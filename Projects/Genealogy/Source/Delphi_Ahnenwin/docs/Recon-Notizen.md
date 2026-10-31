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
- Form1 **[0061DBD4]**: Label19 **[404]** · lfbh2 (TClientDataSet) **[8B8]**; Fields: Nm [90C] · Eh [914] · Aus [920] (lfbh2-Feld-Offsets, TField-Objekte)
- Form15 **[0061D7F4]** (Unit15-L19+): QuickRep1 [2F0] · QRBand1 [2F4] · QRLabel1 [2F8] · QRLabel2 [2FC] · QRShape3 [304] · QRMemo1 [310] · QRDBText4 [31C] · QRDBText5..12 [320..33C] · QRDBText1 [350] · QRDBText2 [354] · QRLabel3 [368]; TQRLabel.SetAutoStretch = `[+0E4]`→ in Recon via `.AutoSize`; `+242`-Byte-Write per `PByte(Integer(Comp)+$242)^ := 0`; OnPreview `+2AC/+2A8` = **nicht implementiert** (Konv. Unit1 L8282, Unit16)
- Form24 **[0061D330]**: CheckBox14 **[394]**, Checked via vtbl+0C4
- Form1-Memo1 [220]?? · DBMemo1 (Width +48, Font +68) — Kommentar-Mirror

## gvar-Weichen (Delphi-Globale, meist `= 1` gesetzt)
25363EC Alter · 25363F0 Beruf · 25363F4 Notiz/Kommentar · 25363F8 Todesurs · 25363FC Satrauz-TZ · 2536400 Taufpat · 2536404 Religion · 2536410 oabk-Schalter (Ort-Abk. nach gvar_02536664 statt in zzg) · 2536414/2536418 Kinder-Name-Weichen (gvar_02536440-Add) · 2536454 lfbh2-IndexName-Save (AnsiString) · 2536664 gvar_02536664 (AnsiString, oabk-Anhang) · 25366644 gvar_02536644 (Single, Zeilenindex)

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
