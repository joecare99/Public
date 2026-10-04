# Feature: Migrate QuickReport workflows to LazReport

**Status:** Unit23 preparation, Unit21 FOKO Preview dispatch, and Unit25/Unit5/
Unit15 layout preparation are migrated. Synthetic Unit23 and Unit15
LazReport pages now export through the shared report-to-PDF contract, using
SynPDF for Delphi and mORMot2 for FPC/Lazarus. The Unit15 extension is not
wired to a production caller and neither report has been exercised with
genealogy data.
Unit16's legacy QuickReport page navigation, zoom, status, Escape-key close,
exit-menu dispatch, print/save-button dispatch, print-range handler, and
NeedData callback body are restored. Its separate FPC text/HTML save action is
now translated and synthetically tested; real SQLDB output remains blocked by
the unconfigured tables and unresolved global header producers. Actual print
output remains unavailable; NeedData runtime reachability is unproven.
The Unit16 PDF-button migration is blocked pending evidence for the Unit15
report's caller dataset and field mapping.
**Priority:** Backlog  
**Sprint:** Reporting foundation  
**Decision:** QuickReport sources are unavailable. The user initially deferred
reporting, then resumed the work and confirmed a synthetic LazReport proof
followed by a bounded Unit23 vertical slice. Continue incrementally; distinguish
synthetic output validation from unvalidated product UI, real-data behavior,
printing, and output parity. The target is to replace remaining QuickReport
layouts/workflows with LazReport and use SynPDF (LGPL option) for Delphi PDF
generation; the FPC/Lazarus adapter uses SynPDF's recommended mORMot2 PDF unit.
The legacy wPDF/Ahnw50 engine and its license-code path are not target
dependencies.

## Problem

The current application sources and form resources reference QuickReport
classes, but no QuickReport implementation is available in the inspected
component directories. Lazarus LazReport is installed at
`C:\Lazarus\components\lazreport`; it uses its own report model and `.lrf`
templates and is not API-compatible with QuickReport.

## Backlog and sequence

1. Inventory the QuickReport classes, resources, event handlers, and callers.
2. **Done:** Build an isolated LazReport probe and load/prepare a static
   synthetic template.
3. **Done:** Generate/load the Unit23 FOKO template and prepare it against two
   synthetic `TBufDataset` rows. Template loading, field binding, preparation,
   and the separate synthetic PDF output slice are covered; production UI,
   page-navigation UI, printing, save/load, and real-data output remain open.
4. **Preparation slice done:** Convert Unit23's layout and field bindings into
   `Reports\Unit23Foko.lrf` and an injected-dataset preparation service.
5. **Done:** Restore `Unit21.SpeedButton2Click` as a dispatch to the embedded
   Unit23 LazReport template and the real LazReport prepared-report preview.
   Tests substitute the presenter and do not open preview UI or print.
6. **Done (synthetic output only):** Add the provider-neutral PDF contract,
   atomic file publisher, Delphi SynPDF adapter, and FPC/Lazarus mORMot2
   adapter. Exercise Unit23's prepared report with synthetic data and validate
   real two-page PDF output. No product UI, genealogy data, or Unit16 wiring.
7. **Done (layout/preparation only):** Translate Unit25's DFM to an embedded
   two-column A4 LazReport template and test it with synthetic rows. No
   production caller or field semantics are evidenced.
8. **Done (layout/preparation only):** Translate Unit5's DFM to an embedded
   single-column A4 LazReport template and validate it against synthetic rows.
   No production caller or field semantics are evidenced.
9. **Done (synthetic PDF handoff):** Translate Unit15's closely related DFM
   to its own embedded template, retaining its caption/date offsets and
   omitting its empty image placeholders. Its prepared pages now implement
   `IReportPageSource` and export synthetic rows through mORMot2. This proves
   the template-to-PDF boundary only; the real caller and dataset schema
   remain unknown.
