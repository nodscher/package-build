#!/bin/bash
set -e

# make upload area
mkdir packages

# build mesa
cd mesa
updpkgsums
makepkg -s --noconfirm
# store mesa commit
export MESA_COMMIT="#commit=$(cd src/mesa && git rev-parse HEAD)"
# move packages to upload area
mv *.pkg.tar.zst ../packages

# build lib32-mesa
cd ../lib32-mesa
updpkgsums
makepkg -s --noconfirm
# move packages to upload area
mv *.pkg.tar.zst ../packages

# remove colons from names
cd ../packages
for file in *:*; do mv "$file" "${file//:/_}"; done

# go back to start directory
cd ..