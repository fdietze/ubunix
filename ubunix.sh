#!/usr/bin/env bash
set -Eeuo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail

# https://medium.com/@SaravSun/running-gui-applications-inside-docker-containers-83d65c0db110
# https://github.com/mviereck/x11docker/wiki/Hardware-acceleration
# https://docs.docker.com/engine/reference/commandline/run/#access-an-nvidia-gpu
# https://stackoverflow.com/questions/28985714/run-apps-using-audio-in-a-docker-container/28985715#28985715
# https://github.com/mviereck/x11docker

IMAGEPATH="$HOME/projects/ubunix"
docker build "$IMAGEPATH" --tag ubunix $@ && \
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
  ubunix bash -c "useradd --uid $UID --gid $GID $USER && cd $(pwd) && echo -e 'root ALL=(ALL:ALL) SETENV: ALL\n $USER	ALL=(ALL:ALL)	NOPASSWD:SETENV: ALL' >> /etc/sudoers && su $USER --session-command '$(basename "$SHELL") -i'" \

