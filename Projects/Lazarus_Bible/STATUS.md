# Status der Portierung

Kurzfassung des aktuellen Stands der Delphi-Bible auf Linux (FPC/Lazarus).

## Build-Stand (Ubuntu 26.04, FPC 3.2.2, Lazarus 4.8.0)

`FPC/tools/build_all.sh` baut **123 von 129** Projekten. Noch offen (echte
Windows-Abhaengigkeiten):

* `Animator`, `CoolDemo` (Win32-Animationssteuerelement -> LCL-Neuimplementierung)
* `Report1` (QuickReport -> LazReport)
* `Testdll` (+ `Colorlib`: DLL -> Shared Library)

`WinesEntry` und `Sqlplay` nutzen jetzt die BDE-freie Paradox-Engine
`DBParadox` (Komponente unter `C:\Projekte\Delphi\Components`). Dafuer wurde
DBParadox erweitert: Paradox-Versionen `0x09`/`0x0A` (Datenkopf bei `$78`)
sowie die Feldtypen `2` (Date) und `6` (Number/Double, big-endian mit
gekipptem Vorzeichenbit). Tests dazu in `Components/Source/DBParadox/Tests`
(`tst_DBParadoxFileReader`, `tst_DBParadoxRecordEncoder`,
`tst_DBParadoxConnection`). Alle 119 Tests laufen unter Linux (FPC 3.2.2,
Lazarus 4.8) **und** Windows (Lazarus 4.8) fehlerfrei; `WinesEntry` baut mit
der Windows-Lazarus.

Behoben beim Neuaufsetzen des Builds:

* Lazarus-Konfiguration zeigte auf entferntes `/usr/lib/lazarus/4.4`
  (installiert ist `/usr/share/lazarus/4.8.0`).
* Shell-Skripte in `FPC/tools/*.sh` von CRLF auf LF (`fix_line_endings.py`).
* 92 Quelldateien mit Gross-Endung (`.PAS`/`.DFM`) kleingeschrieben
  (`normalize_extensions.py`) - FPC sucht unter Linux mit exakter Schreibweise.
* Pfad-Case in den `.lpi` an die tatsaechliche Ordnerschreibweise angepasst
  (`fix_path_case.py`, neu). FPCs `-Fu`-Suche ist case-sensitiv.
* Fehlende `.lfm` aus binaeren `.dfm` erzeugt (`dfm2lfm.pas` + `fix_lfm.py`).
* `gen_projects.py`: Test-Erkennung, Paket-Erhalt (Union mit vorhandenen),
  transitive Demo-Units, `all_demo_units` scannt auch `view/viewmodel/model`,
  `parse_uses` liest alle `uses`-Abschnitte, `--tests-only`.
* `UnitOutputDirectory` auf die Makro-Funktion `$NameOnly($(ProjFile))`
  korrigiert (`fix_unit_output_dir.py`). Die IDE schreibt faelschlich
  `$(NameOnly(...))`; Lazarus liest das als unbekannte Makro-Variable
  `(unknown macro: )` und legt den Ausgabeordner entsprechend an - unter
  Windows scheitert das am `:` im Namen. Die Makro-Funktion steht ohne die
  aeussere `$(...)`: `$NameOnly($(ProjFile))`.
* DDE-Demos (`DDE2`, `DDECOLOR`) auf `fcl-simpleipc` umgestellt (Delphi behaelt
  DDE ueber `{$IFDEF FPC}`).
* `OleCont` -> Bild-Vorschau, `OleWord1/2` -> Dokument mit Standardprogramm
  oeffnen, `DingX` -> eigenes LCL-Steuerelement statt ActiveX.

## Werkzeuge

