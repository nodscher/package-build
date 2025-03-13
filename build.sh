#!/bin/bash
mkdir packages


cd mesa
makepkg -s --noconfirm

rm *debug*.pkg.tar.zst
mv *.pkg.tar.zst ../packages


cd ../lib32-mesa
makepkg -s --noconfirm

rm *debug*.pkg.tar.zst
mv *.pkg.tar.zst ../packages