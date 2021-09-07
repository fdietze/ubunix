from ubuntu:latest

ARG user_name_arg
ENV user_name=$user_name_arg
ARG user_id_arg
ENV user_id=$user_id_arg
ARG user_gid_arg
ENV user_gid=$user_gid_arg
ARG docker_gid_arg
ENV docker_gid=$docker_gid_arg

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -y
# software-properties-common = add-apt-repositories
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apt-utils software-properties-common

RUN DEBIAN_FRONTEND=noninteractive apt-get update

# Set the locale
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# basic tools
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install sudo \
    moreutils bsdmainutils iputils-ping usbutils \
    build-essential curl \
    zsh git wget \
    libncurses5 \
    gnome-keyring \
    fuse \
    gnupg \
    pulseaudio

RUN DEBIAN_FRONTEND=noninteractive groupadd -g "$docker_gid_arg" docker
RUN DEBIAN_FRONTEND=noninteractive useradd -M --uid "$user_id_arg" --gid "$user_gid_arg" "$user_name_arg"
RUN DEBIAN_FRONTEND=noninteractive usermod -aG sudo,docker "$user_name_arg"
RUN DEBIAN_FRONTEND=noninteractive echo 'root ALL=(ALL:ALL) SETENV: ALL' >> /etc/sudoers && echo "$user_name_arg ALL=(ALL:ALL) NOPASSWD:SETENV: ALL" >> /etc/sudoers

# advanced tools
RUN DEBIAN_FRONTEND=noninteractive apt-key update -y

RUN DEBIAN_FRONTEND=noninteractive wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -
RUN DEBIAN_FRONTEND=noninteractive wget -q https://apt.releases.hashicorp.com/gpg -O- | apt-key add -
RUN DEBIAN_FRONTEND=noninteractive wget -q https://download.docker.com/linux/ubuntu/gpg -O- | apt-key add -

RUN DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:neovim-ppa/unstable
RUN DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:mmk2410/intellij-idea
RUN DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:maarten-fonville/android-studio
RUN DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:saiarcot895/chromium-beta
RUN DEBIAN_FRONTEND=noninteractive add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
RUN DEBIAN_FRONTEND=noninteractive apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN DEBIAN_FRONTEND=noninteractive add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

RUN DEBIAN_FRONTEND=noninteractive apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python3 python3-pip python3-venv python3-setuptools python3-dev cython3
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install npm nodejs yarn \
    pkg-config autoconf-archive libtool autotools-dev libbz2-dev zlib1g-dev libtar-dev \
    ruby ruby-dev \
    fasd \
    jq \
    terraform \
    tig \
    entr \
    neovim \
    dhall \
    code \
    openjdk-8-jdk \
    firefox \
    chromium-browser \
    intellij-idea-community \
    libcanberra-gtk-module android-sdk android-studio

RUN DEBIAN_FRONTEND=noninteractive curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip -o awscliv2.zip && sudo ./aws/install

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install docker-ce docker-ce-cli containerd.io
RUN DEBIAN_FRONTEND=noninteractive npm update && npm upgrade && npm install -g npm
RUN DEBIAN_FRONTEND=noninteractive npm install -g purescript \
    && npm install -g spago \
    && npm install -g purty \
    && npm install -g bower \
    && npm install -g pulp

RUN DEBIAN_FRONTEND=noninteractive curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install nodejs

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt clean && apt autoclean
