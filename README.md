# Description

This is the build environment for minimal Linux images for the Jumpcube's
various *RaspberryPi 2* based controllers. This is the recommended way for getting
the controllers up and running. For development setup see the respective
repositories.

# Requirements

* Yocto compatible Linux distribution. For further information on this go to
  [Yocto Quickstart
  ](https://www.yoctoproject.org/docs/2.4.3/yocto-project-qs/yocto-project-qs.html)
  (section [The Linux Distribution
    ](https://www.yoctoproject.org/docs/2.4.3/yocto-project-qs/yocto-project-qs.html#the-linux-distro))
* A resonable fast PC (recommened: at least 4 threads and 8GB RAM)
* 30GB of free storage

# Available flavors

Currently the following flavors are available:

* `control-server` [Dimmer](https://github.com/j-be/vj-control-server)
* `aerome-scent-controller` [Vragrancer](https://github.com/j-be/vj-aerome-scent-controller)
* `servo-controller` [Maxon Motors EPOS servos](https://github.com/j-be/vj-servo-controller)
  * **Note:** To build the `servo-controller` flavor you need to manually find
    version 5.0.1.0 of the *EPOS Linux Library*, rename it to
    `EPOS-Linux-Library_5.0.1.0.zip` and put it in
    `poky/meta-vj/recipes-support/libEposCmd/files`.

# Build instructions

1. Go to
  [Yocto Quickstart
  ](https://www.yoctoproject.org/docs/2.4.3/yocto-project-qs/yocto-project-qs.html)
  and install the dependencies for your Linux distribution (section
  [The Build Host Packages
  ](https://www.yoctoproject.org/docs/2.4.3/yocto-project-qs/yocto-project-qs.html#packages))
1. Clone this repository and `cd` into it
1. Bootstrap the build environment: `source setup.sh`
1. Build the desired image: `bitbake image-vj-<flavor>`
1. The final SD-Card image can be found in
  `poky/build/tmp/deploy/images/raspberrypi2` as
  `image-vj-<flavor>-raspberrypi2-<timestamp>.rootfs.rpi-sdimg`
1. If you need to build another flavor goto (4)
