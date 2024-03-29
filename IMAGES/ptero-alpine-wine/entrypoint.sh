#!/bin/bash

# Verify wine install
wine --version

# Default the TZ environment variable to UTC.
TZ=${TZ:-UTC}
export TZ

# Make internal Docker IP address available to processes.
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

if [[ $XVFB == 1 ]]
then
    Xvfb :0 -screen 0 ${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}x${DISPLAY_DEPTH} &
fi

# Install necessary to run packages
echo "First launch will throw some errors. Ignore them"

mkdir -p $WINEPREFIX

# Check if wine-gecko required and install it if so
if [[ $WINETRICKS_RUN =~ gecko ]]
then
    echo "Installing Gecko"
    WINETRICKS_RUN=${WINETRICKS_RUN/gecko}
    
    if [ ! -f "$WINEPREFIX/gecko_x86.msi" ]
    then
        wget -q -O $WINEPREFIX/gecko_x86.msi http://dl.winehq.org/wine/wine-gecko/2.47.2/wine_gecko-2.47.2-x86.msi
    fi
    
    if [ ! -f "$WINEPREFIX/gecko_x86_64.msi" ]
    then
        wget -q -O $WINEPREFIX/gecko_x86_64.msi http://dl.winehq.org/wine/wine-gecko/2.47.2/wine_gecko-2.47.2-x86_64.msi
    fi
    
    wine msiexec /i $WINEPREFIX/gecko_x86.msi /qn /quiet /norestart /log $WINEPREFIX/gecko_x86_install.log
    wine msiexec /i $WINEPREFIX/gecko_x86_64.msi /qn /quiet /norestart /log $WINEPREFIX/gecko_x86_64_install.log
fi

# Check if wine-mono required and install it if so
if [[ $WINETRICKS_RUN =~ mono ]]
then
    echo "Installing mono"
    WINETRICKS_RUN=${WINETRICKS_RUN/mono}
    
    if [ ! -f "$WINEPREFIX/mono.msi" ]
    then
        wget -q -O $WINEPREFIX/mono.msi https://dl.winehq.org/wine/wine-mono/7.1.1/wine-mono-7.1.1-x86.msi
    fi
    
    wine msiexec /i $WINEPREFIX/mono.msi /qn /quiet /norestart /log $WINEPREFIX/mono_install.log
fi

# List and install other packages
for trick in $WINETRICKS_RUN
do
    echo "Installing $trick"
    winetricks -q $trick
done

# If .wine directory doesn't exist, copy backup
if [ ! -d /home/container/.wine ]; 
then echo "Wineprefix not found, initialiizing wine" && winecfg && /usr/sbin/winetricks
echo "Configured Succesfully"
fi;

# Switch to the container's working directory
cd /home/container || exit 1

# Replace Startup Variables
MODIFIED_STARTUP=$(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}