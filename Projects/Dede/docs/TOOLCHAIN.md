# Verfuegbare Toolchains

Geprueft am 2026-10-26 durch Aufruf der Versions-/Hilfeoptionen sowie
erfolgreiche Delphi-XE-, FPC-Win32-, FPC-Win64- und WSL-Builds.

| Werkzeug | Pfad | Ergebnis |
| --- | --- | --- |
| Delphi XE Win32 | `C:\copy\delphi\RAD Studio\8.0\bin\DCC32.EXE` | Compiler 22.0, Copyright 2010, aufrufbar |
| Lazarus | `C:\lazarus\lazbuild.exe` | Version 4.8, aufrufbar |
| FPC Win32 | `C:\lazarus\fpc\3.2.2b\bin\i386-win32\fpc.exe` | Version 3.2.2; CLI-Vollbuild, Smoke und XE-Strukturvergleich bestehen; passende FPC-/LCL-Units sind installiert. |
| FPC Win64 | `C:\lazarus\fpc\3.2.2\bin\x86_64-win64\fpc.exe` | Version 3.2.2; CLI-Vollbuild und Smoke bestehen; PE32/Disassembler- und ZIP-Tests bestehen. |
| WSL Ubuntu 26.04 | `/usr/bin/fpc` | FPC 3.2.2; native Linux-CLI baut, smoke-tests und exportiert die Referenzdatei. |

Delphi-RTL/VCL-DCUs `System.dcu` und `Forms.dcu` sind in
`C:\copy\delphi\RAD Studio\8.0\lib\win32\release` sowie `debug` vorhanden.
Die Installation wurde durch die Builds und Tests in der aktuellen
Scope-Quellstruktur vollstaendig bis zum Linken validiert.

## Buildentscheidung

Delphi XE ist der erste Kandidat fuer den VCL-Basisbuild. Es ist kein
nachgewiesener Originalcompiler und hat bereits Unicode-Standardstrings.
ANSI-/Unicode-Grenzen muessen deshalb als eigene Build-/Portierungsdeltas
behandelt werden. FPC Win32 bleibt fuer den separaten Lazarus-Zweig verfuegbar.

Build- und Artefaktregeln:

- Die Delphi-XE-Units werden nach `..\bin\D_XE\Units` geschrieben; GUI, CLI
  und Test-Runner liegen jeweils in einem eigenen App-Verzeichnis unter
  `..\bin\D_XE`.
- Buildprotokolle und reproduzierbare Analyseausgaben liegen unter
  `DeDe\build`; die Quellen unter `DeDe\src` bleiben frei von DCUs, EXEs
  und Objektdateien.
- Die Buildskripte definieren Suchpfade fuer `View`, `ViewModel`, `Model`,
  `Core` und RX explizit und erzwingen einen Vollbuild (`-B`). VCLZip ist
  kein Produktions-Buildinput mehr.
- Historische DCUs werden nicht als Build-Eingabe verwendet.

`build_fpc.py` liest CPU und Zielbetriebssystem direkt vom gewaehlten
Compiler und trennt die Artefakte: Win32 nach `bin\Laz32\Win32`, Win64 nach
`bin\Laz64\Win64` und Linux nach `bin\Laz64\Linux`; FPC-Units landen jeweils
im `Units`-Unterordner. Fuer Win32 ergaenzt das Skript die zum Compiler
gehoerenden FPC-Paketpfade, da diese Installation keine eigene `fpc.cfg`
mitbringt. Unter WSL wird die native Linux-Toolchain verwendet; die
CLI-Paritaet wird gegen den XE-Export mit
`tools/verify_cross_host_export.py` gemessen. Siehe `docs/PORTABILITY.md`.

Zusaetzlicher historischer Befund: `trunk/Source/Main/DeDe.dof` nennt
FileVersion `3.1.0.1532` und ProductVersion `3.10b`, waehrend
`DeDeConstants.pas` den Stand 3.11 nennt. Die abweichende VERSIONINFO
der Original-EXE passt damit zu einer bereits im Basisprojekt sichtbaren
abweichenden Versionspflege; dies ist kein eigenstaendiger Beweis fuer
die offizielle Releasebezeichnung der EXE.
