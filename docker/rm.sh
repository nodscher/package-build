#!/bin/bash
set -e

cd /buildzone/repo/custom
for item in $(find -name '*.pkg.tar.zst' -mtime +6 | sed -E 's#^\./##; s/(.*)-x86_64.pkg.tar.zst/\1/'); do 
    if [[ "$(tar --exclude='*/*' -tf custom.db.tar.zst | tr : _)" != *"$item"* ]]; then
        rm -f "$item"
    fi
done