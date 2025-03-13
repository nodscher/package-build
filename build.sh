#!/bin/bash
set -e

# make upload area
mkdir packages

# build mesa
cd mesa
makepkg -s --noconfirm
# move packages to upload area
rm *debug*.pkg.tar.zst
mv *.pkg.tar.zst ../packages

# build lib32-mesa
cd ../lib32-mesa
makepkg -s --noconfirm
# move packages to upload area
rm *debug*.pkg.tar.zst
mv *.pkg.tar.zst ../packages