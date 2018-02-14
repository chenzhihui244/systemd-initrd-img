#!/bin/sh

#		--install "sshd" \
#		--install "sshd-keygen" \
#		--debug \
#		--keep \

function install_dracut_modules() {
	[ -d /lib/dracut/modules.d/98pam ] || cp -a dracut/modules/98pam /lib/dracut/modules.d/
	[ -d /lib/dracut/modules.d/98sshd ] || cp -a dracut/modules/98sshd /lib/dracut/modules.d/
	[ -d /lib/dracut/modules.d/99jeff ] || cp -a dracut/modules/99jeff /lib/dracut/modules.d/
}

function install_dependency() {
	yum install -y \
		coreutils \
		gawk \
		initscripts \
		net-tools \
		curl \
		openssh-server \
		openssh-clients \
		ipmitool \
		telnet \
		tftp \
		vim \
		ethtool \
		dmidecode \
		nmap-ncat \
		dos2unix \
		dracut \
		dracut-network \
		clevis-dracut \
		iscsi-initiator-utils \
		wget \
		pciutils \
		> /dev/null
}

function configure_dracut() {
	sed -i "s/#hostonly=\"yes\"/hostonly=\"no\"/g" /etc/dracut.conf
}

function mk_initrd() {
	dracut -M --gzip \
		--verbose \
		--modules "network" \
		--modules "bash" \
		--modules "nss-softokn" \
		--modules "ifcfg" \
		--modules "terminfo" \
		--modules "udev-rules" \
		--modules "i18n" \
		--modules "clevis" \
		--modules "base" \
		--modules "rescue" \
		--modules "shutdown" \
		--modules "usrmount" \
		--modules "systemd" \
		--modules "systemd-bootchart" \
		--modules "debug" \
		--modules "drm" \
		--modules "dm" \
		--modules "resume" \
		--modules "fs-lib" \
		--modules "shutdown" \
		--modules "rootfs-block" \
		--modules "kernel-modules" \
		--modules "plymouth" \
		--modules "jeff" \
		-f initrd.img
	chmod +r initrd.img
}

function grub_entry() {
	cat <<EOF >> grub.cfg
menuentry 'pxe initrd D05 test' --class gnu-linux --class gnu --class os {
	set root=(tftp,192.168.1.107)
	linux chenzhihui/pxeboot/vmlinuz \
	ip=eth0:dhcp \
	rd.info \
	rd.shell \
	console=tty0,115200 earlycon=hisilpcuart,mmio,0xa01b0000,0,0x2f8 \
	console=ttyAMA0
}
EOF
}

install_dependency
if [[ ! $? ]]; then
	echo "install_dependency failed"
	exit 1
fi

install_dracut_modules

configure_dracut
if [[ ! $? ]]; then
	echo "configure_dracut failed"
	exit 1
fi

mk_initrd
