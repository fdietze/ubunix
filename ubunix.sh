#!/usr/bin/env bash

IMAGEPATH=$HOME/local/ubunix

# https://medium.com/@SaravSun/running-gui-applications-inside-docker-containers-83d65c0db110
# https://github.com/mviereck/x11docker/wiki/Hardware-acceleration
# https://docs.docker.com/engine/reference/commandline/run/#access-an-nvidia-gpu
# https://stackoverflow.com/questions/28985714/run-apps-using-audio-in-a-docker-container/28985715#28985715
# https://github.com/mviereck/x11docker

ux() {
    # https://stackoverflow.com/questions/1668649/how-to-keep-quotes-in-bash-arguments/8723305#8723305
    COMMAND=''
    for i in "$@"; do 
        i="${i//\\/\\\\}"
        COMMAND="$COMMAND \"${i//\"/\\\"}\""
    done
    # docker build "$IMAGEPATH" --quiet --tag ubunix && \
        # -v /etc/group:/etc/group:ro \
        # -v /etc/passwd:/etc/passwd:ro \
        # -v /etc/shadow:/etc/shadow:ro \
    docker build "$IMAGEPATH" \
        --tag ubunix \
        --build-arg user_name_arg=${USER} \
        --build-arg user_id_arg=${UID} \
        --build-arg user_gid_arg=${GID} \
        --build-arg docker_gid_arg=$(getent group docker | cut -d ":" -f3) \
        && \
    docker run -t -i \
        --env="TERM=xterm-256color" \
        --env="UBUNIX=true" \
        --env="DISPLAY" \
        --env="XDG_RUNTIME_DIR" \
        --env="TMP=/tmp" \
        --env="SHELL=$SHELL" \
        --env="FLUTTER=~/flutter/bin" \
        --env="CHROME_EXECUTABLE=/usr/bin/chromium-browser" \
        --net=host \
        --device /dev/fuse --cap-add SYS_ADMIN \
        --ipc=host \
        --user=${USER} \
        --group-add video \
        --group-add docker \
        --device /dev/dri \
        --privileged \
        -v /dev/shm:/dev/shm \
        -v /dev/bus/usb:/dev/bus/usb \
        -v /dev/serial:/dev/serial \
        -v /etc/machine-id:/etc/machine-id \
        -v /run/user/$UID:/run/user/$UID \
        -v /var/lib/dbus:/var/lib/dbus \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /tmp:/tmp \
        --mount type=bind,source="$HOME",target="$HOME" \
        --mount type=bind,source="$(pwd)",target="$(pwd)" \
            ubunix bash -c "cd $(pwd) && $(basename "$SHELL") -ic \"$COMMAND\""; 
            # ubunix bash -c "cd $(pwd) && sudo su $USER --session-command '$(basename "$SHELL") -ic \"$COMMAND\"'";
}

ux-add-run() {
    echo "RUN $*" >> "$IMAGEPATH"/Dockerfile
}


ux-edit() {
    $EDITOR "$IMAGEPATH"/Dockerfile
}

ux-install() {
    echo "RUN DEBIAN_FRONTEND=noninteractive apt-get -y install $*" >> "$IMAGEPATH"/Dockerfile
}

uxs() {
    ux "$(basename "$SHELL")" -i
}
