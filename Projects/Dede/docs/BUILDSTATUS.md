# XE-Basisbuild: Zwischenstand

Stand 2026-10-25. Der Delphi-XE-Basisbuild linkt erfolgreich und erzeugt
`..\bin\D_XE\DeDe\DeDe.exe`. Start- und PE-Header-Smoke-Tests
bestanden; der Process-Button kam bei einem gueltigen PE ueber die
Headerpruefung hinaus. Ein echter Explorer-Datei-Drop, vollstaendige
Workflow-Ergebnisse und Verhaltensgleichheit mit der Referenz bleiben
unverifiziert. Die Referenz-EXE wurde nicht ausgefuehrt.
Verbesserungsvorschlaege fuer eine spaetere Bereinigungsphase sind separat in
`docs/IMPROVEMENT_NOTES.md` gesammelt; sie sind nicht Teil dieser
Originalrekonstruktion.

Die SVN-Arbeitskopie unter `trunk/Source/Main` war bereits vor diesen
Buildkorrekturen lokal veraendert (unter anderem Pascal-Dateien,
Lazarus-Dateien und Sicherungskopien). Diese vorhandenen Aenderungen wurden
nicht zurueckgesetzt. `build_xe.py` kompiliert die Arbeitsdateien aus
`DeDe/src` und kopiert keine Anwendungsquellen mehr flach aus `trunk`.
Damit beschreibt der Build den aktuellen Arbeitsstand und nicht zwingend den
unveraenderten SVN-Revision-10-Stand.

## Reproduktion

```powershell
python DeDe\tools\sync_version_resource.py
python DeDe\tools\build_xe.py
```

## DUnit-Fixture-Tests

Die installierte Delphi-XE/RAD-Studio-8-Umgebung stellt klassisches DUnit
(`TestFramework`, `TextTestRunner` und `DUnitConsts`) bereit. Der Runner und
die Tests sind als normale Projektdateien unter `tests` angelegt; DUnit wird
nicht in den Quellbaum kopiert. Ausfuehren:

```powershell
python DeDe\tools\run_tests_xe.py
```

Das Werkzeug baut den Konsolenrunner nach `..\bin\D_XE\Tests`, legt
Compiler- und Testausgabe unter `build\D_XE\Tests` als `compile.log` bzw. `test.log` ab und
liefert bei Testfehlern einen Fehler-Exitcode. Der aktuelle Satz enthaelt
35 `TTestCase`-Tests: DSF-/Klassenparsergrenzen, DCU-Endmarker,
Compiler-Versionsmarker, D6/D7-PE32-VMT-Marker sowie D7-Import-,
Konfigurations- und Katalogzuordnung, bounded PE32-Codezugriffe, Uses-
Listenformatierung, DPJ-ANSI- und
Kommentarrecords, den negativen MainUnit-Callback, EditProp-Validierung und
Listen-Tabellen, synthetischen FileDrop, verschachtelte Collections,
alle IDR-Text-DFMs, den PE-Header des Testprogramms und RVA-Offsetgrenzen.
Der aktuelle DUnit-Lauf besteht mit `OK: 35 tests`; dazu gehoeren SHA-1-
Known-Vectors, BSS-/Expression-RVAs, Prozesspointer oberhalb der
signed-32-bit-Grenze, die MemLoc-Auflistung des aktuellen Prozesses, der
UI-freie Progress-Host und Session-Callbacks waehrend des initialen Ladens,
die Eigentumspruefung angehaengter
GUI-Analysedaten, gemeinsame Versionszuordnung, getrennte Core-Kontexte
angehaengter Sitzungen und deren Restore nach Analysefehlern,
JSON-Export-/Overwrite-Schutz, atomarer Exportabbruch mit bereinigten
Staging-Dateien, gross-/kleinschreibungsunabhaengige PAS-Namenskollisionen,
x86-Call-Referenzen und Cleanup-Evidenz,
die Zuordnung von Methodencodeadressen zu
VMT-Slots sowie DOI-/DUF-/BPL-Archive-Roundtrips ueber den neuen ZLib-Adapter.

Die bisherigen Smoke-Programme bleiben waehrend der schrittweisen Migration
als Vergleichsorakel erhalten. Die DUnit-Suite verarbeitet jetzt alle
36 IDR-Text-DFMs sowie zusaetzliche synthetische DFM-Collection-Faelle.
`VersionInfoSmoke` bleibt als parameterisierter Test fuer ein externes PE;
`PEHeaderSmoke` bleibt fuer die zusaetzliche alte PE-Fixture. Fixtures
werden deterministisch im DUnit-Test erstellt oder als vorhandene
Referenzdateien eingelesen und koennen spaeter separat versioniert werden.
Der synthetische HDROP-Test belegt keinen echten Explorer-Drop. Tests, die
Explorer-Interaktion, echte Zielprozesse oder eine isolierte VM benoetigen,
bleiben ausserhalb des regulaeren DUnit-Laufs.

