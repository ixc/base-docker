#!/bin/bash

# Create database, `PGDATABASE`. If -f option is given, drop and recreate it.
#
# If `SRC_PGDATABASE` is a file, execute it on `PGDATABASE`. Otherwise, it is
# assumed to be the name of a database to dump and restore.
#
# If the source database is on a different host, `SRC_PGHOST`, `SRC_PGPORT`,
# `SRC_PGUSER`, and `SRC_PGPASSWORD` can also be specified.

echo "# ${0}"

set -e

# If `PGDATABASE` already exists, drop (when -f option given) or exit.
if psql -l | grep -q "\b${PGDATABASE}\b"; then
    if [[ "$1" = '-f' ]]; then
        echo "Database '${PGDATBASE}' already exists, and -f option given. Drop."
        dropdb "${PGDATABASE}"
    else
        echo "Database '${PGDATABASE}' already exists, but -f option not given. Ignore."
        exec "$@"
    fi
fi

# Create database.
echo "Create database '${PGDATABASE}'."
createdb "${PGDATABASE}"

# Restore from file or source database.
INITIAL_DATA="${SRC_PGDATABASE:-${PROJECT_DIR}/var/initial_data.sql}"
if [[ -f "${INITIAL_DATA}" ]]; then
    echo "Restore to database '${PGDATABASE}' from file '${INITIAL_DATA}'."
    psql -d "${PGDATABASE}" -f "${INITIAL_DATA}"
elif [[ -n "${SRC_PGDATABASE}" ]]; then
    # Get source database credentials.
    SRC_PGHOST="${SRC_PGHOST:-${PGHOST}}"
    SRC_PGPASSWORD="${SRC_PGPASSWORD:-${PGPASSWORD}}"
    SRC_PGPORT="${SRC_PGPORT:-${PGPORT}}"
    SRC_PGUSER="${SRC_PGUSER:-${PGUSER}}"
    # Wait for source database server to become available.
    # dockerize -wait "tcp://${SRC_PGHOST}:${SRC_PGPORT}"
    echo "Restore database '${PGDATABASE}' from source database '${SRC_PGDATABASE}' on tcp://${SRC_PGHOST}:${SRC_PGPORT}."
    PGPASSWORD="${SRC_PGPASSWORD}" pg_dump -d "${SRC_PGDATABASE}" -h "${SRC_PGHOST}" -p "${SRC_PGPORT}" -U "${SRC_PGUSER}" -O -x | psql -d "${PGDATABASE}"
fi

exec "$@"
