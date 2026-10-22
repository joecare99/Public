#!/bin/sh
cd /mnt/d/Projekte/Delphi/Delphi_Bible
lazbuild --build-mode=Default FPC/demo_smoke.lpi > /tmp/smoke.log 2>&1
grep -E "Error|Fatal" /tmp/smoke.log | head -3
BIN=$(ls bin/x86_64-linux/demo_smoke 2>/dev/null)
if [ -z "$BIN" ]; then
  echo NOBINARY
  exit 1
fi
./bin/x86_64-linux/demo_smoke 2>/dev/null
