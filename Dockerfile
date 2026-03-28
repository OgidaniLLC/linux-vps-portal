FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV VNC_PW=vps12345
ENV TZ=Asia/Tokyo

RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    novnc \
    websockify \
    wget \
    gnupg2 \
    software-properties-common \
    cabextract \
    xdg-utils \
    fonts-noto-cjk \
    fonts-ipafont \
    p7zip-full \
    && dpkg --add-architecture i386 \
    && mkdir -pm755 /etc/apt/keyrings \
    && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources \
    && apt-get update \
    && apt-get install -y --install-recommends winehq-staging \
    && add-apt-repository -y ppa:xtradeb/apps \
    && apt-get update \
    && apt-get install -y --no-install-recommends chromium \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Wine Windows 10 mode + Japanese fonts
RUN mkdir -p /root/.wine && \
    WINEDLLOVERRIDES="mscoree,mshtml=" DISPLAY=:1 wineboot --init || true && \
    wine reg add "HKEY_CURRENT_USER\Software\Wine" /v Version /t REG_SZ /d "win10" /f || true && \
    mkdir -p /root/.wine/drive_c/windows/Fonts && \
    cp /usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc /root/.wine/drive_c/windows/Fonts/ && \
    printf 'REGEDIT4\n\n[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Fonts]\n"Noto Sans CJK JP Regular (TrueType)"="NotoSansCJK-Regular.ttc"\n\n[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\FontSubstitutes]\n"MS UI Gothic"="Noto Sans CJK JP Regular"\n"MS Gothic"="Noto Sans CJK JP Regular"\n"MS PGothic"="Noto Sans CJK JP Regular"\n"Yu Gothic"="Noto Sans CJK JP Regular"\n"Meiryo"="Noto Sans CJK JP Regular"\n' > /tmp/jp-fonts.reg && \
    wine regedit /tmp/jp-fonts.reg || true

# winetricks fakejapanese for Japanese font support
RUN wget -O /usr/local/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x /usr/local/bin/winetricks && \
    DISPLAY=:1 winetricks -q fakejapanese || true

# Desktop shortcuts
RUN mkdir -p /root/Desktop && \
    printf '[Desktop Entry]\nName=ヘルプ・使い方\nExec=xdg-open https://note.com/ogidanillc\nType=Application\nIcon=help-browser\nTerminal=false\n' > /root/Desktop/help.desktop && \
    chmod +x /root/Desktop/help.desktop

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

EXPOSE 6080

CMD ["/startup.sh"]
