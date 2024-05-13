#!/bin/bash

# GET FLAGS
START_FILE=$1
CONFIG_FILE=$2
SERVER_IP[0]=$3
SERVER_PORT[0]=$4
MAX_PLAYERS[0]=$5

# CREATE YELLOW COLOR
YELLOW="\033[0;32m"

# CALCULATE VARIABLE "HTTP_PORT"
HTTP_PORT[0]=$((SERVER_PORT + 2))

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
    if [ -z ${HTTP_PORT[0]} ]; then echo -e "${YELLOW}THE VARIABLE 'HTTP_PORT' IS UNDEFINED." && EXIT=$((EXIT + 1)); fi
    if [ -z $ARCHITECTURE ]; then echo -e "${YELLOW}THE VARIABLE 'ARCHITECTURE' IS UNDEFINED." && EXIT=$((EXIT + 1)); fi

    # CHECK IF THE VARIABLE "EXIT" IS GREATER THAN "0"
    if [ $EXIT -gt 0 ]; then exit 1; fi
}

# FUNCTION TO CHECK IF THE FILE TO START THE SERVER EXISTS
start_file() { if test -f $START_FILE; then return; else echo -e "${YELLOW}THE FILE TO START THE SERVER DOES NOT EXIST" && exit 1; fi }

# FUNCTION TO CHECK IF THE CONFIGURATION FILE EXISTS
config_file() { if test -f $CONFIG_FILE; then return; else echo -e "${YELLOW}THE SERVER CONFIGURATION FILE DOES NOT EXIST" && exit 1; fi }

# FUNCTION TO CHECK THE IP ADDRESS
serverip()
{
    # EXTRACT IP ADDRESS FROM CONFIGURATION FILE
    SERVER_IP[1]=$(sed -n "/<\/serverip>/p" ./$CONFIG_FILE | sed -n "s/<serverip>//p" | sed -n "s/<\/serverip>//p")

    # NOTIFY IF "SERVERIP" DOES NOT EXIST
    if [ -z ${SERVER_IP[1]} ]; then echo -e "${YELLOW}No '<serverip></serverip>' was found in your configuration file, please add the line '<serverip>${SERVER_IP[0]}</serverip>' in your configuration file." && exit 1; fi

    # CHECK IF THE IP CONFIGURATION FILE IS THE SAME AS THE SET ONE
    if [ ${SERVER_IP[1]} != ${SERVER_IP[0]} ];
    then
        # REMOVE SUBSTITUTE LINE
        LINE=$(grep -n "</serverip>" ./$CONFIG_FILE | sed -n -r "s/:(.*)//p")

        # REPLACE THE IP ADDRESS IN THE CONFIGURATION FILE WITH THE SET ONE
        sed -i "$LINE cCHANGE-ME" ./$CONFIG_FILE ;
        sed -i -r "$LINE s|CHANGE-ME|    <serverip>${SERVER_IP[0]}</serverip>|" ./$CONFIG_FILE

        # SEND A MESSAGE TO INFORM THEM THAT WE KNOW YOU CHANGED THE IP :D
        echo -e "${YELLOW}It was detected that in its configuration file the ip address was different from the one established, so it was modified."
    fi
}

# FUNCTION TO CHECK THE MAIN PORT
serverport()
{
    # EXTRACT MAIN PORT FROM THE CONFIGURATION FILE
    SERVER_PORT[1]=$(sed -n "/<\/serverport>/p" ./$CONFIG_FILE | sed -n "s/<serverport>//p" | sed -n "s/<\/serverport>//p")

    # NOTIFY IF "SERVERPORT" DOES NOT EXIST
    if [ -z ${SERVER_PORT[1]} ]; then echo -e "${YELLOW}No '<serverport></serverport>' was found in your configuration file, please add the line '<serverport>${SERVER_PORT[0]}</serverport>' in your configuration file." && exit 1; fi
    
    # CHECK IF THE PORT OF THE CONFIGURATION FILE IS THE SAME AS THE SET PORT
    if [ ${SERVER_PORT[1]} != ${SERVER_PORT[0]} ];
    then
        # REMOVE SUBSTITUTE LINE
        LINE=$(grep -n "</serverport>" ./$CONFIG_FILE | sed -n -r "s/:(.*)//p")

        # REPLACE THE PORT IN THE CONFIGURATION FILE WITH THE SET PORT
        sed -i "$LINE cCHANGE-ME" ./$CONFIG_FILE ;
        sed -i -r "$LINE s|CHANGE-ME|    <serverport>${SERVER_PORT[0]}</serverport>|" ./$CONFIG_FILE

        # SEND A MESSAGE TO LET THEM KNOW THAT YOU CHANGED THE MAIN PORT :D
        echo -e "${YELLOW}It was detected that in its configuration file the main port was different from the established one, so it was modified."
    fi
}

