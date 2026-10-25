# Remaining work plan (Restplan) — AHNENWIN 5.1 recon

State: **572 / 659** methods reconstructed (87 open). Build is green.

Method sizes below are the number of *disassembly* lines in the listing
(the `{*procedure …` block or the plain `procedure …` body up to the next
procedure). "Lines" therefore is *code*, not Delphi — a 500-line listing may
become 100 lines of Pascal.

---

## Phase 1 — the small ones (< 250 disassembly lines)

These are the only methods small enough to convert in one pass. They are
scattered across all three major units (Unit1, Unit3, Unit13) and the two
smaller ones (Unit17, Unit24, Unit26, Unit33).

| # | Method | Unit | Lines |
|---|--------|------|------:|
| 1 | `sub_005D39D8`  | Unit1  | 46  |
| 2 | `sub_0054F810`  | Unit26 | 60  |
| 3 | `sub_00573314`  | Unit13 | 72  |
| 4 | `symm`          | Unit13 | 95  |
| 5 | `sub_0057316c`  | Unit13 | 117 |
| 6 | `sub_0056897c`  | Unit13 | 117 |
| 7 | `sub_00568c9c`  | Unit13 | 127 |
| 8 | `sub_00568b04`  | Unit13 | 129 |
| 9 | `sub_00568e3c`  | Unit13 | 175 |
| 10| `vorf_erm2`     | Unit13 | 225 |
| 11| `sub_005BEF5C`  | Unit3  | 308 |
| 12| `sub_00582C24`  | Unit3  | 411 |
| 13| `nam2`          | Unit17 | 486 |
| 14| `fambeltern`    | Unit17 | 509 |
| 15| `nr1`           | Unit13 | 658 |
| 16| `nr2`           | Unit13 | 665 |
| 17| `sub_005BC604`  | Unit3  | 1096 |
| 18| `sub_005BE4B8`  | Unit3  | 645 |
| 19| `illki`         | Unit3  | 687 |

> **Note on Unit13 items (4–10, 15–16):** they touch the shared chart arrays.
> The layout is now PINNED — see "Phase A findings" below.

## Phase A findings (layout, pinned 2026-10-25)

These are the chart row grids of Unit13. One row per person, **row size
$198 = 408 bytes**, row count **$2710 = 10000** (matches the IDR annotation
`array[10000] of ?`). Both facts close ONLY with hex constants: the
`imul …,33` scale is $33 = 51 and every row slot is 8 bytes (`51 × 8 =
408 = $198`); a decimal "33" would give 264 B and contradict the
explicit `add/sub …,198` row walks.

Recon declarations (see `Units\AHNGlobals.pas`):

- `TChartRow = array[0..101] of Integer` (408 B), `TChartRows = array[0..9999] of TChartRow`.
- **Grid A** `gvar_011AE1C4` (labels inside: `011AE1CC` = row[r].dword[2],
  `011AE35C` = row[r+1].dword[0], `011AE360` = dword[1], `011AE364` = dword[2]).
- **Grid B** `gvar_019764C4` (labels inside: `019764C8` = dword[1],
  `019764D8` = dword[5], `019764E0` = dword[7]; row r+1: `0197665C` = dword[0],
  `01976664` = dword[1], `01976668` = dword[3], `01976670` = dword[5]).
- **Grid C** `gvar_015924E4` — a second 10000×$198 working copy (load/store
  mirror of grid A, copied stride-$198 with count $2710 in the method at
  005693C…0056943E).
- **Person mirror** `gvar_0061F30C`: `TPersonRec = array[0..531] of Byte`
  ($214 = 532 bytes), count `$13880 = 80000`; pinned fields: +0 num,
  +4 flag, +8 kind, +$137/+$10E/+$160 = ShortString[28] (the Len byte
  at +$137 is compared with 'W').

All cell math in the listings is 4-byte (`fild dword ptr`, cmp dword), so
the 8-byte slots are **array[0..1] of Integer pairs (lo = +0, hi = +4)** —
not DateTime/Double (the listing's `fild` converts an Integer to double,
it does not load floats).

Converted against this layout so far:

- `sub_00568FD4` / `sub_00569010` — scan rows while
  `gridA[r].dword[2] > 0`, track the max of `gridA[r].dword[5]`, then call
  `sub_00568C9C(max)` / `sub_00568E3C(max)` respectively (Unit13 recon,
  build green).
- `sub_00568C9C` / `sub_00568E3C` — converted (build green), see
  "Phase B findings" below.
- Stubs for `sub_0056897C(AValue)`, `sub_00568B04(AValue)` (called by
  C9C/E3C); not yet converted.

**Converted since (still Phase B, build green):**

- `sub_0056897C` / `sub_00568B04` (grid-A pair *normalizers*): same
  flat-index translation, BUT (a) they run `V` full passes over the
  level loop (`[esp+8]` pass counter), (b) comparisons are
  `jge`/`jl` (magnitude, not equality), (c) the propagation loop
  continues while the level dword equals `lvl+1`, and (d) they only
  act when the doubling-row value is BELOW (branch 1) / the row value
  is ABOVE (branch 2) the neighbor value — sort-shift semantics,
  versus the distribute semantics of C9C/E3C.
