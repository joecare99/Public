"""Benennt eine Unit im ganzen Projekt um.

Mehrere Demos verwenden denselben Unit-Namen (z. B. Frm_ABOUT in AboutEx,
TABS und TODO). Unter Linux fuehrt das zu Verwechslungen, wenn ein Projekt
mehrere Demos sieht. Mit diesem Werkzeug werden Datei, Unit-Deklaration,
Verweise und Formulardateien angepasst.

  python3 FPC/tools/rename_unit.py <AlterName> <NeuerName> [--folder <Ordner>]

Ohne --folder wird die Unit in allen Demoordnern umbenannt (die Namen
müssen dort gleich lauten).
"""

import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
SRC = os.path.join(ROOT, 'source')
FPC = os.path.join(ROOT, 'FPC')


def find_files(old, folder=None):
    """Findet alle Dateien der Unit (pas, lfm, dfm)."""
    found = []
    for dirpath, dirnames, filenames in os.walk(SRC):
        demo = os.path.basename(dirpath)
        if folder and demo.lower() != folder.lower():
            continue
        for name in filenames:
            base = os.path.splitext(name)[0]
            if base.lower() == old.lower():
                found.append(os.path.join(dirpath, name))
    return found


def replace_in_file(path, old, new):
    with open(path, 'r', encoding='utf-8-sig', errors='replace') as fh:
        text = fh.read()
    new_text = re.sub(r'\b%s\b' % re.escape(old), new, text)
    if new_text != text:
        with open(path, 'w', encoding='utf-8', errors='replace', newline='') as fh:
            fh.write(new_text)
        return True
    return False


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        return 1
    old, new = sys.argv[1], sys.argv[2]
    folder = None
    if '--folder' in sys.argv:
        folder = sys.argv[sys.argv.index('--folder') + 1]

    files = find_files(old, folder)
    if not files:
        print('Unit nicht gefunden: %s' % old)
        return 1
    for path in files:
        ext = os.path.splitext(path)[1]
        stem = os.path.splitext(os.path.basename(path))[0]
        target = os.path.join(os.path.dirname(path), new + ext)
        if os.path.normcase(target) != os.path.normcase(path):
            os.rename(path, target)
            print('umbenannt:', os.path.relpath(target, ROOT))
        # Inhalt anpassen (Unit-Deklaration, Formularklasse, Verweise)
        replace_in_file(target, old, new)

    # Alle Verweise im Projekt anpassen
    changed = []
    for base in (SRC, FPC):
        for dirpath, dirnames, filenames in os.walk(base):
            for name in filenames:
                if not name.lower().endswith(('.pas', '.dpr', '.lpr', '.lfm', '.dfm')):
                    continue
                path = os.path.join(dirpath, name)
                if os.path.splitext(name)[0].lower() == new.lower():
                    continue
                if replace_in_file(path, old, new):
                    changed.append(os.path.relpath(path, ROOT))
    for path in changed:
        print('angepasst:', path)
    return 0


if __name__ == '__main__':
    sys.exit(main())
