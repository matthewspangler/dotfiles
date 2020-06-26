# This is my automated installation / setup of Debian with all my software and dotfiles


# REQUIREMENTS: debian minimal install, no DE or WM. Internet connection.

# This is where it all starts:
cd ~

# Log in as root, apt update, install git for dotfiles
su
apt update
apt install git

# Window manager of choice + usability tools
apt install awesome xinit rofi vim vim-nox vim-python

# Terminal emulator of choice
apt install rxvt-unicode

# File manager(s) of choice
apt install ranger pcmanfm

# Web browser of choice
apt install firefox-esr

# exit root
exit

# Get my dotfiles (puts them in ~/dotfiles) & use dotbot to install them in proper locations!
git clone https://github.com/matthewspangler/dotfiles && cd dotfiles && ./install

# rofi

# .vimrc

# .xinitrc

# .Xresources

# pywall

# run :PlugInstall in vim
vim --headless +PlugInstall +qall

# vim's YouCompleteMe auto-completion

# enter root for more software installs
su

# .weechat
apt install weechat

# python
apt install python3 python3-pip

# General software I use
apt install keepassxc

# Development tools
apt install codeblocks tiled

# Art & Music production
apt install grafx2 milkytracker