10. **Pascal slice done; output migration blocked:** Restore Unit16's
   DFM-bound first, previous, next, and last page actions plus page-count/
   status callback from the complete listings. This does not replace its
   QuickReport preview. Unit15's DFM and current source do not establish which
   active dataset supplies its fifteen QRDBText fields; do not wire Unit16 PDF
   output until that contract is recovered.
11. Port the remaining report layouts and shared print/preview workflows.
12. Replace obsolete QuickReport project dependencies only after all callers
   are migrated; validate report paths with synthetic data.
13. Record output comparisons, known differences, and remaining uncertainties
   in the separate wiki.

## Unit16 text/HTML save action — bounded FPC restoration

`TForm16.Speichernunter1Click` now delegates the save dialog to
`ExecuteUnit16SaveDialog`, preserving the listing's exact filter, default
extension, cancellation handling, and blank-after-trim early return. An
accepted name invokes `TForm16.ExportTextFile`, which snapshots the report
selector, `Label2.Caption`, and the recovered address-based string state, then
uses the owning `DataModule2` tables with the provider-neutral
`Unit16TextExportWorkflow`.

The output projections are backed by the listing/IDR/DFM evidence:
`$00E0` -> `Table14.Nm`/`Zeile`, `$01B4` -> `Table22.No`/`Zus`, and `$01F8` ->
`Table27.Namvorn`. All 15 selector strings remain exact comparisons. The
workflow preserves the case-sensitive `htm` substring test, HTML prologue,
`<p>` and ancestor `<br>` emission, separators, report footer, and HTML close
tags. Writer and dataset errors propagate; there is no empty success fallback.

The string aliases `GlobalVar_02535930`, `GlobalVar_02535934`, and
`GlobalVar_02535438` are address-named and do not yet have mapped FPC producers.
`GlobalVar_0061E028` is read from Unit19. The FPC SQLDB tables currently have
no configured connection, so a real export was deliberately not attempted.
When a branch requires one of the unmapped strings, the form adapter raises
`EUnit16ExportStateUnavailable` before creating the output file. Thirteen
synthetic workflow tests and 23 save/preview-action tests pass; the complete
FPCUnit suite passes 461/461. The test project compiles `Unit16.pas`;
the main Debug build links but omits Unit16, so this does not establish the
end-user runtime path. This save action does not migrate Unit16's QuickReport
preview, print workflow, or separate PDF button.

## Compile-compatibility boundary

The compatibility layer under
`Source\AhnWin52\Compat\QuickReport` is a temporary compile-time contract, not
a report engine and not a change to the accepted LazReport target. Units that
still require unsupported QuickReport APIs raise
`EQuickReportCompatibilityUnsupported`. Preview, prepare, print, printer
setup, page navigation, save/load, and export calls likewise fail with the
specific unsupported-operation name. No empty report, default output, or
successful fake result is returned.

`Unit23.pas` is no longer part of that FPC contract: its FPC LFM is a plain
form, and the recovered FOKO layout is represented by
`Reports\Unit23Foko.lrf` plus `Reports\FokoListReport.pas`. The builder accepts
an already-active, caller-owned dataset named `Table20`; it validates the
nine resource-evidenced fields and never opens the dataset. It preserves the
current row around preparation and raises an explicit named error for Print.
The template is embedded as a Lazarus resource, so the workflow has no
working-directory dependency. `Unit21.SpeedButton2Click` passes the
caller-owned `DataModule2.Table20` to `TFokoListReportWorkflow`; after
successful preparation the default presenter calls
`TfrReport.ShowPreparedReport`. The Delphi DFM and Delphi-only QuickReport
field declarations remain preserved under the non-FPC conditional.

`Unit25.pas` is also removed from that FPC compatibility boundary. Its FPC LFM
is a plain form, and `Reports\Unit25ListReport.lrf` records the DFM-backed A4
two-column header/detail/footer layout and eight named field objects. The
embedded resource is loaded as a stream, then bound to an already-active,
caller-owned dataset named `Unit25Rows`; preparation validates all eight DFM
field names and restores the caller's current row. These names do not prove
production field meaning or identify an actual caller. The three DFM image
controls have no evidenced image source and are omitted. No preview, printing,
export, or output parity is claimed; the original Delphi DFM remains preserved.

