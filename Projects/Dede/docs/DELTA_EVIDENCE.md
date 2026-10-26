# 3.11 -> 3.5 Routine-Delta-Evidenz

## Zweck und Kennzeichnung

Diese Datei beginnt die routineweise Gegenueberstellung der V3.11-Quellen
mit den V3.5-Decompilaten. Sie dokumentiert nur belegte Beziehungen und
trennt Verhalten von Umbenennungen. Eine passende Routine allein belegt
keine vollstaendige Verhaltensgleichheit des gesamten Workflows.

Kategorien:

- **Unveraendert/belegt**: Quellenroutine und Zielcode zeigen denselben
  semantischen Ablauf mit direkter Opcode-/DFM-Evidenz.
- **Ziel-only/geaendert**: Zielcode oder Zielressource fuegt Verhalten hinzu
  oder aendert die Bindung.
- **Unklar**: die Evidenz reicht nicht, um Quellsemantik oder Feldzuordnung
  sicher zu bestimmen.

## MainUnit-Namensueberdeckung

Ein case-insensitiver Scan der Implementationsteile zaehlt 123 eindeutige
Routinenamen in `trunk/Source/Main/MainUnit.pas` und 79 in
`Decomp/IDR/MainUnit.pas`; 51 Namen kommen in beiden vor. 72 Namen sind
vorerst nur in der Basisquelle und 28 nur im Ziel-IDR vertreten.

Das ist eine Suchhilfe, keine Delta-Klassifikation: Ein fehlender Zielname
beweist nicht, dass eine Routine entfernt wurde; sie kann umbenannt,
verschoben, in einer anderen IDR-Unit enthalten oder vom Decompiler nicht
symbolisch wiederhergestellt sein. Die 28 Ziel-only Namen enthalten auch
unaufgeloeste `sub_...`-Routinen und mitdekompilierte Abhaengigkeiten. Nur
Eintraege mit Opcode-/DFM-/Aufruferevidenz werden als Deltas gewertet.

## Erste Zuordnung: Process-Button-MouseDown

| Merkmal | V3.11-Basis | V3.5-Ziel | Befund |
|---|---|---|---|
| Formular-Handler | `trunk/Source/Main/MainUnit.pas`: `TDeDeMainForm.btnProcessMouseDown` | `Decomp/IDR/MainUnit.pas`: `TDeDeMainForm.PrcsBtnMouseDown`; Code bei `00599198` | Hohe semantische Uebereinstimmung |
| Button/Eventbindung | `trunk/Source/Main/MainUnit.dfm`: `btnProcess`, `OnClick=PreBtnClick`, `OnMouseDown=btnProcessMouseDown`; DFM-Stream-Name bei Byteoffset 10538 | `Decomp/IDR/DeDeMainForm.dfm`: `PrcsBtn`, `OnClick=PreBtnClick`, `OnMouseDown=PrcsBtnMouseDown`; auch in `Decomp/DeDe/MainUnit.dfm` belegt | Ziel benennt Button und MouseDown-Handler um |
| Debug-Schalter | `bDebug := ssShift in Shift`; spaeter wird bei `bDebug` `Application.ExeName` mit `.dbg.txt` gespeichert | Ziel testet das Shift-Bit und schreibt den Boolean nach `gvar_005ADCEE`; im Ziel-`PreBtnClick` wird dieses Flag vor dem `.dbg.txt`-Speicherpfad gelesen (`00593F94` bis `00593FD3`) | Belegt: derselbe Shift-gesteuerte Debug-Export |
| User-Prozedur-Flag | `bUserProcs := [ssALT, ssShift, ssCtrl] - Shift = [ssLeft]` | Ziel bildet die Setoperation als `not Shift`, AND-Maske `0x07`, Vergleich mit `0x08` ab und speichert das Ergebnis nach `gvar_005ADCEF` (`005991B6` bis `005991CE`) | Hohe Uebereinstimmung; Zielglobal durch korrespondierenden Datenfluss zugeordnet |

