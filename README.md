# About

My Arch Linux development environment dotfiles orchestrated with GNU Stow and Ansible.

# Installation

1) Install Python 3.
2) Download install.py from this repo: ```curl --location --remote-header-name --remote-name https://github.com/matthewspangler/dotfiles/install.py```.
3) Run the installer with your admin password as an argument: ```python3 install.py -p <your password>```.
4) Run Emacs and let it configure itself.
5) Setup tab icons by doing this in Emacs: ```M-x all-the-icons-install-fonts```

# Troubleshooting

If Emacs isn't maximizing in KDE, do this:

Right click window top boarder --> More Actions --> Special Application Settings --> + Add Property --> Obey Geometry Restrictions --> "Force" --> "No"

# Notable GNU Stow Modules

### core
Important libraries and dependencies for development

### zsh
Zsh + Oh-my-zsh configuration

### bash
My .bashrc

### xonsh
My .xonsh

### vim
My vim development environment

### emacs
My Emacs development environment

### qtile
My configuration files for the Qtile window manager

### plasma
My KDE Plasma configuration files
