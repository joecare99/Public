# DeDe: Hinweise fuer eine spaetere Bereinigungsphase

## Zweck und Grenze

Die aktuelle Arbeitsphase rekonstruiert das Verhalten und die Datenformate
der Originalversion. Die folgenden Punkte sind von dieser Rekonstruktion
getrennte Verbesserungsvorschlaege. Eine eng begrenzte DPJ-Eingabepruefung
wurde bereits als dokumentierte Haertung umgesetzt; weitergehende
Formatkorrekturen gehoeren in eine separate Folgephase mit eigener Testsuite.

## DPJ-Rundlauf und Dateisicherheit

- Der IDR-Writer (`00559908`) schreibt nach Projektname und Zielpfad die
  PE-CRC, danach Symbol-/Konfigurations-/Klassendaten und erst spaeter die
  Kommentaranzahl samt 104-Byte-Records.
- Der IDR-Reader (`005595C8`) liest direkt nach Projektname und Zielpfad eine
  Kommentaranzahl. Bei einem vom Writer erzeugten DPJ wird damit die CRC als
  Anzahl interpretiert. Ein Roundtrip ist daher asymmetrisch und wurde in
  dieser Rekonstruktionsphase nicht ausgefuehrt.
- `TComment` ist im Speicher 260 Bytes gross, der Ziel-Writer speichert
  jedoch nur die ersten 104 Bytes je Eintrag. Das wird derzeit bewusst
  beibehalten, weil es dem IDR-Writer entspricht.
- In einer Bereinigungsphase sollte ein neues, versioniertes DPJ-Format mit
  klaren Abschnitten, CRC-Verifikation, begrenzten Laengen und korrespondierendem
  Reader/Writer entworfen werden. Alte DPJ-Dateien benoetigen einen getrennten
  Legacy-Reader. Vor der Aenderung sind vorhandene DPJ-Dateien zu sichern und
  mit Roundtrip-Tests abzudecken.
- Als dokumentierte Haertung prueft `ReadDPJCommentRecords` die Dateigrenze
  vor der Arrayallokation; `LoadDPJFile` gibt den Stream per `try..finally`
  frei. Das verhindert unnoetige Allokationen und Leaks, behebt aber nicht
  die Format-Asymmetrie des Originals.

## Klassenmetadaten und Compiler-Versionen

- Beim Selbsttest mit der unter Delphi XE gebauten EXE zeigte
  `TDefaultDBScreenApplication` den Fehler `FieldTblPos=1F5E13`. Die Bytes
  dort beginnen mit `1B` (Laenge 27) und dem ANSI-Klassennamen, nicht mit
  einer Feldtabelle. Das spricht fuer einen VMT-/FieldTable-Layoutunterschied
  zwischen dem alten Analyzer und dem XE-Selbsttestziel; die
  Referenzkompatibilitaet bleibt unbewiesen.
- Eine spaetere Erweiterung sollte VMT-Layouts nach Compiler-Version
  unterscheiden, Feldtabellen vor dem Lesen validieren und wiederholte
  modale Fehler zu einer zusammengefassten Diagnose machen. Diese Aenderungen
  wuerden die Referenzsemantik erweitern und gehoeren nicht in die
  Rekonstruktionsphase.

## PAS-Methodenadressen

- Jede Methodendeklaration im PAS-Klassenabschnitt erhaelt jetzt die
  8-stellige Ziel-VA aus der Methodentabelle als Kommentar, z. B.
  `procedure FormCreate(Sender: TObject);//00489410`. Damit laesst sich die
  Deklaration unmittelbar der disassemblierten Routine zuordnen; die Adresse
  ist eine Adresse im analysierten PE, kein Hostzeiger oder Dateioffset.
- Wenn derselbe Codezeiger nachweislich in einem VMT-Slot steht, folgt das
  IDR-Format `//v<Offset>//<VA>`, etwa `//v14//0045D434`. Nicht-virtuelle
  Methoden erhalten nur die VA. Die Zuordnung wird beim VMT-Scan aufgebaut
  und auch fuer spaeter erkannte synthetische Routinen verwendet; fehlende
  Zuordnungen bleiben explizit als Sentinel markiert.
- `TestVMTMethodOffsetMapping` prueft einen virtuellen und einen nicht-
  virtuellen Eintrag anhand eines synthetischen PE-Streams. Der
  Cross-Host-Verifier prueft fuer jede exportierte PAS-Klassendeklaration
  die Kommentarform und vergleicht die VA bei vorhandenem Disassembly mit
  der ersten Instruktionsadresse. In der DeDe-3.5-Referenz haben alle 672
  Methodendeklarationen eine Code-VA; 670 Startadressen stimmen mit dem
  Disassembly ueberein, zwei synthetische Routinen haben leere
  Disassemblies. Keine der dort exportierten Methoden wird als VMT-Methode
  erkannt.
