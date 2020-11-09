from ubuntu:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update

# Set the locale
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# basic tools
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apt-utils
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install zsh
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install git wget
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libncurses5
