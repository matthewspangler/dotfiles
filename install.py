HELP_MESSAGE = """
Installs dotfiles.
Syntax: install.py [-p|h]
options:
p     Specify user password for running ansible/pacman.
h     Print this Help.
"""
GITHUB_URL = "https://github.com/"
GIT_REPO = "matthewspangler/dotfiles"

# Built-in libraries:
import argparse
import subprocess
import platform
import os
import sys
import re
# Check python version:
if sys.version_info[0] < 3:
    sys.exit("Must be using Python 3")
else:
    # pip install requirements file from remote repo:
    subprocess.call(f"pip3 install -r https://raw.githubusercontent.com/{GIT_REPO}/main/requirements.txt", shell=True)
# Pypi libraries:
from typing import Any
import distro
from loguru import logger

# Process arguments
parser = argparse.ArgumentParser()
parser.add_argument("-p", "--password", help="Specify user password for running ansible/pacman.")
parser.add_argument("-v", "--verbosity", help="increase output verbosity")
parser.add_argument("-t", "--tags", help="Specify ansible tags to run.")
args = parser.parse_args()


"""
Distro-specific setup is handled by the DistroSetup class. 
In order for your childclass to be automatically run, 
the class name must match the string obtained from distro.id()
Initializing any DistroSetup class automatically runs the installer steps 
via the DistroSetup.run() function.
"""
class DistroSetup:
    def __init__(self, install_args):
        self.install_args = install_args
        self.admin_pass = install_args.password if install_args.password else None
        self.run()

    def get_repo(self):
        title("Clone dotfiles")
        subprocess.call(f"git clone --recurse-submodules {GITHUB_URL}{GIT_REPO} ~/dotfiles", shell=True)

    def get_ansible(self):
        # Override in distro child class
        pass

    def get_collections(self):
        title("Install galaxy powered collections")
        subprocess.call("ansible-galaxy collection install -r ~/dotfiles/galaxy/requirements.yml", shell=True)

    def get_roles(self):
        pass_string = ""
        if self.admin_pass:
            pass_string = f"ansible_become_pass={self.admin_pass}"
        title("Install galaxy powered roles")
        subprocess.call(f"ansible-galaxy install --roles-path=~/dotfiles/galaxy/roles -r ~/dotfiles/galaxy/requirements.yml", shell=True)
        subprocess.call(f"ansible-playbook ~/dotfiles/galaxy/main.yml -e \"localuser=$USER {pass_string}\"", shell=True)

    def run_playbooks(self):
        pass_string = ""
        if self.admin_pass:
            pass_string = f"ansible_become_pass={self.admin_pass}"
        tags_string = ""
        if self.install_args.tags:
            tags_string = f'--tags="{self.install_args.tags}"'
        title("Run dotfiles ansible installer")
        subprocess.call(f"ansible-playbook ~/dotfiles/playbooks/install_playbook.yml --extra-vars=\"localuser=$USER {pass_string}\" -vvv", shell=True)

    def run(self):
        logger.info(f'Running the {self.__class__} class install process.')
        self.get_ansible()
        self.get_repo()
        self.get_collections()
        self.get_roles()
        self.run_playbooks()


class Darwin(DistroSetup):
    def __init__(self, install_args):
        # Init super
        super().__init__(install_args)
    
    def get_ansible(self):
        hb_install = """
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh
        echo "{} yes" | /bin/bash -c "./install.sh"
        """.format(self.admin_pass)

        # Check if homebrew exists, install it if not. Then install Ansible with homebrew:
        if not os.path.exists("/usr/local/bin/brew"):
            subprocess.check_output(hb_install, shell=True)
        subprocess.call("brew install ansible git", shell=True)


class Debian(DistroSetup):
    def __init__(self, install_args):
        super().__init__(install_args)

    def get_ansible(self):
        subprocess.call(f"echo {self.admin_pass} | sudo -S apt install ansible git", shell=True)

class Arch(DistroSetup):
    def __init__(self, install_args):
        super().__init__(install_args)

    def get_ansible(self):
        subprocess.call(f"echo {self.admin_pass} | sudo -S pacman -S ansible git", shell=True)
        
class Endeavouros(Arch):
    def __init__(self, install_args):
        super().__init__(install_args)
        

class Manjaro(Arch):
    def __init__(self, install_args):
        super().__init__(install_args)


def show_help():
    print(HELP_MESSAGE)

def title(text):
    color='\033[1;37m'
    nc='\033[0m'
    print(f"\n{color}{text}{nc}\n")

def get_os():
    # Retrieve and return OS + distribution. This will allow the script to run on Mac OS, Debian, or Arch:
    system = platform.system()
    release = platform.release()
    dist = distro.id()
    return system, release, dist

def install(dist, install_args):
    # Find and init class dynamically by matching distro string with class name:
    distro_class = globals()[dist.capitalize()]
    # __init__ function calls run() automatically, which runs the install process.
    distro_class(install_args)

def main():
    # Get OS/distro info
    _, _, dist = get_os()
    
    install(dist, args)

if __name__ == "__main__":
    main()