- Instanzfelder in PAS-Klassendeklarationen tragen zusaetzlich den
  IDR-kompatiblen Offset `//f<Hex>` aus `TFieldRec.dwID`, z. B.
  `Panel1: TPanel;//f2F0`. Der Cross-Host-Verifier prueft alle 1.001
  Feldkommentare und verankert `AboutUnit.Panel1`, `OKButton` und `Image1`
  an den IDR-Offsets `f2F0`, `f2F4` und `f2F8`.

## BSS-/DATA-Live-Erfassung

- `DeDeBSS.Dump` versucht, das Zielprogramm mit `CreateProcess` zu starten.
  Wenn das fehlschlaegt, zeigt der Originalcode `Can not create process`,
  fuellt die Listen danach aber mit Platzhalterwerten und laesst den Dump
  fortfahren.
- Beim Delphi-2005-Fixture endete der Lauf nach dieser Meldung trotzdem mit
  `Dump Successful`; dies bestaetigt nicht die Live-Erfassung der BSS-/DATA-
  Werte. Die Ursache des `CreateProcess`-Fehlers wurde nicht bestimmt; die
  Windows-Defender-Erkennung wurde nicht umgangen.
- Eine Bereinigung sollte `GetLastError` protokollieren und den Ergebnisstatus
  als statischen Dump mit fehlender Live-Erfassung kennzeichnen.

## Datei-Drop und Dialoge

- `FileDropSmoke.dpr` verifiziert den Same-Process-`HDROP`-Dispatch, die
  Dateireihenfolge, den Callback und WindowProc-Restore. Ein echter Drop aus
  dem Explorer bleibt ungetestet.
- Der IDR-Wrapper verwendet `MakeObjectInstance`/`SetWindowLongA`; die
  Rekonstruktion verwendet `TWinControl.WindowProc`. Bei spaeterer
  Quelltreue sollte das Verhalten bei Handle-Neuerstellung und im echten
  Shell-Drop verglichen werden.
- UI-Smoke-Tests sollten Dialogtitel, Text und Buttons erfassen und nur
  bekannte Meldungen nach passender Bedingung bestaetigen. Der Loader-Prompt
  muss bis zur tatsaechlichen Erstellung des Zielfensters offen bleiben.

## UI-Entkopplung und CLI

- `TDeDeAnalysisSession.Analyze` besitzt jetzt einen eigenen
  `TDeDeCoreContext` und aktiviert ihn nur waehrend Session-Aufrufen;
  `AttachAnalysis` leiht den vom GUI-Host gesetzten Kontext. Ein Regressionstest
  bestaetigt getrennte Reports und Warnungslisten fuer zwei angehaengte
  Sitzungen. `PEFile`, `PEHeader`, `PEStream` und das ELF-Flag werden waehrend
  eines Session-Aufrufs ebenfalls auf das Session-Image gesetzt und danach
  wiederhergestellt. Die Legacy-Routinen lesen diese Werte intern weiterhin
  global; andere Parser-/Disassembler-/Compilerzustands-Globals bleiben
  gemeinsam, weshalb parallele Analysen im selben Prozess noch nicht
  unterstuetzt sind.
- Der PE-Loader und `TPEHeader.Dump` lesen die Datei jetzt ausschliesslich
  ueber das uebergebene `ThePEFile`; die Header-/Section-Parsermethoden
  verwenden ihren `Self`-Header statt der globalen `PEHeader`. Der Core
  ruft die neue `GetDelphiVersion`-Variante mit explizitem Header/Format auf.
  `LoadPEBinary` veraendert dadurch keine globalen PE-Bindungen mehr.
- `TClassesDumper` und `TClassDumper` halten nun das analysierte
  `ThePEFile`/`TPEHeader`-Paar und bieten ihren Stream ueber diese
  Instanzbindung an. `TDeDeAnalysisSession.DumpClasses` injiziert das Image;
  `DeDeClassEmulator`, Symbol-CRC und die PE-Header-/Importsuche des
  Disassemblers holen File/Header aus dem aktiven Core-Kontext. Der
  Disassembler loest Stream und RVA-Konverter bevorzugt aus diesem Kontext;
  globale Stream-/Konverter-Fallbacks bleiben fuer GUI-Aufrufer. Weitere
  Decoderoptionen und Control-/Symbol-Listen sind noch gemeinsam.
- Der CLI-Export plant alle Namen vorab, erzeugt die Dateien in einem
  staging-Unterordner und versucht, bei Installationsfehlern bereits
  verschobene Dateien zurueckzunehmen. Bei einem fehlgeschlagenen Rollback
  bleibt der Staging-Ordner absichtlich erhalten, damit gesicherte
  Bestandsdateien nicht geloescht werden.
- Die Core-Analyse verwendet im ersten Schnitt keine DSF-/DOI-Ladevorgaben
  aus der GUI-Registry. Dadurch koennen erzeugte Disassemblies weniger
  Symbole/Offsetinformationen enthalten als ein interaktiv konfigurierter
  GUI-Lauf. Die GUI-eigene Orchestrierung ist noch nicht auf die Session-API
  umgestellt.
