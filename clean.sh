#!/bin/sh

set -e

cd "$(dirname "$(readlink -f "$0")")"

make -C "/lib/modules/`uname -r`/build" M="$(pwd)" clean

# just to be sure the path is good
export QUILT_PATCHES=patches

if quilt applied >/dev/null; then
	quilt pop -a
fi
