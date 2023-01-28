#!/bin/bash

show_help() {
   # Display Help
   echo "Installs dotfiles."
   echo
   echo "Syntax: install.sh [-p|h]"
   echo "options:"
   echo "p     Specify user password for running ansible/pacman."
   echo "h     Print this Help."
   echo
}

while getopts ':p:h:v' option; do
    case "$option" in
        p)
            PASSWORD=$OPTARG
            ;;
        h)
            show_help
            exit;;
        v)
            echo "Verbosity not implemented"
            ;;
    esac
done

shift $((OPTIND-1))

title() {
    local color='\033[1;37m'
    local nc='\033[0m'
    printf "\n${color}$1${nc}\n"
}

setup_ansible() {
    PASS_STRING=""
    if [[ $1 ]];
    then
        PASS_STRING="echo ${1} |"
    fi
    echo $1
    title "Install ansible"
    $PASS_STRING sudo pacman -Syy --noconfirm --needed ansible
}

setup_galaxy_collections() {
    title "Install galaxy powered collections"
    ansible-galaxy collection install -r ~/dotfiles/galaxy/requirements.yml
}

setup_galaxy_roles() {
    PASS_STRING=""
    if [[ $1 ]]
    then
        PASS_STRING="ansible_become_pass=${1}"
    fi
    title "Install galaxy powered roles"
    ansible-galaxy install --roles-path=~/dotfiles/galaxy/roles -r ~/dotfiles/galaxy/requirements.yml
    ansible-playbook ~/dotfiles/galaxy/main.yml -e "localuser=$USER ${PASS_STRING}"
}

setup_playbooks () {
    PASS_STRING=""
    if [[ $1 ]]
    then
        PASS_STRING="ansible_become_pass=${1}"
    fi

    title "Run dotfiles ansible installer"
    # I use two different user variables here because of ansible-role-zsh requirements:
    ansible-playbook ~/dotfiles/playbooks/arch_installer.yml --extra-vars="localuser=$USER ${PASS_STRING}" -vvv
}

if [ -f "/etc/arch-release" ];
then
    setup_ansible $PASSWORD
    setup_galaxy_collections $PASSWORD
    setup_galaxy_roles $PASSWORD
    setup_playbooks $PASSWORD
else
    echo "Currently the installer only works for Arch Linux."
fi
