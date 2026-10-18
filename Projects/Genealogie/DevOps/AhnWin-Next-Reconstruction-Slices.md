# Backlog: Next AhnWin reconstruction slices

**Status:** Active reconstruction backlog  
**Priority:** Continue replacing the legacy wPDF/Ahnw50 PDF engine with the
verified SynPDF/mORMot2 report-to-PDF adapters and migrate QuickReport report
workflows to LazReport. The Ahnw50 DLL and its embedded license path are not
target dependencies. Non-reporting relationship slices remain blocked on
provider parity and application-specific relationship rules.

## Authorized test-copy BDE catalogue — completed 2026-10-18

The authorized `C:\ProgramData\AHNENWIN Test` copy was inventoried and probed
one table at a time with the standalone Delphi 9/BDE 5.2.0.2 read-only
allowlisted harness. All 29 table files opened; provider metadata records 292
fields, 76 index definitions, and 337 total rows. The probe did not log or
copy record values. Per-table pre/post comparisons and a final whole-directory
comparison against the 170-file SHA-256 baseline found no additions,
removals, or changes. The probe, metadata catalogue, and exact runtime
observations are documented in
`DevOps\ReverseEngineering\AhnWin52-Authorized-BDE-Provider-Catalog.md`;
the inventory/static reconciliation is in
`DevOps\ReverseEngineering\AhnWin52-Authorized-Test-Data-Inventory.md`.

Table13/`LOC.db` exposed a non-unique `Ort_` index, seven distinct test keys,
hit/miss cursor states, a tested partial key and overlength key, and a
closed-table `EDatabaseError`; the test copy contains no duplicate `Ort`.
A separate artificial BDE fixture has now exercised duplicate positioning on
a non-unique `Ort_` index. Table9/`AWD.DB` exposed its
primary plus eight secondary indexes and bounded `First`/`Next`/`Last`
states. These are BDE test-copy observations only: they do not establish
SQLDB parity, memo decoding, all-table collation behavior, production
relationship rules, or permission to activate application workflows.
Keep `FindKey` integration, relationship writes, report producers, and
production UI paths blocked until their separate contracts are verified.

## Synthetic BDE / SQLDB lookup comparison — bounded result

The consumer-backed cases and classifications are recorded in
`ReverseEngineering\AhnWin52-BDE-SQLDB-Lookup-Comparison-Matrix.md`.
Installed BDE 5.2.0.2 was tested on a disposable Paradox fixture with a
non-unique `Ort_` index and duplicate artificial keys. The exact-key hit
selected synthetic ID 1; the miss after `First` returned false and retained
the current synthetic ID 1 with `BOF=True`, `EOF=False`, `RecNo=1`. Four
fixture database/index files had no hash changes during the read-only lookup
batch. Delphi's `AddIndex` required `ixCaseInsensitive` for this named
single-field non-unique index; therefore case-folding parity is not claimed.

An FPCUnit test exercises SQLDB's exact-field `Locate` on an in-memory SQLite
database with duplicate values and an explicit `ORDER BY ID`: the same ID was
selected because query order was fixed, and the miss preserved the current
row with `BOF=True`, `EOF=False`. Focused tests pass 4/4; the full suite passes
590/590. This limited observation does not emulate BDE named-index selection
or composite key-prefix behavior (`num`, `vat`, `mut`), and it does not resolve
the filtered Table9 stale-row dependency. The test exercises generic
`TSQLQuery`, not the external `Cmp_SQLTable` implementation. `TSQLTable.FindKey`
remains an explicitly unsupported operation; no facade or legacy handler was enabled.
No authorized data table needed to be opened because the duplicate behavior
was testable only with synthetic rows.

## Continuation gate — no ready task — 2026-10-18

The current session todo graph contains 482 completed tasks, 25 blocked tasks,
and no pending or dependency-ready task. The guarded UI tab/close extension is
now live-verified and complete: the native selection advanced 1 -> 2, the
metadata-only profile contained no control text, and changed test-copy files
were restored to an exact 170-file backup match. That result does not resolve
the separate provider, report, relationship, or destructive-producer gates.
The remaining blocked tracks require new evidence or authorization:
authoritative Table9 relationship/provider rules; a caller-owned report
dataset contract or separately approved visible observation; missing original
source/build dependencies; or an independent ordering oracle. Repeating the
completed exact-field synthetic comparison does not unblock any of these.

The planned next relationship step is therefore evidence intake only. Request
a metadata-only Table9 specification covering parent/child fields,
cardinality, optionality, sentinel/self-reference rules, and update/delete/
cancellation semantics; do not request genealogy records. Otherwise select a
separately gated workstream and supply the exact missing evidence named by
its blocker. Until then, keep provider integration, writes, destructive
producers, and live report/UI paths blocked.

## Paradox best-guess dispositions — 2026-10-18

Two narrower Paradox investigation gates now have bounded evidence-based
dispositions, documented in
`ReverseEngineering\AhnWin52-Paradox-BestGuess-Resolution.md`.

The fixture's exact history remains unknown, but duplicate snapshots and the
metadata-only BDE catalogue independently support `Rufname=30` for the
authorized test copy and identical Table9 index definitions. This is enough
for static/test-copy metadata work; it does not resolve why the LFM says 40
or why file timestamps/hashes changed. Preserve those as separate,
unexplained claims rather than choosing a production width or assigning
causation.

The existing Delphi 9/BDE 5.2.0.2 synthetic Table27 probe inserted
`Zebra synthetic` before `Alpha synthetic`, then traversed the generated
`Namvg` secondary index and observed Alpha before Zebra. This is an
independent BDE runtime oracle for distinct ASCII keys in that fixture, not a
`.YG` parser, `intl850` collation proof, tie-order guarantee, or SQLDB
contract. Both narrow investigation tasks may close; broader provenance,
binary-tree reader, and production-provider work remain gated.

## UI automation scope — selected tab and graceful-close actions

`Source\AhnWin52UIAutomation` already provides a pinned external controller
for the approved test executable. The separate `person-search` flow remains
specific to `TForm3.Auswahl`; it is not reused for other screens.

The tool provides metadata-only `inspect-metadata` and `read-fields`, which
returns only explicitly selected visible edit/combo values (maximum 16), after
fresh PID/executable/profile/structure checks and `--allow-read`. It now also
has two independently guarded commands:

- `next-tab` queries native tab selection/count, refuses wraparound, sends
  exactly one `Ctrl+Tab`, and requires the selection to advance by one. Its
  output profile has no visible control text; the existing `read-fields`
  validator must still be given explicit handles matched to DFM/LFM evidence.
  If Windows blocks foreground activation, it waits up to 30 seconds for
  explicit user activation of the exact validated main window and sends no
  input before verifying focus within the active tab.
- `close` sends `WM_CLOSE` only to the validated main window, confirms the
  known exit prompt with Ja/Yes, rejects the backup with Nein/No, and never
  force-terminates the process. The explicit `--resume-backup` mode can
  continue only a validated already-open backup prompt after a known accepted
  exit phase. Unknown dialogs or mismatched controls stop.

Delphi component names and dataset field bindings still require static
DFM/LFM reconciliation. For `TMessageForm`, whose message label may not have
an HWND, close automation uses only the known class, the expected two-step
sequence, title constraints, process ownership, and exactly one Ja/Yes and
Nein/No button; native `#32770` dialogs must expose matching prompt text.

The FPC 3.2.2 build and 65 synthetic tests pass. Live `next-tab` is verified:
the final fresh run advanced the native selection exactly from index 1 to 2,
returned `next-tab-verified`, and saved a metadata-only post-profile with 194
HWNDs and no visible text. A post-action validator bug found during the first
input run was fixed and the entire action repeated successfully. Live graceful
close is also verified; the final run used a fresh, verified 170-file backup,
and all ten changed AWD files were restored and hash-verified. An earlier
close attempt exercised `--resume-backup` after a transient invalid-HWND error
during the prompt transition. No genealogy fields were read in these
tab/close runs. The application is closed and the final test directory matches
its backup exactly. This extension does not unblock Unit14, report, provider,
or destructive producer routes. Details:
`DevOps\ReverseEngineering\AhnWin52-UI-Automation-Tab-Close.md`.

## Table27 schema and static producer trace — static matrix complete

The authorized BDE catalogue resolves the `alfls.db` test-copy schema:
`Kn` is 20 bytes, the table has zero records, and it has three ascending
indexes (unique primary `Nr;Dsn`, non-unique `Ds` on `Dsn`, non-unique
`namvg` on `Namvorn;Geb`). This does not establish producer behavior.

The first static pass through `TForm1.spitzbas` maps modes `basa`, `Sppr`,
and the defaulted `Sppo`; `Sppr` traverses Table24, while other modes
traverse Table9. The routine also opens Table8/Table18, applies cutoff-year
filters to Table8 and Table9 when the year is greater than 1, uses
Table18 `num` and sex-dependent Table8 `vat`/`mut`, and selects Table27
`ds`/`Namvg` before report preview. It directly assigns Table27
`Kn`/`Namvorn`/`Kmt`. `aspitz` does not explicitly set the mode global.
Cutoff filters are activated only for years greater than 1; at 1 or less,
traversal continues without those filters.

The full row matrix is now documented in
`DevOps\ReverseEngineering\AhnWin52-Unit15-Report-Caller-Discovery.md`. It
records the independent `Spitz`/`Basis` predicates, exact `Kn`/`Namvorn`/
`Kmt` construction, event annotation precedence, lookup dependencies,
append/post sequence, output indexes, and the no-rollback exception path.
The exact partial-key call shape has additionally been exercised on synthetic
Paradox fixtures with BDE 5.2.0.2: a blank Table18 index selection used the
unnamed primary `Numr` index; one-part keys hit prefixes of `num`, `vat`, and
`mut`; misses set `BOF` but retained the current record. An active Table8
fixture filter using the exact cutoff expression excluded an earlier matching
prefix record and `FindKey` selected the next visible record. A Table27-shaped
fixture left unassigned `Dsn`, `Geb`, and `Sterb` NULL after `Append`/`Post`;
its synthetic `Namvg` index traversed the rows by `Namvorn`. This does not
establish original-runtime parity, locale-sensitive `FloatToStr`, or SQLDB
behavior; ties and order under `ds` remain unresolved. A separate Table9-
shaped primary-index fixture showed that a filtered-out `FindKey` returns
false, sets `BOF`, and leaves the prior visible row current. Since the
`Sppr` listing ignores that Boolean and reads Table9 fields afterward, this
creates a measured stale-current-row dependency on installed BDE state.
Correction from the complete instruction trace: the Table18 marriage lookup
checks its Boolean; a miss branches around the `Verbind` read and adds no
suffix, even though the synthetic BDE miss retained a row. Likewise, the
filter check at cutoff year <=1 is skipped, not an early exit.

Keep `restore-unit15-table27-spitzbas-producer` blocked. Do not execute
`spitzbas`, `EmptyTable`, report/UI routes, or any authorized data. The
standalone synthetic-only probe is
`Source\AhnWin52\ReverseEngineering\Unit15CompositeFindKeyBDEProbe.dpr`.
It confirms only installed-BDE behavior on artificial fixtures and does not
establish SQLDB parity or authorize production integration. Further runtime
probes should be opened only for a concrete reconstruction slice that needs
a remaining contract.

`Reports\Unit15SpitzbasModel.pas` now defines the separate provider-free
synthetic contract. It accepts ordered row/lookup snapshots, constructs only
`Kn`, `Namvorn`, and `Kmt`, keeps the unchecked `Sppr` Table9 current-row
state explicit, reads Table18 `Verbind` only on hit, and consumes explicit
Table8 result states for the `vat`/`mut`/inherited index paths. Cutoff input
flags are synthetic provider outcomes; no filter engine, BDE index, final
Table27 sort, or locale-specific `FloatToStr` is simulated. Focused tests use
artificial data and compose the result with the existing Unit15 projection.
The FPC test project builds; the model suite passes 11/11, the existing
Unit15 report suite passes 26/26, and the full suite passes 583/583 at this
checkpoint.
`DevOps\ReverseEngineering\AhnWin52-Unit15-Spitzbas-Observation-Protocol.md`
prepares but does not authorize a future disposable-copy observation.

## Unit22 producer screen and Unit24 preset regression — 2026-10-18

The next candidate screen found that Unit22's DFM-bound
`TOKBottomDlg.SpeedButton1Click` starts by opening Table14, closing it,
calling `EmptyTable`, reopening Table14, and opening Table15. It is not a
safe provider-free candidate; the producer remains listing-only. Its
`SpeedButton2Click` cancel route and counter helpers already have focused
synthetic tests. Evidence:
`DevOps\ReverseEngineering\AhnWin52-Unit22-TinyTafel-Producer-Boundary.md`.

The same static screen identified a fully bounded test-only follow-up for
Unit24. Its DFM/LFM-bound `RadioButton4Click` and `RadioButton5Click`
directly set the same eleven checkboxes to all True or all False. The current
implementation already matches the listing; added artificial tests for all
target and untouched fields, without invoking datasets or report actions.
Focused tests passed 3/3; the full suite passed 586/586 at that point.

Followed the Unit24 screen through the independent `CheckBox17Click` and
`CheckBox18Click` listings. Both bound handlers clear CheckBox18 only when
CheckBox17 is unchecked; when it is checked, they leave its current state
alone. Added synthetic tests for both branches and unrelated control state.
The focused combined Unit24 suite passes 5/5; the full FPCUnit suite now
passes 588/588. Evidence:
`DevOps\ReverseEngineering\AhnWin52-Unit24-Radio-Presets.md`.

**Next:** continue the evidence-only candidate screen. Keep Unit22's
destructive Table14/15 route and all report/provider paths blocked. Restore
only a complete method with explicit component/resource ownership and a
provider-free synthetic boundary; otherwise record its exact blocker.

## Latest candidate screen — Units4, 5, and 8

The Unit5 and Unit8 retained listings contain only streamed component
declarations and no Pascal methods. Unit8's DFM gives `Timer1` a 5000 ms
interval but no `OnTimer` binding; the retained startup listing creates,
shows, and updates Form8 before TForm1, and `TForm1.FormCreate` later closes
it. This proves a startup-owned close, not timer behavior or the visual
contract. The current FPC project uses a separate `frm_Splash` whose LFM
binds its timer; do not treat that as evidence for legacy Unit8. Unit4 has a
complete short listing for radio-button/modal-result changes and activation
resets, but no corresponding Unit4 Pascal unit or DFM/LFM resource exists in
the current FPC tree. Its component ownership and bindings cannot be
reconciled for safe restoration. No production code or tests were added for
these unavailable boundaries. Evidence:
`DevOps\ReverseEngineering\AhnWin52-Unit8-Startup-Splash-Lifecycle.md`.

The adjacent Unit1 helper candidate `TForm1.alineu` (`005E1DF8`) was also
screened. Its complete listing calls `TDBDataSet.SetDatabaseName` on dozens
of streamed datasets using the input string; it is a provider/data-module
configuration route, not a pure string helper. Keep it outside the synthetic
helper track and do not execute it without an explicitly approved isolated
provider setup.

The immediately preceding Unit7 bounded slice is complete:
`TForm7.berechnen` now delegates its complementary-day eligibility check to
the pure `FrenchRepublicanComplementaryDays` helper. Its 4 focused tests and
the existing 14 calendar-form tests pass; both the test project and Debug main
project build. An initial attempted invalid-form test showed that
`ShowMessage` was not suppressed by the existing `Application.MessageBox`
test hook, so that test was removed and the dialog path was not repeated.
The full suite was not run. Do not rerun the About-form click test that
previously produced Access Violations.

**Next:** continue an evidence-only search for a complete helper whose
arguments, outputs, and side effects are all explicit in a retained listing.
Do not infer Unit4 resource/caller behavior or exercise any dialog, provider,
database, report, file, or printer path. Record a block instead of
reconstructing from a listing alone if no fully bounded candidate appears.

## Unit1 grid column sizing

The complete `TForm1.gridanp` listing at `005D3EF8` contains only width reads
and `TCustomGrid.SetColWidths` calls. Its five original grids map to the
current PersonEdit, Relationships, and Siblings frames through the streamed
LFM resources. Restored the exact column-index/factor assignments in the
current main form; the resize test now streams the frame controls, and the
synthetic layout test verifies all 24 affected widths plus unchanged leading
columns. The focused resize suite passes 2/2. The procedure was tested only
with synthetic dimensions; no production resize, provider, or report route
was executed.

The legacy x86 listing mixes `Extended` and `Single` constants, while the
current x86_64 FPC target has `Extended = Double`. Expressions and `Round`
are preserved, but bit-for-bit behavior at every floating-point tie across
those runtimes is not yet established. Evidence:
`DevOps\ReverseEngineering\AhnWin52-Unit1-Grid-Column-Sizing.md`.

**Next:** continue a bounded static screen for another complete
provider-/file-free listing. Do not broaden locale-dependent date/float
helpers or activate database, report, file, printer, or production UI paths.

## Unit1 validated date-difference core

Extracted the component arithmetic/label formatting from
`TForm1.Proc_005D3B50` into `Forms\Unit1DateDifferenceCore.pas`. The current
form method still performs the two locale-sensitive `StrToDate` validations
and parses the same original integer components before delegating; fallback
and exception behavior are unchanged. The helper preserves legacy day/month
borrowing, positive-fragment emission, exact `J`/`M`/`T` suffixes, and the
`OnlyYears` result. Seven focused synthetic tests cover same-date, month/year
boundaries, leap February, year-only output, and negative components; they
never call date parsing or any UI/provider route. Focused tests pass 7/7,
the full suite passes 572/572, the test project builds, and the main Debug
project builds. Evidence and the locale boundary:
`DevOps\ReverseEngineering\AhnWin52-Unit1-Date-Difference-Core.md`.

**Next:** screen remaining complete arithmetic/text helpers for boundaries
independent of RTL locale, provider, file, and UI state. Keep
`StrToDate`/`FloatToStr` semantics listing-only until authoritative runtime
settings are available.

## Unit17/19 corroboration of the Unit3 source-text normalizer

Static comparison of `Projects_AhnenWin\Unit17.pas:0053D06C` and
`Unit19.pas:00550DA0` confirms two independent copies of the transformation
already reconstructed from `Unit3.pas:00576FF8`. Both preserve the same
special-case order, exact tokens, fixed slices, nine-character repeated
`Copy`, and byte-based punctuation logic. Neither callee reads form, global,
dataset, file, or UI state. This strengthens the existing Unit3 helper
evidence; no duplicate helper or production wiring is needed. Its prior
focused suite passes 7/7 and the full suite had passed 536/536 at the
documented checkpoint. Full comparison:
`DevOps\ReverseEngineering\AhnWin52-Unit3-Source-Text-Normalizer.md`.

## Unit19 three-character integer helper

The static follow-up to the Unit17/19 normalizer comparison screened the
adjacent Unit19 helper cluster. `00550AB8` and `00550BFC` corroborate the
existing six-character zero-padding and byte-uppercase helpers. `00550B5C`
is a separate pure formatter: it prefixes three spaces to `IntToStr` and
copies a three-character suffix. Reconstructed as
`Forms\Unit19ThreeCharacterSpaceInteger.pas` with focused tests; it remains
unconnected to its database-backed report/list callers. The FPCUnit test
project builds and the focused suite passes 3/3. Evidence:
`DevOps\ReverseEngineering\AhnWin52-Unit19-Three-Character-Space-Integer.md`.

## Unit1 picture-output filename helper

The Unit1 helper cluster screen found an existing pure transformation at
`005FCB74`, called by the BMP-to-JPEG menu handler. It extracts the basename,
deletes the last three characters one at a time, then appends lowercase `jpg`;
the caller's dialog, directory changes, conversion, and output write remain
excluded. The current `TForm1.Proc_005FBFD8` already matches this listing.
Added focused tests for path stripping, unconditional three-character
replacement, short basenames, and empty input; only the helper is called.
The FPCUnit project builds and the focused helper class passes 3/3.
Evidence:
`DevOps\ReverseEngineering\AhnWin52-Unit1-BMP-to-JPEG-Name-Helper.md`.

The broader static screen also checked adjacent listing helpers in Units1, 13,
19, and 26.
Unit1 `005D3148`, Unit13 `005637C4`, Unit19 `00550AB8`, and Unit26 `0054F810`
all repeat the existing six-character zero-padded integer suffix formatter.
Unit13 `00563868` and Unit19 `00550BFC` repeat the byte-uppercase helper,
including the three executable-confirmed German-byte mappings. These are
corroborations, not new implementations.

The nearest distinct candidates remain blocked: Unit1 `005D39D8` uses
locale-sensitive `FloatToStr` with an unresolved low-level parameter
contract; `005D3A70` uses locale-sensitive `StrToDate`/`DaysInAMonth` and
suppresses conversion exceptions. No full-format-settings or caller contract
was established in this screen, so they remain listing-only. Details are
recorded in
`DevOps\ReverseEngineering\AhnWin52-Unit3-String-Helper-Inventory.md`.
Unit13's remaining nearby internals were excluded because they mutate shared
geometry arrays or depend on canvas/form state.

**Next safe step:** the application-source scan found no explicit locale
override; keep the date and numeric-format routines listing-only unless
authoritative runtime/locale evidence becomes available. Continue looking for
an independently testable, locale-free helper. Do not run the BMP-to-JPEG
menu action or its filesystem effects.

## Unit1 weekday mapping corroboration

The Unit1 `sub_005D7C50` listing confirms the existing weekday helper's
fixed `DayOfWeek` mapping (`So` through `Sa`) and empty result after a failed
`StrToDate`. The current helper and its tests already represent that mapping.
The original call-site date format is not known, and the independent caller
reads DataModule fields; neither the locale-sensitive parse nor the caller was
executed. No code or provider wiring was added. Details:
`DevOps\ReverseEngineering\AhnWin52-Unit1-Weekday-Abbreviation-Corroboration.md`.

The static search of application-owned Unit1..Unit40 listings, the original
DPR, and the current Pascal/LPR sources found no `ShortDateFormat` or
`DateSeparator` override. The DPR shows initialization and form creation but
does not resolve the RTL/OS locale active at runtime. The existing focused
weekday suite passes 3/3 with explicit temporary format settings.

**Next evidence task:** retain locale-sensitive `StrToDate`/`FloatToStr`
helpers as listing-only unless authoritative Delphi runtime or original
machine locale evidence becomes available. Continue with another retained
helper only when its full contract is locale-independent and caller-free.
Do not activate database, UI, file, report, or printer paths.

## Unit1 source-text normalizer reuse

Unit1 `sub_005D31EC` independently duplicates Unit3's reconstructed
source-text transformation at `00576FF8`, including branch order, fixed
slices, and byte-level fallback rules. The current
`TForm1.Proc_005D32CC` now delegates to `NormalizeUnit3SourceText` instead
of maintaining duplicate code. A synthetic parity test covers the special
branches and fallback edge cases. The focused main-form helper suite passes
4/4 and the standalone normalizer suite passes 7/7. No parser/provider caller
was run. Evidence:
`DevOps\ReverseEngineering\AhnWin52-Unit3-Source-Text-Normalizer.md`.

## Unit11 activation handler — counter reset test

The complete `TForm11.FormActivate` listing at `005CB49C` resets the shared
print-page counter to zero; both form resources bind `OnActivate` to this
handler. The current Pascal body already matches. Added one synthetic test
that seeds and verifies the reset while restoring the global afterward.
The focused Unit11 suite passes 6/6 and the complete FPCUnit suite passes
551/551. Drawing, printer, and database workflows are not invoked. Details:
`DevOps\ReverseEngineering\AhnWin52-Unit11-Activation-Counter.md`.

## Unit20 lookup-click focus handler

The DFM/LFM-bound `TForm20.dblookupcombobox1Click` listing at `005CC5A4`
transfers focus to `Edit1`; the current Pascal assignment matches. Added a
synthetic form/control test for the focus transition. The focused test passes
1/1 and the full FPCUnit suite passes 553/553. The separate
`FormActivate` handler binds `DataSource19` to the lookup and remains
unexecuted because it crosses the provider/data-source boundary. Details:
`DevOps\ReverseEngineering\AhnWin52-Unit20-Focus-Handler.md`.

## Unit20 cancel button — global modal target preserved

The DFM/LFM-bound `BitBtn2Click` listing at `005CC5CC` sets `mrCancel` on
the global `Form20`, not on `Self`; the current code preserves this legacy
target. Added a synthetic test with distinct receiver and global form
instances. `BitBtn1Click` remains excluded because its producer performs
provider-backed table operations including `EmptyTable`. Focused Unit20 tests
pass 2/2 and the full FPCUnit suite passes 554/554. Details:
`DevOps\ReverseEngineering\AhnWin52-Unit20-Cancel-Handler.md`.

## Static candidate screen after Unit20 — no new safe handler selected

The next resource-bound candidate screen checked the remaining retained
Units21–40 against their current implementations and tests:

- Unit21's grid sort/deletion actions use the FOKO dataset; its completion
  action traverses fields and updates modal state, and its other action
  configures a report preview or writes a text file.
- Unit22's parameter action opens and empties a table before rebuilding it.
  Unit23's synthetic report path and Unit25's report layout are already
  covered, but neither supplies a production dataset producer contract.
- Unit24's field-list controls have synthetic coverage. Unit26 includes a
  save-file dialog; Unit28/29/36/39 list workflows use database
  traversal/lookup. Unit30's activation/show path includes a Table38
  `FindKey`; Unit32 loads image files; Unit33's editor uses Table13; Unit38
  reads `foko.abk`.
- Unit27 `FormShow` only selects `RadioButton2` and focuses `Edit1`; it is
  already implemented and covered by
  `tst_AHW52_GedcomDialogCancelTests`. Unit34 activation prefill, Unit35
  option presets, and Unit37/40 local dialog actions likewise already have
  synthetic coverage.
- Unit31's retained IDR listing is present, but no current Pascal/resource
  source exists under `Source\AhnWin52`; do not reconstruct a production
  handler from a compiled artifact alone.

No new implementation or test was justified. During a separate synthetic
About-form click test, two Access Violation message boxes appeared. The user
confirmed both were Access Violations; the unverified test/code edits were
reverted, and that handler was not rerun. A build-only check of
`FPC\AhnWin52Tests.lpi` succeeded; no test suite was run in this follow-up.
The next action remains evidence-only screening for a fully bounded pure
helper; do not activate provider-, file-, report-, or UI-dependent behavior
without a synthetic contract and explicit safety boundary.

## Unit6 close handler — modal lifecycle adaptation

The original Form6 close listing restores `WindowState` to `wsNormal`, while
the current calendar resets `ModalResult` to `mrNone`. The original and
current menu routes both display the calendar modally and release it
immediately afterward; both ignore the returned modal result. Thus neither
closing-state mutation affects a caller decision or persists after disposal.
Retain the current LCL-neutral result behavior and document the difference as
a lifecycle adaptation, not exact listing parity. A focused synthetic test
verifies `mrOk` is reset to `mrNone`; the calendar lifecycle suite passes
3/3 and the full FPCUnit suite passes 552/552. Details:
`DevOps\ReverseEngineering\AhnWin52-Unit6-Close-Event.md`.

## Database structure template — catalogued, contracts still gated

The metadata-only `AhnWin52Backup.Core` structure manifest was normalized to
`DevOps\ReverseEngineering\AhnWin52-Structure-Template-Catalog.json` with
18 tables, 168 fields, and 32 secondary indexes. The manifest's baseline
payload was excluded and not read. Cross-reconciliation confirmed mappings
for Table9/13/14/16/22, but it contains no `alfls.db`/Table27 definition and no
relationship declarations. The repeated `Ort` entry in Table13's serialized
`Ort_` key fields is explained by the backup generator's convention of
appending the table's first field as the primary-key suffix; all 32 index
definitions passed that consistency check. The unresolved Table9 `Rufname`
length is 30 in the manifest vs. 40 in the current LFM. A static cross-check
of Unit2 and the current DataModule LFM now records Table27's seven persistent
field classes/order and available string sizes, but the LFM has no physical
index definition and does not specify `Kn`'s size. That component-only gap is
now resolved for the authorized test copy by BDE: `alfls.db` has seven fields,
`Kn` size 20, zero records, and indexes on `Nr;Dsn` (unique primary), `Dsn`
(`Ds`, non-unique), and `Namvorn;Geb` (`namvg`, non-unique). This does not
resolve the producer's source traversal, mode filters, output order, or failure
semantics. See
`DevOps\ReverseEngineering\AhnWin52-Database-Structure-Manifest-Reconciliation.md`.
Do not unblock relationship writes or the Table27 producer from schema
metadata alone.

## Unit3 string-helper triage — no new safe candidate

Reviewed the remaining string-parameter routines in
`Projects_AhnenWin\Unit3.pas` and string helpers in Units 1, 13, 17, and 18.
The pure formatters, source-text normalizer, and month mapper are already
reconstructed. Unit13 and Unit18 independently duplicate Unit3's source-text
normalizer instruction-for-instruction, corroborating that helper. The other
procedures either access fields/tables, read files, depend on global encoding,
or call locale-sensitive `StrToDate` while mutating global date parts. Unit1's
bytewise `ucase` candidate is now instruction-level characterized: it branches
on input bytes `$E4`, `$F6`, and `$FC`, compares each one-byte substring to a
literal, and appends a separate literal, while other bytes go through
`UpperCase`. Although the listing has lost the six literal byte values, the
user-supplied `C:\ProgramData\AHNENWIN Test\AHNWIN51.exe` confirms the exact
mappings `$E4->$C4`, `$F6->$D6`, and `$FC->$DC`. The `Source\Projects_AhnenWin`
Unit1/Unit3 listings are from IDR v.01.04.2017; the duplicate `TForm3.ucase`
has matching mappings. Implemented as standalone
`Forms\Unit1ByteUppercase.pas`, with focused tests for the three byte mappings,
mixed strings, ASCII `UpperCase` fallback, and empty input. The focused tests
pass 4/4 and the full suite passes 540/540. Exact Delphi `UpperCase` parity
for other high bytes remains unverified; no legacy caller is wired to this
helper. Details:
`DevOps\ReverseEngineering\AhnWin52-Unit3-String-Helper-Inventory.md`.

## Unit10 Easter computus — date core extracted, export path remains separate

The IDR `TForm10.rechnen` listing at `0055A54C` contains a deterministic
Gregorian Easter computus embedded in an XML export/UI routine. Extracted only
the bounded date calculation into
`Model\GregorianCalendarModel.pas::CalculateGregorianEasterDate`, retaining
the source-supported year range 1582–2499 and the epact corrections. Tests
cover known dates at reform/century boundaries and every supported year's
Sunday/date-range invariant. Focused model tests pass 7/7; the full suite
passes 543/543. Also extracted the subsequent date-only weekly sequence:
the actual loop emits 13 Sundays, Easter minus 63 days through Easter plus
21 days, inclusive. Though the fixed holiday-name string has 18 entries, the
loop reads only its first 13 slots (ending at Jubilate); no behavior is
inferred for the unused five labels. The focused suite passes 9/9 and the full
suite now passes 545/545. Neither helper is wired into the legacy export
path. The IDR loop also confirms a row format
`<tbl><tab>NAME</tab><tab><rb>dd.mm.yyyy</rb></tab></tbl>` and wraps only the
Ostern row in `<uesu>` tags. Added `Reports\Unit10EasterXmlRows.pas` as a pure
in-memory adapter producing those 13 rows plus the wrapper lines. The next
static comparison verified the remaining document lines and resolved the
conversion-comment mismatch against the supplied `AHNWIN51.exe`: the binary
contains the IDR's 5.1/2013 comment, not the current Unit10 Pascal constant's
5.2/2019 value. `BuildUnit10EasterXmlDocumentLines` now composes the complete
26-line document for supported years; focused tests pass 4/4 and the full
suite passes 549/549. This is still in-memory only: it does not reproduce
locale-sensitive `StrToDate`, Delphi text-file bytes/errors, invalid-year
partial output, UI, or browser behavior. Evidence and the source mismatch are
recorded in:
`DevOps\ReverseEngineering\AhnWin52-Unit10-Easter-Computus.md`.

## Unit9 About-dialog date formatting — locale contract retained

`TForm9.FormActivate` formats the executable/database date cells with
`DateToStr` before composing the two captions. The retained RTL listing routes
`DateToStr` through global format settings initialized from the active thread
locale; no fixed `ShortDateFormat` or `DateSeparator` assignment was found in
the retained application sources. Thus the formatting contract is
environment-dependent, and there is no justified constant-format helper to
extract. The synthetic AboutForm test pins `dd.mm.yyyy` for predictable
assertions and now restores `DefaultFormatSettings` afterward to avoid
cross-test state leakage. The AboutForm suite passes 4/4 and the full FPCUnit suite passes 549/549.
The target's active locale remains unverified. Details:
`DevOps\ReverseEngineering\AhnWin52-Unit9-About-Date-Formatting.md`.
Details:
`DevOps\ReverseEngineering\AhnWin52-Unit9-About-Date-Formatting.md`.

## Unit6 calendar-grid algorithm — independent listing corroboration

The complete `TForm6.Kal` listing at `005CDC40` independently confirms the
existing three-panel Gregorian grid projection: January/May/September start at
column 3, Sunday–Saturday map to rows 0–6, and the week column advances after
Saturday. Added an all-supported-years test for the three panel starts and
weekday mapping; the focused calendar-model suite passes 10/10 and the full
suite passes 550/550. This does not port the legacy UI routine: it reads the
year via form state, calls locale-sensitive `StrToDate('01.01.' + year)`, and
clears/populates StringGrids. Those effects remain excluded. Details:
`DevOps\ReverseEngineering\AhnWin52-Unit6-Calendar-Grid-Corroboration.md`.

A follow-up disassembly audit resolved `gridleeren`'s `SetCells` argument
order using the retained `Grids.pas`: on the streamed 28-column by 7-row
grids it clears visible columns 1–27 while preserving weekday-label column 0;
its writes to rows 7–8 are outside the visible grid and do not change
`RowCount`. `Kal` clears before it reads/converts the year, whereas the
current form validates the ViewModel/year before clearing. Successful redraws
have equivalent visible cell content, but direct-clear and invalid-year
failure states differ. The user explicitly accepts this as an intentional
improvement: an invalid year keeps the last valid calendar visible instead
of clearing it before conversion fails. This is documented as a deliberate
UX/robustness deviation, not exact legacy parity; no code change was needed.
Locale-sensitive date parsing remains a separate unresolved boundary.

## Static Unit15/Unit16 report-caller discovery — one route-specific field map

