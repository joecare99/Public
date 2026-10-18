# AhnWin52 Unit15/Unit16 report caller discovery

**Status:** Static discovery and synthetic route-specific projections are
complete for the currently traced callers; production integration remains
blocked.

## Result

The original Unit15 QuickReport is dynamically configured by several distinct
callers. A single generic Unit15 row schema is not supported by the evidence.
The global-search print action has a complete fifteen-field projection from
Table16 (`over.db`) to the fifteen `QRDBText` controls. Other callers use
separate projections from Tables 14, 22, and 27; none establishes a generic
Unit15 row schema or authorizes runtime wiring.

No database/provider was opened, no production report was rendered or printed,
and the legacy UI was not wired during discovery or adapter implementation.

## Evidence sources

- `Source\Projects_AhnenWin\Unit1.pas`: retained independent assembly
  decompilation, including the six explicit `TQuickRep.SetDataSet` call sites.
- `Source\Projects_AhnenWin\Unit2.pas`: independent component/offset map.
- `Source\Projects_AhnenWin\Form15.dfm` and `Unit15.pas`: QuickReport controls
  and component offsets.
- `Source\AhnWin52\DataModules\GenealogyDataModule.lfm`: current streamed
  SQLDB tables and persistent fields.
- `Source\AhnWin52\Unit16.lfm` / `Unit16.pas`: preview/export UI resource
  bindings and retained handler listings.
- `Source\AhnWin52\AHNWIN51.lpi` / `AHNWIN51.dpr` and
  `FPC\AHW52_Main.lpi`: project composition in the current Lazarus source and
  the separate FPC application.

## Explicit Unit15 dataset assignments

| Caller | Dataset | QuickReport text-field mapping |
|---|---|---|
| `TForm1.spitzbas` (`005E3454`) | Table27, `$01F8`; current resource `alfls.db` | `QRDBText1=namvorn`, `QRDBText2=kn` |
| `TForm1.druck` (`005EFF30`) | Table14, `$00E0`; current resource `OUTP.db` | `QRDBText1=zeile`; `QRDBText2` is not used |
| `TForm1.geschachtelt1Click` | Table14, `$00E0` | `QRDBText1=zeile`; second text field is not used |
| `TForm1.drucken1Click` (`0060482C`, “Globale Suche”) | Table16, `$00EC`; current resource `over.db` | All fifteen fields, mapped below |
| `TForm1.Einzelpersonenmarkieren1Click` | Table14, `$00E0` | `QRDBText1=zeile`; second text field is not used |
| `TForm1.Vorlist` | Table14, `$00E0` | `QRDBText1=zeile`, `QRDBText2=nm` |
| `TForm3.ofb2` (`0058CB84`) | Table14, `$00E0` | `QRDBText1=zeile`, `QRDBText2=nm` |
| `TForm3.ofb3` (`00585048`) | Table14, `$00E0` | `QRDBText1=zeile`, `QRDBText2=nm` |
| `TForm3.NList` (`00595720`) | Table22, `$01B4`; current resource `nol.db` | `QRDBText1=zus`, `QRDBText2=no` |
| `TForm3.OList` (`00595FB4`) | Table22, `$01B4`; current resource `nol.db` | `QRDBText1=zus`, `QRDBText2=no` |
| `TForm19.nachf` (`00557E8C`) | Table14, `$00E0` | `QRDBText1=zeile`, `QRDBText2=nm` |
| `TOKBottomDlg.SpeedButton1Click` (`0054E0D4`) | Table14, `$00E0` | `QRDBText1=zeile`; `QRDBText2` is disconnected |

The offset-to-component mappings come from `Projects_AhnenWin\Unit2.pas`
(`Table14=$00E0`, `Table16=$00EC`, `Table27=$01F8`). The current resource
corroborates the database names and fields:

- `Table14` is `OUTP.db`, with `Zeile` (`TMemoField`) and `Nm`.
- `Table16` is `over.db`, with `Nn`, `Nummer`, `Name`, the date/place fields
  below, and `Geschlecht`.
- `Table27` is `alfls.db`, with `Kn` and `Namvorn`.
- `Table22` is `nol.db`, with `Zus` (`TMemoField`) and `No`
  (`TStringField`).

### Global-search projection

The `drucken1Click` listing assigns Table16 to `QuickRep1`, attaches each of
the fifteen `QRDBText` controls to that dataset, and sets the following
`DataField` values in order:

| Unit15 control | Source field |
|---|---|
| `QRDBText1` | `name` |
| `QRDBText2` | `nummer` |
| `QRDBText3` | `gebtag` |
| `QRDBText4` | `gebmonat` |
| `QRDBText5` | `gebjahr` |
| `QRDBText6` | `gebort` |
| `QRDBText7` | `sttag` |
| `QRDBText8` | `stmonat` |
| `QRDBText9` | `stjahr` |
| `QRDBText10` | `stort` |
| `QRDBText11` | `htag` |
| `QRDBText12` | `hmonat` |
| `QRDBText13` | `hjahr` |
| `QRDBText14` | `hort` |
| `QRDBText15` | `hname` |

