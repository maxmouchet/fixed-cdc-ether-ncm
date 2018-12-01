#!/bin/bash

set -e

cd "$(dirname "$(readlink -f "$0")")"

patches=(
	# [v4,1/4] Use dev->intf to get interface information
	https://patchwork.kernel.org/patch/10501163/
	# [v3,2/4] Export usbnet_cdc_update_filter
	https://patchwork.kernel.org/patch/10498575/
	# [v3,3/4] Replace the way cdc_ncm hooks into usbnet_change_mtu
	https://patchwork.kernel.org/patch/10498577/
	# [v3,4/4] Hook into set_rx_mode to admit multicast traffic
	https://patchwork.kernel.org/patch/10498579/
)

find patches -mindepth 1 -name '*.diff' -delete
echo -n > "patches/series"

for ndx in "${!patches[@]}"; do
	echo "Fetching patch-${ndx}: ${patches[${ndx}]}"
	curl -q -o "patches/patch-${ndx}.diff" "${patches[${ndx}]}mbox/"
	echo "patch-${ndx}.diff" >> "patches/series"
done
