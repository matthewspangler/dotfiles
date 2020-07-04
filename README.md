My dotfiles for AwesomeWM, vim, etc.

I have tested and used these dotfiles on a minimal, stable Debian buster installation.

## Dependencies:
* Window Manager: awesome (window manager)
* Terminal: lxterminal
* CLI shell: zsh
* Theming: pywal, wpgtk
* File Manager: thunar
* Settings: xsettingsd, lxappearance
* Editor: vim
* Programming: ctags, python3, mono
* Productivity: tmux
* Composite manager: compton
* Utility: xscreensaver, pasystray
* Fonts: fonts-powerline, fonts-roboto
* Networking: network-manager-gnome, network-manager-openvpn-gnome
* Icons: papirus-icon-theme
* Other: NordVPN CLI (https://nordvpn.com/download/)

My vimrc depends on YouCompleteMe, which needs manually compiled.

## How to install the dotfiles:
Clone this repository, navigate to the downloaded folder, and run the ./install script.

## Other info:
I am currently working on an Ansible playbook that will set up and configure all the dependencies.

## Screenshot:

![Alt text](screenshot.png?raw=true "Screenshot")
