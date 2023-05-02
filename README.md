# About

My Arch Linux development environment dotfiles orchestrated with GNU Stow and Ansible.

# Installation

1) Clone this repo and all recursive submodules inside your home directory:
```
cd ~
git clone --recurse-submodules https://github.com/matthewspangler/dotfiles
cd ~/dotfiles
```

2) Edit ./playbooks/arch_installer.yml and uncomment roles you'd like to install.

3) Run the installer:
```
chmod a+x ./install.sh
./install.sh
```

4) Run emacs and wait for it to download packages from Elpa and install everything.

5) Tab icons in Emacs won't show until you do: ```M-x all-the-icons-install-fonts```

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
