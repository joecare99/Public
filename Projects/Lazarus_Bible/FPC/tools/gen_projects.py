#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Erzeugt die Lazarus-Projekte der Delphi-Bible aus den vorhandenen
Delphi-Programmdateien (.dpr) und dem gemeinsamen Quellbaum in source/.

  python3 FPC/tools/gen_projects.py            # .lpr/.lpi/.lpg erzeugen
  python3 FPC/tools/gen_projects.py --check    # nur vergleichen, nichts schreiben

Grundsaetze:
  * Der Quellcode bleibt dual-mode: source/<Demo>/*.pas wird von Delphi und
    von Lazarus gemeinsam benutzt, FPC/ enthaelt nur die Projektdateien.
  * Alle Pfade in den erzeugten .lpi sind Linux-/Windows-tauglich ('/').
  * Die Delphi-Programme (.dpr) bleiben unangetastet.

Aufruf aus dem Repository-Wurzelverzeichnis oder mit Pfadargument.
"""

import os
import re
import sys
import json

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
FPC = os.path.join(ROOT, 'FPC')
SRC = os.path.join(ROOT, 'source')

# Verzeichnisse in source/, die keine eigenstaendige Demo sind
SKIP_DIRS = {'tests', '_core'}

# Scope-Unterordner innerhalb einer Demo (MVVM-Aufteilung)
SCOPE_DIRS = ('view', 'viewmodel', 'model', 'services', 'support')

# Lazarus-/LCL-Pakete, die eine Demo benoetigt -> Package-Name fuer die .lpi
PACKAGE_BY_UNIT = {
    'datetimepicker': 'DateTimeCtrls',
    'dateutilities': 'DateTimeCtrls',
    'tachart': 'TAChartLazarusPkg',
    'printersdlgs': 'Printer4Lazarus',
    'lconvencoding': 'LazUtils',
    'fileutil': 'LazUtils',
    'lazfileutils': 'LazUtils',
    'lazutf8': 'LazUtils',
    'laz_avif_tree': 'LazUtils',
    'guitestrunner': 'FPCUnitTestRunner',
    'lazmouseandkeyinput': 'LazMouseAndKeyInput',
    'anchordocking': 'AnchorDocking',
    'dbf': 'DBFLaz',
    'lazreport': 'lazreport',
    'sqlite3conn': 'sqlite3laz',
    'sqldb': 'SQLDBLaz',
    'virtualtreeview': 'laz.virtualtreeview_package',
    'synedit': 'SynEdit',
    # nicht verfuegbar unter Linux -> Portierungsaufgabe
    'quickrpt': None,
    'qrctrls': None,
    'bgracontrols': None,
    'lazactivex': None,
    'printer4lazarus': None,
    'ddeconv': None,
    'ddeman': None,
    'chart': None,
    'series': None,
    'teengine': None,
    'teeprocs': None,
}

# eigene Pakete des Projektes
LOCAL_PACKAGES = {
    'barchart': 'BarChartp',
    'ctrl_dingbutton': 'DingPkg',
}

UNIT_RE = re.compile(r"^\s*([A-Za-z_][A-Za-z0-9_]*)\s*(?:in\s+'([^']+)')?", re.I)
CREATEFORM_RE = re.compile(r"Application\.CreateForm\s*\(\s*([A-Za-z0-9_]+)\s*,\s*([A-Za-z0-9_]+)\s*\)", re.I)


def strip_directives(text):
    """Entfernt die Direktiven {...} und //-Kommentare. Der Inhalt
    bedingter Bloecke bleibt erhalten, damit auch die Units des
    FPC-Zweigs erkannt werden."""
    text = re.sub(r"\{\$[^{}]*\}", ' ', text)
    text = re.sub(r"//[^\n]*", ' ', text)
    text = re.sub(r"\(\*.*?\*\)", ' ', text, flags=re.S)
    return text


def parse_uses(text):
    """Liefert die Units aus dem uses-Abschnitt."""
    m = re.search(r"\buses\b(.*?);", strip_directives(text), re.S | re.I)
    if not m:
        return []
    out = []
    for entry in m.group(1).split(','):
        em = UNIT_RE.match(entry.strip())
        if em:
            out.append((em.group(1), em.group(2)))
    return out


def parse_create_forms(text):
    return [(m.group(1), m.group(2)) for m in CREATEFORM_RE.finditer(strip_directives(text))]


def source_folders():
    """Alle Demoordner in source/ mit their tatsaechlichen Namen."""
    return [d for d in sorted(os.listdir(SRC))
            if os.path.isdir(os.path.join(SRC, d)) and d not in SKIP_DIRS]


def resolve_folder(name):
    """Findet den Ordner source/<name> case-insensitiv."""
    if not name:
        return None
    for d in source_folders():
        if d.lower() == name.lower():
            return d
    return None


def folder_of_source_path(path):
    """'..\\source\\HELLO\\frm_X.pas' -> 'HELLO'"""
    parts = re.split(r"[\\/]", path)
    if 'source' in [p.lower() for p in parts]:
        i = [p.lower() for p in parts].index('source')
        if i + 1 < len(parts):
            return parts[i + 1]
    return None


def unit_name_of_file(path):
    """Liest den Unit-Namen aus der Datei (Gross-/Kleinschreibung wie in der Datei)."""
    full = os.path.join(SRC, path)
    try:
        with open(full, 'r', encoding='utf-8-sig', errors='replace') as fh:
            head = fh.read(4096)
    except OSError:
        return None
    m = re.search(r"^\s*unit\s+([A-Za-z0-9_]+)\s*;", head, re.I | re.M)
    return m.group(1) if m else None


def collect_units(folder, referenced):
    """Alle Units einer Demo (inkl. ihrer Scope-Unterordner)."""
    units = []
    # Reihenfolge: der Demoordner selbst, danach die Scope-Ordner
    subdirs = [''] + [s for s in SCOPE_DIRS
                       if os.path.isdir(os.path.join(SRC, folder, s))]
    for sub in subdirs:
        d = os.path.join(SRC, folder, sub) if sub else os.path.join(SRC, folder)
        if not os.path.isdir(d):
            continue
        for name in sorted(os.listdir(d)):
            if not name.lower().endswith('.pas'):
                continue
            base = name[:-4]
            lfm = os.path.join(d, base + '.lfm')
            dfm = os.path.join(d, base + '.dfm')
            full = os.path.join(d, name)
            uname = unit_name_of_file(os.path.join(folder, os.path.join(sub, name)))
            if uname is None:
                continue
            with open(full, 'r', encoding='utf-8-sig', errors='replace') as fh:
                text = fh.read()
            used = [u.lower() for u, _ in parse_uses(text)]
            rel = (folder + '/' + sub + '/' + name) if sub else (folder + '/' + name)
            units.append({
                'name': uname,
                'file': name,
                'path': '../source/%s' % rel,
                'form': os.path.exists(lfm) or os.path.exists(dfm),
                'referenced': uname.lower() in referenced,
                'uses': used,
            })
    # Referenzierte Units zuerst, dann die restlichen (alphabetisch)
    units.sort(key=lambda u: (not u['referenced'], u['name'].lower()))
    return units


UNIT_CACHE = {}


def all_demo_units():
    """Index aller Units aller Demos: klein geschriebener Name -> Unit."""
    if UNIT_CACHE:
        return UNIT_CACHE
    for demo in source_folders():
        for name in sorted(os.listdir(os.path.join(SRC, demo))):
            if not name.lower().endswith('.pas'):
                continue
            base = name[:-4]
            uname = unit_name_of_file(os.path.join(demo, name))
            if uname is None:
                continue
            full = os.path.join(SRC, demo, name)
            with open(full, 'r', encoding='utf-8-sig', errors='replace') as fh:
                text = fh.read()
            used = [u.lower() for u, _ in parse_uses(text)]
            UNIT_CACHE[uname.lower()] = {
                'name': uname,
                'file': name,
                'path': '../source/%s/%s' % (demo, name),
                'form': os.path.exists(os.path.join(SRC, demo, base + '.lfm')) or
                        os.path.exists(os.path.join(SRC, demo, base + '.dfm')),
                'referenced': True,
                'uses': used,
            }
    return UNIT_CACHE


def find_demo_units(names):
    """Sucht die genannten Units in allen Demoordnern und liefert die
    gefundenen Units samt Ordner zurueck."""
    wanted = set(n.lower() for n in names)
    cache = all_demo_units()
    found = []
    for name in wanted:
        u = cache.get(name)
        if u is not None:
            found.append(dict(u))
    return found


def units_for_project(units, referenced_names):
    """Projekt-Units: die im Programm verwendeten Units plus die von ihnen
    benutzten Units derselben Demo (damit ViewModel/Model im IDE sichtbar
    sind, ohne fremde Demos mitzuziehen)."""
    by_name = {u['name'].lower(): u for u in units}
    chosen = []
    queue = [n.lower() for n in referenced_names]
    seen = set()
    while queue:
        name = queue.pop(0)
        if name in seen:
            continue
        seen.add(name)
        u = by_name.get(name)
        if u is None:
            continue
        chosen.append(u)
        for used in u.get('uses', []):
            if used in by_name and used not in seen:
                queue.append(used)
    # Formular-Units der Demo, die das Programm erzeugt, gehoeren immer dazu
    for u in units:
        if u['form'] and u['name'].lower() in seen:
            continue
    chosen.sort(key=lambda u: (not u['referenced'], u['name'].lower()))
    return chosen


def packages_for(units, extra_text=''):
    """Ermittelt benoetigte Lazarus-Pakete anhand der verwendeten Units."""
    pkgs = ['LCL']
    used = set()
    for u in units:
        used.update(u.get('uses', []))
    haystack = ' '.join(used) + ' ' + extra_text.lower()
    for unit, pkg in PACKAGE_BY_UNIT.items():
        if pkg and re.search(r'\b%s\b' % re.escape(unit), haystack):
            if pkg not in pkgs:
                pkgs.append(pkg)
    for unit, pkg in LOCAL_PACKAGES.items():
        if re.search(r'\b%s\b' % re.escape(unit), haystack) and pkg not in pkgs:
            pkgs.append(pkg)
    return pkgs


def xml_escape(s):
    return (s.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')
             .replace('"', '&quot;'))


def build_lpr(name, units, create_forms, extra_uses, title, has_res):
    """Erzeugt die Lazarus-Hauptprogrammdatei."""
    uses = []
    uses.append('  {$IFDEF UNIX}{$IFDEF UseCThreads}')
    uses.append('  cthreads,')
    uses.append('  {$ENDIF}{$ENDIF}')
    uses.append('  Interfaces,')
    uses.append('  Forms,')
    uses.append('  SysUtils,')
    if create_forms:
        uses.append('  FormShot,')
    for u in extra_uses:
        uses.append('  %s,' % u)
    referenced = [u for u in units if u['referenced']]
    for i, u in enumerate(referenced):
        sep = ';' if i == len(referenced) - 1 else ','
        uses.append('  %s%s' % (u['name'], sep))
    if not referenced:
        # Konsolen-Demo: die letzte Unit im uses-Abschnitt braucht kein Komma
        if uses and uses[-1].endswith(','):
            uses[-1] = uses[-1][:-1] + ';'
    out = []
    out.append('program %s;' % name)
    out.append('')
    out.append('{$mode delphi}{$H+}')
    out.append('')
    out.append('uses')
    out.extend(uses)
    out.append('')
    # Die Delphi-Ressource (.res) wird bewusst nicht eingebunden: sie
    # enthaelt Symbol und Versionsangaben fuer Windows und wird von
    # Free Pascal nicht in jedem Format gelesen. Das Delphi-Programm
    # (.dpr) bindet sie weiterhin ein.
    out.append('begin')
    out.append('  RequireDerivedFormResource := True;')
    out.append('  Application.Initialize;')
    if title:
        out.append("  Application.Title := '%s';" % title.replace("'", "''"))
    for cls, var in create_forms:
        out.append('  Application.CreateForm(%s, %s);' % (cls, var))
    # Screenshot-Modus: '--screenshot <datei>' rendert das Formular und beendet.
    if create_forms:
        main_var = create_forms[0][1]
        out.append('  if (ParamCount > 1) and (ParamStr(1) = \'--screenshot\') then')
        out.append('  begin')
        out.append('    %s.Show;' % main_var)
        out.append('    Application.ProcessMessages;')
        out.append('    SaveFormToImage(%s, ChangeFileExt(ParamStr(2), \'.bmp\'));' % main_var)
        out.append('    Application.Terminate;')
        out.append('  end;')
    out.append('  Application.Run;')
    out.append('end.')
    out.append('')
    return '\n'.join(out)

def build_lpi(name, lpr_name, units, pkgs, create_forms):
    """Erzeugt die Lazarus-Projektdatei."""
    comp_by_unit = {}
    for cls, var in create_forms:
        comp_by_unit.setdefault(var.lower(), cls)

    lines = []
    a = lines.append
    a('<?xml version="1.0" encoding="UTF-8"?>')
    a('<CONFIG>')
    a('  <ProjectOptions>')
    a('    <Version Value="11"/>')
    a('    <PathDelim Value="/"/>')
    a('    <General>')
    a('      <Flags>')
    a('        <MainUnitHasUsesSectionForAllUnits Value="True"/>')
    a('        <MainUnitHasCreateFormStatements Value="False"/>')
    a('        <MainUnitHasTitleStatement Value="False"/>')
    a('      </Flags>')
    a('      <SessionStorage Value="InProjectDir"/>')
    a('      <MainUnit Value="0"/>')
    a('      <Title Value="%s"/>' % xml_escape(name))
    a('      <UseAppBundle Value="False"/>')
    a('      <ResourceType Value=""/>')
    a('    </General>')
    a('    <i18n>')
    a('      <EnableI18N LFM="True"/>')
    a('    </i18n>')
    a('    <VersionInfo>')
    a('      <StringTable ProductVersion=""/>')
    a('    </VersionInfo>')
    a('    <BuildModes Count="3">')
    a('      <Item1 Name="Default" Default="True"/>')
    a('      <Item2 Name="Debug">')
    a('        <CompilerOptions>')
    a('          <Version Value="11"/>')
    a('          <PathDelim Value="/"/>')
    a('          <Target>')
    a('            <Filename Value="../bin/$(TargetCPU)-$(TargetOS)/%s"/>' % name)
    a('          </Target>')
    a('          <SearchPaths>')
    a('            <OtherUnitFiles Value="%s"/>' % unit_search_path(units))
    a('            <IncludeFiles Value="%s"/>' % unit_search_path(units))
    a('            <UnitOutputDirectory Value="../bin/$(TargetCPU)-$(TargetOS)/units"/>')
    a('          </SearchPaths>')
    a('          <Parsing>')
    a('            <SyntaxOptions>')
    a('              <SyntaxMode Value="Delphi"/>')
    a('              <IncludeAssertionCode Value="True"/>')
    a('            </SyntaxOptions>')
    a('          </Parsing>')
    a('          <CodeGeneration>')
    a('            <Checks>')
    a('              <IOChecks Value="True"/>')
    a('              <RangeChecks Value="True"/>')
    a('              <OverflowChecks Value="True"/>')
    a('              <StackChecks Value="True"/>')
    a('            </Checks>')
    a('          </CodeGeneration>')
    a('          <Linking>')
    a('            <Debugging>')
    a('              <DebugInfoType Value="dsDwarf2Set"/>')
    a('              <UseHeaptrc Value="True"/>')
    a('            </Debugging>')
    a('          </Linking>')
    a('        </CompilerOptions>')
    a('      </Item2>')
    a('      <Item3 Name="Release">')
    a('        <CompilerOptions>')
    a('          <Version Value="11"/>')
    a('          <PathDelim Value="/"/>')
    a('          <Target>')
    a('            <Filename Value="../bin/$(TargetCPU)-$(TargetOS)/%s"/>' % name)
    a('          </Target>')
    a('          <SearchPaths>')
    a('            <OtherUnitFiles Value="%s"/>' % unit_search_path(units))
    a('            <IncludeFiles Value="%s"/>' % unit_search_path(units))
    a('            <UnitOutputDirectory Value="../bin/$(TargetCPU)-$(TargetOS)/units"/>')
    a('          </SearchPaths>')
    a('          <Parsing>')
    a('            <SyntaxOptions>')
    a('              <SyntaxMode Value="Delphi"/>')
    a('            </SyntaxOptions>')
    a('          </Parsing>')
    a('          <CodeGeneration>')
    a('            <Optimizations>')
    a('              <OptimizationLevel Value="3"/>')
    a('            </Optimizations>')
    a('          </CodeGeneration>')
    a('          <Linking>')
    a('            <LinkSmart Value="True"/>')
    a('          </Linking>')
    a('        </CompilerOptions>')
    a('      </Item3>')
    a('    </BuildModes>')
    a('    <PublishOptions>')
    a('      <Version Value="2"/>')
    a('    </PublishOptions>')
    a('    <RunParams>')
    a('      <local>')
    a('        <FormatVersion Value="1"/>')
    a('      </local>')
    a('    </RunParams>')
    a('    <RequiredPackages Count="%d">' % len(pkgs))
    for i, p in enumerate(pkgs):
        a('      <Item%d>' % (i + 1))
        a('        <PackageName Value="%s"/>' % p)
        a('      </Item%d>' % (i + 1))
    a('    </RequiredPackages>')
    a('    <Units Count="%d">' % (len(units) + 1))
    a('      <Unit0>')
    a('        <Filename Value="%s"/>' % lpr_name)
    a('        <IsPartOfProject Value="True"/>')
    a('        <UnitName Value="%s"/>' % name)
    a('      </Unit0>')
    for i, u in enumerate(units):
        a('      <Unit%d>' % (i + 1))
        a('        <Filename Value="%s"/>' % u['path'])
        a('        <IsPartOfProject Value="True"/>')
        if u['form']:
            a('        <ComponentName Value="%s"/>' % xml_escape(u.get('component', 'Form1')))
            a('        <HasResources Value="True"/>')
            a('        <ResourceBaseClass Value="Form"/>')
        a('        <UnitName Value="%s"/>' % u['name'])
        a('      </Unit%d>' % (i + 1))
    a('    </Units>')
    a('  </ProjectOptions>')
    a('  <CompilerOptions>')
    a('    <Version Value="11"/>')
    a('    <PathDelim Value="/"/>')
    a('    <Target>')
    a('      <Filename Value="../bin/$(TargetCPU)-$(TargetOS)/%s"/>' % name)
    a('    </Target>')
    a('    <SearchPaths>')
    a('      <OtherUnitFiles Value="%s"/>' % unit_search_path(units))
    a('      <IncludeFiles Value="%s"/>' % unit_search_path(units))
    a('      <UnitOutputDirectory Value="../bin/$(TargetCPU)-$(TargetOS)/units"/>')
    a('    </SearchPaths>')
    a('    <Parsing>')
    a('      <SyntaxOptions>')
    a('        <SyntaxMode Value="Delphi"/>')
    a('      </SyntaxOptions>')
    a('    </Parsing>')
    a('    <CodeGeneration>')
    a('      <SmartLinkUnit Value="True"/>')
    a('    </CodeGeneration>')
    a('    <Linking>')
    a('      <LinkSmart Value="True"/>')
    a('    </Linking>')
    a('  </CompilerOptions>')
    a('  <Debugging>')
    a('    <Exceptions Count="0"/>')
    a('  </Debugging>')
    a('</CONFIG>')
    return '\n'.join(lines) + '\n'


def unit_search_path(units):
    """Suchpfade: die Scope-Ordner der Demo, der Demoordner und - falls
    verwendet - die gemeinsamen Bausteine unter source/_core."""
    folders = []
    for u in units:
        # '../source/<Demo>/<scope>' bzw. '../source/<Demo>'
        parts = u['path'].split('/')
        folder = '/'.join(parts[2:-1])
        if folder not in folders:
            folders.append(folder)
    demos = source_folders()
    for folder in list(folders):
        parent = os.path.dirname(folder)
        if parent in demos and parent not in folders:
            folders.append(parent)
    # gemeinsame Bausteine (MVVM-Basis, Dienste)
    used = set()
    for u in units:
        used.update(u.get('uses', []))
    core = os.path.join(SRC, '_core')
    for sub in ('mvvm', 'services', 'tools'):
        path = os.path.join(core, sub)
        if not os.path.isdir(path):
            continue
        for name in os.listdir(path):
            if not name.lower().endswith('.pas'):
                continue
            uname = name[:-4].lower()
            if uname in used:
                rel = '_core/%s' % sub
                if rel not in folders:
                    folders.append(rel)
                break
    # Das Screenshot-Werkzeug wird von jedem Programm benutzt
    if os.path.isdir(os.path.join(core, 'tools')) and '_core/tools' not in folders:
        folders.append('_core/tools')
    return ';'.join('../source/%s' % f for f in folders)


def build_lpg(projects):
    lines = ['<?xml version="1.0" encoding="UTF-8"?>',
             '<CONFIG>',
             '  <ProjectGroup FileVersion="1">',
             '    <Targets Count="%d">' % len(projects)]
    for i, p in enumerate(projects):
        lines.append('      <Target%d FileName="FPC/%s">' % (i, p))
        lines.append('        <BuildModes Count="2"/>')
        lines.append('        <Mode1 Name="Default"/>')
        lines.append('        <Mode2 Name="Debug"/>')
        lines.append('      </Target%d>' % i)
    lines.append('    </Targets>')
    lines.append('  </ProjectGroup>')
    lines.append('</CONFIG>')
    return '\n'.join(lines) + '\n'


def write_file(path, content, check):
    if check:
        old = None
        if os.path.exists(path):
            with open(path, 'r', encoding='utf-8', errors='replace') as fh:
                old = fh.read()
        if old != content:
            print('  DIFF %s' % os.path.relpath(path, ROOT))
        return
    with open(path, 'w', encoding='utf-8', newline='\n') as fh:
        fh.write(content)


def update_dpr(name, units, referenced):
    """Aktualisiert das Delphi-Programm (FPC/<Name>.dpr): die Unit-Pfade
    zeigen auf die aktuelle Ablage, zusaetzliche Units (ViewModel, Model)
    werden eingetragen. So bleibt der Delphi-Build erhalten."""
    path = os.path.join(FPC, name + '.dpr')
    if not os.path.exists(path):
        return False
    with open(path, 'r', encoding='utf-8', errors='replace') as fh:
        text = fh.read()
    original = text

    by_name = {u['name'].lower(): u for u in units}
    # 1) vorhandene 'in'-Verweise aktualisieren
    def repl(m):
        unit = m.group(1)
        u = by_name.get(unit.lower())
        if u is None:
            return m.group(0)
        rel = u['path'][len('../source/'):].replace('/', '\\')
        return "%s in '..\\source\\%s'" % (unit, rel)

    text = re.sub(r"(?i)([A-Za-z0-9_]+)\s+in\s+'[^']*'", repl, text)

    # 2) fehlende Units (ViewModel/Model) in den uses-Abschnitt eintragen
    m = re.search(r'(?is)\buses\b(.*?);', text)
    if m:
        block = m.group(1)
        added = []
        for u in units:
            if u['referenced']:
                continue
            if re.search(r'(?i)\b%s\b' % re.escape(u['name']), block):
                continue
            rel = u['path'][len('../source/'):].replace('/', '\\')
            added.append("  %s in '..\\source\\%s'" % (u['name'], rel))
        if added:
            # vor dem Semikolon des uses-Abschnitts einfuegen
            insert = '\n' + ',\n'.join(added)
            # vorhandene letzte Unit mit Komma versehen
            block_new = re.sub(r'(?<!,)(\s*)$', r',\1', block.rstrip())
            text = text[:m.start(1)] + block_new + insert + text[m.end(1):]
    if text != original:
        with open(path, 'w', encoding='utf-8', errors='replace', newline='') as fh:
            fh.write(text)
        return True
    return False


def main():
    check = '--check' in sys.argv
    changed = []

    # --- Demo-Programme aus den .dpr ableiten -------------------------------
    demos = []
    for fname in sorted(os.listdir(FPC)):
        if not fname.lower().endswith('.dpr'):
            continue
        path = os.path.join(FPC, fname)
        with open(path, 'r', encoding='utf-8', errors='replace') as fh:
            text = fh.read()
        name = fname[:-4]
        uses = parse_uses(text)
        create_forms = parse_create_forms(text)
        title = ''
        m = re.search(r"Application\.Title\s*:=\s*'([^']*)'", text)
        if m:
            title = m.group(1)

        folders = []
        referenced = set()
        extra_uses = []
        for uname, upath in uses:
            if upath:
                f = folder_of_source_path(upath)
                f = resolve_folder(f) or f
                if f and f not in folders:
                    folders.append(f)
                referenced.add(uname.lower())
            elif uname.lower() in ('defaulttranslator',):
                extra_uses.append(uname)
        if not folders:
            f = resolve_folder(name)
            if f:
                folders.append(f)
        if not folders:
            print('  ? ohne source-Ordner: %s' % fname)
            continue

        all_units = []
        for f in folders:
            all_units.extend(collect_units(f, referenced))
        # Units aus anderen Demos (z. B. Inidata, BarChart) mit einbeziehen
        grew = True
        while grew:
            grew = False
            known = set(u['name'].lower() for u in all_units)
            wanted = []
            for u in all_units:
                for used in u.get('uses', []):
                    if used not in known and used not in wanted:
                        wanted.append(used)
            for u in find_demo_units(wanted):
                if u['name'].lower() not in known:
                    all_units.append(u)
                    known.add(u['name'].lower())
                    grew = True
        units = units_for_project(all_units, list(referenced))
        # Komponentennamen aus den CreateForm-Aufrufen zuordnen
        var_by_class = {cls.lower(): var for cls, var in create_forms}
        for u in units:
            if u['form']:
                u['component'] = 'Form1'
        # Formularvariable der Demo den Units zuordnen (CreateForm)
        for cls, var in create_forms:
            for u in units:
                if u['form'] and cls.lower().endswith(u['name'].lower()[-3:]):
                    pass
        demos.append({
            'name': name,
            'folders': folders,
            'units': units,
            'create_forms': create_forms,
            'title': title,
            'extra_uses': extra_uses,
        })

    # --- Test-Harnesses (nur .lpr vorhanden) --------------------------------
    for fname in sorted(os.listdir(FPC)):
        if not fname.lower().endswith('.lpr'):
            continue
        if fname[:-4] in [d['name'] for d in demos]:
            continue
        path = os.path.join(FPC, fname)
        with open(path, 'r', encoding='utf-8', errors='replace') as fh:
            text = fh.read()
        name = fname[:-4]
        uses = parse_uses(text)
        folders = []
        referenced = set()
        for uname, upath in uses:
            if upath:
                f = folder_of_source_path(upath)
                f = resolve_folder(f) or f
                if f and f not in folders:
                    folders.append(f)
            referenced.add(uname.lower())
        # Test-Harnesses liegen in source/tests
        if os.path.isdir(os.path.join(SRC, 'tests')):
            folders.append('tests')
        units = []
        for f in folders:
            units.extend(collect_units(f, referenced))
        # Die Test-Units benutzen die Units der jeweiligen Demo - diese
        # gehoeren mit in das Projekt (Suchpfad und Unitliste).
        demo_names = []
        for u in units:
            for used in u.get('uses', []):
                if used not in demo_names and not used.startswith('tst_'):
                    demo_names.append(used)
        extra = find_demo_units(demo_names)
        for u in extra:
            if not any(x['name'].lower() == u['name'].lower() for x in units):
                units.append(u)
        demos.append({
            'name': name,
            'folders': folders,
            'units': units,
            'create_forms': [('TGuiTestRunner', 'TestRunner')],
            'title': 'Test: %s' % name,
            'extra_uses': [],
            'test': True,
        })

    # --- Dateien schreiben --------------------------------------------------
    for d in demos:
        name = d['name']
        lpr_name = name + '.lpr'
        if not d.get('test'):
            has_res = os.path.exists(os.path.join(FPC, name + '.res'))
            lpr = build_lpr(name, d['units'], d['create_forms'], d['extra_uses'],
                            d['title'], has_res)
            write_file(os.path.join(FPC, lpr_name), lpr, check)
            changed.append(lpr_name)
        if not d.get('test'):
            update_dpr(name, d['units'], [u['name'] for u in d['units'] if u['referenced']])
        pkgs = packages_for(d['units'])
        if d.get('test'):
            # Test-Harnesses benoetigen den Test-Runner und die Maus-/Tastatureingabe
            for extra in ('FPCUnitTestRunner', 'LazMouseAndKeyInput'):
                if extra not in pkgs:
                    pkgs.append(extra)
        lpi = build_lpi(name, lpr_name, d['units'], pkgs, d['create_forms'])
        write_file(os.path.join(FPC, name + '.lpi'), lpi, check)
        changed.append(name + '.lpi')

    # Projektgruppe
    projects = sorted(d['name'] + '.lpi' for d in demos)
    for extra in ('BarChartp.lpk', 'DingPkg.lpk'):
        if os.path.exists(os.path.join(FPC, extra)):
            projects.append(extra)
    # Die Meta-App liegt in einem eigenen Unterordner
    meta_dir = os.path.join(FPC, 'meta')
    if os.path.isdir(meta_dir):
        for name in sorted(os.listdir(meta_dir)):
            if name.lower().endswith('.lpi'):
                projects.append('meta/' + name)
    write_file(os.path.join(ROOT, 'Lazarus_Bible.lpg'), build_lpg(projects), check)
    changed.append('Lazarus_Bible.lpg')

    print('%s %d Projekte' % ('geprueft:' if check else 'geschrieben:', len(demos)))
    return 0


if __name__ == '__main__':
    sys.exit(main())
