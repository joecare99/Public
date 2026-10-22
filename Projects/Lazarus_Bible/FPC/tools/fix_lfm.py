"""Entfernt Eigenschaften aus einem LFM, die das LCL nicht kennt.

Der LCL kennt z. B. bei TLabel und TImage kein TabOrder - solche Zeilen
fuehren beim Laden des Formulars zu einem Fehler.

  python3 FPC/tools/fix_lfm.py <datei.lfm> [...]
"""

import os
import re
import sys

# Eigenschaften, die der LCL bei bestimmten Controls nicht kennt
INVALID = {
    'TLabel': ('TabOrder', 'BorderStyle'),
    'TImage': ('TabOrder', 'BorderStyle'),
    'TBevel': ('TabOrder', 'BorderStyle'),
    'TGroupBox': ('TabOrder',),
    'TPanel': ('TabOrder',),
}


def fix(text):
    lines = text.split('\n')
    out = []
    stack = []
    for line in lines:
        m = re.match(r"(\s*)object\s+(\w+):\s*(\w+)\s*$", line)
        if m:
            stack.append(m.group(3))
        elif re.match(r"(\s*)end\s*$", line):
            if stack:
                stack.pop()
        else:
            prop = re.match(r"\s*([A-Za-z_][A-Za-z0-9_]*)\s*=", line)
            if prop and stack:
                cls = stack[-1]
                if prop.group(1) in INVALID.get(cls, ()):
                    continue
        out.append(line)
    return '\n'.join(out)


def main():
    for path in sys.argv[1:]:
        with open(path, 'r', encoding='utf-8-sig', errors='replace') as fh:
            text = fh.read()
        new = fix(text)
        if new != text:
            with open(path, 'w', encoding='utf-8', errors='replace', newline='') as fh:
                fh.write(new)
            print('angepasst:', os.path.basename(path))
    return 0


if __name__ == '__main__':
    sys.exit(main())
