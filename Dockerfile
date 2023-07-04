FROM ubuntu:latest

RUN apt-get update && apt-get install -y bash coreutils findutils curl binfmt-support cron wget

RUN mkdir ~/exagear
WORKDIR ~/exagear

RUN wget https://dl.insrt.uk/mirror/exagear/exagear-guest-ubuntu-1804_3428_all.deb
RUN wget https://dl.insrt.uk/mirror/exagear/exagear_3428-1_arm64.deb

RUN dpkg -i exagear*3428*.deb
RUN dpkg -i exagear-guest*.deb

RUN curl https://dl.insrt.uk/mirror/exagear/patch.sh | bash

RUN apt-get update && apt-get upgrade -y