- Die Ausgabe wird fuer sichere Dateisystemnamen sanitisiert; der JSON-
  Bericht listet relative Dateinamen und Diagnosewarnungen. Fehlende
  Eingaben, nicht erkannte Legacy-Versionen und vorhandene Ausgabedateien
  ohne `--force` sind explizite Fehler. Der CLI-Export wurde inzwischen
  end-to-end mit der bereitgestellten Referenz-EXE getestet (D6, 852
  Klassen, 33 Formulare, 72 Ausgabedateien); die Referenz wurde dabei nur
  analysiert, nicht gestartet. Ein frueher XE-Lauf meldete sieben zusaetzliche
  Methodenscans am Streamende; nach dem byteorientierten PChar-Fix liefern
  die korrigierten XE- und Linux-Laeufe keine Grenzwarnungen.
- Die GUI fragt beim Core-Export bei einem vorhandenen Ziel jetzt einmal fuer
  die gesamte Dateigruppe nach, statt pro Datei einzeln. Bei Ablehnung bleibt
  der vorhandene Satz unveraendert; bestaetigtes Ersetzen verwendet denselben
  Staging-/Rollbackpfad wie die CLI.
- `DisassembleProc` zeigte Fehler zuvor unmittelbar als Win32-MessageBox.
  Der Core sammelt diese Diagnosen jetzt einschliesslich ProcName, Instruktion
  und Streamposition in `sDisAsmErrors`; Exportbericht und GUI-Adapter koennen
  sie gebuendelt anzeigen. PE-/DFM-/Klassen-/Disasm-/BSS-/Symbol-Hilfseinheiten
  verwenden keine direkten Dialog-/VCL-Aufrufe mehr. Die GUI stellt die
  BSS-Laderbestaetigung ueber `TDeDeCoreContext.OnConfirm` bereit.

## Cross-References und ABI-Evidenz

- Der bisherige Disassembler loeste Call-, Import-, String-, Control- und
  DSF-Referenzen nur fuer die sichtbaren Assembly-Kommentare auf. Die
  optionale `--xref`-Ausgabe ergaenzt jetzt einen strukturierten Call-Graph
  aus den beim Export disassemblierten Routinen und den transitiv erreichbaren
  direkten Callzielen.
- Fuer `--xref` wird der zum erkannten Compiler passende `vcl*.dsf`-Katalog
  neben der CLI geladen. Die DSF-Signaturen werden nach derselben
  `UnlinkCalls`-Normalisierung wie im Disassembler exakt verglichen; eine
  versionsinkompatible Signatur oder mehrere unterschiedliche Namensmatches
  erzeugen keinen geratenen Namen. XRef-Eintraege fuehren Quelle und
  Vertrauensstufe (`built_in_dsf`, `exact_pattern`); eindeutige Treffer
  erscheinen auch im Assembly-Kommentar. Klassenmethoden-Metadaten haben
  Vorrang. Das DSF-Laden meldet Fehlerklasse und -text in den Analysewarnungen.
  Die Repository-Quelle enthaelt keine `.dsf`-Assets; der Sidecar weist
  fehlende oder inkompatible Kataloge explizit aus. Die Decompilate (`IDR`
  `_Unit82`/`_Unit85`) zeigen den fehlenden Formatunterschied: bei Mode-Bit
  `$40` folgt auf das Flag ein zusaetzliches DWORD, danach erst Recordcount,
  Patternlaenge und Offsets. Mode-Bit `$80` kennzeichnet die aktuelle
  Formatgeneration; das Decompilat meldet fehlendes `$40` als zu alt und
  fehlendes `$80` als altes Format, das aktualisiert werden soll.
- `DeDeBPL` liest und schreibt dieses optionale DWORD nun. Der 3.11-Parser
  aus `trunk` tut dies nicht; ein isolierter DCC32-Probeaufbau mit dem
  unveraenderten `DeDeBPL.pas` erhielt beim Originaleintrag `Vcl6.dsf`
  `EReadError: Stream-Lesefehler`. Die ZIP-Datei `DSF\VCL7.dsf` enthaelt
  genau einen gleichnamigen Roh-DSF-Eintrag, den der Loader nach einer
  Entpackstufe liest. Dessen Felder sind mit dem erweiterten Layout gueltig:
  Mode `$E0`, Extension-DWORD `0`, 42.904 Records, Patternlaenge 50,
  Patternoffset `$29`, Namensoffset `$20BBD9` und Kommentarlaenge 20.
- Der echte VCL6-Katalog aus der Referenzdistribution laedt jetzt 41.907
  Symbole. Auf der Referenz-EXE werden 240 Routinen und 3.830 Callkanten
  eindeutig benannt, z. B. `System.@LStrAddRef` und
  `Controls.TControl.SetText`. Die geladenen Windows-/Linux-XRef-Sidecars
  sind byteidentisch. 1.682 DSF-benannte Callstellen werden zusaetzlich als
  `// DSF: <Symbolname>` direkt an den jeweiligen PAS-Assemblerzeilen
  ausgegeben. Der volle 3.11-GUI-Build scheitert unter dem
  bereitgestellten DCC32 weiterhin separat an einem unguarded Lazarus-
  `Interfaces`-Verweis und der Delphi-Kompatibilitaet der alten VCLZip-Units;
  der Parser selbst wurde isoliert kompiliert und getestet.
