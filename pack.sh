#!/bin/sh

if [ ! $# -eq 2 ]; then
	echo "$0 <initrd img> <rootfs>"
	exit
fi

img=${1-initrd.img}
rootfs=${2-tmp}

cd $rootfs &&
find . | cpio -c -o | gzip -9 > ../$img
chmod +r ../$img
