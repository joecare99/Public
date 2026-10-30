# Remaining work plan (Restplan) â€” AHNENWIN 5.1 recon

State: **572 / 659** methods reconstructed (87 open). Build is green.

Method sizes below are the number of *disassembly* lines in the listing
(the `{*procedure â€¦` block or the plain `procedure â€¦` body up to the next
procedure). "Lines" therefore is *code*, not Delphi â€” a 500-line listing may
become 100 lines of Pascal.

---

## Phase 1 â€” the small ones (< 250 disassembly lines)

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
| 12| `sub_00582C24`  | Unit3  | 411 | **</br> COMPLETED 2026-10-29 (build green)** |
| 13| `nam2`          | Unit17 | 486 | **</br> COMPLETED 2026-10-30 (build green)** |
| 14| `fambeltern`    | Unit17 | 509 | **</br> COMPLETED 2026-10-30 (build green)** |
| 15| `nr1`           | Unit13 | 658 |
| 16| `nr2`           | Unit13 | 665 |
| 17| `sub_005BC604`  | Unit3  | 1096 | **</br> COMPLETED 2026-10-29 (build green)** |
| 18| `sub_005BE4B8`  | Unit3  | 645 | **</br> COMPLETED 2026-10-28 (build green)** |
| 19| `illki`         | Unit3  | 687 | **</br> COMPLETED 2026-10-30 (build green)** |

> **Note on Unit13 items (4â€“10, 15â€“16):** they touch the shared chart arrays.
> The layout is now PINNED â€” see "Phase A findings" below.

## Phase A findings (layout, pinned 2026-10-25)

These are the chart row grids of Unit13. One row per person, **row size
$198 = 408 bytes**, row count **$2710 = 10000** (matches the IDR annotation
`array[10000] of ?`). Both facts close ONLY with hex constants: the
`imul â€¦,33` scale is $33 = 51 and every row slot is 8 bytes (`51 Ã— 8 =
408 = $198`); a decimal "33" would give 264 B and contradict the
explicit `add/sub â€¦,198` row walks.

Recon declarations (see `Units\AHNGlobals.pas`):

- `TChartRow = array[0..101] of Integer` (408 B), `TChartRows = array[0..9999] of TChartRow`.
- **Grid A** `gvar_011AE1C4` (labels inside: `011AE1CC` = row[r].dword[2],
  `011AE35C` = row[r+1].dword[0], `011AE360` = dword[1], `011AE364` = dword[2]).
- **Grid B** `gvar_019764C4` (labels inside: `019764C8` = dword[1],
  `019764D8` = dword[5], `019764E0` = dword[7]; row r+1: `0197665C` = dword[0],
  `01976664` = dword[1], `01976668` = dword[3], `01976670` = dword[5]).
- **Grid C** `gvar_015924E4` â€” a second 10000Ã—$198 working copy (load/store
  mirror of grid A, copied stride-$198 with count $2710 in the method at
  005693Câ€¦0056943E).
- **Person mirror** `gvar_0061F30C`: `TPersonRec = array[0..531] of Byte`
  ($214 = 532 bytes), count `$13880 = 80000`; pinned fields: +0 num,
  +4 flag, +8 kind, +$137/+$10E/+$160 = ShortString[28] (the Len byte
  at +$137 is compared with 'W').

All cell math in the listings is 4-byte (`fild dword ptr`, cmp dword), so
the 8-byte slots are **array[0..1] of Integer pairs (lo = +0, hi = +4)** â€”
not DateTime/Double (the listing's `fild` converts an Integer to double,
it does not load floats).

Converted against this layout so far:

- `sub_00568FD4` / `sub_00569010` â€” scan rows while
  `gridA[r].dword[2] > 0`, track the max of `gridA[r].dword[5]`, then call
  `sub_00568C9C(max)` / `sub_00568E3C(max)` respectively (Unit13 recon,
  build green).
- `sub_00568C9C` / `sub_00568E3C` â€” converted (build green), see
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
  is ABOVE (branch 2) the neighbor value â€” sort-shift semantics,
  versus the distribute semantics of C9C/E3C.
- `TForm13.Symm` (00568834): two backward row walks over grid B from
  row `gvar_011AE344` downto 1. Part 1 moves `gridB[esi][0]` to the
  midpoint of `gridB[esi][7]`/`[8]` (via `ChartBFlat(102*d)` row-index
  deref: term `[T*8 + 19764C4]` = flat dword `2*T`) when the pair
  differs by more than `gvar_011AE334+gvar_0061F118`, then
  `gvar_011AE31C := max(011AE31C, [esi][0] div sum âˆ’ 1)`. Part 2
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
  dword down (`ChartBFlat(102*val â†’ +1)`); else when both parents
  `[r][6]/[r][7]` are 0 and the row is a level-equal successor,
  place at previous row's position + the spacing constants
  (`0253637C*011AE318 + 011AE318 + 61F118 + 011AE348` in vm1;
  `011AE334 + 61F118` in vm).
- `TForm13.kek_ord` (005686F0): 011AE328-1 passes; anchor 1976670 =
  `row[r][5]`; when `[r][5] < 011AE328` and equals `[r-1][5]`, all
  three dwords 3 of rows r/râˆ’1/r+1 positive, `[r][0] <= [r-1][0]` and
  `[r][7] = [r][8] = 0`: `[r][0] := 2*(011AE334+61F118) + [r-1][0]`.
- `TForm13.kek_ord_2` (00568774): counter trap gives EXACTLY two row
  walks with ecx = Vâˆ’1 then Vâˆ’2; conditions keyed on ecx; then
  `[r][0] := [r-1][0] + sum` and `[r-1][0]` gets +/- sum by the PARITY
  of `[r][2]` (and $80000001 idiom = sign-corrected odd test).
- `TForm13.Vr2` (0056904C) converted: screen/canvas metric setup
  (`fScale` = `gvar_0253636C` = 1.0 normally, 1.13 when drawing
  canvas <> PaintBox1.Canvas; 6.0 pen multiplier on the printer branch â€”
  all Extended constants recovered from the mantissa/exp words).
  Then: walks grid A rows (`while [r][2] > 0`, r starts 1), clears
  20 slot strings (011AE2C8..011AE2F8 area) + 20 row-local string
  slots (flat dword 102*row+19, ..., via new `ChartAAnsi` helper),
  FindKey on DataModule2.Table17 with `[row][3]`, calls
  `memein(gvar_011AE1C4[row-1][3])` and
  `zerleg(011AE334, 011AE318, canvas)` â€” both still TODO stubs
  (declared: `memein(AValue)` EDX, `zerleg` 3-register/stack args;
  IDR lists zerleg as function, result unused here). Copies dwords
  0..2 of each grid-C row (`gvar_015924E4`, 408-B rows) into the
  FD4-family grid rows (flat 102r..102r+2 = gvar_011AE1C4 rows 1..),
  calls sub_00569010, computes max `[r][0]` â†’ 011AE320 (then Dec),
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

- `T = 51*ebx` (from `imul eax,ebx,33`) â€” row ebx, dword (102 + K div 4).
- `T = 66*ebx` (from `add eax,eax; imul â€¦,33`) â€” the "paired" row:
  dword 132*ebx + (102 + K div 4); NOT a whole row multiple, but a
  well-defined flat dword index.
- `T = 33*eax` (propagation loops) â€” dword 66*eax + (102 + K div 4).

Every term translates to the flat dword index `2*T + 102 + (K div 4)`
of `gvar_011AE1C4`; no per-row "slot" interpretation is needed and all
terms resolve to integers. AHNGlobals now exposes
`ChartAFlat(I)/SetChartAFlat(I,V)` for literal access; recon keeps the
old `[r][d]` expressions where they fit (FD4/9010 unchanged â€”
`[r][2]` = flat 102*r+2, identical memory).

**Power idiom semantics pinned** (empirically from the argument build
order): the callee is called with Pascal-convention stack args built
right-to-left â€” first push `80000000:$4000` = Extended **2.0** (the
exponent), last assembled via `fild/fstp` = **N** (the base, N =
level-1). So the call is `Power(2.0, lvl-1)` = `2^(lvl-1)`, and
`ebx := Round(Power(2.0, lvl-1)) = 2^(lvl-1)`. (The Delphi heuristic
"stack args are pushed left-to-right for the register convention"
does not apply here; the balanced epilogue with no caller cleanup
proves a calle-pops convention.) The BASM replica crash is moot.

Both walkers (C9C and E3C, address-identical except one dword shift and
the callee `5689 7C`â†’`568B04`) implement: for lvl := V-1 downto 1, start
at row `2^(lvl-1)`, skip rows whose status dword is 0, then while the
row's level dword equals lvl run the pair-normalization body (compare
row ebx value against the "doubling row" 132*ebx value, propagate the
delta through the 66*eax stride chain while the level dword matches)â€¦

### vz2 (00569504) â€” converted, build green (2026-10-25)

- Signature fixed: `procedure vz2(AValue: TCanvas);` (AValue = EDX,
  listing `[ebp-8]`; `[ebp-4]` = Self). Draws the ancestor chart into
  AValue, working entirely on a copy of grid A in grid B
  (`gvar_019764C4[row][k]`, row-local `[esi+edi*8-X]` offsets resolved:
  -194â†’d1, -19Câ†’d0, -190â†’d2, -18Câ†’d3, -184â†’d5, -17C/-178â†’d7/d8,
  -170/-16Câ†’d10/d11, -160/-15Câ†’d14/d15, -158â†’low word of d16,
  -0D7â†’ShortString@193 ('M'/'W' flag), -100â†’ShortString@152 (ID),
  -56â†’ShortString@322 (photo), -150â†’20 AnsiString ptrs @72).
- Head: crHourGlass; saves ScrollBar1/2.Position into 2536364/2536368
  (zeroed when `PaintBox1.Canvas <> AValue`); fills PaintBox white;
  `FindKey(Table17, [gvar_011AE368])` builds title
  `'Vorfahren von ' + sub_00563868(Name) + ' ' + Vornamen`, TextOut at
  `Round(f*30)-364-8 / Round(f*5)-368`.
- Build loop copies Aâ†’B fields verbatim (incl. word copy of d16 low
  half, 20 ChartAAnsiâ†’ChartBAnsi slots) and computes
  `B[0] := (A[0]-1)*(334+118)+340-364`,
  `B[1] := (A[1]-1)*(37C*318+318+348+114)+33C-368`.
- Min-scan edx = min B[0] (B[3]>0, init $186A0=100000); shifting
  `B[0] -= 364 + edx - 340` when edx > 340.
- Loop 1: vertical line above each box (MoveTo (B0+334/2, B1),
  LineTo (B0+334/2, B1-half), only when B5<328 and (B7>0 or B8>0));
  'W' rows (row>1): line from bottom B1+cnt scaled (+348-1) down to
  +half, cnt = 37C*318+318.
