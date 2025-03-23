#!/bin/bash
set -e

function cleanup() {
    echo "###Cleaning up###"
    cd $STARTDIR
    rm -rf $TEMPDIR
    echo "###Done###"
}
trap cleanup EXIT

if [[ $(basename $0) == build-mesa ]]; then
    latest=$(git ls-remote https://gitlab.freedesktop.org/mesa/mesa.git HEAD | cut -c1-10)
    [[ "$(tar --exclude='*/*' -tf $STARTDIR/repo/custom/custom.db.tar.zst | grep mesa-git)" != *"$latest"* ]] || (echo mesa-git-$latest is already up to date; exit 1)
elif [[ $(basename $0) == build-linux-drm ]]; then
    latest=$(git ls-remote https://gitlab.freedesktop.org/drm/tip.git HEAD | cut -c1-9)
    [[ "$(tar --exclude='*/*' -tf $STARTDIR/repo/custom/custom.db.tar.zst | grep linux-drm-tip-git-)" != *"$latest"* ]] || (echo linux-drm-tip-git-$latest is already up to date; exit 1)
elif [[ $(basename $0) == build-linux-mainline ]]; then
    latest=$(cat kernel/linux-mainline/PKGBUILD | grep pkgver= | cut -d= -f2)
    [[ "$(tar --exclude='*/*' -tf $STARTDIR/repo/custom/custom.db.tar.zst | grep linux-mainline)" != *"$latest"* ]] || (echo linux-mainline-$latest is already up to date; exit 1)
else
    echo "Unknown function"
    exit 1
fi


echo "$(basename $0) $(date)"
sudo pacman -Syu --noconfirm
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
    build-linux-mainlin
fi
