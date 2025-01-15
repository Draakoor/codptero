#!/bin/bash

# this is really only necessary outside of docker, but I'll leave this here
kill_subshells_and_exit() {
    echo \n "Interrupt caught! Killing all subshells."
    # Kill all subprocesses started by the script
    pkill -P $$
    pkill -f wine
    exit 0
}

trap 'kill_subshells_and_exit' SIGINT
trap 'kill_subshells_and_exit' SIGTERM

### Usage function for displaying help and instructions
usage() {
    echo "Usage: $0 GAME_DIR"
    echo
    echo "Run the HMW Dedicated Server (on linux) with specified configuration."
    echo
    echo "REQUIRED:"
    echo "  GAME_DIR   Path to the MWR (2017) game files directory."
    echo
    echo "Environment Variables:"
    echo "  SERVER_NAME      Name displayed in logs (default: HMW_Dedicated_Server)."
    echo "  CFG              Server config file (default: server_default.cfg)."
    echo "  PORT             UDP port for server (default: 27016)."
    echo "  RESTART_ON_EXIT  Set to 1 to automatically restart server on exit (default: 0)."
    echo
    echo "Examples:"
    echo "  $0 /path/to/game Run server in the specified game directory."
    echo
    exit 1
}

GAME_DIR="$1"
SERVER_NAME="${SERVER_NAME:-HMW_Dedicated_Server}"
CFG="${CFG:-server_default.cfg}"
PORT="${PORT:-27016}"
PROTON_PATH="${PROTON_PATH:-$HOME/.steam/root/compatibilitytools.d/proton-ge-custom}"
PREFIX_PATH="${PREFIX_PATH:-$HOME/hmw/hmw_server_pfx}"
RESTART_ON_EXIT="${RESTART_ON_EXIT:-0}"

# Display usage if help flag is used or no argument is given
if [[ "$1" == "-h" || "$1" == "--help" || -z "$GAME_DIR" ]]; then
    usage
    exit 1
fi

### COMMENT THIS SECTION OUT IF YOU'RE NOT USING DOCKER
### This part of the script sets up an VNC Server and dummy display for the docker container.
export DISPLAY=:0
Xvfb :0 -screen 0 1024x768x16 > xvfb.log 2>&1 &
echo "X11 Virtual Framebuffer Started on Display $DISPLAY"
# x11vnc -passwd hmw -display :0 -N -forever &
x11vnc -nopw -display :0 -N -forever > x11vnc.log 2>&1 &
echo "X11VNC Server Started and Listening on: 5900"
###
###

echo "[$(date --rfc-3339=s)]::[INFO]: Server: $SERVER_NAME - Config: $CFG - UDP Port: $PORT"
echo "[$(date --rfc-3339=s)]::[INFO]: To shut down the server, interrupt this script (Ctrl+C)!"
echo "[$(date --rfc-3339=s)]::[INFO]: Starting server..."

# check we have linux exe or exit
SOURCE_FILE="hmw-mod_proton.exe"
DESTINATION="$GAME_DIR/hmw-mod_proton.exe"
# Check if the file exists in the destination
if [ ! -f "$DESTINATION" ]; then
    echo "[$(date --rfc-3339=s)]::[INFO]: Attempting to copy linux binary to game files directory..."
    cp ./"$SOURCE_FILE" "$DESTINATION"
fi
if [ ! -f "$DESTINATION" ]; then
    echo "ERROR: Unable to find $SOURCE_FILE"
    echo "If not using this script with docker, then you must have a proton compatible"
    echo "HMW executable either in the same folder as this script named hmw-mod.exe"
    echo "or in the game files named hmw-mod_proton.exe"
    echo "Found existing hmw-mod_proton.exe in game files, using it."
    exit 1
fi

# Ensure the provided config exists or default to server_default.cfg
CONFIG_DIR="/config"
if [ ! -f "$CONFIG_DIR/$CFG" ]; then
    echo "[$(date --rfc-3339=s)]::[WARNING]: Configuration file '$CFG' not found in '$CONFIG_DIR'."
    echo "Using built-in 'server_default.cfg' instead."
    CONFIG_DIR="."
    CFG="server_default.cfg"
fi

cp "$CONFIG_DIR/$CFG" $GAME_DIR/main/$CFG
cp -r /user_scripts $GAME_DIR/

cd $GAME_DIR

while true; do
    GAMEID=0 STORE=steam WINEPREFIX=$PREFIX_PATH PROTONPATH=$PROTON_PATH PROTON_VERB=runinprefix \
        umu-run ./hmw-mod_proton.exe -nosteam -dedicated +exec $CFG +set net_port $PORT +map_rotate

    # Server exited.
    if (( $RESTART_ON_EXIT )); then
        echo "[$(date --rfc-3339=s)]::[INFO]: $SERVER_NAME server closed or dropped. Restarting server."
    else
        echo "[$(date --rfc-3339=s)]::[INFO]: $SERVER_NAME exited and will not restart."
        break
    fi
done

exit 0
