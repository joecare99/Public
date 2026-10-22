"""Setzt fuer die .lpi der Meta-App einen eigenen Unit-Ausgabeordner.

Die Demos teilen sich teilweise Unit-Namen; ein gemeinsamer Unit-Ordner
fuehrt dann zu Fehlern. Jedes Projekt bekommt deshalb sein eigenes
Unterverzeichnis.
"""

import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
LPI = os.path.join(ROOT, 'FPC', 'meta', 'BibleExplorer.lpi')

with open(LPI, 'r', encoding='utf-8', errors='replace') as fh:
    text = fh.read()

text = text.replace(
    '<UnitOutputDirectory Value="../../bin/$(TargetCPU)-$(TargetOS)/units"/>',
    '<UnitOutputDirectory Value="../../bin/$(TargetCPU)-$(TargetOS)/units/BibleExplorer"/>')

with open(LPI, 'w', encoding='utf-8', errors='replace', newline='') as fh:
    fh.write(text)

print('angepasst:', os.path.relpath(LPI, ROOT))
