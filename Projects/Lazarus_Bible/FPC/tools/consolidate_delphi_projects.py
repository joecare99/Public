#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Bereinigt die Delphi-Projektdateien:

  * Die Versionsordner je Demo (source/<Demo>/2007, 2009, 2010, D_XE, old,
    2006, backup, __history) sind Legacy. Ihre Dateien werden in die
    Wurzelordner 2007/, 2009/, 2010/, D_XE/, 2006/ verschoben (bzw. dort
    belassen, wenn sie schon existieren) und die Ordner danach entfernt.
  * Die Verweise auf die Demo-Units werden an die neue Ablage angepasst
    (source/<Demo>/view/..., source/<Demo>/viewmodel/...).
  * Die Gruppen-Dateien (*.groupproj, *.bdsgroup) zeigen danach auf die
    Wurzelordner.

  python3 FPC/tools/consolidate_delphi_projects.py [--dry-run]
"""

import os
import re
import shutil
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
SRC = os.path.join(ROOT, 'source')

# Quellordner je Demo -> Zielordner im Wurzelverzeichnis
VERSION_MAP = {
    '2006': '2006',
    'old': '2006',
    '2007': '2007',
    '2009': '2009',
    '2010': '2010',
    'D_XE': 'D_XE',
}
# Ordner, die ersatzlos entfallen
DROP_DIRS = ('backup', '__history')

# Dateiendungen, die mit wandern
MOVE_EXT = ('.dpr', '.dproj', '.bdsproj', '.res')
# Projektdateien, die ebenfalls gebraucht werden
KEEP_EXT = ('.dpk', '.tlb', '.inc', '.ini', '.ridl', '.dll', '.ocx')
# Legacy-Duplikate des Demo-Quellcodes (liegen bereits in source/<Demo>/)
DROP_EXT = ('.pas', '.dfm', '.lfm')


def find_existing(target_dir, name):
    """Sucht case-insensitiv nach einer Datei (Windows-Kollisionen!)."""
    if os.path.exists(os.path.join(target_dir, name)):
        return name
    low = name.lower()
    for existing in os.listdir(target_dir):
        if existing.lower() == low:
            return existing
    return None


def build_unit_index():
    """Index: dateiname (klein) -> relativer Pfad, je Demo und global."""
    index = {}
    global_index = {}
    for demo in sorted(os.listdir(SRC)):
        d = os.path.join(SRC, demo)
        if not os.path.isdir(d) or demo.startswith('_') or demo == 'tests':
            continue
        units = {}
        for dirpath, dirnames, filenames in os.walk(d):
            for name in filenames:
                if name.lower().endswith('.pas'):
                    rel = os.path.relpath(os.path.join(dirpath, name), SRC)
                    units[name.lower()] = rel.replace('\\', '/')
                    global_index.setdefault(name.lower(), rel.replace('\\', '/'))
        index[demo.lower()] = units
    return index, global_index


def fix_unit_paths(text, demo, index, global_index):
    """Ersetzt 'source\\<Demo>\\...\\<unit>.pas' durch den tatsaechlichen Pfad."""
    units = index.get(demo.lower(), {})

    def repl(m):
        prefix, tail = m.group(1), m.group(2)
        base = os.path.basename(tail.replace('\\', '/')).lower()
        rel = units.get(base) or global_index.get(base)
        if rel is None:
            return m.group(0)
        return prefix + 'source\\' + rel.replace('/', '\\')
    pat = re.compile(r'(?i)((?:\.\.[\\/])*)source[\\/]([^\s"\'<>]*?\.pas)')
    return pat.sub(repl, text)


def fix_local_paths(text, demo, index):
    """Ersetzt '..\\<unit>.pas' (Unit im Demoordner) durch den neuen Pfad."""
    units = index.get(demo.lower(), {})

    def repl(m):
        name = m.group(1)
        rel = units.get(name.lower())
        if rel is None:
            return m.group(0)
        return '..\\source\\' + rel.replace('/', '\\')

    pat = re.compile(r'(?i)\.\.[\\/]([A-Za-z0-9_]+\.pas)')
    return pat.sub(repl, text)


def main():
    dry = '--dry-run' in sys.argv
    index, global_index = build_unit_index()
    moved = deleted = fixed = 0

    # 1) Versionsordner je Demo aufloesen
    for demo in sorted(os.listdir(SRC)):
        d = os.path.join(SRC, demo)
        if not os.path.isdir(d) or demo.startswith('_') or demo == 'tests':
            continue
        for sub in sorted(os.listdir(d)):
            subpath = os.path.join(d, sub)
            if not os.path.isdir(subpath):
                continue
            if sub in DROP_DIRS:
                print('  entferne  %s/%s (Legacy)' % (demo, sub))
                if not dry:
                    shutil.rmtree(subpath)
                deleted += 1
                continue
            if sub not in VERSION_MAP:
                continue
            target_dir = os.path.join(ROOT, VERSION_MAP[sub])
            if not os.path.isdir(target_dir):
                os.makedirs(target_dir)
            for name in sorted(os.listdir(subpath)):
                src_file = os.path.join(subpath, name)
                if not os.path.isfile(src_file):
                    continue
                ext = os.path.splitext(name)[1].lower()
                existing = find_existing(target_dir, name)
                if ext in DROP_EXT:
                    # Legacy-Duplikat des Demo-Quellcodes
                    if not dry:
                        os.remove(src_file)
                    continue
                if ext not in MOVE_EXT and ext not in KEEP_EXT:
                    # .cfg/.stat sind IDE-Reste und entfallen
                    if not dry:
                        os.remove(src_file)
                    continue
                if existing is not None:
                    if not dry:
                        os.remove(src_file)
                    continue
                with open(src_file, 'r', encoding='utf-8', errors='replace') as fh:
                    text = fh.read()
                text = fix_local_paths(text, demo, index)
                with open(os.path.join(target_dir, name), 'w',
                          encoding='utf-8', errors='replace', newline='') as fh:
                    fh.write(text)
                print('  verschiebe %s/%s/%s -> %s/%s' % (demo, sub, name, VERSION_MAP[sub], name))
                if not dry:
                    os.remove(src_file)
                moved += 1
            # Ordner restlos entfernen (inkl. __history-Resten)
            try:
                if os.path.isdir(subpath):
                    if not dry:
                        shutil.rmtree(subpath)
                    print('  entferne  %s/%s' % (demo, sub))
                    deleted += 1
            except OSError:
                pass

    # 2) Verweise in den Wurzel-Versionordnern korrigieren
    for sub in sorted(set(list(VERSION_MAP.values()) + ['D24', 'D25', 'DXE2'])):
        target_dir = os.path.join(ROOT, sub)
        if not os.path.isdir(target_dir):
            continue
        for name in sorted(os.listdir(target_dir)):
            path = os.path.join(target_dir, name)
            if not os.path.isfile(path):
                continue
            if os.path.splitext(name)[1].lower() not in ('.dpr', '.dproj', '.bdsproj'):
                continue
            with open(path, 'r', encoding='utf-8', errors='replace') as fh:
                text = fh.read()
            new = text
            for demo in index:
                new = fix_unit_paths(new, demo, index, global_index)
            if new != text:
                print('  Pfade    %s/%s' % (sub, name))
                if not dry:
                    with open(path, 'w', encoding='utf-8', errors='replace', newline='') as fh:
                        fh.write(new)
                fixed += 1

    # 3) Gruppen-Dateien auf die Wurzelordner umstellen
    for name in sorted(os.listdir(ROOT)):
        if not (name.endswith('.groupproj') or name.endswith('.bdsgroup')):
            continue
        path = os.path.join(ROOT, name)
        with open(path, 'r', encoding='utf-8', errors='replace') as fh:
            text = fh.read()
        new = re.sub(r'(?i)source[\\/][^\\/"]+[\\/](2006|2007|2009|2010|D_XE)[\\/]', r'\1\\', text)
        new = re.sub(r'(?i)source[\\/][^\\/"]+[\\/]([A-Za-z0-9_]+\.bdsproj)', r'2006\\\1', new)
        if new != text:
            print('  Gruppe   %s' % name)
            if not dry:
                with open(path, 'w', encoding='utf-8', errors='replace', newline='') as fh:
                    fh.write(new)
            fixed += 1

    print('verschoben: %d  entfernt: %d  angepasst: %d%s' %
          (moved, deleted, fixed, '  (Probelauf)' if dry else ''))
    return 0


if __name__ == '__main__':
    sys.exit(main())