| Datei | Zweck |
|---|---|
| `FPC/tools/gen_projects.py` | erzeugt alle `.lpr`/`.lpi`/`.lpg` aus den `.dpr` (Linux-Pfade, Buildmodi) |
| `FPC/tools/build_all.sh` | baut alle Projekte, schreibt `build/build-report.txt` |
| `FPC/tools/build_one.sh` | baut einzelne Projekte |
| `FPC/tools/run_demo.sh` | startet ein Demo und prueft, ob es laeuft |
| `FPC/tools/shot_test.sh` | erzeugt einen Screenshot (`--screenshot`) |
| `FPC/tools/port_units.py` | setzt die FPC-Kopfzeilen und bedingte `uses`-Abschnitte |
| `FPC/tools/fix_unit_refs.py` | vereinheitlicht Unit-Verweise (Linux ist case-sensitiv) |
| `FPC/tools/consolidate_delphi_projects.py` | fuehrt die Legacy-Versionsordner zusammen |
| `FPC/tools/dfm2txt.pas` | wandelt alte binäre DFM in Text-DFM |
| `FPC/tools/fix_lfm.py` | entfernt LCL-unbekannte Eigenschaften aus LFMs |
| `FPC/tools/setup_lazarus.sh` | registriert die benoetigten Lazarus-Pakete |

## Aufbau

```
source/<Demo>/            gemeinsamer Quellcode (dual-mode: Delphi + Lazarus)
    view/                  View (Formular)
    viewmodel/             ViewModel
    model/                 Model
    services/              demo-spezifische Dienste
source/_core/              gemeinsame Bausteine
    mvvm/                  ViewModelBase, Command, PropertyChanged
    services/              FileService, ProcessService, BibleIpc
    tools/                 FormShot (Screenshot)
FPC/<Demo>.lpr|.lpi        Lazarus-Projekte
FPC/meta/                  Meta-App "BibleExplorer"
FPC/tools/                 Werkzeuge
bin/<cpu>-<os>/            erzeugte Programme
build/                     Build-Bericht und Screenshots
```

## Stand der Demos

* **MVVM-Muster (View / ViewModel / Model, eine Klasse je Datei):**
  `HELLO`, `Calc32`, `README` - vollstaendig umgestellt und getestet.
* **Eingebettet (Verhalten):** `HELLO`, `Calc32`, `README`, `Enumfon`,
  `Printgr` - die Showcase-Registry kennt sie, der
  Schliessen-Knopf und das Demo-Menue laufen im Frame.
* **Weitere portierte Demos:** `Actions`, `Addpage`, `Calc64`, `CharGrid`,
  `Checks`, `Combos`, `Constraint`, `Contcomp`, `Exwin`, `Exlist`, `Except1`,
  `Except2`, `Fancy`, `Filemenu`, `Findrepl`, `Fishy`, `Fishy2`, `GlyphLst`,
  `Hello`, `Inidata`, `Keycount`, `Keyinfo`, `Listfont`, `Listtext`, `Lister`,
  `Master`, `MemInfo`, `Memopad`, `Metamore`, `MouseExcept`, `Msgdlg`,
  `Multimen`, `Ontop`, `Options`, `Palette`, `PicDialogs`, `Polyflow`,
  `Printgr`, `Prninfo`, `Readme`, `Runme`, `Sketch`, `Splashin`, `Spinbutt`,
  `StaticDemo`, `Status`, `StatusOD`, `Strlist`, `Strres`, `Syscolor`,
  `Sysmenu`, `TabEdit`, `Tabs`, `Telname`, `Todo`, `Toolbar1`, `Toolbar2`,
  `UpDownDemo`, `YesNoTest` - bauen unter Linux.
* **Noch Windows-spezifisch (werden einzeln umgestellt):**
  `Animator` (Win32-Animationssteuerung), `BarTest`/`MayTemp`/`MemInfo`/
  `WinesChart` (TeeChart -> TAChart), `CoolDemo` (BgraSpriteAnimation),
  `DingX` (ActiveX), `DDE1`/`DDE2`/`DDECOLOR`/`IPC` (DDE -> BibleIpc),
  `OleCont`/`OleWord1`/`OleWord2` (COM), `Report1` (QuickReport),
  `Sqlplay` (dbExpress), `VideoPlayer` (Windows Media), `Enumwin`/`Nonclien`
  (Fensterverwaltung), `WinesEntry` (BDE), `Calc32_2` (IntToBin).

## Meta-App "BibleExplorer"

* Baum links mit den Demos nach Themen, rechts die Reiter
  **Ueberblick / Code / Verhalten / Dateien / Notizen** (TPageControl, damit
  die Reiterleiste sichtbar ist) und unten eine Navigationsleiste
  (`< Zurueck`, `Weiter >`, Seitenname, Statuszeile).
