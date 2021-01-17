from ubuntu:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update
# software-properties-common = add-apt-repositories
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apt-utils software-properties-common

# Set the locale
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# basic tools
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install sudo
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install moreutils bsdmainutils iputils-ping usbutils
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install zsh git wget vim
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libncurses5
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install fuse
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install pulseaudio pavucontrol

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install nodejs npm yarn
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python3 python3-pip python3-venv python3-setuptools python3-dev cython3
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install pkg-config autoconf-archive libtool autotools-dev libbz2-dev zlib1g-dev libtar-dev

