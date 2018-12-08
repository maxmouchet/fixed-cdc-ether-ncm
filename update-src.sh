#!/bin/bash

set -e

cd "$(dirname "$(readlink -f "$0")")"

if [ -z "${HEAD}" -a -z "${REPO}" ]; then
	# assume stable kernel
	HEAD=v$(uname -v | egrep -o '[0-9]+\.[0-9]+\.[0-9]+')
	REPO=https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/
fi

# set default repo, overwrite through environment
: ${REPO:=https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git}
# ${REPO:=https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git}
# ${REPO:=https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git}

query=
if [ -n "${HEAD}" ]; then
	echo "Getting files for branch ${HEAD}"
	query="?h=${HEAD}"
fi

files=(
	drivers/net/usb/cdc_ether.c
	drivers/net/usb/cdc_mbim.c
	drivers/net/usb/cdc_ncm.c
	drivers/net/usb/usbnet.c
	include/linux/usb/usbnet.h
)

echo "Updating files from ${REPO}"
# cleanup current code
rm -rf include drivers .pc

for file in "${files[@]}"; do
	mkdir -p "$(dirname "${file}")"
	curl -q -o "${file}" "${REPO}/plain/${file}${query}"
done

echo "obj-y := net/" > drivers/Kbuild
echo "obj-y := usb/" > drivers/net/Kbuild

cat <<'EOF' > drivers/net/usb/Kbuild
obj-m += cdc_ether.o cdc_ncm.o cdc_mbim.o usbnet.o

# prepend path with locally modified headers
LINUXINCLUDE := -I$(M)/include $(LINUXINCLUDE)
EOF
