#!/bin/sh
# Baut die Meta-App (mit frischen Units) und startet sie kurz zur Kontrolle.
set -u
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT/FPC" || exit 1
rm -rf "$ROOT"/bin/x86_64-linux/units
rm -f "$ROOT"/bin/x86_64-linux/BibleExplorer
lazbuild --build-mode=Default meta/BibleExplorer.lpi >/tmp/meta_build.log 2>&1
if [ $? -ne 0 ]; then
    echo "Build FEHLER"
    grep -E 'Error|Fatal' /tmp/meta_build.log | head -6
    exit 1
fi
echo "Build OK"
cd "$ROOT" || exit 1
sh FPC/tools/shot_test.sh BibleExplorer /tmp/be3.bmp 2>&1 | tail -2
if [ -f /tmp/be3.bmp ]; then
    convert /tmp/be3.bmp build/shots/BibleExplorer.png && echo "Screenshot: build/shots/BibleExplorer.png"
fi
