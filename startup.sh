#!/bin/bash
mkdir -p ~/.vnc
echo "${VNC_PW:-vps12345}" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Desktop shortcuts
mkdir -p /root/Desktop
printf '[Desktop Entry]\nName=ヘルプ・使い方\nExec=xdg-open https://note.com/ogidanillc\nType=Application\nIcon=help-browser\nTerminal=false\n' > /root/Desktop/help.desktop
chmod +x /root/Desktop/help.desktop

vncserver :1 -geometry 1280x768 -depth 24 -localhost no &
sleep 3

websockify --web=/usr/share/novnc/ 6080 localhost:5901 &

wait