- Delphi-7-Erkennung ist davon getrennt noch offen. Das 3.5-Decompilat
  ordnet in `IDR\_Unit78.pas` den Marker `$2F8` D7 und `$2F0` D6 zu; die
  Importerkennung erkennt `VCL70.bpl`/`.dpl`, und der damalige DSF-Pfad bildet
  `D7` generisch auf `vcl7.dsf` ab. Der aktuelle CLI-Pfad ruft die
  Importerkennung nicht auf, der direkte Markerpfad unterscheidet `$2F8`
  nicht, `ConfigureVersion` setzt keine D7-Maske `$20`, und
  `GetVersionedDSFName` kennt D7 nicht. Daher ist das geladene VCL7-DSF noch
  nicht korrekt an D7-Analysen gebunden.
- `E8 rel32` wird als PE32-VA-Kante gespeichert; `FF /2` und `FF /3` sind
  indirekte Calls ohne geratenes Ziel. Der Graph enthaelt Routine-/Instruktion-
  VAs und bleibt bei wiederholter Disassemblierung dedupliziert. Beim Export
  werden bekannte Routinen und Callziele anhand der Klassenmethodentabelle
  benannt.
- Fuer ABI-Folgeanalyse werden unmittelbare `ret`/`ret n`-Cleanupwerte je
  Routine sowie ein direkt auf einen Call folgendes `add esp, n` als
  Caller-Evidenz erfasst und je direktem Callziel aggregiert. Der Decoder-
  Callback `TDisAsm.OnRef` liefert fuer Routinen mit erkanntem
  `push ebp; mov ebp, esp`-Prolog positive EBP-relative Stackzugriffe samt
  Operandbreite, Quellinstruktions-VA und ausgerichtetem
  Stack-Word-Slot-Kandidaten. Cleanup und Zugriffe werden als passend, nur
  beobachtet oder widerspruechlich klassifiziert. Vor Calls werden erkannte
  letzte Definitionen von EAX/EDX/ECX mit VA protokolliert, aber nicht als
  Argumente behauptet. Das beweist weder Gesamtparameteranzahl noch
  Registerargumente oder Typen/Namen und aendert keine PAS-Signatur.
- Die separate `cross-references.json`-Ausgabe laesst Dateiliste und
  `analysis.json` unveraendert. Bei `--xref` werden zusaetzlich 87 Kommentare
  (51 Stackzugriff-, 36 Cleanup-Evidenzen) in 14 betroffene PAS-Dateien
  eingefuegt; sonstige regulaere Artefakte bleiben bytegleich. Die
  Referenzdatei erzeugt 9.008 Kanten, 1.600 Routineeintraege/Bodies, davon
  927 transitiv entdeckte direkte Callziele, und 1.108 bekannte
  Klassenmethoden-Kanten. 912 Bodies haben den kanonischen Frame-Prolog;
  118 zeigen positive Stackzugriffe (174 Offset-/Breitenkombinationen, 167
  ausgerichtete Stack-Word-Slots). 35 Routinen haben passende Cleanup-/
  Offsetevidenz, 37 widerspruechliche Evidenz; 48 Routinen haben einen
  Cleanup-Word-Count-Kandidaten. FPC/Win32, Win64 und Linux
  erzeugen identische Sidecars und PAS-Evidenzkommentare.
- 8.045 Callstellen enthalten erkannte Registerdefinitionen (EAX 7.730,
  EDX 5.948, ECX 2.494; Mehrfachbelegung moeglich). Die 407 waehrend der
  optionalen Analyse aufgefangenen Disassemblerdiagnosen, vorwiegend
  `Unknown register` aus der bestehenden Emulationsauswertung, bleiben im
  Sidecar sichtbar. 48 Routinen erhalten ausserdem einen
  Stack-Word-Count-Kandidaten aus ausgerichteten Cleanupbytes.
- Die bestehende Importnamen-Aufloesung ist an den Graphen angebunden, traf
  auf der Referenz-EXE 14 absolute IAT-Slots, aber keinen Importnamen. Weitere
  Inferenzschritte bleiben:
  vollstaendige Import-/VMT-/Datenzielaufloesung, semantischer Register-
  Datenfluss, vom exportierten Code unerreichbare globale Routinen und die aggregierte
  Parameterbelegung an Aufruferstellen. Typ- und Namensinferenz benoetigt
  weiterhin RTTI, Symbole oder andere starke Metadaten.

## VCLZip / Standard-ZLib

- Die aktive VCLZip-Bindung wurde durch `DeDeZip.pas` ersetzt. Alle vier
  Dateiformat-Adapter (`DeDeDPJEng`, `DeDeDUF`, `DeDeOffsInf`, `DeDeBPL`)
  lesen und schreiben nun ueber denselben ZIP-Container mit Raw-DEFLATE aus
  der Standard-ZLib. Die ungenutzten Imports in `StatsUnit` und `DeDeSym`
  wurden ebenfalls entfernt.
