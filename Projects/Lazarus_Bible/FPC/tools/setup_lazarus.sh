#!/bin/sh
# Registriert die von der Delphi-Bible benoetigten Lazarus-Pakete im
# Benutzerprofil, damit lazbuild sie findet.
#
#   FPC/tools/setup_lazarus.sh
#
# Wird einmal pro Linux-Installation ausgefuehrt.

set -u

LZR=${LZR:-/usr/lib/lazarus/4.4}

PACKAGES="
components/lazutils/lazutils.lpk
components/datetimectrls/datetimectrls.lpk
components/tachart/tachartlazaruspkg.lpk
components/printers/printer4lazarus.lpk
components/fpcunit/fpcunittestrunner.lpk
components/mouseandkeyinput/lazmouseandkeyinput.lpk
components/anchordocking/anchordocking.lpk
components/tdbf/dbflaz.lpk
components/lazreport/source/lazreport.lpk
components/sqlite/sqlite3laz.lpk
components/sqldb/sqldblaz.lpk
components/virtualtreeview/laz.virtualtreeview_package.lpk
components/synedit/synedit.lpk
"

for rel in $PACKAGES; do
    f="$LZR/$rel"
    if [ ! -f "$f" ]; then
        echo "fehlt    : $rel"
        continue
    fi
    if lazbuild --add-package-link "$f" >/dev/null 2>&1; then
        echo "registriert: $(basename "$f")"
    else
        echo "FEHLER   : $rel"
    fi
done
