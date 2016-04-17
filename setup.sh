#!/bin/sh

PYTHON2_ENV="env-python2"
PYTHON_VERSION=`python -c "import sys; print(\"%i\" % sys.version_info[0])"`
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
	if [ $PYTHON_VERSION -ne "27" ]; then
		if [ ! -d $PYTHON2_ENV ]; then
			virtualenv2 $PYTHON2_ENV
		fi
		. $PYTHON2_ENV/bin/activate
		pip install gitpython
	fi
}

forcePython2

python checkout-repos.py

cd poky

copyLayers
copyConf "local.conf"

. ./oe-init-build-env


if [ $# -eq 1 ]; then
	if [ $1 = "build" ]; then
		bitbake "$IMAGE"
	fi
fi