**Einordnung:** Der Handler ist kein neu erfundenes 3.5-Verhalten. Die
V3.11-Quelle enthaelt bereits die beiden Shift-/Modifier-Auswertungen; im
Ziel sind die UI-Komponente und Handlerbezeichnung anders. Die aktuelle
Arbeitsquelle behaelt noch `btnProcess` und `btnProcessMouseDown`, fuehrt
aber dieselbe Handlerlogik aus. Es wurde deshalb keine funktionale Aenderung
vorgenommen. Das zielgenaue Umbenennen von DFM-Komponente und Pascal-Feld
waere eine separate, behavior-neutrale Quellenangleichung.

**Beibehaltene Auffaelligkeit:** Der Vergleich `([ssAlt, ssShift, ssCtrl] -
Shift) = [ssLeft]` wirkt mit der ueblichen `TShiftState`-Belegung
unerreichbar: die linke Menge enthaelt `ssLeft` nicht. Der V3.5-Code erzeugt
jedoch denselben `0x07`-Masken-/`0x08`-Vergleich. Das wird als moeglicher
historischer Fehler markiert, nicht als Rekonstruktionsdelta „repariert“.

**Evidenzstaerke:** Hoch fuer Methodensignatur, Shift-Bit-Auswertung,
`.dbg.txt`-Speicherpfad und Ziel-DFM-Bindung. Die Zuordnung des zweiten
Zielglobals zu `bUserProcs` ist stark, aber basiert auf Datenfluss und dem
entsprechenden V3.11-Ausdruck, nicht auf einem erhaltenen Quellvariablennamen.

## Zweite Zuordnung: DPJ-Menuehandler bleiben Stubs

| Merkmal | V3.11-Basis | V3.5-Ziel | Befund |
|---|---|---|---|
| `LoadProjectFile1Click` | `MainUnit.pas` zeigt `Not implemented yet!` und verlaesst die Routine vor `DeDeDPJEng.LoadDPJFile` | IDR `MainUnit.pas`, `005A08D0` bis `005A09B7`: derselbe Text und unbedingter Sprung zum Ende; IDR-DFM bindet `LoadProjectFile1Click` | Gleiches beobachtbares Stub-Verhalten |
| `SaveProjectFile1Click` | `MainUnit.pas` zeigt `Not implemented yet!` und verlaesst die Routine vor dem DPJ-Aufruf | `Decomp/IDR/MainUnit.pas`, `005A09E8` bis `005A0A63`: `ShowMessage('Not implemented yet!')`, danach unbedingter Sprung zum Routineende | Gleiches beobachtbares Stub-Verhalten |
| `SaveProjectFileAs1Click` | `MainUnit.pas` zeigt denselben Text und verlaesst die Routine vor Save-Dialog und `SaveDPJFile` | `Decomp/IDR/MainUnit.pas`, `005A0A84` bis `005A0BB7`: derselbe Text und unbedingter Sprung ueber den nachfolgenden Dialog-/Speichercode | Gleiches beobachtbares Stub-Verhalten |
| Ziel-UI | Baseline-DFM/Form besitzt die Save-Project-Aktionen | `Decomp/IDR/DeDeMainForm.dfm` fuehrt `SaveProjectFile1` und `SaveProjectFileAs1` | UI vorhanden, Funktion laut Ziel nicht implementiert |

**Einordnung:** Das Ziel hat an diesen Menu-Handlern keine aktive
DPJ-Speicherfunktion hinzugefuegt. Obwohl sowohl die V3.11-Quelle als auch
das 3.5-Decompilat nach dem Stub noch DPJ-Speichercode erkennen lassen,
verhindert der fruehe Exit bzw. der Ziel-Sprung dessen Ausfuehrung. Die
separat rekonstruierte DPJ-Streamroutine ist davon zu unterscheiden.

**Evidenzstaerke:** Hoch fuer den sichtbaren Stub-Text und den
Ziel-Kontrollfluss (unbedingter Sprung ueber den Speicherpfad). Der
nachgelagerte DPJ-Code ist kein Beleg dafuer, dass die UI ihn ausfuehrt.

## Ziel-only Einheit: MemLoc-Prozessauswahl

