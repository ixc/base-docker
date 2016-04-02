FROM buildpack-deps:jessie

# Base image with Dockerize, Gosu, and setup scripts for an unprivileged user.

ENV DOCKERIZE_VERSION=0.2.0
RUN wget -O - "https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz" | tar -xz -C /usr/local/bin/ -f -

ENV GOSU_VERSION=1.7
RUN wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture)" \
    && chmod +x /usr/local/bin/gosu

ENV PATH=/opt/base/bin:$PATH

COPY . /opt/base
