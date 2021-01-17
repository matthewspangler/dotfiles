[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

wal -R
xrdb -merge ~/.Xresources
picom -c &

# Here Xfce is kept as default
session=${1:-xfce}

case $session in
    qtile             ) exec qtile && ~/Scripts/autostart.sh;;
    xfce|xfce4        ) exec startxfce4;;
    # No known session, try to run it as command
    *                 ) exec $1;;
esac
