#!/usr/bin/env bash

# * Variables

WEBHOOK_FOLDER_NAME="webhook"
[ -z "$WEBHOOK_FOLDER" ] && export WEBHOOK_FOLDER=$HOME/.config/$WEBHOOK_FOLDER_NAME
DEVICES_FILE=$WEBHOOK_FOLDER/devices

# * Script

if [ ! -f "$DEVICES_FILE" ]; then # If devices file doesn't exist
    if [ "$1" != "-silent" ]; then
        brecho "Devices file doesn't exist!"
        echo "Create the file $DEVICES_FILE with the DEVICES variable"
    fi
else
    # shellcheck disable=SC1090
    source "$DEVICES_FILE" # LOAD devices
fi

if [ -z "$DEVICES" ]; then # If variable it's empty
    if [ "$1" != "-silent" ]; then
        brecho "No DEVICES configured in the configuration file"
        echo "Write your DEVICES as a bash variable inside $DEVICES_FILE"
        echo "E.G."
        echo "DEVICES=\"smartDevice smartLamp smartPlug\""
    fi
else
    complete -W "$DEVICES" webhook # Run command for autocomplete
fi
