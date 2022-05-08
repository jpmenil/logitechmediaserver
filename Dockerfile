FROM ubuntu:22.04

ARG ARCH=amd64
ARG BASE_URL=http://downloads.slimdevices.com/nightly/
ARG RELEASE=8.3

ENV DEBIAN_FRONTEND noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get -y install --no-install-recommends locales \
    && locale-gen en_US.UTF-8 \
    && apt-get -y --no-install-recommends install espeak \
        faad \
        ffmpeg \
        flac \
        lame \
        libcrypt-openssl-rsa-perl \
        libgomp1 \
        libio-socket-ssl-perl \
        libopusfile0 \
        libsox-fmt-all \
        sox \
        wavpack \
    && apt-get -y install --no-install-recommends ca-certificates curl \
    && if ! [ "${ARCH##*"arm"*}" ]; then ARCH="arm"; fi \
    && RELEASE_FILE=$(curl -Lsf -o - "${BASE_URL}?ver=${RELEASE}" | grep "${ARCH}".deb | sed -e '$!d' -e 's/.*href="//' -e 's/".*//') \
    && curl -Lsf "${BASE_URL}${RELEASE_FILE}" -o /tmp/lms.deb \
    && dpkg -i /tmp/lms.deb \
    && rm /tmp/lms.deb \
    && mkdir /config /music \
    && chown squeezeboxserver:nogroup /config /music \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

USER squeezeboxserver
VOLUME /config
EXPOSE 3483 3483/udp 9000

ENTRYPOINT ["squeezeboxserver"]
CMD ["--cachedir", "/config/cache", "--logdir", "/config/logs", "--prefsdir", "/config/prefs"]
