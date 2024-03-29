FROM --platform=$TARGETOS/$TARGETARCH alpine:latest

# Installing alpine stuff
RUN apk add --update --no-cache ca-certificates tzdata \
	&& adduser -D -h /home/container container

# Install wine and wget
RUN apk update \
    && apk add --update --no-cache wine \
    && apk add --update --no-cache winetricks --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
    && apk add --update --no-cache wget \
    && apk add --update --no-cache xvfb \
    && apk add --update --no-cache gnupg

# ENV
ENV HOME=/home/container
ENV WINEDEBUG=fixme-all
ENV WINEARCH=win64
ENV WINEPREFIX=/home/container/.wine

#
USER container
ENV USER=container HOME=/home/container
WORKDIR	/home/container

#
COPY ./entrypoint.sh /entrypoint.sh
CMD	["/bin/ash", "/entrypoint.sh"]