`Unit5.pas` is also removed from that FPC compatibility boundary. Its embedded
`Reports\Unit5ListReport.lrf` preserves the single-column A4 header/detail/
footer layout, two caption placeholders, two enabled and thirteen disabled
DBText fields, the empty `QRMemo1`, and the date/page-number footer fields.
`TUnit5ListReport` binds the `Unit5Rows` alias to an already-active,
caller-owned dataset, validates the fifteen DFM field names, and restores the
current row after preparation. The DFM's three empty QRImage components are
omitted. No caller or production field semantics are evidenced; preview,
printing, export, and output parity are not claimed. The original Delphi DFM
is preserved.

`Unit15.pas` is likewise removed from the FPC QuickReport contract. Its own
embedded template retains the single-column A4 layout, fifteen DFM field
bindings, two caption positions, the distinct printed-date offset, and date/
page footer objects. It binds an active caller-owned dataset as `Unit15Rows`,
validates the field names, and preserves the current row. Four QRImage
placeholders, including the additional `QRImage4`, have no evidenced source
and are omitted. `TUnit15ListReport` exposes its prepared EMF pages through
the shared PDF page-source contract and can export them through the injected
writer. A two-row synthetic `TBufDataset` test writes a PDF and verifies its
signature, title metadata, A4 dimensions, and dataset cursor. Unit15 focused
tests pass 6/6; the full Lazarus suite now passes 371/371. This is not a
production caller integration: the DFM does not assign a dataset or
datasource, and the fifteen `QRDBText` names do not establish field meaning.
No real dataset, preview UI, printing, or output parity is claimed.

## Unit23 report-to-PDF vertical slice

`Reports\ReportPdfContracts.pas` defines a provider-neutral page source,
metadata record, writer interface, and argument/page validation.
`Reports\ReportPdfFilePublisher.pas` publishes through a temporary file beside
the requested destination and replaces the destination only after successful
generation. `Reports\SynPdfReportWriter.pas` is the Delphi backend;
`Reports\MormotPdfReportWriter.pas` is the Windows FPC/Lazarus backend using
the mORMot2 PDF unit recommended by SynPDF's README. Both receive the same
prepared report-page source; the old wPDF page arguments and Ahnw50 license
path are not reused.

`TFokoListReportWorkflow.ExportToPdf` prepares the embedded Unit23 LazReport
template from an already-active, caller-owned dataset, then sends its pages
through the injected PDF writer. Synthetic tests exercise this handoff with
two rows. The direct writer probes produce structurally validated two-page
PDFs with A4 portrait and landscape pages, title metadata, and rendered
synthetic canvas text. Focused writer tests pass 3/3, Unit23 workflow tests
pass 9/9, and the complete Lazarus suite passes 369/369. Delphi 7 and RAD
Studio 3.0 DCC32 each compile/run the SynPDF probe; Lazarus/FPC builds and
validates the mORMot2 probe.

This proves the adapter and synthetic workflow, not the product experience:
no PDF button/dialog is connected, no real genealogy data is used, and Unit16
QuickReport output remains unmigrated. The pinned source notices select the
LGPL 2.1 option and document the required source/license and linking review;
these probes are not approval to distribute a linked executable. See the
separate CodeWiki how-to for the flow and practical integration guidance.

## Unit15 LazReport-to-PDF follow-on

`TUnit15ListReport` now implements `IReportPageSource`, including prepared
page count, physical page definition/orientation, and rendering to a supplied
canvas. `ExportToPdf` prepares the recovered template and delegates to
`ExportReportToPdf`; the shared publisher protects any existing destination
from partial output. The synthetic test creates two rows for the fifteen
DFM-named fields and exports an A4 PDF via mORMot2. Six Unit15 tests pass and
the full suite passes 371/371.