These are Table16's persistent fields with case-insensitive spelling
differences from the LFM (`Name`, `Nummer`, `Gebtag`, etc.). `Nn` and
`Geschlecht` are not projected by this report. The original `Form15.dfm`
streams each control's default `DataField` as its own name and contains no
`DataSet`/`DataSource` property, so the global-search handler's explicit
runtime assignment is essential evidence.

The caller checks Table16's record count first. An empty result shows
`Keine Suchergebnisse vorhanden.` and exits; otherwise it asks for a report
heading, and cancellation exits before report setup. It then binds the
fifteen fields, reopens Table16, assigns the heading and preview callback,
and calls QuickReport preview. The retained listing uses `try/finally` for
its temporary string, without swallowing exceptions. This UI/control flow is
recorded as evidence but is not restored or wired in the FPC application.

### Table27 `spitzbas` route: field map known, producer remains blocked

The independent `Projects_AhnenWin\Unit1.pas` listing for
`TForm1.spitzbas` (`005E3454`) sets `QuickRep1.DataSet` to Table27
(`$01F8`), attaches the first two `QRDBText` controls, and assigns
`QRDBText1=namvorn` and `QRDBText2=kn`. The independent component map in
`Projects_AhnenWin\Unit2.pas` and the current DataModule LFM corroborate
Table27 as `alfls.db` and identify `Namvorn` and `Kn` as persistent string
fields. The method turns on those two controls before the preview path.
Callers `basa`, `aspitz`, and `pspitz` set different captions/modes before
delegating to `spitzbas`.

This is not a provider-free report handler: before configuring Unit15,
`spitzbas` closes Table27, calls `TTable.EmptyTable`, reopens it, and builds
its rows using several other tables and mode-dependent logic. Reconstructing
that producer would cross a destructive database-write boundary and requires
the unresolved source/index/filter contract. No table was opened or changed.
The two-field display mapping is static evidence only; it does not authorize
calling the producer or using the live table. Keep this route separate from
the synthetic Table16 adapter, and do not infer that only two destination
fields are relevant to other report callers.

#### Static row and side-effect matrix

The complete retained listing (`005E3454`–`005E48AE`) now resolves the
source-level row rules. Field identities below are cross-checked against the
independent `Unit2.pas` offset map and the current DataModule resources; index
definitions come from the authorized BDE metadata catalogue. This is a
static contract only, not proof of equivalent SQLDB or synthetic-dataset
behavior.

| Branch | Inclusion rule for current traversal row | Table27 values and lookups |
|---|---|---|
| `Spitz` | The heading string contains `Spitz`. In `Sppr`, look up the current Table24 `Nummer` in Table9 first; the Boolean result is ignored. Then require Table9 `Vater=0`, `Mutter=0`, `Trim(Name)` nonempty, and the raw `Name` not exactly `NN`. Other modes use the current Table9 row directly. | `Kn=Format('%6s',[IntToStr(Table9.Nummer)])`. `Namvorn` starts with `Name + ' ' + Vornamen + spouseSuffix`; only `Sppr` prefixes `'[' + FloatToStr(Table24.Kek) + '] '`. The Table18 marriage `FindKey` Boolean is checked: only a hit reads `Verbind` and sets `spouseSuffix` to `', oo'` if it contains `Ehes`, otherwise `', o-o'`; a miss adds no suffix. `Kmt=Table9.Lebensort`. |
| `Basis` | The heading string contains `Basis`. Require nonempty `Gebjahr` and `Stjahr`, then `StrToInt(Gebjahr)-StrToInt(Stjahr) >= 32`, a nonempty `Name`, and a miss from Table18 `FindKey(Table9.Nummer)`. This branch does not trim/reject `NN`. | `Kn` uses the same six-character space-padded format. `Namvorn=Name + ' ' + Vornamen`, plus `'(Nachfahren)'` if the Table8 lookup returns true. `Kmt=Table9.Lebensort`. |

Both branches append the same optional date text to `Namvorn`, then `Post`
once per included row. If either `Gebjahr` or `Gebort` is nonempty, append
`' * ' + Gebtag + '.' + Gebmonat + '.' + NormalizeUnit3SourceText(Gebjahr)
+ ' ' + Gebort`; otherwise, if either `Taufjahr` or `Taufort` is nonempty,
append the analogous baptism text prefixed by `' ~ '`. These birth/baptism
alternatives are mutually exclusive. For the second event group, nonempty
`Stjahr` or `Stort` gates a death annotation prefixed by `' + '`, using
`Sttag.Stmonat.Stjahr` and `Stort`. Only when both `Stjahr` and `Stort` are
empty does nonempty `Begjahr` or `Begort` produce the burial annotation
prefixed by `' # '`, using `Begtag.Begmonat.Begjahr` and `Begort`. The year
text is passed through the existing source-text normalizer; the listing
performs no date validation. Empty checks here are pointer/nonempty checks,
not numeric comparisons.