- Loop 2: parent â†’ child lines for B[7] and B[8] (guard B5<328 and
  child>0); LineTo bottom of child box; trailing PaintBox-equal/â‰ 
  duplicate LineTo pair â€” [7] child: BOTH sides without inc; [8] child:
  equal-branch without, inequal-branch with `inc eax` (y+1).
- Loop 3: maximizes 331C = (B0-340+364) div (334+114) (identical asm
  recompute transcribed) and 324 = max B5; FindKey([B3]); text
  `wasSchon`: 'K: ' from a 10-byte Extended built via push order
  d14=mant.lo, d15=mant.hi, low word of d16=exponent (recon uses an
  `absolute` overlay: extOver.Lo=d14, Hi=d15, W=word(d16));
  `if 2C4=1`: empty â†’ `'DS: '+IntToStr(B3)` else `wasSchon+' DS: '+â€¦`;
  `if 2C8=1 and BShort(152) > ' '`: empty â†’ 'ID: '+ss truncated to 44
  (@PStrNCat cl=$2C) else `wasSchon + ' ID: ' + ss`.
- TextOut at (Round(B0*f)+2, Round(B1*f)+Font.Height-2) with
  Font.Size = Round(120*9)-1, then Size restored to Round(120*9).
- Photo (`if 2BC=1` and ss@322 > ' '): TImage.Create(Self),
  LoadFromFile(ss@322), `if Graphic is TJPEGImage then` scale Image
  width = Round(GraphicWidth * Image.Height/GraphicHeight)
  (fdivrp â†’ ImageH/Gh); Rect((B0+4),(B1+2),(B0+Round(W/H*cnt*4/5)),
  (B1+Round(cnt*4/5))) with cnt = 37C*318+318; `Proportional := True`;
  `StretchDraw` â€” NOTE: TCanvas.StretchDraw(ARect, AGraphic) in Delphi
  2006, rect comes FIRST (matches lea edx=[ebp-35]; ecx=Graphic); then
  img.Free.
- 20-string loop (slotI 0..19, slotRow y-counter): Font.Style := []
  every slot, [fsBold] when slotI=0 and also after a rightmost '#'
  strip (only slotI 0..3 do the '#' check â†’ the slot string is replaced
  by Copy(s, 1, len-1)); TextWidth per slot; x offset
  `Round((334*f - TextWidth)/2)` (fsubrp direction!) added to
  Round(B0*f); y = Round((B1 + 3 + slotRow*318 + 348)*f); text = Trim
  of ChartBAnsi(102*row+18+slotI)^.