Die routineweise Delta-Karte hat begonnen: `docs/DELTA_EVIDENCE.md` ordnet
den V3.11-Handler `btnProcessMouseDown` dem V3.5-`PrcsBtnMouseDown` zu.
Shift-Debugflag und Modifier-Auswertung stimmen semantisch ueberein; im Ziel
wurden Button und Handler im DFM umbenannt. Das ist ein konkreter
unveraenderter Verhaltenskern mit Ziel-Umbenennung. Ein zweiter Vergleich
belegt, dass die DPJ-Lade-/Speichermenuehandler in beiden Staenden vor dem
DPJ-Code mit `Not implemented yet!` abbrechen. Dies ist erst ein kleiner,
belegter Ausschnitt, keine vollstaendige MainUnit-Deltaanalyse. `SaveProject1Click`
enthaelt in beiden Staenden denselben `FbProcessed`/`f558`-Guard mit
Exception-Pfad.
`FormCloseQuery` ist ebenfalls semantisch gleich: No verhindert das
Schliessen; waehrend Process laeuft wird die Form abgebaut und der Prozess
direkt beendet.
Ein Namensscan findet 51 gemeinsame MainUnit-Routinenamen (123 in der
Basisquelle, 79 im Ziel-IDR). Diese Zahlen dienen nur zur Kandidatenauswahl;
unmatched Namen gelten nicht automatisch als entfernt oder neu.
Als fuenfter Vergleich ist der Wechsel vom 3.11-Message-Handler
`WM_DROPFILES` zur 3.5-`TFileDrop`-Komponente belegt. Die Ziel-Callbackadresse
ist bekannt, der Callback-Body aber nicht symbolisch rekonstruiert; die
Uebereinstimmung der aktuellen Callback-Entscheidung bleibt daher offen.

Die Anwendungsquellen liegen nach Scope unter
`DeDe/src/{View,ViewModel,Model,Core}`; die DPR-Einstiegspunkte verbleiben
im Stamm und `DeDe.res` liegt unter `src/Resources`. Die fruehere
`docs/baseline-copy.json` dokumentiert nur die einmalige Quelltextuebernahme;
der Build kopiert keine Units aus `trunk`. Compileraufrufe und vollstaendige
Diagnosen liegen unter `DeDe/build/D_XE/<App>`. EXEs werden nach
`bin/D_XE/<App>`, DCUs nach `bin/D_XE/Units` umgeleitet. Die produktive
ZIP-Komponente wurde durch `Core/DeDeZip.pas` (ZLib raw-DEFLATE plus
Ein-Eintrags-ZIP-Container) ersetzt. Kein Produktionsmodul importiert mehr
VCLZip/VCLUnZip; die XE-Buildskripte beziehen auch keine VCLZip-Quellen mehr
ein. Alte Vendor-Dateien in `third_party/xe_overrides` bleiben als historische
Vergleichsunterlagen liegen, sind aber keine Build- oder Laufzeitabhaengigkeit.
Der Adaptertest laeuft unter XE/Win32 und FPC/Win64 gegen originale DOI/DSF-
Fixtures und Python ZIP. Die belegten 3.11-zu-3.5-Deltas stehen in
`docs/DELTA_EVIDENCE.md`; die getrennten Haertungen und offenen
Rekonstruktionsgrenzen in `docs/IMPROVEMENT_NOTES.md`.
Details, Containergrenzen und Testkommando stehen in
`docs/ZLIB_ZIP_SPIKE.md`. Eine Legacy-VCLUnZip-Gegenprobe ist wegen des
fehlerhaften isolierten Harnesses weiterhin offen.

Die lokale SVN-Metadatenangabe nennt das ehemalige Google-Code-Repository
`http://dedex.googlecode.com/svn`, Revision 10. Der Server liefert fuer
`svn log` keinen erreichbaren Pfad mehr; weitere Historie konnte daher nicht
remote verifiziert werden.

## Bisherige Buildkorrekturen

- `DeDe.dpr`: LCL-Unit `Interfaces` nur fuer FPC einbinden.
- Compileroption `-$J+`: schreibbare typisierte Konstanten, wie im alten
  Projekt durch `J=1` vorgesehen; notwendig fuer Erkennungsmuster.
- `DeDeMemDumps.pas`: PE-Sektionsnamen explizit als ANSI lesen.
- `DeDeBSS.pas`: `TStartupInfo` passend zur generischen Windows-API verwenden.
- `SelProcessUnit.pas`: Toolhelp-Dateinamen passend zum generischen `PChar` lesen.
- `DisAsmTables.pas` und `DisASM.pas`: Opcodeindex bleibt ein Byte (`AnsiChar`),
  keine versehentliche Erweiterung auf 65.536 Unicode-Zeichen.
- `StatsUnit.pas`: Delphi-XE-`TStartupInfo`/`TProcessInformation` fuer die
  Unicode-Windows-API; `WinExec`-Kommandozeile und gelesene Prozessausgabe
  bleiben explizit ANSI-Bytes.
- `DeDeClasses.pas`: ANSI-Bytes in PE-Signaturen, Sektionsnamen und
  RTTI-Namen werden vor Stringvergleichen explizit dekodiert;
  `DeDeClassHandle.pas` verwendet denselben byteorientierten Leser fuer
  Klassen-, Unit-, Feld- und Methodennamen.
- `DeDeAnsiStream.pas`: gemeinsame bytekorrekte ANSI-Lese-/Schreibhilfe fuer
  DPJ, DOI, DUF, DSF, WPJ/ALF und die Symbolnamen im Analyzer.
- `DeDeClassHandle.pas`: `GetBufferForDPJSave` serialisiert Klassennamen,
  Feld-/Methodennamen und Listenstrings mit der im IDR-Helfer `005A1180`
  belegten ANSI-Byte-Laenge je String.
- `DeDeDPJEng.pas`: DPJ-Rohstrings und laengenpraefixierte Werte werden als
  ANSI-Bytes statt als halbe Unicode-Stringdaten geschrieben bzw. gelesen.
- `tools/build_xe.py`: GUI, CLI und Tests aus den projektierten Quellen bauen;
  VCLZip-Quellen werden weder gestaged noch als Suchpfad eingebunden.
