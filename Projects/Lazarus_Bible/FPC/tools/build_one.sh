#!/bin/sh
# Baut einzelne Projekte (z. B. beim Testen).
#   FPC/tools/build_one.sh <Name> [<Name> ...]
set -u
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT/FPC" || exit 1
for name in "$@"; do
    printf '%-16s ' "$name"
    if lazbuild --build-mode=Default "$name.lpi" >"/tmp/build_$name.log" 2>&1; then
        echo "OK"
    else
        echo "FEHLER"
        grep -E 'Error|Fatal' "/tmp/build_$name.log" | head -4 | sed 's/^/    /'
    fi
done
