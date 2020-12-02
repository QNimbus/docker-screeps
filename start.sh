#!/usr/bin/env bash
set -e


function init_srv(){
        echo "===== SETTING UP SCREEPS ====="

        cp -a /screeps.base/* /screeps/

        cd /screeps

        if [ -z "$STEAM_KEY" ]; then
                echo "Did you forget to set the STEAM_KEY environment variable?"
                exit 1
        else
                echo "initializing .screepsrc..."

                yarn init -y
                yarn add screeps

                # pass our steam key into the init process
                echo "${STEAM_KEY}" | npx screeps init
        fi

        sed -i 's/modfile.*/modfile = custom_mods.json/' .screepsrc
        sed -i 's/storage_disabled = false/storage_disabled = true/' .screepsrc

        # Add newline to .screepsrc if not already ending with newline
        [ -n "$(tail -c1 .screepsrc)" ] && echo >> .screepsrc

        echo -e "\n[mongo]" >> .screepsrc
        echo -e "host=${MONGO_LINK:=mongo}" >> .screepsrc
        echo -e "[redis]" >> .screepsrc
        echo -e "host=${REDIS_LINK:=redis}" >> .screepsrc
}

function run_srv(){
        cd /screeps
        exec npx screeps start
}

case $1 in
        init)
                init_srv
                ;;
        run)
                run_srv
                ;;
        *)
                exec "$@"
                ;;
esac
