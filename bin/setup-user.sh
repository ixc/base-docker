#!/bin/bash

# Create an unprivileged user with the given username and home directory. If
# the user already exists, change its UID and GID match the given home
# directory. If the home directory already exists and is owned by root, change
# its UID and GID to match the unprivileged user.

set -e

USERNAME=$1
HOME_DIR=$2

# Create user.
if ! id "${USERNAME}" 2> /dev/null; then
    echo "User '${USERNAME}' does not exist. Create."
    if [[ -d "${HOME_DIR}" ]]; then
        adduser --system --home "${HOME_DIR}" --no-create-home "${USERNAME}"
    else
        adduser --system --home "${HOME_DIR}" "${USERNAME}"
    fi
fi

# Get UID and GID for user and home directory.
HOME_DIR_GID=$(stat -c '%g' "${HOME_DIR}")
HOME_DIR_UID=$(stat -c '%u' "${HOME_DIR}")
USER_UID=$(id -u "${USERNAME}")
USER_GID=$(id -g "${USERNAME}")

# Change user or home directory UID and GID.
if [[ "${USER_UID}" != "${HOME_DIR_UID}" ]] || [[ "${USER_GID}" != "${HOME_DIR_GID}" ]]; then
    if [[ "${HOME_DIR_UID}" == 0 ]]; then
        echo "Unprivileged user home directory '${HOME_DIR}' is owned by root. Change owner."
        chown -R "${USER_UID}:${USER_GID}" "${HOME_DIR}"
    else
        echo "UID and GID for user '${USERNAME}' (${USER_UID}:${USER_GID}) do not match directory '${HOME_DIR}' (${HOME_DIR_UID}:${HOME_DIR_GID}). Modify."
        usermod -g "${HOME_DIR_GID}" -u "${HOME_DIR_UID}" "${USERNAME}"
    fi
fi
