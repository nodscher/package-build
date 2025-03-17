#!/bin/bash
set -e

# make upload area
mkdir packages

#build linux-mainline
cd linux-mainline
updpkgsums
makepkg -s --noconfirm
# move packages to upload area
mv *.pkg.tar.zst ../packages