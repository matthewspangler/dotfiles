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
