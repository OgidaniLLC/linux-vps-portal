FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV VNC_PW=vps12345
ENV TZ=Asia/Tokyo
ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:ja
ENV LC_ALL=ja_JP.UTF-8

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
    locales \
    && locale-gen ja_JP.UTF-8 \
    && update-locale LANG=ja_JP.UTF-8 \
    && dpkg --add-architecture i386 \
    && mkdir -pm755 /etc/apt/keyrings \
    && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources \
    && apt-get update \
    && apt-get install -y --install-recommends winehq-staging=10.2~jammy-4 wine-staging=10.2~jammy-4 wine-staging-amd64=10.2~jammy-4 wine-staging-i386=10.2~jammy-4 \
    && add-apt-repository -y ppa:xtradeb/apps \
    && apt-get update \
    && apt-get install -y --no-install-recommends chromium \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Wine Windows 10 mode + Japanese locale + fonts
RUN mkdir -p /root/.wine && \
    WINEDLLOVERRIDES="mscoree,mshtml=" LANG=ja_JP.UTF-8 DISPLAY=:1 wineboot --init || true && \
    LANG=ja_JP.UTF-8 wine reg add "HKEY_CURRENT_USER\\Software\\Wine" /v Version /t REG_SZ /d "win10" /f || true && \
    LANG=ja_JP.UTF-8 wine reg add "HKEY_CURRENT_USER\\Control Panel\\International" /v Locale /t REG_SZ /d "00000411" /f || true && \
    LANG=ja_JP.UTF-8 wine reg add "HKEY_CURRENT_USER\\Control Panel\\International" /v LocaleName /t REG_SZ /d "ja-JP" /f || true && \
    LANG=ja_JP.UTF-8 wine reg add "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Nls\\CodePage" /v ACP /t REG_SZ /d "932" /f || true && \
    LANG=ja_JP.UTF-8 wine reg add "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Nls\\CodePage" /v OEMCP /t REG_SZ /d "932" /f || true && \
    LANG=ja_JP.UTF-8 wine reg add "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Nls\\Language" /v InstallLanguage /t REG_SZ /d "0411" /f || true && \
    LANG=ja_JP.UTF-8 wine reg add "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Nls\\Language" /v Default /t REG_SZ /d "0411" /f || true && \
    LANG=ja_JP.UTF-8 wine reg add "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\AeDebug" /v Auto /t REG_SZ /d "0" /f || true && \
    LANG=ja_JP.UTF-8 wine reg add "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\AeDebug" /v Debugger /t REG_SZ /d "" /f || true && \
    mkdir -p /root/.wine/drive_c/windows/Fonts && \
    cp /usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc /root/.wine/drive_c/windows/Fonts/ && \
    LANG=ja_JP.UTF-8 wine reg add "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Fonts" /v "Noto Sans CJK JP Regular (TrueType)" /t REG_SZ /d "NotoSansCJK-Regular.ttc" /f || true && \
    LANG=ja_JP.UTF-8 wine reg add "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\FontSubstitutes" /v "MS UI Gothic" /t REG_SZ /d "Noto Sans CJK JP Regular" /f || true && \
    LANG=ja_JP.UTF-8 wine reg add "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\FontSubstitutes" /v "MS Gothic" /t REG_SZ /d "Noto Sans CJK JP Regular" /f || true && \
    LANG=ja_JP.UTF-8 wine reg add "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\FontSubstitutes" /v "MS PGothic" /t REG_SZ /d "Noto Sans CJK JP Regular" /f || true && \
    LANG=ja_JP.UTF-8 wine reg add "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\FontSubstitutes" /v "MS Shell Dlg" /t REG_SZ /d "Noto Sans CJK JP Regular" /f || true && \
    LANG=ja_JP.UTF-8 wine reg add "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\FontSubstitutes" /v "MS Shell Dlg 2" /t REG_SZ /d "Noto Sans CJK JP Regular" /f || true && \
    LANG=ja_JP.UTF-8 wine reg add "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\FontSubstitutes" /v "Tahoma" /t REG_SZ /d "Noto Sans CJK JP Regular" /f || true

# Replace Wine built-in fonts with IPA Gothic for Japanese support
# Wine's built-in arial/tahoma have no Japanese glyphs, causing garbled text
RUN IPA=/usr/share/fonts/opentype/ipafont-gothic/ipag.ttf && \
    for f in arial.ttf tahoma.ttf tahomabd.ttf times.ttf cour.ttf; do \
        cp $IPA /opt/wine-staging/share/wine/fonts/$f; \
    done

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
