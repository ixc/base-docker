#!/bin/sh

# Add features from the `ixc/base-docker` image, without having to build FROM
# it, which would require a complete rebuild of all derivative images for a
# simple script change.

# Usage: wget -O - https://raw.githubusercontent.com/ixc/base-docker/master/bootstrap.sh | sh

# Dockerize.
DOCKERIZE_VERSION=0.2.0
wget -O - "https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz" | tar -xz -C /usr/local/bin/ -f -

# Gosu.
GOSU_VERSION=1.7
wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture)"
chmod +x /usr/local/bin/gosu

# Scripts.
mkdir -p /opt/base/bin
cd /opt/base/bin
wget https://raw.githubusercontent.com/ixc/base-docker/master/bin/entrypoint-gosu-dir.sh
wget https://raw.githubusercontent.com/ixc/base-docker/master/bin/gulp.sh
wget https://raw.githubusercontent.com/ixc/base-docker/master/bin/setup-postgres.sh
wget https://raw.githubusercontent.com/ixc/base-docker/master/bin/setup-user.sh
chmod +x /opt/base/bin/*.sh
export PATH=/opt/base/bin:$PATH
