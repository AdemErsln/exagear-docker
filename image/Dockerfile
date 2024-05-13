FROM ubuntu:20.04

LABEL maintainer="alzhahir"

ENV DEBIAN_FRONTEND noninteractive

## add container user
RUN useradd -m -d /home/container container
ENV USER=container HOME=/home/container

## install dependencies
RUN apt update && apt upgrade -y
RUN apt install -y iproute2 gnupg2 tzdata software-properties-common libntlm0 winbind xvfb xauth python3 wget ca-certificates locales apt-transport-https

ENV BOX86_PATH=~/wine/bin/
ENV BOX86_LD_LIBRARY_PATH=~/wine/lib/wine/i386-unix/:/lib/i386-linux-gnu:/lib/aarch64-linux-gnu/
ENV BOX64_PATH=~/wine64/bin/
ENV BOX64_LD_LIBRARY_PATH=~/wine64/lib/i386-unix/:~/wine64/lib/wine/x86_64-unix/:/lib/i386-linux-gnu/:/lib/x86_64-linux-gnu:/lib/aarch64-linux-gnu/

## add ryanfortner's box64 repo
RUN wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list
RUN wget -O- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor |  tee /usr/share/keyrings/box64-debs-archive-keyring.gpg
RUN apt update

## install dependencies and box64 itself
RUN apt install -y libc6 libstdc++6 mesa* zenity* box64

## install box86
RUN dpkg --add-architecture armhf
RUN wget https://ryanfortner.github.io/box86-debs/box86.list -O /etc/apt/sources.list.d/box64.list
RUN wget -O- https://ryanfortner.github.io/box86-debs/KEY.gpg | gpg --dearmor |  tee /usr/share/keyrings/box86-debs-archive-keyring.gpg
RUN apt update && apt install libasound2 libc6:armhf libglib2.0-0 libgphoto2-6 libgphoto2-port12 \
        libgstreamer-plugins-base1.0-0 libgstreamer1.0-0 libldap-2.4-2 libopenal1 libpcap0.8 libpulse0 \
        libsane1 libudev1 libunwind8 libusb-1.0-0 libvkd3d1 libx11-6 libxext6 ocl-icd-libopencl1 \
        libasound2-plugins libncurses6 libtinfo5 libasound2:armhf libstdc++6:armhf libglib2.0-0:armhf \
        libgphoto2-6:armhf libgphoto2-port12:armhf libgstreamer-plugins-base1.0-0:armhf libgstreamer1.0-0:armhf \
        libldap-2.4-2:armhf libopenal1:armhf libpcap0.8:armhf libpulse0:armhf libsane1:armhf libudev1:armhf \
        libunwind8:armhf libusb-1.0-0:armhf libvkd3d1:armhf libx11-6:armhf libxext6:armhf ocl-icd-libopencl1:armhf \
        libasound2-plugins:armhf libncurses6:armhf libmpeg2-4:armhf libmpeg2encpp-2.1-0:armhf libtinfo6:armhf \
        libmpg123-0:armhf libtinfo5:armhf cabextract libxslt1.1:armhf zenity:armhf mesa*:armhf box86 -y

# install mono
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
        && echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
        && apt update \
        && apt install mono-complete -y

## arch-qualify the current repositories
RUN sed -i "s/deb h/deb [arch=arm64] h/g" /etc/apt/sources.list

## add amd64 architecture to prepare for wine
RUN dpkg --add-architecture amd64

## add x86 architecture to prepare for wine
RUN dpkg --add-architecture i386

## add amd64 and i386's repos
RUN echo "# both amd64 and i386 repositories" >> /etc/apt/sources.list
RUN echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ focal main restricted" >> /etc/apt/sources.list
RUN echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ focal-updates main restricted" >> /etc/apt/sources.list
RUN echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ focal universe" >> /etc/apt/sources.list
RUN echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ focal-updates universe" >> /etc/apt/sources.list
RUN echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ focal multiverse" >> /etc/apt/sources.list
RUN echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ focal-updates multiverse" >> /etc/apt/sources.list
RUN echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb [arch=amd64,i386] http://security.ubuntu.com/ubuntu/ focal-security main restricted" >> /etc/apt/sources.list
RUN echo "deb [arch=amd64,i386] http://security.ubuntu.com/ubuntu/ focal-security universe" >> /etc/apt/sources.list
RUN echo "deb [arch=amd64,i386] http://security.ubuntu.com/ubuntu/ focal-security multiverse" >> /etc/apt/sources.list
RUN apt update && apt upgrade -y
RUN apt install libgcc-s1:amd64 libgcc-s1:i386 libc6:amd64 libc6:i386 gcc-10-base:amd64 gcc-10-base:i386 -y

# Install libstdc++6 manually
RUN cd /home/container \
        && wget http://mirrors.kernel.org/ubuntu/pool/main/g/gcc-10/libstdc++6_10.3.0-1ubuntu1~20.04_i386.deb \
        && wget http://security.ubuntu.com/ubuntu/pool/main/g/gcc-10/libstdc++6_10.3.0-1ubuntu1~20.04_amd64.deb \
        && dpkg --force-all -i libstdc++6_10.3.0-1ubuntu1~20.04_i386.deb \
        && dpkg --force-all -i libstdc++6_10.3.0-1ubuntu1~20.04_amd64.deb

# Install more dependencies
RUN apt update && apt install libvkd3d1:amd64 libvkd3d1:i386 \
        winbind xvfb zenity -y

RUN mkdir -pm755 /etc/apt/keyrings \
        && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
        && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources \
        && apt update \
        && apt install --install-recommends wine-stable-amd64=7.0.1~focal-1 \
        wine-stable-i386:i386=7.0.1~focal-1 wine-stable:amd64=7.0.1~focal-1 \
        winehq-stable=7.0.1~focal-1 -y

## setup winetricks
RUN wget -q -O /usr/local/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
        && chmod +x /usr/local/bin/winetricks

#ENV HOME=/home/container
#ENV WINEARCH=win32 WINEPREFIX=/home/container/.wine32
ENV WINEARCH=win64 WINEPREFIX=/home/container/.wine
ENV WINEDLLOVERRIDES="mscoree,mshtml="
ENV DISPLAY=:0
ENV DISPLAY_WIDTH=1024
ENV DISPLAY_HEIGHT=768
ENV DISPLAY_DEPTH=16
ENV AUTO_UPDATE=1
ENV XVFB=1

## configure locale
RUN update-locale lang=en_US.UTF-8 && dpkg-reconfigure --frontend noninteractive locales

# init wine
# Install MS stuff
USER container
RUN wine wineboot
RUN winetricks corefonts d3dx10 d3dx9_36
# RUN winetricks dxvk vcrun2005
USER root

WORKDIR /home/container
COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
