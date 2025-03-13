#!/bin/bash
set -e

# make upload area
mkdir packages

# build mesa
cd mesa
updpkgsums
makepkg -s --noconfirm
# store mesa commit
MESA_COMMIT=$(cd src/mesa && git rev-parse HEAD)
# move packages to upload area
rm *debug*.pkg.tar.zst
mv *.pkg.tar.zst ../packages

# build lib32-mesa
cd ../lib32-mesa
updpkgsums
makepkg -s --noconfirm
# move packages to upload area
rm *debug*.pkg.tar.zst
mv *.pkg.tar.zst ../packages