The independent `Projects_AhnenWin\Unit1.pas` listing contains six explicit
`TQuickRep.SetDataSet` assignments to `Form15.QuickRep1`. They do not share one
dataset contract: `spitzbas` binds Table27 (`$01F8`) to `QRDBText1=namvorn` and
`QRDBText2=kn`; `druck`, `geschachtelt1Click`, and
`Einzelpersonenmarkieren1Click` bind Table14 (`$00E0`) to `QRDBText1=zeile`;
`Vorlist` binds Table14 to `zeile`/`nm`; and the DFM-bound global-search action
`drucken1Click` binds Table16 (`$00EC`) to all fifteen text controls. The
last route's ordered fields are `name`, `nummer`, `gebtag`, `gebmonat`,
`gebjahr`, `gebort`, `sttag`, `stmonat`, `stjahr`, `stort`, `htag`,
`hmonat`, `hjahr`, `hort`, and `hname`.

The table/field identities are independently corroborated by
`Projects_AhnenWin\Unit2.pas` and the current streamed DataModule: Table14 is
`OUTP.db` with `Zeile`/`Nm`; Table16 is `over.db` with all fifteen mapped
fields (plus `Nn` and `Geschlecht`); and Table27 is `alfls.db` with `Kn` and
`Namvorn`. The original `Form15.dfm` has fifteen `QRDBText` controls whose
default `DataField` values are their component names, but no `DataSet` or
`DataSource`. Thus the global-search caller supplies a complete, specific
projection; it does not establish a generic contract for all Unit15 callers.
That caller shows `Keine Suchergebnisse vorhanden.` when Table16 is empty and
honors cancellation of its report-heading prompt before report setup.

The `spitzbas` route has a statically verified, route-specific pair: Table27
(`alfls.db`) maps `QRDBText1=Namvorn` and `QRDBText2=Kn`, corroborated by the
independent Unit1 caller listing, Unit2 component map, and current DataModule
LFM. However, `spitzbas` closes and empties Table27 before rebuilding it from
other tables through mode-dependent provider operations. Keep that producer
blocked; do not activate or test it against a database. Details are in
`DevOps\ReverseEngineering\AhnWin52-Unit15-Report-Caller-Discovery.md`.

## Unit3 month abbreviation normalizer — synthetic only

The retained `Projects_AhnenWin\Unit3.pas` listing at `00577544` maps the 16
tokens `JAN`, `FEB`, `MAR`, `MÄR`, `APR`, `MAY`, `MAI`, `JUN`, `JUL`, `AUG`,
`SEP`, `OCT`, `OKT`, `NOV`, `DEC`, and `DEZ` to `01`–`12`. Unmapped input is
trimmed and truncated to its first two characters. Seven calls in
`TForm3.zsa` pass three-character substrings to the helper. A read-only byte
check confirms that the retained `MÄR` token stores `$C4` between `M` and `R`.

Added `Forms\Unit3MonthAbbreviation.pas` and focused tests for every month
alias, fallback behavior, case sensitivity, and matching before trimming.
The helper remains standalone and is not wired into `zsa` or any
provider-backed data/report workflow. Evidence:
`DevOps\ReverseEngineering\AhnWin52-Unit3-Month-Abbreviation.md`.
The focused suite passes 3/3, and the complete FPCUnit suite passes 517/517.

## Unit3 numeric place-prefix reordering — synthetic only

The retained Unit3 listing at `0057893C` implements a two-string
transformation: preserve input unless its first character is a digit; then
move the text after the first space before the initial numeric prefix. It
uses `Length(Trim(input))` as the `Copy` count while slicing the original
input, so no-space input acquires a trailing space and some trailing
whitespace is retained. The standalone
`Forms\Unit3PlacePrefixReordering.pas` preserves these exact edge semantics.
Focused tests cover unchanged input, reordering, only-first-space behavior,
the no-space case, and leading whitespace. This helper is not wired into any
production UI/provider route. Evidence:
`DevOps\ReverseEngineering\AhnWin52-Unit3-Place-Prefix-Reordering.md`.
Focused tests pass 5/5; the complete FPCUnit suite passes 522/522. The test
project builds successfully.

## Unit3 six-character integer formatter — synthetic only

The pure routine at `Projects_AhnenWin\Unit3.pas:00576EB0` concatenates six
zeroes with `IntToStr(value)` and copies six characters from offset
`Length(concatenation)-5`. Thus positive values are zero-padded to six
characters, longer values lose leading characters, and negative signs retain
their literal position (for example, `-1` becomes `0000-1`). No call site was
found in the retained Unit3 listing, so only the routine's behavior is
documented; no caller or production integration is inferred.
`Forms\Unit3SixCharacterInteger.pas` and focused boundary tests were added.
Evidence: `DevOps\ReverseEngineering\AhnWin52-Unit3-Six-Character-Integer.md`.

The adjacent pure routine at Unit3 offset `00576F54` performs the same
six-character suffix extraction after prefixing six spaces instead of zeroes.
`Forms\Unit3SixCharacterSpaceInteger.pas` reconstructs this separately, with
tests for right alignment, truncation, and negative input. Its caller is not
identified in the retained listing; no production use is inferred. Evidence:
`DevOps\ReverseEngineering\AhnWin52-Unit3-Six-Character-Space-Integer.md`.

The static `Vorlist` route maps Table14 (`OUTP.db`) fields `Zeile` (memo) and
`Nm` (string) to `QRDBText1` and `QRDBText2`. Added a synthetic-only
`Unit15VorlistRows` adapter: memo content remains `ftMemo`, `Nm` is copied
through `DisplayText`, source order/bookmark are preserved, and remaining
report fields are blank schema placeholders. Its tests cover multiple rows,
multiline memo, display-text callback, empty/missing-field cases, and report
preparation. Focused Unit15 passes 16/16; full FPCUnit passes 500/500. The
legacy `Vorlist` producer remains blocked because its listing opens a dialog
and empties/rebuilds Table24, Table14, and Table27 through provider-backed
logic. No database or production report path was used.

Correction to the earlier discovery note: `TForm1.Famblatt` (`005FB604`)
opens Table38 (`$0530`) and selects index `tit`, then configures labels/images
and previews QuickReport. This routine contains no `QuickRep.SetDataSet`,
`QRDBText.SetDataSet`, or `QRDBText.SetDataField` call. Table38's current
resource identity (`sour2`) agrees with the independent component map; it is
not evidence of a Unit15 row projection. Unit16's own `FormShow` table opens
belong to its separate text/HTML export route, and its PDF handler consumes
the already-prepared QuickReport rather than resolving a source dataset.

Decision: retain the broad Unit15/Unit16 runtime integration block. The
global-search mapping has now been implemented as a **route-specific synthetic
adapter** in `Reports\Unit15GlobalSearchRows.pas`. It validates the source
dataset contract, copies all fifteen fields into caller-owned `QRDBText1..15`
rows, preserves the source cursor, and supports empty datasets. Focused tests
cover the complete field map, the current LFM's Table16 field types/sizes, and
nil/inactive/non-browse/missing-field failure cases, plus the
`DisplayText`-versus-`AsString` integer regression (13/13 pass); the test
project builds, and the full FPCUnit suite passes 497/497. These synthetic
tests do not exercise a production report.
Do not open `over.db`, wire the preview or PDF UI, or claim production
coverage. Caller dispatch,
input-dialog behavior, and runtime integration remain separate gates. Full
evidence and the mapping table are in
`DevOps\ReverseEngineering\AhnWin52-Unit15-Report-Caller-Discovery.md`.

### Unit15 empty-mask display-text trace

Static inspection of `Projects_AhnenWin\QRCtrls.pas` establishes that an empty
`TQRDBText.Mask` branches to `TField.GetDisplayText`; the numeric
`GetAsInteger`/`FormatFloat` path is reached only for a nonempty mask on a
non-string field. Neither `Form15.dfm` nor the global-search caller sets
`QRDBText2.Mask`, so the global-search report reads `DisplayText` for all
fifteen mapped fields. The synthetic projection now uses
`sourceField.DisplayText`. A regression test proves the `Nummer` mapping
preserves a synthetic `DisplayFormat` (`00101`) instead of unformatted
`AsString` (`101`). Production integration remains blocked; no provider,
database, legacy report, preview, print, or PDF path was run.

## Main-form tab callback audit — no new safe handler selected

Compared the existing ownership ledger, the main form's frame callback
assignments, relevant LFM bindings, and the current host/frame method bodies.
The remaining active bridges are `PersonEditFrame.TabSheet2Enter` to
`anzeigen(Self)` and the two `OnSaveRequested` callbacks from the person
navigator and text memo to `speich1`. The first remains provider-backed; the
other two are shared persistence. Keep all three boundaries unchanged.

`PersonEditFrame.TabSheet2Exit` and the LFM-bound `PageControl1Exit` currently
have empty Pascal bodies and no independently evidenced action to restore.
`TabSheet2Show` already performs its verified focus action in the frame.
Existing other no-op/listing-only routes remain inert as recorded in the
ownership ledger. Therefore this audit found no additional frame-owned
handler whose complete effects can be restored without entering provider or
write behavior. No speculative Pascal change or redundant test was added.
The unchanged tree passes 488/488 FPCUnit tests and builds
`AHW52_Main` in Debug mode. Reopen this item only with new complete listing
evidence for a bounded, provider-free handler.

## Table13 consumer inventory — completed screening

The only currently executable Pascal Table13 read in the main FPC application
is `TOrtsfamilienbuchOptionsForm.listanz`, already routed through
`IGenealogyDataModule.Table13` and `Table13Ort`. Other Table13 surfaces are
either resource-bound legacy UI paths with listing-only/no-op Pascal bodies,
or unbound assembly candidates; they are not safe to activate by adding an
interface property alone.

- `ComboBox20Exit` is streamed for three controls in
  `AHW52RelationshipsFrame.lfm` (six in the original main-form DFM); its
  current frame handler is empty. The retained legacy behavior performs a
  Table13 lookup and may append/post a missing location, then touches Table5.
- `TabSheet3Exit` is bound in the original main-form DFM. Its retained listing
  normalizes places through Table13 and continues into Table1/Table5 writes.
- `Unit14` binds `ListBox1DblClick` and `ListBox1KeyPress`; their listings use
  Table13 `FindKey`. The unit belongs to a separate FPC preview project, not
  the main FPC project.
- `Unit33` binds twelve DBEdit fields to `DataModule2.DataSource13` and binds
  `BitBtn1Click`; its listing includes Table13 lookup and mutation operations.
  Unit33 is not part of the main FPC project.
- `datsich`/`Sikoein`, `DBLookupComboBox4MouseDown`, and ten
  `PersonSearchForm` routines contain Table13-offset listing references.
  Their current bodies are listing-only; the named mouse/search routines were
  not found as direct DFM event bindings, so indirect reachability remains
  unresolved.

Do not restore lookup, append/post, edit, or delete paths until the original
key/index, provider, cursor, and failure behavior can be exercised through a
synthetic contract. The resource bindings and listings establish candidate
surfaces, not safe runtime semantics. No provider or live data was opened and
no production code changed. The Unit14 follow-up found that `FormActivate`
sets Table13's index to `ort_` before traversing `Table13Ort`. The independent
`Projects_AhnenWin\Unit14.pas` listing identifies the call at `0053C794` as
`TTable.SetIndexName`; the annotated AhnWin52 copy mislabels it as
`TSession.OpenDatabase`. The copied `.XG0` header labels the matching
secondary index `Ort_`, with indexed field `Ort` and ASCII collation. DblClick
and Enter trim the selected location and call `FindKey` with one string key.
This supports the key/index mapping, but both handlers ignore `FindKey`'s
Boolean result and continue to an unresolved `Show` target. BDE miss/cursor
behavior and any SQLDB equivalent remain unverified; do not restore the
handlers or substitute `Locate`.

### LOC test-copy metadata-only check

At the user's request, inspected only the authorized
`C:\ProgramData\AHNENWIN Test\LOC - Kopie.db` copy. It is 8,192 bytes; the
matching-base `.PX`, `.XG0`, and `.YG0` sidecars were subsequently copied.
Read only the first 64 bytes of the `.db` and the first 2,048 header bytes of
each index sidecar; no record blocks, BDE/pxlib provider, or live database
were accessed. The `.XG0` header identifies the `Ort_` index on `Ort`
(`ascii` collation), matching the runtime `SetIndexName('ort_')` call.
`FindKey` return/miss and cursor behavior remain unresolved. No
project/database file was modified.

## HEJ membership screening — close-only Table4/Table20/Table35

Compared the streamed resources and the independent
`Projects_AhnenWin\Unit2.pas` component map with the complete `datsich`
backup-writer and `Sikoein` restore-reader listings. `Table4` is `NUMRES.DB`
at `$0074`, `Table20` is `FOKO.DBF` at `$0158`, and `Table35` is `occ.db` at
`$0380`. Neither listing references any of these offsets; Table13's `ortv`
section remains an explicit contrast at `$00CC`.

The available HEJ evidence therefore does not place these close-only tables
inside the genealogy backup boundary. They remain concrete; non-membership
does not classify them as temporary. No database contents or provider were
opened, and no production code changed.

## HEJ membership screening — Table12 and Table37

Reviewed the complete retained `TForm1.datsich` and `TForm1.Sikoein`
listings against the streamed resources and the independent
`Projects_AhnenWin\Unit2.pas` component map. `Table12` is `NM.db` at legacy
offset `$00C8`; `Table37` is `ndh.db` at `$0520`; the approved place dataset
`Table13` is `LOC.db` at `$00CC`. Both HEJ writer and reader reference
`$00CC` in the `ortv` section, but neither references `$00C8` or `$0520`.
Thus the available HEJ evidence does not place Table12 or Table37 inside the
genealogy backup boundary.

This is an evidence result, not a temporary-data classification. Table12 and
Table37 remain concrete and are not added to `ITemporaryDataModule`. No
database contents, provider, or live genealogy data were opened.

## Latest data-access slice — Table13 place-list consumer

Added only `Table13: TDataSet` and `Table13Ort: TField` to
`IGenealogyDataModule`; the non-owning adapter delegates to the existing
streamed `LOC.db` table and persistent place field. The location arguments in
`TOrtsfamilienbuchOptionsForm.listanz` now use one local interface reference.
`Table12`/`Table12Name` and `Table37`/`Table37Hofname` remain concrete and
unclassified. The six `RefreshFieldLists` arguments, dataset traversal,
positive-value rule, and exception behavior are unchanged.

Adapter identity and the existing synthetic field-list tests pass; the full
suite passes 480/480 and the Debug main project builds and links. No live
place data or provider was opened.

## Latest data-access slice — active privacy Table7/Table8/Table9 consumers

Added `Table7`, `Table8`, and `Table9` as `TDataSet` properties on
`IGenealogyDataModule`; the non-owning adapter delegates directly to the
existing streamed tables. The three privacy-mode mappings now use
`RequireGenealogyDataModule`. The privacy workflow's dataset order and
enable/disable sequence are unchanged.

Adapter identity assertions cover the three properties, and the existing
privacy workflow tests pass unchanged (5/5). The focused interface suite
passes 14/14, all 480 FPCUnit tests pass, and the FPC main project builds and
links in `Debug` mode. No provider-backed filter, lookup, or live data was
used. Table7's streamed index/master relationship and all database semantics
remain untouched.

## Previous data-access slice — active Table17/Table18 consumers

Extended `IGenealogyDataModule` with `Table17` and `Table18` as `TDataSet`.
The adapter continues to expose the existing concrete `TParadox` components
without taking ownership or changing their initialization. The privacy-mode
lookup for `pdsTable17` and `TForm13.FormShow`'s `Table17.Open` then
`Table18.Open` sequence now use `RequireGenealogyDataModule`.

Adapter identity assertions and the existing synthetic FormShow recorder
cover delegation and open order; focused interface/privacy/graphic-form tests
pass 36/36, the full suite passes 480/480, and the FPC main project builds and
links in `Debug` mode. No actual Paradox file or genealogy records were
opened. `Table7`-`Table9` privacy access, Paradox/provider behavior, data
resolution, lookup/filter semantics, and graphic rendering remain unchanged.

## Earlier data-access slice — active basic Table5 marriage consumers

Expanded `IGenealogyDataModule` additively with `Table5: TDataSet` and
`Table5Numr`/`Table5Epnum: TField`, matching the active marriage close guard,
privacy filter reset, dataset close, and control suppression. The adapter
delegates to the existing streamed `MRG.DB` components; `DataModule2` remains
the sole resource owner.

Migrated all active direct `DataModule2.Table5*` operations in the main form to
`RequireGenealogyDataModule`. State and field-check order, privacy behavior,
Table1/Table5 control order, dataset close order, and error propagation remain
unchanged. Adapter identity assertions and the synthetic inactive-dataset
control test cover the interface path. All 480 FPCUnit tests pass, and the
FPC main project builds and links in `Debug` mode. No provider or live
genealogy data was opened. Marriage insertion/lookup workflows, provider
configuration, master-detail behavior, and other non-Table5 dependencies
remain outside this slice; `ITemporaryDataModule` remains empty.

## Earlier data-access slice — active basic Table1 consumers

Expanded `IGenealogyDataModule` only for the active, verified Table1 consumers:
`Table1`/`Table3: TDataSet` and `Table1Nummer`, `Table1Vater`,
`Table1Mutter`, `Table1Name`, `Table1Vornamen`, and `Table1Religion: TField`.
The adapter delegates each property to the existing streamed component; the
concrete `DataModule2` form remains the sole resource owner.

Migrated parent unlink, privacy current-person lookup/restore, close/post/backup
and Table1 close, person save/duplicate lookup, Table1 control suppression,
Details religion assignment, and the Unit13 person-number read to
`RequireGenealogyDataModule`. `Table3` is included only because the existing
person save workflow uses it for its duplicate-number check. At that point
Table5 and other non-Table1 dependencies remained concrete; Table5 has since
been migrated in the bounded slice above. `ITemporaryDataModule` stays empty;
neither slice classifies other tables or configures a database provider.

Adapter tests check the identity of each exposed dataset/field, the Details
frame writes through the interface, dataset-control behavior retains its
Table5 path, and Unit13's existing synthetic FormShow fixture now supplies the
parallel interface. The full FPCUnit suite passes 480/480, and the FPC application project builds
and links in its `Debug` mode. No provider or live genealogy data is used.

## Latest bounded data-access slice — PersonEdit checkbox refresh

Restored `TAHW52PersonEditFrame.DBCheckBox1Exit` from listing `00602068`:
the handler dispatches exactly one `Table1.Refresh` through the new
`IGenealogyDataModule.Table1: TDataSet` consumer boundary. The interfaces and
parallel global references live in `DataModules\GenealogyDataModuleAccess.pas`
because Pascal cannot declare a global variable with the same identifier as
its containing `GenealogyDataModule` unit. A second, separate
`ITemporaryDataModule` contract and `TemporaryDataModule` global provide a
future boundary for non-genealogy data that is not yet classified; it
currently has no members, and no non-HEJ table is presumed temporary. By the
user's domain definition, genealogy data covers the person, marriage,
adoption, place, and source records included in HEJ backups; their exact
component mapping remains a separate evidence task. The
concrete unit supplies non-owning reference-counted adapters; `DataModule2`
and all existing legacy callers remain unchanged.

Startup assigns both adapters only after concrete data-access initialization
and clears both interfaces in `finally` after `Application.Run`, before the
application-owned form is destroyed. Missing initialization or adapter input
raises `EDataModuleInterfaceUnavailable`; refresh exceptions propagate
unchanged. Seven new synthetic tests cover adapter delegation, invalid adapter
input, independent interface substitution, uninitialized access, and refresh
failure; the existing resource test verifies the LFM `OnExit` binding. The
focused PersonEdit suite passes 14/14, the full suite 479/479, and the forced
Debug main build links. No SQL driver/provider, live database, or genealogy
record was opened or configured. `Table1` remains typed to the capability
needed by this handler; future interface members are added only with verified
consumers.

## Latest maintainability slice — calendar menu controller

The LFM-bound Gregorian and French Republican calendar commands are now
proxies into `Forms\CalendarMenuController.pas`. The shared orchestration
preserves tab activation and save order, while the main-form adapter retains
the distinct view-model construction, `Free` versus `Release` semantics, and
the legacy French `Form7` reference window. Synthetic tests cover successful
ordering, sender forwarding, owner/view-model assignment, modal failures,
cleanup, and save failure before form creation. The focused controller suite
passes 6/6, the full FPCUnit suite passes 465/465, and the forced Debug build
links. No interactive dialogs or genealogy data were used. Calendar
calculations, rendering, printing, and other menu actions are unchanged.

## Latest bounded reporting slice — Unit16 text/HTML export

Translated the complete `TForm16.Speichernunter1Click` text/HTML writer into
`Reports\Unit16TextExportWorkflow.pas` and wired its FPC save action through
`ExecuteUnit16SaveDialog`. The exact text filter (including the space after
`(`), `txt` default extension, cancellation/trim guard, case-sensitive
`Pos('htm', FileName)` test, selector comparisons, HTML literals, separator
suffix, ancestor `<br>` lines, footer, and close/error behavior are retained.

The offset projections use `Table14.Nm`/`Zeile`, `Table22.No`/`Zus`, and
`Table27.Namvorn`; `Label2.Caption` supplies the list-caption test. The assembly producers for the address-named header aliases are now indexed,
but their listing-only callers do not yet write those values in active FPC
Pascal. `TForm19.nachf` is the evidenced producer of
`Unit19.GlobalVar_0061E028` (`ComboBox1.Text + ' von '`). The FPC adapter
requires that heading for a non-list `Nach` export instead of silently
emitting a blank line.

The global-search selector `Over` is an explicit different route: it binds
Table16 to Unit15, while this Unit16 text exporter has no `Over` row contract
and reads Table14/22/27 for its supported modes. Unsupported modes now raise
`EUnit16ExportOperationUnsupported` before writing; form validation rejects
them before creating the output file. Fifteen synthetic workflow tests pass.
All source failures remain visible: the streamed SQLDB tables have no
configured provider and no real data was opened. The full suite passes
496/496.

At the initial 2026-10-04 implementation checkpoint, synthetic coverage
passed 13/13 workflow tests and 23/23 Unit16 preview/action tests; the full
suite passed 461/461. `Unit16.pas` compiles in the test project. The forced
Debug main-project build links, but `AHW52_Main.lpi` does not include Unit16,
so this is not an end-user runtime claim. The unrelated Unit15 QuickReport/PDF
caller dataset remains blocked.

## Latest bounded helper slice — Unit13 graphic-text functions

Reconstructed `TForm13` listing helpers `005637C4`, `00563868`, and
`00563A0C` as provider-free functions in
`Source\AhnWin52\Services\Unit13GraphicTextHelpers.pas`. The implementation
preserves six-character suffix formatting, the explicit legacy ANSI umlaut
byte mappings, and the graphic-label branch order/fixed slices. The original
listings remain commented in `Unit13.pas`; typed Pascal adapters now call the
new functions but make no claim of Delphi 32-bit register-ABI compatibility.

The focused `TTestAHW52GraphicForm` suite passes 17/17, including over-width
and negative values, all three umlaut bytes, whitespace, special labels,
repeated nine-byte slices, digit bypass, and general dot/spacing behavior.
The complete FPCUnit suite passes 423/423, and the Debug main application
builds successfully.
`Projects_AhnenWin` resolves every direct helper call to `IntToStr`,
`UpperCase`, `Trim`, or `RightStr`; therefore no speculative unsupported
operation was added to this helper call graph. The layout-driven chart routines
remain listing-only and outside this slice.
The three original listings are retained, so the assembly-listing coverage
count is unchanged; their resource maps now record the resolved RTL targets
and explicitly distinguish those pure helpers from the non-ABI evidence.

## Latest isolated layout slice — Unit13 `0056CAD4`

The independent `Projects_AhnenWin\Unit13.pas` listing identifies the shared
graphic-record stride as `$198` bytes and the storage base as
`GlobalVar_011AE35C` (AhnWin52 address `GlobalVar_011AD35C`). The complete
`0056CAD4` listing reads 32-bit slots at entry offsets `$00` and `$14`, loops
over levels 2 through `GlobalVar_011AD328` inclusive, and examines
`GlobalVar_011AD344 - 1` adjacent entry pairs. If two adjacent entries have
the current level marker and the current offset-`$00` value is at least the
next value, the next value is incremented. Slot meaning beyond these
operations and the rest of the record remain unknown.

The bounded transformation is isolated in
`Source\AhnWin52\Services\Unit13GraphicLayoutModel.pas` as a typed projection
of those two integer slots. It is deliberately not wired to `TForm13` or the
legacy global layout array: that would require migrating and validating the
complete record storage. The original listing remains inactive. Recursive
propagation helpers (including the then-unresolved `0042E1EC` dependency)
and PDF-canvas/drawing routines remained outside this `0056CAD4` slice; the
isolated layout-family follow-up is recorded immediately below.

Five synthetic tests cover bounds, inclusive levels, adjacent-marker
matching, comparison branches, and live in-place update ordering. They use
only in-memory projections; they do not create a form, open genealogy data,
or render/print a chart. The focused suite passes 5/5, the complete FPCUnit
suite passes 428/428, and the Debug main application builds successfully.
The helper remains isolated; no original graphics call path was enabled.

## Latest isolated layout-family slice — Unit13 `0056897C`–`00569010`

The remaining six methods in the same layout family are now represented by
isolated operations in `Unit13GraphicLayoutModel.pas`:

| Listing | Reconstructed operation | Listing evidence |
|---|---|---|
| `0056897C` | Adjust projected slot `$04` through the binary-indexed entry run. | Signed integer branches, sibling slot `$00` comparison, and repeated in-place delta propagation. |
| `00568B04` | Adjust projected slot `$00` through the binary-indexed entry run. | Signed integer branches and repeated in-place delta propagation. |
| `00568C9C` | Reflow projected slot `$04`. | Selects a `Math.Power(2, depth - 1)`/`Round` start, checks slot `$04`, and dispatches `0056897C`. |
| `00568E3C` | Reflow projected slot `$00`. | Same traversal shape for slot `$00`, dispatching `00568B04`. |
| `00568FD4` | Select active-prefix maximum level and reflow slot `$04`. | Scans while slot `$08` is positive, keeps the greatest slot `$14` above its zero baseline, then calls `00568C9C`. |
| `00569010` | Select active-prefix maximum level and reflow slot `$00`. | Same selector, then calls `00568E3C`. |

The independent `Projects_AhnenWin\Math.pas` resolves the former
`0042E1EC` unknown call as `Math.Power`. The model projects only integer slots
`$00`, `$04`, `$08`, and `$14`; their meanings outside the observed
operations remain unknown. Explicit projection bounds are checked and
incomplete required tree entries raise `EGraphicLayoutProjectionBounds`.

The focused suite now passes 15/15 and the complete FPCUnit suite passes
438/438. The Debug main application builds. These methods are **not** wired
to `TForm13`, `GlobalVar_011AD35C`, or any caller. The historical listings
remain inactive; no database, PDF, canvas, printing, or chart rendering was
used or enabled.

## Latest bounded menu-handler slice — French Republican calendar

`TForm1.FrzRevolutionskalender1Click` is LFM-bound and its AhnWin52 listing
matches the independent `Projects_AhnenWin\Unit1.pas` sequence: activate
`TabSheet2`, invoke `speich1`, create the form formerly named `TForm7` with the
main form as owner, invoke its modal display, and release it in a finally
path. The class reference maps to the existing
`TFrenchRepublicanCalendarForm`.

The retained handler is now a short typed Pascal proxy in
`Forms\MainMenuActions\CalendarAndPictures.inc`. Virtual lifecycle seams keep
the production owner/modal/release behavior explicit and allow tests to
substitute an unstreamed form without opening a real dialog. The historical
listing remains in place. `Form7` is assigned during the modal lifetime for
the calendar's existing finish-button handler and cleared even if display or
release raises.

The focused menu lifecycle tests pass 2/2, covering the call order, tab
activation before saving, owner, valid `Form7` during display, and cleanup
after normal and injected-failure paths. The complete FPCUnit suite passes
440/440, and the Debug main project builds and links.

`Osterberechnung1Click` was inspected but not restored. Its listing sets the
`Oster` mode, activates `TabSheet2`, saves, then calls a virtual target through
`GlobalVar_0061E0AC` at unresolved VMT offset `$E8`. Although Unit10 has an
Oster-specific state path, the target's exact display/ownership behavior is
not established; no guessed show/close call was added. Unit13 PDF/chart and
provider-dependent paths are also outside this slice.

## Latest bounded Unit10 slice — Easter-year arrow controls

The LFM binds `TForm10.Button2Click` to the `<` button and
`TForm10.Button1Click` to the `>` button. Both AhnWin52 and independent
`Projects_AhnenWin\Unit10.pas` listings show a lexical comparison of the
trimmed `Edit1.Text` against `'1582'` / `'2500'`, followed (when the condition
passes) by integer conversion of the original, untrimmed edit text, a one-year
decrement/increment, and `Edit1.Refresh`. The independent SysUtils listing
resolves `00409448`, `004099B4`, and `00409950` to `Trim`, `StrToInt`, and
`IntToStr`.

Both arrow handlers are now restored in `Source\AhnWin52\Unit10.pas`.
`TryStrToInt` preserves the listing's no-change outcome for malformed or
whitespace-padded input without adding a broad exception handler. Tests also
lock down the lexical-comparison quirk: `999` passes the decrement gate, and
`19999` passes the increment gate. The focused suite passes 5/5; the complete
FPCUnit suite passes 445/445; the Debug main project builds and links.

The adjacent `Edit1Change` handler remains inactive because its valid range
calls `rechnen`, whose legacy workflow includes unported Easter calculation,
file/XML generation, and browser operations. The menu command,
`TForm10.FormShow`, calculator/export, printing, and save behavior remain
outside this slice.

## Assembly-listing statistics — 2026-10-03

The latest PascalAssemblyCoverage scan found 602/1,144 first-party class
methods still containing retained assembly listings (52.62%); 542/1,144 have
no recognized listing (47.38%). `Unit13.FormShow` now translates its
listing-backed initialization prefix and the proven field access while
retaining the original listing for unresolved rendering behavior. Scope is
`Source\AhnWin52` with the vendored `ThirdParty` subtree excluded. Newly added
support and compatibility methods remain in the denominator, so the
no-listing count does not mean those methods were reconstructed. The per-file
scan is
`DevOps\AhnWin-Assembly-Coverage-2026-10-03.csv`.

## Latest bounded helper checkpoint — `Proc_005D3AB8` — 2026-10-03

Audited the pure numeric formatter against its caller shape and the independent
sibling listing. The Pascal method takes one `Extended`, formats it with
`FloatToStr`, prefixes 25 spaces, and returns the rightmost 25 characters.
A new synthetic FPCUnit test creates the form without streaming its DFM and
checks the 25-character result for `42.0`. The focused test passes 1/1 and the
full suite passes 389/389.

This validates only the Pascal helper's output shape. Its remaining assembly
call sites are comments, so neither the test nor the build proves binary ABI
compatibility. Keep those call sites disabled until converted. No database,
report, password, licensing, or unknown-global path is involved.

## Evidence checkpoint — approved unpersonalized test directory — 2026-10-02

The user approved structural analysis of `C:\ProgramData\AHNENWIN Test` as an
unpersonalized test dataset. Its inventory includes Paradox/BDE table files,
the AhnWin executable, and `par.cfg` containing the product identifier.
`Unit2.dfm` itself is the source for the persisted `Table9` field schema,
including names, field types, and declared sizes. The `AWD.DB` header also
contains several matching field labels, but it is only corroboration and is
not needed to recover the DFM-declared schema.

The independent `Projects_AhnenWin\Unit2.pas` declaration gives the matching
object-layout offsets: `DataModule2.Table9` is at `$09C`, and its field
components run from `Table9Nummer` at `$874` through `Table9Rufname` at
`$940` in four-byte increments. Cross-referencing these offsets with
`frmAhnenWinMain.pas` disassembly identifies which named field components a
routine accesses. They are offsets within the decompiled data-module object,
not byte offsets in a Paradox record and not index definitions.

The user appended Pascal bodies for `Proc_005D7D30`, `Proc_005D32CC`,
`Proc_005D3228`, `Proc_005FBFD8`, and `Proc_005D3AB8`. Auditing their original
assembly in `frmAhnenWinMain.pas.bak` and callsites confirms the first four
receive their input in EAX and an output-string pointer in EDX. Their assembly
shape is therefore procedure-style input/output, although the user's
conversions express them as `TForm1` string-returning functions. Those
functions can be retained only as a high-level Pascal API with matching
converted callsites; they do not preserve the observed binary call ABI.

`Proc_005D3AB8` has a stronger mismatch: the caller at `00608A3A` puts an
output-string buffer in EAX and pushes a 12-byte floating-point value. The
routine passes the three stack words to the floating-point formatter, prefixes
25 spaces, and writes the final 25-character slice to that buffer. This
supports `function(Value: Extended): string` and not a procedure with two
integers and a word. The declaration and implementation have been adjusted to
`function(Value: Extended): string`; the other converted routines remain
high-level `TForm1` functions and do not preserve the legacy helper ABI. The
remaining assembly callsites are comments, so a successful project compile
does not establish runtime ABI equivalence.

The requested `AHW52_Main.lpi` build now succeeds. The first compile exposed
two malformed return declarations and unresolved decompiler helper names;
these were corrected using the complete `Projects_AhnenWin` RTL listings:
`Trim` and `ExtractFileName` from `SysUtils`, `RightStr` from `StrUtils`, and
`DaysInAMonth` from `DateUtils`. The main form's weekday method delegates to
the already-tested `DateWeekdayAbbreviation` helper, avoiding duplicate
production logic.

A read-only RAD Studio 3.0 BDE metadata probe compiled successfully and was
run only against a copy of `AWD.*` in a temporary directory. BDE denied opening
the table because a password is required. The approved source files were not
modified, no records were enumerated or displayed, and no password was guessed
or attacked. `dbexplor.exe` and `DataExplore.exe` are present but were not
launched; do not treat their presence as evidence that the password gate can
be bypassed. The protected table is not a blocker for reading the DFM field
schema. It does block optional validation of on-disk `namgeb`/`geba` index
definitions through the BDE. Subsequent read-only parsing of the approved
fixture's `.XG0`–`.XG7` headers in two verified snapshots recovered all eight
ordered fixture index field lists, including `namgeb` and `geba`; this is
separate from `Unit2.dfm`, which persists no `Table9` `IndexDefs`. BDE lookup,
cursor, and error behavior remain unresolved. The Unit15/Unit16 caller dataset
contract is a separate unresolved report boundary.

## Latest bounded restoration — date weekday abbreviation helper — 2026-10-02

Recovered the pure formatter called by the main form's `wt34` listing as
`Forms\DateWeekdayAbbreviation.pas`. It parses using the current regional
`StrToDate` settings, maps `DayOfWeek` values 1..7 to the evidenced German
abbreviations `So`, `Mo`, `Di`, `Mi`, `Do`, `Fr`, `Sa`, and returns an empty
string for invalid input. This behavior is recovered from the complete
independent `Projects_AhnenWin\Unit1.pas` listing at `005D7C50`.

