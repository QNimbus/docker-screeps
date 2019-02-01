#!/bin/bash

# Add local user
# Either use the LOCAL_UID if passed in at runtime or fallback

USER_ID=${LOCAL_UID:-9001}

echo "Starting with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
export HOME=/home/user

# Set ownership of volume to user
chown -R user /screeps

cd /screeps
exec /usr/local/bin/gosu user start.sh "$@"