- Boxes: Pen.Color := 0, Brush.Style := bsClear (dl=1, NOT bsSolid!),
  'M' â†’ Rectangle((B0,B1)-Round((B0+334, B1+cnt+348)) â€” the 348 is
  ADDED in INTEGER space before scaling, i.e. Round((B1+cnt+348)*f);
  'W' â†’ same Rect via RoundRect(..., 15, 15); Pen.Color := 0 again per
  row.
- Tail: `ScrollBar1.Max := (331C+1)*(334+118)+340`;
  `ScrollBar2.Max := (37C*318+114+318+348)*324+33C`; crDefault.
- Unit13 uses additions: `jpeg` (TJPEGImage) and `Types` (TRect) at
  implementation level; helper `gvar_0061F114` retyped Singleâ†’Integer
  in AHNGlobals (all reads are dword/ROUND).
- Next in address order: vz1 (005711D4, listing L13489), then
  Nach_erm (0056A970, L7311), nr1 (0056C0D4), nr2 (0056CB30),
  nz1 (0056D6B4), nz2 (0056EB10).

### vz1 (005711D4, listing L13489â€“14575) â€” converted, build green (2026-10-25)

- Signature fixed: `procedure vz1(AValue: TCanvas);` (AValue = EDX,
  `[ebp-8]`). Grid B access: listing keeps `edi = gvar_0197665C` (=
  gvar_019764C4 + $198, the same frame vz2 calls esi) with
  `esi = 51*row` â†’ `[edi + esi*8 + X]` maps IDENTICALLY to
  `gvar_019764C4[row][d]` (same offset table as vz2; no new helper
  needed).
- Differences vs vz2 (otherwise structurally the same Aâ†’B copy, min
  scan, shift, K:/DS:/ID: text with the same 10-byte Extended build,
  JPEG photo with identical Rect math, 20-string '#' loop, M/W boxes,
  identical ScrollBar1/2.Max tail):
  - Head: PaintBox white fill FIRST; 2536364/2536368 := 0 ALWAYS, then
    loaded from ScrollBar1/2.Position only when
    `PaintBox1.Canvas = AValue` (vz2 is the inverse order).
  - NO 'W' drop line, NO above-box connector loop.
  - Child connectors ([7] and [8], guard B5<328 and child>0) are
    orthogonal 3-segment lines: MoveTo((B0+334, Yp)) where
    Yp = Round(f*(B1 + (348*f + (37C*318+318))/2)) â€” the 348*f term is
    INSIDE the scaled expression; then LineTo to
    ((B0+334+118/2), Yp) [the 118/2 is added inside Round,
    X = Round((B0+334+118/2)*f)], then to (same X, childB1 variant of
    Yp), then to (childB0*f, childY). No PaintBox eq/ne variants, no
    âˆ’1/inc.
  - Extrema swapped: gvar_011AE324 := max of
    (B1-33C+368) div (37C*318+114+318+348) (idiv, duplicated asm
    recompute transcribed); gvar_011AE31C := plain max of B5.
- Next in address order: Nach_erm (0056A970, listing L7311), then
  nr1 (0056C0D4), nr2 (0056CB30), nz1 (0056D6B4), nz2 (0056EB10).

## Phase 2 â€” the mid-size ones (250 â€“ 1500 lines)

These are single-purpose methods that need the DataModule2 tables or one or
two of the Phase-1 helpers. Convert them one at a time; each should compile
independently before the next.

- Unit3  `sub_005BEF5C` 308, `sub_00582C24`  411, `sub_005BC604` 1096,
         `sub_005BE4B8`  645, `illki`          687  â† done in Phase 1
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
         `gedein_5`, `ofb3`, `ofb2` (sizes unconfirmed â€” the GEDCOM I/O chain)
- Unit17 `BitBtn1Click` 4341
- Single-`Click` handlers in Unit16, Unit18, Unit20, Unit22, Unit24, Unit33

## Phase 3 â€” the GEDCOM I/O chain (Unit3, 13 methods)

Do these **in order** (innermost helper first), each depending on the
previous:

```
gedein_5  â†’  gedin2  â†’  gedin â†’ gedin_neu
gedausv   â†’  gedausxv â†’ gedaus â†’ gedausx
            (osbein, adrschreib, ahndosein are the non-GEDCOM I

### nach_erm (0056A970, listing L7311ï¿½8706) ï¿½ converted, build green (2026-10-25)

- `TForm13.Nach_erm` implemented in `Units\Unit13.pas` (head, zero-init, phase 1 BFS, phase 2 grid-A fill, phase 3 tail). `Unit1` added to the implementation uses (Form1.DBText1); `Unit12`/`Unit2`/`AHNGlobals` were already present.
- Grid A zero-init fields: d0,d1,d2,d3,d5,d7,d8,d10,d11,d12 + in-row bytes 316/318/320/322. Grid B zero-init: d0..d3, d5, d7, d8, d9, d10, d11, d12 + same bytes (no d4/d6/d10 exceptions: d10 IS cleared for B). Loop `for edi := 10000 downto 1`.
- Head: gvar_0253636C := 0 (3-part Extended store), 61F118 := Round(61F120*20), 61F114 := Round(61F120*30), 11AE344/31C := 0, 11AE334 += 10 if 61F2BC=1.
- Setup: startNr := Table1Nummer.AsInteger; 61F2F0 := StrToInt(Form12.SpinEdit1.Text); birth filter when 02536BA0 > 1 ('gebjahr<=n and taufjahr<=n', Filtered := True, Form1.DBText1.Color := $FFFF); FindKey ignored; index 'vat' if Geschlecht(M) / 'mut' if (W); FindKey([startNr]) ï¿½ if the checked FindKey fails ? ShowMessage('Keine Nachfahren gefunden.') + Exit **without restoring the cursor** (original behavior); fonts/heights set on PaintBox1.Canvas.Font; 61F118/61F114 re-set (same values), 11AE33C := Round(61F120*45), 11AE340 := Round(61F120*20), 11AE318 := -PaintBox1.Canvas.Font.Height + 2; chain := Num2Str(Table17Nummer).
- Phase 1 (chunk BFS over chain): markers/nextChain patterns as documented; per pnun: markers-dedup prepend on chain itself, Table18.IndexName 'num', FindKey([pnun]) then repeat while (not Eof) and (Table18Nummer = pnun); chain += Num2Str(Epnum) (markers-dedup); bmk := -1 (v150 GetBookmark stub); Table17 'index' reset, FindKey([Epnum]) ignored; **v1A0 GotoBookmark = no-op comment**; gender M ? Index 'vat', walk Vater = pnun (append nextChain when Mutter = Epnum or Mutter = 0, markers-dedup when gen < max); W ? Index 'mut', walk Mutter = pnun (Vater = Epnum or Vater = 0, symmetric). Then Index '', v1A0 no-op, Table18.Next; chain := nextChain after the chunk loop.
- Phase 2 (grid A fill): person row edi gets d2 := edi, d3 := Nummer, d7 := Vater, d8 := Mutter (nulled when edi = 1), shortstrings: ID @152 (Copy(...,1,40)), sex uppercased @193, photo @322 ('_bitmap path gvar_02536B9C + '\bilder\b' + IntToStr(d3) + 'a.jpg', computed twice, only if 61F2BC = 1 and FileExists); d0/d1 per Nachgr1 (gen-1+ardy / colx) or Nachgr2 (swapped); 20 ChartSlotAnsi slots cleared; d5 := gen. Marriage row then: chain += Num2Str(Epnum); bmk := -1; d2..d12 filled; **d10 := ChartAFlat(102*(edi-1)+3)** (asm: [11AE038+408edi] = d3 of the previous row); pIdx (EDI/partner counter) into d12; slot trims into flat 102*edi+17 for slots 1..19 (slot order 1..19, slot 0 excluded; condition Length(Trim(slot)) > 0); 0056BA66-B82 is a **dead block** (cmp [ebp-0C],0 never 0 ï¿½ count is 20 from the clear loop), transcribed as a comment only. After the marriage loop: nextChain built with dup-check only in the *parent-without-marriage-parent* arm (Vater/Mutter = 0 uses Pos-dedup, = Epnum appends unconditionally, **no '*' markers in phase 2**). End per generation: chain := nextChain, colx := 1, gvar_011AE344 := edi.
- Phase 3: cursor default, 11AE328 := max(d5) walking rows while d2 > 0, gvar_02522AD8[edi] := d0, gvar_0252C718[edi] := d1 (arrays[0..10499] of Integer, AHNGlobals); ShowMessage 'N Generationen / M-1 Personen gefunden'; gvar_011AE32C := PaintBox1.Canvas.
- FindKey results are only Boolean-tested where the listing tests al; elsewhere the call is transcribed without using the result. FindKey([X]) transcribed as `DataModule2.TableXX.FindKey([X]);`

### nr1 (0056C0D4, listing L8708â€“9325) â€” converted, build green (2026-10-25)

- `TForm13.nr1` implemented in `Units\Unit13.pas` (replaces the stub). Locals: `row, child, i0, count, gen, esi` (esi = the listing's "last child row" chain variable, reused across the push loops).
- Head: 011AE340 := Round(61F120*45); **011AE33C := 30 (immediate, not Round!)**; 61F118 := Round(61F120*30); 61F114 := Round(61F120*20); 011AE334 := Round(61F120*120) + 011AE338; crHourGlass; 02536364/365 := 0; if `PaintBox1.Canvas = gvar_011AE32C` then load them from ScrollBar1/2.Position (inverse of nz2). 011AE348/0253637C/011AE318 := 0; overlay-canvas Font 'Arial' Size Round(120*9), 011AE318 := -Font.Height + 2 (plain neg/add-2, no nested Round); PaintBox1.Canvas same Size and 318 recompute; 0253636C := 0.
- Printer branch (`Printer.Canvas = gvar_011AE32C`): 0253636C := 0.6 (mantissa 9999999A/B9999999 exp 4001); Printer.Canvas 'Arial', Size Round(120*9); `count := PaintBox1.Canvas.Pen.Width` ([esp+18]); `Printer.Canvas.Pen.Width := Round(count * 0253636C)`. Screen branch: if `PaintBox1.Canvas <> gvar_011AE32C` then 0253636C := 0.1.
- `DataModule2.Table17.IndexName := ''`. Row loop (while `ChartAFlat(102*row+2) > 0`): clear 20 ChartSlotAnsi(i0) + row slots `ChartAAnsi(102*row+18+i0)`; `Table17.FindKey([ChartAFlat(102*row+3)])`; `memein(ChartAFlat(102*row+11))` (EDX arg = d11); `zerleg(gvar_011AE334, gvar_011AE318, gvar_011AE32C)`; copy slots back into 102*row+18+i0.
- `if gvar_0061F2BC = 1 then gvar_011AE348 := Round(((0253637C*011AE318)+011AE318)*4/5)` (imul/add/shl-2/fild/fdiv 5).
- Marking pass 1 (0056C477â€“C52B): nested whiles over rows `row` and `child` (both cond `d2 > 0`); if `d7(child) = d3(row)`, `d7(child) > 0` and `ChartAShort(child,316)^ <> '*'` then `Set(â€¦+7, row); 316 := '*'` (`mov word ptr [â€¦-5C],2A01`). Pass 1b: d8/byte318 symmetric (same loop body).
- Marking pass 2 (0056C52Bâ€“C599): d10/byte320: `Set(â€¦+10, child - 1)` (partner row = ebxâˆ’1!). `lea eax,[edi+â€¦-58]` = byte 320 âœ“ (408âˆ’88).
- Alignment (anchor conversion: `lea eax,[edi+14]` = row(R+1) d5 anchor; d1-index = flat 102R+1, d7=+7, d8=+8, d5=+5; `[eax+198]` = next row d1, `[eax+1A8]` = next d5; `[edi+W-17C/-178/-194]` = row W d7/d8/d1):
  - Loop A (0056C59Bâ€“C732, runs when 011AE328 â‰¥ 3, count = 328âˆ’3+1, gen = 3..): per level (esi reset to 0 each level): rows1: if d5(row) = gen and esi â‰  d7/d8 â†’ for d7/d8 > 0 with row(child).d7>0 or row(child).d8>0: child.d1 := row.d1, esi := child; rows2 push (if d5>1, = next d5, d1 â‰¥ next d1 â†’ next d1 := d1+1); rows3 (parent onto child: row.d1 := child.d1); rows4 push again. Inc gen; until count = 0.
  - 0056C738â€“C7C7: if 328 â‰¥ 3 single scan gen = 3..(countâˆ’2): parent.d1 := child.d1.
  - 0056C7C9â€“C805: one push pass over all rows.
  - 0056C807â€“C8D1: if 328 â‰¥ 2, count = 328âˆ’2+1, gen = 2..: parent.d1 := child.d1 + push pass per level.
  - 0056C8D7â€“C98C: esi := 0; gen := 328 downto 2 (repeat..until gen â‰¤ 1): child.d1 := parent.d1 (esi-guard last-child).
  - 0056C992â€“C9CE: final push pass.
- 0056C9D0â€“CA22: max scan while d2>0: 011AE320 := max(d1), 011AE324 := max(d1) (both same comparison â€” literal).
- Tail: `gvar_011AE320 := gvar_011AE320 - 1` (06CA24); ScrollBar1.LargeChange := PaintBox1.Width âˆ’ 5; ScrollBar2.LargeChange := PaintBox1.Height âˆ’ 5 (Word-component offsets +48/+4C = TPaintBox.Width/Height, +222 = TScrollBar.LargeChange â€” IDR-labelled at sub_0056944D L6062â€“6079); SmallChange := 10 (0xA â€” note sub_0056944D uses 20/0x14); Screen.Cursor := crDefault.
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

### nz2 (0056EB10, listing L11180-12510) - converted, build green (2026-10-25)

- `TForm13.nz2(ACanvas: TCanvas)` (EDX = canvas; decl updated) implemented. Copy/title/wasSchon/DS-ID/d7-d8-count-suffixes/font/names/'#' strips/'M'/'W'/'X' boxes/photo/tail are block-for-block IDENTICAL to nz1 (same Transkriptionshilfe applies). Only these differences:
- Connector loop (while B[row][2] > 0, B.d1 > 0 required):
  - Horizontal marriage line only when d5 < 11AE330 AND d5 > 1 AND (d7 > 0 OR d8 > 0): MoveTo(Round((d0+334/2)*6C), Round(d1*6C)) -> LineTo(same X, Round((d1-61F114/2)*6C)).
  - 0056EF93 'W' drop line: row > 1; ChartBShort(row,193)^ = 'W'; d5 < 11AE330-1 (dec edx!); B[row][9] > 0 (the -174 dword). Then MoveTo(Round((d0+334/2)*6C), Round(6C*(d1+h))) -> LineTo(same X, Round(6C*(d1+h+61F114/2))) with h = 37C*318+318+348.
  - No father/mother elbow segments at all (unlike nz1/vz1).
- Extrema loop: first sets **ACanvas.Pen.Color := 0 once before the loop** (0056F0E8-F0); body starts with **gvar_011AE324 := max(d5)** (plain dword cmp, not the nz1 d1-division); then gvar_011AE31C := max of (d0-340+364) div (61F118+334) (same as nz1); guard d3 > 0.
- Analyzer hint: pushes in Rectangle/RoundRect call sites confirm X2 = (d0+334)-scaled, Y2 = (d1+h)-scaled with W/H = 15 (established recon interpretation kept).
- Next in address order: sam2 (00572D98), vorf_erm2 (00572A78), vr1 (00570D1C), memein (00566220, L2802), zerleg (005675D8), nachf_neu (00564668), PaintBox1Paint (00570C14), FormShow/FormClose (00570294/00570728), buttons.

## vr1 (TForm13.vr1, 00570D1C) - DONE
- "Vorgeneration 1" variant of Vr2 (0056904C): identical skeleton, only metric
  constants differ: `011AE340 := 20` (same), **61F118 := Round(F120*30*scale),
  61F114 := Round(F120*20*scale)** (Vr2: 20/30 swapped); 334/33C same as Vr2.
- Bitmap gate: fScale := 1.0, := 1.13 when PaintBox1.Canvas <> gvar_011AE32C.
- Scroll offsets 2536364/68 loaded from ScrollBar1/2.Position first, then
  zeroed when the drawing canvas differs (order inverted vs Vr2 recon, same
  semantics).
- Printer branch (Printer.Canvas = 11AE32C): fScale := 7.0
  (listing dword 0 / C0000000 / 4001 = mantissa 1.75 * 2^2 = 7.0; the Vr2
  recon wrote 6.0 for the same bytes - likely should also be 7.0 there),
  Font 9pt Arial, 11AE32C.Pen.Width := Round(PaintBox pen width * 7.0).
- Main row loop while 011AE1C4[row][2] > 0: clear 20 slots
  (ChartSlotAnsi(i), ChartAAnsi(102*row+19+i)), ebp14 := [row][3],
  Table17.FindKey, memein([row-1][3]),
  zerleg(011AE334, 011AE318, 011AE32C), ChartAAnsi(102*row+18) := slot 0,
  then 13 Trim-guarded copies ChartAAnsi(102*row+19+i) := Trim(slot i+1),
  i = 0..12.
- Photo scale (61F2BC = 1): 011AE348 := Round((253637C*318+318) shl 2 / 5).
- 10000-row copy: SetChartAFlat(102r+2, gvar_015924E4[row][2]),
  (102r, [row][0]), (102r+1, [row][1]); then sub_00568FD4 (Vr2 called
  sub_00569010 - the identical scan).
- Extrema: 011AE320 := max([row][0]) - 1; scrollbars: LargeChange =
  PaintBox1.Width/Height - 5, SmallChange = 20/20.
- Build: [build] SUCCESS (existing hints only; byteFlag/fScale
  "never used" hints are benign).
- Remaining after vr1 (address order): memein (00566220, listing ~L2802),
  zerleg (005675D8, ~L3800), PaintBox1Paint (00570C14), sam2 (00572D98),
  vorf_erm2 (00572A78), nachf_neu, FormShow/FormClose, buttons.

## memein (TForm13.memein(AValue: Integer), 00566220) - DONE
- Fills Memo1 for the current Table17 person + marriage records of
  Table18 (index 'num') where Epnum = AValue, for Vorgr/Nachgr modes.
- DataModule2 field offsets (Unit2 map): 950 Name, 954 Vornamen,
  944 Nummer (Integer), 95C Religion, 960 Beruf, 9D8 Hausname,
  964/968/96C/970 Gebtag/Gebmonat/Gebjahr/Gebort,
  974/978/97C/980 Tauftag/Taufmonat/Taufjahr/Taufort,
  98C/990/994/998 Sttag/Stmonat/Stjahr/Stort,
  9A0/9A4/9A8/9AC Begtag/Begmonat/Begjahr/Begort;
  Table18 (//140): 4C8 Nummer, 4CC Epnum, 4D0/4D4/4D8/4DC
  Htag/Hmonat/Hjahr/Hort, 4E4/4E8/4EC/4F0 Satag/Samonat/Sajahr/Saort,
  4F8 Verbind.
- Flags: 61F2D4=Religion line, 61F2CC=Beruf line, 61F2D0=Hausname.
- Lines: Name' 'Vornamen + Copy(Religion+', ',1,5); Beruf/Hausname
  line (Hausname appended with ' '); '* '/baptism '~ '/death '+ '/
  burial '# ' date blocks: CatN(tag,'.',monat,'.',jahr) -> sub_00563A0C
  -> ' ' + ort; each block gated by Trim(jahr) or Trim(ort) non-empty;
  death block skips burial (0056678E jmp 005668B7).
- Ancestor sections: if Pos(Vorgr/Nachgr, gvar_0253692C) > 0 and
  AValue > 0: Table18.IndexName:='num', First, FindKey(Table17Nummer);
  '--------'; while not Eof and Table18Nummer = Table17Nummer:
    conn := 'o-o' (6F2D6F03) or 'oo' when Pos('Ehe', Verbind)>0
    [ebp-0A]/6F2D6F03 are ShortString len bytes.
    - Vorgr: conn='oo': SA fields first (Satag/Samonat/Sajahr/Saort),
      else H fields (Htag/Hmonat/Hjahr/Hort), else plain conn;
      conn='o-o': H fields. Prefix = conn + ' '.
    - Nachgr: conn='oo': SA fields with prefix conn+' (S) '
      (PStrNCat maxlen 9); else H fields where Htag='HK' -> plain
      conn+' ', else conn+' (K) '; else plain conn; conn='o-o': plain
      conn+' ' + H fields.
  Then Table18.Next; head-false or EOF exits the section
  (00566E19/0056744D fall into the section exit).
- Build: [build] SUCCESS. Local names: relPrefix/conn: string,
  ebp14/s/line: AnsiString.

## Verwandtschaft1Click (0057249C) â€” implemented
- Event handler: PageControl1.ActivePage := TabSheet2, Form1.aus1.Click, curNum := Table1Nummer.AsInteger.
- Caption s := Name+' '+Vornamen; if Trim(Gebjahr)<>'' then s+=' * '+Gebjahr else if Trim(Taufjahr)<>'' then s+=' ~ '+Taufjahr; s+=' [DS: '+IntToStr(curNum)+']'.
- esi copy of curNum (used for FindKey restores). An ini-style AnsiString [ebp-10] is cleared only - omitted.
- gvar_011AE2C4 = second person number (set elsewhere, input dialog). If 0 -> Exit.
- ebx try/except noise around ebx := gvar_011AE2C4 (handler 'Datensatz-Nummer ungueltig'); recon keeps plain assignment.
- Table1.FindKey([gvar_011AE2C4]); if missing -> ShowMessage('Datensatz-Nummer nicht vorhanden'), FindKey([curNum]), Exit.
- FindKey([curNum]); if second = curNum -> MessageDlg('Die beiden Personen sind identisch.', mtInformation(dl=2), [mbOK](), 0), Exit.
- Otherwise gvar_02536B94 := 0; Screen hourly; Proband1Click(curNum, gvar_011AE2C4) [original pushes Sender as stack arg, ignored]; FindKey([gvar_011AE2C4]).
- Caption s2 for the second person (Gebjahr/Taufjahr year strings appended raw). FindKey([curNum]) restore; Screen default; gvar_0253692C := ''.
- Result message: ShowMessage(s+' und '+CRLF+s2+CRLF+('sind nicht blutsverwandt.' | 'sind blutsverwandt.')) by gvar_02536B94.

## Proband1Click (005729E4) â€” implemented
- Signature Proband1Click(ARoot, AOther: Integer); original passes (eax=Form13, edx=curNum, ecx=target, pushed stack param=Sender, ignored).
- Form1.PageControl1.ActivePage := TabSheet2; Form1.aus1.Click; if Table1.RecordCount >= 2 ([edx+14C] = RecordCount getter, see Unit1 recon 'RecordCount < 2' precedent) then vorf_erm2(ARoot, AOther) else ShowMessage('Keine Daten verfuegbar.'), exit.

## vorf_erm2 (00572A78) â€” implemented
- Params (ARoot=curNum, AOther=target). gvar_011AE2BC := ''.
- Table17.Open + IndexName := ''; Table18.Open + IndexName := 'num'.
- If Table17.FindKey([ARoot]): 11AE2BC := Num2Str(Table17Nummer)+'*'.
- Chunk loop i:=1.. while Length(11AE2BC) >= 7*i: chunk := Copy(11AE2BC, 7*i-6, 6).
  - chunk Trim = '000000' -> sam2(AOther), Exit (strings NOT cleared on this path? note: sam2 clears them on exhaustion/find).
  - n := StrToInt(chunk); if n<=0 or FindKey([n]) fails -> next block.
  - if Table17Vater > 0: 11AE2BC += Num2Str(Vater)+'*'; if Mutter > 0: += Num2Str(Mutter)+'*' (no Pos dedup here).
  - if n = ARoot -> next block; else Table18.FindKey([n]); while (Table18Nummer = ARoot): if Epnum>0 and Pos(Num2Str(Epnum),11AE2BC)=0 -> append Num2Str(Epnum)+'*'; Next; Eof breaks.
    IMPORTANT: the head condition compares Table18Nummer against ARoot (original listing 'cmp eax,[ebp-8]'), and FindKey positions at n which differs from ARoot, so the body normally never runs - kept faithful.
- End: sam2(AOther) [eax slot gets junk (original ebp-4 alias), ignored; edx=ecx param=AOther].

## sam2 (00572D98) â€” implemented
- sam2(AOther: Integer) (AOther in EDX). gvar_011AE2C0 := ''; Table17.Open/IndexName := ''; Table18.Open/'num'.
- If Table17.FindKey([AOther]): tmpS := Num2Str(Table17Nummer)+'*'; if Pos(tmpS, gvar_011AE2BC) > 0 -> gvar_02536B94 := 1, Exit (both strings left intact); else 011AE2C0 := Num2Str+'*'.
- Chunk loop over ~011AE2C0 identical to vorf_erm2, but Vater/Mutter each: numStr := Num2Str(field); if Pos(numStr+'*', 11AE2BC) > 0 -> flag := 1, Exit; else 011AE2C0 += numStr+'*'.
- Termination chunk '000000' or too short: clear BOTH gvar_011AE2BC and gvar_011AE2C0, Exit. Match path never clears.
- Original reads Vater/Mutter fields twice per append (test + numStr source + fresh append); recon collapses to one read per use - same values.

## Next
- Continue in address order: nachf_neu (00564668) is next among the kÐµÑˆ remaining core parts, then PaintBox1Paint (00570C14), FormShow (00570294), FormClose (00570728), Buttons, SpeedButton3Click (00573450), ScrollBar changes (00572484/490).

- Continue in address order: nachf_neu (00564668) next among remaining core parts, then PaintBox1Paint (00570C14), FormShow (00570294), FormClose (00570728), Buttons, SpeedButton3Click (00573450), ScrollBar changes (00572484/490).

## nachf_neu (00564668) - implemented
- nachf_neu(AGen: Integer) (AGen in EDX, stored to gvar_0061F2F0; also sets gvar_0061F110 := 80).
- New AHNGlobals type TNachfNode/TNachfNodes: BFS node grid at gvar_01044CE8, 10000 rows of $94 bytes. dwords +0 Nummer, +4 Row, +8 Col, +$0C Ref1 (father node), +$10 Ref2 (mother node), +$14 Flag1, +$18 Flag2 (spouse marker), +$1C Order, +$28 Flag3; ShortStrings: Raw[0..50] = Name (IDR label 01044D14, max 50 bytes = PStrNCpy cl=$32), Raw[51..101] = Partner (01044D47). IDR label 01044D7C = row 1 start.
- gvar_0061F1F0 is now array[0..50] of AnsiString (slot n at 61F1F0+4n; IDR label 61F1F4 = slot 1). nachf_neu child appends via [edi*4+61F1F4] = slot GenIdx+1; spouse/parse chunks at slot GenIdx. FormClose finalize (0057391F) of 50 slots from 61F1F4 matches.
- Structure: init (zero rows 1..10000, clear slots 1..50, build node 1 = start person from Table1 current record, list slot 1 = Num2Str(start)+Num2Str(0)+Num2Str(0)); root phase (Table10 'num' walk for spouses of StartNum: spouse nodes with Flag2=1, Name = OPPOSITE gender letter of root person, Partner line from Table10 Satag/Samonat/Sajahr/Saort 'ooS ...' / church fields 'ooK ...' / 'and' -> 'o-o '+Hjahr / 'Ehesch' -> 'oo' which is the 3-byte movs copy from 566178 = ShortString 'oo'); children of (root, spouse) and root-without-partner appended to slot 2 as [child][fatherIdx][motherIdx] chunks (18 chars = 3x Num2Str 6 digits, sub_005637C4).
- Generation loop edi = 2..AGen: parse slot edi (Trim-empty -> statistics exit); Count = Round(Length/18); per chunk: node from Table1 (Nummer 534), Ref1/Ref2 from chunk fields 7..12/13..18 (StrToInt ignores spaces -> 0), Flag1=1, Order, Name = UpperCase(Geschlecht 548); P1=Buf; if Ref2 <> LastM (ebp-40) then Flag3 := 1, LastM := Ref2 (per generation); spouse scan like root phase but helper sub_00563A0C formats the date part before ' Saort/Hort'; children of (person, spouse) and person-without-partner appended to slot GenIdx+1 ([child][P1 father][P2 mother] order for male person, [child][P2][P1] for female).
- Statistics: walk nodes while Order > 0: MaxRow = max Row (1044CEC), Pers = count Nummer > 0; ShowMessage(IntToStr(GenIdx-1) + ' Generation(en) / ' + IntToStr(Pers) + ' Personen gefunden'); Table1.EnableControls.
- Deviations (documented): (a) clear loop zeroes whole $94 rows (original clears dwords 0..$28 + the two Len bytes only) - superset, safe; (b) gen-loop spouse 'partner line' CatN: IDR shows 2 pushes for CatN(edx=4) / 6 for edx=5 around sub_00563A0C; recon reconstructs 'ooS ' + Satag + '.' + Samonat + '.' + Sajahr -> helper -> + ' ' + Saort (space literal follows the root-phase CatN 8 pattern); (c) recon collapses repeated field reads.

## Next
- Continue in address order: PaintBox1Paint (00570C14), FormShow (00570294), FormClose (00570728), Buttons, SpeedButton3Click (00573450), ScrollBar changes (00572484/490).

## PaintBox1Paint (00570C14) - implemented
- Dispatcher: if gvar_0253692C = 'Vorgr1' -> vr1 + vz1(PaintBox1.Canvas); 'Vorgr2' -> Vr2 + vz2(...); 'Nachgr1' -> nr1 + nz1(...); 'Nachgr2' -> nr2 + nz2(...). Sequential ifs, not else-chains; nothing clears gvar_0253692C here.

## FormShow (00570294) - correction to earlier implementation
- Zoom constant at 00570306 is 0.63 (Extended mantissa 0xA147AE147AE147AE, exponent 0x3FFE -> mantissa 1.26 * 2^-1). The earlier "0.375" was a misread; fixed to gvar_0061F120 := 0.63. Same constant in SpeedButton3Click.

## ScrollBar1/2Change (00572484/490) - verified
- Both only call PaintBox1.Refresh.

## SpeedButton3Click (00573450) - implemented
- PDF export for the four graph modes. Saves gvar_0061F120, per mode sets gvar_0061F120 := 0.63, WPPDFPrinter1.Filename := 'VGr1/VGr2/NGr1/NGr2.pdf', calls vr1/Vr2/nr1/nr2 and computes a page total:
  * modes 1/3: PageTotal := (gvar_011AE320 + 1) * (gvar_0253637C*gvar_011AE318 + gvar_0061F114 + gvar_011AE318 + gvar_011AE348) + gvar_011AE33C
  * modes 2/4: PageTotal := (same factor) * gvar_0061F2F0 + gvar_011AE33C
- WPPDFPrinter1.SetLicenseLibrary('Ahnw50.dll') (00537710, member); global WPPDFRegisterLicense('Heribert Reitmeier','A144arg6fm45afqf96d4@80B340EF') (00536D90).
- WPPDFPrinter1.Field70 (byte f70, meaning unknown) tested 005736A3; only if True -> set False.
- CanvasReference := wprefScreen (byte f64 := 0, 005736BB), StartDocument ([vmt+40]/005379E0).
- try/finally: nested page builder sub_00573314 called once (005736DC); exit: if DrawFlag then EndDoc ([vmt+48]/00538C98) + FinishDocument ([vmt+54]/00538D00); restore zoom; gvar_011AE32C := PaintBox1.Canvas; PaintBox1.Refresh (all inside finally).
- Nested procs in recon (original used the ebp+8 nested convention):
  * WritePage (0057316C): if DrawFlag then EndDoc; WPPDFPrinter1.StartPage(PageContent, PageTotal, 0, $64, $64) ([vmt+4C], pushed 64/64/0, edx = caller [ebp-0C], ecx = caller [ebp-10]); canvas := printer canvas (005373F4) -> gvar_011AE32C; copies PaintBox1.Canvas.Font.Name; dispatches vz1/vz2/nz1/nz2(canvas); DrawFlag := True.
  * sub_00573314 (called once): page content height (caller [ebp-0C]): 'Vorgr1'/'Nachgr1': (gvar_011AE334 + gvar_0061F118) * gvar_011AE328 + gvar_011AE340; 'Vorgr2': (gvar_011AE320+1) * (gvar_011AE334 + gvar_0061F118) + gvar_011AE340; 'Nachgr2': (gvar_011AE334 + gvar_0061F118) * gvar_011AE320 + gvar_011AE340; then if (not DrawFlag) or overflow condition (005733DA-05 uses caller [ebp-14]+[ebp-18] vs [ebp-1C]) -> WritePage; followed by caller [ebp-14] += [ebp-18] (0057340A).
- Deviations: (a) [ebp-14]/[ebp-18] are never initialized in the original (stale stack); first call draws unconditionally, so recon uses 0-initialized locals (DrawUsedY/DrawStep); (b) compat additions in Compat\WPPDF: WPPDFR1: SetLicenseLibrary (00537710), unit-level WPPDFRegisterLicense (00536D90), StartDocument (vmt+40), FinishDocument (vmt+54), Field70 property (byte +70); WPPDFR2 TWPPDFPrinter: Canvas (GetCanvas 005373F4, TBitmap-backed) and StartPage (vmt+4C). Real PDF rendering not in shell.

## Next
- Remaining Unit13 stubs: SpeedButton1Click (005704A8, print path, stub at recon 2527), remaining TODO at recon 2876 (Button3Click?), recon 4083 stub, FormClose (00570728). Then Finalization (00573848).

## SpeedButton1Click (005704A8) - implemented
- PrintDialog1.Execute; if not: gvar_0253636C := 1.0 (Extended 1.0: d0 0, d1 $80000000, exp $3FFF) and gvar_011AE32C := PaintBox1.Canvas, exit. Else gvar_011AE32C := Printer.Canvas, dispatch vr1/'Vorgr2'->Vr2/'Nachgr1'->nr1/'Nachgr2'->nr2, Printer.BeginDoc, dispatch vz1/vz2/nz1/nz2(Printer.Canvas), Printer.EndDoc in finally.

## Button4Click (00570890) - implemented
- JPG save: scans grid A rows (X = ChartAFlat(102*row), Y = ChartAFlat(102*row+1), used flag = ChartAFlat(102*row+2); offsets are hex: -0x198/-0x194/-0x190) computing maxima gvar_0253635C/02536360; TJPEGImage.Create; gvar_011AE358 := TBitmap.Create; Width := (gvar_011AE334+gvar_0061F118)*MaxX+gvar_011AE33C; Height := (gvar_0253637C*gvar_011AE318+gvar_011AE318+gvar_011AE348+gvar_0061F114)*MaxY+gvar_011AE340; canvas font size := Round(gvar_0061F120*7); gvar_011AE32C := bitmap canvas; dispatch vr/vz/nr/nz; then JPEG: Performance := jpBestSpeed, CompressionQuality := 90, Assign(bitmap); SaveDialog1 (FileName '': DefaultExt 'jpg'; Filter 'Grafik-Dateien (*.jpg)|*.jpg'; Options := 0x2 = [ofOverwritePrompt]); on Execute: fn := Trim(FileName), save guarded by LStrCmp(fn,'.jpg') + jbe -> recon writes `if fn > '.jpg'` (lexicographic guard, exact original flag usage; only bitmap stays alive as gvar, jpeg freed in finally).

## Vorf_erm1 (00563CF8) - COMPLETED
- Signature faked as `Vorf_erm1(AGens, AShift: Integer)` (AGens in EDX -> [ebp-8], AShift in ECX -> [ebp-0C], push ecx/xchg dance decoded).
- Structure: person mirror BFS over TPersonRec rows (recon mapping row r = `AncestorRec(r)` = 61F30C + \*(r-1) = 61F0F8 + \*r).
- Init loop \ = 80000 rows clears: +0, -\/-8 (prev row tail +\/+\; guarded t>1 in recon), +\ byte, +\, +8, +\, +\, +4, +\ byte.
- Setup: Table1.Open, IndexName='', FindKey([StartNum]); Table10.Open, IndexName 'num'; row1 +8 := 1 ([61F314]); row1 num := Table1Nummer ([61F30C]); Screen crHourGlass.
- Main loop: IterLeft = Round(Power(AGens, 2.0)) - 1, skip if <= 0; rows edi = 1..IterLeft.
- Row body non-empty (num > 0): Table1.FindKey([num]); num re-read; Geschlecht -> Trim(UpperCase), PStrNCpy \ -> +\; IDNR -> +\; Religion (54C) -> +\ (all \); +8 := edi; +4 := 1 if Vater>0 or Mutter>0.
- Empty row: +0 := 0, +8 := edi - still goes through partner + slot sections.
- Partner part (Table10.First, only when row gender ShortStr = 'W'): FindKey([num]); loop while Nummer = num: only records with Epnum = prev-row num ([ebx-\], guarded edi>1); Textjoin via sub_00563A0C:
  - Pos('Ehes', Table10Verbind) > 0: Trim(Sajahr) <> '' or Trim(Saort) <> '' (Mosso via earlier Trims; ja -> '+\'): 'ooS ' + Cat(PRDay.'.'PRplace'.'SaPlace) + ' ' + Saort, else 'oo ' + H-date + ' ' + Hort.
  - else Pos('and') > 0: 'o-o ' + H-date + ' ' + Hort.
  - always Break after one Epnum-matching record; Next only on Epnum mismatch.
- After loop: gender 'W' and Trim(Partner) <> '' -> row (edi-1) +\ := PStrNCpy \ of Partner ([ebx-\]; guarded edi>1 in recon - underflow in original targets row0 tail over other gvars). Partner := ''.
- Slot loop j = 0..\ (41x): if edi >= Round(j^2) and j > MaxSlot -> [row+\] := j+1, MaxSlot := j, and flag flip: ParentCount=0 -> TermFlag=1 else ParentCount=0.
- TermFlag=1 -> break to tail (father/mother expansion skipped).
- Slot calc (per row, not terminated): v := Round(MaxSlot^2) * AShift + (edi - Round(MaxSlot^2)) -> [row+\]; [row+\] := edi. (Round(Power(MaxSlot,2)) computed twice in listing, identical.)
- Parents (per row, num > 0): Vater > 0 -> father-dword := Vater at AncestorRec(2*edi) (+0 = 61F0F8+\*edi), Inc(ParentCount); Mutter similarly at AncestorRec(2*edi+1).
- Tail: MaxSlot+1 < GenLimit -> GenLimit := MaxSlot ([ebp-8] overwritten); Table1.FindKey([StartNum]); cursor crDefault; GenLimit > 3 -> Button1.Visible := True.
- Helpers added to AHNGlobals: `AncestorNum(Row)`, `SetAncestorNum(Row, Value)`, `AncestorRec(Row): PByte` (all \ stride off gvar_0061F30C, row 1-based).
- Documented deviations: init-loop prev-row tail clear guarded (t>1); edi=1 prev-partner/prev num reads skipped; intermediate GetText/UpperCase/Trim chains collapsed; original exception frame (LStrArrayClr 30 + LStrClr) replaced by automatic local cleanup.
- Build: SUCCESS.

### Batch: Vorf_erm (00567A30) + Vorf_erm1 Power-idiom correction
- Corrected Vorf_erm1 (00563CF8) Power decoding: the pushed 2.0 constant is the
  BASE, so all three idiom sites are Power(2.0, x) = 2^x (not x^2). Affects
  iteration count (Power(2.0, GenLimit) - 1), slot-loop bound (edi >= Power(2.0, j))
  and slot arithmetic (Round(Power(2.0, MaxSlot))). Matches binary-BFS tree sizes
  1/2/4/8... and the boundary test Power(2.0, k) - 1 = edi.
- Reconstructed Vorf_erm (00567A30) into Unit13.pas: chart A/B/C grid clearing
  loop (t=1..$2710, ten A/B stores + three C stores per $198-stride row), setup
  (gvar_0061F2F0 := StrToInt(Form12.SpinEdit1.Text), gvar_011AE34C :=
  StrToInt(Form12.SpinEdit2.Text), Table17 with no index, eA/eB tbyte Extended,
  base code string ebp24 via sub_005637C4), main BFS loop while
  edi < Power(2.0, gvar_0061F2F0): 6-char code decode per row, FindKey, father/
  mother codes appended to ebp24, flat slots +3/+7/+8 in grid A and C-mirror
  dword terms (102*edi-104/-103/-102), Vorgr1/Vorgr2 level numbering, Extended
  accumulators eA/eB, picture path check (gvar_02536B9C\bilder\bNa.jpg into
  ChartAShort(edi,$142)), PExtended slot +$38 = edi mod 2^(g-1) + gvar_011AE34C *
  2^(g-1), gender word $4D01/'M' + $5701/'W' at +$C1, boundary loop ebxv
  1..$14 (Power(2.0, ebxv) - 1 = edi -> eB := eA, generation increment), exit
  when eB = 0; tail: ShowMessage ('Generationen/Personen gefunden', eB>0
  distinguishes truncation), gvar_011AE328 := gvar_011AE330 - 1 or gvar_011AE330,
  Vorgr1/Vorgr2 post-loops shifting flat +1 by gvar_011AE330 - gvar_011AE328
  or + gvar_011AE330 - gvar_0061F2F0 while flat +2 / +5 guards, ending with
  gvar_011AE32C := PaintBox1.Canvas and PaintBox1.Refresh.
- Deviations documented: exception-frame LStrArrayClr dropped (compiler-managed
  AnsiStrings), SSR-start/ssr-clr string work collapsed, FindKey structure args
  inlined, PStrNCpy truncation via SetLength/Copy semantics, tbyte locals as
  Extended assignments.
- Converter fixes: ChartAFlat() assignments replaced with SetChartAFlat()
  helper calls in Vorf_erm.
Remaining Unit13 work: FormClose (00570728) verification, Finalization
  (00573848, listing L15904+), SpeedButton12Click nil-check removal.

### Batch: SpeedButton12Click fix, FormClose verified, Finalization (00573848)
- SpeedButton12Click (00570694): removed the extra nil-check on
  gvar_011AE32C; the listing assigns Font.Name directly.
- FormClose (00570728): verified against listing L12803+ - recon already
  matches (Form12.Close; form 13 hidden via gvar_0061F10C/Form13).
- Finalization (00573848, listing L15904+): decoded and documented at the
  unit end of Unit13.pas as a doc-stamp block. Listing mechanics:
  refcount guard [253638C] (inc ; jne skip), @FinalizeArray over the
  five 10000-element chart grids (0213E95C, 01D5A7DC, 0197665C, 015924DC,
  011AE35C; element stripper 'vor' @5637A0), @FinalizeArray of 20
  AnsiString slots at 011AE2C8, LStrClr on 011AE2C0/011AE2BC/0061F2EC/
  F2E8/F2E4/F2E0, and two 50-element AnsiString arrays at 0061F1F4 and
  0061F12C. Recon deviation: the grids are static records without
  managed fields, so the run block is empty; kept as
  `initialization / finalization / end.` (this DCC17 requires a
  non-empty-list syntax chain - bare `finalization end.` fails with
  E2029, a preceding empty `initialization` is accepted).
- Note: grids 0213E95C / 01D5A7DC (Nachfahren, $214 stride) appear in
  the finalization set; they are owned by the Unit1/Unit recon target,
  documented here for cross-reference.

### Batch: Unit3 gedein_5 helpers (sub_005BE4B8 / sub_005BEF5C)
- Decoded and implemented `sub_005BE4B8` ("2 DATE" handler of the GEDCOM import, Projects_AhnenWin\Unit3.pas L64989-65635): per event tag (gvar_02536858 = BIRT/BAPT/DEAT/BURI/EMIG) parses the pre-comma part via sub_00577934, writes the date triplet to Table1 Gebtag/Gebmonat/Gebjahr (554/558/55C), Tauftag/Taufmonat/Taufjahr (564/568/56C), Sttag/Stmonat/Stjahr (57C/580/584) or Begtag/Begmonat/Begjahr (590/594/598), and appends the post-comma part to comment accumulator gvar_0253684C with prefixes "Geburt: "/"Taufe: "/"Tod: "/"Bestatt.: "/"Auswanderung am ". Lines without comma only parse the date; EMIG non-comma writes "Auswanderung am d.m.y" via sub_005772E4; other tags only parse.
- Decoded and implemented `sub_005BEF5C` ("2 PLAC" handler, Projects_AhnenWin\Unit3.pas L65635-66413): mirrors the place text via TForm3.Ortdreh unless tag = RESI, splits up to three comma parts (e1/e2/e3) when gvar_0253685C is empty (kept as guard, RESI skips the split), updates/creates Table13 (FindKey ort -> Edit Lkr/Bland/Land, else Append Ort + Lkr/Bland/Land, offsets A44/A4C/A58/A64) and finally assigns Table1Gebort/Taufort/Stort/Begort/Lebensort; EMIG appends "Auswanderung nach <ort>" via sub_005772E4.
- Component mapping fixed: Table1 field offsets 558 = Table1Gebmonat, 590/594/598 = Table1Begtag/Begmonat/Begjahr (Unit2.pas); Table13 fields A44=Ort, A4C=Land, A58=Bland, A64=Lkr; Table1Lebensort = 578.
- `Form3.sour` (= sub_005BF434 body, "2 SOUR @" Repso2 resolver) was found already reconstructed in Unit3.pas.
- Verified: build.cmd -> [build] SUCCESS. Array-slicing PowerShell quirks avoided by direct Read tool usage.
- Next: main body of TForm3.gedein_5 (stub, current recon L1807+), which calls sub_005BC604 (huge, L62911-71288 of the listing - approx 8300 lines, separate batch) - register declaration stub with 15 params (3 register + 12 stack) first.

### Batch: Unit3 gedein_5 main body (005BFB94) - COMPLETED, build green (2026-10-29)
- Fully converted `TForm3.gedein_5` in Units\Unit3.pas (listing extract C:\Users\Mir\AppData\Local\Temp\opencode\gedein5.txt, 5432 lines, 005BFB94-005C541D), transcribed in chunks C1..C8: prolog (fsc temp table Nr/Fnr/V/M/K, open dialog), header loop, Phase I (@INDI/0 @F counting, 0 @S source import, 0 @P places, 1/2 NOTE), Phase II (persons: SEX/RUFN/OCCU/RELI/IDNO, event/date/place taboo ladder, 1 SOUR @S replication into Table1Quelle + Table38, ADDR/ADR1..ADR5/CITY/POST, EMAIL/PHON/URL/WWW), Phase III (fsc Auswertung: v/m pairs into Table5Nummer/Table5Epnum, k-splits into Table1Vater/Mutter via Table1.FindKey, family loop with 1 HUSB/WIFE/CHIL via Form1.Repso2 'alt_' index, MARR/DIV marshalling into 16 locals m1dat..sav2, MARRIED/_STAT mapping).
- Component/field verifications: Table1 offsets 5CC=Adr1, 5D0=Adr2, 5D4=PLZ, 5D8=Ort, 5DC=Adrzus, 5F0=Tel, 5F4=Ema, 5F8=Ur, 5FC=Quelle, 600=Rufname, 5E0=Indj; [ebx+80]=Table5 (fsc Auswertung target, recon-name Table11 discarded); Form1 offsets 400=Label18, 404=Label19, 8C0=Repso2, 8C8=Repso2nr.
- `sub_005BC604` remains a stub (declare 4 register ints + 12 stack AnsiStrings, exact register/stack push order 30,68,6C,50,54,58,5C,60,64,70,74,78 = 16 args, listing L62911ff; body still to be decoded as a separate batch).
- Loop-tail convention: `LPhase2Tail` ends each Phase II chunk with ReadLn + goto LPhase2; `005C27F8 jmp 005C47E5` was recon-coded as `goto LPhase2` - final-stage candidate for verification against C8 epilogue.
- Verified: build.cmd -> [build] SUCCESS (28063 lines, only known unused-local hints).

### Batch: Unit3 sub_005BC604 (Ehe/Familie-Schreiber) - COMPLETED, build green (2026-10-29)
- Fully converted `sub_005BC604` in Units\Unit3.pas (listing extract C:\Users\Mir\AppData\Local\Temp\opencode\sub_B604.txt, L1-1094 relevant; method ends 005BD6CA `ret 30`), transcribed in 3 chunks: C1 prolog (Table5.FindKey([AHusn]) -> Append Nummer[410]/Epnum[414]), C2 edit path pass 1 (Verbind[440] from AMarried; date triplets Htag/Hmonat/Hjahr 418-420, Satag 42C-434, Schtag 444-44C via sub_00577934 comma-split Copy(8,Pos-8)/Copy(8,Length); raw texts Hort 424/Saort 438/Schort 450; witnesses Copy(9) -> Trauz 428/Satrauz 43C; three '2 SOUR @' blocks -> Hqu 454/Saqu 458/Schqu 45C via Form1.Repso2 'ih'/Repso2inh2 dedup with '; ' chain; Post), pass-2 entry FindKey([AWifn]) + Append mirror, C3 mirrored edit path (no source-field writes on pass 2, faithful to listing) + Post @005BD656.
- Field names verified in Unit2.pas: Table5Nummer 410, Epnum 414, Htag/Hmonat/Hjahr 418/41C/420, Hort 424, Trauz 428, Satag/Samonat/Sajahr 42C-434, Saort 438, Satrauz 43C, Verbind 440, Schtag/Schmonat/Schjahr 444-44C, Schort 450, Hqu 454, Saqu 458, Schqu 45C (Table5Schjahr restored from earlier 'Sajahr' typo).
- Param slots: +34 AMarried (int), +30..+8 = 11 AnsiStrings (ADatD/AOrtD/ADat1/AOrt1/AWit1/ADat2/AOrt2/AWit2/AQm1/AQm2/AQd), LStrAddRef list consistent, ret 30.
- Next/Eof tails 005BD063/005BD65E documented unreachable after FindKey/Append positioning (Unit3 comments).
- Verified: build.cmd -> [build] SUCCESS (28292 lines).

### Batch: Unit3 gedein_5 C4-Verifikation (Kontrollfluss) - COMPLETED, build green (2026-10-29)
- 005C27F8 `jmp 005C47E5` verified: Phase-I exit RE-ENTERS the Phase-II read loop (EOF check entry at 005C47E5); recon `exit;` was wrong, replaced with `goto LPhase2;` (~L2563).
- Phase2Tail (005C4786-005C47E5) verified vs listing L71026-71054: ReadLn -> '0 @F'-check (005C47A2 jg 005C47FC = Phase3 entry) -> EOF-check -> zsa(zeile,ptmp) + zeile upload -> EOF-check back edge. Recon tail previously missed the '0 @F' long-jump AND the zsa; without them Phase II silently dropped entire family records.
- Phase3 loop tail (005C520E-005C52CC) verified: correct order is ReadLn first, then zsa, then flush-condition (Pos('0 @')+Pos('@F')>0 && famIdx/husn/wifn>0 -> sub_005BC604), then loop condition (no Eof-check before ReadLn). Rewritten.
- New W1036 uninit warnings (husn/wifn/relN/nummer) accepted = compiler flow-blindness from goto/labeled-loop structure.
- Verified: build.cmd -> [build] SUCCESS (28291 lines).

### Batch: Unit3 gedein_5 C4 alt84/alt88 - COMPLETED, build green (2026-10-29)
- alt88 ([ebp-88]) only ever cleared at 005C282B -> effectively constant ''; recon `alt88 := ''` matches (aka/immigrant messages emit leading space like original).
- Missing gate fixed: ASM 005C2F63-2F72 `gvar_02536858='NAME'` (jne 005C352D) guards the whole alt84/'2 TYPE'/type-name ladder (005C2F78-005C350D); recon ran it ungated -> wrapped in `if gvar_02536858 = 'NAME' then begin ... end;`. The '2 NOTE' block follows afterwards with its own guard.
- alt84 slot mapping re-verified (listing L69565-69614): Copy(zeile,8,1)='/' check 005C2F91; alt84 := Trim(Copy(zeile, Pos+1, 40)) then Copy(alt84,1,Length-1) in place; '1 NAME'-2nd-line and '2 TYPE' variants identical.
- Verified: build.cmd -> [build] SUCCESS (28294 lines).

### Batch: Unit3 sub_00582C24 (Datum-Export-Formatter) - COMPLETED, build green (2026-10-29)
- Converted as `function sub_00582C24(A, B, C: AnsiString): AnsiString;` (A=Tag, B=Monatsnr, C=Jahr; Result via hidden [ebp+8], `ret 4`) in Units\Unit3.pas after sub_005BEF5C.
- Semantics (extract C:\Users\Mir\AppData\Local\Temp\opencode\sub_582c24.txt, 00582C24-00582DFF): `case StrToInt(B)` -> JAN..DEC (jmp table 00582C97); with month: Format('%2s',[A])+' '+mon+' '+Format('%4s',[C]) = 'DD MON YYYY'; without: DD.MM.YYYY dot-triplet. Prefix marker 'um*UM*ca*CA*VO*vo*na*NA*ER*er' (Pos in A) suppresses standard Result; uppercase ladder UM/CA->'ABT ', VO->'BEF ', NA->'AFT ', ER->'CAL ', each 'PREFIX '+mon+' '+C, only when StrToInt(B)>0; empty A -> 'MON YYYY', empty A+B -> C. try/finally pairs collapse to CatN3 fallbacks (normal-flow only).
- 21 call sites (005A66xx..005B9D7A) all in still-open methods, mainly TForm3.gedausv (005B5224, TODO stub).
- Verified: build.cmd -> [build] SUCCESS (28382 lines).

### Batch: Unit3 illki (Lebenslinien-Katalogeintrag) - COMPLETED, build green (2026-10-30)
- Converted `TForm3.illki(ALine: AnsiString; ANr: Integer; var AErgebnis: AnsiString)` (Units\Unit3.pas; extract C:\Users\Mir\AppData\Local\Temp\opencode\illki.txt, 00584350-00584E21, `ret 4`; edx=ALine LStrAddRef, ecx=ANr, [ebp+8]=var-result via mov ebx). Interface + implementation declarations updated (was parameterless TODO stub).
- Body: AErgebnis:=''; empty-Trim exit; Table1.IndexName:='' + First; num=Round(Length/7); loop over 7-char packets -> k=StrToInt(Copy(ALine,(i-1)*7+1,6)) -> Table1.FindKey([k]); AErgebnis += Name+' '+Vornamen; name-list adds to gvar_02536440 in three variants gated by gvar_02536414/gvar_02536418 (with ' * '+Gebjahr / plain), suffix sub_00576F54(i) with empty separator (CatN7/5/3 push pairs verified).
- lfbh2 block: gvar_02536454 := Form1.lfbh2.IndexName saved, bookmark vtbl+150 stubbed as `bmk := -1`, IndexName 'Pro' + First; sub_00576EB0(Table1Nummer.AsInteger, u) -> FindKey([StrToInt(u)]) -> AErgebnis += ' [' + IntToStr(lfbh2Nm.AsInteger) + ']', lfbFlag:=1; IndexName restored; vtbl+1A0 stub comment; lfbFlag<>0 -> Continue (skips following blocks, jmp 00584DDA loop tail, faithful).
- Remaining blocks in order: gvar_02536404 Religion ', '; gvar_025363F0 Beruf ', ' + Hausname ' ' (Table1Hausname 5C8, verified Unit2.pas); birth/baptism(death-replacement) triplets via sub_00576FF8 (procedure (ALine; var) verified) with ' * '/' ~ '/' + ' prefixes; gvar_02536410=1 -> oabk(place)->gvar_02536664 else AErgebnis += ' '+place; gvar_02536444.Add(place+sub_00576F54(ANr)) after each event block; Taufpat ' (TP: ...)' gated gvar_02536400.
- Verified: build.cmd -unit 3 -> SUCCESS (28532 lines; known hints H2164 's' in oabk, H2077 bmk per stub convention).

### Batch: Unit17 nam2 (Namenszeile Familienblatt) - COMPLETED, build green (2026-10-30)
- Converted `TForm17.nam2(AIn: AnsiString)` (Units\Unit17.pas; Projects_AhnenWin\Unit17.pas L52-277, 0053CC38-0053CFCF, plain `ret`): builds sheet name line `s` from caller text AIn + current Table3 person, writes both to Table14 (Append, Zeile[1E8]=s, Nm2[1F0]=AIn, Post) when s <> ''.
- Three name variants: CheckBox9 checked -> ' (DS '+IntToStr(Table3Nummer)+')' suffix; else `Pos('                oo ', AIn)` > 0 (16 spaces + 'oo ') -> AIn+#13#10+20 spaces+name; else plain concat - all as ucase(Table3Name [610]) + ' ' + Table3Vornamen [614] via Form1.ucase(x, var).
- Toggle blocks in listing order: CheckBox1 ' (ID: ' + Table3IDNR [690] + ')'; CheckBox11 ', ' + Beruf [620]; CheckBox13 ', ' + Hausname [698]; CheckBox7 ', ' + Religion [61C], each only when the field is nonempty.
- AIn edge cases (listing-faithful, commented in recon): Copy(AIn,1,5)='     ' -> AIn keeps only leading whitespace (Copy 1..Length-TrimLeftLen); ELSE when Trim(AIn) nonempty -> AIn cleared (LStrClr [ebp-4] at 0053CF57 exactly as binary does).
- Fields verified in Unit2.pas: Table3 604=Nummer/610=Name/614=Vornamen/61C=Religion/620=Beruf/690=IDNR/698=Hausname; Table14 (E0) 1E8=Zeile, 1F0=Nm2.
- Verified: build.cmd -unit 17 -> SUCCESS (28121 lines, no new Unit17 hints).

### Batch: Unit17 fambeltern (Eltern-Abschnitt Familienblatt) + sub_0053D06C - COMPLETED, build green (2026-10-30)
- Converted `TForm17.fambeltern(AIn: AnsiString)` (Units\Unit17.pas; Projects_AhnenWin\Unit17.pas L3070-3577, 0053FD18-00540491, plain `ret`): writes the parents' section of the Familienblatt into Table14.
- Flow: if Vater[538]>0 or Mutter[53C]>0 -> empty Table14.Append+Post + Inc(gvar_0061EFCC); Vater>0 -> Table3.FindKey + nam2(AIn+'Vater : ') + gebst(AIn+11 spaces) + gvar_0061EFCC+3 (order verbatim per LStrCat3 edx+ecx convention: AIn first, label second); Table10.IndexName='num' + FindKey([Table1Vater]) then while not Eof: Epnum[3B8]=Mutter -> Table14.Append + spouse line block; Table10.Next each round; Mutter>0 -> nam2/gebst mirror + gvar_0061EFCC+3.
- Spouse-line ladder inside Epnum=Mutter: Pos('Ehes', Verbind[3E4])>0 -> (a) Saort[3DC]/Sajahr[3D8] nonempty -> Table13.FindKey([Saort]) + only when Sajahr<>'' line = AIn + '           oo (S) ' + sub_0053D06C(Satag[3D0]+'.'+Samonat[3D4]+'.'+Sajahr) + TrimRight(' '+Saort); (b) else Hort[3C8]/Hjahr[3C4] nonempty -> Table13.FindKey([Hort]) + only when Hjahr<>'' line with Htag[3BC]='HK' comparison -> '           oo ' plain else '           oo (K) ' + norm(date triplet) + TrimRight(' '+Hort); (c) else line = AIn+'            oo' (12 spaces). Pos('Ehes')<=0 (o-o path): Table13.FindKey([Hort]) then only when Trim(Verbind)<>'' line = AIn + '           (o-o ' + norm(H-tag triplet) + TrimRight(' '+Hort) + ')'. Table14.Post per matching row, faithfully even when nothing written.
- New helper `procedure sub_0053D06C(ALine; var AErgebnis)` (Units\Unit17.pas, twin of sub_00576FF8/Unit3): date normalizer 0053D06C-0053D2F9 - '..'->'', 'HK'->'HK '+Copy(4,7), 'vo.r'->Copy(1,2)+Copy(4,1)+' '+RightStr(4), 'na.ch'->Copy(1,2)+Copy(4,2)+' '+RightStr(4), leading '.'/blank strip loop Copy(2,9), s[1]>'9' -> dot-strip + Insert(' ') before first char < ':'.
- Signature correction: recon `procedure gebst` had been parameterless -> corrected to `procedure gebst(AIn: AnsiString)` (interface + stub, listing 0053E878 = `gebst(?:AnsiString)`); gebstvn (0053D358, 2-param) still TODO stub.
- AHNGlobals fix: gvar_0061EFCC was AnsiString -> Integer (binary does `inc`/`add 3` - Familienblatt-Zeilenzaehler).
- Uses extended by StrUtils (RightStr).
- Verified: build.cmd -unit 17 -> SUCCESS (28735 lines, no Unit17 hints).

### Batch: Unit3 gedeausv (005B5224, GEDCOM-Export 5.5.1) Chunk C1 - COMPLETED, build green (2026-10-30)
- Whole-method extract created: C:\Users\Mir\AppData\Local\Temp\opencode\gedausv.txt (5889 listing lines, 005B5224-005BBCC5; Projects_AhnenWin\Unit3.pas L57025-62908). Parameterless TForm3 method, esi=Self, edi=gvar_0253665C.
- Chunk C1 transcribed (005B5224-005B5E30): krg := Table1Nummer; Form26.Hide + ModalResult := 2 (vtbl+24C); source-monster string gvar_0253665C := '' then 'qu'-Indexlauf - listing-truth: SetIndexName('qu') on Table29 [248], but First/Next/Eof + Table24Nummer [22C] on Table24 [1D0] (transcribed verbatim, noted as suspicious). File setup: SaveDialog1[3FC] (GetFileName -> System.Assign to gvar_02536458 Text var; explicit System.Assign because bare Assign resolves to TForm3.Assign), Title='ged' (+60), Filter='Gedcom-Dateien (*.ged)|*.ged' (+74), FilterIndex:=2 (+5C), Rewrite. 0 HEAD block: Form27.RadioButton2 -> BOM #$EF#$BB#$BF + '0 HEAD', else plain. CHAR-Varianten: RadioButton1 -> gvar_02536654:=1 + '1 CHAR ANSI'; else RadioButton2 -> gvar_02536650:=1 + '1 CHAR UTF-8'; else RadioButton3 -> gvar_02536650:=1 + '1 CHAR Unicode' (654/650/658 := 0 before). Then '1 SOUR AHNENWIN'/'2 VERS 5.1'/'1 DEST OTHER'; '1 DATE ' + sub_00582C24(Copy(DateToStr 1,2), Copy 4,2, Copy 7,4) [Tag/MonatsNr/Jahr]; '1 FILE ' (+ AnsiToUtf8 in 650-branch) of ExtractFileName(SaveDialog1.FileName); '1 SUBM @S0@'/'1 GEDC'/'2 VERS 5.5.1'/'2 FORM LINEAGE-LINKED'/'1 PLAC'/'2 FORM place, county, state, country'; '1 LANG German' in BOTH charset branches; @S0@ SUBM blocks:
  - 650-branch (UTF-8): Edit1 nonempty -> '0 @S0@ SUBM'(AnsiToUtf8), '1 ADDR', '2 ADR1 '..'1 POST '(Edit3), '1 CITY '(Edit5[340]), '1 PHON '(Edit4[310]), '1 EMAIL '(Edit6[348]) all via AnsiToUtf8; Edit1 empty -> only '0 @S0@ SUBM'+'1 NAME UNKNOWN'.
  - ANSI branch: same ladder WITHOUT conversions; transcribed through Edit3/'1 POST ' (Listing L600).
- Form27 (TOKBottomDlg1/GEDCOM output dialog) field map verified: 304=Edit1, 308=Edit2, 30C=Edit3, 310=Edit4, 340=Edit5, 348=Edit6, 328=RadioButton1, 32C=RadioButton2, 334=RadioButton3 (Units\Unit27.pas); Form26 = gvar_0061EFFC (Units\Unit26.pas).
- Unit3 uses extended: + Unit26, Unit27.
- Junction 005B5E30 (followed by the family/person export loop, listing L600+ not yet transcribed) left as TODO C2; uninit-var W1036 warnings of gedein_5 unchanged; new hint H2077 krg (written, read only by later chunks) accepted.
- Verified: build.cmd -unit 3 -> SUCCESS (28865 lines).

### Batch: Unit3 gedeausv Chunk C2 (005B5E30-005B63EF) - COMPLETED, build green (2026-10-30)
- Completes the ANSI @S0@ SUBM ladder exactly like the UTF-8 one but WITHOUT AnsiToUtf8: Edit5 '1 CITY ', Edit4 '1 PHON ', Edit6 '1 EMAIL '; Edit1 empty -> '0 @S0@ SUBM' + '1 NAME UNKNOWN' (005B5DFE branch was the left-leg target of the C1 Edit1-check).
- Junction 005B5E30: Form27.Visible := False; Form1.Label18 [400] Visible/'0 %'/Refresh; Form1.Label19 [404] Visible/'Gedcom schreiben'/Refresh.
- gvar_02536644 := Table24.RecordCount (vtbl+14C); Table1.IndexName := ''; Table24.IndexName := ''; Table24.First; Table29.Open; Table29.IndexName := 'qu'; personNr ([ebp-0C]) := 1; st2 ([ebp-10]) := ''; call Form3.gedausxv (005B5F25 prefix method); Table24.IndexName := ''; Table24.First.
- Person loop (listing loop-head jmp 005B8B7D = Eof condition; body 005B5F4B ff) recon'd as `while not DataModule2.Table24.Eof do`: progress Round(personNr/gvar_02536644*100) -> Label18 '%'+Refresh; {edi:=0} scratch; WriteLn '0 @I'+IntToStr+@ INDI (CatN3 order '0 @I',Nr,'@ INDI'); uNr ([ebp-168] Integer) := Table24Nummer.AsInteger; Table1.FindKey([uNr]); st4 := Trim(Table1Vornamen [+544]); Pos('!')->LStrDelete 1 char at pos; NAME variants via CatN4/5: 650=1 -> AnsiToUtf8(st4 + ' /' + Trim(Name [+540]) + '/'), else '1 NAME ' + st4 + ' /' + Trim(Name) + '/'; Namex [+5BC] nonempty -> '1 NAME /'+(Utf8?)Namex+'/' + '2 TYPE variant'; Rufname [+600] -> '2 _RUFNAME '; Hausname [+5C8] -> '1 NAME /'+(Utf8?)Hausname+'/' + '2 TYPE estate'.
- New vars: personNr, proz, uNr: Integer. u ([ebp-168]) renamed uNr (TIntegerField.AsInteger = Integer, not AnsiString).
- TODO C3: from 005B63EF (Geschlecht [+548] -> UpperCase -> 'W'/'M'/'1 SEX' blocks, then further person sub-blocks, Extrakt gedeausv.txt L1000+).
- Verified: build.cmd -unit 3 -> SUCCESS (28937 lines).

### Batch: Unit3 gedeausv Chunk C3 (005B63EF-005B8878) - COMPLETED, build green (2026-10-30)
- Person-Loop-Fortsetzung transkribiert (Units\Unit3.pas, Extrakt gedeausv.txt L1000-3265): SEX (UpperCase-Vergleiche W/F M/X, leer -> '1 SEX U', nur ein乗 Vergleich); OCCU/RELI/IDNO; Quelleg-Quelref-Blocks;
  BIRTblock: check Trim(Gebjahr [55C]) + Gebort [560], '1 BIRT'; '2 DATE ' via sub_00582C24(Gebtag 554, Gebmonat 558, Gebjahr 55C); PLAC-Block: FindKey(Table13 [0CC]) ohne Result-Test (positions Table13-Felder) + CatN7 chain 'Ort,Lkr,Bland,Land' (Gebort + Table13Lkr [A64] + Table13Bland [A58] + Table13Land [A4C]); 650 -> AnsiToUtf8; SECOND FindKey mit Result-Test -> '3 _LOC @P'+IntToStr(bmk)+'@' + sub_00576EB0 + Pos(u, st1[ebp-14] PlacRef-Accu) -> st1 += u+'*' DEDUP; Table38.FindKey([Quelleg [5A0]]) -> '2 SOUR @S'+IntToStr(bmk)+'@' + st3[ebp-28] SourRef-Accu += u+'*'.
- Identische Blockstruktur fuer CHR (56C/570 Check; DATE args TAUFTAG 564/Monat 568/Jahr 56C; Quelle [5A4]), DEAT (584/588; Sttag 57C/Monat 580/Jahr 584; Quelleb [5A8]), BURI (598/59C; Begtag 590/Monat 594/Jahr 598; Quelle [5AC]); '2 _GODP ' via TAUFPAT [574] (Utf8-Variante), '2 CAUS ' via TODESBEZEICHUNG-QUELLE [58C].
- Anmerkung: Feld-Checks sind jeweils auf dem JAHR-Field (55C/56C/584/598), nicht auf dem Tag - im Original so.
- RESI-Block: Check Lebensort [578] + Adr1 [5CC] -> '1 RESI'; '2 PLAC ' (Lebensort, Utf8-variante); Adr1 -> '2 ADDR '-Kopfzeile OHNE Inhalt + '3 ADR1 '; Adr2 [5D0] '3 ADR2 '; Adrzus [5DC] '3 ADR3 '; PLZ [5D4] '3 POST '; Ort [5D8] '3 CITY '; Tel [5F0] '2 PHON '; Ema [5F4] '2 EMAIL '; Ur [5F8] '2 WWW ' - alle mit 650/AnsiToUtf8-Unterscheidung.
- NOTES-Block: Namex [5BC] -> '1 NOTE Schrw.: '(edi=0, dann edi:=1) sonst '2 CONT Schrw.: '; Lebt [5B4]='j' -> '1 NOTE lebt: '/''2 CONT lebt: '' sonst '2 CONT lebt: ', edi := 1 in BEIDEN Zweigen (Jump-Effekt 005B8539); Kommentar TMemoField [5B0] skip if Form27.CheckBox1 [318] Checked (vtbl+0C4); sonst Memo1 [40C] Clear (vtbl+0DC recon als Clear), komFeld := Table1.FieldByName('kommentar'), Memo1.Lines.Assign(komFeld) ([Memo1+220]=Lines vtbl+8 - recon Annahme), Count-Test (vtbl+14), erste Zeile '1 NOTE '/'2 CONT ' (edi-getrieben), while cmzCount < Lines.Count -> '2 CONT '-Zeilen (Get(esi) vtbl+0C, inc esi 005B8857).
- Neue Locals in gedeausv: edi (NOTES-Merker, init 0 im Loop-Kopf 005B5FA8), bmk (Recon-Stub -1 fuer alle vtbl+150 GetBookmark-Aufrufe), cmzCount (Memo-Lines-Loop-Index), komFeld: TField.
- TODO C4: ab 005B8878 (FAMS/FAMC-Loops gvar_02536448/44C TStringList, RightStr(6)/StrToInt, sub_00576EB0-Compare, '@F'-Blocks, danach loop-tail personNr+Table1.FindKey([krg])+Table24.Next 'lfn'-Index, FAM-Loop ab 005B8BA4).
- Verified: build.cmd -unit 3 -> SUCCESS (29323 lines).
