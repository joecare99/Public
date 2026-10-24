"""Normalisiert die Unit-Verweise auf die tatsaechliche Schreibweise.

Delphi sucht Units ohne Rücksicht auf die Gross-/Kleinschreibung, Free
Pascal unter Linux dagegen schon. Dieses Werkzeug sammelt alle im Projekt
deklarierten Unit-Namen und ersetzt in den uses-Abschnitten alle Verweise
durch die deklarierte Schreibweise.

  python3 FPC/tools/fix_unit_refs.py [--check]
"""

import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
SRC = os.path.join(ROOT, 'source')
FPC = os.path.join(ROOT, 'FPC')

UNIT_RE = re.compile(r"^\s*unit\s+([A-Za-z0-9_]+)\s*;", re.I | re.M)
USES_RE = re.compile(r"(?is)\buses\b(.*?);")


def collect_declared():
    """Index: klein geschriebener Unit-Name -> deklarierte Schreibweise."""
    index = {}
    for dirpath, dirnames, filenames in os.walk(SRC):
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
                index.setdefault(m.group(1).lower(), m.group(1))
    return index


def fix_text(text, index):
    """Ersetzt Unit-Verweise in uses-Abschnitten durch die Schreibweise
    der Deklaration."""
    changed = False

    def fix_block(m):
        nonlocal changed
        block = m.group(1)

        def repl(um):
            nonlocal changed
            name = um.group(1)
            canonical = index.get(name.lower())
            if canonical and canonical != name:
                changed = True
                return um.group(0).replace(name, canonical)
            return um.group(0)

        new = re.sub(r"([A-Za-z_][A-Za-z0-9_]*)\s+(?=in\s+')", repl, block)
        # Units ohne 'in'-Angabe: nur ersetzen, wenn sie im Index stehen
        def repl2(um):
            nonlocal changed
            name = um.group(0)
            canonical = index.get(name.lower())
            if canonical and canonical != name:
                changed = True
                return canonical
            return name
        new = re.sub(r"(?<![A-Za-z0-9_'])([A-Za-z_][A-Za-z0-9_]*)", repl2, new)
        return m.group(0).replace(block, new)

    return USES_RE.sub(fix_block, text), changed


def main():
    check = '--check' in sys.argv
    index = collect_declared()
    files = []
    for dirpath, dirnames, filenames in os.walk(SRC):
        for name in filenames:
            if name.lower().endswith('.pas'):
                files.append(os.path.join(dirpath, name))
    for name in sorted(os.listdir(FPC)):
        if name.lower().endswith(('.dpr', '.lpr')):
            files.append(os.path.join(FPC, name))

    n = 0
    for path in files:
        with open(path, 'r', encoding='utf-8-sig', errors='replace') as fh:
            text = fh.read()
        new, changed = fix_text(text, index)
        if not changed:
            continue
        n += 1
        print('%s' % os.path.relpath(path, ROOT))
        if not check:
            with open(path, 'w', encoding='utf-8', errors='replace', newline='') as fh:
                fh.write(new)
    print('%s %d Dateien' % ('geprueft:' if check else 'angepasst:', n))
    return 0


if __name__ == '__main__':
    sys.exit(main())
