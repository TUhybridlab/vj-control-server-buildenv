#!/bin/sh

START_PATH="`pwd`"
CONF_DIR="$START_PATH/poky/build/conf"

YOCTO_RELEASE="sumo"

BBLAYERS_FILE="bblayers.conf"

function copyLayers() {
	copyConf $BBLAYERS_FILE
	sed -i 's|YOCTO_BASE_PATH|'`pwd`'|' "$CONF_DIR/$BBLAYERS_FILE"
}

function copyConf() {
	if [ ! -d $CONF_DIR ]; then
		mkdir -p $CONF_DIR
	fi
	cp "$START_PATH/conf/$1" "$CONF_DIR"
}

function checkoutRepo() {
	local BASE_URL=$1
	local REPO=$2
	local BRANCH=$3

	if [ ! -d "$REPO" ]
	then
		git clone "$BASE_URL"'/'"$REPO"
	fi
	pushd "$REPO"
	git stash
	git fetch
	git checkout "$BRANCH"
	git rebase
	git stash pop
	popd
}

checkoutRepo 'git://git.yoctoproject.org/' 'poky' "$YOCTO_RELEASE"
cd 'poky'

checkoutRepo 'https://github.com/agherzan/' 'meta-raspberrypi' "$YOCTO_RELEASE"
checkoutRepo 'https://github.com/openembedded/' 'meta-openembedded' "$YOCTO_RELEASE"
checkoutRepo 'git@github.com:j-be/' 'meta-vj' 'master'

copyLayers
copyConf "local.conf"

. ./oe-init-build-env
