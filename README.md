My dotfiles, including configuration files for vim and emacs. Although I primarily use Arch Linux, I also sometimes use Emacs on Windows, so I have included steps for installing my dotfiles on both systems.

## How to install the dotfiles:

### Linux:
```
$ git clone https://github.com/matthewspangler/dotfiles
$ cd dotfiles
$ ./install
```

### Windows:
```
$ git clone https://github.com/matthewspangler/dotfiles
$ cd dotfiles
$ export MSYS=winsymlinks:nativestrict
$ ./install
```

## Branches:
* Qtile - includes my dotfiles for the Qtile window manager. I no longer use this Window manager having moved to a combination of EXWM and XFCE.
* AwesomeWM - includes my dotfiles for Awesome window manager. I no longer use this either.
* Master - current, updated dotfiles and EXWM configuration.

## What's included in the master branch:

* .emacs.d - My emacs configuration files. Emacs is my primary code editor, email client, irc client, and organizer. Includes my development environment for Python, C, Lua, and GDScript.
* .vimrc - My vim configuration file. I occassionally use this for code editing, so it includes configuration for C and Python.
* .wl - I use wanderlust in combination with emacs as my email client, and this file includes some setup for my email provider.
* .xinitrc - written for use with EXWM, which can be enabled by uncommenting a line in config.org
* .zshrc - I use oh-my-zsh and the spaceship-prompt theme.
* picom.conf - Composit manager configuration file for using EXWM.
