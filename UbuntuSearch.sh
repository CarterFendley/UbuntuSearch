#!/bin/bash

export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export CYAN='\033[0;36m'
export BCYAN='\033[1;36m'
export PURPLE='\033[0;35m'
export GRAY='\033[0;37m'
export MAGENTA='\033[0;37m'
export NC='\033[0m'

# Log file name
ctime=$(date +%s)
mkdir ./logs
export logfile="./logs/log_$ctime.log"
touch "$logfile"

function log() {
    case $2 in
        "raw")
            message="$1";
            noColorMessage="$1"
            ;;
        "error")
            message="[${CYAN}UbuntuSearch${NC}] ${RED}ERROR${NC}: $1 \n"
            noColorMessage="ERROR: $1"
            ;;
        "success")
            message="[${CYAN}UbuntuSearch${NC}] ${GREEN}SUCCESS${NC}: $1 \n"
            noColorMessage="SUCCESS: $1"
            ;;
        "prompt")
            message="[${CYAN}UbuntuSearch${NC}] ${GRAY}PROMPT${NC}: $1 "
            noColorMessage="PROMPT: $1"
            ;;
        "silent")
            echo "SILENT: $1 \n" >> "$logfile"
            return 0
            ;;
        "nobreak")
            message="[${CYAN}UbuntuSearch${NC}] ${PURPLE}LOG${NC}: $1 "
            noColorMessage="LOG: $1"
            ;;
        *)
            message="[${CYAN}UbuntuSearch${NC}] ${PURPLE}LOG${NC}: $1 \n"
            noColorMessage="LOG: $1"
            ;;
    esac
    echo "$noColorMessage" >> "$logfile"
    printf "$message"
}
export -f log

# Prompts the user for Y/n input. Returns 0 if yes 1 if no
#
function yesNo(){
    if [ "$2" = "1" ]; then
        log "$1 [N/y]:" "prompt"
    else
        log "$1 [Y/n]:" "prompt"
    fi

    read answer

    if [ "$answer" = "Y" ] || [  "$answer" = "y" ]; then
        echo "RESPOSE: 0 \n" >> "$logfile"
        return 0
    elif [ "$answer" = "N" ] || [  "$answer" = "n" ]; then
        echo "RESPOSE: 1 \n" >> "$logfile"
        return 1
    elif [ "$answer" = "" ]; then
        echo "RESPOSE: $2 \n" >> "$logfile"
        return $2
    else
        yesNo "$1"
        return $?
    fi
}
export -f yesNo

if [ "$(id -u)" != "0" ]; then
    log "This script requires root privlages to be run." "error"
    exit 1
elif [ "$(lsb_release -si)" != "Ubuntu" ]; then
    log "This program is only designed to work with Ubuntu." "error"
    exit 1
fi

function getOperation() {
    log "Please select one of the operations below"
    log "   [1] Apt Search\n" "raw"
    log "   [2] Log Search\n" "raw"
    log "   [3] Exit\n" "raw"
    log "Input the number of a valid operation:" "prompt"

    read answer
    return $answer
}

while true
do
    getOperation
    op=$?

    case $op in
        1)
            ./modules/appSearch/appSearch.sh
            ;;
        2)
            ./modules/logSearch.sh
            ;;
        3)
            log "Quiting UbuntuSearch" "success"
            exit 0
            ;;
        *)
            log "couldnt find requested task" "error"
            ;;
    esac
    printf "\n"
done
