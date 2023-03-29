#!/bin/bash

shopt -s nullglob

RESOLUTION=${RESOLUTION:=1600x900}

sudo find /dev -name 'video*' -exec chown :video {} +
sudo rm -f /etc/sudoers

mkdir -p ~/.config/autostart && cp /usr/share/applications/wemeetapp.desktop ~/.config/autostart
mkdir -p ~/.local/share && ln -s /wemeet ~/.local/share/wemeetapp
mkdir ~/.vnc && touch ~/.vnc/passwd && chmod 600 ~/.vnc/passwd
cat << END > ~/.vnc/xstartup
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
eval "$(dbus-launch --sh-syntax --exit-with-session)"
fcitx5 -d
exec openbox-session
END
chmod +x ~/.vnc/xstartup

mkdir -p ~/.config/fcitx5
cd ~/.config/fcitx5
cat << END > profile
[Groups/0]
Name=Default
Default Layout=us
DefaultIM=pinyin

[Groups/0/Items/0]
Name=keyboard-us
Layout=

[Groups/0/Items/1]
Name=pinyin
Layout=

[GroupOrder]
0=Default
END

cd ~
vncserver -geometry ${RESOLUTION} -depth 24 -localhost -SecurityTypes None :1
websockify --web=/usr/share/novnc/ 6008 127.0.0.1:5901
