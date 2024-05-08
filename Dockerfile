FROM ubuntu:latest

RUN apt-get update && apt-get install -y tar bash coreutils findutils curl binfmt-support cron wget git

RUN mkdir ~/exagear
WORKDIR ~/exagear

RUN wget https://archive.org/download/exagear-desktop-rpi3.tar/exagear-desktop-rpi3.tar.gz
RUN tar xvzf exagear*.tar.gz

RUN dpkg -i exagear*3428*.deb
RUN dpkg -i exagear-guest*.deb

RUN curl https://archive.org/download/exagear-desktop_202111/patch.sh | bash

RUN apt-get update && apt-get upgrade -y

USER container
ENV  USER container
ENV HOME /home/container

WORKDIR /home/container
COPY ./entrypoint.sh /entrypoint.sh


CMD ["/bin/bash", "/entrypoint.sh"]

