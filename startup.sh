#!/bin/bash
mkdir -p ~/.vnc
echo "${VNC_PW:-vps12345}" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Japanese fonts setup
mkdir -p /root/.wine/drive_c/windows/Fonts
for font in /usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc /usr/share/fonts/truetype/ipafont-gothic/ipag.ttf; do
    fname=$(basename "$font")
    if [ -f "$font" ] && [ ! -f "/root/.wine/drive_c/windows/Fonts/$fname" ]; then
        cp "$font" /root/.wine/drive_c/windows/Fonts/
    fi
done

# Desktop shortcuts
mkdir -p /root/Desktop
printf '[Desktop Entry]\nName=Help\nExec=env DISPLAY=:1 chromium --no-sandbox https://note.com/fx_systradeea/n/nb5cf4ed8b087\nType=Application\nIcon=help-browser\nTerminal=false\n' > /root/Desktop/help.desktop
chmod +x /root/Desktop/help.desktop

find "/root/.wine/drive_c/Program Files" "/root/.wine/drive_c/Program Files (x86)" -name "terminal64.exe" -o -name "terminal.exe" 2>/dev/null | while read exe; do
    dir=$(dirname "$exe")
    name=$(basename "$dir")
    if ! ls /root/Desktop/ | grep -qi "$name"; then
        printf '[Desktop Entry]\nName=%s\nExec=wine "%s"\nType=Application\nIcon=wine\nTerminal=false\n' "$name" "$exe" > "/root/Desktop/${name}.desktop"
        chmod +x "/root/Desktop/${name}.desktop"
    fi
done

xdg-settings set default-web-browser chromium.desktop 2>/dev/null || true
if grep -qr "exo-open --launch WebBrowser" /root/.config/xfce4/panel/ 2>/dev/null; then
    for f in /root/.config/xfce4/panel/launcher-*/; do
        find "$f" -name "*.desktop" -exec sed -i "s|Exec=exo-open --launch WebBrowser|Exec=chromium --no-sandbox|g" {} \;
    done
fi

vncserver :1 -geometry 1280x768 -depth 24 -localhost no &
sleep 3

websockify --web=/usr/share/novnc/ 6080 localhost:5901 &

wait
