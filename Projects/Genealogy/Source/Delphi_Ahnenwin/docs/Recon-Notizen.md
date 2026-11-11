# Recon-Notizen (AhnenWin 5.1 / IDR-Disassembly)

Technische Merkhilfen für die methodische Rekonstruktion. Doku des Fortschritts: `Restplan.md`.

## Build & Workflow
- Build: `cmd /c build.cmd -unit N`, workdir `Delphi_AhnenWin`; **EXIT=0 ohne "Fehler"** = grün (Hinweise/Warnungen egal).
- Marker-Technik: offene Blöcke mit `end; {temp}` provisorisch schließen; jeder Chunk ersetzt den `{0058.... - naechster Anlauf (Cxx: ...)}`-Marker; jeder Zwischenstand baut.
- **Assy-`jmp X;`-Zeilen** niemals als Pascal schreiben — nur als `{ jmp X; }`-Kommentar (sonst E2003/E2029).
- **E2029 `'.' erwartet`** an der Procedure-Ende heißt fast immer: ein `end;` zu viel irgendwo vorher (Block-Balance prüfen).
- `je Label` → Loop-Top ohne `Next` = Endlosschleife im Original → Pascal: `Next; Continue;` (Terminierungssicherheit).
- Sprünge `je X` / `jne Y` aus Loop-Tails auf Loop-Köpfe als `Continue`, auf Loop-Ende als `Break` / Fallthrough übersetzen.

## Assembler-Muster → Pascal
| Muster | Bedeutung |
|---|---|
| `call dword [ecx+60]` | `TField.AsString` (Getter) |
| `call dword [edx+58]` | `TField.AsInteger` (Getter) |
| `call dword [ecx+0B0]` mit edx=Str | `TField.AsString :=` (Setter) auf TField-Objekt |
| `call dword [ecx+2C4]` | `TDataSet.FindKey` (test al → je) |
| `call dword [ecx+248]` | `TDataSet.Post` |
| `call dword [ecx+150]` | **kontextabhängig**: auf lfbh2 = Bookmark-getter (bmk); auf Table13 [0CC] = **RecNo** (bestätigt: oabk L2802 `sub_00576EB0(Table13.RecNo,u)`, L5872) |
| `call dword [ecx+1A0]` | `GotoBookmark` (edx=bmk) |
| `call dword [edx+0C4]` | `TCheckBox.Checked` |
| `call @LStrCatN` edx=N | `concat` aus N Strings (Pushs in umgekehrter Reihenfolge) |
| `call @LStrPos`, test/jle | `Pos(...) > 0` |
| `cmp dword [eax+0A1],0` | `TDataSet.Eof` (je/jne = Break/Weiter) |
| `mov byte [ebp-0AC],0B` | `leere := False` (Byte-Flag mit Value-Typ-Tabelle) |
| `inc dword [ebp-1C]` | Integer-Inkrement (KEIN Boolean!) |

## String-Konstanten (ofb3, 0058C8xx)
`58C884 '*'` · `58C88C/#13#10` · `58C890 'M'` · `58C89C '000000*'` · `58C8AC 'W'` · `58C8B8 'Pro'` · `58C8C4 'mut'` · `58C8D0 'vat'` · `58C8F8 ' '` · `58C904 ' * '` · `58C910 '' (leer)` · `58C938 ', '` · `58C944 '.'` · `58C950 ' ~ '` · `58C95C ' + '` · `58C974 ')'` · `58C980 #13#10` · `58CA00 ']'` · `58CA30 'Kind(er): '` · `58CA44 ' - '` · `58CA50 '. '` · `58CA5C ' ['` · `58CA68 ' [oo '` · `58CA78 ' (TP: '` · `58CA88 'Mutter nicht bekannt: '` · `58CAA8 'Vater nicht bekannt: '` · `58CAC8 'Kind(er), Mutter nicht bekannt: - '` · `58CAF4 'Kind(er), Vater nicht bekannt: - '`

## Table1-Felder (DataModule2) — Feld-Offsets
Nummer **[534]** · Vater **[538]** · Mutter **[53C]** · Name [540] · Vornamen [544] · Geschlecht [548] · Religion [54C] · Beruf [550] · Gebtag [554] · Gebmonat [558] · Gebjahr [55C] · Gebort [560] · Tauftag [564] · Taufmonat [568] · Taufjahr [56C] · Taufort [570] · Taufpat [574] · Lebensort [578] · Sttag [57C] · Stmonat [580] · Stjahr [584] · Stort [588] · Todesurs [58C] · Kommentar [5B0] · Lebt [5B4] · Namex [5BC] · Hausname [5C8] · Alter [5EC]

**⚠ Häufiger Fehler:** [538] = **Vater**, [53C] = **Mutter** — vor jedem Edit prüfen, welches Feld der `cmp`/`mov`-Offset adressiert!

## DataModule2-Objekt-Offsets (eax aus [0061DC3C])
Table1 **[5C]** · Table13 **[0CC]** · Table14-TTable **[0E0]** · Table14-Zeile-TField **[1E8]** · Table14-Nm-TField **[1EC]** · Table18 **[140]**
Table13-Felder: Ort **[A44]** · PLZ [A48] · Land [A4C] · ... · Lkr [A64] · **Abk [A68]** · Lg [A6C] · Bg [A70] (Unit2 L656-668)
Table18-Felder: Nummer [4C8] · Epnum [4CC] · Satag [4E0] · Samonat [4E4] · Sajahr [4EC]?? (prüfen) · Saort [4F0] · Satrauz [4F4] · Verbind [4F8] · Htag [4D0]?? · Hmonat [4D4]?? · Hjahr [4D8] · Hort [4DC]

## Form1 / Form24 / Form15
- Form1 **[0061DBD4]**: Label19 **[404]** · lfbh2 (TClientDataSet) **[8B8]**; Fields: Nm [90C] · Eh [914] · **Aus [920] = Integer** · **Hei [924] = String-Jahresfeld (lfbh2Edit/Post: Sajahr [4EC] / Hjahr [4D8])** · Ix [918] · Nam [91C] (Unit1.pas L411-418)
- Form15 **[0061D7F4]** (Unit15-L19+): QuickRep1 [2F0] · QRBand1 [2F4] · QRLabel1 [2F8] · QRLabel2 [2FC] · QRShape3 [304] · QRMemo1 [310] · QRDBText4 [31C] · QRDBText5..12 [320..33C] · QRDBText1 [350] · QRDBText2 [354] · QRLabel3 [368]; TQRLabel.SetAutoStretch = `[+0E4]`→ in Recon via `.AutoSize`; `+242`-Byte-Write per `PByte(Integer(Comp)+$242)^ := 0`; OnPreview `+2AC/+2A8` = **nicht implementiert** (Konv. Unit1 L8282, Unit16)
- Form24 **[0061D330]**: CheckBox14 **[394]**, Checked via vtbl+0C4
- Form1-Memo1 [220]?? · DBMemo1 (Width +48, Font +68) — Kommentar-Mirror

