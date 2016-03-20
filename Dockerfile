FROM debian:jessie

# Base image with Dockerize, Gosu, and setup scripts for gulp, postgres and an
# unprivileged user.

# System packages.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Dockerize.
ENV DOCKERIZE_VERSION=0.2.0
RUN wget -O - "https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz" | tar -xz -C /usr/local/bin/ -f -

# Gosu.
ENV GOSU_VERSION=1.7
RUN wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture)" \
    && chmod +x /usr/local/bin/gosu

# Entrypoint.
ENV PATH=/opt/base/bin:$PATH
ENTRYPOINT ["entrypoint-base.sh"]

# Source.
COPY . /opt/base

# ONBUILD #####################################################################

# Build arguments.
ONBUILD ARG PROJECT_NAME

# Environment.
ONBUILD ENV PROJECT_NAME=$PROJECT_NAME
ONBUILD ENV PROJECT_DIR=/opt/$PROJECT_NAME
ONBUILD ENV PATH=$PROJECT_DIR/bin:$PATH

# Workdir.
ONBUILD WORKDIR $PROJECT_DIR
