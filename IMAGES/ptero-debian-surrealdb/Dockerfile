FROM ghcr.io/parkervcp/yolks:ubuntu
LABEL author="Stefanuk12" maintainer="stefanukpadd@gmail.com"

## Install dependencies
USER root
RUN apt update \
    && apt upgrade -y \
    && apt install curl -y \
    && apt-get install libc6 libstdc++6 -y

## Installing SurrealDB
RUN curl -sSf https://install.surrealdb.com | sh

## Finishing up
USER container
WORKDIR	/home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD	["/bin/bash", "/entrypoint.sh"]