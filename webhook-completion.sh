#!/usr/bin/env bash

# * Variables

WEBHOOK_FOLDER_NAME=".webhook"
WEBHOOK_FOLDER=$HOME/$WEBHOOK_FOLDER_NAME
DEVICES_FILE=$WEBHOOK_FOLDER/devices

# * Script

if [ ! -f "$DEVICES_FILE" ]; then # If devices file doesn't exist
    brecho "Devices file doesn't exist!"
    echo "Create the file" $DEVICES_FILE "with the DEVICES variable"
    return 1
fi

source $DEVICES_FILE # LOAD devices

if [ -z "$DEVICES" ]; then # If variable it's empty
    brecho "No DEVICES configured in the configuration file"
    echo "Write your DEVICES as a bash variable inside" $DEVICES_FILE
    echo "E.G."
    echo "DEVICES=\"smartDevice smartLamp smartPlug\""
    return 2
fi

complete -W "$DEVICES" webhook # Run command for autocomplete
