#!/bin/sh
# Baut alle Lazarus-Projekte der Delphi-Bible und schreibt einen Bericht.
#
#   FPC/tools/build_all.sh [BuildMode]   (Default: Default)
#
# Ergebnis: build/build-report.txt mit einer Zeile je Projekt.

set -u

ROOT=$(cd "$(dirname "$0")/../.." && pwd)
MODE=${1:-Default}
LAZBUILD=${LAZBUILD:-lazbuild}
BUILDDIR="$ROOT/build"
REPORT="$BUILDDIR/build-report.txt"

mkdir -p "$BUILDDIR" "$BUILDDIR/logs"
: > "$REPORT"

ok=0
fail=0
failed=""

for lpi in "$ROOT"/FPC/*.lpi; do
    [ -e "$lpi" ] || continue
    name=$(basename "$lpi" .lpi)
    log="$BUILDDIR/logs/$name.log"
    if "$LAZBUILD" --build-mode="$MODE" "$lpi" >"$log" 2>&1; then
        ok=$((ok + 1))
        printf 'OK   %s\n' "$name" >>"$REPORT"
        printf '.'
    else
        fail=$((fail + 1))
        failed="$failed $name"
        printf 'FAIL %s\n' "$name" >>"$REPORT"
        grep -E 'Fatal|Error:|error:' "$log" | head -4 | sed 's/^/       /' >>"$REPORT"
        printf 'F'
    fi
    rm -f "$log.old"
done

{
    printf '\n'
    printf 'Build-Modus : %s\n' "$MODE"
    printf 'erfolgreich : %d\n' "$ok"
    printf 'fehlgeschlagen: %d\n' "$fail"
    if [ -n "$failed" ]; then
        printf 'fehlgeschlagen: %s\n' "$failed"
    fi
} >>"$REPORT"

echo
echo "OK: $ok   FEHLER: $fail   (Bericht: build/build-report.txt)"
[ "$fail" -eq 0 ] || exit 1