Three synthetic tests cover all weekdays, invalid dates, and a non-German
short-date format. The focused tests pass 3/3; the full Lazarus suite passes
382/382. The standalone helper compiles under Delphi 7, RAD Studio 3.0, and
FPC. This restores the pure helper only: `wt34` still reads database fields
and updates `Label23`, and has not been wired to the new helper or exercised.
At that checkpoint, the BDE test-table password still blocked relationship
and report integration. The later authorized read-only catalogue below
supersedes the access blocker, but does not establish SQLDB parity or unblock
relationship/report integration. No test-dataset values were logged.

## Checkpoint — Table9 request contract and RemoteControl preflight — 2026-10-03

The approved fixture's `.XG0`–`.XG7` headers have now been decoded, so the
earlier unresolved-key-map statement below is superseded. Added
`Table9IndexDefinitions.pas` with the eight verified ordered field lists and
`intl850` collation. Added `PersonSearchLookupRequest.pas`; its person-search
name path builds the exact `geba` key prefix `Edit1` / Name, then `Edit2` /
Vornamen, as shown by `Button1Click` at `00583F0C`–`00583F6E`.

Replaced the old synthetic BDE-shaped contract—which preserved a current
cursor and returned the first duplicate—with a provider-neutral
`IIndexedLookupProvider`. It returns `not found`, one candidate, or an ordered
candidate list; malformed result shapes are rejected, and the provider cannot
expose an implicit BDE cursor. The candidate order is the future provider's
index order. This is approved replacement behavior, not an assertion about BDE.
No concrete lapParadox/pxlib provider has been wired yet; the schema unit is
fixture evidence and must not substitute for runtime metadata validation in
the provider.

The AhnWin52 index tests pass 15/15. The external utility now has a
`prepare-search` command that creates a versioned, non-executable manifest
from a saved dialog profile and supplied snapshot reference. It never starts
or queries the target process and sends no input. The observation result
records visible top-level state while explicitly not reading grid selection
or inferring a lookup outcome. Its synthetic suite passes 26/26, and the
utility builds without warnings. No live experiment was run.
The CLI preflight was also exercised with a synthetic saved profile and
verified that the manifest keeps `liveExecutionAuthorized=false`,
`snapshot.manualVerificationRequired=true`, and all three provider outcome
classes; it neither launched nor queried the original process.

Remaining work includes selecting and implementing the lapParadox/pxlib
provider from its actual available API, replacing the complete assembly-backed
dialog flow with UI-layer candidate selection, and separate user approval
before any live search. These are distinct from production relationship
writes, which still require an application-specific selection/cancellation
flow. The detailed design and constraints are in the session plan and
Paradox metadata how-to.

### pxlib provider API inspection — 2026-10-03

The user-provided pxlib 0.6.8 headers expose `PX_read_primary_index` and
`PX_add_primary_index`, plus generic record-number accessors such as
`PX_get_record`, `PX_get_record2`, and `PX_retrieve_record`. They do not expose
a secondary-index seek/FindKey API. FPC's `TParadox` wrapper delegates record
navigation to `PX_get_record` and likewise exposes no secondary-index lookup
operation.

The bundled `doc/paradox4.txt` describes `.XG` secondary-index data files as
one logical record per table record, with secondary key fields followed by
primary-key fields and a final `Hint` field. The C header/API therefore leaves
a plausible read-only implementation route—open/validate a secondary-index
file and traverse its records—but does not by itself prove the exact field
layout, stable ordering, collation comparison, or matching `.YG` tree behavior
for the approved AhnWin fixtures. Do not claim that `PX_add_primary_index`
handles a secondary index; its source validates a primary `.PX` file.

### Synthetic `.XG` logical-record probe — 2026-10-03

A one-shot fixture generator created a 4-KiB file with pxlib file type 6
(`pxfFileTypNonIncSecIndexG`) under the session `files` directory only. Its
five synthetic fields were `Surname`, `GivenName`, `PersonId`, `PersonPart`,
and a final two-byte `Hint`; three artificial records were written in an
intentionally preselected surname/given-name order. FPC 3.2.2 `TParadox`
opened the file and returned all five field names and all three records in
the stored field order, including the `Hint` values.

The SHA-256 was
`BD80AD491B3D7F295DD7F859000342C4FE29A771B2FD76B000D9C1F2097A660C`
both before and after the read. This validates generic, read-only
field/record access for this synthetic file type. Raw header inspection
reported `fileType=6`, `records=3`, `fields=5`, and `primaryKeyFields=2`;
pxlib 0.6.8 sets the latter to 2 unconditionally for this file type. Thus the
test does not establish how the header partitions secondary-key fields from
primary-key fields. Because the fixture was authored in the desired row order
and contains no matching `.YG` tree, it also does **not** verify pxlib sorting,
`intl850` comparison, `.YG` traversal, or BDE behavior. The actual approved
fixture was not opened.

Next provider spike: validate the `.XG`/`.YG` header and cross-file structure
using a second synthetic fixture with a corresponding tree, or implement a
dedicated read-only reader after confirming the required format details. Do
not connect generic `TParadox` record enumeration to the provider contract as
an ordered lookup until sort and candidate ordering are independently tested.
No live AhnWin run or genealogy-row inspection was performed.

### `.YG` generation and ordering boundary — 2026-10-03

The pxlib 0.6.8 source/API review does not provide a valid way to complete the
planned ordering experiment with its writer alone. `PX_write_primary_index`
builds only a list of source data blocks and record counts, then writes one
index entry per block using that block's first stored record. Its
`build_primary_index` routine walks the existing block chain; it does not
compare keys or sort records. `PX_read_primary_index` explicitly accepts only
file type `pxfFileTypPrimIndex` (type 1), and `PX_add_primary_index` likewise
requires a primary `.PX` index. The format note says a `.YG` file has the
same basic format as `.PX`, but this does not supply a secondary-index
collation/comparison or a tested `.YG` traversal API.

Consequently, generating a `.YG` from the already ordered synthetic `.XG`
would only mirror the order chosen by the fixture writer; it could not test
the source of that order or `intl850` comparisons. No surrogate pair was
created and no approved files were opened. Keep the tree/order validation
blocked until an independent documented builder/parser or authoritative
synthetic `.XG`/`.YG` fixture is available. The generic `.XG` row reader
remains useful for field access, but is not an ordered lookup provider.

## Checkpoint — wPDF DFM compatibility surface

`Source\Projects_AhnenWin` contains a partial wPDF export decompilation, not
the full WPTools editor/preview library. Added the separate
`Source\AhnWin52\wPDF\Components\WPPDFCompatibility.pas` component shim with the
Unit13/Unit16 DFM-backed enum values and published properties for
`TWPPDFPrinter`,
`TWPPDFExportInfo`, and `TWPPDFProperties`. Constructor defaults `Producer`
and `PreselectedCJK` follow the decompiled constructors. The `PDFAMode`
setter also restores the complete simple listing rule: selecting PDF/A Level
A changes the default TrueType font mode to embedded TrueType, while leaving
an explicit font mode unchanged.

`TWPPDFExportInfo.Assign` now copies the recovered metadata fields and
`Strings` collection. The listing does not copy `IsUTF8`, and the synthetic
test preserves that behavior. `Strings` uses a `TStrings` getter so its
published property remains compatible with Delphi 7 and RAD Studio 3.0.
`TWPCustomPDFExport.Info` also restores its listing-backed setter, which
copies into the component-owned metadata object rather than replacing it.

The synthetic test streams the Unit16 PDF component settings, including the
`WPPDFProperties1.PDFPrinter` reference and the three enabled mode flags.
Focused tests pass 6/6; the full Lazarus suite passes 360/360. The
compatibility unit compiles under Delphi 7 DCC32 and RAD Studio 3.0 DCC32.
The Unit16 Pascal unit itself compiles in the FPC test build after adding its
missing standard control units and correcting an `(*` sequence inside an
assembly comment that left the decompiled source comment unclosed.

Limits: constructing the whole Unit16 form still stops at the explicit
QuickReport compatibility exception `TQRPreview.Create`. The compatibility
unit supports the streamed property surface, the recovered metadata
assignment and setter, and one recovered option transition; it does not
implement PDF rendering. Unit13/Unit16 still depend on the external
`Ahnw50.dll` engine/license call. No licensing behavior was copied or
bypassed, and no PDF was written.

Lifecycle evidence is now mapped: Unit16's `SpeedButton4Click` calls the
printer's virtual `+40` start-document method, prepares QuickReport, loops
over report pages, calls virtual `+4C` with five page arguments, renders each
page metafile, calls virtual `+48` to close the page, and calls virtual `+54`
to finish the document. The listing's error strings confirm that page start
is only valid inside a document. The five page arguments remain opaque.

`wPDF\Engine\WPPDFEngineContract.pas` now defines an abstract, injectable
backend lifecycle. The component delegates document/page start and finish
operations to that backend, checks invalid transitions, and changes its
state only after a backend operation succeeds. Ten focused synthetic tests
pass, including operation order, multiple pages, invalid transitions,
missing-backend failure, and propagation/retry after backend exceptions. The
full Lazarus suite passes 364/364; both Delphi 7 and RAD Studio 3.0 DCC32
compile the contract and component units.

This seam is only a boundary for future implementation: the five page values
are still passed opaquely, the external engine is absent, and QuickReport
rendering remains unsupported. No fake backend is wired into Unit16 and no
PDF output is generated. Next, continue recovering the engine ABI and page
argument semantics from the independent Ahnw50/consumer listings without
adding those reference sources or licensing behavior to the AhnWin52 build.

Additional ABI evidence from `Ahnw50.dpr` and `WPPDFR1.pas` narrows the
contract without yet defining a usable adapter. The exports use `stdcall`;
the assembly cleanup sizes show six 32-bit arguments for
`WPPDF_Initialize`, one pointer for `WPPDF_Finalize`, four words for
`WPPDF_Action`, and three words for `WPPDF_InitializePage`. Initialization
returns a context pointer and rejects its fourth input when greater than 3,
but the argument meanings are not established. Finalize frees the context.
Action receives the context, action code, and two opaque words; its result is
an integer, with the caller checking zero for document start. The page
initializer receives the context, a second word not read in the recovered
body, and a pointer to a record; it returns a Boolean-like success value.

The `WPPDFR1` five-argument page method builds that record and passes its
first five values at offsets `0`, `4`, `8`, `0C`, and `10` to
`WPPDF_InitializePage`. Unit16 supplies two calculated report-page values,
then `0`, `254`, and `254`; their meanings and units remain unresolved. The
wrapper calls action `$11B7` only after page initialization succeeds.
Observed document/page action order is `$11B5` start document, `$11B7`
initialize page, `$11B8` finish page, `$11B6` pre-finalize document,
`$11B9` retrieve output stream, `$11BA` set filename, and `$11BB` finalize.
This is evidence for the façade call ordering, not authorization to load or
reimplement the external engine. Full ownership, per-action result, and
property signatures still require corroboration before an adapter is safe.

## Selected replacement direction — SynPDF + LazReport

The user selected SynPDF to replace the wPDF/Ahnw50 PDF engine and LazReport
to replace QuickReport. The official SynPDF README describes a standalone
Delphi library (Delphi 6+, no external DLL) with metafile rendering and a VCL
canvas. It is not a drop-in, source-compatible replacement for the recovered
wPDF component surface; use an adapter rather than importing the external
wPDF API or DLL.

The shared `Reports\ReportPdfContracts.pas` boundary now carries page
definitions, metadata, a page-source renderer, and an injected writer;
`ReportPdfFilePublisher.pas` atomically publishes completed output. The Delphi
provider is `SynPdfReportWriter.pas`, built from SynPDF commit
`15749968e294f5e86fe1a36b117827ee9fdd648a`. For Windows FPC/Lazarus,
`MormotPdfReportWriter.pas` uses `mormot.ui.pdf` from mORMot2 commit
`1f37f3a44bef4f9c2f935b9d3a11855b50a7fe86`, following SynPDF's README
recommendation. Both consume the same LazReport prepared-page contract; the
legacy wPDF opaque page arguments are not part of it.

The Unit23 `TFokoListReportWorkflow.ExportToPdf` slice has produced and
validated synthetic PDF output. Focused writer tests pass 3/3, Unit23 tests
pass 9/9, and the full Lazarus suite passes 369/369. DCC32 version 7 and
RAD Studio 3.0 probes validate the SynPDF backend; Lazarus/FPC validates
mORMot2 output. The probes cover two pages, A4 portrait/landscape dimensions,
title metadata, and rendered synthetic canvas text.

This output boundary is not wired to a production export button/dialog and
has not been exercised against real genealogy data. Unit16's QuickReport
print/save/PDF workflow and remaining layouts are still open. Keep Ahnw50
reference-only; do not load its DLL or carry its license-code call forward.
The vendored notices choose the LGPL 2.1 option for each backend; review
license delivery and linking/replacement obligations before redistribution.

