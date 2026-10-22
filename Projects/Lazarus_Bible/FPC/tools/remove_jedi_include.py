"""Entfernt die ungenutzten Jedi-Einbindungen ({$i jedi.inc}).

Die Demos benutzen keine der Jedi-Makros; die Einbindung stammt aus den
Originalen und blockiert den Build (die Datei liegt nicht vor).
"""

import os
import re

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
SRC = os.path.join(ROOT, 'source')

pat = re.compile(r"[ \t]*\{\$i\s+jedi\.inc\}\r?\n", re.I)

for dirpath, dirnames, filenames in os.walk(SRC):
    for name in filenames:
        if not name.lower().endswith('.pas'):
            continue
        path = os.path.join(dirpath, name)
        with open(path, 'r', encoding='utf-8-sig', errors='replace') as fh:
            text = fh.read()
        new = pat.sub('', text)
        if new != text:
            with open(path, 'w', encoding='utf-8', errors='replace', newline='') as fh:
                fh.write(new)
            print('entfernt:', os.path.relpath(path, ROOT))
