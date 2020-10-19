from ubuntu:latest

RUN apt-get update
RUN apt-get -y install sqlite3
RUN apt-get -y install libsqlite3-dev
RUN apt-get -y install build-essential
RUN apt-get -y install zsh


