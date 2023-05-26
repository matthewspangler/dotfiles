# About

My dotfiles for immutable Linux distros (Silverblue, Kinoite), orchestrated with chezmoi.

# Install:

```
# Create container for dotfile management
distrobox create --image registry.fedoraproject.org/fedora-toolbox:39 dotfiles
# Enter container
distrobox enter dotfiles
# Get correct binary for OS
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
# Init chezmoi repo
chezmoi init https://github.com/$GITHUB_USERNAME/dotfiles.git
```