Source: [SynPDF official README](https://github.com/synopse/SynPDF).

## Latest checkpoint — Unit15 report-to-PDF extension

`TUnit15ListReport` now implements the shared `IReportPageSource` contract,
exposing prepared EMF pages, A4 dimensions/orientation, and canvas rendering.
Its `ExportToPdf` prepares the recovered Unit15 LazReport template and writes
through the injected provider/atomic publisher. Synthetic tests export two
rows and check signature, requested title, page dimensions, and caller cursor.
Focused Unit15 tests pass 6/6; the full Lazarus suite passes 371/371.

The Unit15 DFM does not establish a `DataSet` or `DataSource` binding, and its
fifteen `QRDBText` names do not establish the real field semantics. Searches
of the reconstructed Unit1, Unit15, and Unit16 Pascal sources found no
explicit assignment to those fields or `Form15.QuickRep1`. This
does not yet wire Unit16's PDF button, replace its UI, remove QuickReport
dependencies, or retire Ahnw50 references. Continue with source/resource
evidence for the real dataset contract before integrating the caller.

## Previous checkpoint — Unit23 report-to-PDF vertical slice

The synthetic Unit23 handoff now prepares the embedded LazReport using
caller-owned test rows and exports the prepared pages through an injected
`IReportPdfWriter`. A shared temporary-file publisher prevents partial output
from replacing an existing destination. Delphi and FPC/Lazarus use separate
providers behind the same contract: SynPDF and mORMot2 respectively.

At that checkpoint, the FPC test project passed all 369 tests. Focused PDF
writer and Unit23 workflow suites pass 3/3 and 9/9. Delphi 7 and RAD Studio 3.0 DCC32
both compile/run the SynPDF probe; its PDF and the FPC/mORMot2 PDF pass
structural checks for signature/EOF, page count, ordered A4 dimensions,
metadata, and synthetic canvas text. No Unit16/product UI or real data path
is claimed. See `AhnWin-LazReport-Migration.md` and the CodeWiki how-to for
the detailed scope and licensing notes.

## Latest checkpoint — integrated Unit18 text export

Restored `TForm18.speichern` as an injectable save workflow: it preserves the
listing's dialog filter/cancel/default-extension order, formats and traverses
`DataModule2.Table16` through source/writer interfaces, and writes the header,
separator line, and data rows. The exact header was recovered from
`AHNWIN51.exe` at file offset `0x1457E8`; PE mapping gives VA `0x5463E8`,
matching the string reference in the Unit18 listing. The data adapter maps
the DFM-evidenced `Nummer`, `Name`, `Geb*`, `St*`, and `H*` fields without
guessing the `H*` business labels.

The FPC test build now succeeds and the complete suite passes 354/354,
including seven dialog/orchestration tests and eight export tests. Synthetic
tests use fake factories/data; one isolated writer test creates and removes a
temporary file. RAD Studio DCC32 version 17.0 compiles the save workflow,
dataset adapter, and VCL dialog adapter. No real genealogy dataset or actual
save dialog was used. The subsequent Lazarus rebuild also fixed a duplicate
implementation `uses` entry and added the missing `Classes` test dependency.

Remaining validation boundary: the full native application is still blocked
by unavailable legacy project units and QuickReport/WPTools dependencies.
Do not claim database-backed, interactive-dialog, or end-user application
behavior based only on these isolated tests.

## Latest checkpoint — Unit16 shared address counter

Translated the complete short listings in `TForm16._PROC_0055E5BD` and
`TForm16._PROC_0055E5EC`: increment and decrement the same 32-bit cell,
`$0061E0C4`. `Reports\Unit16AddressCounter.pas` retains the address-based
global name because the counter's domain meaning is unknown. The callbacks
delegate to this helper; neither a DFM/LFM event binding nor a Pascal caller
was found, so reachability is not claimed.

Six synthetic tests cover ordinary increments/decrements, crossing zero,
and both signed `LongInt` wraparound boundaries. The focused suite passes
6/6, full Lazarus suite 340/340, and the helper compiles with Delphi 7 DCC32
and RAD Studio 3.0 DCC32. `Unit16.pas` still cannot be compiled in the
available project because its QuickReport dependencies are missing; only the
independent helper is compiled/tested. The current scan is 615/1,094 methods
with retained listings (56.22%); Unit16 is 13/29 (44.83%). Structural
listing counts do not measure behavioral coverage.

## Previous checkpoint — Unit18 save-button boundary

Restored the DFM/LFM-bound `Button7Click` order from the complete listing:
call `speichern(Sender)`, then show the exact Excel instruction. The sender
and ordered actions are isolated in `Unit18SaveButtonWorkflow` and tested
with recording callbacks.

The `speichern` listing still contains untranslated dialog, dataset, and
file-output logic. It now raises `EUnit18SaveOperationUnsupported` before any
I/O, so the restored button wrapper cannot report a completed save or show
the follow-up hint after the untranslated method returns. No dialog or file
was used. The form-resource declarations also established that Button7 and
Button1 are `TButton`; their Pascal field declarations and unstreamed fixtures
were corrected from `TSpeedButton`.

Focused tests pass 4/4; the full Lazarus suite passed 334/334 at that
increment. Both Delphi 7
DCC32 and RAD Studio 3.0 DCC32 compile the isolated workflow and error units.
The scan at that increment was 617/1,094 methods with retained assembly
(56.40%); Unit18 was
7/32 (21.88%). These remain structural listing counts, not behavior coverage.

## Candidate screen — remaining short handlers

The next small Unit16 candidates are not isolated workflows: `FormCreate`
calls the unavailable WPPDF licensing/configuration APIs using embedded
identity/key strings, and its trailing callbacks have no recovered resource
binding. Do not invent a PDF vendor contract or test with real licensing data.

`Unit27.SpeedButton1Click` is resource-bound but combines global cursor and
form mutations with dispatch into `TForm3.gedaus`/`gedausv` according to
address-backed global strings. Those routines are provider/report paths, so
the handler cannot be safely invoked or translated as a self-contained
synthetic slice without understanding the BDE data contract. Continue screening
for a complete handler whose effects do not cross these boundaries.

### Completed approved slices — Unit14 place search and Unit11 metrics

`TForm14.Button1Click` (`0053B964`) is restored as a person/event place
search, distinct from Unit14's still-listing-only Table13 listbox selection
handlers. It reads person-place fields `Gebort`, `Taufort`, `Stort`, and
`Begort` from `Table1`, and marriage-event places `Saort` and `Schort` from
`Table18`, through `IGenealogyDataModule`. It preserves exact and partial
matching, formatted result rows, duplicate-event suppression, and restoration
of the current person with `TDataSet.Locate`. Seven synthetic search tests
passed. Provider-specific `Locate` behavior and the old `namgeb` index order
remain unverified; do not claim BDE ordering parity.

`TForm11.FormCreate` (`005CB380`) now reads `Printer.PaperSize`, printable
page dimensions, and printer DPI instead of opening a GDI printer handle.
Physical paper extents are converted from the printer's coordinate units to
millimetres using `XDPI`/`YDPI`, then truncated to whole centimetres as the old
`HORZSIZE`/`VERTSIZE` values were; printable pixel extents are divided by
those centimetres to populate the six listing-identified globals.
The screen baseline globals are initialized in `TForm1.FormCreate`; a
standalone Form11 preview falls back to its current screen and host form.
The canvas field is resolved as `PaintBox1.Canvas` from the streamed
`TPaintBox`. A synthetic metrics record isolates all arithmetic and scaling
from live printer/screen reads; focused tests cover printer ratios, form
bounds, canvas/global state, screen-change scaling order, and invalid input.
All five focused tests pass; the full FPCUnit suite passes 487/487. The
isolated Form11 and Debug main projects build. No printer was opened for
testing and no print job was issued.

The Lazarus printer backend's physical-size rounding, selected-paper behavior,
and visual parity of `ScaleBy` are not established against the original
Windows driver. `TForm11.SpeedButton2Click` remains a separate
printer/graph-rendering workflow and was not activated.

Other screened handlers remain outside this completed slice:
`TForm16.FormClose` (`0055DC1C`) couples QuickReport cleanup and a
record-count-dependent mutation of the main form's `DBText1.Color`;
`TForm10.Edit1Change` dispatches to browser/file-backed `rechnen`. Unit14's
`ListBox1DblClick` and `ListBox1KeyPress` still use the separate unresolved
BDE `Table13.FindKey` path.

### Unit14.FormActivate — Table13 place-list activation restored

Restored the DFM/LFM-bound handler's sequence: save a nonnegative list index,
clear `ListBox1`, request `ort_`, traverse Table13 from `First` through EOF
while adding `Table13Ort`, restore the saved selection, and focus the list.
`IGenealogyDataModule.SetTable13Index` maps only the evidence-backed `ort_`
name to `Table13.IndexFieldNames := 'Ort'`; unknown names raise
`EUnsupportedGenealogyDataIndex`. The adapter test verifies this mapping on
the closed streamed table without opening it.

The FormActivate fixture sorts an in-memory Table13 dataset before traversal.
The two existing tests that show Form14 now provide synthetic `Dresden`
Table13 data as well: activation runs from the LFM event binding before those
tests invoke the search. This prevents the fake module's missing-index
capability from raising a modal error during test setup. Eight Unit14 place
search/activation tests pass, the adapter suite passes 14/14, and the full
suite passes 488/488. The `AHW52_Main` Debug build links. No provider, live
place data, or real genealogy records were opened.

The `.XG0` header confirms ASCII collation for `Ort_`; exact BDE-versus-SQLDB
collation parity remains unverified. The standalone Form14 preview still
does not create a DataModule. Its attempted build is currently blocked by
`PrintersDlgs` unit resolution in the existing Unit13 dependency; test-project
compilation covers the restored handler.

### Unit14 place-selection handlers — editor target resolved; BDE gate remains

The independent `Projects_AhnenWin\Unit14.pas` listing names the target global
at `$0061D234` as `^gvar_0061EFAC:TForm33`. This is corroborated by
`Unit33.pas` and its DFM: field offset `+$034C` is `TForm33.Label12`, and
`TForm33.FormActivate` copies the selected `Form14.ListBox1` item into
`Edit1.Text`. The `AHNWIN51.dpr` registers both `Unit14` and `Unit33`, so the
activation prefill is part of the same original application composition.
Therefore the DblClick/Enter post-lookup UI operation is specifically to set
`Form33.Label12.Caption` to `Aktueller Orts-Name: ` plus the selected location
and show `Form33`; it is not an unresolved arbitrary form anymore.

This resolves only the target-form mapping. Both handlers still call
`Table13.FindKey` on the BDE `LOC.db` table before that UI operation. The
Boolean result is ignored, but provider exception/current-row behavior and the
effect of an empty or missing key are not established for SQLDB. The
compatibility layer explicitly rejects `FindKey`; do not bypass that failure,
replace it with `Locate`, or wire the editor until a synthetic lookup contract
preserves the observed ordering and failure semantics. No provider or records
were opened during this follow-up.

### Unit14 resource-bound event inventory — no additional safe slice

Cross-checked every event in both `Unit14.dfm` and `Unit14.lfm` against the
current Pascal bodies and the independent `Projects_AhnenWin\Unit14.pas`
listing. The complete surface is accounted for:

- `FormActivate` restores the selected place list through Table13; this is
  implemented and covered by the synthetic place-search tests.
- `Button1Click` performs the separate person/event place search; it is
  implemented through the data-module interface and covered by synthetic
  tests.
- `BitBtn1Click` resets the saved/list selection and closes the form; this is
  implemented and already documented with its synthetic coverage.
- `ListBox1Click` copies `ItemIndex` to the saved selection cell; the
  independent listing at `0053C850` confirms the assignment, and the current
  Pascal body and test preserve the `-1` no-selection value.
- `ListBox1DblClick` and Return in `ListBox1KeyPress` both depend on the
  unresolved `Table13.FindKey` contract before opening `Form33`; keep them
  listing-only.
- `Button2Click` dispatches to `TForm1.Lb_speich`; it remains on the shared
  persistence boundary and is not a local UI-only handler.

`CheckBox1` has no event binding. Thus Unit14 has no unclassified,
provider-free resource-bound handler left to restore. No source or test
change is justified until the BDE lookup contract or a different complete,
independent listing becomes available.

## Interpreting assembly coverage

The initial 2026-10-03 first-party scan reported 603/1,142 methods still
containing retained assembly (52.80%). After restoring
`Unit13.SpeedButton12Click`, the report recorded 602/1,142 (52.71%). The
latest `Unit13.FormShow` increment adds the bounded
`TouchGraphicPersonNumberField` helper while retaining the handler listing:
602/1,144 (52.62%) still contain listings and 542/1,144 (47.38%) do not. The
complement is not a count of original methods reconstructed. The scan covers
`Source\AhnWin52` and excludes vendored `ThirdParty` Pascal. Its denominator
includes newly added support methods and compatibility units. Compared with
the 2026-10-02 report (615/1,094), both the source set and denominator changed,
so the difference is not a direct count of restored original methods. The
dated per-file report is
`DevOps\AhnWin-Assembly-Coverage-2026-10-03.csv`.

## Implementation strategy

Optimize for recovered behavior, not for a favorable coverage percentage.
Long methods may be restored in evidence-backed Pascal slices: isolate a
well-understood branch or state transition, preserve its ordering and
side-effects, and validate that slice with synthetic tests before continuing
to the next block. Keep each slice useful in the application path where its
contract is known; do not count newly added helpers or untouched Pascal as
restored original routines. If a method's dependencies are still opaque, keep
the boundary explicit and move to another independently provable block.

## Previous checkpoint — report counter callbacks

Restored four complete report-form listings, each consisting of a decrement
of one address-backed 32-bit global: Unit5 `$0061DFA0`, Unit15 `$0061DF14`,
Unit23 `$025358D0`, and Unit25 `$0061E0DC`. The names retain the addresses;
the counter semantics and consumers remain unknown.

Synthetic tests call the actual methods on unstreamed forms and verify a
nonzero decrement and the unclamped `0 -> -1` boundary. No DFM/LFM binding or
reconstructed Pascal caller was found, so runtime reachability is not claimed.
Focused tests pass 4/4; the full suite passes 330/330. Coverage is 618/1,093
(56.54% still containing listings); each of the four report units is now 0/2.
These are structural measures, not behavior coverage.

## Previous checkpoint — Gregorian calendar print handler

`btnPrintKalenderClick` is DFM/LFM-bound and its complete listing now maps to
the original control sequence: hide the follow-year button, realign the
previous-year button, hide the OK and print buttons, call `TCustomForm.Print`,
then show all four controls in the same sequence. The previous-year button
remains visible while the print action runs; this is explicitly asserted by
the injected-action test.

The FPC event path raises `EGregorianCalendarPrintUnsupported` before
accessing controls or opening a printer. The helper/error units compile with
both available DCC32 versions. The focused tests pass 2/2 and the full suite
passes 326/326. Actual printer output and visual parity remain unvalidated.
Direct RAD Studio compilation of the full calendar unit remains blocked by
pre-existing `EInvalidOpException` and Lazarus-style `MessageDlg` references.
The refreshed listing scan is 622/1,093 (56.91%); `Forms\GregorianCalendar.pas`
is 0/17 with retained assembly. The denominator includes the new
`PrintCalendar` and exception-constructor support methods.

## Previous checkpoint — Unit16 preview controls and report dispatch

Restored the four DFM-bound page-navigation handlers, the page-count callback,
and the shared page-status update from the complete x86 listing. The DFM binds
all four buttons. The callback's second register argument (`ECX`) is the total
page count; the translated callback signature now reflects that evidence.
`PreviewPageCount` gives the legacy shared count cell a domain name. The page
transition rules live in `Reports\Unit16PreviewActions.pas`, and the handlers
still call `TQRPreview.SetPageNumber` so the FPC compatibility layer reports
that its actual preview behavior is unsupported.

The DFM-bound `SpeedButton2Click` and `SpeedButton3Click` wrappers now forward
`Sender` to `Drucken1Click` and `Speichernunter1Click`; a recording callback
tests the shared dispatch helper without opening dialogs or invoking printer/
file I/O. `Drucken1Click` now restores the print-dialog bounds and accepted
range dispatch to `Form15.QuickRep1`'s printer settings. Independent IDR type
offsets and Unit15 DFM property names corroborate the mapping. Its FPC path
raises the explicit unsupported-print exception; no real dialog or printer
has been exercised.

`Quickreport1NeedData` now uses the two-argument QuickReport callback ABI,
increments its per-form page counter, and sets `MoreData` from the recovered
printer-page-count comparison. The transition is synthetically tested. Its
FPC path explicitly rejects the unavailable printer page-count operation.
No resource binding or source assignment exists in the reconstructed tree;
runtime reachability is unknown.

`Speichernunter1Click` now applies the listing-backed text-only filter and
`txt` default extension, returns on cancellation or a filename that is blank
after trimming, and raises a named unsupported-export error for an accepted
nonblank path until the long export body is translated. FPC fails before UI;
the synthetic tests do not show a dialog or create a file.

`FormKeyDown` is restored from its complete listing with the ABI-correct
`TKeyEvent` signature: Escape closes the receiving form and other keys leave
it alone. No Unit16 DFM/LFM binding or source assignment was found, so runtime
reachability is unproven. Its key predicate is covered synthetically.

Twenty synthetic tests pass for page transitions/bounds, status formatting,
Escape-key recognition, NeedData counter boundaries, save-dialog setup and
filename checks, print-dialog initialization, zoom selection, exit-button
dispatch, and report-action sender forwarding. The focused suite passes 20/20
and the full suite 324/324.
Both Delphi 7 DCC32 and RAD Studio 3.0 DCC32 compile and run a smoke program
against the actual `Unit16PreviewActions.pas` helper, using their matching
RTL `Lib` directories.

The full native project still cannot be built from this tree: the legacy
`AHNWIN51.dpr` has stale relative source paths, and its referenced `Unit1.pas`
and `Unit9.pas` are absent from `Source\AhnWin52` (they belong to the separate
`Projects_AhnenWin` decompilation). Do not combine decompiler variants merely
to force a build. A separate DCC probe of `Unit15` also stops at missing
`QRPrntr.dcu`; the installed RAD Studio libraries do not contain the complete
QuickReport units. The Lazarus test project builds, but does not compile
`Unit16` because its WPTools PDF
dependency has not been shimmed. No QuickReport rendering, callback UI,
actual zoom, print, PDF, export, or output parity is claimed. Remaining
assembly is in 623/1,091 scanned methods (57.10%). `Unit16.pas` is 15/29
methods with retained listings (51.72%), down from 29/29. These are structural
listing counts, not a measure of application behavior restored.

The remaining main-form and PersonSearch `showpreview` wrappers are
listing-only. Neither has a DFM/LFM event binding, and both load their initial
page count from shared cell `0061E0B8`, whose producer has not been recovered
in the Pascal sources. Do not infer a binding or substitute a guessed
`TQRPrinter` page-count property. These caller and preview-integration paths
remain deferred; the WPTools components are also unavailable in the isolated
build.

## Latest checkpoint — Unit15 LazReport layout

Unit15 shares Unit5's A4 portrait, single-column bands and fifteen
DFM-named `QRDBText` fields, with two enabled and thirteen disabled. Its DFM
positions the header caption and printed date slightly differently and adds
an empty fourth QRImage; those images have no evidenced producer or embedded
picture data and are excluded. The new embedded `Reports\Unit15ListReport.lrf`
uses a distinct `Unit15Rows` alias and preserves the evidenced layout offsets.
No production caller or field semantics were found in the reconstructed
source.

Four synthetic tests verify template bindings/visibility, preparation,
bookmark and ownership preservation, schema rejection, and the Unit15 form
factory. The project builds and all 304 tests pass. No database, preview,
printer, export, or rendered-output comparison was used.

Assembly remains in 637/1,090 methods (58.44%; complement 41.56% without
listings, not necessarily reconstructed); Unit15 is 1/2 assembly-backed and
`Reports\Unit15ListReport.pas` is 0/6. The next major
QuickReport path is Unit16's preview/PDF integration; its WPTools dependency
and preview behavior require separate evidence before attempting migration.

## Latest checkpoint — Unit5 LazReport layout

The Unit5 DFM establishes an A4 portrait, single-column report with page
header/detail/footer bands, two header captions, fifteen named DBText
components (two enabled, thirteen disabled), an empty `QRMemo1`, date and
page-number fields, and three empty QRImage components. The FPC form now uses
an embedded `Reports\Unit5ListReport.lrf` template and a builder that validates
the fifteen DFM field names against an already-active caller-owned dataset.
There is no evidenced production caller or semantic mapping for the field
placeholders; empty image components are omitted.

Four synthetic tests verify the layout, binding alias, field visibility,
two-row preparation, bookmark and ownership preservation, missing-field
rejection, and form factory. The Lazarus test project builds and all 300 tests
pass. No database, preview UI, printer, export, or rendered-output comparison
was used. The canonical app build remains blocked at deferred `QRPrgres`.

Coverage is 637/1,083 methods containing retained assembly (58.82%); Unit5 is
1/2 assembly-backed and `Reports\Unit5ListReport.pas` is 0/6. Unit15 remains a
separate candidate because its DFM has small layout differences and an
additional empty image component; its caller and field semantics remain
unproved.

## Latest checkpoint — Unit25 LazReport layout

`Unit25.dfm` establishes an A4 portrait, two-column QuickReport with page
header/detail/footer bands, two visible data fields, six disabled data fields,
the `QRLabel1` caption placeholder, date/page-number footer fields, and three
empty image components. Its bounded replacement is an embedded
`Reports\Unit25ListReport.lrf` template loaded by
`Unit25ListReportTemplateResource.pas`; the report builder binds a
caller-provided active dataset under the template alias and preserves its
current bookmark during preparation.

Four synthetic tests cover template objects and bindings, two-row preparation,
caller dataset ownership/cursor state, required-field rejection, and the
Unit25 form factory. The project builds and the full suite passes 296/296.
There is no evidenced Unit25 production caller or semantic mapping behind its
placeholder field names. The empty image controls are excluded. Preview,
printing, export, production data, and output parity are not implemented or
validated. The application build remains blocked at deferred `QRPrgres`.

Coverage is 637/1,076 methods with retained assembly (59.20%); `Unit25.pas`
is 1/2 assembly-backed and `Reports\Unit25ListReport.pas` is 0/6. The next
reporting candidate must be selected from the remaining QuickReport resources
only after its DFM fields and caller contract are independently evidenced.

## Latest checkpoint — Unit21 FOKO LazReport preview dispatch

The Unit23 FOKO report is now accessible through the restored
`Unit21.SpeedButton2Click` caller. The A4 portrait `Reports\Unit23Foko.lrf`
template is embedded as a Lazarus resource; the workflow prepares it against
the already-active `DataModule2.Table20` and calls the default LazReport
prepared-preview surface. The three QRImage placeholders in the DFM have no
embedded picture data or proven source and are not represented. No pixel-level
output parity is claimed.

`TFokoListReport` validates all nine required fields without opening a
provider, bookmarks/restores the caller's current record, and leaves ownership
with the caller. The preview presenter is injectable; tests use a recording
presenter and never open a modal preview or invoke printing. Print remains an
explicit unsupported operation. Unit23's FPC LFM no longer streams
QuickReport controls; the original Delphi DFM/field declarations remain under
the Delphi conditional.

Seven Unit23 and two Unit21 synthetic tests verify captions and field bindings,
actual preparation, current-row/ownership preservation, missing-field
rejection, handler dispatch, embedded template loading, and presenter
invocation. The focused Unit21 suite passes 2/2 and the complete suite passes
292/292; the test project builds. The application build remains blocked by
deferred `QRPrgres`. No database, genealogy data, modal preview UI, printer,
export, or output comparison was used.

Coverage is 426/1,062 methods restored (40.11%); `Unit21.pas` has 4/8 methods
still assembly-backed, and `Unit23.pas` is 1/2 assembly-backed. Remaining
report migration includes the other QuickReport forms, print, export, and
output parity; do not infer these from successful FOKO preview dispatch.

## Latest checkpoint — Unit10 browser-command dispatch boundary

Restored `BitBtn1Click` and `SpeedButton2Click` to dispatch legacy command
ID 6 with option 0; restored `SpeedButton3Click` to dispatch command ID 4 with
option 0; and restored `BitBtn2Click` to dispatch command 4 only after the
save dialog accepts. The complete listings at `0055A124`, `0055A138`,
`0055A1AC`, and `0055A1C0` establish these values and call order. Only the
two SpeedButton events are bound in the available DFM/LFM; the BitBtn methods
are restored from listings but their UI reachability is not claimed.

Because the Windows `TWebBrowser.ExecWB` surface has no proven equivalent on
the FPC `THtmlViewer`, `Compat\BrowserCommands\BrowserCommandCompat.pas`
defines an injectable command provider and a default provider that raises
`EBrowserCommandCompatibilityUnsupported` with the exact legacy command
identity. It does not print, save, or silently substitute HTML-viewer
behavior. Synthetic tests use a recording provider and a fixed-result save
dialog to cover all four handlers, both save-dialog outcomes, exact command
IDs/options, and the explicit default failure. No browser, file, dialog UI,
report, or genealogy data was accessed.

The focused tests pass 6/6; the complete suite passes 283/283; and the test
project builds. Coverage is 416/1,053 restored (39.51%); `Unit10.pas` is
8/16 assembly-backed (50.00%). The main application build is still blocked
by the deferred QuickReport dependency `QRPrgres`.

## Latest checkpoint — Unit24 field-list refresh

Restored `TForm24.listanz` (`0055EC64`) and `Button9Click` (`0055EE60`) from
the independent IDR listing. IDR confirms `listanz` is a receiver-only helper,
not a `Sender` event, and maps the three source pairs through `TDataModule2`:
Table12/field Table12Name to ListBox1, Table13/field Table13Ort to ListBox2,
and Table37/field Table37Hofname to ListBox5. The helper clears all six
listboxes, then opens each source in sequence, traverses from First to EOF,
and appends `AsString` only when `AsInteger > 0`; conversion and provider
errors are not swallowed. `Button9Click` dispatches the main-form
`listen_akt` callback before calling `listanz`. The direct x86 callers and
independent IDR declaration show `listen_akt` has no argument; its Pascal
signature was corrected, but its body remains assembly-backed.

`RefreshFieldLists` factors this exact ordered generic dataset operation for
synthetic `TBufDataset` tests. Three cases verify populated and empty lists,
all-list clearing, order/filtering, and conversion-error propagation before
later datasets are opened. The live global-table path and Button9 dispatch
were not invoked because they enter the provider-backed main refresh. No
genealogy data or application UI was accessed. The test project builds and
the full suite passes 277/277. The canonical application build remains
blocked by the deferred QuickReport dependency `QRPrgres`. Coverage is
411/1,052 restored (39.07%), with 641 methods still assembly-backed;
`Unit24.pas` is 0/26 assembly-backed. This restores the method body only; it
does not assert BDE/SQLDB or production-provider parity.

## Latest checkpoint — Unit18 export-string normalizer

Restored the unit-level helper at `00545A0C` from the complete IDR
decompilation in `Source\Projects_AhnenWin\Unit18.pas`. The call site confirms
`AnsiString` input in EAX and output-string address in EDX; the previous
`TForm18.Proc_00545A0C(Sender: TObject)` class declaration was an ABI
misidentification and has been replaced by
`Proc_00545A0C(inputText: AnsiString; var outputText: AnsiString)`.
The implementation preserves the special `..`, `HK`, `vo.r`, and `na.ch`
branches and the remaining trim/period/space conversion. A guard prevents a
period-only value from looping after the original fixed-length copy empties
the working string.

Eight synthetic tests cover the special branches, punctuation conversion,
numeric-prefix pass-through, whitespace preservation, and the empty-result
edge case. The helper is tested independently; `speichern` still contains its
assembly listing and was not invoked, so no CSV file or provider work is
claimed. The complete suite passes 275/275 and the test project builds. The
canonical application build currently stops because the deferred QuickReport
unit `QRPrgres` is unavailable; no report dependency was changed. Coverage is
409/1,052 restored (38.88%), with 643 assembly-backed; `Unit18.pas` is 8/32
assembly-backed (25.00%). No real data, report, file, or application UI was
accessed.

## Latest checkpoint — Unit24 field-list close state

Restored DFM/LFM-bound `TForm24.FormClose` from listing `0055F144`. The
separate IDR decompilation in `Source\Projects_AhnenWin\Unit24.pas` identifies
the string constant at `0055F524` as `%`, confirming that ListBox3 and
ListBox4 are serialized in order with a trailing delimiter for every item.
The handler then zeros 18 option globals and sets the corresponding flags
from RadioButton1-3 and CheckBox1-11, 14, and 16-18. The IDR `Unit3` listing
independently shows the option globals consumed by report-generation code;
report behavior remains outside this slice. Since the two decompilations use
different global-address labels, the Pascal declarations retain the current
DeDe listing's `GlobalVar_025353E0`–`GlobalVar_02535424` names rather than
assuming the other image's absolute addresses.

A synthetic unstreamed-form test verifies both ordered strings and trailing
delimiters, every radio/checkbox mapping, empty-list clearing, and all-zero
flags, while restoring shared state afterward. The full suite passes
267/267; the test project and main application build. Coverage is
408/1,052 restored (38.78%), with 644 assembly-backed; `Unit24.pas` is
2/26 assembly-backed (7.69%). No database, report, or application UI was
opened.

## Candidate-screen checkpoint — no resource-bound candidate — 2026-10-02

The follow-up screen after `TForm24.FormShow` found no immediate method that
meets all current selection criteria: a retained complete assembly listing,
confirmed form-resource binding, and a bounded synthetic test with no
database/provider, report/printing, file, or opaque-helper behavior.
`TGregorianCalendarForm.btnPrintKalenderClick` remains report/printing work;
the calendar address-counter callbacks are already Pascal and have no
confirmed resource binding. This is a bounded screening result, not proof
that all remaining source methods have been inventoried.

At the time of this screen, coverage was 406/1,052 methods restored (38.59%);
646 were assembly-backed. `Unit24.pas` was 3/26 assembly-backed (11.54%) after
r1569.

## Latest checkpoint — main-form empty callback

Restored the complete listing for `TForm1.drucken2Click` at `005D3FB0` as an
empty Pascal body: the listing consists only of compiler exception-frame
setup/teardown, with no application-level operation. No DFM/LFM event binding
was found, so this does not establish UI reachability or printing behavior.
The inert main-form test invokes it on an unstreamed form and verifies that
caption and modal result remain unchanged. Focused test passes 1/1; the full
suite passes 266/266. Coverage is 407/1,052 restored (38.69%), with 645 still
assembly-backed; `frmAhnenWinMain.pas` is 229/323 assembly-backed (70.90%).
No database, report, or application UI was opened.

## Earlier checkpoint — Unit24 field-list initialization

Restored DFM/LFM-bound `TForm24.FormShow` from the complete listing
`0055EE78`: call the then-assembly-backed `listanz` helper, enable
RadioButton1 and RadioButton3, and set ActiveControl to ListBox1. A synthetic
unstreamed-form test verified the enabled states and active control.
`listanz` was restored later as recorded in the latest checkpoint; this
historical test did not execute provider-backed list loading. At that time,
the complete suite passed 266/266. No genealogy data or report was opened.

## Latest checkpoint — Main-form progress-label reset

Restored `TForm1.lab18ein` from complete listing `005D87E4`. The helper shows
Label18, sets its caption to `0 %`, refreshes it, then shows and refreshes
Label19; nine retained callers were located. The unstreamed-form test creates
synthetic labels and verifies visibility plus the reset caption. Focused test
passes 1/1; full suite passes 265/265, and the Lazarus test project builds.
Coverage is 405/1,052 methods restored (38.50%); `frmAhnenWinMain.pas` is
230/323 assembly-backed (71.21%). No data or report code was invoked.

## Latest checkpoint — Unit18 clear-all criteria

Restored the DFM/LFM-bound `TForm18.Button5Click` from its complete listing.
The “alle löschen” action clears ComboBox1-26, Edit1-9, and Edit23, then
sets ActiveControl to ComboBox1. The listing has no query or dataset
operation. A synthetic test seeds all 36 fields and verifies the clear and
focus behavior. Focused Unit18 tests pass 6/6, the full suite 264/264, and
the Lazarus test project builds. Coverage is 404/1,052 methods restored
(38.40%); `Unit18.pas` is 9/32 assembly-backed (28.13%). Only the bounded
method changed in the legacy-encoded source. No database, report, or
application UI was opened.

## Latest checkpoint — Unit18 search-form initialization

Restored the DFM/LFM-bound `TForm18.FormShow` from its complete listing. It
disables Button1 and Button7, then sets ActiveControl to ComboBox1. An
unstreamed-form test starts with both buttons enabled and verifies these
states and the focused control. At that checkpoint, coverage was 403/1,052
methods restored (38.31%); `Unit18.pas` was 10/32 assembly-backed (31.25%).
Focused tests passed 5/5 and the full suite passed 263/263. The source
encoding is unchanged outside the restored method. No database, report, or
application UI was opened.

## Latest checkpoint — Unit18 search-row clearing

Restored the nine DFM/LFM-bound `TForm18.SpeedButton2Click` through
`SpeedButton10Click` handlers from complete listings. Each clears exactly
the three or four search inputs in its own criteria row; the listings do not
touch Query1 or any dataset. A synthetic unstreamed-form test seeds all 35
inputs and checks each handler clears only its designated row. At that
checkpoint, coverage was 402/1,052 methods restored (38.21%);
`Unit18.pas` was 11/32 assembly-backed (34.38%). Focused tests passed 4/4 and
the full suite passed 262/262. The legacy source encoding was preserved
outside the replaced method bodies. No database, report, or application UI
was opened.

## Latest checkpoint — Unit19 finish-button checkbox state

Restored the DFM/LFM-bound `TForm19.BitBtn1Click` from its complete listing.
The handler dispatches `nachf(Sender)` only when the shared mode in Unit12
equals `Nach` exactly, then clears CheckBox7 and CheckBox8 if the current
list-type text contains the case-sensitive substring `alph`. Two synthetic tests exercise both checkbox outcomes with a non-`Nach` mode,
so they do not enter the database-backed descendant workflow. At that
checkpoint, coverage was 393/1,052 methods restored (37.36%);
`Unit19.pas` was 12/28 assembly-backed (42.86%). Focused tests passed 11/11
and the full suite passed 261/261. No database, report, or application UI was
opened.

## Latest checkpoint — Unit17 checkbox presets

Restored DFM/LFM-bound `TForm17.RadioButton1Click` and
`RadioButton2Click` from complete listings as explicit presets for
CheckBox1-9 and CheckBox11-16. Both methods touch the 15 checkboxes only; the
radio-button captions corroborate the mark-all and clear-all intent. The
unstreamed synthetic tests assert all 15 states for each handler. Focused
tests pass 2/2, the full suite 259/259, and the test project builds. Coverage
is 392/1,052 methods restored (37.26%); `Unit17.pas` is 10/15
assembly-backed (66.67%). No database, report, or application UI was opened.

## Latest checkpoint — Unit13 unbound scale callback

Restored `TForm13.UpDown1Click` from listing `005661E8`. It compares the
address-backed extended scale strictly against `0.5` and subtracts `0.13`
only when greater; unlike `Button5Click`, the listing does not request a
repaint. Synthetic unstreamed-form tests cover below, exactly at, and above
the threshold. The Unit13 DFM/LFM do not bind this handler and no direct
Pascal caller was found, so only the method body is reconstructed, not
original UI reachability. Focused GraphicForm tests pass 9/9; full suite
257/257. Coverage is 662/1,052 (62.93%); `Unit13.pas` is 41/55 (74.55%).
No database or report was opened.

## Earlier candidate boundaries — Unit10 and Unit24

The Unit10 browser commands were initially held back because the listings
target `SHDocVw.TWebBrowser.ExecWB` while the FPC branch declares
`THtmlViewer`. They were subsequently restored against an explicit unsupported
command-provider boundary as recorded in the latest checkpoint.

Unit24's resource-bound `Button9Click` calls the main-form `listen_akt`
callback and then `TForm24.listanz`, which reads data-module state and
repopulates lists. Keep this out of unattended tests until synthetic
provider/data-module contracts bound those reads and writes; do not invoke it
on genealogy records or claim BDE/SQLDB parity.

## Latest checkpoint — Unit19 cursor reset

Restored `TForm19.vorchron` as `Screen.Cursor := crDefault`. The complete
listing loads the global `TScreen`, passes cursor value zero to `SetCursor`,
and performs no other application operation. The unstreamed synthetic test
sets `crHourGlass`, invokes the method, verifies `crDefault`, and restores
the prior cursor in `finally`. No DFM/LFM binding or direct caller was found;
the restored body is not evidence of original UI reachability. Focused tests
pass 2/2 and the full suite passes 256/256. Coverage is 663/1,052 (63.02%);
`Unit19.pas` is 13/28 (46.43%). No database or report was opened.

## Latest checkpoint — Unit19 empty callbacks

Restored `TForm19.vorf` and `TForm19.voralph` from complete listings that
contain only compiler exception-frame setup/teardown; neither performs an
application operation. The DFM and LFM do not bind these methods, so they are
recorded as reconstructed method bodies, not verified reachable UI behavior.
An unstreamed-form test invokes both and confirms that `ModalResult` remains
unchanged. Focused tests pass 1/1; the full suite passes 255/255. Coverage is
664/1,052 (63.12%); `Unit19.pas` is 14/28 (50.00%). No database or report was
opened.

## Latest checkpoint — Unit17 counter increment

Restored `_PROC_0054524D` from its complete listing as an increment of the
same address-backed `LongInt` used by `_PROC_0054527C`. The wrapper's
exception-frame instructions are compiler bookkeeping, so the observed
operation is `Inc(GlobalVar_0061DFD8)`. An unstreamed-form test verifies
increment from zero and from a positive count; together with the existing
decrement test, focused tests pass 2/2 and the full suite passes 254/254.
Coverage is 666/1,052 (63.31%); `Unit17.pas` is 12/15 (80.00%). No data was
opened.

## Latest checkpoint — Unit18 first living-status exit handler

Restored the complete `ComboBox1Exit` listing: when `ComboBox1.Text` equals
`lebt` exactly, clear `ComboBox2.Text` and `Edit1.Text`. Both DFM and LFM bind
the handler. The existing unstreamed Unit18 tests now exercise this pair
alongside the eight previously restored pairs and preserve all dependent
fields for case-different input. Focused tests pass 3/3 and the full suite
253/253. Coverage is 667/1,052 (63.40%); `Unit18.pas` is 20/32 (62.50%). No
records or application UI were opened.

## Candidate deferred — Unit18 string normalizer

Do not rewrite `Proc_00545A0C` from its current decompiler declaration yet.
The caller at `00546211` passes a string in `EAX` and an output-string address
in `EDX`, which conflicts with the generated `Sender: TObject` signature.
The complete body also calls `00409448` and `0044643C`, whose implementations
are not present in this repository. The routine appears string-only, but the
correct Pascal signature and helper semantics remain unproven. Resume only
after independent ABI/helper evidence is available; do not infer behavior
from the German string fragments alone.

## Latest checkpoint — Unit18 counter callbacks

Restored `_PROC_0054D870` and `_PROC_0054D8B4` from complete listings.
The increment callback increases the address-backed 32-bit counter and clears
both associated managed strings only when the resulting count is zero; the
decrement callback subtracts one without clamping. Synthetic unstreamed-form
tests cover the nonzero increment, zero-result clear branch, and zero-to-minus
one decrement. Focused tests pass 3/3; full suite 253/253. Coverage is
668/1,052 (63.50%); `Unit18.pas` is 21/32 (65.63%). No database or application
UI was opened.

## Latest checkpoint — Unit18 bounded control state

Restored the eight DFM/LFM-bound `ComboBox*Exit` handlers for fields 3, 5, 7,
9, 11, 13, 22, and 25 from their complete listings. Each performs an exact,
case-sensitive comparison with `lebt` and clears only its paired combo/edit
fields. Restored `FormClose` from its listing to copy `Edit23.Text` into the
address-backed `GlobalVar_0253593C`. Three synthetic unstreamed-form tests
cover all eight clear branches, nonmatching case, and close-state copying.
The focused group passes 3/3; the complete suite passes 250/250; the test
project builds with `Unit18` included. Coverage at that slice was 670/1,052
(63.69%); `Unit18.pas` was 23/32 (71.88%). The canonical application build
advances past the `Unit10` HtmlView dependency and then stops in deferred
`Unit16` because `TMainMenu`/`TMenuItem` are unresolved. No records, files, or
application UI were opened.

## Latest checkpoint — Unit17 counter decrement

Restored `TForm17._PROC_0054527C` from listing `0054527C` as
`Dec(GlobalVar_0061DFD8)`. The complete listing consists only of that
address-backed decrement and `ret`; it does not clamp at zero. Its
unstreamed `TForm17` test covers zero-to-negative and positive decrement.
That slice passed 1/1 focused and 247/247 full-suite tests at the time.
`_PROC_0054524D` was subsequently restored as the matching increment. No
database was opened and AhnWin was not started.

## Latest checkpoint — Unit10 counter helpers

Restored `_PROC_0055B2B5` and `_PROC_0055B2E4` from listings `0055B2B5` and
`0055B2E4` as direct increments and decrements of the address-backed
`GlobalVar_0061E0B0`. The increment listing contains exception-frame cleanup
around the increment but no additional application behavior; the decrement
has no clamp. Two synthetic tests cover both deltas and the negative
decrement boundary using an unstreamed form. Focused tests pass 2/2, the full
suite 246/246, and the test project builds. Coverage is now 680/1,052
(64.64%); `Unit10.pas` is 12/15 (80.00%). No HTML content, image, or
genealogy data was loaded.

## Latest checkpoint — Image-selection form dispatch

Restored the DFM/LFM-bound `TForm10.SpeedButton5Click` from listing
`0055A4B8`; the handler displays the global `Form32` image-selection form.
The synthetic test assigns an unstreamed `TForm32` with a test-only `OnShow`
observer and verifies the global target is shown exactly once. Because the
target is not streamed, its file-loading `FormShow` is not assigned and no
image paths are read. The image-selection form's file-loading and click
handlers remain assembly-backed and out of scope. The test project now
references the existing `FrameViewer09` and `fpvhttp` packages required by
`Unit10`. The focused test passes 1/1, the complete suite 244/244, and the
test project builds. Coverage is now 682/1,052 (64.83%); `Unit10.pas` is
14/15 (93.33%). No image or genealogy data was loaded and AhnWin was not
started.

## Latest checkpoint — Source archive form lookup boundary

Restored the DFM-bound `TForm30.FormShow` from listing `00560EC8`. It first
calls `DataModule2.Table11.FindKey([Form30.Label2.Caption])`, then assigns the
eleven fixed archive-description captions in listing order. `Table11` is the
converted `TSQLTable` corresponding to the legacy BDE table; the existing
compatibility helper rejects `TTable.FindKey` explicitly rather than using
SQLDB lookup semantics.

An unstreamed synthetic test creates only `TForm30`, `TDataModule2`, and an
inactive `TSQLTable`, then verifies that `FormShow` propagates the named
`TTable.FindKey` compatibility exception before touching real data. The
post-lookup caption assignments are compile-checked but intentionally not
reached because lookup semantics and archive records are unavailable. The
focused test passes 1/1, the full suite 243/243, and the test project builds.
The canonical main build remains blocked by the pre-existing `Unit18.pas`
syntax error. Coverage is 683/1,052 (64.92%); `Unit30.pas` is 1/6 (16.67%).
No genealogy or archive database was opened and AhnWin was not started.

This fulfills the first bounded provider-backed source restoration against
the explicit-failure boundary; it does not implement `FindKey` or claim BDE /
SQLDB lookup parity. Continue with another short routine only where its
unsupported data operation and failure boundary are independently testable.

### Follow-up candidate screening

The DFM-bound `TForm32.Image1DblClick` handles ten image controls, constructs
`.jpg` paths, and calls `TPicture.LoadFromFile` on those branches; it also
depends on opaque string helpers. Keep it deferred unless a synthetic file
provider and helper contract are established. The short-looking
`TForm29.FormActivate`, `TForm36.FormActivate`, and `TForm39.FormActivate`
callbacks clear selections and then open BDE-backed tables. `TForm19.BitBtn1Click`
can dispatch to `nachf`, whose listing reads the main dataset's `RecordCount`.
`TForm1.Proband1Click` likewise reads record count after dispatching a menu
item. These are not control-only tests and remain uninvoked. No next
resource-bound candidate met the safe execution boundary in this screen.

## Latest checkpoint — Relationship caption normalization

Restored the DFM/LFM-bound `TForm1.ComboBox5Exit` from the complete listing
`0061781C`. It performs two ordered, case-sensitive substring checks on
`ComboBox5.Text`: `heschl` becomes `Eheschliessung`, then `dere Bez` becomes
`andere Beziehung` if still present. The form resources also bind
`ComboBox5Change`; that existing handler only focuses `Edit4`. Four
synthetic tests exercise each replacement, unchanged input, and case
sensitivity using an unstreamed form and manually created combo box.

The focused suite passes 4/4 and the full suite 242/242. The test project
builds. The canonical `AHNWIN52.lpi` build remains blocked by the pre-existing
syntax error in `Unit18.pas` (`ComboBox4` encountered where `THEN` is
expected); this slice does not modify that unrelated method. Coverage is
684/1,052 (65.02%); `frmAhnenWinMain.pas` is 231/323 (71.52%). No genealogy
data was opened and AhnWin was not started.

Next, continue screening for complete, resource-bound handlers with control-
only or synthetic effects. Keep provider-backed dataset refreshes, report,
print, file, and relationship-index workflows out of execution; do not
approximate incomplete listings or static constants.

## Latest checkpoint — Main-form resize state

Restored the DFM/LFM-bound `TForm1.FormResize` sequence from listing
`005F23A0`: use the global main-form height and the previous height in
`ScaleControls`, store the new height in the address-backed cell
`02535BA4`, then invoke `gridanp`. Both retained callers invoke `gridanp`
without arguments, and the target listing does not consume an event sender,
so its decompiler-generated `Sender` parameter was removed. `gridanp` itself
remains assembly-backed and was not modified.

A synthetic `TForm1.CreateNew` test verifies the height state update without
streaming data-bound controls; `ScaleControls` sees no children and the
retained `gridanp` body is deliberately not treated as restored grid-sizing
behavior. The focused test passes 1/1, the complete suite 238/238, and the
canonical main project builds and links. Coverage is 685/1,052 (65.11%);
`frmAhnenWinMain.pas` is 232/323 (71.83%). No genealogy data was opened and
AhnWin was not started.

### Follow-up candidate boundary review

Audited the complete `gridanp` listing and both call sites: the routine uses
its `TForm1` receiver, reads five string-grid client widths, and sets their
column widths; it never reads an event `Sender`. The parameterless signature
is therefore supported, but the referenced floating-point constants at
`005D4348` through `005D4390` are not defined in the checked-in Pascal
listing. The known `AHNWIN51.exe` and `AHNWIN51_.exe` reference images are
absent from this working copy. Keep the grid-width body assembly-backed until
those exact constants are independently recovered; do not estimate
proportions.

The short `Osterberechnung1Click` listing is not a safe alternative: after
setting the `"Oster"` mode and active tab it calls `speich1` and an
unidentified global virtual method. `TForm13.Button4Click` is DFM-bound but
creates a JPEG/bitmap and enters a save-dialog/file-write path; `FormShow`
opens a BDE dataset. These remain untouched. Continue screening for a
complete control-only callback, or restore `gridanp` only with verified
constant evidence.

## Latest checkpoint — Login dialog label sizing

Restored `TLoginDialog.FormShow` from the complete listing at `004B0EE0`;
`DBLogDlg.dfm` binds it to the form's `OnShow`. It compares
`Panel.ClientWidth` to `DatabaseName.Left + DatabaseName.Width` and only
when the label reaches or exceeds that boundary assigns the remaining panel
width minus the observed five-pixel margin. A synthetic `CreateNew` dialog
with manually created controls tests a fitting label, exact boundary, and
narrow panel. The login resource and its database-facing handlers were not
streamed or invoked.

`DBLogDlg` is included by a unit-specific source reference rather than a
global `Sys` search path. Its legacy declarations needed the missing
`ExtCtrls` import for `TPanel` and `TBevel`; no unrelated login behavior was
changed. The focused tests pass 3/3, the full synthetic suite passes 237/237,
and the canonical main project builds and links. Coverage is 686/1,052
(65.21%); `Sys\DBLogDlg.pas` is 5/6 (83.33%). No database was opened and
AhnWin was not started.

## Latest checkpoint — Password dialog edit state

Restored `TPasswordDialog.EditChange` from the complete listing at
`004B1298`; `DBPWDlg.dfm` binds `Edit.OnChange` to the handler. It enables
`AddButton` and `RemoveButton` when `Edit.Text` is nonempty, and enables
`OKButton` when the text is nonempty or the private byte at offset `030C` is
nonzero. A synthetic test invokes the actual handler on a `CreateNew` dialog
with manually created controls, covering empty, nonempty, and cleared text
while the byte remains at its default zero. The nonzero-byte branch is
source-recovered but not dynamically injected.

The test project compiles `DBPWDlg` through an explicit unit source path,
avoiding a broad `Sys` search path that collides with Lazarus's `DBLogDlg`.
The focused test passes 1/1, the complete suite 234/234, and both test and
canonical main Lazarus projects build/link. Coverage is 687/1,052 (65.30%);
`Sys\DBPWDlg.pas` is 6/7 (85.71%). No database was opened and AhnWin was not
started.

## Latest checkpoint — Report-option cancel reset dispatch

Restored `TForm17.BitBtn2Click` from listing `005405A0`; both form resources
bind `BitBtn2.OnClick` to this method. The DPR's `CreateForm` listing maps
global `0061DFC8` to `TForm17`. The handler sets `Form17.ModalResult` to
`mrCancel`, clears the address-backed 32-bit cell `0061DFD0`, then calls the
global main form's `anzeigen` with the original `Sender`.

The handler remains uninvoked because `anzeigen` enters the assembly-backed,
database-refresh path. Added `Unit17` to the test project's compile set so
the restored body is actually compiled; the full synthetic suite passes
233/233, and the canonical main project links. Coverage is 688/1,052 methods
with retained listings (65.40%); `Unit17.pas` is 14/15 (93.33%). No genealogy
data was opened and AhnWin was not started.

## Latest checkpoint — Option-dialog cancel dispatch

Restored `TForm19.BitBtn2Click` from listing `0055108C`; both the DFM and LFM
bind `BitBtn2.OnClick` to this method. The listing sets the global `Form19`
instance's `ModalResult` to the literal value 2 (`mrCancel`), then calls the
global main form's `anzeigen` with the original `Sender`. `Form19` is the
address-backed form global preceding the sequential `GlobalVar_0061E014`
string cells; `Form1` and `anzeigen(Sender)` are exposed by
`frmAhnenWinMain`.

The exact dispatch now compiles, including the necessary implementation
dependency on `frmAhnenWinMain`. It was not invoked because `anzeigen` remains
assembly-backed and enters the data-refresh path. The test project compiles
the changed unit, the main project links, and the full synthetic suite passes
233/233; no test invokes this handler. Coverage is 689/1,052 methods with
retained listings (65.49%); `Unit19.pas` is 16/28 (57.14%). No genealogy data
was opened and AhnWin was not started.

## Latest checkpoint — Fractional graphic scale buttons

Restored the DFM/LFM-bound `TForm13.Button5Click` and `Button6Click` from
listings `00572404` and `00572448`. The shared cell `0061E120` is an
80-bit `Extended`: the listings use `fld`/`fstp tbyte`, and the matching
reference executable initializes the same cell as a ten-byte floating-point
value. Read-only PE inspection of `AHNWIN51.exe` (SHA-256
`817c1b1bb23469cd628c52e4a5ea26cb4db26275b5ec84952717b218605f0aff`)
confirmed the code bytes at the method entry match the listing and decoded
the referenced constants: `0.5` threshold and `0.13` step.

`Button5Click` subtracts `0.13` and refreshes only when the cell is strictly
greater than `0.5`; `Button6Click` always adds `0.13` then refreshes. Synthetic
tests verify values below, at, and above the threshold, the increment, and
repaint requests using a recording PaintBox callback rather than the
assembly-backed family drawing handler. The focused graphics tests pass 8/8,
the full synthetic suite passes 233/233, and both Lazarus projects build and
link. Coverage is 690/1,052 methods with retained listings (65.59%);
`Unit13.pas` is 42/55 (76.36%). No application was run and no genealogy data
was opened.

## Latest checkpoint — Family-graphic PaintBox wrapper

Restored DFM/LFM-bound `TForm11.PaintBox1Paint` from listing `005CB350`. It
compares `PaintBox1.Canvas` with the saved canvas reference at `02535894`;
when they match, it sets the PaintBox control color to `clBtnFace`, then
unconditionally calls `zeichnen` with the saved canvas. The assignment target
is the PaintBox control, as shown by the `TControl.SetColor` call with the
PaintBox still in the receiver register.

The handler was not invoked because `zeichnen` remains a large
assembly-backed routine that may access genealogy data. Both Lazarus projects
build and link, and the existing synthetic suite passes 232/232; none of
those tests invokes this paint path. Coverage is now 692/1,052 methods with
retained listings (65.78%); `Unit11.pas` is 5/11 (45.45%). The updated
per-file report is `AhnWin-Assembly-Coverage-2026-10-01.csv`. No genealogy
data was opened and AhnWin was not started.

## Latest checkpoint — Family-graphic button dispatch

Restored the DFM/LFM-bound `TForm11.Button1Click` from listing `005CB568`.
The listing increments the address-backed counter at `025358A8`, then passes
the saved canvas at `02535894` to `zeichnen`. The field access in
`FormCreate` and the drawing call sites identify the saved object as a
`TCanvas`; the existing `zeichnen(Sender: TObject)` signature accepts it
without changing that routine's API.

The handler body now preserves that order. It was not invoked: `zeichnen`
remains a large assembly-backed routine that may access genealogy data. Both
the test project and canonical main project compile and link; this validates
the restored dispatch's types but not its runtime drawing/data behavior.
Structural inventory is 693/1,052 methods with retained listings (65.87%);
`Unit11.pas` is 6/11 (54.55%). The updated per-file report is
`AhnWin-Assembly-Coverage-2026-10-01.csv`. No genealogy data was opened and
AhnWin was not started.

## Latest checkpoint — Bounded graphic control handlers

Restored the DFM/LFM-bound `TForm13.ScrollBar1Change` and
`TForm13.ScrollBar2Change` from listings `00572484` and `00572490`. Each
listing loads `PaintBox1`, calls the same refresh routine, and returns;
both Pascal bodies now call `PaintBox1.Refresh`. A synthetic visible PaintBox
with a recording `OnPaint` verifies that each handler requests a redraw.

Also restored the DFM/LFM-bound `Button1Click`, `Button2Click`, and
`Button3Click` listings (`005707C0`, `00570838`, and `00570854`). They toggle
the address-backed mode and exact captions, increment two 32-bit state cells,
and independently enforce the two observed decrement thresholds, requesting
a PaintBox refresh after each taken branch. Synthetic tests exercise both
toggle directions, increments, both decrement branches, and the boundary
no-op. No drawing generator, printing, or external data is used.

Restored the DFM/LFM-bound `Button7Click` and `Button8Click` listings
(`00573120` and `005730D4`) as guarded Pen.Width decrement/increment handlers.
They preserve the observed 1- and 3-pixel limits and refresh only after
changing the width; synthetic tests cover both bounds and all intermediate
steps.

The focused graphic-form group passes 7/7, the complete synthetic suite passes
232/232, and both `AhnWin52Tests.lpi` and `AHW52_Main.lpi` build and link.
Current structural inventory: 694/1,052 methods retain listings (65.97%);
`Unit13.pas` is 44/55 (80.00%). The per-file report is
`AhnWin-Assembly-Coverage-2026-10-01.csv`. No genealogy data was opened and
AhnWin was not started.

## Latest checkpoint — BDE boundary and bounded UI restorations

Restored `TForm1.anzeigen1Click` from the complete DFM/LFM-bound listing
`005EEB40`. It selects `TabSheet2`, then shows `StringGrid5`; a synthetic
`CreateNew` main form verifies both effects without initializing data-bound
controls. Restored `TForm13.FormCreate` from DFM/LFM-bound listing `00570740`:
it initializes six address-backed integer cells (`02535380`, `02535384`,
`011AD31C`, `011AD324`, `011AD318`, `0253537C`), then sets `PaintBox1` to
100 by 100, white, and pen width 1. Its synthetic `TPaintBox` test verifies
the values and restores shared fixture state.

The DBTables compatibility boundary permits non-I/O `TQuery` setup and
explicitly rejects unsupported query execution and the listing-evidenced
`FindKey`/`EmptyTable` calls. Focused tests pass: DBTables 7/7, menu dispatch
2/2, and graphics 4/4. The complete suite passes 229/229, and both Lazarus
projects build and link. The current structural inventory is 701/1,052 methods
retaining listings (66.63%); `frmAhnenWinMain.pas` is 233/323 (72.14%) and
`Unit13.pas` is 51/55 (92.73%). The denominator includes five compatibility
surface methods and should not be compared directly with the prior 1,047-
method report. See `AhnWin-Assembly-Coverage-2026-10-01.csv`. No genealogy
data was opened and AhnWin was not started.

## BDE query runtime boundary — 2026-10-01

The DBTables inventory distinguishes actual Pascal/resource dependencies from
DeDe reference comments. `PersonSearchForm.dfm` streams one `TQuery` component,
but it has no database/transaction settings; the other located
`FindKey`/`OpenDatabase`/`EmptyTable` references are retained listing
annotations, not executable Pascal calls. Do not build a speculative
`TSession`/`TTable` API from those comments alone.

`DBTables.TQuery` can now be constructed and configured with SQL text without
opening a provider. `OpenCursor`, `Prepare`, and `ExecSQL` fail explicitly
with `EDBTablesCompatibilityUnsupported` and a method-specific `Operation`.
The compatibility unit also provides `TSQLTable` helper methods for the
listing-evidenced BDE calls `FindKey` and `EmptyTable`; both always fail
explicitly and do not inspect or mutate a dataset. This keeps source
reconstruction compilable without allowing SQLDB to silently replace BDE
execution. Existing `TBufDataset` tests continue to exercise generic in-memory
locate and navigation behavior separately; they do not establish BDE
key/index equivalence.

The compatibility test group passes 7/7; the complete synthetic suite passes
227/227 and `AHW52_Main.lpi` builds. No genealogy data was opened and AhnWin
was not started. Next, choose a bounded restoration only after its concrete
Pascal call surface is evidenced; keep `FindKey`, session/alias operations,
and table-file behavior unsupported until then.

## Candidate boundary review — 2026-10-01

After the edit-tab guard, the short-list was screened for another bounded
handler. `TabSheet7Enter` refreshes and opens the BDE-backed relationship
dataset and selects the `namgeb` database; the source-list and Hofnamen menu
handlers also open database-backed datasets. The `DBEdit40Exit`/`DBEdit7Exit`
paths depend on data-module state and message dialogs, `Image2Click` executes
an external picture-file dialog, and the remaining Unit16 candidate belongs
to the QuickReport preview. These paths were not run or changed.

The tiny Unit21 callback at `005CBE3F` contains only malformed decoded bytes
(`0003 add [ebx], al; 0000 add [eax], al`) and has no resource binding; it is
not sufficient evidence for a Pascal body. At that screening point, the
immediate shortlist had no additional safe provider-free slice. A subsequent
focused review of the graphics unit found two independently bounded scrollbar
repaint handlers; their restoration is recorded in the latest checkpoint
above. Continue screening for similarly small resource-bound UI methods.
Preserve the existing relationship and LazReport boundaries.

## Latest checkpoint — Edit-tab entry mode guard

Restored the DFM/LFM-bound `TForm1.TabSheet2Enter` from listing `005EC2E8`.
It compares `Unit12.GlobalVar_0253592C` with the exact `dsneu` sentinel and
calls `anzeigen(Self)` only when they differ. The synthetic test exercises
only the `dsneu` branch; it deliberately avoids the provider-backed refresh
path. The method remains bounded to the observed comparison and dispatch.

Both Lazarus projects build and all 221 synthetic tests pass. Coverage is
703/1,047 methods retaining listings (67.14%); `frmAhnenWinMain.pas` is
234/323 (72.45%). Tracker: 190 items, 184 done, five blocked, and one pending
for deferred LazReport. No genealogy data was opened and AhnWin was not
started.

## Latest checkpoint — Family-graphics menu dispatch

Restored the DFM/LFM-bound `TForm1.FamGrafik1Click` from listing `005F9CCC`.
It selects `TabSheet2`, clicks `aus1`, then shows global `Unit11.Form11`, in
that order. The DPR maps the listing's global slot `0061C924` (address
`02535890`) to `TForm11`. A synthetic test records the menu-click/show order
and page selection using unstreamed forms; the target is alpha-blended and
its real drawing/data initialization is not invoked.

