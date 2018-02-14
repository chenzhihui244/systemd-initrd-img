#!/bin/bash

echo "This is a test service script"
mkdir /tmp/test-pid-$$
_ctty=/dev/tty0
#exec /bin/sh -i -l
#setsid --ctty /bin/sh -i -l 0<>$_ctty 1<>$_ctty 2<>$_ctty

export DRACUT_SYSTEMD=1
if [ -f /dracut-state.sh ]; then
    . /dracut-state.sh 2>/dev/null
fi
type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

source_conf /etc/conf.d

type plymouth >/dev/null 2>&1 && plymouth quit

export _rdshell_name="dracut" action="Boot" hook="emergency"

source_hook "$hook"

[ -f /etc/profile ] && . /etc/profile
[ -z "$PS1" ] && export PS1="$_name:\${PWD}# "
exec sh -i -l
