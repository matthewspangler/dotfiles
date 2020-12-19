[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

# xscreensaver &
wal -R
xrdb -merge ~/.Xresources
exec qtile