- `run_zip_archive_tests.py` prueft originale `d2.doi`, `D6.DOI` und
  `VCL7.dsf` unter Delphi XE/Win32, FPC/Win64 und WSL/Linux, round-tripped alle
  unkomprimierten Nutzdaten, prueft falsche Eintragsnamen/CRC und verifiziert
  neu geschriebene Archive mit Python `zipfile`.
- Der Adapter unterstuetzt bewusst nur die in DeDe verwendeten
  Single-Disk-/Single-Entry-Archive (Stored oder Deflate, keine Verschluesselung
  oder ZIP64) und prueft Grenzen, Groessen und CRC. Neue ZIP-Features brauchen
  eigene Fixtures und duerfen nicht als implizit unterstuetzt gelten.
- Die isolierte VCLUnZip-Gegenprobe war im frueheren Konsolen-Harness auch
  auf Originalarchiven fehlerhaft. Daher wird keine direkte Lesbarkeit durch
  die alte VCLUnZip-Version behauptet; die getestete Kompatibilitaet gilt fuer
  Originalarchive, DeDes Adapter-Roundtrip und den unabhaengigen Python-
  ZIP-Reader. Die alten VCLZip-Vendorquellen verbleiben nur als historische
  Dateien und sind nicht mehr im Buildpfad.

## Bitness-/Betriebssystem-Portierung: PE32/Linux-CLI

- Die PE32-Metadaten- und Fileoffset-Typen bleiben 32 Bit. Der
  `ReadProcessMemory`-Bytecount in `DeDeBSS.Dump` ist explizit `QWord` fuer
  64-Bit-FPC und `Cardinal` fuer XE/Win32, passend zur API-ABI; er beschreibt
  keine Eingabedaten. Auf Nicht-Windows-Hosts meldet der Prozessspeicher-
  Dump explizit, dass er nicht unterstuetzt wird.
- Die alten `TList`-Container fuer BSS-/DATA-Werte, Klassen-zu-Instanz-
  Zuordnungen, Emulator-Register/Locals und DOI-Offsets speichern jetzt
  32-Bit-Werte in `TPE32DWordList`, nicht in Pointerfeldern. Ein eigener
  High-Bit-/Undefined-Vektor laeuft unter XE, FPC/Win64 und WSL/Linux.
  `ReadProcessMemory` bekommt einen hostbreiten Pointer nur an der
  Windows-API-Grenze; FPC meldet in den migrierten Units keine
  Ordinal-zu-Pointer-Konvertierungswarnungen mehr.
- `DeDeClasses` und die fuer den Datei-Analysepfad noetigen Serviceunits
  verwenden keine `Windows`-Unit mehr fuer PE-Felder. SoftIce und
  VersionInfo-API-Zugriffe sind an Windows gebunden; Linux setzt die
  Hostversion-Funktion nicht und behaelt die festgelegte DeDe-Version.
- `DeDeCore` importiert keine `Windows`-Unit mehr. Tickcount und
  Dateiumbenennungs-/Loeschoperationen laufen ueber `DeDeCoreServices`;
  Windows-spezifische Implementierung bleibt am Host-Service-Rand.
- `DeDePAS` adaptiert FPCs `TBinaryObjectReader` fuer Delphi-DFM-Prefixe,
  Lese- und Listenoperationen. `MethProp` speichert aenderbare Lookup-
  Tabellen als Variablen statt beschreibbarer typisierter Konstanten.
- Der x86-Decoder nutzt jetzt `PAnsiChar` fuer Zielcodebytes und eine
  explizite Restpufferlaenge. Das behebt eine XE-spezifische Unicode-
  `PChar`-Fehldeutung, die PAS-Ausgabe und Methoden-Scan-Warnungen
  veraenderte. `StartNewPas` schreibt seine ASCII/ANSI-Header ebenfalls
  byteweise statt Unicode-Charlaengen als Byteanzahl zu verwenden.
  Ziel-Immediate-Adressen in `TdaRef` sind jetzt `DWORD`, nicht ein
  hostbreiter Pointer. `DeDeMemDumps.AddProcessPointerOffset` benutzt
  typisierte Bytepointer-Arithmetik fuer echte Host-/Remote-API-Pointer.
