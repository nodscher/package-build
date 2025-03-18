#!/bin/bash
set -e

STARTDIR=$(pwd)
[ -d repo ]
TEMPDIR=$(mktemp -dp .)
cd $TEMPDIR
git clone --recursive https://github.com/nodscher/package-build
cd package-build

build-mesa() {
    cd mesa
    ./build.sh
    repo-add -R $STARTDIR/repo/custom.db.tar.gz packages/*.pkg.tar.xz
}

build-linux-drm() {
    cd kernel
    ./build-drm.sh
    repo-add -R $STARTDIR/repo/custom.db.tar.gz packages/*.pkg.tar.xz
}

build-linux-mainline() {
    cd mesa
    ./build-mainline.sh
    repo-add -R $STARTDIR/repo/custom.db.tar.gz packages/*.pkg.tar.xz
}

if [[ $(basename $0) == build-mesa ]]; then
    build-mesa
elif [[ $(basename $0) == build-linux-drm ]]; then
    build-linux-drm
elif [[ $(basename $0) == build-linux-mainline ]]; then
    build-linux-mainline
else
    echo "Unknown function"
    cd $STARTDIR
    rm -r $TEMPDIR
    exit 1
fi


cd $STARTDIR
rm -r $TEMPDIR
