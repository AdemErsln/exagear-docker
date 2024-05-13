#!/bin/bash

# FUNCTION TO INSTALL BOX86
install_box86()
{
    # CHECK IF THE SYSTEM IS ARM
    if [ $(uname -i) = "aarch64" ];
    then
        # BOX86 INSTALLATION PROCESS
        apt update -y ; apt upgrade -y ;
        apt install -y build-essential cmake make python3 ;
        dpkg --add-architecture armhf ;
        apt update -y ; apt upgrade -y ;
        apt install -y libc6:armhf gcc-arm-linux-gnueabihf ;
        git clone https://github.com/ptitSeb/box86 ;
        cd box86 ; mkdir build ; cd build ;
        cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo ;
        make -j2 ; make install ;
        cd .. ; cd .. ; rm -rf box86 ;
    fi
}

# FUNCTION TO INSTALL SAMP DEPENDENCIES
install_samp_dependencies()
{
    # DEPENDENCIES INSTALLATION PROCESS
    if [ $(uname -i) != "aarch64" ];
    then
        dpkg --add-architecture i386 ;
        apt update -y ; apt upgrade -y ;
        apt install -y openssl fontconfig dirmngr dnsutils libstdc++6 libtbb2:i386 libtbb-dev:i386 libicu-dev:i386 ;
    fi
}

# MAIN FUNCTION
main()
{
    # INSTALL BOX86
    install_box86 ;

    # INSTALL SAMP DEPENDENCIES
    install_samp_dependencies
}

# LOAD MAIN FUNCTION
main