- Die korrigierte Ausgabe wurde als neues XE-Golden festgehalten; der
  vorherige Export/Manifest liegen mit `pre-byte-fix` zur Nachverfolgung
  daneben. WSL Ubuntu 26.04/FPC 3.2.2 baut und startet die native Linux-
  CLI. `verify_cross_host_export.py` belegt 72 Dateien, gleiche
  Analysezahlen, DFM-Bytes, DPR-Referenzen, Events und 1.344
  Routine-Deklarationen; Linux verliert keine XE-Opcodezeile und fuegt 23
  PE-byteverifizierte Zeilen hinzu. BSS/DOI/class-map/emulator-Zielwerte
  verwenden jetzt fixed-width typed lists statt Pointerfelder; der FPC
  Win64-Build meldet dort keine Ordinal-zu-Pointer-Konvertierungen mehr.
  FPC Win32/Win64/Linux verwenden getrennte Zielordner; Win32- und Win64-
  CLI-Smokes bestehen. Ein erster GTK2-LCL-Host nutzt die Session ebenfalls
  und erzeugt im WSLg-Smoke einen gegen denselben Cross-Host-Vertrag
  geprueften Referenzexport.
  Andere Compilerwarnungen, darunter Managed-Local-Diagnosen, bleiben
  einzeln sichtbar statt pauschal unterdrueckt.

## Prozessauswahl / MemLoc

- Der IDR-Pfad waehlt auf Win9x Toolhelp32 und auf NT PSAPI. Die
  Rekonstruktion hatte zuerst nur Toolhelp verwendet; sie enthaelt jetzt
  beide Pfade und nutzt die schon in `DeDeMemDumps` geladenen PSAPI-Funktions-
  pointer. `TestMemLocEnumeratesCurrentProcess` prueft, dass der aktuelle
  Prozess unter dem Testhost im Dropdown erscheint.
- Der IDR-NT-Pfad uebergibt `0x100` als Bytegroesse an `EnumProcesses`, laesst
  den Bytezaehler danach aber wie eine Anzahl von DWORD-PIDs in die Schleife
  einfliessen. Die Rekonstruktion teilt `cbNeeded` durch `SizeOf(DWORD)` und
  vergroessert den Prozesspuffer bis zum vollstaendigen Ergebnis. Das
  verhindert eine moegliche Fehlindizierung; es ist eine dokumentierte
  Haertung gegenueber dem IDR-abgeleiteten Verhalten.
- Die Zielroutine oeffnet jeden Prozess mit `PROCESS_ALL_ACCESS`. Die
  Rekonstruktion nutzt fuer das reine Lesen des Modulnamens nur
  `PROCESS_QUERY_INFORMATION or PROCESS_VM_READ` und ueberspringt nicht
  zugaengliche Prozesse. Das ist eine minimale-Rechte-Abweichung; der
  Win9x-Zweig wurde auf diesem Host nicht ausgefuehrt.

## Parserzustand und undefinierte Rueckgaben

- `DeDeCrypt.pas` definierte `DWord` nur fuer exakt `VER120` als
  `LongWord`; unter Delphi XE fiel der SHA-1-Worttyp damit auf signed
  `LongInt` zurueck. Die SHA-1-Initialwerte mit gesetztem hohem Bit erzeugten
  W1012 und falsche Digests. `DWord` ist nun `LongWord`, passend zur
  32-Bit-unsigned-Arithmetik des Algorithmus. Die DUnit-Fixture
  `TestSHA1KnownVectors` prueft die bekannten SHA-1-Digests fuer `abc` und
  die leere Eingabe; Hash-Eingaben werden dabei explizit als ANSI-Bytes
  uebergeben. Das ist eine XE-Kompatibilitaetskorrektur, keine Aenderung des
  SHA-1-Formats.
- Die Emulatoren geben bei unbekannten Registern oder unimplementierten
  EBP-relativen Operanden keine zufaelligen Register-/Funktionswerte mehr
  weiter: `TCPUEmulator` prueft Registerindizes vor dem Arrayzugriff und
  meldet unbekannte Register sowie den explizit unimplementierten
  EBP-Speicherpfad mit `EConvertError`. `Str2TRegister` weist unbekannte
  Registertexte ebenfalls explizit ab. Die privaten Zustandsleser des
  Klassenemulators initialisieren ihre Ergebnisse; fuer gueltige Enumwerte
  bleiben die Zuordnungen unveraendert. `TestEmulatorInvalidInputs` prueft
  gueltige Teilregisterwerte und die Fehlerpfade. Das ist eine dokumentierte
  Haertung; das Emulatorverhalten fuer ungueltige bzw. bisher nicht
  unterstuetzte Eingaben ist nicht als Referenzverhalten belegt.
- Weitere Compiler-Warnstellen wurden kontrollflussbezogen determinisiert:
  `RunHiddenStuff` startet seinen Trefferzaehler bei null; `IntLStr` startet
  den temporaren Signed-Wert definiert; `WriteIntData` liefert bei einem
  unbekannten Operandformat den definierten Offset null passend zum
  `?Int`-Ausgabetext. Die DSF-Hierarchie-Info beginnt als nil, bevor der
  optionale Smart-Mode sie setzt. Die drei leeren ASMShow-Referenzcallbacks
  liefern jetzt `False`, statt einen unbestimmten Bool-Wert zurueckzugeben.
  Der Plugin-Startscan initialisiert den Offset und liest nur vorhandene
  Listeneintraege; der Kommentar-Button beendet sich ohne Treffer, statt
  hinter das Listenende zu indizieren.
