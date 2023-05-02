import argparse
import subprocess
import platform
import distro
import os
import sys
import re

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

def setup_galaxy_collections():
    title("Install galaxy powered collections")
    subprocess.call("ansible-galaxy collection install -r ~/dotfiles/galaxy/requirements.yml", shell=True)

def setup_galaxy_roles(password):
    pass_string = ""
    if password:
        pass_string = f"ansible_become_pass={password}"
    title("Install galaxy powered roles")
    subprocess.call(f"ansible-galaxy install --roles-path=~/dotfiles/galaxy/roles -r ~/dotfiles/galaxy/requirements.yml", shell=True)
    subprocess.call(f"ansible-playbook ~/dotfiles/galaxy/main.yml -e \"localuser=$USER {pass_string}\"", shell=True)

def setup_playbooks(password):
    pass_string = ""
    if password:
        pass_string = f"ansible_become_pass={password}"
    title("Run dotfiles ansible installer")
    subprocess.call(f"ansible-playbook ~/dotfiles/playbooks/arch_installer.yml --extra-vars=\"localuser=$USER {pass_string}\" -vvv", shell=True)

def get_os():
    # Retrieve and return OS + distribution. This will allow the script to run on Mac OS, Debian, or Arch:
    system = platform.system()
    release = platform.release()
    distro = distro.id()
    return system, release, distro

def setup_darwin(admin_pass):
    # Check if homebrew exists, install it if not. Then install Ansible with homebrew:
    if not os.path.exists("/usr/local/bin/brew"):
        subprocess.call("/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)\"", shell=True)
    subprocess.call("brew install ansible", shell=True)

def setup_arch(admin_pass):
    subprocess.call(f"echo {admin_pass} | sudo -S pacman -S ansible", shell=True)

def setup_debian(admin_pass):
    subprocess.call(f"echo {admin_pass} | sudo -S apt install ansible", shell=True)

def setup_dependencies(distro, admin_pass):
    if 'darwin' in distro:
        setup_darwin(admin_pass)
    # If Arch Linux:
    elif 'arch' in distro:
        subprocess.call("sudo pacman -S ansible git", shell=True)
    # If Debian Linux:
    elif 'debian' in distro:
        subprocess.call("sudo apt install ansible git", shell=True)
    else:
        sys.exit("Installer does not support this OS/distribution.")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--password", help="Specify user password for running ansible/pacman.")
    parser.add_argument("-v", "--verbosity", help="increase output verbosity")
    args = parser.parse_args()

    # Get OS/distro info
    system, release, distro = get_os()

    if sys.version_info[0] < 3:
        sys.exit("Must be using Python 3")
    
    setup_dependencies(distro, args.password)
    setup_galaxy_collections()
    setup_galaxy_roles(args.password)
    setup_playbooks(args.password)

if __name__ == "__main__":
    main()