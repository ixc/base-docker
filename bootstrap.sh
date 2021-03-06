#!/bin/sh

# Add features from the `ixc/base-docker` image, without having to build FROM
# it, which would require a complete rebuild of all derivative images for a
# simple script change.

# Usage: wget -O - https://raw.githubusercontent.com/ixc/base-docker/master/bootstrap.sh | sh -s {commit}

set -ex

COMMIT=${1:-master}

if [ "$COMMIT" = "master" ]; then
    >&2 echo "Downloading 'master' version of scripts. You should specify a specific commit for repeatable builds."
fi

# Dockerize.
DOCKERIZE_VERSION=0.2.0
wget -nv -O - "https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz" | tar -xz -C /usr/local/bin/ -f -

# Gosu.
GOSU_VERSION=1.7
wget -nv -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture)"
chmod +x /usr/local/bin/gosu

TINI_VERSION=0.9.0
wget -nv -O /usr/local/bin/tini "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static"
chmod +x /usr/local/bin/tini

# Scripts.
cd /usr/local/bin
wget -N -nv "https://raw.githubusercontent.com/ixc/base-docker/${COMMIT}/bin/gosu-dir.sh"
wget -N -nv "https://raw.githubusercontent.com/ixc/base-docker/${COMMIT}/bin/gulp.sh"
wget -N -nv "https://raw.githubusercontent.com/ixc/base-docker/${COMMIT}/bin/setup-postgres.sh"
wget -N -nv "https://raw.githubusercontent.com/ixc/base-docker/${COMMIT}/bin/setup-user.sh"
chmod +x *.sh
