# Main-form tab handler ownership

## Scope and status

The nine tab resources and control trees are already hosted by production
frames. This inventory tracks the second, separate migration: event logic and
the legacy listing evidence must no longer be kept in `frmAhnenWinMain.pas`
merely because an adapter was convenient during the resource move.

`frmAhnenWinMain.pas` initially contained 287 `TForm1` method implementations.
After the completed tab-handler slices and the menu-source split, the main
unit plus its menu-area includes contain 239 implementations. The main source
file is now 63,860 lines (down from 107,278 immediately before the menu
split). A source scan found about 53 implementations with executable Pascal
outside the retained ASM comments; the remainder were mostly listing-only
stubs. Moving controls did not move those stubs or listings.

## Migration rule

- Move executable code whose behavior belongs to one tab into that tab's frame.
- Keep cross-tab navigation, menu/application actions, form lifecycle,
  shared persistence, and genuinely shared operations behind narrow host or
  service boundaries.
- Listing-only methods remain inert. Preserve their original text in a
  non-compiled, frame-specific evidence file before deleting their host
  implementations. Listing offsets continue to describe the original
  `TForm1`, not a frame instance.
- Remove adapter enums/cases and host method declarations only after source
  references and tests confirm they are no longer needed.

## Current event routes

| Tab/frame | Current event routes to the host | Ownership / next action |
|---|---|---|
| `TabSheet1` / `TAHW52PersonSelectionFrame` | none; right-click invokes the dialog global directly | Exact `mbRight` clears `PersonSearchDialog.Edit1` and invokes the shared modal launcher; other buttons do nothing. A missing dialog raises `EInvalidOperation`. BDE-backed show, grid, and navigation behavior remains inactive. |
| `TabSheet2` / `TAHW52PersonEditFrame` | tab-entry refresh and save request | Four field exits (`DBEdit12/13/20/21`) now terminate as frame-local no-ops. Their old host wrappers called `wt34`/`wt36`, which had no executable Pascal body; all six ASM listings are preserved in `ReverseEngineering\AhnWin52-TabSheet2-EditFieldExits.asm.txt`. `DBEdit69Change` resets address-named shared state locally through `AHW52LegacySharedState`. Navigator save is wired through `OnSaveRequested` directly to `speich1`. All proven focus changes (`DBEdit2`, `DBComboBox3`) now execute in the frame through its containing form; only provider-backed tab entry remains host-routed. |
| `TabSheet3` / `TAHW52PersonDetailsFrame` | none | `ComboBox5Change` now focuses the frame-owned hidden `Edit4`; the other bound events also terminate in the frame. Listing-only Details behavior remains inactive. |
| `TabSheet4` / `TAHW52RelationshipsFrame` | tab enter/exit, grid click, DBEdit exits, DBComboBox exit, combo exits | All handlers terminate in the frame. The old combo-exit host dispatcher and two empty `TForm1` wrappers are removed; their historical listings remain inactive in `ReverseEngineering\AhnWin52-Details-Relationships-ComboExits.asm.txt`. |
| `TabSheet5` / `TAHW52SiblingsFrame` | none; enter and grid double-click terminate in the frame | **Source migration complete.** Removed both no-op host handlers and the dispatcher; preserved 1,551 lines of inactive listing evidence in `ReverseEngineering\AhnWin52-TabSheet5-Siblings.asm.txt`. BDE lookup/navigation remains deferred. |
| `TabSheet6` / `TAHW52PersonTextFrame` | memo exit | The memo-exit callback reaches the shared person-persistence workflow. The empty tab-enter adapter and host assignment have been removed; the historical dataset/caption listing remains inactive. |
| `TabSheet7` / `TAHW52RelatedPersonSelectionFrame` | none; right-click invokes the dialog global directly | The tab mouse-down handler matches TabSheet1: exact `mbRight` clears `PersonSearchDialog.Edit1` and invokes its modal launcher; absent dialog raises `EInvalidOperation`. Dataset, cross-tab, and relationship-selection behavior remains inactive. |
| `TabSheet8` / `TAHW52AddressFrame` | tab enter | City-combo exit now terminates in the frame. The old empty host wrapper was removed and its inactive listing was archived; address DB/BDE behavior remains unresolved. |
| `TabSheet9` / `TAHW52PicturesFrame` | none; click/show/exit terminate in the frame | **First source migration complete.** Removed the pictures host dispatcher and three `TForm1` methods. Preserved their 7,067 source lines of listing evidence in `ReverseEngineering\AhnWin52-TabSheet9-Pictures.asm.txt`; frame handlers remain inert. |