- `TMakePEHForm.Button2Click` hatte ein nicht erzeugtes lokales
  `TPEHeader`-Objekt verwendet. Der Pfad erzeugt den Header jetzt vor dem
  Dump, gibt ihn im `finally` frei und initialisiert `DVer` vor der
  Compilererkennung. Diese notwendige Laufzeitkorrektur betrifft nur den
  PE-Header-Korrekturdialog; der GUI-Ablauf wurde nicht interaktiv getestet.
- Der DCU-Parser verglich den unsigned `Cardinal`-Enumwert mit null, obwohl
  dieser Wertebereich nicht negativ sein kann; der nutzlose Test wurde
  entfernt. `TShortStrDef.Show` vergleicht dagegen ein signed `TNDX`-Feld
  mit `Cardinal(-1)`, was Delphi als stets false diagnostizierte. Der
  Sentinel wird jetzt signed als `-1` verglichen. `GetSymbolReference`
  pruefte einen `Cardinal`-Offset auf `< 0` und addierte danach die
  Patternlaenge im unsigned Bereich. Der Test ist durch eine
  Int64-Streamgrenzenpruefung ersetzt; `TestSymbolReferenceOffsetBounds`
  prueft eine unter die ImageBase fallende RVA, die sonst auf einen hohen
  32-Bit-Dateioffset umschlaegt.
- `TBSS.GetDataPrtOfBSSData` durchlief RVAs mit einem signed `Integer`,
  waehrend Start und Groesse unsigned DWORD-Werte sind. Der Scanzaehler ist
  jetzt unsigned; `TestBSSAddressRangeAboveSignedLimit` prueft einen
  Datenbereich ab `$80000000`. `DeDeExpressions` verwendet nun ebenfalls
  DWORD-RVAs wie der gespeicherte Record, initialisiert einen nicht
  gefundenen Kommentar als leeren String und `AddExpression` delegiert an
  `AddNewExpression` statt sich selbst aufzurufen.
  `TestExpressionHighRVA` deckt Suchen, Aktualisieren und nicht gefundene
  Eintraege mit einem RVA oberhalb der signed-32-bit-Grenze ab.
- `DeDeMemDumps` bildete Remote-Prozessadressen durch Addition in `LongInt`
  und anschliessenden Pointer-Cast. Bei Win32-Modulbasen oberhalb `$7FFFFFFF`
  war das signed overflow. `AddProcessPointerOffset` fuehrt diese Addition
  jetzt mit typisiertem `PByte`-Pointer-Offset aus; PE-Header-, Section-, Code- und Ressourcen-
  Lesezugriffe verwenden den Helfer. Stream-Offsets werden als `Int64`
  gebildet, relative 32-Bit-Displacements anschliessend bewusst auf `DWORD`
  reduziert. `TestProcessPointerOffsetAboveSignedLimit` prueft die
  Pointeraddition mit einem synthetischen High-Address-Wert; echter
  Fremdprozesszugriff bleibt ungetestet.
- `TClassParser.ParseClass` hatte einen `Boolean`-Rueckgabewert, setzte ihn
  aber nie. Er ist jetzt `False`, wenn der Parser beim Fehler-Sentinel bleibt,
  und ansonsten `True`; die bestehenden Aufrufer verwenden weiterhin
  Klassenname und Vererbung wie zuvor.
- `TNewDCU2DSFParser.ParseIt` konnte bei einem `end;` ohne vorheriges `begin`
  einen uninitialisierten Index und Musterpuffer ausgeben. Der Parser setzt
  Zustand und Puffer jetzt zurueck, gibt fuer solche unverknuepften Enden
  keinen Datensatz aus und prueft Hexbytes explizit mit `TryStrToInt`.
- `FixDCUEndMarkers` initialisiert den Scanstatus fuer beide Durchlaeufe
  separat und prueft den Zugriff auf die vorherige Zeile am Listenanfang.
  Dadurch bleibt eine fehlerhafte Ausgabe deterministisch und wird weiter
  durch `VerifyParse` als ungueltig gemeldet, statt mit undefiniertem Zustand
  oder einem Indexfehler fortzufahren.
- In `Dcu32.ReadUses` bricht ein Typ-Importtag innerhalb einer DLL-Importliste
  nun vor dem gemeinsamen Listen-Append ab; der vorhandene Unexpected-Tag-
  Fehlerpfad verhindert dort die Verwendung eines alten `TR`-Werts.
- Die W1036-Warnungen fuer `E`, `B`, `RTTISz` und `TR` in `Dcu32.pas`
  bleiben nach Kontrollflusspruefung bestehen: `E` wird nur bei `Ok=True`
  ausgegeben, `B` nur nach dem ersten Bytezugriff in einer nichtleeren
  Bit-Schleife verwendet und `RTTISz` nur fuer `drImpTypeDef` gelesen und
  weitergereicht. Alle Pfade, die den gemeinsamen Append in `ReadUses`
  erreichen, erstellen `TR`; nicht unterstuetzte Tags brechen vorher ab und
  werden vom bestehenden Fehlerpfad abgewiesen.
