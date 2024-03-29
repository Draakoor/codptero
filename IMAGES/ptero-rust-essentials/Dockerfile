FROM ghcr.io/parkervcp/yolks:rust_latest

# Installing some essentials
USER root
RUN apt update \
    && apt install build-essential checkinstall zlib1g-dev libssl-dev pkg-config -y

# Setting up the container
USER container
WORKDIR	/home/container
COPY ./entrypoint.sh /entrypoint.sh

# Starting the container
CMD	["/bin/bash", "/entrypoint.sh"]
