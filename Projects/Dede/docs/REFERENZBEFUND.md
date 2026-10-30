# Statischer Referenzbefund

Pruefdatum: 2026-10-24. Die EXE wurde nicht ausgefuehrt; der Abgleich ist
statisch per PE-Dateiinhalt erfolgt.

## Referenz

`C:\install\Development\DeDe.3.50.02.1619.bin\DeDe.exe`

SHA-256: `5D65B528574B9E2211F2721292FCD4979604E62B2B8A27AFC7F89C52E68BE134`

Die EXE wird unter diesem Hash als verbindliche statische Referenz verwendet.
Der Distributionsname 3.50.02.1619, VERSIONINFO 3.1.0.1619 / 3.10b und
die UI-Angabe 3.50.01 bleiben getrennt dokumentiert. Die Diskrepanz ist
kein Hindernis fuer die Zuordnung des DeDe-Dumps: Der Codevergleich
identifiziert den referenzierten Maschinenstand wesentlich genauer.

## Ergebnisse

| Pruefung | Ergebnis |
| --- | --- |
| PE-Format | PE32, x86 |
| Programmeinstieg VA | `005A54A8`, wie in beiden DPR-Dumps |
| DeDe-PAS/DPR-Opcodezeilen | 45.224 von 45.224 stimmen an der angegebenen VA bytegenau |
| Abweichende Opcodezeilen | 0 |
| Opcodehaltige Decomp-Quellen | 30 von 34 verglichenen PAS/DPR-Dateien; alle 30 ohne Byteabweichung |
| Dateien ohne Opcodezeilen | 4 (`AddClsMemDtaUnit`, `DOIAddDtaUnit`, `LodoUnit`, `ShowPluginUnit`) |
| Binaere DeDe-DFM | 33 von 33 enthalten ab `TPF0` den vollstaendigen identischen EXE-Ressourceninhalt |
| DFM-Dateihuellen | Zusaetzliche Bytes vor und nach dem Ressourceninhalt; Dateien nicht roh gleichsetzen |
| IDR-Formulare | Alle 36 Wurzelklassen haben eine namensgleiche Ressource in der EXE |
| Hashinventar | 1.037 Dateien aus Originaldistribution, trunk und Decomp; SVN-Metadaten ausgeschlossen |

Damit ist der DeDe-Dump belastbar dieser Original-EXE zugeordnet.
Der Vergleich belegt nur die tatsaechlich ausgegebenen Instruktionen,
nicht eine vollstaendige Codeabdeckung oder Identitaet aller EXE-Bytes.
IDR ist durch Einstiegspunkt, bereits bekannte gemeinsame Handleradressen
und Ressourcenklassennamen gestuetzt. Der erneute Lauf am 2026-10-24 ergab
genau 45.224 Treffer und null Opcodeabweichungen; die 33 DFM-Ressourcen
stimmen jeweils als `TPF0`-Payload-Praefix ueberein. Der volle IDR-Code
wurde nicht gegen alle Bytes disassembliert; ein eigenschaftsweiser
Text-DFM-Abgleich und die Messung nicht dekompilierter Codebereiche stehen
weiterhin aus.

## Gegenprobe mit dem neuen CLI-Exporter

Die angegebene EXE wurde auch als Eingabe von `DeDeCLI.exe` analysiert
(weiterhin ohne die Ziel-EXE auszufuehren). Der Legacy-Scanner erkennt
`D6`; der Core meldet 852 Klassen, 33 Formulare und 33 Units und erzeugt
72 Projektdateien inklusive JSON-Bericht.

- Alle 33 exportierten PAS-Dateinamen stimmen mit `Decomp/DeDe` ueberein.
- Alle 672 exportierten Methodendeklarationen enthalten jetzt ihre 8-stellige
  Ziel-Code-VA als Kommentar. Bei 670 Methoden stimmt sie mit der ersten
  Instruktionsadresse des Disassemblies ueberein; zwei synthetische
  Routinen haben leere Disassemblies. Im Referenzprogramm gibt es unter
  diesen deklarierten Methoden keinen belegten VMT-Slot; virtuelle Methoden
  wuerden zusaetzlich im IDR-Format `//v<Offset>//<VA>` markiert.