The outer mode is retained only when already `Sppr` or `basa`; every other
value becomes `Sppo`. `Sppr` traverses Table24 and otherwise the procedure
traverses Table9. The `Spitz` and `Basis` checks are independent, case-sensitive
substring tests on the heading, so a heading containing both can append two
rows for one traversal item, with the `Spitz` row first. A cutoff year greater
than 1 activates `gebjahr<=Y and taufjahr<=Y` filters on Table8 and Table9. At a cutoff year
of 1 or less the filters are not activated, and ordinary traversal continues.
The traversal count used for progress is read before those filters are
activated.

There are important index-state dependencies. The DFM/LFM do not specify an
initial Table18 index; the BDE catalogue identifies its primary index as
`Numr`. The `Spitz` marriage lookup passes `Table9.Nummer` before the
routine sets Table18 to `num`, so the first traversal item's lookup uses the
initial index selection; `num` is selected after that branch on every
iteration. The `num` index is composite (`Nummer;Indj;Indm`), while the
lookup supplies only `Nummer`. The `Basis` marriage-exclusion lookup occurs
after `num` is selected. Likewise, `vat` (`Vater;Indj;Indm;Indt`) and `mut`
(`Mutter;Indj;Indm;Indt`) are composite Table8 indexes, but the descendant
marker lookup supplies only the person number. For `M`, the code selects
`vat`; for `W`, it selects `mut`. Other sex values do not reset the index,
so the prior index can carry over. A synthetic-only BDE 5.2.0.2 probe below
confirms one-part prefix hits and immediate miss state for these exact
composite key layouts on unfiltered fixtures. It also records retained
Table18 values after misses, but the `Spitz` listing checks the marriage
lookup Boolean and does not read `Verbind` after a miss. The Table18 miss
state therefore does not produce a stale-row suffix in this path. The probe
does not establish original runtime or SQLDB parity.

Rows are appended in traversal order, with `Spitz` before `Basis` within an
item. Before report binding, Table27 selects `ds` (`Dsn`) and, except in
`Sppr`, replaces it with `Namvg` (`Namvorn;Geb`). The producer does not
assign `Dsn`, `Geb`, or `Sterb`; it assigns only `Kn`, `Namvorn`, and `Kmt`
among the non-auto fields. A synthetic BDE fixture with the same Table27
field widths and primary/`Namvg` key layouts showed that these three untouched
fields remain NULL after `Append`/`Post`; under `Namvg`, rows were traversed
by `Namvorn` with `Geb` NULL. This is provider-specific synthetic evidence,
not proof of the original runtime. Under `ds`, the synthetic Dsn values are
NULL and relative order for equal keys remains unresolved.

The routine has no local `except` or rollback. It calls `EmptyTable` before
the potentially failing lookups, conversions, assignments, and `Post`; its
`finally` only clears local strings. An exception can therefore leave an
empty or partially rebuilt destination and altered dataset/index/filter state.
On normal fallthrough it resets Table8/Table9 index names and closes Table27
before report setup, but does not visibly disable the filters or restore
Table18's index. `FloatToStr` also depends on runtime locale. These
unresolved provider/runtime details keep even an in-memory producer replica
from claiming exact parity; do not execute `spitzbas`, `EmptyTable`, or a
report route.

#### Synthetic BDE composite-index probe

Added `Source\AhnWin52\ReverseEngineering\Unit15CompositeFindKeyBDEProbe.dpr`.
It creates only artificial `MRG.DB`, `AWD.DB`, and Table27-shaped `ALFLS.DB`
Paradox tables in a newly created `%TEMP%` directory; it does not accept a
database path or read the authorized data directory. Compiled with Delphi 9
compiler 17.0 and ran against registered BDE `IDAPI32.DLL` 5.2.0.2 (SHA-256
`FC2FAEC98FD7167CF7D25FA773EC8ECEAD0DFC678CA1FFAF6B34F78BAC91A91E`).

Observed on these fixtures:

- An omitted `IndexName` selected the unnamed primary key on `Numr`. A
  one-integer `FindKey([1])` hit `Numr=1` even though that row's `Nummer`
  was 900. After selecting `num` (`Nummer;Indj;Indm`), the same one-part
  key hit the `Nummer=1` prefix and selected the first matching composite
  key in index order.
- A primary-index miss (`FindKey([777])`) returned false and retained the
  current row's `Verbind='Ehes'`; a subsequent `num`-index miss after a hit
  also returned false and retained the prior row's `Verbind='other'`. The
  retained values are recorded as BDE cursor evidence only: the listing
  branches around the `Verbind` read when `FindKey` returns false, so neither
  miss creates a marriage suffix.
