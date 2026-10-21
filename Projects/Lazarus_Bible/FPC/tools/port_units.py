#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Wendet die Portierungs-Vorlage (siehe FPC/PORTING.md) mechanisch auf alle
Demo-Units in source/<Demo>/*.pas an.

  python3 FPC/tools/port_units.py           # Aenderungen schreiben
  python3 FPC/tools/port_units.py --check   # nur anzeigen

Vorgenommen wird:
  1. {$IFDEF FPC}{$MODE Delphi}{$ENDIF} als Unit-Kopf (falls fehlend)
  2. {$R *.dfm} -> bedingte Formular-Ressource {$R *.lfm} (FPC) / {$R *.dfm} (Delphi)
  3. uses-Abschnitt: Windows-spezifische Units werden in einen
     {$IFNDEF FPC} / {$ELSE}-Zweig verschoben, die FPC-Variante wird
     durch LCL-Ersatzunits ersetzt.

Nicht mechanisch erledigt werden: Aufrufe von Win32-Funktionen. Die
verbleibenden Compilerfehler zeigen sie einzeln auf.
"""

import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
SRC = os.path.join(ROOT, 'source')

# Windows-spezifische Units -> (Delphi-Unit, FPC-Ersatzunits)
WIN_ONLY = {
    'windows':      ('Windows',      ['LCLIntf', 'LCLType', 'LMessages']),
    'shellapi':     ('ShellAPI',     ['LCLIntf']),
    'winprocs':     ('WinProcs',     []),
    'wintypes':     ('WinTypes',     ['Messages']),
    'registry':     ('Registry',     ['LazUtils']),
    'comobj':       ('ComObj',       []),
    'comserv':      ('ComServ',      []),
    'ole2':         ('ole2',         []),
    'olecntrs':     ('OleCtnrs',     []),
    'olectrls':     ('OleCtrls',     []),
    'activex':      ('ActiveX',      []),
    'stdvcl':       ('StdVCL',       []),
    'variants':     ('Variants',     ['Variants']),
    'ddeman':       ('DdeMan',       ['BibleIpc']),
    'ddeconv':      ('DDEConv',      ['BibleIpc']),
    'ddeitem':      ('DDEItem',      ['BibleIpc']),
    'simpleipc':    ('simpleipc',    ['BibleIpc']),
    'sharemem':     ('ShareMem',     ['BibleIpc']),
    'mplayer':      ('MPlayer',      []),
    'quickrpt':     ('quickrpt',     []),
    'qrctrls':      ('Qrctrls',      []),
    'xpman':        ('XPMan',        []),
    'colorgrd':     ('ColorGrd',     ['ColorBox']),
    'tabs':         ('Tabs',         ['ComCtrls']),
    'mask':         ('Mask',         ['MaskEdit']),
    'chart':        ('Chart',        ['TAChart']),
    'series':       ('Series',       ['TAChart']),
    'teengine':     ('TeEngine',     ['TAChart']),
    'teeprocs':     ('TeeProcs',     ['TAChart']),
    'teecanvas':    ('TeCanvas',     ['TAChart']),
    'dbchart':      ('DBChart',      ['TAChart']),
    'jpeg':         ('jpeg',         ['LazJpg']),
    'jpeglib':      ('JPEGLib',      ['LazJpg']),
    'commctrl':     ('CommCtrl',     ['ComCtrls']),
    'dbtables':     ('DBTables',     ['db']),
    'sqldb':        ('sqldb',        ['sqldb', 'db']),
    'sqltable':     ('SQLTable',     ['sqltable', 'db']),
    'mysql56conn':  ('mysql56conn',  []),
    'mysql60conn':  ('mysql60conn',  []),
    'odbcconn':     ('odbcconn',     []),
}

MODE_BLOCK = '{$IFDEF FPC}\r\n  {$MODE Delphi}\r\n{$ENDIF}\r\n'


def read(path):
    with open(path, 'r', encoding='utf-8', errors='replace', newline='') as fh:
        return fh.read()


def write(path, text):
    with open(path, 'w', encoding='utf-8', errors='replace', newline='') as fh:
        fh.write(text)


def uses_block(text):
    """Liefert (start, end) des uses-Abschnitts der Unit-Schnittstelle."""
    m = re.search(r'(?is)\ninterface\b(.*?)\buses\b', text)
    if not m:
        return None
    start = m.end()
    # Ende des uses-Abschnitts: Semikolon auf Absatzebene
    i = start
    depth = 0
    while i < len(text):
        c = text[i]
        if c == '{':
            j = text.find('}', i)
            i = j + 1 if j > 0 else i + 1
            continue
        if c == '(' and text[i:i + 2] == '(*':
            j = text.find('*)', i)
            i = j + 2 if j > 0 else i + 1
            continue
        if c == ';':
            return (start, i)
        i += 1
    return None


def split_entries(block):
    """Zerlegt den uses-Block in Eintraege (Text, Unit-Name)."""
    entries = []
    cur = ''
    i = 0
    while i < len(block):
        c = block[i]
        if c == '{':
            j = block.find('}', i)
            if j < 0:
                j = len(block)
            cur += block[i:j + 1]
            i = j + 1
            continue
        if block[i:i + 2] == '(*':
            j = block.find('*)', i)
            if j < 0:
                j = len(block)
            cur += block[i:j + 2]
            i = j + 2
            continue
        if c == ',':
            entries.append(cur)
            cur = ''
            i += 1
            continue
        cur += c
        i += 1
    if cur.strip():
        entries.append(cur)
    return entries


def unit_of(entry):
    clean = re.sub(r'\{[^}]*\}', ' ', entry)
    clean = re.sub(r'\(\*.*?\*\)', ' ', clean, flags=re.S)
    m = re.match(r'\s*([A-Za-z_][A-Za-z0-9_]*)', clean)
    return m.group(1) if m else None


def indent_of(entry):
    m = re.match(r'\s*', entry)
    return m.group(0) if m else ''


def transform_uses(block):
    """Erzeugt den neuen uses-Block. Gibt (neuer Block, geaendert) zurueck."""
    if re.search(r'\{\s*\$IF', block):
        # bereits bedingt -> nicht anfassen
        return block, False
    entries = split_entries(block)
    system, delphi_only, fpc_only = [], [], []
    changed = False
    for e in entries:
        u = unit_of(e)
        if not u:
            system.append(e)
            continue
        key = u.lower()
        if key in WIN_ONLY:
            dname, fnames = WIN_ONLY[key]
            changed = True
            delphi_only.append(dname)
            fpc_only.extend(fnames)
        else:
            system.append(e)
    if not changed:
        return block, False

    out = []
    # System-Units zuerst (Reihenfolge bleibt erhalten)
    for e in system:
        t = e.strip()
        if t:
            out.append(indent_of(e) + t)
    if delphi_only or fpc_only:
        for e in system:
            pass
        out.append('{$IFnDEF FPC}')
        out.extend('  ' + u for u in delphi_only)
        out.append('{$ELSE}')
        out.extend('  ' + u for u in fpc_only)
        out.append('{$ENDIF}')
    # Kommas setzen: alle Eintraege ausser dem letzten Zweig-Eintrag
    lines = []
    for i, l in enumerate(out):
        t = l.rstrip()
        if t.startswith('{$'):
            lines.append(t)
            continue
        if i + 1 < len(out) and out[i + 1].startswith('{$ELSE}'):
            lines.append(t + ',')       # letzter Eintrag vor {$ELSE}
        elif i + 1 < len(out) and out[i + 1].startswith('{$ENDIF}'):
            lines.append(t)             # letzter Eintrag vor {$ENDIF}
        else:
            lines.append(t + ',')
    newblock = '\n' + '\n'.join(lines) + '\n'
    return newblock, True


def transform(text, path):
    changed = []

    # 1) Unit-Kopf
    if '{$MODE Delphi}' not in text and '{$mode delphi}' not in text:
        m = re.search(r'(?m)^(\s*unit\s+[A-Za-z0-9_]+\s*;\s*\r?\n)', text)
        if m:
            text = text[:m.end(1)] + MODE_BLOCK + text[m.end(1):]
            changed.append('mode')

    # 2) Formular-Ressource
    if re.search(r'\{\$R\s+\*\.dfm\}', text, re.I) and 'lfm' not in text.lower():
        text = re.sub(r'(?im)^(\s*)\{\$R\s+\*\.dfm\}\s*$',
                      r'\1{$IFnDEF FPC}' + '\n' + r'\1  {$R *.dfm}' + '\n' +
                      r'\1{$ELSE}' + '\n' + r'\1  {$R *.lfm}' + '\n' +
                      r'\1{$ENDIF}',
                      text)
        changed.append('resource')

    # 3) uses
    ub = uses_block(text)
    if ub:
        start, end = ub
        block = text[start:end]
        newblock, ch = transform_uses(block)
        if ch:
            text = text[:start] + newblock + text[end:]
            changed.append('uses')

    return text, changed


def main():
    check = '--check' in sys.argv
    touched = 0
    for folder in sorted(os.listdir(SRC)):
        d = os.path.join(SRC, folder)
        if not os.path.isdir(d):
            continue
        for name in sorted(os.listdir(d)):
            if not name.lower().endswith('.pas'):
                continue
            path = os.path.join(d, name)
            text = read(path)
            new, changed = transform(text, path)
            if not changed:
                continue
            touched += 1
            print('%-14s %-28s %s' % (folder, name, ','.join(changed)))
            if not check:
                write(path, new)
    print('%s %d Units' % ('geprueft:' if check else 'geaendert:', touched))
    return 0


if __name__ == '__main__':
    sys.exit(main())