## gvar-Weichen (Delphi-Globale, meist `= 1` gesetzt)
25363EC Alter · 25363F0 Beruf · 25363F4 Notiz/Kommentar · 25363F8 Todesurs · 25363FC Satrauz-TZ · 2536400 Taufpat · 2536404 Religion · 2536410 oabk-Schalter (Ort-Abk. nach gvar_02536664 statt in zzg) · 2536414/2536418 Kinder-Name-Weichen (gvar_02536440-Add) · 2536454 lfbh2-IndexName-Save (AnsiString) · **2536644** gvar_02536644 (**Single**, Zeilen-/Trefferzähler; `mov dword [2536644],0` / `inc dword [2536644]` = Ganzzahl-Op, kein String!) · 2536664 gvar_02536664 (AnsiString, oabk-Anhang)

## Subroutines (Unit3)
- `sub_00576FF8(ALine; var out)` — Datum-Normalisierer (`'T.M.J'` → formatiert)
- `sub_00576F54(idx: Integer; var out)` — idx = ebx, liefert Orts-/Kürzel-Anhang
- `sub_00576EB0(ALine: Integer; var out)` — Nr → String (IntToStr-Format)
- `oabk(ALine; var out)` — Orts-Abkürzung; Ergebnis wird bei `gvar_02536410=1` an `gvar_02536664` gehängt statt in `zzg`
- `illki(ALine: AnsiString; ANr: Integer; var AErgebnis: AnsiString)` — Kette `'*Nr*Nr*'` → lesbare Liste; Aufruf `illki(u, idx, out)`

## ofb3-Struktur (00585048–0058C854) — grobe Karte
1. **Haupt-Loop** `while not Form1.lfbh2.Eof` (00586D6A / Tail 0058BFDD je→6D6A)
2. Person-Block: Name/Vornamen/Religions-/Berufs-/Datums-/Todes-/Kommentar-Blöcke (gvar-gegate)
3. **Kommentar-Mirror**: Memo1.Lines.Assign(Table1Kommentar), repeat-Loop → `zzg += #13#10 + Trim(line)`
4. **Ehen-Loop**: `i := Length(lfbh2Eh) div 7; if i > 0 then repeat` (ehn-Index, Blöcke à 7 Zeichen in lfbh2Eh)
5. **Table18-Loop** pro Epnum: `u := Copy(lfbh2Eh, (ehn-1)*7+1, 6); if StrToInt(u) = Table18Epnum` → `patn := Epnum`
6. **'Ehes'-Block**: Hochzeits-/Heimatdaten (`'- oo '`, lfbh2.Edit/Post für Aus-Feld)
7. **Kopf** (gueltig/gvar_02536454/Pro-Index/lfbh2-Marker `' [Nm]'`/Scan-Loop `' [oo Nm]'` über lfbh2Eh)
8. **Körper pro Epnum**: Hauptzeile + Kind-Loops **M** (Index 'vat', Vater=patn, unkMut) und **W** (Index 'mut', Vater=patn, unkVat) — Kinderzeilen nach CheckBox14/Weichen 414/418/Name; `'Mutter/Vater nicht bekannt: '+illki(...)`; lfbh2-Kopf-Marker gespiegelt
9. **Ehen-Loop-Tail** (0058B8E4): Table18.Next; Eof→Break; Epnum=num→Continue; sonst Break; `Inc(ehn); Dec(i); until i = 0`
10. **Table14-Write** (0058B920): `Table14Zeile.AsString := zzg`
11. **2. Pass** (B97C..BF75): nur wenn `Trim(lfbh2Eh) = '000000*'` → Geschlecht M/W → IndexName 'vat'/'mut' → FindKey([perNr]) → Loop: Mutter/Vater=0 → lfbh2-Kopf-Check (Pro) → `zzg += #13#10#13#10'Kind(er), Mutter/Vater nicht bekannt: - ' + illki(Num+'*')` (nur wenn noch kein '... nicht bekannt'-Marker in zzg; sonst `' - '+illki`)
12. **Table14.Write+Post** (BF75), IndexName:='', lfbh2.Next → Epilog (BFF7: Table1.EnableControls, ...)

## ofb3-Var-Block (ebp, ~L1400 Unit3)
zzg [ebp-38] (AnsiString) · unkMut [ebp-40] · unkVat [ebp-44] · kcount [ebp-18] · ehn [ebp-14] · patn [ebp-10] · erst [ebp-1C] (Integer!) · kopf [ebp-20] (Boolean) · bmk [ebp-24] · gueltig [ebp-4A] · i [ebp-50] · leere [ebp-0AC] (Byte-Flag) · num [ebp-0B0] (Temp-Buffer für FindKey-Var) · **perNr = esi** · **idx = ebx** · s/u/v (AnsiString-Temps)

## Konventionen im reconstruierten Code
- `if gvar_XXX = 1 then` statt Boolean-Globals
- `Trim(Table1X.AsString) <> ''`-Guards vor Anhängen
- `'Kind(er): '`-Header nur bei `erst = 1` (Inc(erst) vorher!)
- `' ['+Nm+']'`-Kopf-Marker + `' [oo '+Nm+']'`-Scan-Loop mit kopf-Flag + gvar_02536454-IndexName-Restore + GotoBookmark
- `' * '` (Geb) / `' ~ '` (Tauf) / `' + '` (St) — jeweils mit `sub_00576FF8`-Normalisierung + oabk/gvar_02536664-Weiche + `gvar_02536444.Add(Ort+v)`
- `zzg` (ebp-38) = laufender Zeilentext; `gvar_02536440/2536444` = Listen; Table14 = Druck-Export

## ofb3-Epilog (C3q, 0058BFF7..C6ED) — abgearbeitet
- `[ebp-8]` im Prolog = `Table1Nummer.AsInteger` der aktuellen Person (0058506C..7E) → Epilog `Table1.FindKey([krg])`
- 2. Pass-Weiche nur bei `Trim(lfbh2Eh) = '000000*'` (jne -> BF75 = Epilog-Write)
- String-Neue (C8xx): `58CB20 'ort_'` · `58CB30 'Orts-Abkürzungen: '` · `58CB4C 'Überschrift : '` · `58CB64 'OFB'` · `58CB70 'zeile'` · `58CB80 'nm'` · `58C9D0 ': '`
- D7-Konvention: `InputQuery(T, P, S)` = Function mit `var S: String`, Return-Boolean wird verworfen; kein 4. Parameter (E2034)
- `TField/TCtrl` Private-VT-Member (`+242`, `+0E0`) via PByte — kein direkter property-Zugriff in QuickRpt-Kompatibilitaetslage