- `TForm13.Symm` (00568834): two backward row walks over grid B from
  row `gvar_011AE344` downto 1. Part 1 moves `gridB[esi][0]` to the
  midpoint of `gridB[esi][7]`/`[8]` (via `ChartBFlat(102*d)` row-index
  deref: term `[T*8 + 19764C4]` = flat dword `2*T`) when the pair
  differs by more than `gvar_011AE334+gvar_0061F118`, then
  `gvar_011AE31C := max(011AE31C, [esi][0] div sum − 1)`. Part 2
  monotonically raises `gridB[esi][0]` when `[esi][7]/[8]` are empty,
  `[esi][5] < 011AE328` and equals `[esi-1][5]`, `[esi][3]` and
  `[esi-1][3]` are positive and `[esi-1][0] >= [esi][0]`.
- **Retype**: `gvar_011AE334`, `gvar_0061F118`, `gvar_011AE328` are INTEGERS
  (every access is `add dword,0A`, `mov/cmp dword`, `fild dword`; the
  IDR "Single" label is wrong). `AHNGlobals` exposes
  `ChartBFlat/SetChartBFlat` for grid B's `[T*8+19764C4]` terms.
- `TForm13.schieb_vm1` (00568528) / `schieb_vm` (0056862C): first find
  the row dword[5] maximum (scan while `[r][2] > 0`; vm1 only), then
  N outer passes; each pass walks rows 1..`gvar_011AE344` on the
  1976668-anchor (`row[r][3]`; vm1 shifts `row[r][1]`, vm
  `row[r][0]`): when ecx(=pass) = `[r][5]` copy the pointed value's
  dword down (`ChartBFlat(102*val → +1)`); else when both parents
  `[r][6]/[r][7]` are 0 and the row is a level-equal successor,
  place at previous row's position + the spacing constants
  (`0253637C*011AE318 + 011AE318 + 61F118 + 011AE348` in vm1;
  `011AE334 + 61F118` in vm).
- `TForm13.kek_ord` (005686F0): 011AE328-1 passes; anchor 1976670 =
  `row[r][5]`; when `[r][5] < 011AE328` and equals `[r-1][5]`, all
  three dwords 3 of rows r/r−1/r+1 positive, `[r][0] <= [r-1][0]` and
  `[r][7] = [r][8] = 0`: `[r][0] := 2*(011AE334+61F118) + [r-1][0]`.
- `TForm13.kek_ord_2` (00568774): counter trap gives EXACTLY two row
  walks with ecx = V−1 then V−2; conditions keyed on ecx; then
  `[r][0] := [r-1][0] + sum` and `[r-1][0]` gets +/- sum by the PARITY
  of `[r][2]` (and $80000001 idiom = sign-corrected odd test).
- `TForm13.Vr2` (0056904C) converted: screen/canvas metric setup
  (`fScale` = `gvar_0253636C` = 1.0 normally, 1.13 when drawing
  canvas <> PaintBox1.Canvas; 6.0 pen multiplier on the printer branch —
  all Extended constants recovered from the mantissa/exp words).
  Then: walks grid A rows (`while [r][2] > 0`, r starts 1), clears
  20 slot strings (011AE2C8..011AE2F8 area) + 20 row-local string
  slots (flat dword 102*row+19, ..., via new `ChartAAnsi` helper),
  FindKey on DataModule2.Table17 with `[row][3]`, calls
  `memein(gvar_011AE1C4[row-1][3])` and
  `zerleg(011AE334, 011AE318, canvas)` — both still TODO stubs
  (declared: `memein(AValue)` EDX, `zerleg` 3-register/stack args;
  IDR lists zerleg as function, result unused here). Copies dwords
  0..2 of each grid-C row (`gvar_015924E4`, 408-B rows) into the
  FD4-family grid rows (flat 102r..102r+2 = gvar_011AE1C4 rows 1..),
  calls sub_00569010, computes max `[r][0]` → 011AE320 (then Dec),
  sets ScrollBar1/2.LargeChange = PaintBox dims-5 and
  SmallChange = 20 (IDR hex "14").
- **IDR number bases**: printed numbers are HEX (e.g. `mov edi,14`
  = 20, `imul x,33` = 0x33 = 51 row stride, `2710` = 10000).
  Verified against recon cross-checks (FD4 scan terms = flat
  102r+{2,5} with the 0x11AE35C anchored identity).
- Additives: `ChartAFlat`/`SetChartAFlat`/`ChartAAnsi` (flat dword /
  string-pointer slots over 011AE1C4), `ChartSlotAnsi` (011AE2C8+4i)
  in AHNGlobals.
- **Retype**: `gvar_011AE348` is an Integer too (same fild/add dword
  pattern); `gvar_019764CC` (grid B row[r] dword[2]) pinned.

## Phase B findings (2026-10-25)

**The earlier "term-scaling inconsistency" is RESOLVED.** The walkers use
three different T values in `[esi + T*8 + K]` terms (esi = 011AE35C =
base + $198):

- `T = 51*ebx` (from `imul eax,ebx,33`) — row ebx, dword (102 + K div 4).
- `T = 66*ebx` (from `add eax,eax; imul …,33`) — the "paired" row:
  dword 132*ebx + (102 + K div 4); NOT a whole row multiple, but a
  well-defined flat dword index.
- `T = 33*eax` (propagation loops) — dword 66*eax + (102 + K div 4).