# FUNCTION TO CHECK THE HTTP PORT
httpport()
{
    # EXTRACT HTTP PORT FROM THE CONFIGURATION FILE
    HTTP_PORT[1]=$(sed -n "/<\/httpport>/p" ./$CONFIG_FILE | sed -n "s/<httpport>//p" | sed -n "s/<\/httpport>//p")

    # NOTIFY IF "HTTPPORT" DOES NOT EXIST
    if [ -z ${HTTP_PORT[1]} ]; then echo -e "${YELLOW}No '<httpport></httpport>' was found in your configuration file, please add the line '<httpport>${HTTP_PORT[0]}</httpport>' in your configuration file." && exit 1; fi

    # CHECK IF THE PORT OF THE CONFIGURATION FILE IS THE SAME AS THE SET PORT
    if [ ${HTTP_PORT[1]} != ${HTTP_PORT[0]} ];
    then
        # REMOVE SUBSTITUTE LINE
        LINE=$(grep -n "</httpport>" ./$CONFIG_FILE | sed -n -r "s/:(.*)//p")

        # REPLACE THE PORT IN THE CONFIGURATION FILE WITH THE SET PORT
        sed -i "$LINE cCHANGE-ME" ./$CONFIG_FILE ;
        sed -i -r "$LINE s|CHANGE-ME|    <httpport>${HTTP_PORT[0]}</httpport>|" ./$CONFIG_FILE

        # SEND A MESSAGE TO LET THEM KNOW THAT YOU CHANGED THE HTTP PORT :D
        echo -e "${YELLOW}It was detected that in its configuration file the http port was different from the established one, so it was modified."
    fi
}

# FUNCTION TO CHECK MAX PLAYERS
maxplayers()
{
    # EXTRACT MAX PLAYERS FROM THE CONFIGURATION FILE
    MAX_PLAYERS[1]=$(sed -n "/<\/maxplayers>/p" ./$CONFIG_FILE | sed -n "s/<maxplayers>//p" | sed -n "s/<\/maxplayers>//p")

    # NOTIFY IF "MAXPLAYERS" DOES NOT EXIST
    if [ -z ${MAX_PLAYERS[1]} ]; then echo -e "${YELLOW}No '<maxplayers></maxplayers>' was found in your configuration file, please add the line '<maxplayers>${MAX_PLAYERS[0]}</maxplayers>' in your configuration file." && exit 1; fi

    # CHECK IF THE MAX PLAYERS OF THE CONFIGURATION FILE ARE GREATER THAN THE ESTABLISHED ONES
    if [ ${MAX_PLAYERS[1]} -gt ${MAX_PLAYERS[0]} ];
    then
        # REMOVE SUBSTITUTE LINE
        LINE=$(grep -n "</maxplayers>" ./$CONFIG_FILE | sed -n -r "s/:(.*)//p")

        # REPLACE THE MAX PLAYERS IN THE CONFIGURATION FILE WITH THE SET ONE
        sed -i "$LINE cCHANGE-ME" ./$CONFIG_FILE ;
        sed -i -r "$LINE s|CHANGE-ME|    <maxplayers>$MAX_PLAYERS</maxplayers>|" ./$CONFIG_FILE

        # SEND A MESSAGE TO LET THEM KNOW WE KNOW YOU CHANGED THE MAX PLAYERS :D
        echo -e "${YELLOW}It was detected that in your configuration file the number of people who could enter your server exceeded the established limit, therefore it was changed."
    fi
}

# FUNCTION TO START THE SERVER
start_server()
{
    # START SERVER COMMAND
    if [ $ARCHITECTURE == "aarch64" ]; then BOX64_LOG=0 box64 ./$START_FILE -n; else ./$START_FILE -n; fi
}

# PRINCIPAL FUNCTION
main()
{
    # LOADING ALL FUNCTIONS
    check_variables
    start_file
    config_file
    serverip
    serverport
    httpport
    maxplayers
    start_server
}

# MAIN FUNCTION EXECUTION
main