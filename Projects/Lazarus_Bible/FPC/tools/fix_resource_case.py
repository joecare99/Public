"""Normalisiert die Formular-Ressourcen-Verweise auf die Kleinschreibung.

Free Pascal sucht die Datei hinter {$R *.lfm} unter Linux mit genau der
Schreibweise, die in der Direktive steht. Die Dateien im Archiv heissen
aber durchgehend klein (frm_x.lfm).
"""

import os
import re

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
SRC = os.path.join(ROOT, 'source')

pat = re.compile(r"(\{\$R\s+\*\.)([A-Za-z]+)(\})")

for dirpath, dirnames, filenames in os.walk(SRC):
    for name in filenames:
        if not name.lower().endswith('.pas'):
            continue
        path = os.path.join(dirpath, name)
        with open(path, 'r', encoding='utf-8-sig', errors='replace') as fh:
            text = fh.read()
        new = pat.sub(lambda m: m.group(1) + m.group(2).lower() + m.group(3), text)
        if new != text:
            with open(path, 'w', encoding='utf-8', errors='replace', newline='') as fh:
                fh.write(new)
            print('angepasst:', os.path.relpath(path, ROOT))
