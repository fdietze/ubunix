#!/usr/bin/env bash

IMAGEPATH=$HOME/projects/ubunix

# https://medium.com/@SaravSun/running-gui-applications-inside-docker-containers-83d65c0db110
# https://github.com/mviereck/x11docker/wiki/Hardware-acceleration
# https://docs.docker.com/engine/reference/commandline/run/#access-an-nvidia-gpu
# https://stackoverflow.com/questions/28985714/run-apps-using-audio-in-a-docker-container/28985715#28985715
# https://github.com/mviereck/x11docker

dr() {
    # https://stackoverflow.com/questions/1668649/how-to-keep-quotes-in-bash-arguments/8723305#8723305
    COMMAND=''
    for i in "$@"; do 
        i="${i//\\/\\\\}"
        COMMAND="$COMMAND \"${i//\"/\\\"}\""
    done
    docker build "$IMAGEPATH" --quiet --tag ubunix && \
    docker run -t -i \
        --env "TERM=xterm-256color" \
        --env "UBUNIX=true" \
        --env="DISPLAY" \
        --env="XDG_RUNTIME_DIR" \
        --env="TMP=/tmp" \
        --net=host \
        --device /dev/fuse --cap-add SYS_ADMIN \
        --ipc=host \
        --group-add video \
        --device /dev/dri \
        --privileged \
        -v /dev/shm:/dev/shm \
        -v /dev/bus/usb:/dev/bus/usb \
        -v /dev/serial:/dev/serial \
        -v /etc/machine-id:/etc/machine-id \
        -v /run/user/$UID:/run/user/$UID \
        -v /var/lib/dbus:/var/lib/dbus \
        -v /tmp:/tmp \
        --mount type=bind,source="$HOME",target="$HOME" \
        --mount type=bind,source="$(pwd)",target="$(pwd)" \
            ubunix bash -c "useradd --uid $UID --gid $GID $USER && cd $(pwd) && echo -e 'root ALL=(ALL:ALL) SETENV: ALL\n $USER	ALL=(ALL:ALL)	NOPASSWD:SETENV: ALL' >> /etc/sudoers && su $USER --session-command '$(basename "$SHELL") -ic \"$COMMAND\"'"; 
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
