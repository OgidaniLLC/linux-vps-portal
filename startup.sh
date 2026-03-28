#!/bin/bash
mkdir -p ~/.vnc
echo "${VNC_PW:-vps12345}" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Desktop shortcuts
mkdir -p /root/Desktop
printf '[Desktop Entry]\nName=Help\nExec=xdg-open https://note.com/ogidanillc\nType=Application\nIcon=help-browser\nTerminal=false\n' > /root/Desktop/help.desktop
chmod +x /root/Desktop/help.desktop

if [ -f "/root/.wine/drive_c/Program Files/XMTrading MT5/terminal64.exe" ]; then
    printf '[Desktop Entry]\nName=XMTrading MT5\nExec=wine "/root/.wine/drive_c/Program Files/XMTrading MT5/terminal64.exe"\nType=Application\nIcon=wine\nTerminal=false\n' > /root/Desktop/MT5.desktop
    chmod +x /root/Desktop/MT5.desktop
fi

vncserver :1 -geometry 1280x768 -depth 24 -localhost no &
sleep 3

websockify --web=/usr/share/novnc/ 6080 localhost:5901 &

wait
