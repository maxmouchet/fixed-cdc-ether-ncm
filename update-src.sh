#!/bin/bash

set -e

cd "$(dirname "$(readlink -f "$0")")"

# set default repo, overwrite through environment
: ${REPO:=https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git}
# ${REPO:=https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git}
# ${REPO:=https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git}

files=(
	drivers/net/usb/cdc_ether.c
	drivers/net/usb/cdc_mbim.c
	drivers/net/usb/cdc_ncm.c
	include/linux/usb/usbnet.h
)

echo "Updating files from ${REPO}"
# cleanup current code
rm -rf include drivers .pc

for file in "${files[@]}"; do
	mkdir -p "$(dirname "${file}")"
	curl -q -o "${file}" "${REPO}/plain/${file}"
done

echo "obj-y := net/" > drivers/Kbuild
echo "obj-y := usb/" > drivers/net/Kbuild

cat <<'EOF' > drivers/net/usb/Kbuild
obj-m += cdc_ether.o cdc_ncm.o cdc_mbim.o

# prepend path with locally modified headers
LINUXINCLUDE := -I$(M)/include $(LINUXINCLUDE)
EOF