Every term translates to the flat dword index `2*T + 102 + (K div 4)`
of `gvar_011AE1C4`; no per-row "slot" interpretation is needed and all
terms resolve to integers. AHNGlobals now exposes
`ChartAFlat(I)/SetChartAFlat(I,V)` for literal access; recon keeps the
old `[r][d]` expressions where they fit (FD4/9010 unchanged —
`[r][2]` = flat 102*r+2, identical memory).

**Power idiom semantics pinned** (empirically from the argument build
order): the callee is called with Pascal-convention stack args built
right-to-left — first push `80000000:$4000` = Extended **2.0** (the
exponent), last assembled via `fild/fstp` = **N** (the base, N =
level-1). So the call is `Power(2.0, lvl-1)` = `2^(lvl-1)`, and
`ebx := Round(Power(2.0, lvl-1)) = 2^(lvl-1)`. (The Delphi heuristic
"stack args are pushed left-to-right for the register convention"
does not apply here; the balanced epilogue with no caller cleanup
proves a calle-pops convention.) The BASM replica crash is moot.

Both walkers (C9C and E3C, address-identical except one dword shift and
the callee `5689 7C`→`568B04`) implement: for lvl := V-1 downto 1, start
at row `2^(lvl-1)`, skip rows whose status dword is 0, then while the
row's level dword equals lvl run the pair-normalization body (compare
row ebx value against the "doubling row" 132*ebx value, propagate the
delta through the 66*eax stride chain while the level dword matches)…

### vz2 (00569504) — converted, build green (2026-10-25)

- Signature fixed: `procedure vz2(AValue: TCanvas);` (AValue = EDX,
  listing `[ebp-8]`; `[ebp-4]` = Self). Draws the ancestor chart into
  AValue, working entirely on a copy of grid A in grid B
  (`gvar_019764C4[row][k]`, row-local `[esi+edi*8-X]` offsets resolved:
  -194→d1, -19C→d0, -190→d2, -18C→d3, -184→d5, -17C/-178→d7/d8,
  -170/-16C→d10/d11, -160/-15C→d14/d15, -158→low word of d16,
  -0D7→ShortString@193 ('M'/'W' flag), -100→ShortString@152 (ID),
  -56→ShortString@322 (photo), -150→20 AnsiString ptrs @72).
- Head: crHourGlass; saves ScrollBar1/2.Position into 2536364/2536368
  (zeroed when `PaintBox1.Canvas <> AValue`); fills PaintBox white;
  `FindKey(Table17, [gvar_011AE368])` builds title
  `'Vorfahren von ' + sub_00563868(Name) + ' ' + Vornamen`, TextOut at
  `Round(f*30)-364-8 / Round(f*5)-368`.
- Build loop copies A→B fields verbatim (incl. word copy of d16 low
  half, 20 ChartAAnsi→ChartBAnsi slots) and computes
  `B[0] := (A[0]-1)*(334+118)+340-364`,
  `B[1] := (A[1]-1)*(37C*318+318+348+114)+33C-368`.
- Min-scan edx = min B[0] (B[3]>0, init $186A0=100000); shifting
  `B[0] -= 364 + edx - 340` when edx > 340.
- Loop 1: vertical line above each box (MoveTo (B0+334/2, B1),
  LineTo (B0+334/2, B1-half), only when B5<328 and (B7>0 or B8>0));
  'W' rows (row>1): line from bottom B1+cnt scaled (+348-1) down to
  +half, cnt = 37C*318+318.
- Loop 2: parent → child lines for B[7] and B[8] (guard B5<328 and
  child>0); LineTo bottom of child box; trailing PaintBox-equal/≠
  duplicate LineTo pair — [7] child: BOTH sides without inc; [8] child:
  equal-branch without, inequal-branch with `inc eax` (y+1).
- Loop 3: maximizes 331C = (B0-340+364) div (334+114) (identical asm
  recompute transcribed) and 324 = max B5; FindKey([B3]); text
  `wasSchon`: 'K: ' from a 10-byte Extended built via push order
  d14=mant.lo, d15=mant.hi, low word of d16=exponent (recon uses an
  `absolute` overlay: extOver.Lo=d14, Hi=d15, W=word(d16));
  `if 2C4=1`: empty → `'DS: '+IntToStr(B3)` else `wasSchon+' DS: '+…`;
  `if 2C8=1 and BShort(152) > ' '`: empty → 'ID: '+ss truncated to 44
  (@PStrNCat cl=$2C) else `wasSchon + ' ID: ' + ss`.
- TextOut at (Round(B0*f)+2, Round(B1*f)+Font.Height-2) with
  Font.Size = Round(120*9)-1, then Size restored to Round(120*9).
- Photo (`if 2BC=1` and ss@322 > ' '): TImage.Create(Self),
  LoadFromFile(ss@322), `if Graphic is TJPEGImage then` scale Image
  width = Round(GraphicWidth * Image.Height/GraphicHeight)
  (fdivrp → ImageH/Gh); Rect((B0+4),(B1+2),(B0+Round(W/H*cnt*4/5)),
  (B1+Round(cnt*4/5))) with cnt = 37C*318+318; `Proportional := True`;
  `StretchDraw` — NOTE: TCanvas.StretchDraw(ARect, AGraphic) in Delphi
  2006, rect comes FIRST (matches lea edx=[ebp-35]; ecx=Graphic); then
  img.Free.
