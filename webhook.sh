#!/usr/bin/env sh

# * Variables

WEBHOOK_FOLDER_NAME=".webhook"
WEBHOOK_FOLDER=$HOME/$WEBHOOK_FOLDER_NAME
CONFIG_FILE=$WEBHOOK_FOLDER/config

# * Functions

generateDelayRequest() { # Return the request for a delayed call, input parameters are message, mins, key
    REQUEST="https://script.google.com/macros/s/AKfycbx0hWSQlfMuJ47xgYqHO5O2fAfRXb5p8e66in8A7mmFmHpEATU/exec?action=$1&mins=$2&key=$3"
}

generateRequest() {
    REQUEST="https://maker.ifttt.com/trigger/$1/with/key/$2"
}

generateMessage() {
    MESSAGE="turn_$1_$2"
}

checkKey() {
    if [ ! -f "$CONFIG_FILE" ]; then
        brecho "Config file doesn't exist!"
        echo "Create the file $CONFIG_FILE with the KEY variable"
        exit 3
    fi

    # shellcheck disable=SC1090
    . "$CONFIG_FILE"       # Sourcing the key file
    if [ -z "$KEY" ]; then # Check if the KEY parameter exist
        brecho "No KEY configured in the configuration file"
        echo "Write your KEY as a bash variable inside $CONFIG_FILE"
        exit 4
    fi
}

brecho() { # Bold Red echo
    # shellcheck disable=SC2059
    printf "${F_BOLD}${C_RED}$1${C_NO_COLOR}\n"
}

gecho() { # Green echo
    # shellcheck disable=SC2059
    printf "${C_GREEN}$1${C_NO_COLOR}\n"
}

makeWebRequest() { # Make the web request
    FILENAME="$WEBHOOK_FOLDER/requestResult"

    wget -O "$FILENAME" "$REQUEST" >/dev/null 2>&1 # Make web request and suppress output
    requestResult=$(cat "$FILENAME")               # Print request result on a variable
    rm "$FILENAME"                                 # Remove request result

    if [ -z "$requestResult" ]; then # if request result it's empty
        brecho "ERROR firing the event: Invalid KEY"
        exit 5
    fi
    echo "$requestResult"
    exit 0
}

# * Script

if [ -z "$1" ]; then # Check if the DEVICE parameter exist
    brecho "No DEVICE provided"
    echo "Usage: webhook.sh [DEVICE] [0/1] optional[DELAY]"
    exit 1
elif [ -z "$2" ]; then # Check turn status
    brecho "No action provided"
    echo "Usage: webhook.sh [DEVICE] [0/1] optional[DELAY]"
    exit 2
fi
checkKey

# MESSAGE GENERATION
COMMAND=$2
DEVICE=$1
if [ "$COMMAND" = "1" ]; then
    COMMAND="on"
elif [ "$COMMAND" = "0" ]; then
    COMMAND="off"
else
    brecho "Wrong command provided"
    echo "Valid values are: 0 ; 1"
    exit 1
fi
generateMessage $COMMAND "$DEVICE"

if [ -z "$3" ]; then # Check if delay parameter exist
    generateRequest "$MESSAGE" "$KEY"
else
    generateDelayRequest "$MESSAGE" "$3" "$KEY"
fi

gecho "Turning $COMMAND $DEVICE with key $KEY"
makeWebRequest
