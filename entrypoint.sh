#!/usr/bin/env bash

# Add local user
# Either use the LOCAL_UID if passed in at runtime or fallback to uid 9001

USER_ID=${LOCAL_UID:-9001}

echo "Starting with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
export HOME=/home/user

# Exit when error is encountered
set -e

# Set ownership of volume to user
chown -R user /screeps

cd /screeps
exec /usr/local/bin/gosu user start.sh "$@"
