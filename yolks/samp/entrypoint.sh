#!/bin/bash

# GET AND EXPORT INTERNAL IP ADDRESS
export INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')

# GO TO THE DIRECTORY
cd /home/container

# CHECK IF "START.SH" EXISTS
if test -f start.sh;
then # IF IT EXISTS

    #WE DELETE WHAT EXISTS
    rm start.sh

    # WE DOWNLOAD THE FILE AGAIN
    wget https://raw.githubusercontent.com/daniscript18/pterodactyl/master/scripts/start-samp.sh --no-hsts -q

    # WE RENAME IT
    mv start-samp.sh start.sh

    # WE MAKE IT EXECUTABLE
    chmod +x start.sh

else # IF NOT EXISTS

    # WE DOWNLOAD THE FILE AGAIN
    wget https://raw.githubusercontent.com/daniscript18/pterodactyl/master/scripts/start-samp.sh --no-hsts -q

    # WE RENAME IT
    mv start-samp.sh start.sh

    # WE MAKE IT EXECUTABLE
    chmod +x start.sh
    
fi

# CREATING START COMMAND
MODIFIED_STARTUP=$(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")

# RUN START COMMAND
exec env ${MODIFIED_STARTUP}