- `tools/sync_version_resource.py`: nur den RT_VERSION-Eintrag in
  `src/Resources/DeDe.res` mit dem SHA-geprueften Referenz-Payload ersetzen; alle
  anderen `.res`-Eintraege bleiben bytegleich.
- `third_party/xe_overrides/RxMemDS.pas`: Byte-Offset-Arithmetik fuer
  Delphi-XE-`TRecordBuffer`; die RX-MemDS-Implementierung verwendete fuer
  Feldoffsets `PChar`, dessen XE-Zeichenschritt zwei Bytes betraegt.

## Ergebnis und offene Arbeit

`DCU_In.pas` und `DCU_Out.pas` kompilieren im aktuellen Stand ohne Fehler;
die zuvor dokumentierten sechs Compilerfehler sind nicht mehr der aktuelle
Blocker. Die abschliessende Vollkompilierung meldet keine Compilerfehler und
erzeugt die EXE. Der isolierte V3.11-Arbeitsstand wurde in `DeDe.dpr` um den
im Referenz-DPR belegten Logo-Start (anzeigen, aktualisieren, 500 ms warten,
vor `Application.Run` freigeben) sowie die dort belegten Titeltexte
`DeDe 3.50.02 ...` und `Version 3.50.02` ergaenzt.

Das ist nur eine teilweise rekonstruierte Startpfad-Scheibe. Die anfangs
fehlenden `AddClsMemDtaUnit`- und `MemLocUnit`-Formulare sind jetzt in `src`
integriert. `MemLocUnit` unterscheidet nun wie im Ziel den Win9x-Toolhelp-
und NT-PSAPI-Pfad; der DUnit-Test bestaetigt die aktuelle Host-Auflistung.
Der Win9x-Zweig wurde nicht auf einem Win9x-System ausgefuehrt. `DBLogDlg`
und `DBPWDlg` sind
jetzt ebenfalls mit den IDR-Dialogressourcen und BDE-Callbacks integriert.
Der Remote-Login-Dialog verwendet den BDE-Ressourcentext `SRemoteLogin`
statt eines fest codierten englischen Captions.
`EditPropUnit` ist mit IDR-Text-DFM und einfacher Wertvalidierung integriert:
Byte/Word/DWord, Boolean, ShortString/Custom Type, Hexdaten und Set-Items
koennen editiert werden. ValueList-/NameValueList-Text wird in die RX-
MemoryData-Tabellen dekodiert und angezeigt; Aenderungen in diesen Tabellen
werden noch nicht in das Property-Rohformat zurueckserialisiert. `TreeViewUnit`
und ein textbasierter
DFM-Parser sind nun ebenfalls integriert. Collection-Eigenschaften werden
als synthetische Collection-/Item-Knoten abgebildet; dadurch bleiben etwa
DBGrid-Spalten und verschachtelte Collection-Items im Strukturbaum sichtbar.
Mehrzeilige Werte in Klammern und binaere `{...}`-Werte werden ueber
Zeilengrenzen hinweg mit korrektem Quote-/Delimiter-Balancing erhalten.
Doppelklick auf eine DFM-Zeile oeffnet den Struktur-/Eigenschafteninspektor.
Der Parser instanziiert keine Komponenten aus dem untersuchten DFM; daher gibt
es noch keine Live-Vorschau der Form. Prepare-Script/Speichern-Buttons zeigen
weiterhin wie im Ziel `not implemented yet!`.

Die `EditPropUnit`-Validierung wurde gegen die Referenzroutine `00585430`
abgeglichen: Typindizes oberhalb 12 werden abgewiesen; Boolean-Texte muessen
kleingeschrieben `true`/`false` sein und aktualisieren die beiden Boolean-
Typcodes entsprechend dem Referenzpfad. ValueList bleibt bei der
Rohtextvalidierung, waehrend Name/Value List zwar angezeigt wird, aber wie
im Ziel nicht gespeichert werden kann.

Der Projekt-DPR enthaelt jetzt alle 33 Ziel-DPR-Units und die belegte
Formularerzeugungsreihenfolge. Versionslogik, DFM-Typklassifikation und die
Rueckserialisierung der ValueList/NameValueList-Tabellen bleiben unvollstaendig. Der neue
`tools/unit_inventory.py`-Lauf erzeugt `docs/unit-inventory.csv` mit 261
Eintraegen, Quellpfad-Evidenz und konservativen Kategorien. Er findet 33
Ziel-DPR-Units, 53 V3.11-Main-Units, 51 installierte Delphi-RTL/VCL/DB-Units,
17 Komponentenquellen, 4 Arbeitskopie-Units (zwei vorhandene lokale Units
plus `FileDrop` und `DeDeAnsiStream`) und 103 synthetische IDR-Units.
`AniFile`, `Animate`, `FileUtil`, `GIFCtrl`, `IcoList`, `Placemnt` und
`ToolEdit` sind per eindeutigem Klassentreffer den RX-Quellen zugeordnet;
`FileCtrl` sowie `System`, `SysUtils` und `Variants` dem Delphi-Quellbaum.
`FileDrop.pas` rekonstruiert die IDR-Hilfsklasse: `MainUnit` bindet die
Komponente mit `DropControl` an das Hauptformular und verarbeitet in `OnDrop`
die erste Datei nach Process-Button-Pruefung, Bestaetigung und Aufruf von
`PreBtnClick`. Die Komponente sammelt alle Unicode-Dateipfade, gibt die
HDROP-Ressource auch bei Fehlern frei und stellt den urspruenglichen
WindowProc beim Abbau wieder her. Der Start-Smoke-Test und ein
Same-Process-Smoke-Test mit synthetischem HDROP bestanden; ein echter
Explorer-Datei-Drop bleibt noch ungetestet.
Die 103 synthetischen IDR-Units bleiben getrennt; drei haben eindeutige
Klassenevidenz zu `kpSStrm`, `KPLib` und `WSDLBind`. `_Unit151` ist anhand
der `DPJ!`-/`CLASSESDUMPER`-Signaturen und der MainUnit-Aufrufe als DPJ-
Streamloader/-writer belegt. `_Unit1` passt mit acht internen Routinen zu
`SysInit.pas` und buendelt Kernel32-Imports; `_Unit30`/`_Unit31` sind
Shell32-, `_Unit32` WinSpool- und `_Unit35` CommDlg-Importshims. `_Unit6`
enthaelt COM/OLE- und `_Unit9` OLE-Automation-Imports. API-Namen stimmen mit
Delphi-Quellen ueberein, aber unvollstaendige oder ueberlappende Signaturen
loesen die synthetischen Unitnamen nicht auf. Damit bleiben 92 der 103 Units
ohne Rollenhinweis. Ein systematischer Vergleich der IDR-Prozedurnamen mit
den installierten Delphi-Quellen ergab keine weiteren eindeutigen Treffer;
keine Zuordnung beruht nur auf Dateinamen.

