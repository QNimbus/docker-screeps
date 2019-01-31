#!/bin/bash
set -e

function init_srv(){
        echo "===== SETTING UP SCREEPS ====="

	if [ -z "$STEAMKEY" ]; then
        	echo "Did you forget to set the STEAMKEY environment variable?"
        	exit 1
    	else
        	echo "initializing .screepsrc..."

		yarn init -y
		yarn add screeps

        	# pass our steam key into the init process
        	echo "${STEAMKEY}" | npx screeps init
        fi

        npm install screepsmod-mongo screepsmod-auth screepsmod-tickrate screepsmod-admin-utils screepsmod-features

	cp /custom_mods.json /screeps

        sed -i 's/modfile.*/modfile = custom_mods.json/' .screepsrc

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

