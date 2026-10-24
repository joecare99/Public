"""Normalisiert die Dateiendungen der Pascal- und Formularquellen.

Free Pascal sucht Units unter Linux mit exakter Schreibweise; die
Endungen der Quelldateien muessen daher klein sein.
"""

import os

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
SRC = os.path.join(ROOT, 'source')
FPC = os.path.join(ROOT, 'FPC')

RENAMES = {
    '.PAS': '.pas', '.DFM': '.dfm', '.LFM': '.lfm', '.DPR': '.dpr',
    '.DPK': '.dpk', '.INC': '.inc', '.LPK': '.lpk', '.LPI': '.lpi',
    '.LPR': '.lpr', '.PAS': '.pas',
}

count = 0
for base in (SRC, FPC):
    for dirpath, dirnames, filenames in os.walk(base):
        for name in list(filenames):
            ext = os.path.splitext(name)[1]
            new_ext = RENAMES.get(ext.upper())
            if not new_ext or ext == new_ext:
                continue
            stem = os.path.splitext(name)[0]
            new_name = stem + new_ext
            old = os.path.join(dirpath, name)
            new = os.path.join(dirpath, new_name)
            # Achtung: unter Windows ist der Dateivergleich case-
            # insensitiv. Deshalb zuerst den Ordnerinhalt pruefen und
            # die Datei ueber einen Zwischenamen umbenennen.
            existing = None
            for entry in os.listdir(dirpath):
                if entry.lower() == new_name.lower():
                    existing = entry
                    break
            if existing is None:
                os.rename(old, new)
            elif existing == name:
                # Nur die Endung ist gross: ueber einen Zwischennamen
                # umbenennen, damit die Datei nicht verloren geht.
                tmp = os.path.join(dirpath, stem + '~tmp' + new_ext)
                os.rename(old, tmp)
                os.rename(tmp, new)
            else:
                # Es gibt bereits eine Datei mit dieser Endung (z. B.
                # 'x.pas' und 'x.PAS') - die grossgeschriebene Variante
                # wird entfernt.
                os.remove(old)
            print('umbenannt:', os.path.relpath(new, ROOT))
            count += 1
print('umbenannt: %d' % count)
