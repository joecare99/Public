# Remaining work plan (Restplan) — AHNENWIN 5.1 recon

State: **572 / 659** methods reconstructed (87 open). `tools/crossref.ps1` is
now self-consistent (a method's bullet and the summary line for its unit are
counted in the same pass, so they can no longer disagree). Build is green.

The goal of this document is to order the remaining 87 methods and to make the
*one* structural blocker explicit, because it gates the largest block (Unit13).

---

## Complexity classes

- **A — quick**: self-contained, few or no shared structures, short body. Do these first.
- **B — solid**: one clear job, needs the table (DataModule2) or a small known
  layout, moderate length.
- **C — dependent**: correct reconstruction needs a sibling method *or* a shared
  record layout that is not yet pinned down.
- **D — large / deferred**: long, multi-branch, or I/O pipelines where the risk
  of mis-reconstruction is high. Convert last, "Häppchenweise".

Sizes below are the number of *disassembly* lines between the `{*procedure …`
header and its closing `end;*}` (where measured); otherwise marked `?`.

---

## Per-unit inventory (open)

| Unit | Open | Notes |
|------|-----:|-------|
| Unit1  | 14 | data I/O, Excel, HTML family-sheet, list ops, two `sub_…` |
| Unit3  | 18 | GEDCOM/OS/ADS import & export (the biggest I/O block) |
| Unit11 | 2  | graphics: `Fgr`, `zeichnen` |
| Unit13 | 34 | the whole ancestor/descendant graph + painting (core blocker) |
| Unit16 | 2  | `Speichernunter1Click`, `SpeedButton6Click` |
| Unit17 | 6  | small name/date helpers (best first targets) |
| Unit18 | 1  | `suchen` |
| Unit19 | 5  | name/date list builders |
| Unit20 | 1  | one button handler |
| Unit22 | 1  | one control handler |
| Unit24 | 1  | `listanz` |
| Unit26 | 1  | one `sub_…` |
| Unit33 | 1  | one button handler |

---

## The central blocker (gates Unit13 and parts of Unit1/Unit3)

The graph is stored in flat global arrays (see `AHNGlobals.pas`):

- `gvar_011AE35C` — one row per person / ancestor slot;
- `gvar_019764D8`, `gvar_01976670` — per-row pointer/offset arrays.

In the disassembly the stride between rows alternates between **198 bytes** (or
`*8 -194`, i.e. a 198-byte record) and **33·8 = 264 bytes** (a 33-slot record —
the 5-generation ancestor chart layout). Methods such as `kek_ord`, `Symm`,
`Vorf_erm`, `nachf_neu`, `nk1/nk2/nz1/nz2`, `Vr2`, `vz2` all index into these
arrays, so they are *all* blocked until the record layout is fixed once and
for all.

**Action:** fix the layout *from a writer method*, not a reader. Pick one method
that populates the arrays (e.g. the one that fills 33 slots from the DB) and
derive every field offset from its write sequence. Record the result as a
proper Delphi `record` type in `Unit2.pas` (or a new `Types`) and replace the
gvar raw pointers with typed access. Only then start the 34 Unit13 methods.

> Until the layout lands, do **not** spend effort on individual Unit13 graph
> methods — each one re-derives it and they will contradict each other.

---

## Category A — do first (self-contained, safe)

All from the open list; none touch the graph block.

- Unit17 `nam2`       (0053CC38)
- Unit17 `gebst`      (0053E878)
- Unit17 `gebstvn`    (0053D358)
- Unit17 `fambeltern` (0053FD18)
- Unit17 `BitBtn1Click` (005405C4)
- Unit17 `sub_0053D06C`  (? — alternate-form listing, confirm body first)
- Unit1 `Prfen1Click`  (005D9778)
- Unit1 `spitzbas`     (005E3454)
- Unit26 `sub_0054F810` (58 lines)
- Unit24 `listanz`     (0055EC64)
- Unit18 `suchen`      (00546490)
- Unit16 `Speichernunter1Click` (0055BDB0)

These are the "wins" phase: 12 methods, low risk, and they exercise the
DataModule2 / table helpers that the bigger methods reuse.

## Category B — solid (one job, known table)

- Unit1 `sub_005D39D8`   (44 lines)
- Unit1 `datsich`        (005DCD54)
- Unit1 `Sikoein`        (005DF5EC)
- Unit1 `Vorlist`        (00607C78)
- Unit1 `Vettern1Click`  (0060EF34)
- Unit1 `Basen1Click`    (0061182C)
- Unit1 `geschachtelt1Click` (005FE844)
- Unit19 `Namgeb`        (005513EC)
- Unit19 `namgv`         (0055748C)
- Unit19 `alphlist`      (00557514)
- Unit11 `Fgr`           (005C7068)
- Unit11 `zeichnen`      (005C95E4)
- Unit16 `SpeedButton6Click` (0055DCC4)
- Unit20/22/33 single `…Click` handlers

Build each against `DataModule2` (field offsets in `Unit2.pas`), one at a time.

## Category C — dependent (need a sibling OR the graph layout)

- Unit3 `gedein_neu`, `gedein2`, `gedein` — import chain; do in that order
  (innermost first) once Unit17/Unit19 helpers exist.
- Unit3 `gedausx`, `gedaus`, `gedausxv`, `gedausv` — export chain, same rule.
- Unit3 `ahndosein`, `osbein`, `adrschreib`, `illki`, `ofb3`, `ofb2`
- Unit1 `listen_akt`, `famblattx_daten`, `FamblHTML` (famblattx_daten was
  already reverted to a stub — revisit only after `FamblHTML` exists)
- Unit1 `ExcelExport1Click`
- **All 34 Unit13 graph methods** — *blocked on the record layout above.*

## Category D — large / deferred (convert last, chunk by chunk)

- Unit3 `sub_00582C24`   (409 lines)
- Unit3 `sub_005BC604`   (1094 lines)
- Unit3 `sub_005BE4B8`   (field splitter, 'BIRT' — medium but long)
- Unit3 `sub_005BEF5C`, `gedein_5`
- Unit1 `vorf_erm2`      (00600F50)
- Unit13 `sub_0056897C`…`sub_00569010` (the 7-slot kek/symmetry helpers,
  70–127 lines each) and `sub_0057316C`, `sub_00573314`

---

## Suggested order of attack

1. **Phase 1 (A):** the 12 self-contained methods above. After each one:
   `build.cmd` → `streamcheck.cmd` → `crossref.ps1`.
2. **Phase 2 (B):** the table-based helpers + the two Unit11 graphics methods.
3. **Phase 3 — pin the graph record layout** (writer-derived, into `Unit2.pas`).
   Verify with a writer *and* a reader method.
4. **Phase 4 (C):** Unit3 GEDCOM import chain, then export chain, then the
   Unit1 famblatt/HTML/Excel, then the Unit13 graph + painting.
5. **Phase 5 (D):** the long methods, in ~50–100-line chunks, one at a time;
   keep each chunk compiling before the next.

---

## Per-method rule of thumb

- Reconstruct from the listing *as-is*; if a body is large, split on visible
  `end;`/label boundaries and translate chunk by chunk.
- A method counts as **done** only when its body no longer contains the
  `TODO: Listing fehlt noch` marker *and* `build.cmd` is green.
- If a guess would not be faithful, restore the stub and move it to
  **Category D** rather than shipping a plausible-but-wrong body
  (this is what already happened with `famblattx_daten`).
