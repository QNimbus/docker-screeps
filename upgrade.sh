#!/usr/bin/env sh

# Get latest version from screeps github repository
# version=$(curl https://raw.githubusercontent.com/screeps/screeps/master/package.json | jq -r .version)
version=$(docker run -it --rm --name jq endeveit/docker-jq sh -c 'curl -s https://raw.githubusercontent.com/screeps/screeps/master/package.json | jq -r .version')

# Clone our repository
git clone git@github.com:QNimbus/docker-screeps.git

# Push CWD onto stack and cd into repository directory
pushd docker-screeps

# Update version number in Dockerfile and create/update timestamp
sed -i 's/^ENV SCREEPS_VERSION.*$/ENV SCREEPS_VERSION '$version'/i' Dockerfile
date > timestamp
git add timestamp

# Commit, tag and push updated repository
git commit -a -m "Auto Update to screeps "$version
git tag -f $version
if [[ "$version" != "ptr" ]]; then
	git tag -f latest
fi
git push origin main --tags --force

# Go back to original folder and remove repository
popd
rm -rf docker-screeps
