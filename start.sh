#!/bin/bash

shopt -s nullglob

RESOLUTION=${RESOLUTION:=1280x800}

sudo find /dev -name 'video*' -exec chown :video {} +
sudo rm -f /etc/sudoers

vncserver -geometry ${RESOLUTION} -depth 24 -localhost -SecurityTypes None :1
websockify --web=/usr/share/novnc/ 6008 127.0.0.1:5901
