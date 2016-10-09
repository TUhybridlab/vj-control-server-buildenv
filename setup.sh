#!/bin/sh

START_PATH="`pwd`"
POKY_BUILD_DIR="$START_PATH/poky/build"
CONF_DIR="$POKY_BUILD_DIR/conf"

PYTHON2_ENV="env-python2"

IMAGE="image-vj-control-server"
BBLAYERS_FILE="bblayers.conf"

BUILD_DIR="/mnt/build-envs/rpi2/build/"

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

function forcePython2() {
	if [ ! -d $PYTHON2_ENV ]; then
		virtualenv2 $PYTHON2_ENV
	fi
	. $PYTHON2_ENV/bin/activate
	pip install --upgrade pip
	pip install --upgrade gitpython
}

function mountBuildEnv() {
	echo
	while [ $? -eq "0" ]
	do
		sudo umount "$POKY_BUILD_DIR"
	done

	sudo mount --bind "$BUILD_DIR" "$POKY_BUILD_DIR"
}

forcePython2

python checkout-repos.py

mountBuildEnv

cd "$START_PATH/poky"
copyLayers
copyConf "local.conf"

. ./oe-init-build-env


if [ $# -eq 1 ]; then
	if [ $1 = "build" ]; then
		nice bitbake "$IMAGE"
	fi
fi
