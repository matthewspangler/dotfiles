CONFIG_FILES=$(find $home/.config/swhkd -type f)
swhkd -c $CONFIG_FILES
pkexec swhkd