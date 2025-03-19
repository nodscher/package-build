#!/bin/bash
set -e

function cleanup() {
    cd $STARTDIR
    rm -rf $TEMPDIR
}
trap cleanup SIGINT SIGTERM SIGKILL EXIT


STARTDIR=$(pwd)
[ -d repo ]
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
    exit 1
fi