## Residual callback audit — 2026-10-18

Cross-checked the current frame Pascal, main-form event wiring in
`FormCreate`, relevant LFM bindings, and the retained `TForm1` listing bodies.
The remaining callback paths are:

| Route | Current behavior and evidence | Disposition |
|---|---|---|
| `PersonEditFrame.TabSheet2Enter` → `HandlePersonEditHostAction` → `TForm1.TabSheet2Enter` | The bridge has one enum case. The target calls `anzeigen(Self)` unless `GlobalVar_0253592C = 'dsneu'`; its listing includes the BDE-backed person-list display path. | Keep the narrow bridge. Do not localize or invoke without a provider-free `anzeigen` contract. |
| `PersonEditFrame.DBNavigator1BeforeAction` → `OnSaveRequested` → `speich1` | The LFM binds the navigator event and the main form wires the callback. This is shared person persistence, not tab-local UI state. | Keep the save boundary and sender forwarding; do not treat it as a candidate for a synthetic no-write handler. |
| `PersonTextFrame.DBMemo1Exit` → `OnSaveRequested` → `speich1` | The LFM binds the memo exit; the main form wires the same save workflow. | Keep shared persistence routing unchanged. |
| `PersonEditFrame.TabSheet2Exit` | Main-form LFM event is redirected to the frame; its current handler is empty. No supported effect was established in the current source. | Keep inert; do not infer behavior from neighboring tab handlers. |
| `PageControl1Exit` | Main-form LFM binds it; the Pascal implementation is empty and has no retained listing block adjacent to its body. | Keep inert; no disassembly-backed action to restore. |
| `PersonEditFrame.TabSheet2Show` | Frame-owned method calls `FocusPrimaryField`; its focus behavior is already reconstructed and tested. | Complete; no additional restoration needed. |
| Other tab event methods | Resource-wired methods are already frame-local. The ownership rows above identify which bodies are verified behavior and which deliberately remain empty. | No new host forwarding route was found by the callback-assignment search. |

No unimplemented residual route in this audit is both fully specified by
listing/resource evidence and independent of provider or persistence effects.
In particular, `TabSheet2Enter` and the two save callbacks are not safe
frame-local restorations. Do not remove the bridge or replace persistence with
a fake success path. The audit therefore selects no new Pascal handler for
this slice; resume when a complete listing establishes another bounded,
provider-free effect. Validation of the unchanged source tree: all 488
FPCUnit tests pass and `AHW52_Main` builds in Debug mode.

## Cross-cutting genealogy data access

Active basic Table1 and marriage Table5 consumers now use
`RequireGenealogyDataModule` instead of the concrete `DataModule2` reference.
The interface exposes `Table1`/`Table3` as `TDataSet`, the six verified
Table1 fields, `Table5: TDataSet`, and `Table5Numr`/`Table5Epnum: TField`.
This covers parent unlink, privacy restore, close/post/backup, person save,
Table1/Table5 control suppression, the Details religion exit, Unit13's
person-number read, Table5 privacy reset, marriage close-state guard, and
Table5 close, and the privacy-mode `Table17` dataset lookup. The graphics
form also opens `Table17` and `Table18` through the same interface.

The person edit/save callback remains shared at the main-form boundary;
only its data-module dependency moved behind the interface. Details now writes
the verified religion field through the same contract. The synthetic
dataset-control test assigns the production adapter and verifies both Table1
and Table5 transitions. Other dependencies, including `Table4`, `Table20`,
and `Table35`, remain concrete and are not implicitly classified as
temporary. The empty `ITemporaryDataModule` marker is unchanged. Marriage
insertion, lookup, and provider behavior are not enabled by this boundary.
`Table17`/`Table18` retain their concrete `TParadox` implementation; the
interface exposes only `TDataSet`. Their open order is unchanged, and no
actual data file or graphic rendering is exercised by the synthetic tests.
The remaining privacy datasets `Table7`, `Table8`, and `Table9` now also
resolve through the interface; their existing privacy operation order is
unchanged. Table7's master/index configuration and provider semantics remain
concrete and untested against live data.

