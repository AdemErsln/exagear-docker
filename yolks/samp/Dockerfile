##      PLATFORMS AND BASE IMAGE
FROM    --platform=$TARGETOS/$TARGETARCH ubuntu:latest

##      CREDITS TO THE AUTHOR
LABEL   author="daniscript18" maintainer="daniscript18@outlook.com"

##      DISABLE THE INTERACTION
ENV     DEBIAN_FRONTEND noninteractive

##      UPDATE THE LIST OF REPOSITORIES AND SYSTEM PACKAGES
RUN     apt update -y ; apt upgrade -y

##      INSTALL SOME ESSENTIAL PACKAGES
RUN     apt install -y gcc g++ libgcc1 libc++-dev gdb libc6 git wget curl tar zip unzip binutils xz-utils liblzo2-2 cabextract iproute2 net-tools netcat telnet libatomic1 libsdl1.2debian libsdl2-2.0-0 libfontconfig icu-devtools libunwind8 sqlite3 libsqlite3-dev libmariadb-dev libzip4 locales ffmpeg apt-transport-https init-system-helpers libcurl3-gnutls liblua5.1-0 libluajit-5.1-2 libsqlite3-0 bzip2 zlib1g libevent-dev systemd

##      INSTALL DEPENDENCIES
RUN     curl -s https://raw.githubusercontent.com/daniscript18/pterodactyl/master/scripts/dependencies-samp.sh | sh

##      CREATION OF THE CONTAINER USER
RUN     useradd -m -d /home/container -s /bin/bash container

##      GLOBAL VARIABLE FOR THE USER AND CENTRAL DIRECTORY
ENV     USER=container HOME=/home/container

##      ESTABLISHMENT OF THE WORK AREA
WORKDIR /home/container

##      COPY THE EXECUTABLE FILE TO THE CONTAINER
COPY    ./run.sh /run.sh

##      COPY THE EXECUTABLE FILE TO THE CONTAINER
COPY    ./entrypoint.sh /entrypoint.sh

##      PRIMARY RUN COMMAND
CMD     [ "/bin/bash", "/run.sh" ]