#!/bin/sh

set -e

cd "$(dirname "$(readlink -f "$0")")"

if quilt unapplied >/dev/null; then
	# just to be sure the path is good
	export QUILT_PATCHES=patches

	quilt push -a
fi

exec make -C "/lib/modules/`uname -r`/build" M="$(pwd)"
