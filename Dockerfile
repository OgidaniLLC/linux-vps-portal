FROM consol/ubuntu-xfce-vnc:latest

USER root

# Wine install
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        wine \
        wine32 \
        wine64 \
        winetricks \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER 1000