## Offene TODOs / Fallstricke
- [140]=Table18 (nicht Table13!); [1E8]=Table14Zeile-TField; [0E0]=Table14-TTable
- Table18-Satag/Samonat/Htag/Hmonat-Offsets noch nicht verifiziert (aus C2-Read abgeleitet)
- Eh-String: 7 Zeichen pro Ehe, Nr in den ersten 6, Trennzeichen an Pos 7
- `'000000*'`-Sonderfall im 2. Pass = „keine gültige Eh-Nummer" → illki-Blöcke für Waisenkinder
- Original springt bei `i<=0` (jle->8B920) direkt zum Table14-Write — Pascal: `if i > 0 then begin ... end;` danach B920-Code

## [54C]-Konsistenzcheck (2026-10-31) — 4 Bugs behoben (Unit3.pas)
- **Bug-1 C3h (005885A8..BC)**: Zweiter Guard fehlte — ASM hat NACHEINANDER 	est eax,eax; jle 8887D auf Vater [538] (5885A0) UND Mutter [53C] (5885BA). Fix: if (num > 0) and (Table1Mutter.AsInteger > 0) then.
- **Bug-2 C3h (00588645..6D)**: Pos-Needle kam aus u (Vater6/[ebp-490], nur für lfbh2.FindKey([u])). ASM baut die Needle FRISCH: [53C] Mutter → sub_00576EB0 → [ebp-498] → LStrCat '*'. Fix: sub_00576EB0(Table1Mutter, u) vor dem Pos (u danach nur noch Scratch, nächste Nutzung überschreibt).
- **Bug-3 C3h (005886F0..58872F)**: Control-Flow war invertiert. ASM: Loop-Top 5886F0 → Prob[910] StrToInt vs Vater[538] → **je 588626 (Match) / jmp 58887D (Non-Match = sofort Exit)**; Match: Needle+Pos → jle 5886C4 (kein Treffer = Next) / gefunden → zzg [aus Nm] + jmp 8887D; Next 5886C4 → Eof 5886D3..E1 → jne 8887D / Fall → Loop-Top. Vorher stand der Break unbedingt im Match-Zweig, Non-Match fing.
- **Bug-4 M-Head (00589571..86)**: Table1Vater = patn → **Table1Mutter = patn** ([53C] gegen [ebp-10]=patn, jne 5898BE; der alte Kommentar sagte schon [53C]). W-Seite (L2436 [538] Vater=patn) bleibt korrekt — dort ist perNr die Mutter.
- OK verifiziert: alle 8 [538]/[53C]-Fälle in C1/C2, Religion-[54C]-Blöcke (ofb3: L1861/2148/2356/2532), Tails T2/T3/T4, Else-Branch 5898BE (kein Inc(kcount), edx=7), Pos-Asymmetrie M=sub_00576EB0(Mutter) / W=IntToStr(Vater).

## [54C]+Feldname-Konsistenzcheck (2026-11-01) — 2 weitere Bugs behoben
- **Bug-5 (587E4C..79)**: `lfbh2Aus` → **`lfbh2Hei`**. ASM schreibt per AsString-Setter an `[924]` — Unit1 L411-418: **Aus = [920] Integer** (nur gelesenes `' [aus N]'`-Feld), **Hei = [924] String** = Hochzeit/Jahr-Ziel. Quelle [4EC] = Sajahr.
- **Bug-6 (588291..BE)**: `lfbh2Aus` → **`lfbh2Hei`** (gleiche Stelle im H-Satz; Quelle [4D8] = Hjahr).
- Verifiziert korrekt: Ehen-/Bezie-Pfad (587D96 jne→58A701, 588479 Bezie, 588C4 Epnum), S-Satz S-*: [4E4]/[4E8]/[4EC]/[4F0]/[4F4], H-Satz H-*: [4D8]/[4DC]/[4E0]=**Table18Trauz** (Unit2 L311 — H-TZ-Block, nicht Satrauz!), Tail (B8E4 Eof→B914, B8F5 [4CC]→B8E6, B909 [534]→je B8E6), Table14-Write [1E8]+0B0, oabk/illki-Helper, gvar-2536644-Single-Counter, Table13-A44/A68 + RecNo-[150], lfbh2.Nm=[90C], lfbh2.Aus=[920] (Integer-Lesung), W-Zweig-Feldzuordnungen (Mutter-Vergl. [53C]=patn bei M/Kindersuche, Vater-Vergl. [538]=patn bei W-Seite).
- **Tabelle der Table18-Offsets (Unit2 L304-317, gegen ofb3-Listing abgeglichen)**: Nummer [4C8] **4C8·4CC** Epnum · Htag [4D0] · Hmonat [4D4] · Hjahr [4D8] · Hort [4DC] · **Trauz [4E0]** · Satag [4E4] · Samonat [4E8] · Sajahr [4EC] · Saort [4F0] · Satrauz [4F4] · Verbind [4F8]

## ofb2-Start + Bug-7 ofb3 (2026-11-01)
- **ofb2** (0058CB84+): Listing-Extract `Temp\opencode\ofb2.txt` aus Projects_AhnenWin\Unit3.pas L20970..28999. Chunk 1 (Setup bis 0058CEF8) transkribiert; **Table15 [0E8]** = Ehen-Tabelle der ofb2-Variante (Schwestertabelle Table18, 'num'-Index).
- **Bug-7 ofb3 C1 (r1628)**: Form24-ListBox-Gate 585207..24C — vtbl+0C4 ist **Count** (identischer Slot wie die Loop-Bounds ofb3 585280 / ofb2 58CD71), NICHT Visible. Maschinell: tote Count-Calls L3/L4 (D2-Items-Sync), einziger `jle 58524C` testet nur **ListBox6.Count**. Vorherige `.Visible`-Transkription (L1461-463) war falsch → `if ListBox6.Count > 0`.
- Merke: **vtbl+0C4 auf Form24-ListBoxes [300]/[304]/[368] = Count**, +0C8 auf [38C] RadioButton = SetVisible — nicht verwechseln.