The location-list consumer `TOrtsfamilienbuchOptionsForm.listanz` now resolves
only `Table13` and `Table13Ort` through the same interface. `Table12` and
`Table37` remain concrete. The location table remains the streamed `LOC.db`
component; no provider behavior is exercised.

The HEJ writer/reader listings were checked for the remaining list tables.
Their component map places Table12 (`NM.db`) at `$00C8`, Table13 (`LOC.db`)
at `$00CC`, and Table37 (`ndh.db`) at `$0520`; the `ortv` backup section uses
`$00CC`, while the writer and reader contain no references to `$00C8` or
`$0520`. Table12 and Table37 are therefore not evidenced as HEJ genealogy
data. This does not prove they are temporary, so both remain concrete and
outside `ITemporaryDataModule`.

The close-only `Table4`, `Table20`, and `Table35` accesses were checked in the
same backup/restore listings. Their streamed files are `NUMRES.DB`,
`FOKO.DBF`, and `occ.db`; the independent component map assigns `$0074`,
`$0158`, and `$0380`. Neither listing references these offsets. They are not
evidenced as HEJ genealogy data, but are not thereby temporary; all three
remain concrete and outside the current interfaces.

## Progress

The Pictures and Siblings slices removed 8,641 lines from
`frmAhnenWinMain.pas` (123,385 to 114,744) without enabling their implied
database, file, or navigation behavior. Pictures owns its click/show/exit
entry points; Siblings owns tab entry and grid double-click. Subsequent
handler migration has reduced the host from 287 to 239 method
implementations. The edit-field increment removed four host event
wrappers and their two empty helper stubs (12,042 bytes); the four frame
events no longer dispatch inert field exits back to `TForm1`. The focused
edit-frame suite passed 4/4, the full suite 422/422, and the main Debug and
test projects built at that checkpoint.

The Details and Relationships combo-exit callbacks were also removed where
they only forwarded to listing-only `TForm1` methods with empty executable
bodies. Their frame events remain LFM-bound but now stop in local no-op
handlers. The two Details/Relationships listings are preserved, uncompiled, in
`ReverseEngineering\AhnWin52-Details-Relationships-ComboExits.asm.txt` and
the Address listing in `ReverseEngineering\AhnWin52-Address-ComboExit.asm.txt`.
The complete suite passes 420/420, and the main Debug and test projects build.

## Person-edit shared-state reset localized

`DBEdit69.OnChange` remains bound to the active reset, now implemented by
`TAHW52PersonEditFrame.DBEdit69Change`. Its three listing-proven string
assignments retain their order in `AHW52LegacySharedState.ResetPersonEditSearchState`.
The FPC `peaDBEdit69Change` host-action case and adapter are removed. A
conditional `TForm1.DBEdit69Change` compatibility proxy remains for the
unconverted Delphi DFM, which still binds its legacy main-form control. The
`TabSheet2Enter` host route and navigator/focus callbacks are unchanged.

`GlobalVar_0061E0A0` and `GlobalVar_0061E0A4` now have one Pascal storage
owner shared by the main form and `Unit32`. `Unit32`'s zero-counter cleanup
still clears those two strings and finalizes its own string array; the third
cell `GlobalVar_02535B58` is not cleared by that callback. The state remains
named by binary address because its domain meaning is unknown.

The focused edit-frame suite passes 6/6, the full FPCUnit suite passes
466/466, and the forced Debug main build links. Tests confirm that the frame
reset does not dispatch to the host and that the `Unit32` cleanup operates on
the shared cells. No database, image file, or listing-only behavior was
activated.

## Person-edit navigator save handoff localized

The complete navigator callback contract remains
`DBNavigator1BeforeAction(Sender, Button)`, but its original main-form body
only calls `speich1(Sender)`; the `Button` value is not observed. The frame
now exposes the existing shared-save boundary as `OnSaveRequested: TNotifyEvent`
and forwards the original navigator sender. `FormCreate` wires that event
directly to `TForm1.speich1`.

Removed `HandlePersonEditNavigatorBeforeAction`, its declaration, and the
frame's navigator-specific `TDBNavClickEvent` callback. The
`TForm1.DBNavigator1BeforeAction(Sender)` method is compiled only outside FPC
to preserve the legacy Delphi DFM binding. The save implementation and its
dataset guards, persistence behavior, and errors remain unchanged. Focused
edit-frame tests pass 6/6, the full suite passes 466/466, and the forced
Debug main build links; no genealogy data was opened.

