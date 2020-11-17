FROM ubuntu:20.04

ARG LMS_VERSION=8.0
ARG LMS_SUB_VERSION=0
ARG PACKAGE_VERSION_URL=http://www.mysqueezebox.com/update/?version=8.0.0&revision=1&geturl=1&os=deb

ENV DEBIAN_FRONTEND noninteractive
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get -y --no-install-recommends install faad ffmpeg flac lame libgomp1 libio-socket-ssl-perl libsox-fmt-all sox wavpack \
    && apt-get -y -u dist-upgrade \
    && apt-get -y install --no-install-recommends ca-certificates curl locales \
    && locale-gen en_US.UTF-8 \
    && url=$(curl "${PACKAGE_VERSION_URL}" | sed 's/_all\.deb/_amd64\.deb/') \
    && curl -Lsf "${url}" -o /tmp/lms.deb \
    && dpkg -i /tmp/lms.deb \
    && rm /tmp/lms.deb \
    && mkdir /config /music \
    && chown squeezeboxserver:nogroup /config /music \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER squeezeboxserver
VOLUME /config
EXPOSE 3483 3483/udp 9000

ENTRYPOINT ["squeezeboxserver"]
CMD ["--cachedir", "/config/cache", "--logdir", "/config/logs", "--prefsdir", "/config/prefs"]
