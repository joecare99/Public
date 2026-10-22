"""Korrigiert die Unit-Namen nach dem Umbenennen kollidierender Units."""

import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
SRC = os.path.join(ROOT, 'source')
FPC = os.path.join(ROOT, 'FPC')

# Datei -> (alter Name, neuer Name)
FIXES = [
    ('source/TABS/TABS_Frm_ABOUT.pas', 'AboutEx_Frm_ABOUT', 'TABS_Frm_ABOUT'),
    ('source/TABS/TABS_Frm_ABOUT.lfm', 'AboutEx_Frm_ABOUT', 'TABS_Frm_ABOUT'),
    ('source/TABS/TABS_Frm_ABOUT.dfm', 'AboutEx_Frm_ABOUT', 'TABS_Frm_ABOUT'),
    ('source/TABS/Frm_TabsMAIN.pas', 'AboutEx_Frm_ABOUT', 'TABS_Frm_ABOUT'),
    ('source/TODO/TODO_Frm_ABOUT.pas', 'AboutEx_Frm_ABOUT', 'TODO_Frm_ABOUT'),
    ('source/TODO/TODO_Frm_ABOUT.lfm', 'AboutEx_Frm_ABOUT', 'TODO_Frm_ABOUT'),
    ('source/TODO/TODO_Frm_ABOUT.dfm', 'AboutEx_Frm_ABOUT', 'TODO_Frm_ABOUT'),
    ('source/TODO/Frm_TodoMAIN.pas', 'AboutEx_Frm_ABOUT', 'TODO_Frm_ABOUT'),
    ('FPC/Tabs.dpr', 'AboutEx_Frm_ABOUT', 'TABS_Frm_ABOUT'),
    ('FPC/Todo.dpr', 'AboutEx_Frm_ABOUT', 'TODO_Frm_ABOUT'),
]


def replace(path, old, new):
    full = os.path.join(ROOT, path)
    if not os.path.exists(full):
        print('fehlt:', path)
        return
    with open(full, 'r', encoding='utf-8-sig', errors='replace') as fh:
        text = fh.read()
    new_text = re.sub(r'\b%s\b' % re.escape(old), new, text)
    if new_text != text:
        with open(full, 'w', encoding='utf-8', errors='replace', newline='') as fh:
            fh.write(new_text)
        print('angepasst:', path)


for path, old, new in FIXES:
    replace(path, old, new)
