#!/bin/sh

sleep 1
for i in $hookdir/initqueue/finished/*.sh; do
    [ "$i" = "$hookdir/initqueue/finished/*.sh" ] && break
    [ -e $i ] && echo "true" > $i
done
