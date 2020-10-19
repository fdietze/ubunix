#!/usr/bin/env bash

IMAGEPATH=$HOME/projects/ubunix

dr() {                                                                                               I 
    docker build $IMAGEPATH -t ubunix
    docker run -t -i \
        --mount type=bind,source="$HOME",target="$HOME" \
        --mount type=bind,source="$(pwd)",target="$(pwd)" \
            ubunix bash -c "useradd --uid $UID --gid $GID $USER && cd $(pwd) && su $USER -c '$(echo $@)'"; 
}

dr-add-run() {
    echo "RUN $@" >> $IMAGEPATH/Dockerfile
}

dr-install() {
    echo "RUN DEBIAN_FRONTEND=noninteractive apt-get -y install $@" >> $IMAGEPATH/Dockerfile
}

drs() {
    dr $(basename $SHELL) -i
}
