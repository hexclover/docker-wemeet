#!/bin/bash

vncserver -geometry 1024x768 -depth 24 -SecurityTypes None :1
websockify --web=/usr/share/novnc/ 6008 127.0.0.1:5901
