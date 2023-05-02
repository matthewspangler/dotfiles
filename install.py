GITHUB_URL = "https://github.com/"
GIT_REPO = "matthewspangler/dotfiles"

# Built-in python libraries
import argparse
import subprocess
import platform
import os
import sys
import re
# Check python version
if sys.version_info[0] < 3:
    sys.exit("Must be using Python 3")
else:
    # pip install requirements file from remote repo:
    subprocess.call(f"pip3 install -r https://raw.githubusercontent.com/{GIT_REPO}/master/requirements.txt", shell=True)
# Pypi python libraries below
from typing import Any
import distro
import loguru

class DistroSetup:
    def __init__(self, admin_pass):
        self.admin_pass = admin_pass
        self.run()

    def get_repo(self):
        title("Clone dotfiles")
        subprocess.call(f"git clone --recurse-submodules {GITHUB_URL}{GIT_REPO} ~/dotfiles", shell=True)

    def get_ansible(self, admin_pass):
        # Override in distro child class
        pass

    def get_collections(self, admin_pass):
        title("Install galaxy powered collections")
        subprocess.call("ansible-galaxy collection install -r ~/dotfiles/galaxy/requirements.yml", shell=True)

    def get_roles(self, admin_pass):
        pass_string = ""
        if admin_pass:
            pass_string = f"ansible_become_pass={admin_pass}"
        title("Install galaxy powered roles")
        subprocess.call(f"ansible-galaxy install --roles-path=~/dotfiles/galaxy/roles -r ~/dotfiles/galaxy/requirements.yml", shell=True)
        subprocess.call(f"ansible-playbook ~/dotfiles/galaxy/main.yml -e \"localuser=$USER {pass_string}\"", shell=True)

    def run_playbooks(self, admin_pass):
        pass_string = ""
        if admin_pass:
            pass_string = f"ansible_become_pass={admin_pass}"
        title("Run dotfiles ansible installer")
        subprocess.call(f"ansible-playbook ~/dotfiles/playbooks/arch_installer.yml --extra-vars=\"localuser=$USER {pass_string}\" -vvv", shell=True)

    def run(self):
        self.get_ansible(self.admin_pass)
        self.get_repo()
        self.get_collections(self.admin_pass)
        self.get_roles(self.admin_pass)
        self.run_playbooks(self.admin_pass)


class Darwin(DistroSetup):
    def __init__(self, admin_pass):
        # Init super
        super().__init__(admin_pass)
    
    def get_ansible(self, admin_pass):
        # Check if homebrew exists, install it if not. Then install Ansible with homebrew:
        if not os.path.exists("/usr/local/bin/brew"):
            subprocess.call("/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)\"", shell=True)
        subprocess.call("brew install ansible git", shell=True)


class Arch(DistroSetup):
    def __init__(self, admin_pass):
        super().__init__(admin_pass)

    def get_ansible(self, admin_pass):
        subprocess.call(f"echo {admin_pass} | sudo -S pacman -S ansible git", shell=True)

class Debian(DistroSetup):
    def __init__(self, admin_pass):
        super().__init__(admin_pass)

    def get_ansible(self, admin_pass):
        subprocess.call(f"echo {admin_pass} | sudo -S apt install ansible git", shell=True)


def show_help():
    # Display Help
    print("Installs dotfiles.")
    print()
    print("Syntax: install.py [-p|h]")
    print("options:")
    print("p     Specify user password for running ansible/pacman.")
    print("h     Print this Help.")
    print()

def title(text):
    color='\033[1;37m'
    nc='\033[0m'
    print(f"\n{color}{text}{nc}\n")

def get_os():
    # Retrieve and return OS + distribution. This will allow the script to run on Mac OS, Debian, or Arch:
    system = platform.system()
    release = platform.release()
    distro = distro.id()
    return system, release, distro

def install(distro, admin_pass):
    # Get+init class dynamically by matching distro string with class name:
    distro_class = globals()[distro.capitalize()]
    # __init__ function calls run() automatically, which runs the install process.
    distro_class(admin_pass)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--password", help="Specify user password for running ansible/pacman.")
    parser.add_argument("-v", "--verbosity", help="increase output verbosity")
    args = parser.parse_args()

    # Get OS/distro info
    _, _, distro = get_os()
    
    install(distro, args.password)

if __name__ == "__main__":
    main()