This narrows a useful subtask for Unit16 but does not wire its PDF button:
`Unit15.dfm` contains no `DataSet`/`DataSource` assignment, and no source
evidence yet maps `QRDBText1`–`QRDBText15` to a caller-owned production
dataset. Establish that mapping before replacing the legacy path. Keep the
QuickReport compatibility layer and the Ahnw50 reference/license evidence
unchanged until every live caller is accounted for.

`Unit16.pas` now restores the DFM-bound first/previous/next/last navigation
actions and the page-count/status update from its listings. The listing uses
the callback's second register parameter (`ECX`) as the page count, so the
Pascal callback and temporary QuickReport contract now include that integer.
The page-count global is represented by the descriptive unit-level
`PreviewPageCount`; page navigation still calls QuickReport's `SetPageNumber`.
The DFM-bound zoom preset handler also maps indices 0/1/2 to 100%, fit-page,
and fit-width, mirrors the resulting preview zoom into the spin edit, and
preserves the no-op branch for other indices. The manual zoom handler applies
the spin value and clears the combo text, matching its listing's order. Ten
tests exercise pure page-transition, status-formatting, and zoom-selection
rules. They do not instantiate Unit16: its
`TWPPDFPrinter`/`TWPPDFProperties` dependency still prevents the isolated FPC
project from compiling that form. The FPC QuickReport shim continues to raise
the explicit unsupported exception for preview setters. QuickReport page
rendering, actual zoom, printing, PDF, save/export, and output parity remain
unmigrated and unvalidated.

The DFM-bound `Beenden1Click` menu handler also delegates to the form's
`SpeedButton1.Click`, matching its complete listing. The click is factored
into the `Unit16PreviewActions` helper and tested with an unstreamed synthetic
speed button; the button's print/report workflow is not invoked.

The DFM-bound `SpeedButton2Click` and `SpeedButton3Click` handlers now forward
their original `Sender` to `Drucken1Click` and `Speichernunter1Click`,
respectively, matching their complete listings. Their shared event-dispatch
helper is tested with a recording callback. `Drucken1Click` now restores its
dialog setup and QuickReport range/print dispatch; only
`Speichernunter1Click` remains listing-only. No dialog, printer, or file
operation has been invoked in tests.

`FormKeyDown` now has the ABI-correct VCL `TKeyEvent` signature and closes the
receiving form only when the referenced key is Escape. Its listing is complete,
but neither the DFM nor other reconstructed source binds/assigns this callback;
runtime reachability is therefore not claimed. The key predicate has
synthetic tests and the production helper compiles/runs under Delphi 7 and RAD
Studio 3.0.

`Drucken1Click` now configures `MinPage`, `FromPage`, and `MaxPage` from the
recovered page count; after dialog acceptance it transfers the chosen range
to `Form15.QuickRep1.PrinterSettings.FirstPage`/`LastPage` and calls
`Printer.Print`. The independent Unit16 disassembly, IDR type offsets, and
Unit15 DFM field names corroborate this path. Its FPC branch raises the
explicit unsupported-operation error before showing UI. Synthetic tests only
cover dialog-state initialization; the dialog and printer have not been run.
Unit16 remains uncompiled in FPC because WPTools is unavailable, while Delphi
builds lack the QuickReport `QRPrntr.dcu`.

`Quickreport1NeedData` now has QuickReport's `(Sender, var MoreData: Boolean)`
event signature. It increments a per-form page counter and returns whether
the report printer's current page count is greater than or equal to that
counter, matching its complete listing. Synthetic tests cover the counter
advance and stop boundary. FPC raises an explicit unsupported error when the
printer page count is requested. No Unit16 DFM/LFM binding or source
assignment was found, so the body restoration does not assert runtime
reachability.

`Speichernunter1Click` now applies the listing's text-only filter and `txt`
default extension, returns if the dialog is cancelled, and ignores an
accepted filename that trims to empty. A nonblank accepted path raises the
named `EUnit16ExportOperationUnsupported` until the long output body is
translated; FPC rejects the unsupported workflow before displaying a dialog.
Synthetic tests cover filter/default-extension state and filename trimming,
not dialog UI or file contents.

