#!/bin/sh

img=${1-initrd.img}
rootfs=${2-tmp}

rm -rf $rootfs
mkdir $rootfs && cd $rootfs
/usr/lib/dracut/skipcpio ../$img | gzip -d | cpio -idv
