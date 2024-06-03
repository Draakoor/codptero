#!/bin/bash
cd /home/container

# Output Current Wine Version
wine --version

#Ensure /home/container is owned by container
sudo chown -R container:container /home/container

# If .wine directory doesn't exist, initialize
if [ ! -d /home/container/.wine ]; 
then echo "Wineprefix not found, initialiizing wine" && winecfg && /usr/sbin/winetricks
echo "Configured Succesfully"
fi;

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}
