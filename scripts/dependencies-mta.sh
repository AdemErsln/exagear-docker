#!/bin/bash

# FUNCTION TO INSTALL BOX64
install_box64()
{
    # CHECK IF THE SYSTEM IS ARM
    if [ $(uname -i) = "aarch64" ];
    then
        # BOX64 INSTALLATION PROCESS
        apt update -y ; apt upgrade -y ;
        apt install -y gpg ;
        wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list ;
        wget -O- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor | tee /usr/share/keyrings/box64-debs-archive-keyring.gpg ;
        apt update -y ; apt upgrade -y ;
        apt install box64 -y ;
    fi
}

# FUNCTION TO INSTALL MTA DEPENDENCIES
install_mta_dependencies()
{
    # DEPENDENCIES INSTALLATION PROCESS
    apt install -y libncursesw5 ;
    wget -P /usr/lib/ https://nightly.mtasa.com/files/modules/64/libmysqlclient.so.16
}

# MAIN FUNCTION
main()
{
    # INSTALL BOX64
    install_box64 ;

    # INSTALL MTA DEPENDENCIES
    install_mta_dependencies
}

# LOAD MAIN FUNCTION
main