FROM registry.selfdesign.org/docker/alpine/3.10
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Set Defaults
ENV LISTMONK_VERSION=0.3.0-alpha \
    ENABLE_NGINX=TRUE \
    ENABLE_SMTP=FALSE \
    ENABLE_CRON=FALSE \
    ZABBIX_HOSTNAME=listmonk-app 

### Install Runtime Dependencies
RUN set -x && \
    apk update && \
    apk upgrade && \
    \
    apk add -t .listmonk-run-deps \
               apache2-utils \
               expect \
               nginx \
               postgresql-client \
    && \
    mkdir -p /app && \
    curl -sSL https://github.com/knadh/listmonk/releases/download/v${LISTMONK_VERSION}/listmonk_${LISTMONK_VERSION}_linux_amd64.tar.gz | tar xvfz - --strip 0 -C /app && \
    \
### Misc & Cleanup
    mkdir -p /run/nginx/ && \
    rm -rf /var/cache/apk/*

### Networking Configuration
EXPOSE 80 9000

### Add Files
ADD install /