Both Lazarus projects build and all 220 synthetic tests pass. Coverage is
704/1,047 methods retaining listings (67.24%); `frmAhnenWinMain.pas` is
235/323 (72.76%). The tracker has 189 items: 183 done, five blocked, and one
pending for deferred LazReport. No genealogy data was opened, no dialog was
shown, and AhnWin was not started.

## Latest checkpoint — Person-search form screen scaling

Restored DFM-bound `TPersonSearchForm.FormCreate` from listing `0058424C`.
It targets global `PersonSearchDialog`, enables scaling, caches screen
dimensions, and preserves both independent threshold branches. Each branch
updates target height then width using the observed screen-height ratio; the
first calls `ScaleBy(screenHeight, 768)`, while the second calls
`ScaleBy(screenWidth, 1024)`. A synthetic test compares the global target
against these operations and verifies that a separate event receiver remains
unchanged.

Both Lazarus projects build and all 219 tests pass. Coverage is 705/1,047
methods retaining listings (67.34%); `PersonSearchForm.pas` is 216/225
(96.00%). Tracker: 188 items, 182 done, five blocked, and one pending for
deferred LazReport. No genealogy data was opened and AhnWin was not started.

## Latest checkpoint — Person-search “already found” action

Restored the DFM-bound `TPersonSearchForm.BitBtn2Click` from listing
`00584060`. It compares shared `Unit12.GlobalVar_0253592C` with the exact
string `Verw`; only a nonmatch sets `PersonSearchDialog.ModalResult` to
`mrCancel`. The DPR maps the listing's global target address
`025353D8` to `TForm3`, which is represented by `PersonSearchDialog` in the
renamed unit. Synthetic tests use distinct receiver/global forms and cover
both comparison outcomes without streaming the DFM or constructing `TQuery`.

Both Lazarus projects build and all 218 tests pass. Coverage at that
checkpoint was 706/1,047 methods retaining listings (67.43%);
`PersonSearchForm.pas` was 217/225 (96.44%). Tracker then had 187 items, 181
done, five blocked, and one pending for deferred LazReport.
No genealogy data was opened and AhnWin was not started.

## Latest checkpoint — Help menu guidance

Restored the DFM/LFM-bound `TForm1.Hilfe1Click` from listing `00601858` as
the direct message `Bitte die beiliegende Datei "Handbuch.pdf" benützen`.
The synthetic test intercepts the LCL `PromptDialogFunction` used by
`ShowMessage`, verifies the exact message and call count, and prevents a modal
dialog from appearing.

Both Lazarus projects build and all 217 synthetic tests pass. Coverage is
707/1,047 methods retaining listings (67.53%); `frmAhnenWinMain.pas` is
236/323 (73.07%). Tracker: 186 items, 180 done, five blocked, and one pending
for deferred LazReport. No actual message dialog, genealogy data, or
application was opened.

## Latest checkpoint — Unbound source-search menu dispatch

Restored the complete `TForm1.Quellesuchen1Click` listing as
`QuellenListeeditieren1.Click`. It has no DFM/LFM binding or source caller,
so no reachability is inferred and no event binding was added. A synthetic
`TMenuItem` with a recording `OnClick` checks the dispatch without opening
the source-list database workflow.

Both Lazarus projects build and all 216 synthetic tests pass. Coverage at
that checkpoint was 708/1,047 methods retaining listings (67.62%);
`frmAhnenWinMain.pas` was 237/323 (73.37%). Tracker then had 185 items, 179
done, five blocked, and one pending
for deferred LazReport. No genealogy data was opened and AhnWin was not
started.

## Latest checkpoint — Source-list menu handoff

Restored the DFM/LFM-bound `TForm1.QuellenListeeditieren1Click` from listing
`00603C74` as `Unit29.Form29.Show`. The DPR `CreateForm` sequence maps
`0061C7CC` to `TForm29`; it is not the later-created `TForm30` editor. A
synthetic test uses an unstreamed global list form with a recording `OnShow`,
so its database-backed `FormActivate` is not triggered.

Both Lazarus projects build and all 215 synthetic tests pass. Coverage is
709/1,047 methods retaining listings (67.72%); `frmAhnenWinMain.pas` is
238/323 (73.68%). Tracker: 184 items, 178 done, five blocked, and one pending
for deferred LazReport. No genealogy data was opened and AhnWin was not
started.

## Latest checkpoint — Profession-list menu handoff

Restored the DFM/LFM-bound `TForm1.BerufeVerwaltung1Click` from listing
`0060CFBC` as `Unit36.Form36.Show`. The DPR creation sequence maps global
`0061C344` to `TForm36`; the synthetic test substitutes a `CreateNew` target
and recording `OnShow`, avoiding the database-backed form resource.

Both Lazarus projects build and all 214 synthetic tests pass. Coverage is
710/1,047 methods retaining listings (67.81%); `frmAhnenWinMain.pas` is
239/323 (73.99%). Tracker: 183 items, 177 done, five blocked, and one pending
for deferred LazReport. No genealogy data was opened and AhnWin was not
started.

## Latest checkpoint — Window-title menu dispatch

Restored the DFM/LFM-bound `TForm1.Fenstertitelndern1Click` from its
call-and-return listing as `fcapt(Sender)`. The callee displays a modal title
prompt and updates the form and application titles, so the wrapper was not
invoked during automated validation.

Both Lazarus projects build and all 213 synthetic tests pass. Coverage is
711/1,047 methods retaining listings (67.91%); `frmAhnenWinMain.pas` is
240/323 (74.30%). Tracker: 182 items, 176 done, five blocked, and one pending
for deferred LazReport. No genealogy data was opened and AhnWin was not
started.

## Latest checkpoint — Death-date edit exit dispatch

Restored the DFM/LFM-bound `TForm1.DBEdit20Exit` and `DBEdit21Exit` wrappers
from their complete call-and-return listings as `wt36(Sender)`. Both resource
bindings and the shared call target are confirmed. The `wt36` helper remains
assembler-backed and provider-dependent, so neither event was invoked.

Both Lazarus projects build and all 213 synthetic tests pass. Coverage is
712/1,047 methods retaining listings (68.00%); `frmAhnenWinMain.pas` is
241/323 (74.61%). Tracker: 181 items, 175 done, five blocked, and one pending
for deferred LazReport. No genealogy data was opened and AhnWin was not
started.

## Latest checkpoint — Main-form memo exit save dispatch

Restored the DFM/LFM-bound `TForm1.DBMemo1Exit` from its complete two-
instruction listing as `speich1(Sender)`. This matches the existing
`DBNavigator1BeforeAction` dispatch and the identified direct call target.
The handler was not executed: `speich1` can post or delete the current record.
Both Lazarus projects build and all 213 consolidated tests pass; the existing
synthetic persistence tests exercise its provider-independent helper
branches. Coverage is 716/1,047 methods retaining listings (68.39%);
`frmAhnenWinMain.pas` is 245/323 (75.85%). Tracker: 179 items, 173 done,
five blocked, and one pending for deferred LazReport. No genealogy data was
opened and AhnWin was not started.

## Next checkpoint — Baptism date edit exit dispatch

Restored the DFM/LFM-bound `TForm1.DBEdit12Exit` and `DBEdit13Exit` wrappers
from their complete call-and-return listings as `wt34(Sender)`. Both event
resources and the common target are confirmed. The `wt34` date-validation
helper remains assembler-backed and provider-dependent, so neither wrapper
was invoked; validation is by compilation and the existing synthetic suite
without opening genealogy data.

Both Lazarus projects build and all 213 synthetic tests pass. Coverage is
714/1,047 methods retaining listings (68.19%); `frmAhnenWinMain.pas` is
243/323 (75.23%). Tracker: 180 items, 174 done, five blocked, and one
pending for deferred LazReport. No genealogy data was opened and AhnWin was
not started.

## Latest checkpoint — Graphic-form close lifecycle

Restored `TForm13.FormClose` from listing `00570728`. The DPR create-form
sequence maps the first global target (`0061C9B0`) to `Form12` and the second
(`0061E10C`) to `Form13`. The handler closes global `Form12`, then hides global
`Form13`, rather than acting on its receiver. A synthetic test uses a distinct
receiver, parameter dialog, and graphic form, and checks the close-before-hide
order and global-target identity without running drawing or printing code.

All 213 consolidated synthetic tests pass, and the Debug main-project rebuild
links. Coverage is 717/1,047 methods retaining listings (68.48%);
`Unit13.pas` is 52/55 (94.55%). Tracker: 178 items, 172 done, five blocked,
and one pending for deferred LazReport. No genealogy data was opened and
AhnWin was not started.

## Latest checkpoint — Unit19 no-op callback

Removed the compiler-generated try/finally listing from
`TForm19.namgv` (listing `0055748C`): the complete body performs no
domain-visible operation. Neither `Unit19.dfm` nor `Unit19.lfm` binds this
method, and no other source caller was found; its reachability remains
unknown. A synthetic `CreateNew` test verifies the handler preserves seeded
form and checkbox state without streaming the resource.

The focused Unit19 suite passes 9/9 tests; all 212 consolidated tests pass,
and the Debug main-project rebuild links. Coverage is 718/1,047 methods
retaining listings (68.58%); `Unit19.pas` is 17/28 (60.71%). Tracker: 177
items, 171 done, five blocked, and one pending for deferred LazReport. No
genealogy data was opened and AhnWin was not started.

## Previous checkpoint — DB navigator save-before-action dispatch

Restored the DFM/LFM-bound `TForm1.DBNavigator1BeforeAction` from the
complete listing at `005D9384` as `speich1(Sender)`. The event signature
matches the target method, and both form resources bind the navigator's
`BeforeAction` to this handler; the navigator is connected to `DataSource1`
(`Table1`). The callee implements the separately reconstructed person-row
save/delete/duplicate-number flow. The wrapper is intentionally not invoked
in tests because that path may post or delete a row; existing tests exercise
its provider-independent persistence helpers using synthetic datasets.

The test project and Debug main project build, and all 211 existing
synthetic tests pass. Coverage is 719/1,047 methods retaining listings
(68.67%); `frmAhnenWinMain.pas` is 246/323 (76.16%). Tracker: 176 items,
170 done, five blocked, and one pending for deferred LazReport. No genealogy
data was opened and AhnWin was not started.

## Previous checkpoint — Main-form dataset-control callbacks

Restored `TForm1.tabdisab` and `TForm1.tabenab` from listings `005D8834`
and `005D8858`. The calls at `DataModule2 +$005C` and `+$0080` map to
`Table1` and `Table5`: the declared component order places `DataSource19`
in slot 62, and the prior FOKO listing anchors that field at `+$014C`,
establishing the first component slot at `+$0058`. Both `Unit2.dfm` and
`Unit2.lfm` bind `DataSource1` to `Table1` and `DataSource5` to `Table5`.
The restored helpers disable and re-enable controls on those two datasets in
listing order. A synthetic test exercises both methods on inactive
`TSQLTable` instances without opening data; no DFM/LFM event binding or
additional runtime purpose is inferred.

All 211 consolidated tests pass; the forced Debug main-project rebuild links.
Coverage is 720/1,047 methods retaining listings (68.77%);
`frmAhnenWinMain.pas` is 247/323 (76.47%). Tracker: 175 items, 169 done,
five blocked, and one pending for deferred LazReport. No genealogy data was
opened and AhnWin was not started.

## Previous checkpoint — Graphic-form printer setup dispatch

Restored DFM/LFM-bound `TForm13.SpeedButton13Click` from listing `00572478`
as a direct `PrinterSetupDialog1.Execute` call; its Boolean result is ignored,
as in the listing. Both form resources bind the callback, and the button hint
is `Druckereinstellung`. The synthetic test injects a `TPrinterSetupDialog`
subclass whose virtual `Execute` records the call, so it verifies one
dispatch without opening the native printer dialog or running a print job.
This is only printer setup, not QuickReport/LazReport conversion or report
generation.

All 210 consolidated tests pass; the forced Debug main-project rebuild links.
Coverage is 722/1,047 methods retaining listings (68.96%);
`Unit13.pas` is now 53/55. Tracker: 174 items, 168 done, five blocked, and
one pending for deferred LazReport. No genealogy data was opened and AhnWin
was not started.

## Latest checkpoint — FOKO selector activation data source

Restored DFM-bound `TForm20.FormActivate` from listing `005CC690`. The
receiver's lookup combo now assigns `DataModule2.DataSource19` as its
`ListSource`. The target is corroborated by `Unit2` field order: the
DataSource19 field at `+$014C` is followed by the two Table19 persistent
fields and then Table20 at `+$0158`, matching the offsets used in the
activation and finish listings. `Unit2.dfm` binds DataSource19 to Table19
(`FKMG.db`, field `TX`); Table20 is `FOKO.DBF`, and the FOKO lookup lists and
keys on `TX`. The test creates only a synthetic `TDataSource` and lookup
control; it does not create/open a table or genealogy data.

All 209 consolidated tests pass; the forced Debug main-project rebuild
links. Coverage is 723/1,047 methods retaining listings (69.05%);
`Unit20.pas` is now 1/6. Tracker: 173 items, 167 done, five blocked, and one
pending for deferred LazReport. No genealogy data was opened and AhnWin was
not started. The separate `BitBtn1Click` database-generation path remains
unchanged.

## Latest checkpoint — Person-choice counter callbacks

Restored `TPersonEntryChoiceForm._PROC_005C6A20` and
`_PROC_005C6A50` from their complete listings. They increment and decrement
the 32-bit cell at `0253587C`, now preserved as `GlobalVar_0253587C`.
The DFM/LFM bind neither callback, and no other Pascal source reference to
the cell was found; no state meaning or event reachability is inferred.
Synthetic tests verify `41 -> 42` and `41 -> 40` on unstreamed dialog
instances.

All 208 consolidated tests pass, and the forced Debug main-project rebuild
links. Coverage is 724/1,047 methods retaining listings (69.15%);
`Forms\PersonEntryChoiceForm.pas` is now 0/6. Tracker: 172 items, 166 done,
five blocked, and one pending for deferred LazReport. No genealogy data was
opened and AhnWin was not started.

## Latest checkpoint — French Republican calendar conversion

Restored the complete DFM-driven `TForm7.berechnen` conversion. It now checks
for nonempty day/month/year text; dispatches the 12 Gregorian month-start
anchors; applies the listing's year-specific one-day adjustments; handles
ordinary days and complementary days; and formats/rechecks the final date
against 31.12.1805. Complementary entries are accepted only for Fructidor
with year item indices 2, 6, or 10. Invalid complementary entries retain the
German warning and clear the output; dates after the historical cutoff retain
the original message text/caption and clear the output.

The static month-start table includes the hidden first jump-table case at
`005CEFB4`; its `22.09.1792` value is inferred from the table alignment,
DFM month order, and the adjacent visible anchors. The unannotated year
comparison literals at `005CF0A4`/`005CF0C8` are resolved as I/IV by the
ordered DFM year choices; the other comparisons are directly visible in the
listing. Synthetic tests exercise all month starts, ordinary conversion,
leap complementary days in years III/VII/XI, the last accepted date, and the
post-cutoff output-clearing/message path. The test replaces the LCL message
box callback and restores it afterward, so no modal UI is opened.

All 206 consolidated tests pass; the forced Debug main-project rebuild links.
Coverage is 726/1,047 methods retaining listings (69.34%); `Unit7.pas` is
0/10 (0%). Tracker: 172 items, 166 done, five blocked, and one pending for
deferred LazReport. No genealogy data was opened and AhnWin was not started.

## Latest checkpoint — Place-dialog cancel navigation

Restored the DFM-bound `TForm33.BitBtn2Click` from listing `0053B5F8`, bound
to the place dialog's `Abbruch` button. In order, it activates
`Form1.TabSheet2`, closes global `Form33`, and closes global `Form38`. The DPR
creation calls corroborate both global form identities; the implementation
does not substitute the event receiver for either global target.

A synthetic test invokes the handler on a distinct receiver, builds only an
unstreamed main page control, and records that the target page is active
before both close events and that the close order is preserved. All 200
consolidated tests pass; the forced Debug main-project rebuild links.
Coverage is 727/1,047 methods retaining listings (69.44%); `Unit33.pas` is
1/6 (16.67%). Tracker: 171 items, 164 done, six blocked, and one pending for
deferred LazReport. No genealogy data was opened and AhnWin was not started.

## Latest checkpoint — Place-dialog activation prefill

Restored DFM-bound `TForm33.FormActivate` from listing `0053B630`. It copies
the selected item from global `Form14.ListBox1` into the receiver's `Edit1`.
Although DeDe labels the source offset as `Label4`, the DPR maps that global
slot to `TForm14`; the form declaration/resource and Unit14 listings identify
offset `+$0300` as `ListBox1`, with `ItemIndex` and `Items` accessors. The
translation preserves the selected-item lookup without adding an unobserved
empty-selection guard.

A synthetic test creates unstreamed `TForm14`/`TForm33` instances, selects a
sample list item, and verifies the text handoff. All 199 consolidated tests
pass, and the forced Debug main-project rebuild links. Coverage is 728/1,047
methods retaining listings (69.53%); `Unit33.pas` is 2/6 (33.33%). Tracker:
170 items, 163 done, six blocked, and one pending for deferred LazReport. No
genealogy data was opened and AhnWin was not started.

## Latest checkpoint — Main-form DBGrid3 Escape handler

Restored DFM/LFM-bound `TForm1.DBGrid3KeyDown` from listing `00604E48` with
the full `(Sender, var Key: Word, Shift: TShiftState)` event signature. On
Escape (`$001B`) it clears `DBComboBox3.Text`, hides `DBGrid3` and `Label81`,
then focuses `DBComboBox3`. It does not consume or rewrite the key; other keys
are no-ops.

Synthetic tests invoke the actual event method with `CreateNew` controls and
verify both branches, including unchanged keys and focus. All 198 consolidated
tests pass and the forced Debug main-project rebuild links. Coverage is
729/1,047 methods retaining listings (69.63%); `frmAhnenWinMain.pas` is
249/323 (77.09%). Tracker: 169 items, 162 done, six blocked, and one pending
for deferred LazReport. No genealogy data was opened and AhnWin was not
started.

## Latest checkpoint — Main-form DBGrid3 exit focus

Restored DFM/LFM-bound `TForm1.DBGrid3Exit` from its complete listing at
`00604E1C`. In order, it hides the receiver's `DBGrid3`, hides `Label81`, and
sets the receiver's `ActiveControl` to `DBComboBox3`. No dataset or lookup
method is called.

A synthetic `TForm1.CreateNew` test verifies both visibility changes and the
focus handoff using unstreamed controls. All 197 consolidated tests pass and
the forced Debug main-project rebuild links. Coverage is 730/1,047 methods
retaining listings (69.72%); `frmAhnenWinMain.pas` is 250/323 (77.40%).
Tracker: 168 items, 161 done, six blocked, and one pending for deferred
LazReport. No genealogy data was opened and AhnWin was not started.

## Latest checkpoint — Family-sheet counter zero cleanup

Restored the unbound `TForm32._PROC_00559D3C` from its complete listing. It
increments `GlobalVar_0061E0A8`; only when the result is zero does it clear
the long-string cells at `0061E0A4` and `0061E0A0`, then finalize the
15-element long-string array beginning at `0061E064`. The two `@LStrClr`
references and the `@FinalizeArray` element type/count establish the direct
cleanup contract. The matching decrement remains separate. Neither callback
is bound in the DFM, and state meaning/reachability remain unknown.

Synthetic tests verify nonzero preservation for all 17 strings and clearing
on the `-1` to `0` transition. All 196 consolidated tests pass and the forced
Debug main-project rebuild links. Coverage is 731/1,047 methods retaining
listings (69.82%); `Unit32.pas` is 4/6 (66.67%). Tracker: 167 items, 160 done,
six blocked, and one pending for deferred LazReport. No genealogy data was
opened and AhnWin was not started.

## Latest checkpoint — Descendant counter zero cleanup

Restored the unbound `TForm19._PROC_00558A15` from its complete listing. It
increments the address-backed integer `GlobalVar_0061E05C` and clears exactly
twelve long-string cells (`0061E014` through `0061E040`) only when the new
counter value is zero. The `@LStrClr` calls establish each cell's string type;
the Pascal assignments preserve the listing's reverse-address order. The
already restored decrement remains separate. Neither callback is bound in
the DFM/LFM, and the state purpose remains unknown. Other retained listings
reference two of the string cells; those workflows were not changed.

Synthetic tests verify that a nonzero increment preserves every string and
that the transition from `-1` to `0` clears all twelve. All 194 consolidated
tests pass and the forced Debug main-project rebuild links. Coverage is
732/1,047 methods retaining listings (69.91%); `Unit19.pas` is 18/28
(64.29%). Tracker: 166 items, 159 done, six blocked, and one pending for
deferred LazReport. No genealogy data was opened and AhnWin was not started.

## Latest checkpoint — Family-sheet counter decrement

Restored the unbound `TForm32._PROC_00559D98` from its complete
two-instruction listing. It subtracts one from the 32-bit cell at `0061E0A8`,
preserved as `GlobalVar_0061E0A8`. The neighboring increment listing confirms
the shared cell and performs separate zero-triggered string/array cleanup;
that cleanup was not added to the decrement. Neither callback is bound in
the DFM, and the counter's purpose remains unknown.

The test project now compiles `Unit32`; this exposed and fixed its missing
`ExtCtrls` interface dependency for the declared `TImage` controls. A
synthetic `CreateNew` test verifies ordinary decrement and zero-to-negative
behavior without loading the DFM. All 192 consolidated tests pass and the
forced Debug main-project rebuild links. Coverage is 733/1,047 methods
retaining listings (70.01%); `Unit32.pas` is 5/6 (83.33%). Tracker: 165 items,
158 done, six blocked, and one pending for deferred LazReport. No genealogy
data was opened and AhnWin was not started.

## Latest checkpoint — Descendant parameter counter decrement

Restored the unbound `TForm19._PROC_00558ABC` from its complete two-instruction
listing. It subtracts one from the 32-bit cell at `0061E05C`, now represented
as `GlobalVar_0061E05C`. The neighboring `_PROC_00558A15` independently
increments that same cell and clears string state on a zero result, confirming
the integer type; the decrement itself performs no cleanup. Neither callback
is bound in the DFM/LFM, and the counter's purpose remains unknown.

A synthetic `CreateNew` test verifies both ordinary decrement and
zero-to-negative transition, without streaming the resource or inferring
callback reachability. All 191 consolidated tests pass and the forced Debug
main-project rebuild links. Coverage is 734/1,047 methods retaining listings
(70.11%); `Unit19.pas` is 19/28 (67.86%). Tracker: 164 items, 157 done, six
blocked, and one pending for deferred LazReport. No genealogy data was opened
and AhnWin was not started.

## Latest checkpoint — Descendant list-type visibility

Restored DFM/LFM-bound `TForm19.ComboBox1Change` from listing `00558964`.
Every invocation first makes CheckBox7 and CheckBox8 visible, then hides
both only when the current combo text contains the case-sensitive substring
`alph`. The resource's two standard item captions do not contain that token;
the branch is preserved without assigning it a broader domain interpretation.

A synthetic test invokes the handler on an unstreamed form and verifies the
reset-visible behavior, case-sensitive match, and preservation of another
checkbox's visibility. All 190 consolidated tests pass and the forced Debug
main-project rebuild links. Coverage is 735/1,047 methods retaining listings
(70.20%); `Unit19.pas` is 20/28 (71.43%). Tracker: 163 items, 156 done, six
blocked, one pending for deferred LazReport. No genealogy data was opened
and AhnWin was not started.

## Latest checkpoint — Field-list print confirmation

Restored DFM-bound `TForm24.SpeedButton1Click` from listing `0055F698`. The
handler checks the receiver's `ListBox3`, `ListBox4`, and `ListBox6` in order.
If any list contains an item, it skips the confirmation prompt. If all are
empty, it asks the legacy Yes/No question; only Yes continues. Both accepted
paths set global `GlobalVar_02535B50` to `butt1` and set global `Form24`'s
modal result to `mrCancel`, preserving the listing's target split.

A synthetic test uses a nonempty receiver list and a distinct global target,
so it verifies the accepted path without opening a dialog. The empty-list
prompt branch is preserved but not run in tests. All 189 consolidated tests
pass and the forced Debug main-project rebuild links. Coverage is 736/1,047
methods retaining listings (70.30%); `Unit24.pas` is 4/26 (15.38%). Tracker:
162 items, 155 done, six blocked, one pending for deferred LazReport. No
genealogy data was opened and AhnWin was not started.

## Pre-restoration evidence checkpoint — French Republican conversion

This earlier map recorded the unresolved jump-table annotation and modal
branches before the full `TForm7.berechnen` translation. It was superseded by
the completed restoration documented in the latest checkpoint above; the
five provider/dependency blockers and deferred LazReport remain unchanged.

## Latest checkpoint — Descendant parameter number controls

Restored DFM-bound `TForm19.Button1Click` through `Button4Click`. Buttons 1/2
decrement/increment `Edit1`; Buttons 3/4 decrement/increment `Edit2`. Both
decrement handlers compare the displayed value with the lower-bound string
`'1'` before parsing and subtracting one. Increment handlers parse the text,
add one, and write the converted integer back. The complete listings and
DFM/LFM bindings establish the field-to-button mapping; `Unit19.dfm` gives
both numeric edits the initial value `1`.

Four synthetic tests invoke the real methods on unstreamed forms and verify
both fields, increments/decrements, and the lower-bound no-op. All 188
consolidated tests pass and the forced Debug main-project rebuild links.
Coverage is 737/1,047 methods retaining listings (70.39%); `Unit19.pas` is
21/28 (75.00%). Tracker: 160 items, 154 done, five blocked, and one pending
for deferred LazReport. No genealogy data was opened and AhnWin was not
started.

## Latest checkpoint — Field-list selection presets

Restored the DFM/LFM-bound `TForm24.RadioButton4Click` and
`RadioButton5Click` from complete listings `0055F528` and `0055F5E0`.
Despite the radio-button names, the resource captions say “alle markieren”
and “Markierungen entfernen”; the listings confirm that the handlers set
`CheckBox1` through `CheckBox11` all true or all false, respectively. They do
not touch `CheckBox12` through `CheckBox18` or either radio button's state.
Two synthetic tests initialize those eleven controls to the opposite state
and exercise the actual handlers.

All 184 consolidated tests pass and the forced Debug main-project rebuild
links. Coverage is 741/1,047 methods retaining listings (70.77%);
`Unit24.pas` is 5/26 (19.23%). Tracker: 159 items, 153 done, five blocked,
one pending for deferred LazReport. No genealogy data was opened and AhnWin
was not started.

## Latest checkpoint — First two field-list button pairs

Restored DFM/LFM-bound `TForm24.Button2Click` through `Button7Click`.
Button2/3 add the selected item from global `ListBox1`/`ListBox2` to global
`ListBox3`/`ListBox4`; Button4/5 delete the selected item from global
`ListBox3`/`ListBox4`; Button6/7 clear those corresponding target lists. The
list-field offsets are corroborated by `listanz`/`FormClose` and the matching
double-click handlers. The DFM/LFM arrows confirm the paired source/target
layout; the DeDe `Label*` annotations are not relied upon.

Six synthetic tests use distinct callback receiver and global target forms,
and assert the transfer/removal/clear effects plus source or receiver
preservation. All 182 consolidated tests pass and the forced Debug
main-project rebuild links. Coverage is 743/1,047 methods retaining listings
(70.96%); `Unit24.pas` is 7/26 (26.92%). Tracker: 158 items, 152 done, five
blocked, one pending for deferred LazReport. No genealogy data was opened
and AhnWin was not started.

## Latest checkpoint — Hofname list button actions

Restored DFM/LFM-bound `TForm24.Button1Click`, `Button8Click`, and
`Button10Click`. Button1 adds the selected item from global `Form24.ListBox5`
to `Form24.ListBox6`; when the target count is nonzero it disables the
receiver's `RadioButton1`/`RadioButton3` and checks `RadioButton2`. Button8
deletes the selected target item and re-enables receiver radio buttons 1 and
3 only when the list becomes empty. Button10 clears the global target list
and always re-enables those two receiver controls; neither removal path
changes RadioButton2.

Synthetic tests exercise addition, both branches of Button8's count check,
and clear, using a distinct callback receiver/global form. All 176 tests pass
and the Debug main-project rebuild succeeds. Coverage is 749/1,047 methods
retaining listings (71.54%); `Unit24.pas` is 13/26 (50.00%). Tracker: 157
items, 151 done, five blocked, one pending for deferred LazReport. No
genealogy data was opened and AhnWin was not started.

## Latest checkpoint — Single Hofname selection

Restored DFM/LFM-bound `TForm24.ListBox5DblClick` from complete listing
`0055F954`. If global `Form24.ListBox6` is already nonempty, it displays the
legacy warning `Es kann nur 1 Hofname ausgewählt werden, sonst gibt es
Durcheinander.` and does not continue. Otherwise it adds the selected item
from global `Form24.ListBox5` to global `Form24.ListBox6`; if the target now
has an item, the receiver's `RadioButton1` and `RadioButton3` are disabled and
`RadioButton2` is checked.

The synthetic test uses distinct receiver/global forms and covers the
nonmodal successful path only, avoiding the real warning dialog. All 173
consolidated tests pass; the forced Debug main-project rebuild succeeds.
Coverage is 752/1,047 methods retaining listings (71.82%); `Unit24.pas` is
16/26 (61.54%). Tracker: 156 items, 150 done, five blocked, one pending for
deferred LazReport. No genealogy data was opened and AhnWin was not started.

## Latest checkpoint — ListBox4 selected-item deletion

Restored `TForm24.ListBox4DblClick` from complete listing `0055F11C`. It reads
the current `ItemIndex` from global `Form24.ListBox4` and calls `Delete` on
that list's `Items`. Unit24's `FormClose` loop and the paired
`Button5Click`/clear handlers corroborate the component at offset `+$0304`
as `ListBox4`. Both the DFM and LFM bind this event to `ListBox4` and also to
`ListBox6`; the handler's listing targets the global `Form24.ListBox4`
regardless of `Sender`.

