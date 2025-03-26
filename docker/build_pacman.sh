#!/bin/bash
set -e

STARTDIR=$(pwd)

if [[ $(basename $0) == build-mesa ]]; then
    latest=$(git ls-remote https://gitlab.freedesktop.org/mesa/mesa.git HEAD | cut -c1-10)
    [[ "$(tar --exclude='*/*' -tf $STARTDIR/repo/custom/custom.db.tar.zst | grep mesa-git)" != *"$latest"* ]] || (echo mesa-git-$latest is already up to date; exit 1)
elif [[ $(basename $0) == build-linux-drm ]]; then
    latest=$(git ls-remote https://gitlab.freedesktop.org/drm/tip.git HEAD | cut -c1-9)
    [[ "$(tar --exclude='*/*' -tf $STARTDIR/repo/custom/custom.db.tar.zst | grep linux-drm-tip-git-)" != *"$latest"* ]] || (echo linux-drm-tip-git-$latest is already up to date; exit 1)
elif [[ $(basename $0) == build-linux-mainline ]]; then
    #latest=$(cat kernel/linux-mainline/PKGBUILD | grep pkgver= | cut -d= -f2)
    latest=$(curl -s "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=linux-mainline" | sed -n -e 's/^pkgver=//p' -e 's/^pkgrel=//p' | paste -sd-)
    [[ "$(tar --exclude='*/*' -tf $STARTDIR/repo/custom/custom.db.tar.zst | grep linux-mainline)" != *"$latest"* ]] || (echo linux-mainline-$latest is already up to date; exit 1)
else
    echo "Unknown function"
    exit 1
fi


echo "$(basename $0) $(date)"
sudo pacman -Syu --noconfirm
[ -d repo ]
[ -d repo/custom ] || (sudo chown user:user ./repo && mkdir repo/custom)

function cleanup() {
    echo "###Cleaning up###"
    cd $STARTDIR
    rm -rf $TEMPDIR
    echo "###Done###"
}
trap cleanup EXIT

TEMPDIR=$(mktemp -dp .)
cd $TEMPDIR
git clone https://github.com/nodscher/package-build
cd package-build

build-mesa() {
    cd mesa
    ./build.sh
    add-to-repo
}

build-linux-drm() {
    cd kernel
    git submodule update --init --remote
    ./build-drm.sh
    add-to-repo
}

build-linux-mainline() {
    cd kernel
    git submodule update --init --remote
    ./build-mainline.sh
    add-to-repo
}

add-to-repo() {
    echo "###Adding packages to repo###"
    repo-add -R $STARTDIR/repo/custom/custom.db.tar.zst packages/*.pkg.tar.zst
    mv packages/*.pkg.tar.zst $STARTDIR/repo/custom/
}

$(basename $0)