`tests/DFMTextParserSmoke.dpr` wurde gegen alle 36 IDR-Text-DFMs und eine
Testfixture fuer verschachtelte/leere Collections, mehrzeilige Stringlisten
und binaere Werte ausgefuehrt. Die Tests pruefen auch reale DBGrid-Spalten.
`tests/EditPropTableSmoke.dpr` prueft ValueList-/NameValueList-Eintraege,
unveraenderte Quellwerte und die Zurueckweisung fehlerhafter Escapes.
`tests/EditPropValidationSmoke.dpr` prueft Boolean-Validierung,
Typcode-Umschaltung und die Abweisung der nicht unterstuetzten Typen 13/14.
`tests/VersionInfoSmoke.dpr` prueft die Referenz- und Build-VERSIONINFO.
`tests/DPJCommentSmoke.dpr` prueft den 12-Byte-DPJ-Header, laengenpraefixierte
ANSI-Strings, den Klassenpuffer-Stringhelfer und den im IDR-Writer belegten
104-Byte-Kommentarrecord; der In-Memory-Record ist 260 Bytes gross. Ein
absichtlich uebergrosser Kommentarzaehler wird vor der Arrayallokation
abgewiesen.
`tests/ParserWarningsSmoke.dpr` prueft den booleschen ParseClass-Ausgang,
ignorierte `end;`-Zeilen ohne vorheriges `begin`, deterministische leere
DSF-Puffer und ein vollstaendiges 50-Byte-Muster.
`tests/DCUEndMarkersSmoke.dpr` prueft das Entfernen doppelter `end;`-Marker,
den Grenzfall eines fuehrenden Endmarkers und eine leere Ausgabeliste.
`tests/MemDumpVersionSmoke.dpr` prueft die Versionsmarker-Zuordnung,
unbekannte Marker, den fehlgeschlagenen PID-0-Prozesszugriff und den
Entry-Point-Suchpfad fuer eine unbekannte Version.
`tests/MainUnitCallbacksSmoke.dpr` prueft den negativen Rueckgabepfad des
Plugin-Callbacks `GetCallReference` fuer Offset 0 und unveraenderte
Ausgabeparameter.
`tests/ProjectUsesWrapSmoke.dpr` prueft den Zeilenumbruch der Uses-Liste nach
dem fuenften Komma in `EndProject`.
`tests/FileDropSmoke.dpr` prueft den `WM_DROPFILES`-Dispatch, die geordnete
Dateiliste, den Callback und die Wiederherstellung des Formular-WindowProc.
`tests/PEHeaderSmoke.dpr` prueft die ANSI-Decodierung der PE-Signatur und
des ersten Sektionsnamens. Der Test besteht sowohl fuer die XE-EXE (`.text`)
als auch fuer `LegacyPEFixture.dpr` (`CODE`), erzeugt mit dem angebotenen
DCC32, das tatsaechlich Version 17.0 meldet (Delphi 2005/BDS 3, nicht Delphi
3.0). Die erzeugte Test-EXE wurde nach einer Windows-Defender-PUA-Erkennung
entfernt; die Fixture-Quellen bleiben erhalten und es wurde kein Umgehungs-
oder Whitelistingversuch unternommen.

Der Process-Button-Lauf auf `LegacyPEFixture.exe` endete nach Bestaetigung
einer `Can not create process`-Meldung mit `Dump Successful`. Laut
`DeDeBSS.Dump` faellt dieser Fehlerpfad auf Platzhalter fuer BSS-/DATA-Werte
zurueck; der erfolgreiche Dump bestaetigt daher nicht die Live-BSS-Erfassung.

Beim XE-Selbsttest erfasste ein dialoggesteuerter Process-Button-Lauf den Titel
`DeDe Target Loader` und die Meldung `Press OK when target is fully loaded`;
der passende OK-Button wurde nach Erkennung des geladenen Ziel-Hauptfensters
bedient. Danach blieb der Process-Button mindestens 30 Sekunden deaktiviert.
Das Analyseergebnis wurde daher nicht bestaetigt; der isolierte Prozess wurde
per PID beendet. Bei diesem Selbsttest erschien zusaetzlich
`Class Dump Engine Error!` fuer
`TDefaultDBScreenApplication` bei `FieldTblPos=1F5E13`; die Meldung stammt
aus `TClassDumper.DumpFields`. Die Bytes an dem Offset beginnen mit
`1B` (Laenge 27), gefolgt vom ANSI-Klassennamen
`TDefaultDBScreenApplication`; der Parser behandelt diesen Stringbeginn als
Feldtabellenanzahl. Das weist auf einen fuer dieses XE-Selbsttestziel
unpassenden Feldtabellenzeiger bzw. VMT-Aufbau hin. Die Klassenmetadaten-
Kompatibilitaet mit der Referenz bleibt offen; daraus wurde keine
Referenzverhaltensaenderung abgeleitet.

