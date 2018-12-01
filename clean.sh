#!/bin/sh

set -e

cd "$(dirname "$(readlink -f "$0")")"

make -C "/lib/modules/`uname -r`/build" M="$(pwd)" clean

if quilt applied >/dev/null; then
	# just to be sure the path is good
	export QUILT_PATCHES=patches

	quilt pop -a
fi