| Merkmal | V3.11-Basis | V3.5-Ziel | Rekonstruktion |
|---|---|---|---|
| Unit | Kein `MemLocUnit.pas` in `trunk/Source/Main` gefunden | Eigenstaendige `MemLocUnit`-Form und `ChooseMemLocForm.dfm` in IDR | Ziel-only, kein 3.11-Routinepaar |
| Windows-9x-Pfad | Kein MemLoc-Pfad in der Basis | `GetVersion` waehlt `sub_0051E0A8`; IDR-Imports/_Unit143 belegen Toolhelp32 | Toolhelp-Aufzaehlung ist implementiert |
| NT-Pfad | Kein MemLoc-Pfad in der Basis | `GetVersion` waehlt `sub_0051E320`; IDR/_Unit144 belegen `EnumProcesses`, `EnumProcessModules`, `GetModuleBaseNameA` | PSAPI-Aufzaehlung ist implementiert |
| Anzeigeformat | Nicht anwendbar | Beide Pfade fuellen `ProcsCB`; Namen werden auf mindestens 30 Zeichen aufgefuellt, Win9x-PIDs mit 8 und NT-PIDs mit 4 Hexziffern | Beide Pfadformate werden rekonstruiert |

**Einordnung:** Der Ziel-Dropdown hat zwei plattformspezifische
Aufzaehlungswege. Die Arbeitskopie verwendete zuvor nur Toolhelp und deckte
damit den IDR-belegten NT/PSAPI-Pfad nicht ab. `MemLocUnit` enthaelt jetzt
beide Zweige. `TestMemLocEnumeratesCurrentProcess` besteht fuer den
aktuellen Host und bestaetigt den dort erreichbaren Pfad; ein Win9x-Lauf ist
nicht verfuegbar.

**Sicherheits-/Formatabweichung:** Der IDR-NT-Pfad uebergibt `0x100` Bytes
an `EnumProcesses` und verwendet anschliessend den Rueckgabewert in der
Schleifenbegrenzung ohne sichtbare Umrechnung von Bytes in DWORD-PIDs. Die
Rekonstruktion behandelt `cbNeeded` gemaess PSAPI-Vertrag als Bytezahl,
vergroessert den Puffer bei Bedarf und prueft Prozess-/Modulzugriffe. Sie
verwendet fuer das blosse Auslesen des Modulnamens `PROCESS_QUERY_INFORMATION
or PROCESS_VM_READ` statt des im Ziel sichtbaren `PROCESS_ALL_ACCESS`.
Diese sichereren NT-Pfadgrenzen sind bewusst dokumentierte Abweichungen;
kein fremder Prozess wurde fuer den Test ausgefuehrt oder veraendert.

## Dritte Zuordnung: SaveProject1Click-Verarbeitungs-Guard

| Merkmal | V3.11-Basis | V3.5-Ziel | Befund |
|---|---|---|---|
| Guard | `MainUnit.pas`: `if not FbProcessed then Raise Exception.Create(err_nothing_to_save)` | IDR-Opcodes `005991F0`-`00599224`: Test des Bytefelds `TDeDeMainForm+0x558`; bei null wird die Ziel-Fehlerzeichenkette als Exception erzeugt und ausgeloest | Semantisch gleiche Vorbedingung und Fehlerfolge |
| Feldzuordnung | Klassenfeld `FbProcessed` | IDR deklariert `f558: byte`; der Guard benutzt genau diesen Offset | Stark korrespondierend, symbolischer Zielname ist nicht erhalten |

**Einordnung:** Der Ziel-Handler bestaetigt die Verarbeitungspruefung des
V3.11-Codes und nicht eine neue Speicherroutine. Die Ziel-Feldzuordnung
`f558 = FbProcessed` ist durch das Guard-Verhalten und die gleiche
Fehlerkante stark belegt; ein vollstaendiger Feldlayout-Abgleich waere
noetig, um sie als symbolisch exakt zu bezeichnen.

**Evidenzstaerke:** Hoch fuer Kontrollfluss und Fehlerpfad; mittel-hoch fuer
die konkrete Zuordnung des anonymen Feldoffsets zu `FbProcessed`.

## Vierte Zuordnung: FormCloseQuery