* Die Metadaten stehen in `FPC/meta/bible.manifest.json` (kuratierte
  Annotationen: Kategorie, Kurzbeschreibung, Lernziel, markierte
  Code-Stellen, Notizen).
* Das "Verhalten" zeigt eingebettete Formulare der Showcase-Demos
  (`FPC/meta/units/BibleShowcaseRegistry.pas`), zweiunddreissig Demos
  sind live: `HELLO`, `Calc32`, `README`, `Enumfon`, `Printgr`,
  `Listfont`, `Combos`, `Checks`, `Spinbutt`, `Actions`, `Addpage`,
  `GlyphLst`, `Listtext`, `Multimen`, `Options`, `Palette`, `Sketch`,
  `Constraint`, `Contcomp`, `Fancy`, `Filemenu`, `Objlist`, `Toolbar3`,
  `Strlist`, `Strres`, `Status`, `StatusOD`, `Tabs`, `Telname`,
  `Toolbar1`, `Toolbar2`, `UpDownDemo`
  - der Schliessen-Knopf der
  Demo leert nur den Frame ("Demo intern starten" startet sie erneut):
  `TBitBtn`-Knöpfe mit `Kind = bkClose` werden beim Einbetten auf das
  Demo-Formular umgebogen (`PrepareBehaviorForm`), sonst schliesst die
  LCL die Meta-App. Die Registry erzwingt eigene Formular-Namen
  (statt `TMainForm`), sonst kollidieren die Demo-Ressourcen.
* Die Menuzeile einer Demo erscheint im eingebetteten Zustand nicht -
  sie wird dynamisch in die Menue des BibleExplorers gespiegelt
  (`PrepareBehaviorMenu`), Klicks laufen ruehreffend auf die
  Original-Eintraege der Demo. Sekundaerformulare (z. B. die About-Box
  des Rechners) werden teils bedarfsgesteuert erzeugt, da das
  AutoCreate des eigenstaendigen Projekts entfaellt. Drucken ohne
  installierten Drucker (WSL) wird sauber abgefangen.
* **Stabilitaet im eingebetteten Betrieb:**
  - `Inidata.RegisterINIDataProp` akzeptiert ein identisches
    Klasse+Paar mehrfach, statt mit "already registered"
    abzubrechen - Tabs und Options durften sich sonst im selben
    Prozess gegenseitig ausbremsen (die Ausnahme laesst halbfertige
    Formulare zurueck - Access Violation).
  - Die Options-Demo arbeitet auf der aktuellen Instanz (`Self`)
    statt der globalen Formular-Variable (dort nil im Frame).
  - Einbetten, Vorbereitung und Freigabe des Demo-Formulars laufen in
    try/except; ein fehlgebautes Demo schreibt den Fehler ins
    Verhaltens-Memo, statt die Meta-App mitzureissen.
* **Smoke-Test:** `FPC/demo_smoke.lpr` erzeugt alle zweiunddreissig
  Demo-Formulare einmal (Registry-Factory: LFM-Stream + FormCreate,
  ohne GUI-Klick). Build + Lauf via `FPC/tools/smoke_test.sh` - alle
  32 Demos melden OK.
  Fuer alle anderen Demos startet die App das gebaute Programm
  ("Externes Programm starten", rot markiert) bzw. erzeugt einen
  Screenshot - jedes Demo unterstuetzt `--screenshot <datei.bmp> [seite]`.

## Hinweise zur Versionsverwaltung

* Das Repository liegt in `C:\Projekte\Lazarus\Public_LazarusBible`;
  `Projects/Lazarus_Bible` ist ein **Junction** auf
  `C:\Projekte\Delphi\Delphi_Bible`.
* **Nur mit der Windows-git arbeiten** - die git unter WSL folgt dem
  Junction nicht und wuerde die Dateien als geloescht anzeigen.
* Vor dem Commit `git update-index --really-refresh` ausfuehren: die
  Zeitstempel des 9p-Mounts sind unzuverlaessig, sonst uebersieht git
  Aenderungen. Erkennt die Windows-git ueber das Junction keine
  Aendereten (status/diff bleiben leer, obwohl die Inhalte abweichen),
  hilft nur der direkte Index-Weg: `git hash-object -w <datei>` und
  `git update-index --add --cacheinfo 100644,<blob>,<pfad>`, dann
  diff --cached gegenpruefen und committen.

