"""Prueft, ob Units im aktuellen Baum fehlen (Vergleich mit einem Backup).

  python3 FPC/tools/check_missing_units.py <Backupordner>
"""

import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
UNIT_RE = re.compile(r'^\s*unit\s+([A-Za-z0-9_]+)\s*;', re.I | re.M)


def units_of(base):
    found = {}
    for dirpath, dirnames, filenames in os.walk(base):
        for name in filenames:
            if not name.lower().endswith('.pas'):
                continue
            path = os.path.join(dirpath, name)
            try:
                with open(path, 'r', encoding='utf-8-sig', errors='replace') as fh:
                    head = fh.read(4096)
            except OSError:
                continue
            m = UNIT_RE.search(head)
            if m:
                found.setdefault(m.group(1).lower(), []).append(
                    os.path.relpath(path, base))
    return found


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 1
    backup = os.path.abspath(sys.argv[1])
    old = units_of(backup)
    new = units_of(os.path.join(ROOT, 'source'))
    missing = sorted(k for k in old if k not in new)
    print('Units im Backup: %d, aktuell: %d' % (len(old), len(new)))
    if missing:
        print('FEHLENDE UNITS (%d):' % len(missing))
        for k in missing:
            print('   %s  (%s)' % (k, ', '.join(old[k])))
        return 1
    print('keine fehlenden Units')
    return 0


if __name__ == '__main__':
    sys.exit(main())
