#!/bin/bash

shopt -s nullglob

for f in /dev/video*; do sudo chown :video "$f"; done
sudo rm -f /etc/sudoers

vncserver -geometry 1024x768 -depth 24 -SecurityTypes None :1
websockify --web=/usr/share/novnc/ 6008 127.0.0.1:5901