## M-Zweig-Strukturfragen — GEKLÄRT in C3m (2026-11-04) — T1-Paradox aufgelöst
- **T1-Paradox AUFGELÖST (C3m, 2026-11-04)**: Die alte Lesart (58A603 cmp Vater,esi; je 589571 mit TAIL-Lage auf der falschen COND-Seite → Endlosschleife auf Kind#1) war ein Recon-Artefakt. **3 Kanten getauscht** (als Kommentar {0058A61D Kind-Loop-Tail (T1-Paradox-Fix: 3 Kanten getauscht, s. Recon-Notizen)} in Unit3.pas markiert). Zeugen:
  - **ofb2 593012**: `Mutter=0 → unkMut-Append → Next@59306A → Eof@593079 jne 59309D → COND@593082 Vater=[ebp-10] je 591DAB → beide Exits 59309D = M-Exit` — TAIL läuft VOR der COND, d.h. Zyklus: BODY → Kopf → if-kopf/mirror → TAIL → COND.
  - **ofb3 58B80D** (W-Zweig-Zwilling): `cmp esi,[53C]; je 58A79C` belegt dieselbe Struktur auf der M-Spiegel-Seite.
  - Rekonstruiert als `while Table1Vater = perNr do begin BODY(if Mutter=patn/mirror) → Kopf-scan(589B9B) → if-kopf/mirror → TAIL(Mutter=0-append, Next, Eof→Break) end` (Unit3.pas L2245ff); Eof→Break→M-Exit folgt ofb2 (593079→59309D), ofb3s abweichendes Eof→58B914 in der Annotation vermerkt {0058A67A..8B; Abw.: ofb2 00593079 -> M-Exit}.
- **Recon-Arbeitsstand (C3m abgeschlossen)**: Kopf-Scan läuft jetzt PRO Kind im Zyklus (L2302ff, statt nach der While mit Placeholder) — Eintritt über FindKey([perNr]) auf Index 'vat' → erstes Kind (Vater=perNr, zusammenhängend) → COND; `if patn<=0` / `if not Found` fallen zum M-Exit 0058A691 (Kommentare in Unit3.pas L2235/L2241/L2244).
- **T1-Ausgang (geklärt)**: ASM nach Next 58A66B: Eof → jne 58B914 (= Inc(ehn)-Ehen-Tail, L2633); NOT-Eof → **58A691** = Trim(unkMut) → ggf. illki-Print 'Mutter nicht bekannt' → IndexName:='' → First → jmp 58B827 (Personen-Ausgang). Im Recon fällt der while-Exit (Eof→Break) in den M-Exit 58A691, der außerhalb des Geschlecht-if liegt (Unit3.pas L2418ff) — der alte Verdacht „not-Eof-Exit nach A691 fehlt" ist damit behoben.
- **Sprünge zu 58A691 (M-Exit) korrekt verdrahtet**: Geschlecht≠'M' (589505), patn≤0 (58953A), FindKey-Fail (589566) — alles Abbruchpfade des M-Zweigs, alle fallen zum M-Exit 0058A691 (Trim(unkMut)-Print → IndexName:='' → First → jmp 58B827). Unit3.pas: if≠'M' (L2234) und patn≤0 (L2240) zeigen per Kommentar auf A691; der `if Found`-Guard (L2244) ebenfalls.
- **W-Zweig = else des Geschlecht-if (C3m geklärt)**: Beweis `587DB7 jne 58A701` (else-Kante) + `58A6FC jmp 58B827` (then-Jump-über-else) — der W-Zweig ab 0058A701 ist der `else`-Block von Unit3.pas L2234 (`end else begin` vor {0058A701 W-Zweig}, abschließendes `end;` vor dem Join {0058B827}). Der alte Verdacht „W-Zweig landet auf A691" war falsch: A691 ist M-Exit, 58A701 der eigentliche W-Entry (über 587DB7).
- **Bug-Fix C3m ([4C8] vs [4CC])**: Table18-while-Tail (Unit3.pas L2627) verglich `Table18Epnum = num` — Listing 58B8E6 liest aber `[4C8]`=Table18Nummer gegen frisches `[534]`=Table1Nummer (Idiom bewiesen durch L1529 `until Eof or (Table18Nummer <> Table1Nummer)` {00585865..8E [4C8]/[534]}) → auf `Table18Nummer = Table1Nummer` korrigiert, Annotation `[4C8]/[534]`.
- **Binary-Nachweis gescheitert**: Listing-Adressen (00585048..0058C854) passen weder mit Base 00400000 (CODE endet VA 00563DB8) noch 00500000 (landet in String-Daten) in AHNWIN51.exe — Quell-Binary des Listings ist nicht im Repo; außerhalb von uild/ existiert keine weitere EXE. Wer das passende Original (Ahnen5/AhnWin52 o.ä.) hat, bitte ablegen.
- **Offene Beobachtung (bewusst nicht kodiert)**: eh-Match-Pfad bearbeitet W-Personen über M-Exit, während der W-Block auf eh-Mismatch-Zeilen läuft — binary-faith, Semantik hängt vom Inhalt von lfbh2Eh ab (vgl. ofb2-7e-Gate `Trim(lfbh2Eh)='000000*'`).

## ofb2 KOMPLETT - Chunks 7d3b/7d4, 7e, 8 (2026-11-02/03) - build SUCCESS, Commit ausstehend (SVN down)
- **ofb2 (TForm3.ofb2, 0058CB84..00595388) ist vollständig transkribiert** (Unit3.pas Zeilen 2827..4448); prof.py `2854 4448 2853` schließt auf Tiefe 0; `build.cmd` (voll) -> SUCCESS, keine neuen Warnungen.
- **7e (005944D1..4B8B) = reentrant Mirror des Chunk-5-Gates (ofb3 Zeile 2643ff)**: Write → Table1 reset/FindKey([t1Num]) → Gate `Trim(lfbh2Eh)='000000*'` → M→'vat'/W→'mut' (zwei separate `if ... end else`) → zwei unabhängige `if IndexName='...'`-Loops (vat: `while Vater=t1Num` mit Mutter=0-Scan; mut: `while Mutter=t1Num` mit Vater=0-Scan) → zweiter Write + Post + lfbh2.Next = While-Bottom.
- **Loop-Stil-Beweis**: Eintritt `jmp` → Condition (Condition-Adressen 593082/5943BC/59487F/594B0B liegen NACH dem Body, `je`→Body, Body faellt auf Condition) = **while-Stil**, nicht Chunk-5s `while not Eof`+`Continue`. Unten jeweils `Next; if Eof then Break`.
- **@LStrCatN-Reihenfolge = vorwärts (erster Teil zuerst gepusht)**, verifiziert gegen transkribierte 5930D4/5931D0/594797-Blöcke. `illki` räumt seinen `AErgebnis`-Stackarg selbst ab; `sub_00576EB0` weist zu → kein `u := ''` vor den 7e-Aufrufen.
- **Chunk 8 = ofb3-C3q-Zwilling mit 3 Abweichungen**: (1) **4** statt 3 Table14-Appends vor der Table13-Schleife (4C85/4CC6/4D07/4D48: ' ', ' ', 'Orts-Abkürzungen: ', ' '); (2) **`if InputQuery('OFB','Überschrift : ', gvar_02536438) then`** wertet das Boolean aus (je→005952BA = Epilog; ofb3 verwirft es) und `gvar_02536438 := ''` davor; (3) `QRLabel3.Caption := '(OFB) ' + gvar_02536438` (LStrCat3, Literal 5956FC) statt ofb3s barem `'OFB'`.
- **QRDBText2 am Ende**: Asm `call TQRLabel.SetAutoStretch` (595221) → ofb2 korrekt als `AutoStretch := False` transkribiert; der ofb3-Zwilling notierte dieselbe Stelle (58C654) fälschlich als `AutoSize := False` (grün, aber Annotation-Slip). `+0E0`-Slot: wie ofb3 (58C694/C6B5) als `PByte(...+$0E0)^ := 0` / `QRDBText2.Enabled := True` übernommen (Slot-Identität weiterhin ungeklärt; `+64` = Enabled).
- **SEH-Rahmen nie transkribieren** (Konvention bestätigt): Loop-Frame 00594D8E..4EBE (Handler `594EB9 jmp @HandleAnyException` + `@DoneExcept`) und Prozedur-Epilog 005952BA..5388 (12× `@LStrArrayClr`, `jmp @HandleFinally` @595378) sind compilergeneriert - ofb3 C3q (Zeile 2744ff) macht dasselbe. OnPreview/Preview wie überall als Kommentar (`showpreview` existiert als `TForm3.showpreview` 00583D38, wird aber via OnPageAvailable betrieben; `TCustomQuickRep.Preview` fehlt in der Kompat-Schicht).
- `prof.py` akzeptiert weiterhin optionale 3. Arg (`start`, Default 3895): für Voll-Proc-Checks `start=2853` verwenden.

## gedausxv + Hex-Radix-Fund im IDR-Listing (2026-11-05)
- **WICHTIG — Listing-Immediates sind HEX** (`D:\Projekte\GitHub\IDR\bin\Projects_AhnenWin\*.pas`): `cmp/sub eax,12` bedeutet **0x12 = 18**, `mov edx,0D` = 13, `mov ecx,1A` = 26, `mov edx,2F` = 47 (`@LStrArrayClr`-Slots), `mov edx,4` = 4. Beweis: `0D` enthält eine Hex-Ziffer; `mov edx,2F`=47 LStrArrayClr-Slots passt zum Frame [ebp-0D4]; `0C`/`1A` ebenso. **Konsequenz: alle bisherigen Decimal-Ablesungen solcher Immediates prüfen** — betroffen waren 3 Stellen im gedausv-CHIL-Loop (siehe unten).
- **Bug-Fix gedausv CHIL (Unit3.pas L8163/8165/8170, Listing IDR-Unit3 L60345..60413)**: `cmp eax,12`/`sub eax,12` → **18** (`if Length(entry) > 18`, `Copy(entry,13,Length-18)`); Copy-Start im Loop `dec edx; shl edx,3; sub edx,ecx; add edx,0C; add edx,2` = **`7*(childIdx-1)+14`** (statt `13+7*childIdx`). Eintragsformat (erzeugt von gedausxv): Ehemann(6)+Ehefrau(6)+n×('*'+6 Kinder)+Paar-Idx(6) = **18+7n** → Kinderblock ab Pos 13, Ziffern ab 14. Vorheriger Code: `StrToInt` auf `'*…'` → Crash bei Familien mit ≥2 Kindern.
- **gedausxv (TForm3.gedausxv, 005B4288..005B51B5) vollständig transkribiert** (Unit3.pas L7282..7511, ersetzt den TODO-Stub). Baut gvar_02536448/0253644C für gedausv FAMS/FAMC; Details in docs/Restplan.md „gedausxv-DONE".
- **Feldkorrektur dabei**: `[548]` = **Table1Geschlecht** (Unit2 L337), nicht „Table5Geschlecht" — das Geschlecht-Case bezieht sich auf die aktuelle Person (Table1), Tabellen-Loop (Table5) liefert die Ehepartner-Nummer (Table5Epnum [414]).
- Semantik-Eintrag bestätigt: M-Zweig schreibt `own+Partner`, W-Zweig `Partner+own` → beides Mann+Frau (Konsument `Copy(1,6)`/`Copy(7,6)`); `'000000'` = fehlender Partner im zweiten Paar-Block (M: `own+'000000'`, W: `'000000'+own`).
- Verifikation: `prof.py 7282 7511 7281` → Tiefe 0; `build.cmd -unit 3` grün; voller `build.cmd` → SUCCESS (keine neuen Warnungen).

## adrschreib transkribiert + zweite Listing-Falle: abgeschnittene String-Konstanten (2026-11-05)
- **adrschreib (TForm3.adrschreib, 005B3A3C..005B40E3) vollständig transkribiert** (Unit3.pas L7277..7382, ersetzt den TODO-Stub); Details in docs/Restplan.md „adrschreib-DONE". `prof.py 7277 7382 7276` → Tiefe 0, beide Builds SUCCESS.
- **NEUE LISTING-FALLE — IDR schneidet lange String-Annotationen ab** (bei ~80 Zeichen, z. B. `mov edx,5B4184;'Brf_Anr'+#9+…+Anschrift2'+...`): Der Volltext der Konstante ist dann NUR aus dem Listing nicht rekonstruierbar. Für die adrschreib-Kopfzeile (005B4184) wurden die restlichen 3 der 9 Spaltennamen aus den Ausgabespalten abgeleitet (`'PLZ'/'Ort'/'Adrzus'`, kommentiert in Unit3.pas) — Verifizierung erst, wenn jemand das passende Original-Binary (AHNWIN51/52 mit den Listing-Adressen) hat. Gesucht und nicht gefunden: `D:\Projekte\GitHub\IDR\bin\Projects_AhnenWin` (nur .pas/.dfm/.dpr), `Source\Projects_AhnenWin` (identische Kopie, gleicher Schnitt), `Source\AhnWin52` (anderes Decompilat, enthält 'Brf' nirgends), C:\copy / D:\copy. Hinweis: das 5.2-Decompilat `AhnWin52\Forms\PersonSearchForm.pas` (ab L65891) zeigt dieselbe Routine mit Byte-Codes und annotated die Strings ohnehin nur, wo es sie auflösen kann.
- **Offsets in Unit2/Unit1 eindeutig** (kein Gegenindiz nötig): DataModule2 `[13C]=Table17`, `[0CC]=Table13`; Form1 `[3FC]=SaveDialog1` (TOpenDialog-Felder f74=DefaultExt/f60=Filter/f78=FileName, vtbl+3C=Execute laut extrahiertem `Dialogs.pas`), `[400]=Label18`, `[404]=Label19`, `[7B4]=DBText1`. Idiom-Bestätigung: identischer Filter-Block existiert schon in Unit13 L1783ff (`Table17.Filter/Filtered` + `DBText1.Color := $FFFF`).
- **Delphi-Sprachdetail**: In Unit3 ist der Alias `Text` nicht auflösbar (E2007) — lokale Textdateien dort als `TextFile` deklarieren (wie Unit1 L3093).
- @LStrCatN-Reihenfolge erneut bestätigt (vorwärts gepusht): Filter `'gebjahr<='+N+' and taufjahr<='+N` und `ShowMessage(IntToStr(anz)+' Adresse(n) geschrieben.'+#13#10+'(Nur lebende Personen !)')`.
- **Restliste: 7 Unit3-Stubs** — osbein 005B229C (1301 Zeilen), ahndosein 005AFB9C (2261), gedausx 005A634C (1594), gedaus 005A7C40, gedein 0059D218, gedein2 00596994, gedein_neu 0057EDEC; alle Listings liegen vor.

## osbein transkribiert + dritte Listing-Falle: `#13`/`#10` als Einzel-Konstanten (2026-11-05)
- **osbein (TForm3.osbein, 005B229C..005B3725) vollständig transkribiert** (Unit3.pas L8756..8950, ersetzt den TODO-Stub); Details in docs/Restplan.md „osbein-DONE". `prof.py 8756 8951 8755` → Tiefe 0, `build.cmd -unit 3` grün, voller `build.cmd` → SUCCESS (0 Fehler, keine neuen Warnungen in 8756..8951).
- **NEUE LISTING-FALLE — `#13#10` ist mal EINE, mal ZWEI Konstanten**: IDR annotiert eine 2-Zeichen-Konstante als `58C980;#13+#10`, eine 1-Zeichen-Konstante als `5B3950;#13`. In osbein (005B2ED8..EEC, `@LStrCatN` edx=5) werden `5B3950;#13` und `5B395C;#10` **getrennt** gepusht → Quelltext war `+ #13 + #10`; in Unit3 L2250 (00589598, edx=4) wird `58C980;#13+#10` **zweimal** gepusht → dort ist `#13#10` eine Konstante. Beide Schreibweisen kommen im Original vor — aus `mov edx,N` plus den Push-Adressen folgt, welche gemeint ist.
- **Grössen-Regel für .data-Stringkonstanten (Beweisführung ohne Binary)**: Abstand = `8 + len + 1`, auf 4 aufgerundet (1 Zeichen → 12, 5 → 16, 6 → 16, 9 → 20). Kette `5B3944`(1) → `5B3950`(1) → `5B395C`(1) → `5B3968` 'quelle'(6) → `5B3978` 'Qu.: '(5) → `5B3988` 'sonstiges'(9) → `5B399C` 'Bemerk.: '(9) → `5B39B0` 'n'(1) → `5B39BC` 'ehen'(4) stimmt exakt und belegt die Zeichenlängen.
- **Rohbyte in Stringannotationen**: `5B3944` enthält laut Bytes-Lesung der IDR-Datei (an dieser Stelle kein gültiges UTF-8) das **Byte 0xEC** → als `#$EC` transkribiert (IDR zeigt Mojibake). Es ist das Prüfzeichen am Ende jeder importierten OSB-Kommentarzeile (wird abgetrennt).
- **@LStrCatN-Reihenfolge erneut bewiesen (vorwärts)**: 00589598 pusht `zzg`, `#13+#10`, `#13+#10`, `'Kind(er): '` — nur „erster Push = erster Operand" ergibt den korrekten Text (die Gegenlesung hätte `#10#13…` vorgestellt). Dito osbein: CatN edx=5 (`Kommentar + #13 + #10 + #13 + #10`), edx=5 (`s + 'Qu.: ' + quelle + #13 + #10`), edx=3 (`s + 'Bemerk.: ' + sonstiges`).
- **vtbl-Slots bestätigt**: `+8` = Assign auch auf TField-Seite — `Table1Kommentar.Assign(Memo1.Lines)` und `Memo1.Lines.Assign(Table23.FieldByName('kommentar'))` liegen beide auf dem TPersistent-Platz, der bei TStrings und TField identisch ist (IDR annotiert +8 an Unit1-Stellen als `TStrings.Assign`/`TJPEGImage.Assign`); `+0DC` = Memo1.Clear; `+0C/+14/+20` = TStrings Get/GetCount/Put.
- **Schleifen-/Zweig-Belege**: Ehen-Loop `for i := 1 to 4` (Init `mov [ebp-4],1`, Bottom `inc; cmp dword ptr [ebp-4],5; jne 31E1`), Blockbreite 6 Zeichen (`edx*2*3+1` = `(i-1)*6+1`); `if Copy(ehen,…,5) > '00000'` per `@LStrCmp`+`jbe`; beide `Post`-Aufrufe in stillen `try..except` (SEH `jmp @HandleAnyException` + `@DoneExcept`), Prozedur-Epilog (`@HandleFinally`, `@LStrArrayClr` 0x54+3 Slots, `@LStrClr`) = Kommentar.
- **Restliste: 6 Unit3-Stubs** — ahndosein 005AFB9C (2261), gedausx 005A634C (1594), gedaus 005A7C40, gedein 0059D218, gedein2 00596994, gedein_neu 0057EDEC; alle Listings liegen vor.

## ahndosein transkribiert + Korrekturen an gvar_02536860 (2026-11-06)
- **ahndosein (TForm3.ahndosein, 005AFB9C..005B1E3E) vollständig transkribiert** (Unit3.pas L8952..9306, ersetzt den TODO-Stub); Details in docs/Restplan.md „ahndosein-DONE". `prof.py 8952 9306 8951` → Tiefe 0, `build.cmd -unit 3` grün, voller `build.cmd` → exit 0 (keine neuen Warnungen/Hinweise im Bereich 8952..9306).
- **Zwei Korrekturen in bereits transkribiertem Code** (Listing 005BFC05 bzw. SetTableType `dl=1`): Unit3.pas **L5184** `TTable.Create(nil)` → `TTable.Create(Self)` — Konstruktions-Register sind EAX=Klasse, **DL=1**, **ECX=AOwner** (`mov ecx,[ebp-4]` = Self); **L5186** `TableType := ttDefault` → `ttParadox` — `TTableType = (ttDefault, ttParadox, ttDBase, ttFoxPro, ttASCII)`, also 0=ttDefault, 1=ttParadox (DBTables.pas L818).
- **`sub_005AFB14`-Idiom (procedure + var, L98)**: 19 Kopien in Loop 1 rufen `lea edx,[temp]; call 005AFB14` auf das frisch gelesene `AsString`-Resultat und verwenden danach `[temp]` als Quelle der Ziel-`SetAsString` → transkribiert als **zwei Zeilen mit geteiltem Temp `t`**: `sub_005AFB14(src, t); dest := t;` (ABI EAX=src, EDX=@Result).
- **Zwei verschiedene Guard-Tiefen**: Vater/Mutter prüfen `Copy(code,5,4)` bzw. `(9,4)` **zweimal** (`> '00000'` und Längen-Check `<> ''`, zwei vollständige FieldByName/Copy-Sequenzen), der Ehen-Guard prüft `Copy(code,(i-1)*5+13,4) > '00000'` **nur einmal** (kein `<> ''`).
- **`local.Post` ohne Rahmen vs. Table1/Table5.Post mit Rahmen**: 005B0B52 ist ein plain `call dword ptr [edx+248]`; nur 005B19F4 (Table1) und 005B1D17 (Table5) legen einen SEH-Rahmen an (`jmp @HandleAnyException` + `@DoneExcept`) → genau zwei stille `try..except end` im Text. Insgesamt 3 `fs:[eax]`-Schreibstellen (inkl. Aussenrahmen 005B1E31).
- **Label-Reihenfolge 005B0C0B**: `Label18.Caption := '0 %'` (SetText auf +400), danach `Refresh` auf **+404 = Label19** und erst danach `Label19.Caption := 'AHNEN DOS lesen         '` + Refresh — ungewöhnlich, aber 1:1 aus dem Listing übernommen (kein Sichtbar-/Refresh-Block, stattdessen `Form1.lab18ein`).
- **Literal-Case-Sprung**: FieldDefs-Anlage nutzt `'Lebensorte'` (5B1EE8), jede Kopie/Zugriff dagegen `'lebensorte'` (5B2178) — `FindField` vergleicht ohne Groß/Klein; Literal 1:1 aus dem Listing übernommen. Dito `'Lebensorte'`-Feld als Ziel `Table1Lebensort`.
- **Reihenfolge im Kommentar-String**: ahndosein hängt **erst `'Bemerk.: '`+sonstiges, dann `'Qu.: '`+quelle** an `s` (CatN edx=5 jeweils, Quelltext `s := s + …`), also die umgekehrte Reihenfolge zu osbein (`Qu.: ` zuerst); beide CatN-Blöcke pushen `s` als tiefsten Operanden.
- **Zweiter Trim-Guard mit `ShowMessage`** (005B16F5..1745): Debug-Rest des Originals (`if Trim(Table1Kommentar.AsString) <> '' then ShowMessage(...)`), bewusst übernommen — im Gegensatz zu osbein existiert hier kein ShowMessage am Ende der Routine.
- **Schleifen-/Zweig-Belege**: Loop 1 `while not Table23.Eof` (Kopf 5B0B6F), Loop 2 `while not local.Eof` (Kopf 5B1D66), Ehen `for i := 1 to 3` (Init `mov [ebp-8],1` @5B1A28, Bottom `inc @5B1D4E; cmp 4; jne 5B1A2F`), Memo-Schleife `for i := 0 to Lines.Count-1` (GetCount +14, `dec esi; jl` bei Count-1<0, Get +0C, Put +20); `#$EC` = Rohbyte 0xEC wie in osbein (5B21F4).
- **Restliste: 5 Unit3-Stubs** — gedausx 005A634C, gedaus 005A7C40, gedein 0059D218, gedein2 00596994, gedein_neu 0057EDEC; alle Listings liegen vor.

## gedausx transkribiert + Auswerte-Reihenfolge der Hilfsfunktionen (2026-11-06)
- **gedausx (TForm3.gedausx, 005A634C..005A7BB2) vollstaendig transkribiert** (Unit3.pas L9308..9681, ersetzt den TODO-Stub); Details in docs/Restplan.md „gedausx-DONE". `prof.py 9308 9684 9308` → Tiefe 0, `build.cmd -unit 3` gruen, voller `build.cmd` → exit 0 (keine neuen Warnungen/Hinweise im Bereich 9308..9681).
- **Auswerte-Reihenfolge-Delta (bewusst)**: `sub_00576EB0` ist im Original eine **Funktion** (ABI: EAX=Wert, EDX=@Result; 00582C24 als Funktion mit verstecktem Result-Pointer auf dem Stack, Argumente EAX=Tag/EDX=Monat/ECX=Jahr) und stand jeweils **innerhalb** des Ausdrucks. Als Prozedur transkribiert stehen die Aufrufe vor der Aussage, z. B. gvar-Zeile: Listing pusht zuerst `gvar` (771F), dann erst die pad-Teilausdruecke (7725..7771); Quelltext `gvar := gvar + n6 + '*' + fn6 + '#'` mit vorangestellten `sub_00576EB0`-Aufrufen. Ebenso `ep6`/`n6` vor dem `while`/`if`-Vergleich statt im Condition-Code. Semantik identisch (kein Side-Effekt ausser dem Temp), Codegen weicht geringfuegig ab.
- **if/else-if vs. zwei Ifs — aus den Sprungzielen bestimmt**: In-Loop M/W und Final-Block Av/Am sind echte **else-if** (der M-Zweig endet mit `jmp 7179` bzw. faellt auf 79BC und ueberspringt damit die W- bzw. Am-Bedingung); der Post-Loop M/W dagegen **zwei separate Ifs** (M-Ende 73A9 faellt auf 73AF = W-Bedingung, kein Sprung darueber). Wie in gedausxv als `{--- 005AXXXX ... (sequenziell, kein else) ---}` markiert.
- **Dedup-Idiom `if not (FindKey([n6]) and flag)`**: Die Kurzschluss-Evaluierung des Compilers (FindKey zuerst, bei false direkt in den Append-Zweig; erst dann `flag`) passt exakt zu `je 6641` / `jne 7179` — auch eine De-Morgan-Zerlegung (`not FindKey or not flag`) erzeugt dieselbe Reihenfolge, daher so transkribiert.
- **Schleifen-Idiom bestaetigt**: Alle vier Schleifen (Table5 64D7/7197, Table17-Scans, Table1 6436/75C2, Table31 75F6/7B43) zeigen dasselbe Bild: nach `Next` ein Eof-Check auf die Schleifen-Exit-Adresse, danach der Condition-Block mit `je` zurueck in den Body — transkribiert als `while ... do begin ... Next; if X.Eof then Break; end` (entspricht L7453-7470).
- **`Trim(fk) <> ''`-Guard**: prueft per Pointer-Vergleich (`cmp dword [temp],0; jbe`) und weist anschliessend das **ungetrimmte** `fk`/`uk` zu — so transkribiert.
- **Post-Loop-Append setzt nur 6 Felder** (Fv/Fm/Fk/Fn/Indj/Post), kein Vb, keine Datumsfelder — Listing 72DE..73A9 bzw. 74D9..75A4; `Vb:='A'` gibt es nur im Final-Block-Append (7A94, direktes Literal, kein Copy/UpperCase).
- **Restliste: 4 Unit3-Stubs** — gedaus 005A7C40, gedein 0059D218, gedein2 00596994, gedein_neu 0057EDEC; alle Listings liegen vor.

## gedein transkribiert + Listing-Fallen der CatN/ans-ABI (2026-11-11)
- **gedein (TForm3.gedein, 0059D218..005A58A9) vollstaendig transkribiert** (Unit3.pas L9683..11428, ersetzt den TODO-Stub); Details in docs/Restplan.md „gedein-DONE". `prof.py 9683 11428 9683` → Tiefe 0, `chk7.py` → 0 fehlerhafte Adress-Annotationen, `cov7b.py` → alle verbleibenden call-Luecken sind Multi-Call-Ausdruecke, `build.cmd` → `[build] SUCCESS`.
- **`ans` ist eine Prozedur mit var-Out-Param in ECX** (`procedure ans(AIn; var AOut)`, 005836E8): im Listing `mov edx,src; lea ecx,[tmp]; mov eax,[ebp-4]` (Self in EAX!) → `TForm3.ans`. Also `ans(x, anst);` und **danach** `Trim(anst)` — **`Trim(ans(...))` kompiliert nicht** (E2036/Funktion erwartet). 63 Aufrufe in gedein, alle als Anweisung vor der Auswertung transkribiert → gleicher bewusster Auswerte-Reihenfolge-Delta wie bei `sub_00576EB0` (siehe oben).
- **`@LStrCatN`-Push-Reihenfolge + versteckter Copy-Out-Param**: CatN pusht die Operanden in **Quelltext-Reihenfolge** (erster Operand zuerst, also am tiefsten), `EAX=@Dest`, `EDX=Count`. Der `lea eax,[tmp]; push eax` vor `@LStrCopy` ist der **versteckte Result-Pointer von Copy** und zählt NICHT als CatN-Operand (bewusst nicht mitgezählt, wenn die Operanden-Anzahl aus dem Listing abgezählt wird). `@LStrCat3`: `EAX=@Dest, EDX=S1, ECX=S2` → `Dest := S1 + S2` (Literal zuerst, z.B. `'000000' + Copy(...)`), `@LStrCat`: `EAX=@Dest, EDX=S`.
- **`xor edx,edx; call [ecx+0B0]` = leerer String, nicht `'0'`**: die kompakte Listing-Darstellung `:= 0` ist irrefuehrend; bei TStringField-SetAsString bedeutet EDX=0 den leeren String (z.B. `Table1Indm.AsString := ''` bei 005A498B).
- **Table5-Post-Gate auf Zustandsbyte [9D] ∈ {2,3}**: beide Arcs pruefen `cmp byte [eax+9D],2/je; cmp 3/jne` (Form A, 005A3D15) bzw. `add al,0FE; sub al,2; jae` (Form B, 005A41B2 — unsigned-Test 2..3, identische Semantik). Bewusst als plain `DataModule2.Table5.Post;` mit Gate-Kommentar transkribiert (kein if im Pascal — der Post passiert nur, wenn das Byte passt; die Sprunglogik steckt im Assembler-Test selbst).
- **`famkom` [ebp-74] wird nie beschrieben**: nur `:=''` im `@ FAM`-Init (005A42D5), sonst nur gelesen → die vier `if Trim(famkom) <> ''`-Anhaenge (A3B69/A4006/A508B/A5528) sind toter Code. Bewusst 1:1 transkribiert (kein Toeter entfernt). Ebenso toter `Pos('1 CHAR UNIC')`-Test und die Zaehler `[ebp-14]:=1`/`[ebp-10]:=0`.
- **`System.Assign`/`CloseFile` statt `Assign`/`Close`**: bare `Assign`/`Close` loesen sich zu `TPersistent.Assign` auf (E2010/E2034) — die Textdatei-Variable `gvar_02536458: Text` braucht `System.Assign(gvar_02536458, fname)` und `CloseFile(gvar_02536458)`.
- **`mansnr` = [ebp-20], `wifesnr` = [ebp-24]** — die Deklarationen waren anfangs vertauscht und wurden korrigiert: HUSB-Zweig schreibt [ebp-20] (→ Table5-Bogen2 Nummer, Table31Av, huslist), WIFE-Zweig [ebp-24] (→ Bogen1 Nummer, Table31Am, wifelist). Belege: A4532 `mov [ebp-20],...` nach Table25FindKey im HUSB-Block, A46EB `[ebp-24]` im WIFE-Block.
- **`Copy(line,9,1)='I'`-Test als inverse Form**: das Original hat einen leeren then-Zweig (`{ Nr. bereits ab '@I' erfasst }`) + else mit Neuberechnung — als `if Copy(...) <> 'I' then <Neuberechnung>` transkribiert (semantisch identisch, kein leerer Block). Gilt fuer HUSB (A447F), WIFE (A4638) und CHIL (A482F).
- **Note-Guard deckt Chain + Dispatch ab**: `' NOTE '`-Block (005A1396..A22DE) enthaelt die Pos('@')=8-Chain (Table26 `alt_`-FindKey → Kommentar) **und** den Rest-Dispatch (`'@' an anderer Position → Skip`, Schluesselworte) in einem grossen if — Ende mit `//005A22DE: Ende Note-Guard` markiert; die CONT/COMM-Kette beginnt erst danach (A22DE).
- **`and` vs. verschachteltes if**: mehrfach-zielende Bedingungen als `and` geschrieben (z.B. `(ctx='fam_reli') and (Pos('_WITN')>0)`, `(mansnr>0) and (wifesnr>0)`, `(Pos(' NOTE @')>0) and (Pos('@')=8)`), verschachteltes if nur wenn die Sprungziele unterschiedlich sind (CHIL: `FindKey Table25` → `FindKey Table1`, beide false-Pfade laufen auf A4B4E).
- **In-Body-TRLR-Test vs. While-Bedingung**: 005A4D7E prueft `Copy(ucase(Trim(line)),1,6)='0 TRLR'` **im Body** (mit FAM-Flush), die While-Bedingung A571D..A5771 prueft dasselbe und springt `jne->EFC7`. Beide Faelle enden auf Epilog A5777 — im Pascal faellt der Flush auf die While-Bedingung durch, die dann exitet (semantisch identisch).
- **`@ FAM`-Init hat kein else**: `if Pos('@ FAM',line)>0 then <Init>` (jle->A437A) faellt im false-Fall direkt in den klist-Scan und das gesamte Dispatch durch — kein else-Zweig.
- **`Inc()` auf Single-Globals nicht moeglich**: `gvar_02536668/666C/6644` sind `Single`, aber das Listing inkrementiert als dword (`inc dword ptr ds:[2536668]` + `fild`) — im Pascal `g := g + 1;` (Inc kompiliert nicht auf Single).
- **Restliste: 3 Unit3-Stubs** — gedaus 005A7C40, gedein2 00596994, gedein_neu 0057EDEC; alle Listings liegen vor.

## gedausv SaveDialog-Setup korrigiert (2026-11-11)
- **L7665..7667 transkribierten falsche Setter**: `Title := 'ged'` / `Filter` / `FilterIndex := 2`. Das Listing 005B5348..5382 zeigt dagegen `+74 := 'ged'` (DefaultExt), `+60 := 'Gedcom-Dateien (*.ged)|*.ged'` (Filter) und `[+5C] := 2` (= `Options := [ofHideReadOnly]`) - korrigiert auf `DefaultExt`/`Filter`/`Options`, Annotationen `005B534B..5350`, `005B5365..536A`, `005B537C..5382`.
