#!/bin/bash
set -e

# make upload area
mkdir packages

#build linux
cd linux-"$@"
wget https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/raw/main/config
mv -v config.1 config || true
updpkgsums
makepkg -s --noconfirm
# move packages to upload area
mv *.pkg.tar.zst ../packages