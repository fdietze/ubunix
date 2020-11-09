#!/usr/bin/env bash

IMAGEPATH=$HOME/projects/ubunix

dr() {                                                                                               I 
    docker build "$IMAGEPATH" --quiet --tag ubunix && \
    docker run -t -i \
        -e "TERM=xterm-256color" \
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