## Person-edit focus ownership localized

The complete focus effects are now performed by `TAHW52PersonEditFrame`.
`FocusControl` uses `GetParentForm(Self).ActiveControl` for the frame-owned
target and raises `EInvalidOperation` when no parent form exists. Tab show and
form activation focus `DBEdit2`; grid exit and Escape focus `DBComboBox3`,
with the existing grid visibility, label, text, and key behavior unchanged.

Removed `OnFocusRequest`, `TForm1.HandlePersonEditFocusRequest`, and its
`FormCreate` assignment. `TForm1.FormActivate` remains the application
lifecycle entry point and continues calling `PersonEditFrame.FocusPrimaryField`.
The provider-backed `TabSheet2Enter` boundary and navigator save route remain
unchanged. Focused edit-frame tests pass 7/7, the full suite passes 467/467,
and the forced Debug main build links. No database or live records were used.

## Selection-tab person-search right-click localized

The complete `TabSheet1MouseDown` listing at `005E62D4` and hidden
`TabSheet7MouseDown` listing at `005E8F94` perform the same guarded sequence:
only `mbRight` clears the global person-search dialog's `Edit1`, then invokes
`ShowModal`. The LFM/DFM event wiring continues to target the corresponding
frame-owned handler; no main-form adapter is used.

`TPersonSearchForm.ShowForSelection` owns that shared clear-then-modal order.
Each frame resolves the existing global `PersonSearchDialog` and raises
`EInvalidOperation` if it is absent; the launcher also reports a missing
`Edit1` explicitly. No fallback dialog is created, because the existing BDE
`TQuery` prevents the search form from being instantiated in the FPC start
path. No search, dataset, modal loop, or relationship mutation was enabled.

Five focused synthetic tests cover both frame events, pre-modal clearing,
the global target and one modal call, non-right-button no-ops, and explicit
missing-dialog/control errors. They pass 5/5; the full suite passes 472/472,
and the forced Debug main build links. No database or live records were used.

## Details relationship-combo focus localized

The complete `ComboBox5Change` listing only assigns the form's active control
to the hidden `Edit4`. The Delphi DFM proves that `Edit4` is a `TEdit` owned by
the Details tab (`Left=115`, `Top=379`, `Width=25`, `Height=24`,
`MaxLength=2`, `TabOrder=32`, `Visible=False`); the FPC frame now streams that
resource and owns the event. The handler obtains the containing form with
`GetParentForm(Self)` and assigns its `ActiveControl` to the frame-owned edit,
raising `EInvalidOperation` if the frame has no parent form.

The FPC host-action enum/callback/dispatcher and main-form route are removed.
A conditional `TForm1.ComboBox5Change` compatibility proxy remains for the
unconverted Delphi DFM binding. Focused Details tests pass 2/2, the full suite
passes 466/466, and the forced Debug main build links. No relationship,
dataset, or provider behavior was enabled.

## Person-edit checkbox refresh through the data boundary

The complete `TForm1.DBCheckBox1Exit` listing at `00602068` performs only
`DataModule2.Table1.Refresh`. The frame now performs the same operation via
`RequireGenealogyDataModule.Table1.Refresh`; the LFM still binds
`DBCheckBox1.OnExit` directly to the frame method.

`DataModule2: TGenealogyDataModule` remains the concrete streamed form and
resource owner for compatibility. `GenealogyDataModuleAccess` holds
`IGenealogyDataModule` and its global reference; its first contract
member is only `Table1: TDataSet`, the narrowest type needed for `Refresh`.
The separate `ITemporaryDataModule`/`TemporaryDataModule` contract is
intentionally property-free until the non-genealogy tables are inventoried;
being outside the HEJ backup scope alone does not make a table temporary.
Genealogy data follows the user's HEJ boundary: person, marriage, adoption,
place, and source records included in that backup. Component membership is
not inferred until the backup/table mapping is established.
Production adapters are reference-counted but do not own the form. Startup
creates both after `InitializeDataAccess`, then clears both interface globals
in `finally` immediately after `Application.Run`, before application-owned
forms are destroyed. Missing interface/form input raises
`EDataModuleInterfaceUnavailable`; refresh errors propagate unchanged.

