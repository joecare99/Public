#!/bin/sh
# Zeigt die Fensterliste waehrend ein Demo laeuft (zur Fehlersuche).
#   FPC/tools/windows_of.sh <Name> [Sekunden]
set -u
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
NAME=$1
SECS=${2:-4}
cd "$ROOT" || exit 1
"./bin/x86_64-linux/$NAME" >/tmp/win_out.txt 2>&1 &
PID=$!
sleep "$SECS"
echo "--- Fenster ---"
xwininfo -root -children 2>/dev/null | grep -E '0x[0-9a-f]+' | sed 's/^/   /'
echo "--- Ausgabe ---"
cat /tmp/win_out.txt
kill $PID 2>/dev/null
