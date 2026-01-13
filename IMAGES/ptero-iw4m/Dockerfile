FROM debian:trixie-slim

# Installing IW4M Admin Dependencies!
USER root
RUN apt-get update
RUN apt-get install -y wget
RUN wget https://packages.microsoft.com/config/debian/13/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb
RUN apt-get update; \
    apt-get install -y apt-transport-https && \
    apt-get update && \
    apt-get install -y dotnet-sdk-10.0 aspnetcore-runtime-10.0 zlib1g
RUN dotnet --list-sdks
RUN dotnet --list-runtimes

# Installing other dependencies
RUN apt-get -y install unzip curl

# Setting up container user
USER container
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
WORKDIR /home/container

# Copy over entrypoint
COPY ./entrypoint.sh /entrypoint.sh
CMD     ["/bin/bash", "/entrypoint.sh"]
