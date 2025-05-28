#!/bin/bash
set -e

cd /home/container

echo "[INFO] Running on Debian $(cat /etc/debian_version)"
echo "[INFO] Current timezone: $(cat /etc/timezone)"
echo "[INFO] Wine version: $(wine --version)"

# Determine internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2); exit}')
export INTERNAL_IP

# Launch Xvfb
echo "[INFO] Starting Xvfb on DISPLAY=:0 (${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}x${DISPLAY_DEPTH})"
mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix
Xvfb :0 -screen 0 ${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}x${DISPLAY_DEPTH} &
export DISPLAY=:0

# Ensure WINEPREFIX exists
export WINEPREFIX=/home/container/.wine
mkdir -p "$WINEPREFIX"
export WINEDEBUG=fixme-all

# Optional Wine Gecko installation
if [[ "$WINETRICKS_RUN" =~ gecko ]]; then
    echo "[INFO] Installing Wine Gecko..."
    WINETRICKS_RUN=${WINETRICKS_RUN//gecko/}

    [[ ! -f "$WINEPREFIX/gecko_x86.msi" ]] && \
        wget -q -O "$WINEPREFIX/gecko_x86.msi" http://dl.winehq.org/wine/wine-gecko/2.47.4/wine_gecko-2.47.4-x86.msi
    [[ ! -f "$WINEPREFIX/gecko_x86_64.msi" ]] && \
        wget -q -O "$WINEPREFIX/gecko_x86_64.msi" http://dl.winehq.org/wine/wine-gecko/2.47.4/wine_gecko-2.47.4-x86_64.msi

    wine msiexec /i "$WINEPREFIX/gecko_x86.msi" /qn /norestart || true
    wine msiexec /i "$WINEPREFIX/gecko_x86_64.msi" /qn /norestart || true
fi

# Optional Wine Mono installation
if [[ "$WINETRICKS_RUN" =~ mono ]]; then
    echo "[INFO] Installing Wine Mono..."
    WINETRICKS_RUN=${WINETRICKS_RUN//mono/}

    [[ ! -f "$WINEPREFIX/mono.msi" ]] && \
        wget -q -O "$WINEPREFIX/mono.msi" https://dl.winehq.org/wine/wine-mono/9.1.0/wine-mono-9.1.0-x86.msi

    wine msiexec /i "$WINEPREFIX/mono.msi" /qn /norestart || true
fi

# Install any additional Winetricks components
for trick in $WINETRICKS_RUN; do
    echo "[INFO] Installing winetrick: $trick"
    winetricks -q "$trick"
done

# Parse and execute STARTUP template
MODIFIED_STARTUP=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo "[INFO] Launching: $MODIFIED_STARTUP"
eval "$MODIFIED_STARTUP"