The two remaining `showpreview` wrappers in the main form and
`PersonSearchForm` still contain their listings. A DFM/LFM binding was not
found for either wrapper, and their listings read the initial page count from
shared cell `0061E0B8`; no Pascal producer for that read is currently
established. Do not wire the methods based on their names or guess the count
from a `TQRPrinter` property. Unit16's actual preview integration remains
deferred until callback reachability and the page-count source are evidenced.

`FPC\AhnWin52Tests.lpi` builds the report units against their
declared resource-facing contracts (Unit23, Unit21, Unit25, Unit5, and Unit15
exercise migrated paths) using
synthetic calls. Seven Unit23 tests cover recovered captions and bindings,
two-row synthetic preparation, cursor/ownership preservation, missing-field
rejection, form-to-builder integration, and preview/print boundaries. Two
Unit21 tests verify button-to-workflow dataset dispatch and preparation from
the embedded resource through an injected presenter. Four Unit25 tests cover
the two-column template, field bindings, synthetic preparation, caller state,
schema rejection, and the form factory. Four Unit5 tests cover its single-
column template, all field bindings/visibility, synthetic preparation, caller
state, schema rejection, and the form factory. Four Unit15 tests cover its
distinct template, field bindings, synthetic preparation, caller state, schema
rejection, and form factory. Twenty Unit16 helper tests cover page
transitions, status formatting, Escape-key recognition, NeedData counter
boundaries, save-dialog setup/name guards, print-dialog state, zoom selection,
exit-button dispatch, and report-action sender forwarding. The full runner
passes 324/324. It does not
read genealogy records, open a provider, show
modal preview UI, print, save, or validate output/pixel parity. FPC reports
four unset-result warnings
for integer/graphics/filter functions whose bodies always raise the explicit
unsupported exception; no default result is supplied to silence them.

Two separate build limits remain visible:

- `Sys\QRPrev.pas` references the preview contract, but its binary Delphi
  `QRPrev.DFM` is not recognized by the isolated Lazarus/FPC resource build.
  Preview-form resource conversion is not included in this compatibility
  slice.
- `Unit16` also requires `TWPPDFPrinter` and `TWPPDFProperties` from the
  separate WPTools dependency. That dependency has not been shimmed, and the
  unit is not claimed to compile.

Continue with the remaining report forms as separate LazReport vertical
slices; do not extend the compatibility boundary with unobserved properties
or no-op behavior.

## Acceptance criteria

- Active Lazarus application units no longer depend on QuickReport-only types.
- All recovered report layouts and data bindings are represented in LazReport.
- Preview, page navigation, print setup, save/load, and supported exports are
  implemented or explicitly recorded as blocked with evidence.
- No success-shaped placeholder or empty compatibility class masks missing
  report behavior.
- Builds and synthetic-data checks pass without reading or publishing personal
  genealogy records.

## Initial evidence and risks

- QuickReport report resources are present in `Unit5`, `Unit15`, `Unit23`, and
  `Unit25`.
- `Unit23` is the FOKO-list print form and binds its QuickReport to
  `DataModule2.Table20`; the resource identifies fields `STAAT`, `PLZ_KZ`,
  `ORT`, `TER`, `MK`, `VON`, `BIS`, `NAME`, and `BEKENN`.
- `Unit16` contains the embedded `TQRPreview` workflow; `Sys\QRPrev.pas`
  contains the standard preview form.
- `Sys\QRPrgres.pas` and `Sys\QRLablEd.pas` are additional QuickReport UI
  units that must be assessed for active runtime use.
- LazReport exposes `TfrReport`, `TfrPreview`, and a separate `.lrf` report
  format. Directly registering `TQRPreview` or renaming types would not
  preserve behavior.
- The isolated probe compiles against the installed LazReport package,
  loads `multisize.lrf`, and prepares its three blank pages. This checks only
  engine loading/preparation, not report content.
- The source tree is substantially decompiled; some report/data-flow behavior
  must first be reconstructed from x86 listings and form resources.
