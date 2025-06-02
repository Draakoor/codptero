#!/bin/bash
# Allow i386 Architecture
dpkg --add-architecture i386 && \
apt-get update && \
apt-get install wget gnupg2 software-properties-common -y

apt install -y apt-transport-https

mkdir -pm755 /etc/apt/keyrings
wget -O - https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -
wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/noble/winehq-noble.sources

# Update repository 
apt-get update

## Now we will install wine
apt-get install -y --install-recommends winehq-stable winbind
apt-get install -y xvfb

# Install winetricks
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -O /usr/sbin/winetricks
chmod a+x /usr/sbin/winetricks

wine --version
# Configure our wine environment
# winecfg

# Install Mono
#wget -P /mono http://dl.winehq.org/wine/wine-mono/$WINEVER/wine-mono-$WINEVER.msi
#wineboot -u && msiexec /i /mono/wine-mono-$WINEVER.msi
#rm -rf /mono/wine-mono-$WINEVER.msi
# Install .NET
#wineboot -u && winetricks -q dotnet452


# Install vsc++ redistributable
#wineboot -u && xvfb-run winetricks -q vcrun2008
