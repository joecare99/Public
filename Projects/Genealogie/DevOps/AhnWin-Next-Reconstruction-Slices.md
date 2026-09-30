# Backlog: Next AhnWin reconstruction slices

**Status:** Active reconstruction backlog  
**Priority:** Continue non-reporting reconstruction; QuickReport/LazReport is
deferred by user request.

## Latest checkpoint — Source-name list Enter dispatch

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

## Actual source-restoration status — 2026-09-30

The todo percentages below are workflow tracking only; they are not the
percentage of the decompiled program translated to Pascal. The reusable
per-file scan found 251/323 class-qualified methods in
`frmAhnenWinMain.pas` retaining listings (77.71%). Within the `TForm1` class
specifically, 251/283 retain listings (88.69%); the distinction is that the
file also contains other classes. Across all 69 Pascal files, 759/1,047
class-qualified methods retain listings (72.49%). The reconstructed
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

**Main-form `DBEdit69` change reset:** Both main-form resources bind
`DBEdit69.OnChange` to `TForm1.DBEdit69Change`. Its complete listing has no
condition and clears three address-identified long-string globals in order:
`GlobalVar_0061E0A0`, `GlobalVar_0061E0A4`, and `GlobalVar_02535B58`.
`Unit32`'s long-string assignments corroborate the types of the first two
cells; the handler's `@LStrClr` calls establish the third. A synthetic test
seeds distinct values and calls the handler on an unstreamed `TForm1`; it
does not create the data module or access a provider.

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
callbacks are restored, but `berechnen`'s large assembler listing remains
untouched and no calendar-conversion behavior is claimed. A synthetic test
verifies that empty inputs preserve the existing output. The suite passes 165
tests and the Debug main project builds; `Unit7.pas` now has 1/10 methods with
retained listings.

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

**Status:** Calendar generation and year navigation implemented; model tests
pass for every supported year and the isolated form builds. The two
address-based callbacks now restore paired mutations of global `025358EC`
through `GlobalVar_025358EC`. Synthetic tests verify only the increment and
decrement. Their consumers, semantic purpose, and event associations remain
unresolved.
The print workflow remains deferred with reporting.  
**Effort:** Completed for the date-grid slice; print reconstruction remains
separate and report-dependent.  
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
**Follow-up:** Keep the print handler deferred and retain the callback
listings under their address-based names. Available Pascal/DFM/LFM evidence
does not identify the counter's consumers or justify binding either callback.
Do not use genealogy database data.

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

**Navigation/focus handlers:** `PageControl1Exit` is a return-only handler;
`ComboBox5Change` sets `ActiveControl := Edit4`, as proven by the x86 listing
and the `.lfm` event binding. Both completed assembly-reference blocks were
removed. Static resource/body assertions and the main Lazarus build pass.

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
