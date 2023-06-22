#!/bin/bash
echo "Checking for updates..."

#If /home/container/updater does not exist, create folder
if [ ! -d /home/container/updater ]; then
	mkdir /home/container/updater
fi
#Downnload the latest version of the server updater depending on architecture to /home/container/Server/updater 
if [ "$(uname -m)" == "x86_64" ]; then
echo "64 bit system detected, downloading 64 bit updater"
wget https://github.com/mxve/plutonium-updater.rs/releases/latest/download/plutonium-updater-x86_64-unknown-linux-gnu.tar.gz -O /home/container/updater/latestupdater.tar.gz -q --show-progress
else
echo "ARM system detected, downloading ARM updater"
echo "ARM is currently not supported, please use a 64 bit system"
exit 1
#wget https://github.com/mxve/plutonium-updater.rs/releases/latest/download/plutonium-updater-arm64-unknown-linux-gnu.tar.gz -O /home/container/updater/latestupdater.tar.gz -q --show-progress
fi
#Extract the updater to /home/container/updater/ overwriting any existing files
tar -xvf /home/container/updater/latestupdater.tar.gz -C /home/container/updater/
#Remove the archive from /home/container/updater
rm /home/container/updater/latestupdater.tar.gz
#Run the updater
chmod +x /home/container/updater/plutonium-updater
echo "Updater found, running updater"
/home/container/updater/plutonium-updater -d /home/container/Plutonium

