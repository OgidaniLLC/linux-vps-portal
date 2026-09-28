#!/bin/bash
mkdir -p ~/.vnc

# 2026-09-29: VNC_PW未設定時に固定パスワード(vps12345)へ静かにフォールバック
# していたのを廃止。同じ値が全ユーザー共通のデフォルトとしてリポジトリに
# 公開されており、VNCポートが外部到達可能な環境と組み合わさると不正アクセス
# リスクになるため、未設定なら起動を止めて気づけるようにする。
if [ -z "${VNC_PW:-}" ]; then
    echo "エラー: 環境変数 VNC_PW が設定されていません。" >&2
    echo "  .env ファイルに VNC_PW=<推測困難なパスワード> を設定してください" \
         "（README.md のクイックスタート手順を参照）。" >&2
    exit 1
fi
echo "${VNC_PW}" | vncpasswd -f > ~/.vnc/passwd
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

# VNC(:1) は既に動いていなければ起動。古いロック残骸を掃除してから立てる。
# (コンテナ再起動やプロセス残骸での二重起動を防止。二重起動するとnoVNCに接続できなくなる)
if ! pgrep -f "Xtigervnc :1" > /dev/null 2>&1; then
    vncserver -kill :1 2>/dev/null || true
    rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 2>/dev/null || true
    vncserver :1 -geometry 1280x768 -depth 24 -localhost no &
    sleep 3
fi

# websockify(6080) は1本だけ。二重起動を防止(親死亡で子だけ残りリスナー喪失する事故も防ぐ)。
if ! pgrep -f "websockify.*6080" > /dev/null 2>&1; then
    websockify --web=/usr/share/novnc/ 6080 localhost:5901 &
fi

wait
