[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

wal -R
xrdb -merge ~/.Xresources
~/Scripts/autostart.sh
picom -c &
exec qtile
