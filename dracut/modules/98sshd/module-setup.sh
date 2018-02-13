#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

check() {
    # If our prerequisites are not met, fail anyways.
    require_any_binary sshd || return 1

    return 255
}

depends() {
    echo pam
}

install() {
    inst_dir /var/empty/sshd
    inst_multiple /usr/sbin/sshd /usr/sbin/sshd-keygen
    inst_multiple "$systemdsystemunitdir"/sshd-keygen.service \
	    "$systemdsystemunitdir"/sshd.service \
	    "$systemdsystemunitdir"/sshd.socket
    mkdir -p "$initdir/$systemdsystemunitdir/initrd.target.wants"
    ln_r "$systemdsystemunitdir/sshd.service" \
	"$systemdsystemunitdir/initrd.target.wants/sshd.service"
    inst_multiple /etc/ssh/*
    chmod 0600 $initdir/etc/ssh/ssh_host_rsa_key
    chmod 0600 $initdir/etc/ssh/ssh_host_ecdsa_key
    chmod 0600 $initdir/etc/ssh/ssh_host_ed25519_key
    sed -i "s/^#PermitRootLogin.*/PermitRootLogin yes/g" $initdir/etc/ssh/sshd_config

    egrep '^sshd:' "/etc/passwd" 2>/dev/null >> "$initdir/etc/passwd"
    egrep '^sshd:' "/etc/group" >> "$initdir/etc/group"
}
