#!/bin/sh
# Startet ein Demo im Screenshot-Modus und meldet das Ergebnis.
#   FPC/tools/shot_test.sh <Name> [Zieldatei]
set -u
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
NAME=$1
OUT=${2:-/tmp/$NAME.bmp}
cd "$ROOT" || exit 1
rm -f "$OUT"
timeout 20 "./bin/x86_64-linux/$NAME" --screenshot "$OUT"
RC=$?
echo "exitcode=$RC"
if [ -f "$OUT" ]; then
    echo "Datei: $(stat -c %s "$OUT") Bytes"
else
    echo "keine Bilddatei erzeugt"
fi
