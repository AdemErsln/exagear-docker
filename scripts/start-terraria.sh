#!/bin/bash

# GET FLAGS
START_FILE=$1
CONFIG_FILE=$2
SERVER_IP[0]=$3
SERVER_PORT[0]=$4
MAX_PLAYERS[0]=$5

# CREATE YELLOW COLOR
YELLOW="\033[0;32m"

# GET ARCHITECTURE
ARCHITECTURE=$(uname -i)

# FUNCTION TO CHECK VARIABLES
check_variables()
{
    # SWITCH, IF THE VARIABLE IS GREATER THAN "0" THEN THE SCRIPT IS TERMINATED
    EXIT=0

    # CHECK IF THE VARIABLES ARE EMPTY, IF THEY ARE EMPTY, IT WILL BE NOTIFIED AND A POINT WILL BE ADDED TO THE "EXIT" VARIABLE
    if [ -z $START_FILE ]; then echo -e "${YELLOW}THE VARIABLE 'START_FILE' IS UNDEFINED." && EXIT=$((EXIT + 1)); fi
    if [ -z $CONFIG_FILE ]; then echo -e "${YELLOW}THE VARIABLE 'CONFIG_FILE' IS UNDEFINED." && EXIT=$((EXIT + 1)); fi
    if [ -z ${SERVER_IP[0]} ]; then echo -e "${YELLOW}THE VARIABLE 'SERVER_IP' IS UNDEFINED." && EXIT=$((EXIT + 1)); fi
    if [ -z ${SERVER_PORT[0]} ]; then echo -e "${YELLOW}THE VARIABLE 'SERVER_PORT' IS UNDEFINED." && EXIT=$((EXIT + 1)); fi
    if [ -z ${MAX_PLAYERS[0]} ]; then echo -e "${YELLOW}THE VARIABLE 'MAX_PLAYERS' IS UNDEFINED." && EXIT=$((EXIT + 1)); fi
    if [ -z $ARCHITECTURE ]; then echo -e "${YELLOW}THE VARIABLE 'ARCHITECTURE' IS UNDEFINED." && EXIT=$((EXIT + 1)); fi

    # CHECK IF THE VARIABLE "EXIT" IS GREATER THAN "0"
    if [ $EXIT -gt 0 ]; then exit 1; fi
}

# FUNCTION TO CHECK IF THE FILE TO START THE SERVER EXISTS
start_file() { if test -f $START_FILE; then return; else echo -e "${YELLOW}THE FILE TO START THE SERVER DOES NOT EXIST" && exit 1; fi }

# FUNCTION TO CHECK IF THE CONFIGURATION FILE EXISTS
config_file() { if test -f $CONFIG_FILE; then return; else echo -e "${YELLOW}THE SERVER CONFIGURATION FILE DOES NOT EXIST" && exit 1; fi }

# FUNCTION TO CHECK THE MAIN PORT
serverport()
{
    # EXTRACT MAIN PORT FROM THE CONFIGURATION FILE
    SERVER_PORT[1]=$(sed -n "/port=/p" ./$CONFIG_FILE | sed -n "s/port=//p")

    # NOTIFY IF "PORT" DOES NOT EXIST
    if [ -z ${SERVER_PORT[1]} ]; then echo -e "${YELLOW}No 'port' was found in your configuration file, please add the line 'port=${SERVER_PORT[0]}' in your configuration file." && exit 1; fi

    # CHECK IF THE PORT OF THE CONFIGURATION FILE IS THE SAME AS THE SET PORT
    if [ ${SERVER_PORT[1]} != ${SERVER_PORT[0]} ];
    then
        # REMOVE SUBSTITUTE LINE
        LINE=$(grep -n "port=" ./$CONFIG_FILE | sed -n -r "s/:(.*)//p")

        # REPLACE THE PORT IN THE CONFIGURATION FILE WITH THE SET PORT
        sed -i "$LINE cCHANGE-ME" ./$CONFIG_FILE ;
        sed -i -r "$LINE s|CHANGE-ME|port=${SERVER_PORT[0]}|" ./$CONFIG_FILE

        # SEND A MESSAGE TO LET THEM KNOW THAT YOU CHANGED THE MAIN PORT :D
        echo -e "${YELLOW}It was detected that in its configuration file the main port was different from the established one, so it was modified."
    fi
}

# FUNCTION TO CHECK MAX PLAYERS
maxplayers()
{
    # EXTRACT MAX PLAYERS FROM THE CONFIGURATION FILE
    MAX_PLAYERS[1]=$(sed -n "/maxplayers=/p" ./$CONFIG_FILE | sed -n "s/maxplayers=//p")

    # NOTIFY IF "MAXPLAYERS" DOES NOT EXIST
    if [ -z ${MAX_PLAYERS[1]} ]; then echo -e "${YELLOW}No 'maxplayers' was found in your configuration file, please add the line 'maxplayers=${MAX_PLAYERS[0]}' in your configuration file." && exit 1; fi

    # CHECK IF THE MAX PLAYERS OF THE CONFIGURATION FILE ARE GREATER THAN THE ESTABLISHED ONES
    if [ ${MAX_PLAYERS[1]} -gt ${MAX_PLAYERS[0]} ];
    then
        # REMOVE SUBSTITUTE LINE
        LINE=$(grep -n "maxplayers=" ./$CONFIG_FILE | sed -n -r "s/:(.*)//p")

        # REPLACE THE MAX PLAYERS IN THE CONFIGURATION FILE WITH THE SET ONE
        sed -i "$LINE cCHANGE-ME" ./$CONFIG_FILE ;
        sed -i -r "$LINE s|CHANGE-ME|maxplayers=$MAX_PLAYERS|" ./$CONFIG_FILE

        # SEND A MESSAGE TO LET THEM KNOW WE KNOW YOU CHANGED THE MAX PLAYERS :D
        echo -e "${YELLOW}It was detected that in your configuration file the number of people who could enter your server exceeded the established limit, therefore it was changed."
    fi
}

# FUNCTION TO START THE SERVER
start_server()
{
    # START SERVER COMMAND
    mono ./$START_FILE -ip ${SERVER_IP[0]} -config $CONFIG_FILE
}

# PRINCIPAL FUNCTION
main()
{
    # LOADING ALL FUNCTIONS
    check_variables
    start_file
    config_file
    serverport
    maxplayers
    start_server
}

# MAIN FUNCTION EXECUTION
main
