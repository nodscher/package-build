#!/bin/bash
set -e

function cleanup() {
    echo "###Cleaning up###"
    cd $STARTDIR
    rm -rf $TEMPDIR
    echo "###Done###"
}
trap cleanup EXIT


STARTDIR=$(pwd)
[ -d repo ]
[ -d repo/custom ] || (sudo chown user:user ./repo && mkdir repo/custom)
TEMPDIR=$(mktemp -dp .)
cd $TEMPDIR
git clone --recursive https://github.com/nodscher/package-build
cd package-build

build-mesa() {
    cd mesa
    ./build.sh
    rm -f $STARTDIR/repo/custom/*mesa-*.pkg.tar.zst $STARTDIR/repo/custom/*vulkan-*.pkg.tar.zst
    add-to-repo
}

build-linux-drm() {
    cd kernel
    ./build-drm.sh
    rm -f $STARTDIR/repo/custom/linux-drm-*.pkg.tar.zst
    add-to-repo
}

build-linux-mainline() {
    cd kernel
    ./build-mainline.sh
    rm -f $STARTDIR/repo/custom/linux-mainline-*.pkg.tar.zst
    add-to-repo
}

add-to-repo() {
    echo "###Adding packages to repo###"
    repo-add -R $STARTDIR/repo/custom/custom.db.tar.zst packages/*.pkg.tar.zst
    mv packages/*.pkg.tar.zst $STARTDIR/repo/custom/
}

if [[ $(basename $0) == build-mesa ]]; then
    build-mesa
elif [[ $(basename $0) == build-linux-drm ]]; then
    build-linux-drm
elif [[ $(basename $0) == build-linux-mainline ]]; then
    build-linux-mainline
else
    echo "Unknown function"
    exit 1
fi