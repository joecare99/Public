#!/bin/sh
# Prueft, ob ein Programm laeuft (Fenster/Prozess).
#   FPC/tools/proc_alive.sh <Name> [Sekunden]
set -u
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT" || exit 1
NAME=$1
SECS=${2:-3}
"./bin/x86_64-linux/$NAME" >/tmp/pa_out.txt 2>&1 &
PID=$!
sleep "$SECS"
if kill -0 "$PID" 2>/dev/null; then
    echo "laeuft (pid $PID)"
    kill "$PID" 2>/dev/null
    wait "$PID" 2>/dev/null
else
    wait "$PID" 2>/dev/null
    echo "beendet (rc=$?)"
fi
cat /tmp/pa_out.txt