Der statische DPJ-Abgleich hat eine bestehende Asymmetrie im Zielcode
aufgedeckt: `00559908` schreibt nach Projektname und Dateipfad zuerst die
PE-CRC und danach weitere Projektfelder; `005595C8` liest an dieser Stelle
bereits eine Kommentaranzahl. Ein Roundtrip kann daher den CRC-Wert als
Arraylaenge interpretieren. Als dokumentierte Haertung prueft der Reader den
Zaehler gegen die verbleibenden Streambytes und `LoadDPJFile` gibt den Stream
auch bei Fehlern frei. Das behebt die Format-Asymmetrie nicht; ein Roundtrip
wurde nicht ausgefuehrt. Die Kommentarrecords selbst sind auf die belegten
104 Bytes pro Record angepasst und isoliert getestet.

Der About-Dialog verwendet jetzt das IDR-DFM und die belegten Zielfelder.
`FormActivate` liest `FileVersion` aus dem English-US-Version-Stringtable und
zeigt dessen letzten Abschnitt als Buildnummer (`1619` bei der Referenz). Die
globale DeDe-Versionsnummer wird auf `3.50.02` festgelegt; DPJ-Lese-/Schreib-
Logik vergleicht bzw. serialisiert ebenfalls die belegte Zielversion.
`GetAppVersion` liest Product-/FileVersion weiterhin aus den PE-Metadaten;
deren Produktversion `3.10b` bleibt bewusst getrennt von der UI-/DPJ-
Versionsnummer `3.50.02`.

Die VERSIONINFO-Ressource wurde aus dem PE-Referenzbuild synchronisiert;
die neue EXE meldet nun ebenfalls `ProductVersion=3.10b` und
`FileVersion=3.1.0.1619`, sodass der About-Dialog `Build 1619` anzeigt.
Das Synchronisationswerkzeug ist idempotent; alle anderen Ressourcen im
urspruenglichen `.res` bleiben unveraendert.

Der Referenzinventar-Lauf vom 2026-10-23 bestaetigt weiterhin 45.224 von
45.224 Opcodezeilen, 33 von 33 eingebettete DFM-Ressourcen und 36 von 36
IDR-Formularressourcen. Die resultierende Anwendung ist noch nicht auf
Verhaltensgleichheit getestet.

Der Build enthaelt weiterhin Warnungen, darunter implizite
Stringkonvertierungen, Vorzeichen und weitere moeglicherweise
uninitialisierte Werte. Die W1035/W1036-Befunde in `DeDePFiles.pas` sind
gezielt bearbeitet: `ParseClass` liefert nun einen definierten Status und der
DSF-Parser initialisiert seinen Musterzustand und ignoriert ein `end;` ohne
passendes `begin`. Der fokussierte Test und der Delphi-XE-Build bestehen.
`Dcu32.ReadUses` bricht einen Typ-Importtag in einer DLL-Importliste vor dem
gemeinsamen Append ab. Die W1036-Warnungen zu `E`, `B`, `RTTISz` und `TR` in
`Dcu32.pas` sind nach Kontrollflusspruefung eingeordnet, nicht pauschal
unterdrueckt. `DeDeMemDumps` und `SelProcessUnit` verwenden jetzt dieselbe
definierte Versionszuordnung; unbekannte Marker fuehren nicht mehr zu einem
uninitialisierten DVer. Die W1035/W1036-Befunde in `MainUnit.pas` sind
ebenfalls bearbeitet: DFM-Laengen verwenden keine Schleifenvariable mehr,
die Klassenreferenzsuche startet ausserhalb eines Strings und die
Plugin-Callbacks liefern definierte Booleans. Weitere Warnungen bleiben
einzeln zu bewerten. `DedePProject.EndProject` initialisiert jetzt auch den
Zaehler fuer den Uses-Listen-Umbruch; der bisher undefinierte Zaehlerstand
beeinflusste den Formatierungsrhythmus. Erfolgreiches Kompilieren allein ist
kein Nachweis fuer korrekte Binaeranalyse.

Im aktuellen Warning-Audit wurden zusaetzlich die undefinierten Emulator-
Rueckgaben, der `RunHiddenStuff`-Zaehler, `WriteIntData`, der optionale
`OffsInfStr`-Zustand, die ASMShow-Stub-Rueckgaben sowie die lokalen
`MakePEHUnit`-Objekte determinisiert. Die neuen Emulator-/Registerfehlerpfade
sind in `TestEmulatorInvalidInputs` abgedeckt. Signed/unsigned DCU-Sentinel-
und RVA-Dateigrenzvergleiche wurden ebenfalls korrigiert; die RVA-
Unterlaufgrenze wird durch `TestSymbolReferenceOffsetBounds` geprueft.
`TBSS.GetDataPrtOfBSSData` und die Expression-RVA-Suche verwenden jetzt
unsigned 32-Bit-Adressen; passende Grenztests bestehen.
Ausserdem verwendet die XE-SHA-1-Implementierung jetzt den unsigned
32-Bit-Worttyp; ihre bekannten DUnit-Vektoren bestehen. Der letzte
DUnit-Lauf besteht mit 18 Tests. Remote-Prozesspointer und relative
32-Bit-Offsets in `DeDeMemDumps` verwenden explizite unsigned-/Int64-
Arithmetik; der Vollbuild hat keine Compilerfehler.
In der aktuellen W1035/W1036-Suche verbleiben nur die vier
dokumentierten Kontrollflussfaelle in `Dcu32.pas`; die uebrigen
Compilerwarnungen (u.a. Typkonvertierungen und Vorzeichen) sind weiterhin
offen und werden nicht pauschal unterdrueckt.

