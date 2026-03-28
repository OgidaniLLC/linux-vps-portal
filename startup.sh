#!/bin/bash
mkdir -p ~/.vnc
echo "${VNC_PW:-vps12345}" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

vncserver :1 -geometry 1280x768 -depth 24 -localhost no &
sleep 3

websockify --web=/usr/share/novnc/ 6080 localhost:5901 &

wait
