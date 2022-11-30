#!/bin/bash

title() {
    local color='\033[1;37m'
    local nc='\033[0m'
    printf "\n${color}$1${nc}\n"
}

archlinux_install () {
  # Don't ask for confirmation, and don't reinstall:
  title "Install ansible"
  sudo pacman -Syy --noconfirm --needed ansible

  title "Install galaxy powered roles"
  ansible-galaxy install --roles-path=~/dotfiles/galaxy/roles -r ~/dotfiles/galaxy/requirements.yml
  ansible-playbook -K ~/dotfiles/galaxy/main.yml -e "localuser=$USER"

  title "Run dotfiles ansible installer"
  # I use two different user variables here because of ansible-role-zsh requirements:
  ansible-playbook ~/dotfiles/playbooks/arch_installer.yml --extra-vars="localuser=$USER" -vvv
}

if [ -f "/etc/arch-release" ]; then
  archlinux_install
else
  echo "Currently the installer only works for Arch Linux."
fi