- One-part keys successfully matched the prefixes of the exact four-field
  `vat` (`Vater;Indj;Indm;Indt`) and `mut`
  (`Mutter;Indj;Indm;Indt`) indexes. Duplicate parent keys resolved to the
  first matching suffix tuple in the synthetic index order.
- For a miss on each selected index, `FindKey` returned false, set `BOF`,
  left `EOF` false, and retained the prior current record (`RecNo=1` in
  these fixtures).
- With the exact cutoff expression `Gebjahr<=1965 and Taufjahr<=1965`
  active on the synthetic Table8-shaped table, the unfiltered first
  `Vater=5` match (`Nummer=101`) was excluded and `FindKey([5])` returned the
  next matching, included row (`Nummer=100`). A filtered miss returned false,
  set `BOF`, left `EOF` false, and retained `RecNo=2`.
- On a Table9-shaped table with the primary `Nummer` index and the same active
  cutoff filter, `FindKey([101])` for an excluded key returned false, set
  `BOF`, left `EOF` false, and retained the visible current row `Nummer=102`
  (`RecNo=2`). `FindKey([102])` then hit the included row. Because
  `spitzbas` ignores the Table9 `FindKey` Boolean in its `Sppr` branch and
  immediately reads Table9 fields, this installed-BDE state means the
  following predicates inspect the retained row after a filtered miss. This
  is an observed synthetic interaction, not proof of the original runtime's
  output.
- On the Table27-shaped fixture, `Append`/`Post` with assignments only to
  `Kn`, `Namvorn`, and `Kmt` left `Dsn`, `Geb`, and `Sterb` NULL. Selecting
  the matching `Namvg` index traversed the artificial rows by `Namvorn`;
  the `Geb` tie component remained NULL.

All assertions passed. This confirms the listed partial-key call shape and
immediate miss state for the installed BDE on synthetic Paradox tables with
matching index layouts; it also demonstrates that `FindKey` honors the
active filter in the Table8- and Table9-shaped cases. It does not establish
the exact original application runtime, SQLDB parity, or production data
results. The synthetic NULL defaults do not prove the original runtime's
field defaults or tie ordering. `FloatToStr` locale also remains unresolved.
The producer remains blocked; the probe never calls it, writes only its own
synthetic fixture, and invokes no report or UI route. The temporary fixture
was removed after capturing its file hashes in the session evidence artifact
`unit15-composite-findkey-bde-probe-2026-10-18.json`.

### Provider-free Table27 row model — synthetic contract

Added `Reports\Unit15SpitzbasModel.pas` as a pure in-memory row builder.
It accepts an ordered array of synthetic traversal items, a mode, heading,
and cutoff year, and returns only the `Kn`, `Namvorn`, and `Kmt` values
assigned by the listing. It has no `TDataSet`, provider, BDE/SQLDB, report,
UI, file, `Append`/`Post`, or `EmptyTable` dependency.

Each traversal item supplies the current Table9 row and explicit lookup
snapshots. In `Sppr`, the Table9 `FindKey` Boolean is retained in the input
but deliberately does not select or reject the supplied current row; this
models the listing's unchecked result without making a provider claim.
The Table18 marriage hit flag is checked: only a hit reads the supplied
`Verbind` and generates a suffix. Table18 misses can retain a BDE cursor row,
but this listing does not read that row after a miss. Table8 descendant lookup
outcomes are supplied separately for the `vat`/`mut`/inherited-index cases;
the model does not synthesize BDE composite-key or filter behavior.

For cutoff values greater than 1, the model applies the explicit
`Table9TraversalPassesCutoff` value only to non-`Sppr` Table9 traversals.
In `Sppr`, the ordered items represent Table24 traversal, while the supplied
Table9 current-row/lookup state already represents the separate filtered
lookup. A cutoff of 1 or less leaves traversal unfiltered. These flags are
synthetic input facts, not a SQLDB filter implementation.

The model preserves the listing's case-sensitive independent heading tests,
mode fallback, inclusion predicates, age conversion/error behavior,
hit-dependent marriage suffix, gender-dependent descendant outcome choice,
event-string precedence, source-text normalization, and append order
(`Spitz` then `Basis`). `Table24KekDisplayText` is supplied preformatted so
the helper does not pretend to establish locale-specific `FloatToStr`.
Output remains in synthetic traversal order; it does not sort to simulate
Table27's BDE indexes or assert equal-key order. The existing
`CreateUnit15SpitzbasRows` projection remains a separate downstream adapter.

Focused artificial-fixture tests cover both heading predicates, mode and
case behavior, unchecked Table9 misses, checked Table18 misses/hits, all
Spitz inclusion criteria, Basis threshold/exclusion and `NN` behavior,
gender-selected lookup results, cutoff routing, date precedence and
normalization, error propagation, and composition with the existing Unit15
projection. None of the producer, authorized database, BDE, legacy report,
or UI path is invoked.
The FPC test project builds; the new model suite passes 11/11 and the
existing Unit15 list-report suite passes 26/26. The full test suite was not
run for this bounded change.