| Merkmal | V3.11-Basis | V3.5-Ziel | Befund |
|---|---|---|---|
| Bestaetigungsdialog | `MainUnit.pas`: zeigt `msg_exit_dede_confirm`; bei `mrNo` wird `CanClose := False` gesetzt | IDR-Opcodes `0059A7C4`-`0059A7FA`: derselbe modale Ja/Nein-Bestaetigungspfad und dieselbe Ablehnung bei Resultat 7 (`mrNo`) | Gleiches Schliessverhalten |
| Schliessen waehrend Process | Wenn `btnProcess.Enabled = False`, `FormDestroy(Self)` und `ExitProcess(0)` | Ziel fragt `PrcsBtn.GetEnabled`; bei disabled ruft es `FormDestroy` auf und beendet mit `ExitProcess(0)` (`0059A7FD`-`0059A81C`) | Gleiches Sonderverhalten waehrend der Verarbeitung |
| Ereignisbindung | Baseline-MainUnit-DFM bindet `OnCloseQuery = FormCloseQuery` | IDR-DFM `DeDeMainForm.dfm` bindet ebenfalls `OnCloseQuery = FormCloseQuery` | Kein Event-Delta belegt |

**Einordnung:** Die Routine ist ein direkter semantischer Match. Das Ziel
verwendet den umbenannten Process-Button; Bestaetigungsentscheidung,
`CanClose`-Ergebnis und Notausstieg waehrend laufender Analyse bleiben
erhalten.

**Evidenzstaerke:** Hoch fuer Dialogresultat, Close-Veto, Process-Button-
Status und Abbau-/Exit-Folge. Die Ereignisbindung ist direkt im Text-DFM
belegt.

## Fuenfte Zuordnung: Wechsel von WM_DROPFILES zu TFileDrop

| Merkmal | V3.11-Basis | V3.5-Ziel | Befund |
|---|---|---|---|
| Drop-Empfang | `MainUnit.pas` deklariert `DropFiles(var Msg:TMessage)` als `WM_DROPFILES`-Message-Handler. Die Routine fragt alle Pfade ab und fuegt vorhandene Dateien in `RecentFileEdit` ein bzw. selektiert sie. | IDR `MainUnit.pas` deklariert `f527:TFileDrop`; `FormCreate` erstellt die Komponente, setzt `OnDrop` auf Callbackadresse `005A38D0`, bindet sie an `Self` und aktiviert sie (`00594C59`-`00594C9E`). | Ziel ersetzt den direkten Form-Message-Handler durch die TFileDrop-Komponente |
| Lebenszyklus | Kein `TFileDrop`-Feld oder Lebenszyklus im 3.11-MainUnit-Bestand belegt | Ziel-`FormDestroy` gibt `f527` frei (`00594FE5`); `FileDrop`-IDR sichert/ersetzt den WindowProc und setzt `DragAcceptFiles` | Neue Ziel-Komponentenintegration |
| Callback-Verhalten | Baseline-Handler fuellt die Recent-File-Liste und startet nicht unmittelbar die Analyse | Ziel weist einen `OnDrop`-Callback zu; dessen Zieladresse `005A38D0` ist in den vorliegenden IDR-Listings nicht als eigenstaendige symbolische Routine rekonstruiert | Exakte Zielentscheidung bei Mehrfachdateien/Bestätigung bleibt offen |

**Einordnung:** Die Einfuehrung von `TFileDrop` und ihr Create-/Bind-/Enable-/
Destroy-Lebenszyklus sind direkt belegt und bereits in `DeDe/src` umgesetzt.
Die Arbeitskopie `FileDropOnDrop` verarbeitet derzeit die erste Datei nach
Process-Button-Pruefung und Bestaetigung. Der DUnit-HDROp-Test belegt die
synthetische Komponentenzustellung, aber nicht die semantische Gleichheit
dieses Callback-Ablaufs mit der nicht symbolisch dekodierten Zielroutine.

**Evidenzstaerke:** Hoch fuer den Wechsel des Drop-Empfangs und den
Komponentenlebenszyklus; offen fuer die exakte Callback-Logik im Ziel.