A synthetic test passes the receiver's `ListBox6` as `Sender` while the
global target is a distinct form; it verifies that only the target list's
selected item is deleted. All 172 tests pass. Coverage is 753/1,047 methods
retaining listings (71.92%); `Unit24.pas` is 17/26 (65.38%). Tracker: 155
items, 149 done, five blocked, and one pending for user-deferred LazReport.
No genealogy data was opened or the application started.

## Latest checkpoint — Paired field-list double-click transfers

Restored DFM-bound `TForm24.ListBox1DblClick` and
`TForm24.ListBox2DblClick` from complete listings `0055F00C` and `0055F080`.
They read the current selected item from global `Form24.ListBox1` or
`Form24.ListBox2`, then add that string to global `Form24.ListBox3` or
`Form24.ListBox4`, respectively. The same x86 operation sequences appear in
`Button2Click` and `Button3Click`; DFM/LFM geometry places each source/target
pair around the corresponding `>` button. This evidence resolves inaccurate
`Label*` comments in the disassembly.

Synthetic tests use a callback receiver distinct from global `Form24`, verify
the selected value is added to the correct target, and confirm the source
list and receiver target remain unchanged. All 171 consolidated tests pass
and the forced Debug main-project rebuild succeeds. Inventory: 754/1,047
methods retain listings (72.02%); `Unit24.pas` is 18/26 (69.23%). The tracker
has 154 items: 148 done, five blocked, and one pending for deferred LazReport.
No genealogy data was opened and the application was not started.

## Latest checkpoint — Field-list selected-item removal

Restored the DFM-bound `TForm24.ListBox3DblClick` from complete listing
`0055F0F4`. The listing loads global `Form24`, addresses the independently
corroborated `ListBox3` field at offset `+$0300`, obtains its `ItemIndex`, and
deletes that item from `Items`. The Pascal body preserves that explicit
global target. A synthetic test gives the event receiver and global target
different forms, selects the middle item in the target list, and verifies
only that target item is removed.

The consolidated suite passes 169/169 tests and the forced Debug main-project
rebuild succeeds. The refreshed inventory is 756/1,047 methods retaining
listings (72.21%); `Unit24.pas` is 20/26 (76.92%). The tracker has 153 items:
147 done, five blocked on provider/dependency evidence, and one pending for
user-deferred LazReport. No genealogy data was opened, and neither AhnWin nor
a test process remains running. This slice does not cover the other field
lists or report/database workflows.

## Previous checkpoint — Source-name list Enter dispatch

Restored the DFM-bound `TForm28.ListBox1KeyPress` from the complete listing at
`005747C0`. Its declaration now matches `TKeyPressEvent`
`(Sender, var Key: Char)`. Enter clears the shared name string, copies the
selected list item, and checks the helper's trimmed string result; an empty
entry retains the original German `ShowMessage`, while a nonempty entry keeps
its original whitespace, updates global `Form34.Label3.Caption` with the
literal `Aktueller Name: ` prefix, and shows global `Form34`. The DPR and
`Unit34.dfm` corroborate the target form and label.

A synthetic test covers a non-Enter no-op and a valid Enter selection,
including key preservation, the shared value, caption, visibility, and one
`OnShow` event. It does not trigger the modal empty-entry warning. The
consolidated suite passes 166/166 tests; the Debug main project builds.
Coverage is 759/1,047 retained listings (72.49%), with `Unit28.pas` at 4/9
(44.44%). The todo tracker now has 150 items: 144 done, five blocked on
provider/dependency evidence, and one pending for the user-deferred LazReport
migration. No genealogy data was opened and the AhnWin application was not
started.

Keep the provider-dependent Unit14 `FindKey` path, parent/child relationship
blockers, the unfinished calendar conversion, and deferred LazReport scope
unchanged.

## Previous checkpoint — Source-name list double-click

Restored DFM-bound `TForm28.ListBox1DblClick` from the complete listing at
`005748EC`. It clears and copies the shared name from
`ListBox1.Items[GlobalVar_025353A0]`, assigns global `Form34.Label3.Caption`
to the exact `Aktueller Name: ` prefix plus the original item text, then shows
global `Form34`. This preserves use of the previously stored selection index
rather than reading `ListBox1.ItemIndex` in the handler. The target form and
label are corroborated by the DPR and `Unit34.dfm`.

A synthetic test seeds a stored index that differs from the list's current
`ItemIndex`, invokes the handler on a separate source form, and verifies the
shared string, exact caption, global target visibility, `OnShow`, and unchanged
list selection. The complete suite passes 167/167 tests, and the Debug main
project builds. Coverage is 758/1,047 methods with listings (72.40%);
`Unit28.pas` is 3/9 (33.33%). The tracker has 151 items: 145 done, five
blocked on provider/dependency evidence, and one pending for user-deferred
LazReport. Relationship/provider blockers and reporting scope remain
unchanged; no genealogy data or application was used.

## Latest checkpoint — Source-editor list double-click

Restored the DFM-bound `TForm29.ListBox1DblClick` from listing `00562060`.
The event reads the current list's `ItemIndex`, clears and assigns
`GlobalVar_0061E0EC` from that item, sets global `Form30.Label4.Caption` to
the exact `Aktuelle Quelle: ` prefix plus the source name, then shows global
`Form30`. The DPR maps the global to `TForm30`; the DFM binds the event and
contains `Label4`; the listing directly identifies the label control. `Unit30`
is an implementation-only dependency of `Unit29`.

A synthetic test uses separate list and editor forms, seeds stale shared text,
and verifies the selected item, exact caption, editor visibility, and one
`OnShow` event without streaming the database-backed editor DFM. All 168
consolidated tests pass, and the forced Debug main-project rebuild links.
Coverage is 757/1,047 listings (72.30%); `Unit29.pas` is 2/8 (25.00%). The
todo tracker has 152 items: 146 done, five blocked, and one pending for
user-deferred LazReport. No genealogy data was opened and the application was
not started. Keep adjacent source-editor save/maintenance handlers and all
BDE/SQLDB-dependent paths separate from this UI handoff.

## Actual source-restoration status — 2026-09-30

The todo percentages below are workflow tracking only; they are not the
percentage of the decompiled program translated to Pascal. The reusable
per-file scan found 251/323 class-qualified methods in
`frmAhnenWinMain.pas` retaining listings (77.71%). Within the `TForm1` class
specifically, 251/283 retain listings (88.69%); the distinction is that the
file also contains other classes. Across all 69 Pascal files, 757/1,047
class-qualified methods retain listings (72.30%). The reconstructed
`Forms\PersonSearchForm.pas` is 218/225 (96.89%) by this listing-presence
metric. The full refreshed table is
`AhnWin-Assembly-Coverage-2026-09-30.csv`; methods without listings are not
automatically considered reconstructed.

**Gregorian calendar counter callbacks:** `TGregorianCalendarForm._PROC_005CE618`
increments the integer cell at `025358EC`, while `_PROC_005CE648` decrements
the same cell. Neither method is bound in the DFM/LFM, and no consumer or
domain meaning is known. Their direct effects are restored through
`GlobalVar_025358EC` and covered with synthetic form instances; no reachability
or purpose is inferred.

**Person-search edit exit dispatch:** The DFM binds `Edit2.OnExit` to
`TPersonSearchForm.Edit2Exit`; listing `005841CC` contains a direct call to
`Button1Click` and returns. The Pascal handler now forwards `Sender` to that
method. `Button1Click` itself remains assembler-backed and includes the
provider-dependent person lookup, so the wrapper was compile-validated but
not invoked in a test or against genealogy data.

**Main-form database-edit mouse-down no-op:** Both main-form resources bind
`DBEdit5.OnMouseDown` to `TForm1.DBEdit5MouseDown`. Its complete listing
contains only the standard frame setup/teardown and `ret $000C`; there are no
control or global accesses. The stack cleanup is consistent with Delphi's
register-convention `TMouseEvent` parameters after the first two arguments
are passed in registers. The restored Pascal method has the full
`(Sender, Button, Shift, X, Y)` signature and an empty body. The synthetic
no-op test invokes it without streaming the main form or opening its dataset.

**Person-edit `DBEdit69` reset localized — 2026-10-04:** The frame's bound
`DBEdit69Change` now clears address-named strings `0061E0A0`, `0061E0A4`,
and `02535B58` through `AHW52LegacySharedState`, in the original listing
order. The FPC `TForm1` adapter and `peaDBEdit69Change` action were removed.
A conditional compatibility proxy remains for the unconverted Delphi DFM
binding; tab-entry and navigator/focus host boundaries remain.

**Details relationship-combo focus localized — 2026-10-04:** The full
`ComboBox5Change` listing assigns the active control to hidden `Edit4`. The
Delphi DFM proves that this is a `TEdit` under the Details tab, but that
resource was missing from the FPC frame. Restored its observed bounds,
`MaxLength`, tab order, and hidden state in `TAHW52PersonDetailsFrame`; the
frame now assigns the containing form's `ActiveControl` to its own `Edit4`.
Removed the FPC host-action route; a conditional proxy remains for the old
Delphi DFM binding. The focused Details tests pass 2/2, the full suite passes
466/466, and the forced Debug main build links. No database or relationship
mutation behavior was enabled.

The two cells also used by `Unit32` now have one shared Pascal declaration.
Its counter-zero path retains its original behavior: clear those two cells
and finalize the Unit32 string array, without clearing the third cell.
Synthetic tests assert direct frame execution, no host dispatch, and shared
storage observed through Unit32's cleanup. Focused edit-frame tests pass
6/6, the full suite passes 466/466, and the forced Debug main build links.
No state-domain semantics or provider behavior is inferred.

**Main-form grid Escape handoff:** Both main-form resources bind
`StringGrid5.OnKeyDown` to `TForm1.StringGrid5KeyDown`. The complete listing
compares the `Word` key by reference with `$001B` and, only for Escape, sets
the receiver's `StringGrid5.Visible` property to `False`. The
`ret $0004` matches the stack-passed `Shift` argument under Delphi's register
convention; the handler does not consume or rewrite `Key`. Its synthetic test
checks Escape and an ordinary key using an unstreamed form and grid.

**Field-list dialog cancel state:** `Unit24.dfm` and `.lfm` bind the
`Abbruch` button to `TForm24.SpeedButton2Click`. The complete listing assigns
the exact string sentinel `butt8` to `GlobalVar_02535B50`, then writes modal
result `2` to the global `Form24` instance. The restored handler preserves
that order as a string assignment followed by `Form24.ModalResult := mrCancel`.
A synthetic test confirms both effects and distinguishes the event receiver
from the global target without streaming the data-bound form. `Unit24.pas`
now has 21/26 methods with retained listings (80.77%). The consolidated
suite passes 164 tests, and the Debug main Lazarus project builds.

**Field-list checkbox gate callbacks:** Both form resources bind
`CheckBox17Click` and `CheckBox18Click`. Both complete listings read
`CheckBox17.Checked`; if it is false they set `CheckBox18.Checked` to false.
The second handler does not read its own `CheckBox18` state, so the
cross-control behavior is preserved as listed rather than normalized from
the control caption. Synthetic tests cover both gate values for both handlers
without streaming the form or invoking the report workflow.

**French Republican calendar input dispatch:** Both DFM and LFM bind all
three `ComboBox*Change` callbacks. Each complete listing checks its own
combo's text length and calls the no-argument `TForm7.berechnen()` only when
nonempty; all call-site annotations identify that zero-argument helper. The
callbacks were restored before the separate conversion reconstruction; at
that checkpoint, `berechnen`'s listing remained untouched. The empty-input
guard test verifies that existing output is preserved. The later complete
conversion is documented in the latest checkpoint at the top of this file.

**Descendant-list checkbox presets:** Both form resources bind
`TForm19.RadioButton1Click` and `RadioButton2Click`. Their complete listings
set each of the 17 checkboxes to `True` and `False`, respectively, without
changing either radio button. The restored handlers preserve those direct
effects; two synthetic tests check all 17 controls for each preset.
The DFM/LFM-bound `CheckBox15Click` also directly forces `CheckBox15.Checked`
to `True`; its synthetic test preserves this separate click behavior.
`Unit19.pas` now has 25/28 methods with retained listings (89.29%). The
consolidated suite passes all 133 tests, and the Debug main Lazarus project
builds.

**Choice-dialog checkbox presets:** The complete `TForm31.CheckBox9Click`
listing marks CheckBox1-9 and CheckBox11-16 while clearing CheckBox10; the
`CheckBox10Click` listing clears all 16 controls. The DFM does not bind either
handler, so no runtime reachability or new event wiring is claimed. Synthetic
tests invoke the methods directly; after this preset slice the unit had 2/6
methods with retained listings.
The two remaining direct dismiss methods are also restored:
`BitBtn1Click` hides the global `Form31`, while `BitBtn2Click` closes it.
Neither is bound as an `OnClick` in the DFM; synthetic tests call them on a
separate receiver and assert the global-target effect without adding bindings.
`Unit31.pas` now has 0/6 methods retaining listings.

**Place-search finish action:** The DFM-bound `TForm14.BitBtn1Click` first
clears the saved selection index (`0061DFC0`), resets `ListBox1.ItemIndex` to
zero, then closes the global `Form14` instance. A synthetic test observes
both resets from the target form's `OnClose` callback while invoking the
handler on a distinct receiver. `Unit14.pas` now has 5/9 methods retaining
listings.

**Source-list finish action:** `Unit29.dfm` binds the `Fertig` speed button to
`TForm29.SpeedButton1Click`. The handler clears the saved index, resets the
list index, then writes modal result 2 (`mrCancel`) to the global `Form29`.
The synthetic test checks the state on a separate receiver and modal result
on the global target. `Unit29.pas` now has 4/8 methods retaining listings.

**Source-list save dispatch:** The DFM-bound `TForm29.Button1Click` listing
contains one call to `TForm1.Lb_speich`, passing the global `Form29`. The
main-form method's own listing compares this sender with the same global and
selects the `Quellen` category. The handler is restored as
`Form1.Lb_speich(Form29);`; the called routine is unchanged. No runtime test
invokes it because the target opens a save dialog and performs file/provider
work. Both Lazarus projects compile the changed unit, and the synthetic suite
still passes 139 tests. `Unit29.pas` now has 3/8 methods retaining listings.

**Shared save-dialog dispatches:** The DFM-bound `Speichern` buttons in
`Unit14`, `Unit28`, `Unit36`, and `Unit39` each call
`TForm1.Lb_speich` with the corresponding global form instance. The DPR
`CreateForm` entries corroborate the address-to-class mapping; the callee's
listing identifies these targets as `Orte`, `Namen`, `Berufe`, and
`Hofnamen`. Restored the four wrappers without changing or executing the
save-dialog/provider/file-writing callee. The main and test projects compile;
the synthetic suite remains 139/139 and intentionally does not launch these
external side effects. Coverage is 798/1,047 (76.22%); Unit14 is 4/9,
Unit28 is 6/9, and Units36/39 are each 2/8.

**French Republican calendar form scaling:** `Unit7.dfm` binds
`TForm7.FormCreate`. Its complete listing checks `Screen.Width > 640`, then
`Screen.Height > 480`, and only then calls `ScaleBy(Screen.Width, 640)`.
The restored nested conditions retain that evaluation order. A synthetic
`CreateNew` test verifies the resulting width on the current screen and the
unchanged width when either threshold is not met. The full suite passes 140
tests, the Debug main project builds, and `Unit7.pas` is now 5/10; total
coverage is 797/1,047 (76.12%). The Republican-calendar date conversion code
remains untouched.

**Ancestor-graphics checkbox presets:** The DFM binds the two radio callbacks
in `Unit12` as “alle markieren” and “Markierungen löschen”. Their complete
listings set `CheckBox1` through `CheckBox8` to `True` and `False`,
respectively; only those controls are changed. Synthetic tests initialize
each checkbox to the opposite state and invoke the real handler. All 142
tests pass; the Debug main project builds. Coverage is now 795/1,047
(75.93%), with `Unit12.pas` at 2/7 methods retaining listings. Generation
and provider-backed save handlers remain unchanged.

**Graphics-parameter dialog initialization:** `Unit12.dfm` binds `FormShow`.
The handler zeros eight address-backed integer flags; shows CheckBox1,
CheckBox2, Label2, and SpinEdit2; hides CheckBox8; additionally hides
CheckBox2/Label2/SpinEdit2 when the shared mode string contains `Nachgr`; and
sets SpinEdit1 as active control. Synthetic tests cover both the default and
descendant-mode visibility paths and all eight resets. The complete suite
passes 144 tests; coverage is 794/1,047 (75.84%), and `Unit12.pas` is 1/7.
The `Vorgr` substring result in the listing has no conditional branch before
the unconditional active-control call, so no conditional focus behavior is
added. Generation remains untouched.

**Graphics-parameter finish dispatch:** `SpeedButton1Click` copies only
checked CheckBox1–8 values into the eight address-backed flags (it does not
clear unchecked flags), then dispatches exact `Vorgr1`, `Vorgr2`, `Nachgr1`,
or `Nachgr2` modes to global `Form13`. The ancestor modes require
`SpinEdit1.Value < 15`; otherwise the listing shows its 14-generation warning.
`Nachgr1` additionally invokes `Form13.Button2.Click` after showing it. Every
successful dispatch sets global `Form12.ModalResult` to literal 2, matching
the cancel result used by the separate cancel button. The `Button2` dynamic
call and DFM/LFM component-type discrepancy are recorded in the reconstruction
guide. Synthetic tests use an unstreamed Form13 and a stub click callback, so
they validate the dispatch without running the graphic generator. The full
suite passes 149 tests; current coverage is 793/1,047 (75.74%), with
`Unit12.pas` at 0/7. The modal over-limit message and the generator's own
`OnShow` workflow are not executed by tests.

**FOKO selector focus handoff:** `Unit20.dfm` binds
`dblookupcombobox1Click`. Its complete two-instruction listing retrieves
`TForm20.Edit1` and passes it to `TCustomForm.SetActiveControl`; the handler
is restored as `ActiveControl := Edit1`. A synthetic `CreateNew` test creates
only Edit1, invokes the event, and checks the active control. The other
FOKO-generation actions remain assembler-backed and untouched. The full suite
passes 150 tests, the Debug main project builds, and coverage is now 792/1,047
(75.64%); `Unit20.pas` is 2/6.

**Choice-dialog counter callbacks:** `TForm31._PROC_00563108` and
`_PROC_00563138` have no form-resource binding. Their complete listings
increment and decrement integer cell `0061E108`; the restored methods retain
the address as `GlobalVar_0061E108`. Synthetic tests verify only these direct
arithmetic effects; callback reachability and state meaning remain unknown.

**FOKO dialog counter callbacks:** `TForm21._PROC_005CC40D` increments and
`_PROC_005CC43C` decrements integer cell `025358D8`. Neither DFM nor LFM binds
the callbacks. They now use `GlobalVar_025358D8`, and synthetic tests assert
only the directly observed arithmetic operations.

**Data-module counter callback:** `TDataModule2._PROC_00533514` directly
decrements integer cell `0061DF0C`. Its body now uses `GlobalVar_0061DF0C`;
the synthetic `CreateNew` test verifies only the arithmetic effect. No DFM/LFM
binding or state meaning is inferred.

**Graphics parameter callbacks:** `TForm12._PROC_00562BB1` and
`_PROC_00562BE0` are not bound in `Unit12.dfm`; their complete listings
increment and decrement integer cell `0061E100`. These direct effects are
restored under `GlobalVar_0061E100` and covered by synthetic tests. No
consumer, semantic name, or callback reachability is established.

**Source dialog counter callbacks:** `TForm30._PROC_005611A1` and
`_PROC_005611D0` are unbound in both form resources. Their complete listings
increment and decrement integer cell `0061E0E4`; Pascal preserves that
address through `GlobalVar_0061E0E4`. Synthetic tests verify both arithmetic
effects only.

**FOKO dialog counter callbacks:** `TForm20._PROC_005CD7E9` and
`_PROC_005CD818` are unbound and directly increment/decrement integer cell
`025358E0`. The restored methods retain the address as
`GlobalVar_025358E0`; synthetic tests establish only the arithmetic effects,
with no claim about the cell's purpose or callback reachability.

**GEDCOM parameter counter callbacks:** `TOKBottomDlg1._PROC_0054DD45` and
`_PROC_0054DD74` increment/decrement integer cell `0061DFF0`. Neither form
resource binds them. Their direct arithmetic is restored with an
address-preserving global and synthetic tests; no state meaning or runtime
reachability is asserted.

**Tiny-Tafel parameter counter callbacks:** `TOKBottomDlg._PROC_0054F575`
and `_PROC_0054F5A4` directly increment/decrement integer cell `0061DFF8`.
They are not form-resource-bound; address-based state and synthetic
arithmetic tests preserve only the listing-proven effects.

**Comparison parameter callbacks:** The unbound
`TForm35._PROC_005CFAA4`/`_PROC_005CFAD4` pair increments/decrements integer
cell `025358FC`. Address-based state and synthetic tests preserve only this
direct behavior; the pair has no DFM/LFM event binding.

**Field-list counter callbacks:** `TForm24._PROC_0055FA85` increments
`0061E0D4`, clearing the strings at `0061E0D0` and `0061E0CC` only when the
new count is zero. `_PROC_0055FAC8` decrements the same counter. Neither
resource binds the callbacks; their address-preserving restoration has
synthetic tests for nonzero increment, zero-clear, and decrement.

## Consolidated tests

All current AhnWin52 test suites are registered in the FPCUnit project
`FPC\AhnWin52Tests.lpi`; their Pascal sources are under
`Source\AhnWin52Tests`. This follows the repository convention of keeping
source code under `Source` and toolchain-specific project files under `FPC`.
The suites follow the
`Source\Test_Gen\tst_GedComFile.pas` structure and import `fpcunit`,
`testutils`, and `testregistry`. Build with `lazbuild`, then run
`bin\x86_64-win64\AhnWin52Tests.exe --all --format=plain`. The suite is
synthetic-only; it does not open supplied genealogy data or launch AhnWin.
The current project build completes and all 159 registered tests pass.

## Candidate order

### 1. Calendar unit and year navigation (`GregorianCalendar`)

**Status:** Calendar generation, year navigation, and the listing-backed
print-handler control sequence are implemented; model tests pass for every
supported year and the isolated form builds. The two address-based callbacks
restore paired mutations of global `025358EC` through `GlobalVar_025358EC`.
Synthetic tests verify only the increment and decrement. Their consumers,
semantic purpose, and event associations remain unresolved. Native form
printing is not exercised by the FPC build.
**Effort:** Completed for the date-grid and bounded print-handler slices;
native printing remains an external-platform boundary.  
**Value:** Medium; provides a useful, buildable UI/domain slice.  
**Evidence:** The numbered unit/class are now named for their established
purpose: `TGregorianCalendarForm` / `GregorianCalendar`. The visual files live
directly in `Source\AhnWin52\Forms` (the view folder). The isolated Lazarus project, both DPR
references, and form resource roots use the new names. The
disassembly for `btnFollowYearClick`, `btnPrevYearClick`, and `edtYearChange`
shows the 1582–2499 range, warning messages, increment/decrement, and calls to
`Kal`; edit changes are checked only at four characters. The reconstructed
`Kal` delegates date placement to the non-visual
`Source\AhnWin52\Model\GregorianCalendarModel.pas`. The form depends on
`IGregorianCalendarViewModel`; `TGregorianCalendarViewModel` is injected at the
Lazarus composition root and exposes display text, leaving the form decoupled
from its implementation. The three 28x7 grids each display four consecutive
months. The standalone Pascal test program checks all years 1582–2499,
month/day anchors, leap-century cases, the endpoint guards, and the ViewModel
contract.
**Follow-up:** Retain the callback listings under their address-based names.
Available Pascal/DFM/LFM evidence does not identify the counter's consumers
or justify binding either callback. Do not use genealogy database data or
claim print-output parity.

### 2. FOKO current-row deletion (`Unit21.Zeilelschen1Click`)

**Status:** Implemented with an isolated confirmation-gated dataset service;
synthetic confirm/cancel tests pass and the Unit21 project builds.  
**Effort:** Completed.  
**Value:** Low/medium; restores one concrete edit action.  
**Evidence:** The DFM binds the “Zeile löschen” menu item to this handler and
binds the grid to `DataModule2.DataSource20`; the data-module resource maps that
source to `Table20` (`FOKO.DBF`). The listing displays “Diese Zeile löschen ?”
as a confirmation dialog and invokes `TDataSet.Delete` only for `mrYes`.
**Checks:** `Source\AhnWin52Tests\tst_AHW52_FokoRowDeletionTests.pas` exercises accepted deletion,
cancellation, and nil-dataset rejection with an in-memory `TBufDataset`. The
isolated `AHW52_Form21.lpi` build passes with its existing `CmpSQLTable`
package dependency. No supplied genealogy database was opened.

### 3. About-dialog lifecycle (`Forms\AboutForm`)

**Status:** Unit/class/form identifiers unified as `AboutForm` /
`TAboutForm` / `AboutDialog`. Click-to-hide, mouse-down-to-close,
Escape-to-close, show-time refresh, copyright, and file-date captions are
reconstructed. Delphi and Lazarus resources are both named `AboutForm.*`;
the isolated form build and synthetic tests pass. The `Timer1Timer` handler
is restored as a direct `Close` call, but the timer has no `OnTimer` binding
in either resource. `FormCreate` now captures the global form's client
dimensions into the verified address-backed cells; their downstream
consumers remain unidentified.  
**Effort:** Very low.  
**Value:** Low; useful as a controlled warm-up, not a substantive domain slice.  
**Evidence:** The event listings prove `Hide`, unconditional `Close`,
Escape-gated `Close`, and `Refresh`. `Form1.FormCreate` initializes the two
date globals from `AHNWIN51.exe` and `awd.db`; its `FormShow` and the About
activation listing corroborate the rendered captions. `Timer1` has a 5000 ms
interval but no `OnTimer` binding; direct invocation of `Timer1Timer` is
covered by a test, which does not establish event reachability. `FormCreate` on the About form stores
the two startup file-date snapshots; its dimension writes still target
unresolved globals.  
**Checks:** `AHW52_About.lpi` isolated build and `FPC\AhnWin52Tests.lpi`
synthetic-file tests; the full runner passes 40 tests. Missing-file
notifications go through an injectable message-service interface and are
verified with a recording fake, not a modal dialog. Preserve the unbound timer
and unresolved dimension state; do not add an `OnTimer` binding.

### 4. Application startup and main-form mapping

**Effort:** Medium.  
**Value:** High; clarifies the executable entry point and provides a route to
build the larger application independently of QuickReport.

**Evidence:** `AHNWIN51.dpr` refers to missing `Unit1.pas`; the source tree has
`frmAhnenWinMain.pas` declaring `TForm1`. The project refers to `Unit8.pas`,
while the available splash form is `Forms\frm_Splash.pas`. AhnWin 5.2 startup
projects provide additional composition evidence.

**Progress:** The entry-point sequence now appears in `AHW52_Main.lpr`, and
the existing `AHW52_Splash.lpi` project builds the splash form independently.
`AHW52_Main.lpi` now compiles and links after repairing nested Pascal comment
boundaries in the DeDe listing. Do not add empty stubs for behavior that is
still under construction.

**Implemented handler slice:** `TForm1.GregorianischerKalender1Click` is
reconstructed from the menu binding and x86 listing. It selects `TabSheet2`,
retains the `speich1(Sender)` call, creates the renamed
`TGregorianCalendarForm` locally, injects `TGregorianCalendarViewModel`, opens
it modally, and frees it in `finally`. The legacy `TForm6` global is not
restored. `speich1` is now reconstructed and synthetic-tested as described
below; this handler still does not imply that every pending edit is posted.

**Reconstructed keyboard handler:** The main-form resource binds
`OnKeyPress = FormKeyPress`. The x86 listing proves Enter is consumed and
`WM_NEXTDLGCTL` is posted to move focus; other keys are unchanged.
`FormKeyPressBehavior.pas` isolates the key decision for testing. Its
reference assembler block is removed now that the handler has been restored.

**Main-form contract map:** The linked wiki map classifies lifecycle,
navigation, persistence/CRUD, relationship, file/import/export, reporting,
graphics, and unidentified callbacks by evidence, side effects, and
dependencies. Its original priority placed `speich1` analysis before
`FormClose`; both slices are now documented, with synthetic datasets still
required before larger CRUD/search workflows.

**Exit-menu sequence:** `beenden1Click` now matches the retained listing:
invoke `Datenschutzaus1.Click`, activate `TabSheet2`, then call `Close`. The
completed handler no longer retains its assembly-reference block. Its
`MainFormExitBehavior` coordinator is verified with recording doubles for
exact ordering, early failure, and nil-interface rejection.
`FormClose` is separately reconstructed with its own tested close-time
sequence. The separate [privacy-mode round-trip](C:\Projekte\Delphi\docs\modules\applications\ahnwin51\privacy-mode.md)
is now reconstructed and tested.

**Navigation/focus handlers:** `PageControl1Exit` is a return-only handler.
The complete `ComboBox5Change` listing sets `ActiveControl := Edit4`; its
resource and local frame implementation are covered in the Details focus
increment above. Both completed assembly-reference blocks were removed.
Static resource/body assertions and the main Lazarus build pass.

**Listing-proven inert handlers:** The DFM binds `TabSheet4Show`,
`ComboBox4DblClick`, and `DBEdit8Change`, `DBEdit9Change`, and `DBEdit10Change`.
Their complete listings at `0060D204`, `0061751C`, and `00617528`/`2C`/`30`
contain only `ret`. The restored Pascal bodies are intentionally empty, and a
synthetic unstreamed `TForm1` test invokes all five and checks that form state
is unchanged. No data-bound resource or records are loaded.

**Additional inert lookup Enter handlers:** Eleven methods,
`TForm1.DBLookupComboBox1Enter` through `DBLookupComboBox11Enter`, each have a
complete listing containing only `ret`. They are restored as empty Pascal
bodies and added to the existing unstreamed main-form test. No DFM/LFM
bindings were found, so this proves only their direct no-op behavior and does
not infer event reachability. The consolidated suite passes 150 tests and the
Debug main project builds. Current inventory is 780/1,047 methods retaining
listings (74.50%); `frmAhnenWinMain.pas` is 256/323 (79.26%).

**Edit-tab focus handoff:** Both main-form resources bind `TabSheet2.OnShow`
to `TForm1.TabSheet2Show`. Its complete listing at `006134CC` references
`TForm1.DBEdit2` and calls `SetActiveControl`; the handler now assigns
`ActiveControl := DBEdit2`. A synthetic `CreateNew` form with only DBEdit2
created verifies the active-control target without streaming the data module.
The consolidated suite passes 151 tests, and the Debug main project builds.
Current inventory is 779/1,047 methods retaining listings (74.40%);
`frmAhnenWinMain.pas` is 255/323 (78.95%).

**Calendar receiver-close handler:** `TForm7.Button1Click` has a complete
listing at `005CF1F8` that calls `TCustomForm.Close` on the method receiver.
The existing Pascal body already matched this direct effect; its listing is
now removed. A synthetic `OnClose` test verifies the receiver closes. Neither
the DFM nor LFM binds `Button1Click`, so no reachability is inferred; the
separate, resource-bound `BitBtn1Click` finish path is unchanged. The
consolidated suite passes 152 tests and the Debug main project builds.
Current inventory is 778/1,047 methods retaining listings (74.31%);
`Unit7.pas` is 4/10 (40%).

**Main-record persistence:** `speich1` now posts then deletes an empty-name
row in the legacy pre-key states. In `dsInsert`, it checks the number against
`Table3` and either displays the index error or posts the row. Declaration
order maps listing offsets `+$5C`, `+$6C`, `+$534`, `+$540`, and `+$544` to
`Table1`, `Table3`, `Table1Nummer`, `Table1Name`, and `Table1Vornamen`.
Comparison with `schen1Click` identifies virtual slot `+$248` as `Post`.
The Lazarus `TSQLTable` derives from `TCustomSQLQuery` and does not expose
BDE `FindKey`; because `Table3` has a persistent `Nummer` field and no explicit
index override, the migrated handler uses `Locate('Nummer', ...)`. This
preserves the observed key lookup and found/not-found flow; provider-specific
default-index behavior remains unverified without opening the supplied
database. The FPC port skips `Post` in browse mode because FPC raises there,
while the original Delphi call is a no-op; deletion behavior is preserved.
See the linked wiki analysis for details.

**Status:** Completed and validated; the synthetic runner and main project
build pass.

**Synthetic persistence checks:** `FPC\AhnWin52Tests.lpi`
uses only an in-memory `TMemDataset` to check empty browse/insert/edit row
deletion, preservation of a named row, duplicate rejection without post,
unique-number post, lookup hit/miss and cursor positioning, and nil-dataset
rejection. Both the test runner and
`AHW52_Main.lpi` build and link successfully. The application was not launched
and no genealogy database was opened. `FormClose` has since been reconstructed
as a separate lifecycle slice; this persistence runner does not claim that
all edits are saved on close.

**Checks:** Static call-order assertions against the recovered `.dpr`;
`AHW52_Splash.lpi` and `AHW52_Main.lpi` build without launching the
application or opening genealogy databases. The isolated Enter-key behavior
test passes for Enter, `A`, and Escape. The main build reports three
nested-comment warnings in other preserved listings. The explicit QuickReport
compile-compatibility boundary is isolated and tested, but report behavior
remains unsupported; keep the LazReport migration as a separate deferred
feature. The `speich1` synthetic dataset contract is established; `FormClose`
the privacy round-trip, and both parent-unlink actions are reconstructed and
validated separately. The next main-form workflow is to map one parent-
insertion action and establish its synthetic person-lookup contract.

### 4. Main-form close lifecycle (`TForm1.FormClose`)

**Status:** Reconstructed and validated.  
**Effort:** Medium.  
**Value:** High; this closes the main-form persistence/termination boundary.

**Evidence:** The x86 listing and event binding establish the full order:
activate `TabSheet2`, call `speich1`, remove `_q*.*` entries, then ask for
confirmation. A negative answer sets `CloseAction := caNone` after those
pre-confirmation effects. A positive answer conditionally posts `Table1` and
`Table5`, calls `datsich` when `Table1Nummer > 0`, closes `Table1`, `Table4`,
`Table5`, `Table20`, and `Table35`, removes `vorfa.txt`/`kn.txt`, writes the
caption record to `par.cfg`, performs the BDE password-cache step, and
terminates the application. Data-module declaration order maps the component
and field offsets; the independent wiki page is
`C:\Projekte\Delphi\docs\modules\applications\ahnwin51\form-close-lifecycle.md`.

**Port boundary:** Lazarus `FileListBox2` had a converted `C:\lazarus`
directory unlike the DFM. The adapter sets its directory to `GetCurrentDir`
before applying the mask. `Post` is skipped in browse mode because FPC raises
there while Delphi treats it as a no-op. Database-post failures are reported
and the remaining close sequence continues. SQLDB has no corresponding BDE
`TSession.RemoveAllPasswords`; the port exposes this as an explicit
no-side-effect adapter boundary.