### Prepare-only original-app observation protocol

`DevOps\ReverseEngineering\AhnWin52-Unit15-Spitzbas-Observation-Protocol.md`
is preparation only. It records the destructive `EmptyTable` boundary,
disposable artificial-fixture requirement, exact executable/caller approval,
full pre/post inventory and backup rules, visible-only result categories,
and stop/quarantine conditions. The execution gate remains closed: no safe
route avoiding both the destructive producer and report setup is established,
and a future observation requires separate approval for the exact copy,
caller, scenario, Table27 rewrite, and preview. No app or data was opened.

### Table14 `Vorlist` route: synthetic field projection

The retained `TForm1.Vorlist` listing (`00607C78`) attaches Table14 to
`QuickRep1`, and binds `QRDBText1=zeile` and `QRDBText2=nm` before the
QuickReport handoff (`0060BB32`–`0060BC90`). The current DataModule resource
corroborates `Table14` as `OUTP.db`, with `Zeile: TMemoField` and
`Nm: TStringField`. `TQRDBText.Print` handles memo/blob fields separately:
it calls `GetAsString` and transfers memo text to its line list. With an empty
mask, the ordinary string field uses `GetDisplayText`.

Implemented `Reports\Unit15VorlistRows.pas` as a **synthetic-only** projection
of those two fields. It requires an active browse-state source with the
evidenced field types, copies `Zeile` into an `ftMemo` `QRDBText1`, copies
`Nm.DisplayText` into `QRDBText2`, preserves source order and cursor, and
provides blank string fields `QRDBText3..15` for the existing Unit15 LazReport
schema. Focused synthetic tests verify multiline memo preservation, the
field display-text callback, multiple rows, bookmark restoration, empty input,
missing-field rejection, and successful report preparation; Unit15 passes
16/16 and the full suite passes 500/500.

This does not reconstruct or execute the `Vorlist` producer. Its listing opens
a dialog, empties/rebuilds temporary Table24 data, and later empties/rebuilds
Table14 and Table27 through provider-dependent traversal and filtering. Those
writer/index/filter semantics remain blocked. No database, dialog, QuickReport
runtime, preview, print, or PDF path was used.

## Family-sheet path: correction and limits

`TForm1.Famblatt` (`005FB604`) opens DataModule offset `$0530`, selects index
`tit`, checks record count, configures labels and images, assigns the
QuickReport preview callback, and calls `QuickRep1.Preview`. It does **not**
call `TQuickRep.SetDataSet`, `TQRDBText.SetDataSet`, or
`TQRDBText.SetDataField`. The independent offset map identifies the component
as Table38, and the current DataModule streams Table38 as `sour2`. This is a
consistent component identity, but it does not establish a row projection for
the Unit15 DBText controls. Earlier notes that attributed dynamic DBText
mapping to this method were incorrect.

## Unit16 preview and project reachability

`Unit16.lfm` binds lifecycle handlers (`FormCreate`, `FormShow`, `FormClose`),
the `QRPreview1PageAvailable` callback, and print/save/PDF/control events.
Its PDF handler works on the already-prepared QuickReport; it does not decide
which source dataset backs Unit15. `FormShow` opens Table14/Table22/Table27 in
the text/HTML path; that is not evidence for the Unit15 report contract.

Both `Source\AhnWin52\AHNWIN51.lpi` and `FPC\AHW52_Main.lpi` omit Unit15 and
Unit16. The separate legacy `AHNWIN51.dpr` lists Unit16 but not Unit15.
Consequently, the discovered global-search mapping is not an active FPC
user-facing route, and no runtime integration or product behavior can be
claimed.

## Integration gate

Keep broad Unit15/Unit16 integration blocked. The **synthetic-only** global
search projection described below is implemented using an in-memory dataset
with the fifteen Table16 fields. It must not open `over.db` or invoke the
legacy input dialog, QuickReport, printer, preview, or PDF path. Other Unit15
callers have different projections and must remain separate until their
workflows are independently specified.

## Synthetic projection implementation

Implemented `Source\AhnWin52\Reports\Unit15GlobalSearchRows.pas` as the
route-specific, in-memory adapter. It requires a non-nil, active Table16-like
dataset in browse state with all fifteen named source fields, copies rows in
source order to an owned `TBufDataset` with `QRDBText1..15` string fields, and
restores the caller's source bookmark. The caller owns both datasets. This
copies source `DisplayText` values, matching the recovered
`TQRDBText.Print` path when `Mask` is empty. Output fields remain strings; no
production report formatting/runtime is invoked.

