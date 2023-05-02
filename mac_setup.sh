### This script unstows dotfiles. Later I'd like to make the ansible installer work for mac so it can setup dependencies.

defaults write com.apple.finder AppleShowAllFiles YES

# Quelpa install fails because Mac OS tar works differently than GNU tar
brew install gnu-tar

brew install libvterm

stow --no-folding -d ~/dotfiles/home -t ~/ emacs vim