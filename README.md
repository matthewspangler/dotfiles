# About

My dotfiles + dev environment orchestrated with GNU Stow and Ansible.

# Installation

1) Install Python 3.
2) Download install.py from this repo: ```curl --location --remote-header-name --remote-name https://github.com/matthewspangler/dotfiles/install.py```.
3) Run the installer with your admin password as an argument: ```python3 install.py -p <your password>```.
4) Run Emacs and let it configure itself.
5) Setup tab icons by doing this in Emacs: ```M-x all-the-icons-install-fonts```

# Troubleshooting

If Emacs isn't maximizing in KDE, do this:

Right click window top boarder --> More Actions --> Special Application Settings --> + Add Property --> Obey Geometry Restrictions --> "Force" --> "No"

# How it works

### install.py
This installs git and ansible, clones the repo into '~/dotfiles', and then starts the ansible playbooks. It works on multiple Linux distros and Mac OS.

### install_roles.yml
Uncomment roles in this file install them.

### GNU Stow
GNU Stow is a handy tool that symlinks dotfiles to wherever they belong in your home folder.

## How to add dotfiles or ansible scripts

Steps:
1) Create a role playbook in ```~/dotfiles/playbooks/roles/<role name>/tasks/main.yml```
2) Add ```<role name>``` to ```~/dotfiles/playbooks/install_roles.yml``` so that install.py runs it automatically.
3) Create ```~/dotfiles/home/<dotfile folder name>```, I name the folders based on the app whose dotfiles I am managing.
4) Make the ```<dotfile folder name>``` subdirectory tree structure mirror where you want the dotfiles stored in your user's home directory. Here's an example for emacs: ```~/.emacs.d``` --> ```~/dotfiles/home/emacs/.emacs.d```
5) Use the main.yml playbook you just created to install/unstow/symlink the dotfiles. For example:
```
- name: Symlink emacs dotfiles
  shell: stow --no-folding -d ~/dotfiles/home -t ~/ {{ item }}
  with_items:
    - emacs
```
6) Lastly, run ```python3 install.py```