Focused synthetic coverage in
`Source\AhnWin52Tests\tst_AHW52_Unit15ListReportTests.pas` verifies every
ordered field value across multiple rows, caller-cursor preservation, report
preparation with the projected dataset, missing-field, inactive, nil, and
non-browse source rejection, and the empty-source contract. The synthetic
source fixture now mirrors the current streamed Table16 schema: `Nummer` is
integer; the other fourteen mapped fields are strings with their declared
sizes (`Name`/`Hname` 60, date parts 3/4/7 as streamed, and place fields 30).
The focused tests pass 13/13, and `FPC\AhnWin52Tests.lpi` builds successfully;
the full FPCUnit suite passes 497/497. These tests verify schema and synthetic
display-text compatibility, not the original QuickReport UI/runtime. The adapter does not open `over.db`,
call the original search dialog, or execute the production
QuickReport, preview, print, or PDF routes. It is not wired into the main FPC
application; broad runtime integration remains blocked.

### QuickReport empty-mask display-text trace

The retained `Source\Projects_AhnenWin\QRCtrls.pas` listing for
`TQRDBText.Print` (`0050E57C`, through `0050E83B`) narrows the unresolved
`Nummer` display behavior:

- The original `Form15.dfm` declares no `Mask` property on `QRDBText2`, so the
  streamed mask is empty unless a caller sets it dynamically.
- The branch at `0050E66B` tests whether `Mask` is empty. An empty mask jumps
  to `0050E68F`, where ordinary fields use `TField.GetDisplayText`; nonempty
  masks continue to type-specific formatting branches.
- The global-search caller sets the field mapping but the retained listing
  shows no `Mask` assignment for `QRDBText2`. The current Table16 resource
  declares `Nummer` as integer and does not set a field `DisplayFormat`.

Therefore the recovered global-search route uses `TField.GetDisplayText` for
all fifteen controls, including `Nummer`. The synthetic projection copies
`sourceField.DisplayText` into each `QRDBText` string field. A regression test
sets an in-memory integer field's `DisplayFormat` to `00000`, proves that
`DisplayText` is `00101` while `AsString` is `101`, and checks the projected
value. This validates the adapter contract without opening a database or
invoking QuickReport. Production Unit15/Unit16 UI and provider integration
remain blocked and unchanged.

## Unit16 selector cross-check

The static main-form listing sets the report selector to `Over` in the global
search route, captures the requested heading and fifteen-column heading, then
binds Table16 to Unit15. `Over` is not a Unit16 text-export mode: that distinct
workflow reads Table14, Table22, or Table27 and has no Table16 projection.
The FPC Unit16 text workflow now rejects `Over` explicitly before any output;
the form adapter validates it before creating a file. This is not production
integration and does not resolve the separate Unit15 field-display-format
question.

Other producer listings assign `$02535930` list headings and assemble
`$02535934` descendant text. The person-search listing assigns
`$02535438` ancestor/descendant captions. `TForm19.nachf` assembles
`$0061E028` from `ComboBox1.Text + ' von '`. These listing-backed producers
are not active FPC Pascal writers, so required state remains guarded rather
than synthesized.

## Table14 single-column Unit15 projection

The remaining single-column Table14 contract is independently present in
three Unit15 routes. `TForm1.druck` (`005EFF30`) clears the first two
`DataField` values, binds Table14 (`$00E0`) to `QuickRep1`, assigns
`QRDBText1=zeile`, hides/disconnects `QRDBText2`, and installs the preview
callback. Its `frbestimmtenOrt1Click` caller (`005F08CD`) and
`Probandenname1Click` caller (`005F2CD6`) each empty and repopulate Table14
before invoking `druck`. `geschachtelt1Click` (`005FE844`) and
`Einzelpersonenmarkieren1Click` (`00605A2C`) independently empty/rebuild
Table14 and bind only `QRDBText1=zeile`; both leave the second report text
control unused. The Unit2 component map identifies `$00E0` as Table14, and
the current DataModule resource declares `Table14Zeile: TMemoField`.

Added `Reports\Unit15SingleColumnRows.pas` as a synthetic-only projection:
it requires an active browse-state source with `Zeile: ftMemo`, copies memo
rows in source order to `QRDBText1`, emits the fifteen-field report schema
with unused fields blank, and restores the source bookmark. It does not
execute or replace any caller's producer. Focused tests cover multiline memo
copying, row order, cursor preservation, blank unused fields, report
preparation, empty input, missing/wrong-type fields, and nil/inactive/editing
sources. The test project builds; the focused Unit15 suite passes 20/20 and
the complete FPCUnit suite passes 504/504.

All four legacy producers remain blocked: they call `TTable.EmptyTable` on
Table14 before constructing its rows through provider-dependent table
traversals or query results. No database, dialog, QuickReport runtime,
preview, print, or PDF path was used, and this adapter is not wired into the
legacy or main FPC UI.

## Table27 `spitzbas` projection — synthetic only

The retained `TForm1.spitzbas` listing (`005E3454`) maps Table27
(`$01F8`) to `QRDBText1=namvorn` and `QRDBText2=kn` before preview. The
independent Unit2 component map identifies Table27 at `$01F8`, and the current
DataModule LFM declares `Table27` as `alfls.db`, with `Namvorn` and `Kn` as
`TStringField` fields. The caller uses no nonempty `Mask`; ordinary
QuickReport DBText values therefore follow the `DisplayText` branch.

