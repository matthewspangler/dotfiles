CONFIG_FILES=$(find $HOME/.config/swhkd -type f)
swhkd -c "$CONFIG_FILES"
pkexec swhkd