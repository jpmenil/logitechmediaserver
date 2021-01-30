FROM ubuntu:20.04

ARG BASE_URL=http://downloads.slimdevices.com/nightly/
ARG RELEASE=8.2

ENV DEBIAN_FRONTEND noninteractive
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get -y --no-install-recommends install faad \
        ffmpeg \
        flac \
        lame \
        libgomp1 \
        libio-socket-ssl-perl \
        libsox-fmt-all \
        sox \
        wavpack \
    && apt-get -y install --no-install-recommends ca-certificates curl locales \
    && locale-gen en_US.UTF-8 \
    && RELEASE_FILE=$(curl -vLsf -o - "${BASE_URL}?ver=${RELEASE}" | grep _amd64.deb | sed -e '$!d' -e 's/.*href="//' -e 's/".*//') \
    && curl -Lsf "${BASE_URL}${RELEASE_FILE}" -o /tmp/lms.deb \
    && dpkg -i /tmp/lms.deb \
    && rm /tmp/lms.deb \
    && mkdir /config /music \
    && chown squeezeboxserver:nogroup /config /music \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER squeezeboxserver
VOLUME /config
EXPOSE 3483 3483/udp 9000

ENTRYPOINT ["squeezeboxserver"]
CMD ["--cachedir", "/config/cache", "--logdir", "/config/logs", "--prefsdir", "/config/prefs"]