Added `Reports\Unit15SpitzbasRows.pas` as a synthetic-only adapter. It
requires active browse-state input with both string fields, copies their
`DisplayText` values in source order into `QRDBText1`/`QRDBText2`, restores
the source bookmark, and supplies blank `QRDBText3..15` placeholders for the
current LazReport schema. Tests cover both mappings, a display-text callback,
source order and bookmark restoration, blank placeholders, report
preparation, empty input, missing/wrong-type fields, nil input, and invalid
dataset states. The test project builds; focused Unit15 passes 23/23 and the
full FPCUnit suite passes 507/507.

The actual `spitzbas` producer remains blocked: it closes and calls
`TTable.EmptyTable` on Table27 before rebuilding rows with mode-dependent
provider traversals. Neither this adapter nor its tests run that producer,
open `alfls.db`, or activate the original report UI.

### Later schema evidence — authorized test-copy catalogue

The subsequent allowlisted BDE catalogue opened the authorized `alfls.db`
test copy read-only. It confirmed `Kn` width 20 and three ascending indexes:
unique primary `Nr;Dsn`, non-unique `Ds` on `Dsn`, and non-unique `namvg` on
`Namvorn;Geb`. The table had zero records. This resolves the destination
schema/index-definition gap for that copy, but does not supply producer input
rows or establish the `spitzbas` mode-specific source traversal, filters,
output ordering, or errors. Keep the producer blocked; the zero-row table
cannot validate generated row behavior. Full provider evidence:
`AhnWin52-Authorized-BDE-Provider-Catalog.md`.

### Static producer dispatch and input inventory

A bounded trace of `TForm1.spitzbas` (`005E3454`–`005E48AE`) and its three
callers establishes these entry facts:

| Caller | Mode/caption behavior |
|---|---|
| `basahnen` (`005E4AB8`) | Sets mode `basa` and the Basis-Ahnen heading. |
| `aspitz` (`005E4C30`) | Sets the Spitzen-Ahnen heading but does not assign the mode global. Its behavior therefore depends on the incoming global mode. |
| `pspitz` (`005E4D60`) | Sets mode `Sppr`, derives a selected-person key, and calls the separate `vorf_erm2` path before `spitzbas`. |

At entry, `spitzbas` preserves only `Sppr` and `basa`; other mode values are
rewritten to `Sppo`. It then closes Table27, calls `EmptyTable`, and reopens
it before constructing output. The selected traversal dataset is Table24
(`VORF.DB`) for `Sppr`, otherwise Table9 (`AWD.DB`). It also opens Table9,
Table18 (`MRG.DB`), and Table8 (`AWD.DB`). When the global cutoff year is
greater than 1, it applies and activates the filter
`gebjahr<=year and taufjahr<=year` on both Table8 and Table9; with a cutoff
at or below 1, it traverses without that filter.

The trace confirms indexed lookups through Table18 index `num`, and
conditional Table8 indexes `vat`/`mut` based on the current person's
uppercased sex value. The output is appended to Table27 and the routine
directly assigns the `Kn`, `Namvorn`, and `Kmt` persistent fields; it formats
the key from a person number using `%6s`. Before preview, Table27 selects
`ds`, then selects `Namvg` for every mode except `Sppr`; the BDE catalogue
confirms these are the test-copy indexes on `Dsn` and `Namvorn;Geb`.

This is only the dispatch/input/index inventory, not a complete row
contract. Branch-specific inclusion rules, exact `Kn`/`Namvorn`/`Kmt` string
construction, output ordering across modes, implicit post/exception
behavior, and the unset mode in `aspitz` still need a complete
listing-to-component trace. `EmptyTable` remains a hard no-execution
boundary. Next: build that static condition/field-assignment matrix; do not
add synthetic producer code until it is complete.

## Unit3 `NList` / `OList` Table22 projection — synthetic only

The retained `Projects_AhnenWin\Unit3.pas` listings for `TForm3.NList`
(`00595720`) and `TForm3.OList` (`00595FB4`) both bind Table22 (`$01B4`) to
`QuickRep1`, attach the first two `QRDBText` controls, and assign
`QRDBText1=zus` and `QRDBText2=no`. The independent Unit2 component map and
current DataModule LFM corroborate Table22 as `nol.db`, with `Zus: TMemoField`
and `No: TStringField`. The method listings have no nonempty DBText mask;
the memo is read as string text and the ordinary string field follows
`DisplayText`.

