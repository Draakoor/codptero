# === STAGE 1: Builder stage to initialize WINEPREFIX ===
FROM debian:bookworm-slim AS builder

LABEL maintainer="support@craftway.net"
LABEL author="msmcpeake"

ENV DEBIAN_FRONTEND=noninteractive
ENV WINEPREFIX=/home/container/.wine DISPLAY=:0 WINEDEBUG=-all

# Enable i386 and install base tools
RUN dpkg --add-architecture i386 && \
    apt update && apt install -y --no-install-recommends \
    wget gnupg ca-certificates software-properties-common locales xvfb && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

# Add WineHQ repo and install Wine
RUN mkdir -p /etc/apt/keyrings && \
    wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources && \
    apt update && apt install -y --no-install-recommends winehq-stable && \
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create WINEPREFIX path and give ownership to UID 998
RUN mkdir -p /home/container && chown 998:998 /home/container

# Run wineboot as UID 998 to mimic runtime behavior
USER 998
RUN wineboot -u && wineserver -w
USER root

# === STAGE 2: Final runtime image ===
FROM debian:bookworm-slim

LABEL maintainer="support@craftway.net"
LABEL author="msmcpeake"

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/home/container
ENV WINEPREFIX=/home/container/.wine
ENV WINEDLLOVERRIDES=mscoree,mshtml=
ENV DISPLAY=:0
ENV DISPLAY_WIDTH=1024
ENV DISPLAY_HEIGHT=768
ENV DISPLAY_DEPTH=16
ENV XVFB=1
ENV WINEDEBUG=fixme-all

# Install runtime dependencies and tools
RUN dpkg --add-architecture i386 && \
    apt update && apt install -y --no-install-recommends \
    wget curl gnupg ca-certificates software-properties-common \
    locales xvfb x11-utils xauth iproute2 \
    python3-full python3-pip virtualenv \
    cabextract unzip p7zip-full winbind \
    libvulkan1 libnss3 libgtk-3-0 \
    fonts-liberation libasound2 jq coreutils procps \
    libxcomposite1 libxcursor1 libxi6 libxtst6 libxrandr2 libglu1-mesa && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen && \
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add WineHQ repo and install Wine
RUN mkdir -p /etc/apt/keyrings && \
    wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources && \
    apt update && apt install -y --no-install-recommends winehq-stable winbind

# Install winetricks
RUN curl -sSL https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -o /usr/local/bin/winetricks && \
    chmod +x /usr/local/bin/winetricks

# Fix Xvfb socket permissions
RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

# Create non-root user for runtime
RUN useradd -m container

# Copy initialized Wine prefix from builder
COPY --from=builder /home/container/.wine /home/container/.wine

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown -R container:container /home/container

WORKDIR /home/container
USER container

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