- Alle 1.001 PAS-Instanzfelddeklarationen tragen den IDR-Stil
  `//f<HexOffset>` aus der Klassenfeldtabelle. Die bekannten `AboutUnit`
  Offsets fuer `Panel1`, `OKButton` und `Image1` stimmen mit IDR
  (`f2F0`, `f2F4`, `f2F8`) ueberein.
- Alle 33 DPR-Unitreferenzen stimmen mit dem gespeicherten `DeDe.dpr`
  ueberein. Im bytekorrektierten Export finden sich 542 eindeutige benannte
  Prozedur-/Funktionsdeklarationen in den gespeicherten `Decomp/DeDe`-Units.
  Zusaetzlich enthaelt der Export 712 synthetische `_PROC_<RVA>`-
  Deklarationen fuer nicht symbolisch benannte Methoden; die
  Namensueberdeckung belegt keine Gleichheit der Pascal-Implementierungen.
- Die 33 vorhandenen DFM-Dateinamen stimmen ueberein; zusaetzlich exportiert
  der CLI drei im EXE-Ressourcenbaum gefundene DFM-Ressourcen, die in
  `Decomp/DeDe` nicht als separate Datei vorliegen.
- Alle 36 exportierten DFM-Payloads stimmen ab `TPF0` als Praefix mit einer
  Ressource der Referenz-EXE ueberein. Ein direkter Vergleich ganzer
  DFM-Dateien waere irrefuehrend, weil die Dateien unterschiedliche
  Nachlauf-/Wrapperbytes enthalten koennen.

Ein frueher Delphi-XE-CLI-Lauf meldete sieben zusaetzliche Methodenscans am
Dateiende (Start-RVAs `00447E8F`, `0044A48D`, `0044C271`, `004A8294`,
`004CAADF`, `004D534C` und `005788A3`). Die Ursache war die Verwendung von
Unicode-`PChar` fuer x86-Maschinencode; der byteorientierte Decoder nutzt
jetzt `PAnsiChar` und prueft die uebergebene Pufferlaenge. Der aktualisierte
XE-Goldenexport und der Linux-Lauf melden fuer diese Datei keine
Begrenzungswarnung mehr.

Der WSL/Linux-Export hat dieselben 72 Dateinamen, 852 Klassen, 33 Formulare
und 33 Units. Alle DFM-Dateien, DPR-Unitreferenzen, Events und 1.344
Prozedur-/Funktionsdeklarationen stimmen mit dem korrigierten XE-Export
ueberein. XE-dekodierte Instruktionszeilen fehlen nicht; Linux liefert 23
zusaetzliche Instruktionszeilen, deren Bytes einzeln gegen die Raw-PE-Datei
verifiziert wurden. Das ist eine gemessene Ausgabeverbesserung; sie ersetzt
nicht den unabhaengigen statischen Befund von 45.224/45.224
Decomp-Opcodebytes.

## Reproduktion

Im Zielordner ausfuehren:

```powershell
python tools/inventory_reference.py
```

Optionale Pfade: `--root` fuer den dedex-Ordner und `--distribution` fuer
die Originaldistribution. Das Werkzeug verwendet nur die Python-Standardbibliothek
und liest die PE-Ressourcen direkt, ohne das Windows-Ladeverfahren zu verwenden.

Erzeugte Dateien:

- `reference-inventory.csv`: Dateipfade, Groessen und SHA-256.
- `reference-check.json`: PE-Sektionen, Ressourcen, Vergleiche je Quelldatei,
  Abweichungen, DFM-Huellen und IDR-Klassenzuordnungen.

Das Inventar enthaelt relative Pfade mit separater Herkunftsspalte. Der
aktuelle Lauf erzeugte die Vergleichsdateien nach erneuter Hashpruefung der
vom Nutzer genannten EXE; die EXE wurde nicht gestartet.

## Naechster Schritt

Die bytegenaue Pruefung bestaetigt die Herkunft der ausgegebenen Decomp-
Instruktionen, nicht die Korrektheit oder Vollstaendigkeit der rekonstruierten
Pascal-Quellen. Der verbleibende Validierungsschritt ist ein kontrollierter
Analyse-/Exportlauf auf einer vertrauenswuerdigen Delphi-2-bis-6-Binary.
Ausserdem offen bleiben ein vollstaendiger IDR-Codeabgleich und der
eigenschaftsweise Vergleich der 36 Text-DFMs.
