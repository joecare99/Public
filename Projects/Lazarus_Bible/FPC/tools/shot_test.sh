#!/bin/sh
# Startet ein Programm im Screenshot-Modus (mit optionaler Seitenangabe).
#   FPC/tools/shot_test.sh <Name> [Zieldatei] [Seite]
set -u
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
NAME=$1
OUT=${2:-/tmp/$NAME.bmp}
PAGE=${3:-}
cd "$ROOT" || exit 1
rm -f "$OUT"
if [ -n "$PAGE" ]; then
    timeout 240 "./bin/x86_64-linux/$NAME" --screenshot "$OUT" "$PAGE"
else
    timeout 240 "./bin/x86_64-linux/$NAME" --screenshot "$OUT"
fi
RC=$?
if [ -f "$OUT" ]; then
    echo "Datei: $(stat -c %s "$OUT") Bytes"
else
    echo "keine Bilddatei erzeugt (rc=$RC)"
    exit 1
fi