## UI-neutraler Analysepfad und CLI (neuer Zwischenstand)

`DeDeCoreServices.pas` stellt jetzt einen UI-neutralen Kontext fuer
Fortschritt, Warnungen, PE-/DFM-Hilfsoperationen und gemeinsam genutzte
Analysedaten bereit. `MainUnit.PrepareProject` und die CLI-Session verwenden
denselben `LoadPEBinary`-Loader. `DeDeCore.pas` enthaelt eine
`TDeDeAnalysisSession`
fuer PE-/ELF-Laden, erkannte Legacy-Compiler-Metadaten, Klassenanalyse,
DFM-/PAS-/DPR-/Event-RVA-Export, transaktionale Dateiintegration und
UTF-8-JSON-Berichte. Der GUI-Fortschritt wird ueber einen Adapter an
Statusanzeige/ProgressBar weitergereicht. `DeDeClassHandle`,
`DeDeDisAsm`, `DeDeClassEmulator`, `DeDePAS` und `Emulator` haben ihre
direkten `MainUnit`-/Dialogabhaengigkeiten fuer den CLI-Analysepfad
verloren. Die Compiler-Version-/Kompatibilitaetszuordnung in `PreBtnClick`
delegiert jetzt ebenfalls an `TDeDeAnalysisSession.ConfigureVersion`.

`DeDeCLI.dpr` und `python DeDe\tools\build_xe.py --cli` bauen die separate
Konsole `bin/D_XE/DeDeCLI/DeDeCLI.exe`. Hilfe, ungueltige Optionen und die
nicht-interaktiven Fehler-/Exit-Code-Pfade wurden ausgefuehrt. Beide
Delphi-XE-Builds bestehen; der aktuelle DUnit-Satz besteht mit 30 Tests.
Die vom Nutzer angegebene Referenz-EXE wurde im CLI erkannt (D6), mit
852 Klassen, 33 Formularen und 33 Units analysiert und in 72 Projektdateien
exportiert. Ein frueher XE-Lauf hatte wegen Unicode-`PChar` sieben
zusaetzliche Methodenscans am Dateiende; der Decoder liest PE-Code jetzt
byteweise ueber `PAnsiChar` mit expliziter Pufferlaenge. Der korrigierte XE-
und Linux-Lauf erzeugt keine Begrenzungswarnungen. Der statische Vergleich bestaetigt
45.224/45.224 Opcodebytes, 36/36 DFM-Ressourcenpraefixe, 33/33 PAS-Namen
und DPR-Unitreferenzen sowie
542 benannte generierte Routinen im gespeicherten Decomp; 712 weitere
Routinen sind synthetische `_PROC_<RVA>`-Deklarationen. Der korrigierte
Goldenexport ist unter dem aktualisierten Manifest fixiert; der vorherige
XE-Export bleibt mit `pre-byte-fix` archiviert. Die Delphi-XE-Selbstbinary
wird weiterhin korrekt als nicht unterstuetztes Ziel abgewiesen.

Die Analyse-UI enthaelt weiter Hostvorbereitung: `MainUnit.PreBtnClick`
verwendet die Session jetzt fuer Klassen-Dump und Finalisierung, behaelt aber
Zielidentifikation, UI-Listenaufbau und DSF/DOI-Setup. `crtBtnClick` verwendet
den gemeinsamen Core-Exporter ueber eine nicht-besitzende Session. Der
Core-Pfad selbst enthaelt keine aktiven VCL-Dialog-/MessageBox-Aufrufe;
Disassemblerfehler werden gesammelt und gebuendelt an GUI bzw. JSON
weitergegeben. Details und Vergleichsgrenzen stehen in `docs/CLI.md` und
`docs/REFERENZBEFUND.md`.

### Native Windows FPC CLI (Win32/Win64)

Der zielbewusste FPC-Builder liest CPU und Betriebssystem aus dem Compiler
und legt die Artefakte getrennt ab. FPC 3.2.2/i386-win32 baut nach
`bin/Laz32/Win32`, FPC 3.2.2/x86_64-win64 nach `bin/Laz64/Win64`.
Beide CLI-Smokes bestehen. Der Win32-Export wurde mit dem XE-Export
strukturell verglichen: 72 Dateien, 852 Klassen, 33 Formulare/Units, gleiche
DFM-Bytes, DPR-Referenzen und Events, 1.344 Deklarationen sowie keine
fehlenden XE-Instruktionszeilen; alle 5.565 Win32-Instruktionszeilen sind
gegen die Input-PE verifiziert. Die Win32-FPC-Installation besitzt keine
eigene `fpc.cfg`; `build_fpc.py` fuegt ihre passenden RTL-/FCL-Unitpfade
explizit hinzu.

### Native Linux/Laz64 CLI (WSL-Validierung)

