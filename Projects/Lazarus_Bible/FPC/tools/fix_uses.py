#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Repariert den uses-Abschnitt von Units, die mit einer aelteren Version von
port_units.py umgestellt wurden (Komma nach Direktive, doppeltes Semikolon).

  python3 FPC/tools/fix_uses.py [--check]
"""

import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
SRC = os.path.join(ROOT, 'source')

FIXES = [
    (re.compile(r'\{\$IFnDEF FPC\},\s*\r?\n'), '{$IFnDEF FPC}\n'),
    (re.compile(r'\{\$ELSE\},\s*\r?\n'), '{$ELSE}\n'),
    (re.compile(r',(\s*\r?\n\s*\{\$ENDIF\}\s*;)\s*\r?\n\s*;'), r'\1'),
    (re.compile(r'\{\$ENDIF\}\s*;\s*\r?\n\s*;'), '{$ENDIF};'),
]


def main():
    check = '--check' in sys.argv
    n = 0
    for folder in sorted(os.listdir(SRC)):
        d = os.path.join(SRC, folder)
        if not os.path.isdir(d):
            continue
        for name in sorted(os.listdir(d)):
            if not name.lower().endswith('.pas'):
                continue
            path = os.path.join(d, name)
            with open(path, 'r', encoding='utf-8', errors='replace', newline='') as fh:
                text = fh.read()
            new = text
            for rx, rep in FIXES:
                new = rx.sub(rep, new)
            if new != text:
                n += 1
                print('%-14s %s' % (folder, name))
                if not check:
                    with open(path, 'w', encoding='utf-8', errors='replace', newline='') as fh:
                        fh.write(new)
    print('%s %d Units' % ('geprueft:' if check else 'repariert:', n))
    return 0


if __name__ == '__main__':
    sys.exit(main())