**Checks:** `FPC\AhnWin52Tests.lpi` builds and its runner passes for
confirmed/cancelled call order, failure propagation, nil-interface rejection,
and exact 51-byte caption data (including 50-character truncation and
zero-filled tail). `AHW52_Main.lpi` builds and links in Debug mode. Neither
test nor build launches the application or opens genealogy data.

**Follow-up:** See the completed, separately documented privacy-mode
round-trip below. Keep the user-data and BDE adapter boundaries explicit.

### 4.1. Privacy mode (`Datenschutzein1Click` and `Datenschutzaus1Click`)

**Status:** Reconstructed and validated; both assembler-reference blocks
removed.  
**Effort:** Medium.  
**Value:** High; the mode changes person visibility across multiple related
tables and is invoked by the main-form exit command.  
**Evidence:** Menu bindings, the `Unit2` declaration/resource order, persistent
fields, and `TDataSet` virtual property signatures map the table offsets and
`Filter`/`Filtered` calls. Enabling first clicks the disable command, then
requests a positive year and applies the birth-/baptism-year filter to five
tables. Disabling clears six tables, resets the shared limit, truncates the
caption at `(Datenschutz`, restores the person by number, and refreshes the
view. `Table5` is cleared only on disable.  
**Port boundary:** The original `TMessageForm._PROC_00445B24` is absent; the
Lazarus adapter uses `InputQuery` and integer conversion. The four caption
separator spaces are preserved exactly, including accumulation on repeated
activation. The shared privacy threshold is represented by
`PrivacyModeState`; the original global symbol name remains unknown.  
**Checks:** `Source\AhnWin52Tests\tst_AHW52_PrivacyModeTests.pas` checks enable, disable, cancellation,
filter ordering, caption behavior, current-person restoration, and invalid
interface rejection using a recording fake. The runner passes, and
`AHW52_Main.lpi` builds and links in Debug mode. The application was not
launched and no genealogy database was opened. See the
[privacy-mode wiki analysis](C:\Projekte\Delphi\docs\modules\applications\ahnwin51\privacy-mode.md).

### 4.2. Parent unlinking (`Vaterentfernen1Click` / `Mutterentfernen1Click`)

**Status:** Reconstructed and validated; both assembler-reference blocks
removed.  
**Effort:** Low/medium.  
**Value:** Medium/high; restores two symmetric, explicit family-edit actions.  
**Evidence:** DFM/LFM menu bindings, displayed parent fields, and x86 listings
prove confirmation, `Table1.Edit`, one parent-field assignment to zero,
`Table1.Post`, and a normal-path `anzeigen` call for both roles. Data-module
declaration order maps `+$538` to `Table1Vater` and `+$53C` to
`Table1Mutter`. The Lazarus resource's mother-edit popup binding was aligned
with the original DFM (`PopupMenu4`).  
**Checks:** `Source\AhnWin52Tests\tst_AHW52_ParentUnlinkTests.pas` uses `TMemDataset` with synthetic
parent references to test both confirmed mutations, preservation of the other
reference, cancellation, exact call order, mutation failure propagation, and
nil-interface rejection. The runner passes; `AHW52_Main.lpi` builds in Debug.
The application and supplied genealogy data were not opened. See the
[parent-unlink wiki analysis](C:\Projekte\Delphi\docs\modules\applications\ahnwin51\main-form-parent-unlink.md).

### 4.3. Parent insertion workflow

**Status:** The independent choice dialog is reconstructed and tested; the
search and UI relationship-commit workflow remains under construction. The
verified existing-person role write now has an isolated, synthetic-tested
Pascal operation, but is not yet wired into the multi-mode grid event.  
**Effort:** Medium/high for the complete workflow.  
**Value:** High; continues domain reconstruction beyond single-row parent
unlinking.

**Current boundary:** Choice caller and mirrored father/mother role differences
are mapped. The full relationship implementation is blocked on missing
`Table9` index/schema and provider failure evidence; neither the supplied
genealogy data nor its contents may be used to fill this gap.

**Completed shared choice-dialog slice:** `Unit4` / `TForm4` is now
`Forms\PersonEntryChoiceForm.pas` / `TPersonEntryChoiceForm`. Child,
connection, father, and mother callers use the same old dialog instance with
different captions. Its `Neu` and `Auswahl` handlers return the recovered
numeric results `1` and `2`, `zurück` closes the dialog, and activation clears
all three radio buttons. The empty `FormCreate` handler was removed;
unidentified callbacks and their assembler listings remain. The reconstructed
DFM and Lazarus LFM resource roots, plus the decompiled DPR unit references,
use the generic name. Historical SVN r1423 copies of the original
`Unit4.pas`/`.dfm` confirm that callers inspect `RadioButton1.Checked` and
`RadioButton2.Checked`, not visibility flags or the returned `ModalResult`.
The restored form preserves the radio-button order, shared parent panel,
activation reset, and click results. The current `AHW52_Main.lpi` intentionally
does not include the dialog until caller integration can be performed without
replacing unrelated workflow listings.

**Checks:** `Source\AhnWin52Tests\tst_AHW52_PersonEntryChoiceTests.pas`
verifies exact numeric results, the close-query path, and activation reset.
The registered test runs in the consolidated FPCUnit project without opening
the application or any genealogy data; it also checks that the selected
radio-button state remains available to the caller after the click handler.
See the
[person-entry choice wiki analysis](C:\Projekte\Delphi\docs\modules\applications\ahnwin51\person-entry-choice-dialog.md).

**Bounded person-search-form slice:** The former `Unit3`/`TForm3` dialog is
now `Forms\PersonSearchForm.pas` / `TPersonSearchForm`; its DFM and original
DPR unit reference were renamed. `FormActivate` now clears both search edits,
activates `Edit1`, and no longer contains its assembler-reference block. The
DFM event binding was preserved, and the unit now explicitly imports the
`Buttons` and BDE `DBTables` units required by its declared controls. Static
binding/name checks pass. The unit depends on BDE `DBTables`, which is
unavailable in the SQLDB-based Lazarus project. A narrow compile-only
`Compat\DBTables` shim exposes only `TQuery` for resource resolution and
raises `EDBTablesCompatibilityUnsupported` immediately if constructed. The
main project includes the dialog as a compile dependency but does not create
it at startup. The consolidated FPCUnit project builds and confirms the
explicit runtime rejection; the Debug `AHW52_Main.lpi` project now builds and
links. This does not restore BDE search behavior or imply SQLDB compatibility.
The Pascal unit explicitly disables nested comments in FPC mode because
preserved decompiler listings contain nested comment delimiters.

**Mapping checkpoint:** The choice-dialog step, candidate-grid setup,
existing-person branch, new-person empty-input exit, and parent-mode
`TabSheet3Exit` path through its posts, unchecked child lookups, role-field
write, refresh and return are recorded in the
[parent-insertion workflow map](C:\Projekte\Delphi\docs\modules\applications\ahnwin51\main-form-parent-insertion-workflow.md).
The map confirms that `DBGrid2DblClick` also serves other relationship modes.
Both parent menu actions first invoke the choice form (originally `TForm4`);
only its existing-person branch prepares `TabSheet7` and then invokes the
person-search form (originally `TForm3`).
It records the shared workflow states and the numeric/name search split in
the former `Form3`, now `TPersonSearchForm` under `Forms`. Its activation reset
is reconstructed and its DeDe block removed. The meaning of the `+$2FC` field
is inferred as `Edit1` from its own handlers despite conflicting DeDe
annotations. The parent-candidate literals at `005E9064` and `005E9070` are
byte-verified in the local `AHNWIN51_.exe` reference image as uppercase
`M` and `W`: the existing-person branch writes the selected `Table9Nummer`
to `Table1Vater` for `M` and `Table1Mutter` for `W`. The lowercase `m`/`w`
filters in another handler corroborate the role distinction but are not a
basis for case normalization. BDE/SQLDB semantics and the full validation/
error path guarded by `GlobalVar_02535914 = 1` in `TabSheet3Exit` remain
unresolved.

**Keyboard-handler reconstruction:** In addition to the form-level Escape
handler at `00584234`, both edit handlers at `00584094` and `005840B0` are
restored from their DFM bindings. They set `ModalResult := mrCancel` only for
Escape; this maps the listing's value `2` at form offset `+$24C` to the
standard cancel result. Tests invoke both methods on a `CreateNew` dialog
instance, avoiding construction of the unsupported BDE query.
Both edit KeyPress handlers at `005841D4` and `00584204` also restore the
verified Enter flow: `SelectNext(Sender as TWinControl, True, True)`, followed
by clearing `Key` to `#0`. Non-Enter characters are preserved. Synthetic
controls in the isolated test validate the actual tab-order transition.

**Hofname dialog cancel:** `TForm40.BitBtn1Click`, bound to the DFM
`Abbruch` button, now directly calls `Close`, matching the complete listing
at `00575C7C`. One synthetic test confirms the close event; the separate
database-backed `BitBtn2Click` completion behavior remains untouched.

**Name/profession dialog cancel:** The DFM-bound `BitBtn1Click` handlers in
`Unit34` and `Unit37` also directly close their forms, matching listings
`00573B88` and `00574D20`. Synthetic tests exercise both close events. Their
database-backed `BitBtn2Click` handlers remain unchanged.

**Source dialog cancel:** In `Unit30`, the DFM-bound `BitBtn1Click` for the
`Abbruch` button directly calls `TCustomForm.Close` at `005601E8`; the handler
is restored and covered by a synthetic close-event test. Its data-bound
`BitBtn2Click` save operation remains untouched.

**GEDCOM parameter dialog cancel:** `TOKBottomDlg1.SpeedButton2Click` in
`Unit27` closes the global `Form26` chooser, then the parameter dialog itself,
matching the two calls at `0054DD36` and `0054DD3D`. The first target is
corroborated by the `Form26` global use in `Unit26.SpeedButton1Click`. The
restored handler has an ordered synthetic close test; GEDCOM export behavior
is unchanged.

**GEDCOM parameter dialog initialization:** `Unit27.dfm` binds
`TOKBottomDlg1.FormShow` to the form's `OnShow`. Its complete listing at
`0054DBDC` sets `RadioButton2.Checked := True` and then makes `Edit1` the
active control. The restored handler preserves this order. A synthetic test
creates only those two controls and verifies both effects; the export/save
workflow is not invoked. The full suite passes 153 tests and the Debug main
project builds. Coverage is 777/1,047 methods retaining listings (74.21%);
`Unit27.pas` is 1/5 (20%).

**Main-form activation focus:** Both `frmAhnenWinMain.dfm` and `.lfm` bind
`TForm1.FormActivate`. The complete listing at `00602054` loads `DBEdit2` from
the main-form instance held in global `Form1`, then calls
`TCustomForm.SetActiveControl`. The restored body preserves that global target
as `Form1.ActiveControl := DBEdit2`; a synthetic test assigns an unstreamed
`TForm1` to the global and verifies the actual activation handler focuses its
`DBEdit2`. The suite passes 154 tests and the Debug main project builds.
Coverage is now 776/1,047 methods retaining listings (74.12%), and
`frmAhnenWinMain.pas` is 254/323 (78.64%).

**About-form client dimensions:** Both `AboutForm.dfm` and `.lfm` bind
`TAboutForm.FormCreate`. Its complete listing at `005C6E60` reads the client
width and height from global `AboutDialog` and stores them in the integer
cells `02535884` and `02535888`. The restored handler preserves the global
target and performs these writes before the existing file-metadata checks, so
even the missing-executable early exit retains the listing's unconditional
effects. Synthetic tests cover normal startup and missing database/executable
cases through an injected message recorder. The full suite passes 154 tests
and the Debug main project builds. Coverage is 775/1,047 (74.02%); the About
unit is 2/10 (20%).

**Unbound About counter callbacks:** The complete listing at `005C6E80`
increments integer state at `0253588C` inside a compiler-generated
try/finally; the listing at `005C6EB0` decrements the same cell. The Pascal
callbacks now use the address-backed `GlobalVar_0253588C`. No DFM/LFM event
binding or other source/resource consumer was found, so do not infer purpose
or reachability. Synthetic tests establish only `41 -> 42` and `41 -> 40`.
All 156 tests pass and the Debug main project builds. Coverage is 773/1,047
(73.83%); `AboutForm.pas` has no remaining retained listings (0/10).

**Source-name list selection:** `Unit28.dfm` binds `ListBox1.OnClick` to
`TForm28.ListBox1Click`. Its complete listing at `00574AA0` copies
`ListBox1.ItemIndex` into the address-backed integer at `025353A0`; the
neighboring key/double-click paths read the same value. Restored the direct
assignment as `GlobalVar_025353A0 := ListBox1.ItemIndex;`. A synthetic test
covers both a selected index and `-1`, without entering the later source
editing/save operations. The full suite passes 157 tests and the Debug main
project builds. Coverage is 772/1,047 (73.73%); `Unit28.pas` is 5/9 (55.56%).

**FOKO dialog cancel:** `TForm20.BitBtn2Click` is bound to the DFM's
`Abbruch` button and writes modal result `2` at `005CC6AC`. Its global form
target is corroborated by the main-form callback to `TForm20.BitBtn1Click`.
The restored handler sets `Form20.ModalResult := mrCancel` and has a
synthetic test. The database/query-backed finish path remains unchanged.

**Tiny-Tafel parameter cancel:** `TOKBottomDlg.SpeedButton2Click` in `Unit22`
directly closes the global dialog at `0061DFF4`, matching `0054F568`. The main
form's Tiny-Tafel action calls `Show` on that global, and the DFM root is
`OKBottomDlg`; the restored `OKBottomDlg.Close` handler has a synthetic
close-event test. The generation handler remains unchanged.

**Graphic dialog finish handler:** `TForm13.SpeedButton2Click` is bound to the
`fertig` speed button in the `Grafik` form. Its complete listing at `0057082C`
closes the `Form13` instance; that direct close is restored and covered by a
synthetic test. Graphics rendering and printing remain unchanged.

**French Republican calendar Escape handler:** Both resources for `Unit7`
bind `OnKeyDown` to `TForm7.FormKeyDown`. The complete listing at `005CF314`
closes the form only for Escape (`$1B`). The complete listing at `005CF308`
for the DFM/LFM-bound finish button closes the global `Form7` instance; the
main-form caller creates, shows, and releases that same instance. Both
restored close paths have synthetic tests, alongside a non-Escape no-op test.
Date conversion remains untouched.

**Unbound calendar counter callbacks:** `TForm7._PROC_005CF32C` and
`TForm7._PROC_005CF35C` have complete listings that increment and decrement
the 32-bit cell at `025358F4`, respectively. Both DFM and LFM were checked;
neither binds these methods, and no source/resource consumer for the cell is
known. Their bodies now preserve only those direct mutations through the
address-based `GlobalVar_025358F4`. Synthetic tests invoke each callback
directly and verify `41 -> 42` and `41 -> 40`; no event binding or domain
meaning is inferred.

**Source-dialog Enter navigation:** The DFM binds `TForm30.FormKeyPress`.
Listing `00560EA8` confirms that Enter is consumed and a zero-parameter
`WM_NEXTDLGCTL` is posted to the form handle. The restored method uses the
complete `(Sender, var Key: Char)` event signature. Synthetic tests verify
the actual queued message and the non-Enter no-op; no database-bound controls
or supplied data are opened.

**Source-dialog cancel target:** The Unit30 DFM binds `BitBtn1Click`, and the
complete listing at `005601E8` closes global `Form30`, not necessarily the
event receiver. The current Pascal already preserves that target. A new
two-form synthetic test invokes the handler on a separate receiver and proves
that only global `Form30` receives `OnClose`; the Unit30 cancel suite passes
2/2 and the full suite passes 589/589. Unit29's search action remains
provider-backed and its save action enters shared persistence, so neither is
a safe continuation of this slice. See
`ReverseEngineering\AhnWin52-Unit30-Source-Dialog-Global-Close.md`.

The adjacent Unit29 action screen is now recorded in that same note:
list-selection, editor-launch, and cancel state paths have synthetic tests;
search and activation traverse provider-backed source datasets; save delegates
to shared persistence. Unit30 `FormShow` depends on `FindKey`, and its
edit button includes provider-backed delete/edit/append operations. No
additional source-dialog route is eligible for restoration without evidence
for those contracts. The tracker has no pending todos with satisfied
prerequisites; all remaining tasks are evidence-gated.

`TForm33._PROC_0053B6C4` and `TForm33._PROC_0053B6F4` are not bound in
`Unit33.dfm`; their complete listings only increment/decrement the integer
cell at `0061DFB0`. The restored methods use `GlobalVar_0061DFB0`, with
synthetic tests verifying both arithmetic effects. No meaning or callback
reachability is inferred.

**GEDCOM chooser dismiss button:** `Unit26`'s DFM binds `SpeedButton1Click`
to the `nichts dergleichen` button. Listing `0054F9FC` contains only a close
of global `Form26`; that call is restored and covered by a synthetic close
event test. The same DFM binds `FormActivate`; listing `00550540` sets
`RadioButton1`, `RadioButton2`, and `RadioButton3` to unchecked, now restored
and tested for each selected choice on synthetic controls. GEDCOM generation
remains unchanged.

The unbound `TForm26._PROC_00550578` and `_PROC_005505B4` callbacks increment
and decrement `0061E00C`; the increment clears shared string `0061E008` when
the result is zero. The listing for `RadioButton3Click` assigns the same
string state, corroborating its AnsiString type. The restored methods retain
address-based identifiers for both cells, and synthetic tests cover ordinary
increment/decrement and the zero-clear branch.

**GEDCOM all-person export dispatch:** `Unit26.dfm` binds
`RadioButton3Click` to the `alle Personen` choice. Its complete listing at
`0054F9C8` assigns the exact string `Alle` to `GlobalVar_0061E008`, then calls
`los(Sender)`. The Pascal handler preserves that order. It was compile-checked
but not invoked because `los` opens a save dialog and performs provider/file
operations. The consolidated suite passes 150 tests and the Debug main
project builds. The refreshed inventory is 791/1,047 methods retaining
listings (75.55%); `Unit26.pas` is 6/11 (54.55%). The other query/navigation
callbacks in Unit26 are unchanged.

**Place-dialog Enter navigation:** The `Orts-Verwaltung` DFM sets
`KeyPreview = True` and binds `OnKeyPress` to `TForm33.FormKeyPress`. Listing
`0053B6A4` proves Enter is consumed and `WM_NEXTDLGCTL` is posted to the
form's handle with zero parameters; other characters are unchanged. The event
now has the full `(Sender, var Key: Char)` signature. Synthetic tests inspect
the queued Windows message and the non-Enter no-op without streaming
data-bound controls or accessing records.

**Browser finish handler:** The `Fertig` button in `Unit11` is DFM-bound to
`TForm11.SpeedButton1Click`; its complete listing at `005CB4FC` directly
closes the global instance, and the main-form caller shows that same global.
The Pascal `Close;` body was already present, so this slice removed only the
verified listing and added a synthetic close-event test. Browser navigation
and printing handlers are unchanged. The test project now references
`Printer4Lazarus`, as does the existing isolated Form11 project.

**Browser activation state reset:** Both `Unit11.dfm` and `Unit11.lfm` bind
`OnActivate` to `TForm11.FormActivate`. Its complete listing at `005CB57C`
zeros the 32-bit global at `025358A8` and returns. The handler now assigns
zero to the address-preserving symbol `GlobalVar_025358A8`; the existing
increment/read/write references in `Unit11` use that same symbol. Its domain
meaning is not established, so no semantic name or broader behavior is
inferred. A synthetic `CreateNew` test seeds the value and verifies the
activation reset. The browser's drawing and counter consumers remain
otherwise unchanged.

`TForm11._PROC_005CB585` and `TForm11._PROC_005CB5C0` are unbound callbacks
whose listings increment/decrement `025358C8`; the increment clears the
address-backed string at `025358AC` when its result is zero. Both resources
were checked and contain no binding for this pair, and the state remains
address-named. Synthetic tests exercise both mutations and the zero-clear
branch. The separate `_PROC_005CB355` body has no independently established
behavior and remains untouched.

**Name-dialog activation prefill:** `Unit34.dfm` binds `OnActivate` to
`TForm34.FormActivate`. Listing `00573B94` copies the address-backed
`AnsiString` global at `0253539C` into `Edit1.Text`; `Unit28`'s string
assignment/clear operations on the same address corroborate its string type.
The restored handler uses the address-preserving identifier
`GlobalVar_0253539C` rather than guessing a semantic name. A synthetic test
seeds that value and verifies the edit text without streaming the dialog or
opening data.

`Unit28._PROC_00574ACC` and `_PROC_00574B08` are unbound complete callbacks.
They increment/decrement `025353A4`; the increment clears shared string
`0253539C` only when the result is zero. The Pascal code now uses
`GlobalVar_025353A4` and the existing `Unit34.GlobalVar_0253539C`, avoiding
a duplicate string cell. Synthetic tests cover ordinary increment,
zero-triggered clear, and decrement. No event binding or counter meaning is
inferred.

The same unit also has unbound complete callbacks `00573E85` and `00573EB4`.
They increment and decrement the 32-bit cell at `02535394`; the restored
methods use `GlobalVar_02535394` without assigning it a domain meaning. No
DFM/LFM binding or additional source/resource consumer is known. Synthetic
tests cover both arithmetic effects only; no event reachability is inferred.

**Hofname-dialog activation prefill:** `Unit40.dfm` binds `OnActivate` to
`TForm40.FormActivate`. Listing `00575F0C` copies the address-backed
`AnsiString` global at `025353CC` into `Edit1.Text`; `Unit39`'s
long-string assignment/clear operations on the same address corroborate its
type. The restored handler uses `GlobalVar_025353CC` without guessing a
semantic name. A synthetic test seeds the value and verifies the edit text on
an unstreamed dialog.

`TForm40._PROC_00575F20` and `TForm40._PROC_00575F50` are separate, unbound
callbacks with complete listings that increment/decrement the 32-bit cell at
`025353C4`. Their restored bodies use `GlobalVar_025353C4`; no DFM/LFM event
binding or other consumer is known. Direct synthetic tests verify both
arithmetic effects without inferring reachability or meaning.

**Ancestor-graphics parameter cancel:** `Unit12.dfm` binds the `Abbruch`
button to `TForm12.SpeedButton2Click`. Its complete listing at `005627F8`
sets the address-based state cell `02535948` to `1`, then sets the modal
result of the `Form12` instance to `2` (`mrCancel`). The Pascal handler
preserves that order using `GlobalVar_02535948` and
`Form12.ModalResult := mrCancel`. A synthetic test verifies both effects on
an unstreamed parameter form; generation and provider-dependent work are not
invoked.

**Place-search selected index:** `Unit14.dfm` binds `ListBox1.OnClick` to
`TForm14.ListBox1Click`. The complete listing at `0053C850` reads
`ListBox1.ItemIndex` and writes it to the address-backed integer cell
`0061DFC0`; the same cell is consumed later by the form's save operation.
The handler now performs that single assignment using
`GlobalVar_0061DFC0`. A synthetic test verifies both a selected index and the
no-selection value `-1` without streaming the form or opening data.

The unbound callbacks `_PROC_0053C87C` and `_PROC_0053C8C0` increment and
decrement `0061DFC4`. On increment, the two associated strings at `0061DFBC`
and `0061DFB8` are cleared only if the resulting counter value is zero. The
restored callbacks preserve these direct effects through address-backed
variables; synthetic tests cover an ordinary increment, the zero-clear
branch, and decrement. Neither DFM nor LFM binds the callbacks, and no
semantic purpose or reachability is claimed.

**Source-list selected index:** `Unit29.dfm` binds `ListBox1.OnClick` to
`TForm29.ListBox1Click`. Listing `0056223C` copies `ListBox1.ItemIndex` to
the address-backed integer cell `0061E0F0`; another event in the same unit
uses this cell while updating the source list. The handler is restored as
`GlobalVar_0061E0F0 := ListBox1.ItemIndex`. A synthetic test verifies selected
and unselected index values without loading the database-bound DFM.

The unbound callbacks `_PROC_00562290` and `_PROC_005622CC` increment and
decrement `0061E0F4`. Increment clears the shared string at `0061E0EC` only
when the new counter value is zero. Their direct effects are restored using
address-backed variables and synthetic tests for ordinary increment,
zero-triggered clearing, and decrement. The DFM/LFM binds neither callback;
purpose and reachability remain unknown.

**Family-name list selected index:** `Unit39.dfm` binds `ListBox1.OnClick`
to `TForm39.ListBox1Click`. Listing `00576944` copies the list's
`ItemIndex` into the address-backed integer cell `025353D0`; other methods
in the same unit also read and write this cell. The handler is restored as
`GlobalVar_025353D0 := ListBox1.ItemIndex`. A synthetic test covers both a
selected item and `-1` for no selection.

**Family-name dialog finish:** `Unit39.dfm` binds the `Fertig` button to
`TForm39.BitBtn1Click`. The complete listing at `0057674C` resets
`GlobalVar_025353D0`, sets `ListBox1.ItemIndex` to zero, and assigns modal
result `2` to the global `Form39` instance (identified in `AHNWIN51.dpr`).
The Pascal handler preserves all three effects in order. A synthetic test
verifies the state reset, first-row selection, and `mrCancel` result without
streaming the data-bound form resource.

**Comparison-parameter cancel:** `Unit35.dfm` binds the `Abbruch` button to
`TForm35.BitBtn4Click`. Listing `005CF670` resets the integer global at
`02535B90` and sets the global `Form35` modal-result field to `2`. The Pascal
handler preserves these operations in order, and a synthetic `CreateNew`
test verifies both outcomes without loading comparison data.

**Comparison-parameter presets:** `Unit35.dfm` binds `RadioButton1Click` and
`RadioButton2Click`. Their complete listings (`005CF914` and `005CF9DC`)
show that the first callback checks all ten parameter boxes, while the second
clears all ten; both callbacks set both radio controls to unchecked. The
Pascal handlers preserve these seemingly unusual results rather than
substituting inferred radio-button semantics. Synthetic tests exercise each
callback across all twelve controls.

**Comparison parameter acceptance:** `Unit35.dfm` binds the `OK` button to
`TForm35.BitBtn3Click`. Listing `005CF68C` clears the address-backed string
at `02535B98`, sets state `02535B90` to `1`, and for each checked field sets
its matching address-backed integer flag to `1` while appending the original
field label to the string. It then assigns modal-result value `2`. The
restored handler follows the listing's field order (ID, profession, birth,
baptism, death, and burial fields); tests cover all selected fields and the
no-selection path, including the listing's behavior of leaving unchecked
flags untouched.

**Family-name list double-click:** `Unit39.dfm` binds the double-click event
to `TForm39.ListBox1DblClick`. Listing `00576774` copies the selected list
item to shared `GlobalVar_025353CC`, sets `Form40.Label3.Caption` to the
literal `Aktueller Hofname:    ` plus that string, then shows global form
`Form40`; the DPR identifies its class as `TForm40`, and `Unit40.dfm` binds
the target label. The implementation adds only an implementation-level
`Unit40` dependency. A synthetic test verifies the shared value, caption,
form visibility, and `OnShow` event without opening database resources.

`TForm39._PROC_00576970` and `TForm39._PROC_005769AC` have no DFM/LFM event
binding. Their listings increment/decrement the integer cell at `025353D4`;
the increment also clears the shared hofname string at `025353CC` if the
incremented value is zero. The restored handlers preserve these direct
effects using `GlobalVar_025353D4` and `GlobalVar_025353CC`. Synthetic tests
cover ordinary increment/decrement and the zero-triggered string clear; no
purpose or reachability is inferred for the counter.

**FOKO abbreviation viewer:** `Unit38.dfm` binds `OnShow` to
`TForm38.FormShow`. Listing `0053A054` derives the executable's directory
from `ParamStr(0)`, opens sibling file `foko.abk`, clears `Memo1`, appends
each line in order, and closes the file. The path helper is corroborated by
the main form's `ExtractFilePath(Application.ExeName)` usage. A synthetic
test creates a temporary `foko.abk` beside the test executable, verifies the
memo contents replace stale text, and removes the fixture; it refuses to
overwrite an existing file.
The unbound callbacks `_PROC_0053A185` and `_PROC_0053A1B4` increment and
decrement integer cell `0061DFA8`; they preserve this direct effect through
`GlobalVar_0061DFA8`. Synthetic tests cover both mutations. Their purpose and
reachability remain unknown because neither form resource binds them and no
consumer has been established.

**Profession dialog finish:** `Unit36.dfm` binds the `Fertig` button to
`TForm36.BitBtn1Click`. Listing `0057522C` resets address-backed selection
state `025353B8`, selects `ListBox1.ItemIndex := 0`, and sets modal-result
value `2` on `Form36`. The DPR confirms that the global instance is a
`TForm36`. A synthetic test verifies all three effects without loading the
database-backed form resource.

`TForm37._PROC_00574FA5` and `TForm37._PROC_00574FD4` are also unbound in the
resources. Their complete bodies only increment/decrement the address-backed
integer `025353AC`, now represented by `GlobalVar_025353AC`. Synthetic tests
verify both mutations; the value's purpose and callback reachability remain
unknown.

`TForm36._PROC_00575A19` and `TForm36._PROC_00575A54` are not bound in the
form resources. The listings increment/decrement `025353BC`; when the
incremented value is zero, the shared string at `025353B4` is cleared. The
restored code retains those addresses as `GlobalVar_025353BC` and
`GlobalVar_025353B4`. Synthetic tests cover nonzero increment, zero-triggered
clear, and decrement only; no callback reachability or state meaning is
inferred.

**Profession list selection:** `Unit36.dfm` binds `ListBox1.OnClick` to
`TForm36.ListBox1Click`. Listing `005758D8` reads `ListBox1.ItemIndex` and
stores it in `GlobalVar_025353B8`, the same address reset by the finish
handler. The Pascal body preserves the direct assignment; a synthetic test
covers both a selected index and `-1` without streaming the database-backed
form resource. The adjacent double-click handler was initially deferred until
its target component offset could be reconciled; see the following note.

**Profession list double-click:** `Unit36.dfm` binds
`ListBox1.OnDblClick` to `TForm36.ListBox1DblClick`. Its listing stores the
selected profession in shared string state `025353B4`, builds the exact
`Aktueller Beruf :    ` caption, copies the value into `TForm37.Edit1`, and
shows `Form37`. The target offset `+$030C` was initially annotated as
`Image2` by DeDe. It is resolved as `Label3`: the same TForm37 listing
identifies `Edit1` at `+$0300`, and class declaration order places
`BitBtn1`, `BitBtn2`, then `Label3` at `+$030C`; the DFM also contains no
`Image2`. `AHNWIN51.dpr` independently creates `TForm37` through the pointer
cell used by the listing. The restoration uses an implementation-only
`Unit37` dependency. A synthetic test checks the shared text, label, edit,
visibility, and `OnShow` event without opening provider data.

In the parent-mode tail of `TabSheet3Exit` (`GlobalVar_02535918 = 1`),
`FindKey(GlobalVar_02535910)` is followed by unconditional `Edit` without
checking its Boolean result. A normal BDE miss preserves the cursor, so the
subsequent edit and relationship write still run against the current row.
Likewise, only the `Vat` and `Mut` `Label35` prefixes write a parent field;
an unrecognized prefix has no explicit abort path, and the following `Post`
and refresh sequence still runs. These are mapped control-flow facts, not
evidence that the outcomes are safe. Provider-error behavior and the actual
cursor after an unsuccessful SQLDB lookup remain unresolved.
The caller contract for the choice form is now mapped in four menu actions:
child, connection, father, and mother. They set different captions on the
same old `TForm4` instance at global `0061C580`; parent callers ignore
`ShowModal`'s result and read `RadioButton1.Checked` at `+$2F4` (new record)
and `RadioButton2.Checked` at `+$2F8` (existing person). Historical
`Unit4.dfm` at SVN r1423 confirms these offsets and shows both radio buttons
as siblings in `Panel1`; the third button at `+$2FC` closes without selecting
either caller route. Form activation resets all three choices. Although the
caller checks the first two in sequence, the radio-button group makes the
choices exclusive. The existing-parent-person route then clears the
search-form control at `+$2FC` and calls `TForm3.ShowModal`. The reconstructed
`TPersonEntryChoiceForm` has the same control order and semantics. Main-form
caller integration remains deferred until its broader data and error
contracts are suitable for a bounded reconstruction.
The mirrored father/mother listings have also been compared: setup, choice,
and downstream control flow are the same; the create-new branch carries its
role through `Label35` (`Vat`/`Mut`), while the existing-person branch's
shared `DBGrid2DblClick` routes by the selected candidate's exact gender
(`M`/`W`), not by which parent menu launched the search. No candidate gender
filter is visible in the search caller. The resulting asymmetry and the
unmatched-gender no-write path are recorded in the workflow map; it is not
normalized by this mapping.
**Keyboard-handler reconstruction:** The DFM-bound `FormKeyDown` at
`00584234` now has the standard `(Sender, var Key: Word, Shift)` event
signature and calls `Close` only for `$1B` (`VK_ESCAPE`). Other key codes
remain no-ops, and the handler does not modify `Key`. Only this completed
listing was removed; search/provider behavior was not changed. The test suite
checks Escape recognition and compiles the dialog unit without constructing
its unsupported BDE `TQuery`.
No explicit `Table1.Post` appears in the existing-person double-click path.
However, `anzeigen` first runs `gridanp` (which only sets grid column widths),
then navigates `Table1` with `Last`, `First`, and `FindKey`. The
`TDataSet.CheckBrowseMode` contract posts a modified record before navigation,
so `Table1.Last` is the first visible implicit commit point; it later re-enters
edit mode for `Table1` and `Table5`. A synthetic `TBufDataset` test verifies
that `Last` posts a pending modification. `speich1` skips edit states, while
`FormClose` has a conditional explicit post for a non-empty current person.
The listing shows only `try/finally` in `anzeigen` and the grid handler, and
the original `Table1` resource has no `OnPostError` binding. Exact BDE/backend
error presentation and recovery remain open; the selected-person mapping
checkpoint is not approval to replace the multi-mode handler.

**Completed bounded role-write operation:** `ParentSelectionBehavior.pas`
provides `ApplySelectedParent`. It enters edit state, writes only `Vater` for
exact uppercase `M` or `Mutter` for exact uppercase `W`, and returns `False`
without a parent-field write for other values. It does not post or navigate.
The behavior is compiled with the main project and covered by four
`TMemDataset` tests, including both role assignments, other/case-mismatched
values, unposted edit state, and nil-dataset rejection. The consolidated suite
compiles the helper and passes all 39 tests; the Debug main project also builds.
The helper is not yet called from `DBGrid2DblClick`; this avoids inventing a
mode check or replacing unrelated branches.

