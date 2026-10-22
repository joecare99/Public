#!/bin/sh
# Erzeugt Screenshots der Meta-App (eine je Seite).
#   FPC/tools/shots_meta.sh
set -u
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT" || exit 1
mkdir -p build/shots
for page in Ueberblick Code Verhalten Dateien Notizen; do
    sh FPC/tools/shot_test.sh BibleExplorer "/tmp/meta_$page.bmp" "$page" >/dev/null 2>&1
    if [ -f "/tmp/meta_$page.bmp" ]; then
        convert "/tmp/meta_$page.bmp" "build/shots/Meta_$page.png" 2>/dev/null &&
            echo "build/shots/Meta_$page.png"
    else
        echo "fehlt: $page"
    fi
done
