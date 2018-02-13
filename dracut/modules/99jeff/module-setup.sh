#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

check() {
    return 255
}

depends() {
    # We depend on network modules being loaded
    echo "sshd"
}

install() {
    sed -i "s%^ExecStart.*%ExecStart=/usr/bin/systemctl start test.service%g" \
		"$systemdsystemunitdir/initrd-cleanup.service"
    inst_script "$moddir/test.sh" "/sbin/test.sh"
    inst_multiple /etc/sysconfig/sshd
    inst_simple "$moddir/test.service" "$systemdsystemunitdir/test.service"
    inst_script "$moddir/initqueue-bypass-generator.sh" \
	$systemdutildir/system-generators/initqueue-bypass-generator.sh
    egrep '^root:' "/etc/shadow" 2>/dev/null >> "$initdir/etc/shadow"
}
