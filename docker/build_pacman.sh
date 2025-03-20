#!/bin/bash
set -e

function cleanup() {
    echo "###Cleaning up###"
    cd $STARTDIR
    rm -rf $TEMPDIR
    echo "###Done###"
}
trap cleanup EXIT

echo "$(basename $0) $(date)"
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
    add-to-repo
}

build-linux-drm() {
    cd kernel
    ./build-drm.sh
    add-to-repo
}

build-linux-mainline() {
    cd kernel
    ./build-mainline.sh
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
