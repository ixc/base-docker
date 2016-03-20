#!/bin/bash

# Setup unprivileged user and execute.

set -e

# Root entrypoint.

if [[ $(id -u -n) == "root" ]]; then
    setup-user.sh "${PROJECT_NAME}" "${PROJECT_DIR}/var"
    exec gosu "${PROJECT_NAME}" entrypoint-base.sh "$@"
fi

# Unprivileged entrypoint.

exec "$@"