WSL Ubuntu 26.04 mit FPC 3.2.2 baut `bin/Laz64/Linux/DeDeCLI/DeDeCLI` aus
demselben Quellbaum. Native Linux-Smoke-, PE32-/Disassembler-Grenz- und
ZLib-ZIP-Matrizen bestehen. Der Lauf auf derselben Referenz-EXE ergibt D6,
852 Klassen, 33 Formulare/Units und 72 Dateien. `verify_cross_host_export.py`
vergleicht den aktuellen XE- und Linux-Export: DFM-Bytes, DPR-Unitreferenzen,
Events, Analysezahlen und 1.344 Prozedur-/Funktionsdeklarationen stimmen;
alle 5.565 Linux-Instruktionszeilen sind an den Raw-PE-Bytes verifiziert,
keine XE-Instruktionszeile fehlt. Linux decodiert 23 zusaetzliche
Instruktionszeilen. Bericht: `DeDe/build/FPC-Linux/cross-host-report.json`.
Ein erster separater LCL-GUI-Host steht jetzt bereit; die
historische VCL-Formularsuite und Windows-Prozess-/Registry-/Shell-Werkzeuge
sind weiterhin nicht nach Linux portiert.

### Linux LCL GUI host (WSLg)

`DeDe/src/DeDeLCL.lpi` baut mit Lazarus 4.8/lazbuild und GTK2 aus dem
portablen Analyse-Core. Die neue, codebasierte LCL-Form stellt Eingabe,
Ausgabeordner, Ueberschreiboption, Fortschritt, Warnungen und erzeugte
Dateien dar; die alten VCL-Forms werden nicht in diesen Build gezogen.
`tools/run_lcl_gui_smoke.py` zeigt die Form unter WSLg, analysiert die
Referenz-EXE und exportiert ueber `TDeDeAnalysisSession`. Der CLI-
Cross-Host-Checker bestaetigt 72 Dateien, 852 Klassen, 33 Formulare/Units,
gleiche DFM-Bytes und keine fehlenden XE-Instruktionszeilen. Bericht:
`DeDe/build/FPC-Linux/DeDeLCL/cross-host-report.json`.

### Platform service boundary

Die portable `TDeDeCoreContext.Confirm`-Schnittstelle verweigert Aktionen,
wenn kein Hostcallback gesetzt ist oder dieser `False` liefert. BSS/DATA-
Prozessspeicherdumps werfen auf Nicht-Windows-Hosts jetzt explizit
`EDeDeServiceUnavailable`. FPC/XE-Portabilitaetstests pruefen den
unterstuetzten Callback, Ablehnung und die Linux-Ausnahme. Registry,
Prozessenumerierung/-dump, Shell-Registrierung, Drag&Drop und alte
Toolfenster bleiben bewusst ausserhalb des Linux CLI-/LCL-Aufrufpfads.

### Strukturierte Cross-References und ABI-Evidenz (opt-in)

`DeDeXRef` speichert beim Disassemblieren erkannte PE32-x86-Calls getrennt
von den formatierten Assembly-Kommentaren. Direkte `E8 rel32`-Ziele werden
als PE32-VA berechnet; `FF /2`- und `FF /3`-Calls werden als indirekt erfasst
und ohne nachgewiesenes Ziel nicht aufgeloest. Wiederholtes Disassemblieren
dupliziert dieselbe Kante nicht. Die Routine-Evidenz speichert explizite
`ret`/`ret n`-Cleanupwerte und Konflikte; fuer einen Call wird ein direkt
nachfolgendes `add esp, n` erfasst und eingehend je Zielroutine verglichen.
Bytezaehler, die durch vier teilbar sind, werden als Stack-Word-Anzahl-
Kandidaten, nicht als vollstaendige Parameteranzahl ausgegeben.
Der Decoder liefert ueber `TdaRef` ausserdem beobachtete positive
`[ebp+offset]`-Zugriffe nur nach erkanntem kanonischem Frame-Prolog, zusammen
mit Operandbreite und Instruktions-VA. Die Werte werden als Stackparameter-
Evidenz klassifiziert (`matched`, `frame_access_only`, `cleanup_only`,
`conflicting`), nicht als behauptete vollstaendige Parameteranzahl, Typen
oder Namen. Vor jedem Call werden zudem erkannte letzte EAX/EDX/ECX-
Registerdefinitionen mit Quellinstruktions-VA gespeichert. Sie sind
Registerzustands-Evidenz, keine automatische Argumentzuordnung.

`dede-cli --xref` erzeugt separat `cross-references.json` und fuegt
Stackzugriff-Kommentare bei betroffenen PAS-Methodendeklarationen hinzu. Der
Standardexport ohne Option und `analysis.json` bleiben bytegleich. Der XE-Satz
besteht mit 30 Tests,
einschliesslich Vorwaerts-/Rueckwaerts-Relativcalls, indirektem Call,
Duplikatunterdrueckung, `ret n`, Caller-Cleanup und widerspruechlichen
Cleanup-Pfaden. Win32, Win64 und Linux FPC bauen und bestehen CLI-Smokes.
Die Referenz-EXE liefert unter allen drei FPC-Zielhosts 9.008 Callkanten,
1.600 Routinen/Bodies, darunter 927 transitiv entdeckte direkte Callziele;
1.108 Kanten treffen bekannte Klassenmethoden. 912 Routinen haben einen
Frame-Prolog; 118 zeigen positive Stackzugriffe (174 Offset-/Breiten-
kombinationen, davon 167 mit einem ausgerichteten Stack-Word-Slot-Kandidaten).
35 Routinen haben passende Cleanup-/Zugriffsevidenz, 37 widerspruechliche
Evidenz; 48 Routinen erhalten einen Stack-Word-Count-Kandidaten. Alle
Sidecars und alle 87 PAS-Evidenzkommentare (51 Stackzugriff-,
36 Cleanup-Kommentare) sind auf FPC Win32/Win64/Linux identisch. Bei
aktiviertem Sidecar bleiben Dateiliste und `analysis.json` unveraendert;
genau 14 PAS-Dateien erhalten die opt-in Kommentare, sonstige Dateiinhalte
bleiben zum Export ohne `--xref` bytegleich. 8.045 Callstellen enthalten
erkannte Registerdefinitionen (EAX: 7.730, EDX: 5.948, ECX: 2.494;
Mehrfachnennungen pro Aufruf moeglich); 48 Routinen haben einen aus
Cleanupbytes abgeleiteten Stack-Word-Count-Kandidaten. Der Sidecar fuehrt
ausserdem 407 Disassemblerdiagnosen auf, vor allem
`Unknown register`-Fehler der bestehenden Emulationsauswertung.

