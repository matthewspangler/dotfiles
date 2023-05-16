CONFIG_FILES=$(find $HOME/.config/swhkd/ -type f)
pkexec swhkd -c "$CONFIG_FILES"
