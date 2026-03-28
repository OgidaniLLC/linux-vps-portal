FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV VNC_PW=vps12345

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
    && dpkg --add-architecture i386 \
    && mkdir -pm755 /etc/apt/keyrings \
    && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources \
    && apt-get update \
    && apt-get install -y --install-recommends winehq-staging \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Wine Windows 10 mode
RUN mkdir -p /root/.wine && \
    WINEDLLOVERRIDES="mscoree,mshtml=" DISPLAY=:1 wineboot --init || true && \
    wine reg add "HKEY_CURRENT_USER\Software\Wine" /v Version /t REG_SZ /d "win10" /f || true

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

EXPOSE 6080

CMD ["/startup.sh"]
