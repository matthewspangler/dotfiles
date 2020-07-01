[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

wal -R
xrdb -merge ~/.Xresources
exec awesome