- `ParserWarningsSmoke.dpr` deckt unpassendes `end;`, leere Muster, ein
  vollstaendiges 50-Byte-Muster und den ParseClass-Status ab. Das ist eine
  eng begrenzte Haertung fuer fehlerhafte Parser-Eingaben; der uebliche
  Musterpfad bleibt unveraendert.
- `DCUEndMarkersSmoke.dpr` testet die Duplikatbereinigung, den Listenrand
  und die Behandlung einer leeren Ausgabeliste.
- `DedePProject.EndProject` initialisiert den Zaehler fuer den Zeilenumbruch
  der `USES_LIST`. Die Liste wird weiterhin nach jedem fuenften Komma
  umgebrochen; `ProjectUsesWrapSmoke.dpr` prueft diesen Rhythmus.

## MainUnit: DFM-Header und Plugin-Callbacks

- Die drei DFM-Stream-Builder berechneten die Headerlaenge mit
  `Length(Caption[i])`, wobei `i` nach der Schleife nicht definiert war. Da
  die Indexierung einen einzelnen Klassennamen-Character liefert, wird jetzt
  explizit ein Byte abgezogen (`en-beg-1`); gueltige, nichtleere DFM-Namen
  behalten damit dieselbe Laenge.
- `ClassRefInCode` startete mit uninitialisiertem `bStrMode`. Der Scan beginnt
  nun definiert ausserhalb eines Pascal-Strings.
- `Disassemble` meldet `False` bis ein Decode erfolgreich abgeschlossen ist;
  eine nicht korrigierbare relative Referenz bleibt ein Fehler. `GetCallReference`
  meldet nur bei einem gefundenen Published-, IDATA- oder DSF-Verweis `True`;
  ein fehlgeschlagener Lesezugriff auf das moegliche Import-Opcodewort wird
  nicht mehr anhand uninitialisierter Bytes ausgewertet.
- In `PIULDrawItem` setzte der Selektionspfad `C5` zweimal und liess `C6`
  uninitialisiert, obwohl `C6` als Schriftfarbe verwendet wird. Der
  Selektionswert ist jetzt `clWhite`. `MorePEinfo1Click` sichert den
  Rueckgabewert vor dem Dialog-/Dateiablauf explizit.
- `MainUnitCallbacksSmoke.dpr` prueft den Null-Offset-Rueckgabepfad und dass
  dabei die Ausgabeparameter unveraendert bleiben.

## Prozess- und Compiler-Versionserkennung

- `MemGetDelphiVersionOfAProcess` konnte bei nicht auffindbarem Prozessmodul
  ohne gesetzten Rueckgabewert zurueckkehren. Es liefert jetzt den bereits
  verwendeten Unknown-Marker `$FFFF` und beendet sich bei fehlgeschlagenem
  `OpenProcess` bzw. fehlender Modulbasis, bevor Prozessspeicher gelesen wird.
- `MapDelphiVersionMarker` zentralisiert die Delphi-2-bis-6-Zuordnung fuer
  `DumpProcess` und den RVA-Button. Der ebenfalls dokumentierte D6-Marker
  `$160` wird wie `$15C` auf Version 6 abgebildet; unbekannte Marker ergeben
  Version 0 statt eines uninitialisierten `DVer`.
- Bei einem unbekannten Marker behaelt `DumpProcess` den vorhandenen
  PE-`AddressOfEntryPoint`, statt aus einem zufaelligen Versionsmuster einen
  neuen Wert abzuleiten. Der RVA-Button findet mit unbekannter Version keinen
  Compiler-spezifischen Treffer und zeigt wie vorgesehen den vorhandenen
  Fehlerdialog.
- `MemDumpVersionSmoke.dpr` testet Marker, unbekannte Versionen und den
  PID-0-OpenProcess-Fehlerpfad. Die Aenderung betrifft unbekannte oder nicht
  erreichbare Prozessziele; erkannte Delphi-Versionen behalten ihre
  Zuordnung.

## ANSI-Kompatibilitaet

- `DeDeAnsiStream` erhaelt die byteorientierten ANSI-Formate unter Delphi XE
  und wird fuer DPJ, DOI, DUF, DSF, WPJ/ALF, PE-Metadaten und Symbolnamen
  verwendet.
- Die Konvertierung nutzt die aktuelle System-ANSI-Codepage. Fuer reproduzierbare
  nicht-ASCII-Dateinamen sollte die naechste Phase pruefen, ob eine explizite
  Codepage der Originalversion erforderlich ist.

## Lazarus/FPC

- Die Installation enthaelt FPC 3.2.2 fuer x86_64-win64 und i386-win32 sowie
  passende FPC- und LCL-Units. Der portable CLI-Core baut jetzt auf beiden
  Windows-Targets; Win32- und Win64-Smokes bestehen. Der Win32-Export stimmt
  strukturell mit dem XE-Referenzexport ueberein. Die getrennte Linux-LCL-GUI
  bleibt als eigener Portierungsschritt offen.
