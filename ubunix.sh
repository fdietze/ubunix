
dr() {                                                                                               I 
    docker build $HOME/projects/ubunix -t ubunix
    docker run -t -i \
        --mount type=bind,source="$HOME",target="$HOME" \
        --mount type=bind,source="$(pwd)",target="$(pwd)" \
            ubunix bash -c "useradd --uid $UID --gid $GID $USER && cd $(pwd) && su $USER -c '$(echo $@)'"; 
}
