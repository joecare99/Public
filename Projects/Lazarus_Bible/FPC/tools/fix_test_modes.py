"""Entfernt doppelte Mode-Schalter in den Test-Units.

Die Automatik (port_units.py) hat den Delphi-Kopf ergaenzt, obwohl die
Test-Units bereits einen eigenen Mode-Schalter besitzen. Je Unit ist nur
ein Mode-Schalter erlaubt.
"""
import os
import re

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
TESTS = os.path.join(ROOT, 'source', 'tests')

head = re.compile(r"\{\$IFDEF FPC\}\s*\{\$MODE Delphi\}\s*\{\$ENDIF\}\s*", re.I)
any_mode = re.compile(r"\{\$(?:mode|MODE)\s+\w+", re.I)

for name in sorted(os.listdir(TESTS)):
    if not name.lower().endswith('.pas'):
        continue
    path = os.path.join(TESTS, name)
    with open(path, 'r', encoding='utf-8', errors='replace') as fh:
        text = fh.read()
    rest = head.sub('', text)
    if rest != text and any_mode.search(rest):
        with open(path, 'w', encoding='utf-8', errors='replace', newline='') as fh:
            fh.write(rest)
        print('bereinigt:', name)