- 20-string loop (slotI 0..19, slotRow y-counter): Font.Style := []
  every slot, [fsBold] when slotI=0 and also after a rightmost '#'
  strip (only slotI 0..3 do the '#' check → the slot string is replaced
  by Copy(s, 1, len-1)); TextWidth per slot; x offset
  `Round((334*f - TextWidth)/2)` (fsubrp direction!) added to
  Round(B0*f); y = Round((B1 + 3 + slotRow*318 + 348)*f); text = Trim
  of ChartBAnsi(102*row+18+slotI)^.
- Boxes: Pen.Color := 0, Brush.Style := bsClear (dl=1, NOT bsSolid!),
  'M' → Rectangle((B0,B1)-Round((B0+334, B1+cnt+348)) — the 348 is
  ADDED in INTEGER space before scaling, i.e. Round((B1+cnt+348)*f);
  'W' → same Rect via RoundRect(..., 15, 15); Pen.Color := 0 again per
  row.
- Tail: `ScrollBar1.Max := (331C+1)*(334+118)+340`;
  `ScrollBar2.Max := (37C*318+114+318+348)*324+33C`; crDefault.
- Unit13 uses additions: `jpeg` (TJPEGImage) and `Types` (TRect) at
  implementation level; helper `gvar_0061F114` retyped Single→Integer
  in AHNGlobals (all reads are dword/ROUND).
- Next in address order: vz1 (005711D4, listing L13489), then
  Nach_erm (0056A970, L7311), nr1 (0056C0D4), nr2 (0056CB30),
  nz1 (0056D6B4), nz2 (0056EB10).

### vz1 (005711D4, listing L13489–14575) — converted, build green (2026-10-25)

- Signature fixed: `procedure vz1(AValue: TCanvas);` (AValue = EDX,
  `[ebp-8]`). Grid B access: listing keeps `edi = gvar_0197665C` (=
  gvar_019764C4 + $198, the same frame vz2 calls esi) with
  `esi = 51*row` → `[edi + esi*8 + X]` maps IDENTICALLY to
  `gvar_019764C4[row][d]` (same offset table as vz2; no new helper
  needed).
- Differences vs vz2 (otherwise structurally the same A→B copy, min
  scan, shift, K:/DS:/ID: text with the same 10-byte Extended build,
  JPEG photo with identical Rect math, 20-string '#' loop, M/W boxes,
  identical ScrollBar1/2.Max tail):
  - Head: PaintBox white fill FIRST; 2536364/2536368 := 0 ALWAYS, then
    loaded from ScrollBar1/2.Position only when
    `PaintBox1.Canvas = AValue` (vz2 is the inverse order).
  - NO 'W' drop line, NO above-box connector loop.
  - Child connectors ([7] and [8], guard B5<328 and child>0) are
    orthogonal 3-segment lines: MoveTo((B0+334, Yp)) where
    Yp = Round(f*(B1 + (348*f + (37C*318+318))/2)) — the 348*f term is
    INSIDE the scaled expression; then LineTo to
    ((B0+334+118/2), Yp) [the 118/2 is added inside Round,
    X = Round((B0+334+118/2)*f)], then to (same X, childB1 variant of
    Yp), then to (childB0*f, childY). No PaintBox eq/ne variants, no
    −1/inc.
  - Extrema swapped: gvar_011AE324 := max of
    (B1-33C+368) div (37C*318+114+318+348) (idiv, duplicated asm
    recompute transcribed); gvar_011AE31C := plain max of B5.
- Next in address order: Nach_erm (0056A970, listing L7311), then
  nr1 (0056C0D4), nr2 (0056CB30), nz1 (0056D6B4), nz2 (0056EB10).

## Phase 2 — the mid-size ones (250 – 1500 lines)

These are single-purpose methods that need the DataModule2 tables or one or
two of the Phase-1 helpers. Convert them one at a time; each should compile
independently before the next.

- Unit3  `sub_005BEF5C` 308, `sub_00582C24`  411, `sub_005BC604` 1096,
         `sub_005BE4B8`  645, `illki`          687  ← done in Phase 1
- Unit1  `datsich`, `Sikoein`, `spitzbas`, `listen_akt` (size unconfirmed)
- Unit1  `vorf_erm2`     1076, `Vorf_erm` (Unit13) `Vr2`, `Vz2`,
         `Nach_ern`, `nz1`, `nz2`, `memein`, `nchf_neu`
- Unit17 `gebstvn`      1281, `gebst`   1248
- Unit13 `vz2`  1206, `Nach_ern` 1396, `nz1` 1437, `nchf_neu`  1682
- Unit19 `Namgeb`, `Namgv`, `alphlist`, `nachf` (sizes unconfirmed)
- Unit1  `ExcelExport1Click` 1931, `famblattx_daten` 2020,
         `FamblHTML` 4172, `Vorlist` 4055, `Vettern1Click` 2543,
         `Basen1Click` 2496, `geschachtelt1Click` 2106, `Pfen1Click` 2759
- Unit11 `Fgr`  2484, `zeichen` 1822
- Unit3  `gedein_neu`, `gedein2`, `gedein`, `gedaus`, `gedausx`,
         `ahndosein`, `osbein`, `adrschreib`, `gedausxv`, `gedausv`,
         `gedein_5`, `ofb3`, `ofb2` (sizes unconfirmed — the GEDCOM I/O chain)
- Unit17 `BitBtn1Click` 4341
- Single-`Click` handlers in Unit16, Unit18, Unit20, Unit22, Unit24, Unit33

## Phase 3 — the GEDCOM I/O chain (Unit3, 13 methods)

Do these **in order** (innermost helper first), each depending on the
previous:

```
gedein_5  →  gedin2  →  gedin → gedin_neu
gedausv   →  gedausxv → gedaus → gedausx
            (osbein, adrschreib, ahndosein are the non-GEDCOM I

### nach_erm (0056A970, listing L7311�8706) � converted, build green (2026-10-25)

- `TForm13.Nach_erm` implemented in `Units\Unit13.pas` (head, zero-init, phase 1 BFS, phase 2 grid-A fill, phase 3 tail). `Unit1` added to the implementation uses (Form1.DBText1); `Unit12`/`Unit2`/`AHNGlobals` were already present.
- Grid A zero-init fields: d0,d1,d2,d3,d5,d7,d8,d10,d11,d12 + in-row bytes 316/318/320/322. Grid B zero-init: d0..d3, d5, d7, d8, d9, d10, d11, d12 + same bytes (no d4/d6/d10 exceptions: d10 IS cleared for B). Loop `for edi := 10000 downto 1`.
- Head: gvar_0253636C := 0 (3-part Extended store), 61F118 := Round(61F120*20), 61F114 := Round(61F120*30), 11AE344/31C := 0, 11AE334 += 10 if 61F2BC=1.
- Setup: startNr := Table1Nummer.AsInteger; 61F2F0 := StrToInt(Form12.SpinEdit1.Text); birth filter when 02536BA0 > 1 ('gebjahr<=n and taufjahr<=n', Filtered := True, Form1.DBText1.Color := $FFFF); FindKey ignored; index 'vat' if Geschlecht(M) / 'mut' if (W); FindKey([startNr]) � if the checked FindKey fails ? ShowMessage('Keine Nachfahren gefunden.') + Exit **without restoring the cursor** (original behavior); fonts/heights set on PaintBox1.Canvas.Font; 61F118/61F114 re-set (same values), 11AE33C := Round(61F120*45), 11AE340 := Round(61F120*20), 11AE318 := -PaintBox1.Canvas.Font.Height + 2; chain := Num2Str(Table17Nummer).
- Phase 1 (chunk BFS over chain): markers/nextChain patterns as documented; per pnun: markers-dedup prepend on chain itself, Table18.IndexName 'num', FindKey([pnun]) then repeat while (not Eof) and (Table18Nummer = pnun); chain += Num2Str(Epnum) (markers-dedup); bmk := -1 (v150 GetBookmark stub); Table17 'index' reset, FindKey([Epnum]) ignored; **v1A0 GotoBookmark = no-op comment**; gender M ? Index 'vat', walk Vater = pnun (append nextChain when Mutter = Epnum or Mutter = 0, markers-dedup when gen < max); W ? Index 'mut', walk Mutter = pnun (Vater = Epnum or Vater = 0, symmetric). Then Index '', v1A0 no-op, Table18.Next; chain := nextChain after the chunk loop.
- Phase 2 (grid A fill): person row edi gets d2 := edi, d3 := Nummer, d7 := Vater, d8 := Mutter (nulled when edi = 1), shortstrings: ID @152 (Copy(...,1,40)), sex uppercased @193, photo @322 ('_bitmap path gvar_02536B9C + '\bilder\b' + IntToStr(d3) + 'a.jpg', computed twice, only if 61F2BC = 1 and FileExists); d0/d1 per Nachgr1 (gen-1+ardy / colx) or Nachgr2 (swapped); 20 ChartSlotAnsi slots cleared; d5 := gen. Marriage row then: chain += Num2Str(Epnum); bmk := -1; d2..d12 filled; **d10 := ChartAFlat(102*(edi-1)+3)** (asm: [11AE038+408edi] = d3 of the previous row); pIdx (EDI/partner counter) into d12; slot trims into flat 102*edi+17 for slots 1..19 (slot order 1..19, slot 0 excluded; condition Length(Trim(slot)) > 0); 0056BA66-B82 is a **dead block** (cmp [ebp-0C],0 never 0 � count is 20 from the clear loop), transcribed as a comment only. After the marriage loop: nextChain built with dup-check only in the *parent-without-marriage-parent* arm (Vater/Mutter = 0 uses Pos-dedup, = Epnum appends unconditionally, **no '*' markers in phase 2**). End per generation: chain := nextChain, colx := 1, gvar_011AE344 := edi.
- Phase 3: cursor default, 11AE328 := max(d5) walking rows while d2 > 0, gvar_02522AD8[edi] := d0, gvar_0252C718[edi] := d1 (arrays[0..10499] of Integer, AHNGlobals); ShowMessage 'N Generationen / M-1 Personen gefunden'; gvar_011AE32C := PaintBox1.Canvas.
- FindKey results are only Boolean-tested where the listing tests al; elsewhere the call is transcribed without using the result. FindKey([X]) transcribed as `DataModule2.TableXX.FindKey([X]);`

### nr1 (0056C0D4, listing L8708–9325) — converted, build green (2026-10-25)

- `TForm13.nr1` implemented in `Units\Unit13.pas` (replaces the stub). Locals: `row, child, i0, count, gen, esi` (esi = the listing's "last child row" chain variable, reused across the push loops).
- Head: 011AE340 := Round(61F120*45); **011AE33C := 30 (immediate, not Round!)**; 61F118 := Round(61F120*30); 61F114 := Round(61F120*20); 011AE334 := Round(61F120*120) + 011AE338; crHourGlass; 02536364/365 := 0; if `PaintBox1.Canvas = gvar_011AE32C` then load them from ScrollBar1/2.Position (inverse of nz2). 011AE348/0253637C/011AE318 := 0; overlay-canvas Font 'Arial' Size Round(120*9), 011AE318 := -Font.Height + 2 (plain neg/add-2, no nested Round); PaintBox1.Canvas same Size and 318 recompute; 0253636C := 0.
- Printer branch (`Printer.Canvas = gvar_011AE32C`): 0253636C := 0.6 (mantissa 9999999A/B9999999 exp 4001); Printer.Canvas 'Arial', Size Round(120*9); `count := PaintBox1.Canvas.Pen.Width` ([esp+18]); `Printer.Canvas.Pen.Width := Round(count * 0253636C)`. Screen branch: if `PaintBox1.Canvas <> gvar_011AE32C` then 0253636C := 0.1.
- `DataModule2.Table17.IndexName := ''`. Row loop (while `ChartAFlat(102*row+2) > 0`): clear 20 ChartSlotAnsi(i0) + row slots `ChartAAnsi(102*row+18+i0)`; `Table17.FindKey([ChartAFlat(102*row+3)])`; `memein(ChartAFlat(102*row+11))` (EDX arg = d11); `zerleg(gvar_011AE334, gvar_011AE318, gvar_011AE32C)`; copy slots back into 102*row+18+i0.
- `if gvar_0061F2BC = 1 then gvar_011AE348 := Round(((0253637C*011AE318)+011AE318)*4/5)` (imul/add/shl-2/fild/fdiv 5).
- Marking pass 1 (0056C477–C52B): nested whiles over rows `row` and `child` (both cond `d2 > 0`); if `d7(child) = d3(row)`, `d7(child) > 0` and `ChartAShort(child,316)^ <> '*'` then `Set(…+7, row); 316 := '*'` (`mov word ptr […-5C],2A01`). Pass 1b: d8/byte318 symmetric (same loop body).
- Marking pass 2 (0056C52B–C599): d10/byte320: `Set(…+10, child - 1)` (partner row = ebx−1!). `lea eax,[edi+…-58]` = byte 320 ✓ (408−88).
- Alignment (anchor conversion: `lea eax,[edi+14]` = row(R+1) d5 anchor; d1-index = flat 102R+1, d7=+7, d8=+8, d5=+5; `[eax+198]` = next row d1, `[eax+1A8]` = next d5; `[edi+W-17C/-178/-194]` = row W d7/d8/d1):
  - Loop A (0056C59B–C732, runs when 011AE328 ≥ 3, count = 328−3+1, gen = 3..): per level (esi reset to 0 each level): rows1: if d5(row) = gen and esi ≠ d7/d8 → for d7/d8 > 0 with row(child).d7>0 or row(child).d8>0: child.d1 := row.d1, esi := child; rows2 push (if d5>1, = next d5, d1 ≥ next d1 → next d1 := d1+1); rows3 (parent onto child: row.d1 := child.d1); rows4 push again. Inc gen; until count = 0.
  - 0056C738–C7C7: if 328 ≥ 3 single scan gen = 3..(count−2): parent.d1 := child.d1.
  - 0056C7C9–C805: one push pass over all rows.
  - 0056C807–C8D1: if 328 ≥ 2, count = 328−2+1, gen = 2..: parent.d1 := child.d1 + push pass per level.
  - 0056C8D7–C98C: esi := 0; gen := 328 downto 2 (repeat..until gen ≤ 1): child.d1 := parent.d1 (esi-guard last-child).
  - 0056C992–C9CE: final push pass.
- 0056C9D0–CA22: max scan while d2>0: 011AE320 := max(d1), 011AE324 := max(d1) (both same comparison — literal).
- Tail: `gvar_011AE320 := gvar_011AE320 - 1` (06CA24); ScrollBar1.LargeChange := PaintBox1.Width − 5; ScrollBar2.LargeChange := PaintBox1.Height − 5 (Word-component offsets +48/+4C = TPaintBox.Width/Height, +222 = TScrollBar.LargeChange — IDR-labelled at sub_0056944D L6062–6079); SmallChange := 10 (0xA — note sub_0056944D uses 20/0x14); Screen.Cursor := crDefault.
- Component-offset mapping mnemonic (established): PaintBox1+48=Width, +4C=Height, +160=Canvas; ScrollBar+20C=Position, +220=SmallChange, +222=LargeChange (TScrollBarInc word).
- Next in address order: nz1 (0056D6B4), nz2 (0056EB10), nr2 (0056CB30) after nz-sibling helper sub_0056CAD4 is decoded (two-push variant of block B/D/F/J, called from nr2 at 0056D448/D510)..

### sub_0056CAD4 (listing L9329-9365) - converted, build green (2026-10-25)

- `TForm13.sub_0056CAD4` implemented (class decl added before nr2). Horizontal push variant for 'Nachgr2': anchors 11AE370 = row R d5 ([eax]=d5, [eax-14]=d0, eax+0x198 = next row d5, eax+0x184 = next d0); flat idx d5 = 102*R+5, d0 = 102*R. Guard `gvar_011AE328 < 2` exits; count = 328-2+1 passes, gen 2.., pushes next row d0 to d0+1 when same generation and d0 >= next d0. Row bound `gvar_011AE344 - 1` with repeat..until idiom.

### nr2 (0056CB30, listing L9368-10030) - converted, build green (2026-10-25)

- `TForm13.nr2` implemented in `Units\Unit13.pas` (replaces the stub). Locals: `row, child, i0, count, lvl, esi, gen, lastEsi, curGen, posIdx` + AnsiStrings `tmpS/tmpS2/tmpS3, marked, processed, tmpGenC, msg, pair1, pair2`. `esi` models the CPU register (persists across both alignment phases, init 0 at proc start).
- Head swaps vs nr1: 011AE33C := Round(61F120*45); **011AE340 := 30 (immediate)**; 61F118 := Round(*30); **61F114 := Round(*30) (not *20)**; 011AE334 := Round(*120)+338. Rest of head scroll/zero/Arial/318/0253636C/Printer-0.6/else-0.1 chain identical to nr1.
- Row loop: **SetChartAFlat(102*row, gvar_02522AD8[row]); SetChartAFlat(102*row+1, gvar_0252C718[row]);** first (editor x1/y1 preloads); d5(row) <> curGen ([ebp-38]) -> curGen := d5, posIdx ([ebp-3C]) := 1; clear 20 slots; FindKey([d3]); memein(d11); tmpS2 := Num2Str(d3)+'*'; if Pos(tmpS2, marked)=0 -> marked := marked + Num(d3)+'*'+RightStr('0'+IntToStr(curGen),2)+'*'+RightStr('00'+IntToStr(posIdx),3)+'*' (LStrCatN 7); else -> tmpGenC := Copy(marked, Pos(Num(d3),marked)+7, 2); posC := Copy(...,Pos+10,3); msg := '***'+#13#10+'s.a. Gen. '+IntToStr(StrToInt(tmpGenC))+' Pos. '+IntToStr(StrToInt(posC)); Memo1.Lines.Add(msg); processed += Num(d3)+'*'. Note: the first Pos search uses Num(d3)+'*' (with star), the else-branch Pos searches without star. zerleg + slot copy-back as nr1; per row Inc(posIdx).
- 348 recompute as nr1 (20*4/5 pattern -> *4 div 5).
- Marking pass 1 (0056D129-222): **outer bound for row := 1 to 344-1 (not while d2>0!)**, inner while d2(child) > 0: d7==d3(row) & b316<>'*' -> d7 := row; d8==d3(row) & b318<>'*' -> d8 := row.
- Sync pass (0056D224-D4): for row := 1 to 344-1, if d2(row)>0 then child-scan d10==d3(row) & b320<>'*' -> d10 := child-1; then **gvar_02522AD8[row] := d0(row); gvar_0252C718[row] := d1(row)** ([edi-8]/[edi-4] with edi = 11AE364+408*(r-1)).
- Alignment phase 1 (0056D2D5-46A): count := Round(328/2)+1, repeat; lvl := 328 downto 1 (repeat Dec(lvl)); per row (all rows incl. d5-mismatch!): pair1 := Num(d7)+'*'+Num(d8) built BEFORE the checks; if d5=lvl and Pos(Num(d3),processed)=0: esi := min(d7,d8); pair2 := Num(d7)+'*'+Num(d8); if CompareStr(pair2,pair1) <> 0 and esi > 0 and esi <> lastEsi: pair1 rebuilt, then max-swap d0(esi)/d0(row) (if d0(esi) > d0(row) then d0(row) := d0(esi) else d0(esi) := d0(row)), call sub_0056CAD4, lastEsi := esi. (pair1/pair2 are textually identical - faithful transcription.)
- Alignment phase 2 (0056D46A-52B): count := 328-2+1, gen := 2..; per row: guard `if (esi+1 >= d7) and (esi+1 >= d8) then skip` (proceed iff esi+1 < d7 or < d8 - listing cmp/jl/jge chain); if d5=gen and Pos(Num(d3),processed)=0: esi := min(d7,d8); if esi>0 and esi<>lastEsi: same max-swap + sub_0056CAD4 + lastEsi := esi. No pair strings here.
- Max scan: 011AE320 := max(d0), **011AE324 := max(d1) (different - nr1 used d1 for both)**. Tail: ScrollBar1/2.LargeChange := Width/Height-5, SmallChange := 10, crDefault.
- Next in address order: nz1 (0056D6B4, listing from L10334), nz2 (0056EB10), sam2 (00572D98), vorf_erm2 (00572A78), vr1 (00570D1C), memein (00566220, L2802), zerleg (005675D8), nachf_neu (00564668), PaintBox1Paint (00570C14), FormShow/FormClose, buttons.

### nz1 (0056D6B4, listing L10033-11178) - converted, build green (2026-10-25)

- `TForm13.nz1(ACanvas: TCanvas)` (EDX = canvas) implemented; decl updated from `nz1;`. Draws the "Nachfahren" chart variant 1. Offset map (esi = $197665C = gvar_019764C4[1], verified against the green vz1 transcription): [esi + 408*row + X] -> gvar_019764C4[row][(408+X) div 4] byte-wise for ShortStrings; grid A side: [edi*8 + 11AE1CC + n] with edi = 51*row -> gvar_011AE1C4[row][k].
- Local var keys: [ebp-10] = slotRow, [ebp-0C] = slotI, [ebp-14] = centered text x-corr, [ebp-24] = B-slot base ptr (+4 per name line), [ebp-1C] = wasSchon. Note [ebp-24] is NOT TImage - img is edi in the photo block.
- Loop 1 (copy: while A[row][2] > 0): Table17.FindKey([A[row][3]]) EVERY row; copy d2,d3,d5; sex: `tmpS := UpperCase(ChartAShort(row,193)^); ChartBShort(row,193)^ := tmpS` (LStrFromString/UpperCase/LStrToString/PStrNCpy cl=28); d7,d8; ptrs (CopyArray 20 dwords = ChartBAnsi loop); @152 (cl=28); d9,d10,d11; @322 (cl=50); d12; B.d0 := (A.d0-1)*(334+61F118) + 340 - 364; B.d1 := (A.d1-1)*(37C*318+318+61F114+348) + 33C - 368; gvar_011AE320 := max(A.d0).
- Title: FindKey([B[1][3]]); name = Table17Name.AsString via sub_00563868, vor = Table17Vornamen.AsString; 'Nachfahren von ' + tName + ' ' + tVor; TextOut(Round(6C*30)-364, Round(6C*5)-368, ...).
- Connector loop (while B[row][2] > 0), only when B.d1 > 0:
  - father elbow only when d5 < 11AE330 AND d5 > 1 AND d7 > 0 AND B[d7].d1 > B[d8].d1: MoveTo(Round(d0*6C), Round(6C*(d1+h/2))), then 3 LineTos: (d0-61F118/2, d1+h/2), (d0-61F118/2, B[f].d1+h/2), (d0-61F118-1, B[f].d1+h/2) with h = 37C*318+318+348.
  - **mother elbow runs unconditionally for every row (both d5 guards jump into the mother block at 0056DC6B)**: guarded by d8 > 0 and B[m].d1 > B[f].d1, same 4 segments with B[m].d1.
  - spouse drop line at 0056DE5B when d11 > 0: MoveTo((d0+334/2)*6C, d1*6C), LineTo((d0+334/2)*6C, (d1-61F114-1)*6C).
- Extrema loop (while B[row][2] > 0): 11AE324 = max of (d1-33C+368) div (37C*318+61F114+318+348); 11AE31C = max of (d0-340+364) div (61F118+334) (different from vz1's plain d5!); skips if B[row][3] <= 0.
- Per-person block: wasSchon: DS: (61F2C4=1, IntToStr(d3)); ID: (61F2C8=1 and len(BShort 152) > 0 - shortstring length byte cmp, NOT PStrCmp; 'ID: ' cl=2C concat); father/mother count suffixes: TWO sequential blocks (0056E0AD: if d7>0 {if d8=0 -> +B[f].d12; else if B[f].d12>1 ->} else-if B[f].d12>1; 0056E155: if d7=0 {if d8>0 -> +B[m].d12; else if B[m].d12>1 ->} else-if B[m].d12>1) - the d12 read is B[B[row][k]][12] (offset -168/4+... = d12 at row f/m).
- Font sizes: size R(61F120*9)-1 for wasSchon, TextOut(Round(d0*6C)+2, Round((d1-318)*6C)+1); then size R(61F120*9); FindKey([d3]) after the wasSchon TextOut.
- 20-name loop (slotI 0..19, repeat until slotI=20): Font.Style [] each line, [fsBold] when slotI=0; '#' strip blocks for slots 18/19/20/21 (slotI 0..3: BAnsi(102*row+18+k), RightStr=1 then LStrCopy(len-1), bold after strip); TextWidth(BAnsi(18+slotI)); ebp14 := Round((334*6C - tw)/2); TextOut(Round(d0*6C)+ebp14, Round((d1+slotRow*318+348)*6C)+3, raw slot string, NOT Trimmed).
- Boxes: Brush bsClear + Pen 0; ChartBShort(row,193) = 'M' -> Rectangle, 'W' -> RoundRect(15,15), 'X' -> Pen 0 + RoundRect(15,15); then Pen.Color := 0 again; box = (d0,d1,d0+334,d1+37C*318+318+348) all *6C.
- Photo (61F2BC=1, BShort(row,322) > ' '): TImage.Create(Self); LoadFromFile; `if Graphic is TJPEGImage` (IsClass -> byte flag): ratio := img.Height / Graphic.Height (fdivrp), img.Width := Round(Graphic.Width * ratio); q1 := Round((37C*318+318)*4/5); q2 := Round(Graphic.Width / img.Height * ((37C*318+318)*4/5)) (fdivp W/H then fmul with the shl-2/fdiv-5 term - NOT the rounded q1); aRect = Rect(Round((d0+4)*6C), Round((d1+2)*6C), Round((d0+q2)*6C), Round((d1+q1)*6C)); Proportional; StretchDraw; Free.
- Tail: ScrollBar1.Max := (11AE31C+1)*(334+61F118) + 340; ScrollBar2.Max := (37C*318+61F114+318+348)*11AE324 + 33C; crDefault. Finally-frames free LStr clr blocks.
- nz2 (0056EB10, L11180+) next; prologue is byte-identical to nz1 (same copy loop); draw part differs.
