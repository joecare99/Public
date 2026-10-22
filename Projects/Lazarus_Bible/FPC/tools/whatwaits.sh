#!/bin/sh
# Zeigt, worauf ein haengendes Programm wartet.
#   FPC/tools/whatwaits.sh <Programm> [Sekunden]
set -u
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT" || exit 1
PROG=$1
SECS=${2:-4}
"./bin/x86_64-linux/$PROG" >/tmp/ww_out.txt 2>&1 &
PID=$!
sleep "$SECS"
if kill -0 "$PID" 2>/dev/null; then
  echo "laeuft noch (pid $PID)"
  echo "wchan: $(cat /proc/$PID/wchan 2>/dev/null)"
  echo "--- Threads ---"
  for t in /proc/$PID/task/*; do
    echo "  tid $(basename "$t"): $(cat "$t/wchan" 2>/dev/null) $(head -1 "$t/stack" 2>/dev/null)"
  done
  echo "--- offene Dateien (Sockets/Locks) ---"
  ls -l /proc/$PID/fd 2>/dev/null | tail -8
  kill -9 $PID 2>/dev/null
else
  echo "beendet"
fi
cat /tmp/ww_out.txt