**Current blocker:** The choice-form caller/state handshake is mapped, including
the radio-button `Checked` contract; do not treat this as a remaining mapping
task. No safe relationship implementation slice is ready until a non-sensitive
`Table9` key/index definition and provider miss/error contract are available.
`TForm3` is created in
`AHNWIN51.dpr`; its `+$E8` slot resolves to `00469CEC`, distinct from the
directly identified `TCustomForm.Show` entry at `00469C3C`. The method is
identified as `TCustomForm.ShowModal` by the same `+$E8` VMT slot's explicit
`TLoginDialog.ShowModal()` reference in `Sys\DBLogDlg.pas`. The
person-search caller does not inspect the returned ModalResult and proceeds
to `anzeigen` after dialog dismissal. The BDE API
reference confirms `FindKey=False` leaves the current
record position unchanged; both search branches ignore that Boolean, so a
no-match does not clear the current candidate. Source:
https://docwiki.embarcadero.com/Libraries/Florence/en/Bde.DBTables.TTable.FindKey.
The search listing also has a distinct exception fallback: an exception
during a positive numeric search enters the handler, which retries the
composite `geba` name-key path when the value still parses positive; a normal
`FindKey=False` does not enter that path. Its purpose and triggering BDE
exceptions remain unknown. The installed provider source
`Components\Source\SQLTable\cmp_SQLTable.pas` establishes that the current
`TSQLTable` derives from `TCustomSQLQuery`, builds
`select * from <TableName>`, and inherits `IndexName` and `IndexFieldNames`
from `TCustomBufDataset`; these operate on local client indexes, and
`FindKey` is not available. The inherited `Locate` implementation scans the
active client index and moves to a match, while a normal miss leaves the
current record position unchanged. SQLDB server-index metadata is queried
separately through the connection; the inspected implementation does not
automatically add those definitions to the local index collection.
Neither the original `Unit2.dfm` BDE `Table9` nor the converted
`Unit2.lfm` SQLDB `Table9` persists index definitions; the BDE names
`namgeb`/`geba` only appear in runtime code. Their field definitions and
availability through SQLDB remain unverified. Equivalent comparison/error
behavior is also unverified. Synthetic `TBufDataset` tests confirm the
basic inherited `Locate` contract: a hit moves to its row and a normal miss
preserves the current row. This does not test an SQLDB connection or BDE
comparison parity. Another synthetic test verifies the inherited
`TDataSet` browse-mode rule: `Last` posts a modified edit before moving the
cursor. In the original listing, `anzeigen` starts dataset navigation with
`Table1.Last` after the parent field is changed; `gridanp` only sizes grids.
This is the first visible implicit commit point, before the subsequent
`First`/`FindKey` and refresh. `anzeigen` and `DBGrid2DblClick` show
`try/finally`, not a local `except`, and the BDE `Table1` resource has no
`OnPostError` handler. The exact provider exception/UI behavior is still
unverified; `FormClose` is a distinct path with an explicit
`PostDataSetOrReportError` wrapper. The event-mode boundaries are mapped:
mode 1 (`MRG.DB` relationship) and mode 2 (child route) dispatch before parent
mode; child mode reads a possible partner number from `StringGrid1` while
`StringGrid2` is the child list. Father/mother setup explicitly
sets mode 0 and parent flag 1. Keep those branches out of the helper
integration. Remaining work is the SQLDB local-index configuration and
comparison/error behavior, plus provider post/error semantics. Do not wire the
helper into the form while those contracts remain unresolved.

**Child-workflow mapping checkpoint completed:** The DFM confirms
`StringGrid1` is the partner list (`PopupMenu1`) and `StringGrid2` is the child
list (`PopupMenu2`); `Kindereinfgen1Click` reads the selected partner row.
Mode 2 (`GlobalVar_02535914 = 2`) runs a zero-value guard with a
gender-warning message/focus, uses the shared checked-radio chooser, then
either appends a new person and sets
both parent fields from the current person/partner pair or opens the shared
`Table9` search and edits the selected person's parent fields. Both branches
route by exact `M`/`W` comparisons. The new-record exit returns to the saved
person through an unchecked `FindKey`; the existing-person caller ignores the
search result and leaves mode 2 set until a candidate double-click completes.
The child caller does not clear parent flag 18, and the shared grid handler
checks it after the child branch, so stale state can enter both branches.
Choice/search cancellation has no explicit mode cleanup in the visible
callers. See [the child workflow map](C:\Projekte\Delphi\docs\modules\applications\ahnwin51\main-form-child-insertion-workflow.md)
for field, post, miss, cancellation, and provider boundaries. Implementation
remains blocked: `Table9` has no persisted local index definition, SQLDB does
not provide `FindKey`, and the child handlers perform unchecked lookups and a
two-field mutation. Do not inspect supplied genealogy data or wire this mode
into the shared multi-mode event until a synthetic provider contract is
established.

Child removal is a bounded alternative but scans a relation dataset and
updates matching child records. Partner removal iterates and deletes reciprocal
`Table5` rows, so both remain later workflows.

**Connection-workflow mapping checkpoint completed:** `Verbindungeinfgen1Click`
sets mode 1, clears parent mode 18, saves the current person number, checks a
parsed value, and uses the shared checked-radio choice dialog. The
existing-person route opens the shared `Table9` candidate view; its
`DBGrid2DblClick` branch scans `Table10` (`MRG.DB`) sequentially for the
ordered person-number pair. A duplicate displays the existing-link message
and returns through a branch that leaves mode 14 set. A miss appends and posts
two reciprocal rows with `Verbind = 'Eheschliessung'`, then closes the chooser,
activates the main person page, resets modes 14/18, and refreshes. The new
person route initializes the entry form and appends a person, but its
mode-1 `TabSheet3Exit` commit is mapped separately below.
Cancellation and duplicate branches have visible stale-mode behavior.
`Table10`'s resource identifies its fields but persists no index definitions;
the current duplicate scan is sequential, so the `Table9` `FindKey`/index
blocker does not by itself block mapping this branch. MRG provider errors,
partial failure between reciprocal posts, and duplicate concurrency remain
unverified. See the [connection workflow wiki map](C:\Projekte\Delphi\docs\modules\applications\ahnwin51\main-form-connection-insertion-workflow.md).
Do not inspect supplied genealogy data or join this mode to child mode 2 or
parent mode 0.

**Connection new-person exit checkpoint completed:** The mode-1
`TabSheet3Exit` branch (`005EA398`) checks the new person's name inputs; the
shared incomplete-record path deletes `Table1` and clears mode 14/18 when
both helper results are zero. Otherwise mode 1 normalizes three place inputs
against `Table13` (`LOC.db`), adding and posting missing `Ort` rows, then
appends/posts a reciprocal pair in `Table5` (`MRG.DB`) when both the saved
person number and new `Table1.Nummer` are positive. The two rows reverse
`Nummer`/`Epnum` and copy the same marriage/event fields from the entry
controls, including user-selected `Verbind`. A pre-insert cleanup deletes a
current `Table5` row if either relationship key is zero. A shared positive
birth-year branch copies `Gebjahr/Gebmonat/Gebtag` to `Indj/Indm/Indt` and
posts `Table1` inside a bare exception handler. The normal mode-1 tail skips
parent assignment, clears mode 14, looks up the saved person without checking
the result, clears the saved-number global, and calls `anzeigen`. No rollback
across the two MRG posts or local error handling for LOC/MRG operations is
visible. The field and control map, decision conditions, and remaining
provider boundaries are in the [connection workflow wiki map](C:\Projekte\Delphi\docs\modules\applications\ahnwin51\main-form-connection-insertion-workflow.md).

**Place-input callback checkpoint completed:** The DFM binds the three
plain place combos to `ComboBox20Exit` and their own KeyPress callbacks.
`ComboBox20Exit` also performs a `Table13` `ort_` lookup and, on a miss,
adds the value to location-combo item lists and appends/posts the LOC record.
It later enters a mode-1 `Table5.Edit`/`Post` branch, but does not assign
`Hort`/`Saort`/`Schort` for these three sender controls; the subsequent
`TabSheet3Exit` pair insertion reads the values directly. The key handlers
test Space (`#$20`) and clear/post the corresponding `Table5` place field,
contradicting the DFM hint that says Escape deletes. The unbound
`ComboBox1Exit`/`2Exit`/`3Exit` methods only transform text and are not wired
by this DFM. See the connection workflow map for exact branches. The second
LOC lookup at TabSheet exit remains relevant even if the blur callback has
already added the place, because provider/index equivalence is not established.

**Next bounded work:** do not reconstruct this database workflow into code
yet. Resolve non-sensitive `LOC.db` key/index and `MRG.DB` write semantics
with synthetic provider fixtures, including a failure after the first
reciprocal post. Keep implementation blocked until observable provider/error
behavior is bounded.

### 5. Global search (`Unit18`)

**Effort:** High.  
**Value:** High.  
**Evidence:** The form has a clear “Globale Suche” purpose and a substantial
set of field/operator/value inputs, but the search and persistence handlers
are large and database-dependent.  
**Checks:** Defer until the query contract and dataset schema can be exercised
with synthetic records.

## Recommendation

The calendar model and menu entry point, FOKO row-deletion, evidenced
About-dialog interactions, and Enter-key navigation are implemented and
documented. The main-form event map, exit-menu caller sequence,
`speich1` persistence behavior, low-risk navigation handlers, `FormClose`, the
full privacy-mode round-trip, the exit-menu sequence, parent unlinking, and
the independent parent-insertion choice dialog are implemented and
documented. Parent and child relationship flows are mapped, with mutation
work blocked on the unresolved BDE/SQLDB lookup contracts. The separate
mode-1 connection chooser, existing-person reciprocal insert, and new-person
exit path are now mapped; next, define an isolated synthetic dataset contract
for its LOC/MRG lookups and reciprocal writes before restoring relationship
mutations.
Keep global search deferred until a synthetic database contract is available.
The calendar menu path calls the restored `speich1` behavior, but this is not a
general save of every active edit. The QuickReport compatibility layer only
exposes compile-time contracts and explicit failure boundaries; keep printing
and all report behavior deferred until the LazReport migration is implemented.

**About shared-state checkpoint completed:** `TAboutForm.FormCreate` is now
restored from its DFM/LFM-bound listing: it stores the global `AboutDialog`
client dimensions in address-backed integers `02535884` and `02535888`.
Synthetic tests verify these writes on normal initialization and when either
metadata file is missing; the writes precede the metadata checks so the
missing-executable early return cannot bypass them. No other source/resource
references to these addresses were found. The callbacks at `005C6E80` and
`005C6EB0` are restored as increment/decrement of `0253588C`; they have no
other source/resource consumer or DFM/LFM binding, so their purpose and
reachability remain unknown. The LFM binds `FormMouseDown` and `FormKeyDown`;
the DFM binds neither, despite the retained handlers. Record these as evidence
limits, not as reasons to invent bindings or shared-state APIs. See the
About-dialog wiki map.

## Continuation — retained class references and visible experiment results

### Main quest

The class-pointer audit for the reorganized no-listing units found two
assembly-comment identities that need explicit source mappings:
`TDataModule2` at `005D5125` is now `TGenealogyDataModule`, and `TForm7` at
`005EEBFE` is now `TFrenchRepublicanCalendarForm`. Their original listing
names/instructions remain intact; the comments and symbol map show both
identities. The streamed instances remain `DataModule2` and `Form7`.

The broader listing inventory remains an evidence task, not a reason to
translate an unqualified routine. The later Table13-specific event/caller
screen is recorded at the top of this backlog; it found resource-bound and
listing-only paths, but no provider-safe handler ready for restoration. Keep
relationship, export, and report workflows blocked on their provider and
dataset contracts.

### Side quest

The external adapter now captures only target-process foreground HWND and
matching class/caption metadata, alongside the existing visible top-level
window/control profile. It records a persisted
`timeout-waiting-for-dialog` result (phase, timeout stage/limit, last visible
profile) when the bounded dialog wait expires, and sends no input in that
branch. New profiles/results use schema version 2; version-1 profiles and
prepared manifests remain readable. The UI profile/result contract continues
to set `gridSelectionRead` and `lookupOutcomeInferred` to false. The adapter
builds without warnings and 30 synthetic tests pass; no original process was
started for this change.

### Prepare-only `geba` observation protocol

This is a UX corroboration protocol, not a way to define the replacement
provider contract. The approved fixture's `geba` header fixes the index fields
and order, but does not prove BDE partial-key behavior, hit/miss cursor
semantics, or errors. A manifest remains non-executable; preparing this
checklist does not authorize a live action.

**Before each separately authorized run:**

1. Confirm the exact approved test executable path/hash and that no other
   AhnWin instance or unexpected modal dialog is active.
2. Capture a fresh recursive file inventory with sizes, timestamps, and
   hashes. Copy the complete test-instance directory to a dated backup
   outside it; compare the backup inventory to the source before proceeding.
3. Manually open `Auswahl`, capture a fresh profile from the same PID, and
   validate it with the adapter. Do not reuse an old profile after a dialog
   geometry, DPI, owner, process, or executable change.
4. Prepare exactly one category/manifest and review the surname/given-name
   inputs locally. Do not batch, replay, or source query values from a
   persistent script. No category is executed until the user separately
   authorizes that named category and snapshot.
5. Permit only the two visible search-field text writes and the recovered
   `Edit2Exit` trigger. Do not click other dialog controls, edit/save a
   person, open reports, or invoke print/export.
6. The user records whether a candidate was visibly selected; the adapter
   records only visible window/control state. Compare the complete
   post-close file inventory with the pre-run inventory. Stop on any
   unexpected prompt, ambiguous UI, or unexplained file difference, preserve
   both inventories and the backup, and do not proceed to another category.

**Scenario categories:** `known-hit` requires a user-verified full two-field
match; `surname-only-prefix` supplies a surname and an empty given name;
`absent-surname` uses a user-verified absent surname and nonempty given name;
`absent-given-name` uses a verified surname and a given name absent for that
surname. The category is a precondition label, not a predicted BDE result.

**Recorded terminal evidence:** use one of `dialog-closed`,
`dialog-remains-open`, `dialog-wait-timeout`, `profile-mismatch`, or
`unexpected-window`. Separately record the user's visible-selection report as
`candidate-confirmed`, `no-candidate-confirmed`, or `ambiguous/not-observed`.
Do not translate `dialog-closed` into a hit, `dialog-remains-open` into a miss,
or any UI result into cursor position. The adapter's grid-selection and
lookup-inference flags remain false in every category.

## Continuation — Unit17 inventory and remote authorization gate

The DFM/caller inventory revisited `Unit17` as one bounded example. Its DFM
binds `FormShow`, `BitBtn1Click`, `BitBtn2Click`, and both checkbox-preset
radio buttons. The radio-button presets have already been restored from
complete listings and covered by synthetic tests. `BitBtn2Click` is also
restored, but forwards to `Form1.anzeigen`, whose database refresh path is not
safe to invoke from an isolated test.

The remaining visible completion flow is not a safe restoration candidate:

| Handler | Direct evidence | Boundary |
|---|---|---|
| `FormShow` (`00545204`) | Opens the streamed dataset at DataModule offset `$0530`, opens BDE database alias `tit`, then calls `First` | Dataset/database behavior; no synthetic UI-only effect |
| `BitBtn1Click` (`005405C5`) | DFM-bound “Fertig” action; listing has an `Fbml` branch to `FamblHTML`, repeated `TTable.FindKey` calls, dataset/database operations, and global dialog state | Report/export and BDE/global behavior are coupled; keep assembly-backed |
| `gebst`, `gebstvn`, `nam2`, `fambeltern` | Directly referenced from retained Unit17 assembly paths | Internal helpers, not independently DFM-bound; translating them alone would not close a testable contract |

No Unit17 production source was changed. The principal quest remains on the
broader listing-to-DFM/caller inventory rather than guessing this completion
workflow.

The RemoteControl CLI and synthetic test suite were revalidated: FPC 3.2.2
build succeeded and all 37 tests passed. The manifest reader now requires the
exact `not-found`, `single-candidate`, `candidate-list` outcome array for
result schema 2, rejecting altered or malformed entries. Tests also confirm
that prepared manifests cannot set `liveExecutionAuthorized`. The CLI only
creates manifests; no command consumes one as an execution plan. The approved
application was closed and no input was sent. The previous Ute/Elsa
observation is complete and will not be repeated. Any next live observation
remains blocked until a specific query category is separately authorized and
its fresh backup/inventory and dialog profile are verified.
Manifest parsing additionally requires integral schema numbers and a positive
32-bit target PID; fractional versions/PIDs and an out-of-range PID are
covered by synthetic rejection tests. The CLI and all 37 tests compile
without warnings; a non-starting `verify` confirms the approved executable
path/hash still match.

### Additional bound-handler triage

`Unit32.FormShow` is DFM-bound, but its retained listing resets three labels
and fifteen image controls, then derives paths under `Bilder/` from
address-backed photo state, calls unverified string/path helpers, and loads
JPEG files into `TPicture`. Its visible effects are coupled to external files
and unresolved global/helper contracts; keep the complete routine
assembly-backed rather than partially restoring only the control resets.

The `Unit26` `Gedcom schreiben` radio handlers are likewise not independent
checkbox-style state actions: the `Nachfahren` listing reads
`TForm1.StringGrid2` and dispatches into the dataset-backed `nach_erm` and
save-dialog flow. `Unit28.BitBtn1Click` traverses and appends a global BDE
dataset. These are recorded as blocked candidates, not approximated.

`Unit13.SpeedButton12Click` is now restored from listing `00570694`. The
method sets `FontDialog1.Font.Name` to `Arial`, stores the selected name only
when `Execute` returns true, and always refreshes `PaintBox1`. A private
`StoreFontNameState` helper is the only writer to the source-level
`GlobalVar_0061E2EC` mapping; the listing and `Unit13.zerleg` establish that
the original cell is an `AnsiString` passed to `TFont.SetName`. The binary
address is retained as an identifier, not emitted as an absolute address in
the rebuilt process. Synthetic dialog tests verify accepted and cancelled
paths and repaint behavior; they do not run the printer or genealogy drawing
workflow. The focused GraphicForm group passes 11/11, the full suite passes
398/398, and the main Debug project links.

**`Unit13.FormShow` bounded restoration — 2026-10-04:** The listing-backed
`Table17.Open` and `Table18.Open` calls remain in their original order; the
BDE `TSession.OpenDatabase` call remains outside the form. `Table17`/`Table18`
now use the centrally configured direct `TParadox` route; other `TSQLTable`
datasets still lack a selected SQLDB connection/provider. `$0534` maps to
`Table1Nummer`; the sibling `DB.pas` VMT map corroborates slot `$58` as
`TField.GetAsInteger`, so a small helper now reads `.AsInteger`. The known
global setup is translated (`0.63` scale, rounded values `4` and `76`, the
observed `$011AD338` value `20`, and two zeroed state cells). Each of the four
chart modes resets the paint/scroll state and then reaches an explicit
unsupported-rendering exception; `Vorf_erm`/`Nach_erm` retain their listings
and do not claim successful drawing. Synthetic tests cover the setup, field
access, table-open order, all four mode dispatches, and scrollbar resets
without database I/O.
GraphicForm tests pass 14/14 and the full suite 401/401. Coverage is
602/1,144 (52.62%); `Unit13.pas` is 40/57 (70.18%). The test project compiles
the changed Unit13 and the Debug target `FPC\AHW52_Main.lpi` links. No live
application or database was opened.

### `Cmp_SQLTable` source review — connection configuration remains blocked

The supplied files
`C:\Projekte\Delphi\Components\Source\SQLTable\cmp_SQLTable.pas` and
`C:\Projekte\Delphi\Components\FPC\cmpsqltable.lpk` were inspected; the
component package builds. As clarified by the user, `TSQLTable` is a SQLDB
query component like `TSQLQuery` or `TSQLCommand`: it is expected to use a
provider-backed `TSQLConnection`, which is a separate component. `TSQLTable`
subclasses `TCustomSQLQuery`; its `TableName` setter constructs
`select * from <name>;`, and it republishes inherited SQLDB `Database` and
`Transaction` properties. It is not expected to implement its own connection
or database engine.

The suggested Lazarus `lazParadox` package was inspected. It registers
`paradox.TParadox`, declared as `TParadox = class(TDataSet)` and implemented
directly on pxlib. It exposes file/table naming and pxlib configuration, but
does not inherit from SQLDB `TSQLConnection` or provide an SQLDB transaction.
It can open Paradox files as a direct dataset; it cannot be assigned to the
current `TSQLTable.Database` property.

The `GenealogyDataModule` resource assigns table names (`awd.db`, `MRG.DB`,
etc.) but does not assign `Database` or `Transaction`; it declares no
connection or transaction component. Although the Pascal unit imports
`IBConnection`, it declares and initializes no `TIBConnection`. A targeted
search found no SQL connection/transaction assignments in AhnWin52 source or
resources. The presence of `IBConnection` in a `uses` clause is not evidence
that InterBase is the intended backend, and the `TableName` SQL generation
does not establish that a SQL server exposes the legacy Paradox files as SQL
tables.

The user selected a bounded interim migration to direct `TParadox` components
for `Table17` and `Table18`; this does not convert `TParadox` into a SQLDB
connection. The remaining SQLDB datasets still need either a compatible
`TSQLConnection` or their own separately validated direct-dataset migration.
The import of `IBConnection` alone does not establish that `TIBConnection` is
intended. Validate the two migrated tables' file, field, filter, and runtime
pxlib behavior before expanding the migration. Keep dataset `Open`/`Close`
locations unchanged.

### Incremental direct-dataset migration — `Table17` / `Table18` (2026-10-04)

The user chose to use lazParadox/FCL `TParadox` alongside the existing
`TSQLTable` datasets as an interim approach. The FPC data module now streams
`Table17` (`awd.db`) and `Table18` (`MRG.DB`) as `TParadox` with `FileName`,
while all other tables remain `TSQLTable`. The original `DataSource17/18`
bindings, persistent fields, and `Unit13.FormShow` calls (`Table17.Open`,
then `Table18.Open`) remain in place. This is not a `TSQLConnection` adapter.

`TInterimParadoxTable` aliases to `TParadox` under FPC and to the legacy
`TSQLTable` type for Delphi; the existing Delphi DFM therefore remains
unchanged. FPC explicitly registers `TParadox` before data-module resource
streaming; `FilterOptions` was removed from the two LFM objects because that
property is not published by `TParadox`. `InitializeDataAccess` resolves table
files under `AHNWIN52_DATA_DIRECTORY`, defaulting to the executable directory,
and fails explicitly if the directory or either file is missing. The approved
test instance places `AHNWIN51.exe`, `AWD.DB`, and `MRG.DB` together. The
method optionally reads `AHNWIN52_PXLIBRARY`, validates the configured file,
and assigns it to both datasets; without the override, pxlib's default
`pxlib.dll` remains in force. The FPC project files include the bundled
`fcl-db` Paradox and pxlib source paths through `$(FPCSrcDir)` because this x64
FPC installation has no prebuilt `paradox.ppu`.

Tests now instantiate the data module from its LFM, verify both streamed
datasets, data-directory resolution, configured-library success/error paths,
and no-partial-assignment behavior when a table is missing. Empty temporary
files and synthetic recorder datasets confirm the paths and original open-call
order without database I/O. The full test suite passes 404/404 and the Debug
application build links. No real Paradox file was opened, so DLL deployment,
actual file
compatibility, filter behavior on the real `awd.db`, and persistent-field
binding still need validation against the approved test instance. The other
SQLDB datasets remain without a selected connection/provider, and lookup/index
semantics are not supplied by this migration. Do not change other tables or
open live data until those boundaries are independently checked. Keep a
possible `TDBParadox` common component as a separate future architecture item.

### Main-form helper call-site audit

Rechecked the handwritten `TForm1.Proc_005D32CC`, `Proc_005D3228`, and
`Proc_005FBFD8` bodies against `frmAhnenWinMain.pas.bak`. The current source
contains many annotated assembly call sites, but the backup retains only
different `Sender: TObject` declarations for these routines, not complete
callee listings. The present helper signatures (`string -> string`,
`Integer -> string`, and `string -> string`) and their transformations
therefore remain assumptions rather than recovered ABI or behavior. Caller
references alone are not sufficient evidence to validate the implementations;
leave them unchanged and continue the listing inventory until a complete
callee listing or equivalent direct evidence is available.

## Person-edit navigator save ownership — 2026-10-04

`TAHW52PersonEditFrame.DBNavigator1BeforeAction(Sender, Button)` preserves
the LCL event signature and now forwards its original `Sender` through the
named `OnSaveRequested: TNotifyEvent` boundary. `TForm1.FormCreate` connects
that request directly to the existing `speich1`; as in the complete legacy
body, the button value does not affect the save call. Removed the redundant
FPC `HandlePersonEditNavigatorBeforeAction` adapter. The old main-form
`DBNavigator1BeforeAction(Sender)` method remains conditional for the Delphi
DFM. Focused tests pass 6/6, the complete suite passes 466/466, and the
forced Debug main build links. No genealogy data was opened and save behavior
was not exercised against a live dataset.

## Person-edit focus ownership — 2026-10-04

The proven PersonEdit focus effects no longer cross a generic host callback.
`TAHW52PersonEditFrame.FocusControl` obtains the containing form and assigns
its `ActiveControl` to a frame-owned target; it raises `EInvalidOperation` if
the frame has no parent form. `TabSheet2Show` and `TForm1.FormActivate` focus
`DBEdit2`; grid exit and Escape focus `DBComboBox3` while retaining the
existing grid/label visibility, search-text, and key behavior.

Removed `OnFocusRequest`, `TForm1.HandlePersonEditFocusRequest`, and the
`FormCreate` assignment. `FormActivate` remains the lifecycle entry point;
the provider-backed `TabSheet2Enter` refresh was not moved. Focused tests pass
7/7, the full suite passes 467/467, and the forced Debug main build links.
No database was opened.

## Selection-tab person-search right-click — 2026-10-04

Restored the matching DFM-bound `TForm1.TabSheet1MouseDown` (`005E62D4`) and
`TabSheet7MouseDown` (`005E8F94`) effects in their owning frames. Both listings
act only for `mbRight`: clear global `PersonSearchDialog.Edit1`, then call
`ShowModal`. `TPersonSearchForm.ShowForSelection` now owns that shared order;
no FPC main-form adapter was added.

Since the BDE-dependent dialog is intentionally not instantiated by the FPC
startup path, either frame reports a missing global dialog with
`EInvalidOperation` rather than constructing an unsupported form or silently
doing nothing. The shared launcher likewise rejects a missing first edit.
All other mouse buttons remain no-ops. The search query, data module, modal
loop, and relationship/list navigation are unchanged and inactive.

Five synthetic tests verify both right-click routes, clear-before-show,
global target use, left/middle no-ops, and missing-dialog/control errors.
Focused tests pass 5/5; the complete suite passes 472/472; the forced Debug
main build links. No database, actual modal dialog, or genealogy data was
opened.

## Unit15 Table14 single-column projection — synthetic only

Static traces confirm that `TForm1.druck` and the direct
`geschachtelt1Click` / `Einzelpersonenmarkieren1Click` report paths use only
Table14 `Zeile` (`TMemoField`) for `QRDBText1`; the second DBText control is
unused. `frbestimmtenOrt1Click` and `Probandenname1Click` call `druck` after
they each empty and repopulate Table14. The direct callers also empty
Table14, so their provider-dependent producers remain blocked.

Added `Reports\Unit15SingleColumnRows.pas` for an in-memory-only projection
to `QRDBText1` plus blank placeholder fields required by the recovered
fifteen-field LazReport schema. It preserves memo data, source order, and
bookmark and rejects invalid source state/schema. Focused Unit15 tests pass
20/20; the test project builds; the full FPCUnit suite passes 504/504. No
database, provider, dialog, legacy QuickReport, preview, print, or PDF path
was used. This adapter does not authorize or implement the Table14 producers
or UI integration. Full caller evidence is recorded in
`DevOps\ReverseEngineering\AhnWin52-Unit15-Report-Caller-Discovery.md`.

## Unit15 Table27 `spitzbas` projection — synthetic only

The retained `spitzbas` listing, Unit2 offset map, and current DataModule LFM
corroborate Table27 (`alfls.db`) `Namvorn`/`Kn` string fields mapped to
`QRDBText1`/`QRDBText2`. Added `Reports\Unit15SpitzbasRows.pas` to copy their
`DisplayText` into a synthetic fifteen-field Unit15 dataset, leaving other
report fields blank and preserving source order and bookmark. Tests cover
both fields, field display callbacks, cursor preservation, report preparation,
empty input, missing/wrong-type fields, and invalid source states. Focused
Unit15 passes 23/23; full FPCUnit passes 507/507; the test project builds.

The legacy producer remains blocked because `spitzbas` empties Table27 before
provider-dependent rebuilding. No database, provider, original dialog,
QuickReport, preview, print, or PDF route was executed. This adapter is not
wired into production. See
`DevOps\ReverseEngineering\AhnWin52-Unit15-Report-Caller-Discovery.md`.

## Unit15 Table22 `NList` / `OList` projection — synthetic only

The independent Unit3 listings for `TForm3.NList` (`00595720`) and
`TForm3.OList` (`00595FB4`), the Unit2 component map, and the current
DataModule LFM corroborate Table22 (`nol.db`): `Zus: TMemoField` maps to
`QRDBText1`, and `No: TStringField` maps to `QRDBText2`. Added
`Reports\Unit15Table22Rows.pas` as an in-memory-only adapter preserving memo
content, `No.DisplayText`, source order, and source bookmark; unused fields
remain blank for the recovered Unit15 schema.

The focused Unit15 report suite passes 26/26, the test project builds, and the
full FPCUnit suite passes 510/510. Tests cover multiline memo/display callback,
multiple rows, empty source, schema and source-state rejection, cursor
preservation, and synthetic report preparation.

Both callers empty Table22 before provider-dependent reconstruction (and
`OList` selects `namort`); their producers, database access, and production
report integration remain blocked. No legacy QuickReport, preview, print, or
PDF workflow ran.

The listing-proven list-to-row transform is separately reconstructed in
`Reports\Unit3RegisterRows.pas`. It consumes an injected list of character-15
key/value strings, groups consecutive exact raw keys into `Zus` using
comma-space separators, skips blank trimmed keys/values, and applies the
`NList`-only exact `NN` exclusion. It outputs an in-memory Table22-shaped
dataset and composes with the existing Table22-to-Unit15 adapter. Focused
parser tests pass 4/4, including the composed projection. It does not generate
those lists or execute the legacy destructive/provider-backed producers.
The test project builds and the complete FPCUnit suite passes 514/514.

The follow-up listing search also found Table14 `Zeile`/`Nm` mappings in
`TForm3.ofb2`, `TForm3.ofb3`, and `TForm19.nachf`, plus a Table14 `Zeile`-only
mapping in `TOKBottomDlg.SpeedButton1Click`. These match the existing
synthetic `Unit15VorlistRows` and `Unit15SingleColumnRows` contracts; their
producer traversals/appends remain unrun. `TForm17.BitBtn1Click` empties and
rebuilds Table14 but clears `QuickRep1.DataSet` and never sets a DBText field,
so it does not establish a Unit15 row projection. A repository-wide search
found no other caller-specific Unit15 field assignments in the retained
`Projects_AhnenWin` listings. Full evidence is in
`DevOps\ReverseEngineering\AhnWin52-Unit15-Report-Caller-Discovery.md`.

## Unit3 source-text normalizer — synthetic only

The routine at `00576FF8` has multiple parser call sites and is recovered as
a standalone transform. It handles trimmed `..`, exact `HK`, then substring
cases `vo.r` and `na.ch`; its fallback preserves whitespace-only inputs,
strips leading periods/spaces through repeated `Copy(input, 2, 9)`, and on
nonnumeric-leading values removes periods and inserts a space before the
first byte below `':'`. Fixed slices and the nine-character intermediate
limit are retained. `Forms\Unit3SourceTextNormalizer.pas` plus focused
synthetic tests cover these branches; production parser/database callers
remain untouched. Full contract:
`DevOps\ReverseEngineering\AhnWin52-Unit3-Source-Text-Normalizer.md`.

## Unit14/Table13 `FindKey` synthetic runtime evidence — 2026-10-18

The user authorized and the standalone Delphi 9 harness
`Source\AhnWin52\ReverseEngineering\Unit14FindKeyBDEProbe.dpr` exercised a
disposable synthetic Paradox table using the loaded BDE 5.2.0.2 runtime. It
created the named unique, ascending secondary index `Ort_` on field `Ort`;
both synthetic table/index headers record language driver `DBWINUS0` (ASCII).
`FindKey('Dresden')` returned true and positioned at `Dresden`; after `First`,
`FindKey('Hamburg')` returned false and the immediate `TTable` state remained
on `Berlin` (`RecNo=1`, `BOF=True`, `EOF=False`). The fixture contained only
the artificial place values `Berlin`, `Dresden`, and `Muenchen`.

`DevOps\ReverseEngineering\AhnWin52-Unit14-FindKey-Observation-Protocol.md`
records the setup, result, and limits. Delphi 9 `DBTables.pas` independently
confirms that `FindKey` calls `DbiGetRecordForKey` and resynchronizes only on
success. The test index was unique because Paradox requires an option when a
single-field index name differs from its field name; whether the target index
is unique is not established in the prior metadata extraction. Partial keys,
exceptions, the original application's exact runtime, SQLDB parity, and
downstream `Form33` behavior remain unresolved. No AhnWin process, genealogy
database, or UI input was involved. Keep the compatibility layer's explicit
`FindKey` rejection and Unit14 handlers blocked; do not substitute `Locate`.

## Unit7 complementary-day classification — synthetic-only boundary

`TForm7.berechnen`'s complementary-day decision is now isolated in
`Forms\FrenchRepublicanComplementaryDays.pas`. The retained listing
(`Projects_AhnenWin\Unit7.pas`, `005CEB5C`–`005CECA4`) accepts text between
`'30'` and `'jrev'` only for trimmed month `Fructidor` and year combo indexes
2, 6, or 10. The listing has separate paths for the five `jc` entries and
exact `jrev`; the classifier preserves their combined accepted range and
eligibility rule. The form still owns date conversion, locale-sensitive
formatting, and the `ShowMessage`/output-clearing behavior.

The new pure tests pass 4/4; the existing calendar-form suite passes 14/14;
the test project builds. An initial invalid-form test opened the expected
“Diesen Tag gibt es nicht” dialog because the existing hook captures
`Application.MessageBox`, not `ShowMessage`; that test was removed and the
invalid form path was not invoked again. The full suite was not run in this
continuation. No live application or database was used. Details:
`DevOps\ReverseEngineering\AhnWin52-Unit7-Complementary-Day-Classification.md`.