Die vorhandene Importnamen-Aufloesung ist an den Graphen angebunden: 14
absolute IAT-Slots wurden erkannt, aber kein Importname aufgeloest. Eine vollstaendige
Import-/VMT-/Datenreferenz-Aufloesung, vom exportierten Code unerreichbare
globale Routinen,
semantische Registerargument-/Aufruferzuordnung und eine Signaturinferenz
fuer Pascal-Deklarationen fehlen noch. Der Sidecar ist damit
eine verifizierte stackbezogene Evidenzstufe, nicht bereits ein vollstaendiger
Decompiler fuer Parameternamen und Typen.

Die XRef-Erweiterung nutzt jetzt versionsgebundene DSF-Signaturen, wenn ein
kompatibler Katalog neben der CLI liegt. Namen werden nur bei einem
eindeutigen Bytevergleich nach `UnlinkCalls` ausgegeben; Quelle und
`exact_pattern`-Vertrauen stehen im JSON. Ein Test prueft Versionsmaske,
Byteabweichung, Mehrdeutigkeit und den Vorrang von Klassensymbolen. Der
Decompilatbefund hat das DSF-Headerformat geklaert: Mode-Bit `$40` fuegt nach
dem Flag ein DWORD ein; `$80` markiert die aktuelle Formatgeneration.
`DeDeBPL` unterstuetzt das optionale DWORD nun beim Lesen und Schreiben. XE
DUnit besteht mit 32 Tests; FPC Win32/Win64 und Linux CLI bauen. Mit dem
Original-VCL6-Katalog werden 41.907 Symbole geladen; auf der Referenz-EXE
werden 240 Routinen und 3.830 Callkanten benannt. Die Windows- und Linux-
Sidecars bleiben byteidentisch. 1.682 DSF-benannte Callstellen erhalten
zusaetzliche `// DSF: <Symbolname>`-Kommentare in den PAS-Assemblerzeilen.
Der 3.11-Parser ohne diese Erweiterung wurde separat gegen denselben Katalog
getestet und endet mit `EReadError`.

Delphi 7 ist jetzt in der Core-Versionsdetektion enthalten: Der
TControl-Marker `$2F8` wird von D6 `$2F0` unterschieden; falls kein direkter
Marker gefunden wird, werden `VCL70.bpl`/`.dpl` als Fallback ausgewertet.
Die Konfiguration setzt die D7-Kompatibilitaetsmaske `$20`, waehlt
`vcl7.dsf` und schreibt den Nachweisweg nach `analysis.json`. Neue
synthetische PE32-Fixtures und Import-/Konfigurationstests bestehen. Ein
End-to-End-Lauf mit realer D7-EXE und VCL7-Katalog ist noch nicht belegt.
VMT-Versionsmarker und der Delphi-2-Booleanmarker werden nun mit dem
bounded `DeDeBinaryReader` gelesen; abgeschnittene Sections werden im
Regressionstest abgewiesen, ohne die Streamposition zu veraendern.
Auch die zentralen `GetByte`-/`GetWord`-/`GetDWord`-Zugriffe pruefen jetzt
PE32-Code- und Dateigrenzen ueber denselben Reader.
XRef-Signaturpuffer werden ebenfalls mit `ReadBytesAt` innerhalb der
Dateigrenzen gelesen und lassen die PE-Streamposition unveraendert.
Importdeskriptoren und Thunks werden ueber den bounded Reader geparst;
abgeschnittene Tabellen und Namen werden mit einem `EReadError` abgewiesen.
Compiler-Version, reduzierte Version, C++Builder-/Delphi-2-Modus,
DSF-First-Byte-Filter, BSS-/User-Procedure-Modus, Importauflösung,
Custom-Emulation und Disassembler-Stringoptionen liegen jetzt im jeweiligen
`TDeDeCoreContext` und werden bei Legacy-Aufrufen gebunden/restauriert. Das
ungenutzte globale `FirstCodeRVA` ist entfernt, der `DeDeSym`-Decoder
arbeitet pro `UnlinkCalls`-Aufruf lokal und aktuelle Routine-/Instruktions-
RVAs und Signaturnormalisierungszaehler liegen im Core-Kontext. Das
CRC-Flag und Disassembler-Fehlerakkumulator liegen nun ebenfalls im
Core-Kontext. SEH-/END-Stacks, Jump-/Push-Zustand, Try-Tiefe und
Instruktionsformatierungsflags sind ebenfalls kontextgebunden. Geteilte
Legacy-UI-Schalter bleiben bestehen; parallele Analyse ist weiterhin nicht
freigegeben.