Added `Reports\Unit15Table22Rows.pas` as a synthetic-only adapter. It validates
an active browse-state source and the exact field types, maps `Zus` memo text to
`QRDBText1` and `No.DisplayText` to `QRDBText2`, preserves row order and the
source bookmark, and supplies blank `QRDBText3..15` fields for the current
LazReport schema. Focused tests cover multiline memo, a `No.OnGetText`
override, multiple rows, cursor preservation, report preparation, empty input,
missing/wrong-type fields, and nil/inactive/editing sources. The test project
builds; Unit15 passes 26/26 and the full FPCUnit suite passes 510/510.

Both legacy callers open, close, and empty Table22 before rebuilding it from
string-list and provider-backed traversal logic; `OList` also selects the
`namort` index. Those producers remain blocked. No database, provider,
QuickReport, preview, print, or PDF path was run, and the adapter is not wired
into production.

### Synthetic reconstruction of the NList/OList string-list parser

The two retained Unit3 listings establish a shared parser over their supplied
`TStringList` entries, each using character 15 as the key/value separator.
Both trim the suffix and skip entries whose trimmed key or suffix is empty.
They preserve the raw key, combine only consecutive entries with exactly equal
raw keys, and append each repeated suffix to `Zus` with `", "`. `NList` skips
the exact key `NN`; `OList` retains it. Both begin by appending an empty
Table22 record and delete it when the final first-row `No` is blank, so the
observable result for no accepted entries is an empty dataset.

Added `Reports\Unit3RegisterRows.pas` to reconstruct only this list-to-rows
transformation over caller-supplied strings in memory. It produces Table22's
`No`/`Zus` field schema and has no provider, traversal, database, or report-UI
dependency. Tests cover repeated contiguous keys, raw-key equality,
`NN`-specific behavior, trimmed and malformed/empty entries, and empty output.
They also pass the synthetic result through `Unit15Table22Rows` to verify the
combined report mapping. The test project builds; the focused parser suite
passes 4/4, and the full FPCUnit suite passes 514/514. This does not
reconstruct how either legacy caller creates its string list or authorize
either caller's `EmptyTable` producer.

## Cross-unit caller follow-up

A repository-wide search of the retained `Projects_AhnenWin` listings for
`TQuickRep.SetDataSet` and `TQRDBText.SetDataField` found the additional
Unit3, Unit19, and Unit22 callers listed above, plus one Unit17 operation that
does not establish a report row mapping. `TForm3.ofb2` and `ofb3` use the same
Table14 `Zeile`/`Nm` projection already represented by `Unit15VorlistRows`;
`TForm19.nachf` has the same mapping, and
`TOKBottomDlg.SpeedButton1Click` uses the Table14 single-column contract
represented by `Unit15SingleColumnRows`.

These matches confirm reusable field contracts, not safe producers:
`ofb2`/`ofb3`, `nachf`, and `SpeedButton1Click` append to Table14, while their
traversals and output construction remain provider-dependent. They were not
run. `TForm17.BitBtn1Click` empties/rebuilds Table14 but then assigns `nil` to
Unit15 `QuickRep1.DataSet` and does not assign a DBText `DataField`; it shows
Unit16 afterward. It therefore provides no evidenced Unit15 row projection
and remains outside the adapter contract. The repository-wide search found no
additional caller-specific DBText field assignment beyond the entries in the
table above.

## Generic report lifecycle boundary — interface-only

`Source\AhnWin52\Reports\ReportLifecycleContract.pas` defines a
provider/UI-neutral handoff, not a shared rendering implementation:

| Phase | Contract | Boundary |
|---|---|---|
| Request | `TReportRequest` (`ReportId`, `ReportKind`, caption) | Identity and presentation metadata only; no database route, global state, file path, or form reference. |
| Source | `IReportSourceContext` | Marker passed by the caller. The contract does not open, close, retain, or free backing data; concrete adapters must preserve the caller's lifetime. |
| Preparation | `IReportPreparer.Prepare` | Receives the request and source and returns a prepared-report interface. Missing source/preparer, nil preparation, and identity mismatch are explicit failures. |
| Prepared state | `IPreparedReport` | Exposes identity and independent preview, print, PDF, and text capabilities; it is not a dataset, page source, or output stream. |
| Output | `IReportOutputSink` / `ExecuteReportOutput` | Each sink handles one capability. Dispatch checks the matching capability and never falls back to another output type. |

Provider/engine exceptions propagate unchanged; adapters may classify known
engine failures with `EReportEngineFailure`. The generic contract does not
silently translate arbitrary exceptions or implement retries/fallbacks.

This contract has no production adapter and does not route or alter the
existing workflows. FOKO continues to use its dataset-backed LazReport
workflow and PDF page-source bridge. Unit16 text export retains its separate
context/writer contract; its QuickReport preview/PDF handoff remains unresolved.
The synthetic lifecycle suite passes 15/15; independent existing FOKO and
Unit16 text-export suites pass 9/9 and 15/15. The complete FPCUnit suite
passes 629/629, and the AHW52_Main Debug project builds. These results prove
contract invariants only—not real output, printer behavior, Unit16 preview/
PDF, QuickReport/WPTools migration, or legacy dependency retirement.
