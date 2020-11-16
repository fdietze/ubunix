#!/usr/bin/env bash

IMAGEPATH=$HOME/projects/ubunix

# https://medium.com/@SaravSun/running-gui-applications-inside-docker-containers-83d65c0db110
# https://github.com/mviereck/x11docker/wiki/Hardware-acceleration
dr() {
    docker build "$IMAGEPATH" --quiet --tag ubunix && \
    docker run -t -i \
        -e "TERM=xterm-256color" \
        --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
        --env="DISPLAY" \
        --net=host \
        --device /dev/fuse --cap-add SYS_ADMIN \
        --ipc=host \
        --group-add video \
        --device /dev/dri \
        --mount type=bind,source="$HOME",target="$HOME" \
        --mount type=bind,source="$(pwd)",target="$(pwd)" \
            ubunix bash -c "useradd --uid $UID --gid $GID $USER && cd $(pwd) && su $USER --session-command '$*'"; 
}

dr-add-run() {
    echo "RUN $*" >> "$IMAGEPATH"/Dockerfile
}


dr-edit() {
    $EDITOR "$IMAGEPATH"/Dockerfile
}

dr-install() {
    echo "RUN DEBIAN_FRONTEND=noninteractive apt-get -y install $*" >> "$IMAGEPATH"/Dockerfile
}

drs() {
    dr "$(basename "$SHELL")" -i
}
