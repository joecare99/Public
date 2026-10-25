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
