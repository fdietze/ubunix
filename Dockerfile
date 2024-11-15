FROM ubuntu:24.04
ARG UID
ARG GID
ARG USER

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get --yes --no-install-recommends install \
    locales \
    sudo zsh fish

# set up local user
RUN userdel ubuntu \
 && useradd --uid "$UID" --gid "$GID" "$USER" \
 && printf "root ALL=(ALL:ALL) SETENV: ALL\n %s	ALL=(ALL:ALL)	NOPASSWD:SETENV: ALL" "$USER" >> /etc/sudoers

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get --yes --no-install-recommends install \
    # ubuntu-desktop-minimal \
    # build-essential cmake autoconf \
    neovim git xclip wget

USER $USER


