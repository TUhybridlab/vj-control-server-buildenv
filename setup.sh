#!/bin/sh

PYTHON2_ENV="env-python2"
IMAGE="image-vj-control-server"
CONF_DIR="build/conf"
BBLAYERS_FILE="bblayers.conf"

START_PATH=`pwd`

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

forcePython2

python checkout-repos.py

cd poky

copyLayers
copyConf "local.conf"

. ./oe-init-build-env


if [ $# -eq 1 ]; then
	if [ $1 = "build" ]; then
		nice bitbake "$IMAGE"
	fi
fi