Each interface will grow only as individually verified consumers migrate.
`Table11: TSQLTable` and other concrete table/provider details are not added
speculatively. No SQL driver/provider is configured by this change. The
focused PersonEdit suite passes 14/14, the full suite 479/479, and the forced
Debug main build links; adapter and handler tests use only synthetic state.

## Menu-triggered host actions

The main-form LFM binds 84 distinct click events to `TForm1`: 76 commands
under the 13 top-level menus plus eight person/relationship popup actions.
All 84 existing method implementations are now grouped into nine Pascal
includes under `Forms\MainMenuActions`:

| Include | Menu area | Implementations |
|---|---|---:|
| `FileRecordBackup.inc` | File, record, backup | 15 |
| `DataExchange.inc` | Data exchange | 8 |
| `Search.inc` | Search | 8 |
| `ReportsAndLists.inc` | Lists and reports | 15 |
| `AncestorDescendant.inc` | Ancestor/descendant | 10 |
| `CalendarAndPictures.inc` | Calendar and pictures | 9 |
| `DataValidation.inc` | Data validation | 4 |
| `FilterAndInfo.inc` | Filter and information | 7 |
| `RelationshipPopup.inc` | Relationship/person popup commands | 8 |

The `.lfm` method names and `TForm1` declarations are unchanged; the include
files are compiled as part of `frmAhnenWinMain`, not separate units. This
physically shrinks and organizes the source without changing event routing or
inventing controller APIs. A later migration may replace individual
implementations with narrow controller proxies after their dependencies are
understood. Listing-only database/provider behavior remains inactive.

## Assembly listing resource maps

Every first-party routine containing an embedded DeDe assembly listing now
has a resource-map comment immediately before its implementation. The scan
covers 568 routines in 38 Pascal/include files, including the main form,
`Forms`, `Sys`, and the menu-area includes. Third-party source was excluded.

The comments record symbolized UI controls/forms, database/provider API
references, global-variable names, unresolved `OFFS_*` fields, project and
framework calls, and possible string/file/dialog resources. All 568 maps
explicitly retain an unknown-reference warning; 139 listings have no
symbolized resource labels at all. These maps describe the commented
historical binary listing, not current runtime dependencies. Form/control
offsets refer to the old binary layout; `GlobalVar_*` names and `OFFS_*`
fields are not treated as a recovered schema.

For reconstruction prioritization, a listing with named local controls and
known framework calls but no unresolved globals/data offsets is a stronger
conversion candidate. A listing that opens BDE tables, touches global state,
or contains opaque offsets should first be cross-referenced against the data
module and a symbol/offset map. No assembly listing was activated by this
annotation pass.

## Calendar menu controller — bounded lifecycle extraction

The LFM-bound `GregorianischerKalender1Click` and
`FrzRevolutionskalender1Click` handlers remain on `TForm1` as short proxies.
Their shared sequencing now lives in `Forms\CalendarMenuController.pas`;
control activation, record saving, concrete forms, view-model construction,
modal display, and legacy state remain in the form adapter.

The Gregorian action preserves `TabSheet2` activation then `speich1`, creates
a newly owned `TGregorianCalendarForm`, injects a new
`TGregorianCalendarViewModel`, shows it modally, and calls `Free` from a
`finally` block. The French action preserves the same tab/save prefix, sets
`FrenchRepublicanCalendarForm.Form7` before modal display, then calls
`Release` and clears `Form7` in nested `finally` blocks. These disposal rules
are intentionally not unified.

Six synthetic tests assert ordering, sender forwarding, owner and ViewModel
setup, global reference visibility, modal and save exception propagation, and
cleanup. The focused suite passes 6/6; the full suite passes 465/465; the
forced Debug main build links. No modal UI or genealogy data is exercised.

## Text-tab inert enter adapter removed

`TAHW52PersonTextFrame.TabSheet6Enter` had an empty Pascal body, and the frame
LFM did not bind an enter event. Removed that method and the redundant
`TabSheet6.OnEnter` assignment from `TForm1`. The active `DBMemo1.OnExit` path
is unchanged: `DBMemo1Exit(Sender)` forwards the original memo sender through
`OnSaveRequested` to `speich1`.

The complete assembly-backed tab-enter behavior reads datasets and composes
`Label21`; it remains inactive and was not moved into the frame. The focused
PersonTextFrame suite verifies that `TabSheet6.OnEnter` stays unassigned and
that the memo/save callback remains bound.
