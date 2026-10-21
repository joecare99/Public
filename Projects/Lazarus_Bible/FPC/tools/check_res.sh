#!/bin/sh
# Prueft, ob zu jedem Projekt die passende Ressourcendatei vorhanden ist.
set -u
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT/FPC" || exit 1
for f in *.lpr; do
    name=$(basename "$f" .lpr)
    if [ ! -f "$name.res" ]; then
        echo "fehlt: $name.res"
    fi
done
