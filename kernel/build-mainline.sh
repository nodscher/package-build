#!/bin/bash
set -e

# make upload area
mkdir packages

#build linux-mainline
cd linux-mainline
grep CONFIG_NTSYNC=m config || echo CONFIG_NTSYNC=m | tee -a config 
updpkgsums
makepkg -s --noconfirm
# move packages to upload area
mv *.pkg.tar.zst ../packages