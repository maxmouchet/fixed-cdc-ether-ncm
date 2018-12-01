Build fixed `cdc_ether` and `cdc_ncm` modules for current kernel after
applying patches with quilt:

	./build.sh

Other scripts:

- `./clean.sh`: clean (with current kernel), then remove all patches with quilt
- `./update-src.sh`: fetch current sources from upstream repo
- `./update-patches.sh`: fetch patches from mails
