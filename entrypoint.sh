#!/usr/bin/env bash

# Add local user
# Either use the LOCAL_UID if passed in at runtime or fallback to uid 9001

USER_ID=${LOCAL_UID:-9001}

# Create user if it doesn't already exist
id -u ${USER_ID} >/dev/null 2>&1 || useradd --shell /bin/bash -u ${USER_ID} -o -c "" -m screeps

echo "Starting with UID : ${USER_ID} (screeps)"
export HOME=/home/screeps

# Exit when error is encountered
set -e

# Set ownership of volume to user
chown -R screeps /screeps

cd /screeps
exec /usr/local/bin/gosu screeps start.sh "$@"
