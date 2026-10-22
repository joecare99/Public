"""Bringt Dateiname und Unit-Deklaration in Uebereinstimmung.

Free Pascal verlangt, dass der Dateiname der Unit-Deklaration entspricht
(unter Linux mit exakter Schreibweise). Das Werkzeug benennt abweichende
Dateien um und zieht die Formulardateien (.lfm/.dfm) mit.
"""

import os
import re

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
SRC = os.path.join(ROOT, 'source')

UNIT_RE = re.compile(r'^\s*unit\s+([A-Za-z0-9_]+)\s*;', re.I | re.M)

count = 0
for dirpath, dirnames, filenames in os.walk(SRC):
    for name in list(filenames):
        if not name.lower().endswith('.pas'):
            continue
        path = os.path.join(dirpath, name)
        with open(path, 'r', encoding='utf-8-sig', errors='replace') as fh:
            head = fh.read(4096)
        m = UNIT_RE.search(head)
        if not m:
            continue
        unit = m.group(1)
        stem = os.path.splitext(name)[0]
        if stem == unit:
            continue
        # Formulardateien zuerst umbenennen
        for ext in ('.lfm', '.dfm'):
            old = os.path.join(dirpath, stem + ext)
            if os.path.exists(old):
                os.rename(old, os.path.join(dirpath, unit + ext))
        target = os.path.join(dirpath, unit + '.pas')
        # Achtung: unter Windows ist der Dateivergleich case-insensitiv.
        # Deshalb den Ordnerinhalt pruefen und nur wirklich umbenennen.
        existing = None
        for entry in os.listdir(dirpath):
            if entry.lower() == (unit + '.pas').lower():
                existing = entry
                break
        if existing is None:
            os.rename(path, target)
        elif existing == name:
            # Nur die Schreibweise unterscheidet sich: ueber einen
            # Zwischennamen umbenennen, damit nichts verloren geht.
            tmp = os.path.join(dirpath, unit + '~tmp.pas')
            os.rename(path, tmp)
            os.rename(tmp, target)
        else:
            print('Konflikt (nicht geaendert): %s' % name)
            continue
        print('umbenannt: %s -> %s' % (name, unit + '.pas'))
        count += 1
print('umbenannt: %d' % count)
