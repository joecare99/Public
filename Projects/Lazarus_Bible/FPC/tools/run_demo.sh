#!/bin/sh
# Startet ein gebautes Demo und prueft, ob es fehlerfrei laeuft.
#
#   FPC/tools/run_demo.sh <Name> [Sekunden]
#
# Exitcode: 0 = laeuft, 1 = Absturz/Fehler, 2 = nicht gefunden

set -u

NAME=${1:-}
SECS=${2:-4}
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
BIN="$ROOT/bin/x86_64-linux/$NAME"

if [ -z "$NAME" ]; then
    echo "usage: $0 <Name> [Sekunden]"
    exit 2
fi
if [ ! -x "$BIN" ]; then
    echo "nicht gefunden: $BIN"
    exit 2
fi

OUT=$(mktemp)
"$BIN" >"$OUT" 2>&1 &
PID=$!
sleep "$SECS"

if kill -0 "$PID" 2>/dev/null; then
    echo "$NAME: laeuft"
    kill "$PID" 2>/dev/null
    wait "$PID" 2>/dev/null
    if [ -s "$OUT" ]; then
        echo "--- Ausgabe ---"
        cat "$OUT"
    fi
    rm -f "$OUT"
    exit 0
else
    wait "$PID" 2>/dev/null
    RC=$?
    echo "$NAME: beendet (exitcode $RC)"
    echo "--- Ausgabe ---"
    cat "$OUT"
    rm -f "$OUT"
    exit 1
fi
