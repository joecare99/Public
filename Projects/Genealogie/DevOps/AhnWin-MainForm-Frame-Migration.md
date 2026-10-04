# AhnWin Main-Form Frame Migration

## Product goal

Split `TForm1` into nine tab-owned frames while keeping `TForm1` as the
application shell for the `PageControl`, menus, dialogs, global lifecycle, and
cross-tab navigation. Migrate one tab at a time and preserve the currently
streamed layout and observable Pascal behavior at each increment.

The frame inventory is:

| Tab | Frame | Status |
| --- | --- | --- |
| `TabSheet1` - Auswahl | `TAHW52PersonSelectionFrame` | Done |
| `TabSheet2` - Bearbeiten | `TAHW52PersonEditFrame` | Done |
| `TabSheet3` - Details | `TAHW52PersonDetailsFrame` | Done |
| `TabSheet4` - Ehen u.a. | `TAHW52RelationshipsFrame` | Done |
| `TabSheet5` - Geschwister | `TAHW52SiblingsFrame` | Done |
| `TabSheet6` - Text | `TAHW52PersonTextFrame` | Done |
| `TabSheet7` - hidden related selection | `TAHW52RelatedPersonSelectionFrame` | Done |
| `TabSheet8` - Adresse | `TAHW52AddressFrame` | Done |
| `TabSheet9` - Bilder | `TAHW52PicturesFrame` | Done |

## Sprint goal — first vertical slice

**Story:** As a maintainer, I want the person-selection tab's grid and event
entry points to belong to a named frame, so that the main form can remain a
thin host without inventing unrecovered database behavior.

**Acceptance criteria**

- The selection tab embeds a production frame and no longer owns `DBGrid1`.
- The frame retains the original columns, visual properties, and grid bounds.
- Grid events are handled by the frame. Tab `OnShow`, `OnExit`, and
  `OnMouseDown` are assigned to frame methods after resource loading.
- Frame-to-host actions use callbacks; the frame does not reference global
  `Form1` or a sibling frame.
- Existing incomplete behavior is not silently promoted to reconstructed
  behavior. Assembly-only BDE and global-state paths remain deferred.
- Tests cover frame streaming, layout, event forwarding, and host wiring.

**Completed increment — 2026-10-04**

- Renamed `fra_Page1.pas/.lfm` to
  `Forms\AHW52PersonSelectionFrame.pas/.lfm` with `svn move`.
- Moved the original `DBGrid1` resource under the frame, preserving all nine
  columns and the original bounds (`Left=37`, `Top=13`, `Width=987`,
  `Height=640`).
- Embedded the frame in `TabSheet1`; kept `PageControl1` and tab navigation
  on `TForm1`.
- Added typed callback boundaries for grid double-click, key-down, and tab
  lifecycle/mouse events. `FormCreate` connects those boundaries to the
  existing host methods.
- Corrected the host key and mouse handler signatures to match their event
  contracts. Their Pascal bodies remain empty; their assembly listings remain
  in the source as evidence, not as active code.
- Updated the selection preview project to load the production frame.
- Added four FPCUnit tests. Full suite: 408/408 passed. The preview project
  and main Debug project build.

## Sprint goal — second vertical slice

**Story:** As a maintainer, I want the person-edit tab's controls and local
events to belong to a production frame, while global refresh, persistence,
navigation, and unresolved database behavior remain behind host boundaries.

**Acceptance criteria**

- `TabSheet2` embeds `TAHW52PersonEditFrame` and no longer owns its 70 controls.
- Control field bindings and local event bindings remain streamed.
- Frame-local focus and grid-dismissal behavior stays in the frame; host-owned
  refresh, navigator, shared state, and focus actions use explicit callbacks.
- Empty handlers and assembly-only database behavior are not activated by
  extraction.
- Tests cover streaming, field bindings, event wiring, focus requests, and grid
  Escape/exit behavior.

**Completed increment**

- Renamed the incomplete `fra_Edit` prototype to
  `Forms\AHW52PersonEditFrame.pas/.lfm` and embedded it in `TabSheet2`. Its
  70 controls, layout, and `DataField` settings remain in the frame resource.
- Kept the 43 control event bindings in the frame resource; the three tab
  lifecycle events are connected to frame methods after streaming.
- Moved verified grid-dismissal and edit-tab focus behavior into the frame.
  Focus requests return to the host through a typed callback. Tab-entry
  refresh, navigator pre-action, and shared edit/global-state actions remain
  explicit host callbacks.
- Updated host-side privacy and close helpers to access `DBText1` and
  `FileListBox2` through the owning frame. Removed redundant main-form event
  forwarding methods after tests were switched to call the frame.
- Repointed the edit-frame preview project to the production frame resource.
- Added four frame tests. The full suite passes 412/412; the main Debug
  application, edit-frame preview, and test project build.

## Sprint goal — third vertical slice

**Story:** As a maintainer, I want the Details tab's controls and bound
events to belong to a dedicated frame, while cross-tab focus and unresolved
listing-only handlers remain behind explicit host callbacks.

**Acceptance criteria**

- `TabSheet3` embeds `TAHW52PersonDetailsFrame` and no longer owns its 71
  child controls.
- The 23 control-event bindings, original data fields, visual bounds, tab
  caption, and page order remain intact; enter/exit lifecycle is delegated to
  the frame after streaming.
- Verified local relationship-caption normalization and religion field
  assignment execute in the frame. Shared focus behavior and empty/listing-only
  handlers remain explicitly host-owned.
- Focused tests cover streaming, field bindings, bounds, event ownership, and
  host-action forwarding.

**Completed increment**

- Extracted the entire `TabSheet3` subtree into
  `Forms\AHW52PersonDetailsFrame.pas/.lfm` and embedded that frame in the
  existing tab. The 71 controls and their layout/field bindings were retained.
- Bound the control events directly to the frame and routed the 14 distinct
  listing-only/shared actions through a typed host callback. The tab's enter
  and exit events are connected in `FormCreate`.
- Moved the active `ComboBox5Exit` normalization and
  `DBComboBox7Exit` religion-field assignment into the frame. `ComboBox5Change`
  stays a host action because its legacy body targets `TForm1.Edit4`.
- Updated the relationship-caption tests to exercise the streamed frame and
  registered two additional frame tests.
- The full suite passes 414/414. The main Debug application and test project
  build; no database was opened.

## Sprint goal — fourth vertical slice

**Story:** As a maintainer, I want the relationships tab's controls and
control-owned events to belong to one frame without enabling its unresolved
BDE lookup, dataset, or date-validation behavior.

**Acceptance criteria**

- `TabSheet4` embeds `TAHW52RelationshipsFrame` and no longer owns its 37
  child controls.
- All 11 control-event bindings, data-field names, geometry, caption, image
  index, and tab order remain intact.
- The tab's enter, exit, and show lifecycle bindings route through the frame;
  proven no-op show behavior remains a no-op.
- Shared combo-exit actions continue through the host adapter, and all
  assembly-only database behavior remains inactive.
- Tests cover streamed ownership, bindings, event ownership, and callback
  forwarding.

**Completed increment**

- Extracted the complete `TabSheet4` subtree into
  `Forms\AHW52RelationshipsFrame.pas/.lfm` and embedded it inline under the
  unchanged tab shell. All 37 controls retain their original positions,
  styles, and `DataField` values.
- The 11 control-event bindings are now frame methods. Nine unresolved or
  shared actions use a typed host callback; `TabSheet4Show` remains a local
  empty handler, matching its verified no-op body.
- `ComboBox20Exit` and `ComboBox11Exit` remain host adapters because the
  Details frame also forwards those legacy actions. Tab lifecycle is wired
  after streaming.
- The old `TabSheet4Enter`, `TabSheet4Exit`, grid-click, relationship-type,
  and date handlers remain inert; their commented ASM listings are not
  reactivated during this ownership change.
- Two frame tests cover streaming, key bindings, event assignment, and all
  callback actions. The full suite passes 416/416; Debug main and test
  projects build. No database was opened.

## Sprint goal — fifth vertical slice

**Story:** As a maintainer, I want the siblings grid and its tab-entry event
to belong to a dedicated frame while the original unresolved dataset lookup
and cross-tab navigation remain behind the host boundary.

**Acceptance criteria**

- `TabSheet5` embeds `TAHW52SiblingsFrame` and no longer owns its two child
  controls.
- The grid's original geometry, hint, row count, columns, fonts, options, and
  double-click binding are preserved.
- Tab entry is delegated through a typed frame callback after streaming.
- No BDE lookup, dataset iteration, label population, or navigation behavior
  is enabled from commented assembly listings.
- Tests cover streamed ownership, grid properties, event assignment, and
  sender/action forwarding.

**Completed increment**

- Extracted `Label26` and `StringGrid4` into
  `Forms\AHW52SiblingsFrame.pas/.lfm`; the tab keeps its caption, image index,
  and page position.
- The `StringGrid4` double-click and `TabSheet5Enter` entry point forward
  through typed host actions. Their existing Pascal methods remain empty;
  the assembly listings that describe BDE lookup and edit-tab navigation
  remain evidence only.
- Added two frame tests for the original grid dimensions/column widths,
  streaming, event ownership, and callback routing.
- The focused tests pass 2/2; the complete FPCUnit suite passes 418/418.
  Debug main and test projects build. No database was opened.

## Sprint goal — sixth vertical slice

**Story:** As a maintainer, I want the text label and comment memo to belong
to a dedicated frame while preserving the existing memo-exit save chain and
leaving the assembly-only tab-entry behavior inactive.

**Acceptance criteria**

- `TabSheet6` embeds `TAHW52PersonTextFrame` and no longer owns its two child
  controls.
- The comment field, memo bounds, hint, scrollbars, styles, tab caption,
  image index, and memo-exit event are preserved.
- Memo exit is dispatched through a typed frame-to-host action; the empty
  tab-enter adapter was removed in a later cleanup increment.
- The memo exit callback retains the existing `DBMemo1Exit(Sender) ->
  speich1(Sender)` path; no additional database operation is invented.
- Tests cover streamed ownership, data binding, visible properties, event
  ownership, and callback sender/action forwarding.

**Completed increment**

- Extracted `Label21` and `DBMemo1` into
  `Forms\AHW52PersonTextFrame.pas/.lfm`; the tab shell retains its caption,
  image index, and page order.
- The `Kommentar` field binding and memo-exit event remain in the frame
  resource. `DBMemo1Exit` forwards to the existing host method, which invokes
  `speich1(Sender)`; that method's current insert/post guards are unchanged.
- At extraction time, `TabSheet6Enter` forwarded to its prior host handler.
  Its commented listing performs dataset reads and updates `Label21`, but
  remained inactive because the Pascal handler was empty. A later cleanup
  removed the empty frame handler and host assignment; the listing remains
  inactive.
- Two frame tests cover streaming, bounds, field/hint values, event
  ownership, and callback routing. Focused tests pass 2/2; the full suite
  passes 420/420. Debug main and test projects build. No database was opened.

**Cleanup increment:** Removed the empty `TabSheet6Enter` frame method and
the main-form `TabSheet6.OnEnter` assignment. `DBMemo1.OnExit` and
`PersonTextFrame.OnSaveRequested := @speich1` remain unchanged. The updated
focused test asserts no enter handler is assigned while retaining assertions
for memo event ownership and sender forwarding. The historical tab-enter
listing still reads datasets and updates `Label21`; that behavior remains
inactive. The focused frame suite passes 2/2, the full FPCUnit suite passes
465/465, and the forced Debug main build links. No data or interactive UI was
used.

## Sprint goal — seventh vertical slice

**Story:** As a maintainer, I want the hidden secondary-person selection
grid and its tab events to belong to a dedicated frame, without restoring
unverified dataset, BDE, or global-state behavior.

**Acceptance criteria**

- `TabSheet7` embeds `TAHW52RelatedPersonSelectionFrame` and no longer owns
  its two child controls.
- The tab remains hidden and retains its page/image metadata; the label,
  nine grid columns, bounds, hint, fonts, and options are preserved.
- Grid double-click and tab entry are routed through typed frame callbacks.
  The tab mouse callback preserves its full button/modifier/coordinate event
  signature.
- No database is opened and no assembly-only lookup, refresh, navigation, or
  global-state behavior is enabled.
- Tests cover streamed ownership, visibility, columns, geometry, callback
  wiring, and mouse parameter forwarding.

**Completed increment — 2026-10-04**

- Extracted `Label27` and `DBGrid2` into
  `Forms\AHW52RelatedPersonSelectionFrame.pas/.lfm`; `TabSheet7` retains
  `ImageIndex=6`, `TabVisible=False`, and its position in the page control.
- Preserved all nine grid fields in their original order, display properties,
  and bounds. The original LFM has no `DataSource` binding, and the frame
  does not open or attach a dataset.
- Grid double-click and tab entry forward to the existing host stubs. The
  mouse event forwards the complete `TMouseEvent` arguments to the host stub.
- The empty Pascal handlers remain inert. Listings suggest refresh/open,
  BDE database, grid-focus, and global-state behavior, but none was promoted
  into executable code.
- Two focused tests pass; the complete FPCUnit suite passes 422/422. The
  main Debug application and test project build successfully. No genealogy
  database was opened.

## Sprint goal — eighth vertical slice

**Story:** As a maintainer, I want the address tab and its bound editing
controls to belong to a dedicated frame, while the listing-only address
caption, lookup, dataset, and BDE behavior remains inactive.

**Acceptance criteria**

- `TabSheet8` embeds `TAHW52AddressFrame` and no longer owns its 30 controls.
- The address tab preserves its caption, image index, dimensions, and page
  order. The frame preserves the address panel's layout, help context, seven
  data-field bindings, and editable city combo.
- Tab entry and city-combo exit route through typed callbacks to the existing
  host methods with the original sender.
- No listing-only database lookup, dataset edit/append, or BDE operation is
  activated.
- Tests cover frame streaming, control count/layout, all address field
  bindings, nil data sources, and callback wiring/forwarding.

**Completed increment — 2026-10-04**

- Extracted the complete `TabSheet8` subtree into
  `Forms\AHW52AddressFrame.pas/.lfm`. The frame owns `Label78` and `Panel2`
  with its 28 children, for 30 streamed controls total.
- Preserved the tab caption and `ImageIndex=7`, the panel bounds and
  `HelpContext=103`, all seven `DataField` names (`Adr1`, `Adr2`, `PLZ`,
  `Adrzus`, `Tel`, `Ema`, `Ur`), and the `csSimple` city combo style.
- At the resource-migration checkpoint, tab entry and the city-combo exit
  forwarded through typed host callbacks. The later source-ownership slice
  removed the city-exit callback after confirming its host body was inert;
  the frame-local `ComboBox26Exit` remains bound.
- `TabSheet8Enter`'s assembly listing composes an address caption in
  `Label78`; `ComboBox4Exit`'s listing includes dataset edits/lookups and
  opening `ort_`. None of this listing-only behavior was activated; all
  address DB edits remain unbound to any data source.
- Focused tests pass 2/2; the complete FPCUnit suite passes 424/424. The
  main Debug application and test project build successfully. No genealogy
  database was opened.

## Sprint goal — ninth vertical slice

**Story:** As a maintainer, I want the pictures tab's image slots and
selection labels to belong to a dedicated frame, while image-file operations
and tab lifecycle listing behavior remain behind the existing host boundary.

**Acceptance criteria**

- `TabSheet9` embeds `TAHW52PicturesFrame` and no longer owns its 31 controls.
- All 25 images retain their names, order, layout, sizing flags, and click
  binding; all six labels retain their original properties.
- Image click, tab show, and tab exit forward through typed callbacks with
  the original sender.
- Assembly-only picture loading, file operations, and global-state behavior
  are not activated by extraction.
- Tests cover streamed ownership, all image click bindings and dimensions,
  label visibility, lifecycle wiring, and callback sender/action forwarding.

**Completed increment — 2026-10-04**

- Extracted all 25 `TImage` controls and six labels into
  `Forms\AHW52PicturesFrame.pas/.lfm`; `TabSheet9` retains caption `Bilder`,
  `ImageIndex=8`, and page position.
- All images retain their original order and bounds, dimensions
  (`119x129`), `Proportional=True`, `Stretch=True`, and event binding. The
  frame's common `ImageClick` event forwards the clicked image sender.
- Tab show and exit are wired to frame lifecycle methods and forwarded with
  their original sender to the existing host handlers.
- The Pascal event bodies remain inert. Listings that imply reading the
  `bilder\` folder, inspecting/showing image slots, setting captions and
  hints, and clearing pictures on tab exit remain inactive.
- Focused tests pass 2/2; the complete FPCUnit suite passes 426/426. The main
  Debug application and test project build successfully. No genealogy
  database or picture directory was opened.

## Reconstruction boundary

The selection listings suggest BDE key lookup and navigation on grid
activation, database initialization on tab exit, dataset/filter work on tab
show, and an opaque global state read on tab mouse-down. The current Pascal
bodies were empty. The frame extraction therefore forwards events to the
existing host methods but does not implement those listing-only effects.
Revisit each operation only when its dataset/provider contract and state
semantics are verified.

The person-edit extraction is structural, not a database reconstruction. Its
existing Pascal behavior is retained: local grid/focus actions are executable,
shared actions are forwarded to the host, and otherwise-empty handlers remain
empty. Assembly comments still describe the original `TForm1` layout and are
retained as evidence; their offsets are not claims about the new frame's
runtime layout. No BDE or Paradox file was opened by this increment.

The Details tab's empty Pascal handlers remain inert in the frame; historical
listings continue to describe the original binary layout, not the new frame's
offsets. The host's `ComboBox5Change` routine still targets a declared `Edit4`
field that is not streamed by the current LFM; this pre-existing focus target
remains unresolved rather than being guessed or redirected. The `ComboBox1`
keypress listing has no restored Pascal action, so its typed frame event
leaves the key unchanged.

The Relationships tab's listing-only grid click contains a BDE session/index
lookup path, while tab entry and date-exit listings call dataset and date
helpers. Their Pascal bodies remain empty. The combo-exit events now stop in
their frame instead of forwarding to empty host adapters. No BDE/provider or
relationship-write behavior is established by this source-ownership change.

The Siblings tab contains only `Label26` and `StringGrid4`. Its entry listing
builds the sibling caption/grid from datasets, and its grid double-click
listing performs a BDE key lookup before selecting the edit tab. Both Pascal
handlers had empty executable bodies. The two listings were moved to
`ReverseEngineering\AhnWin52-TabSheet5-Siblings.asm.txt`; the frame methods
now own these event entry points without host forwarding. Listing-derived
data access and navigation remain inactive.

The Text tab's `TabSheet6Enter` assembly listing reads several datasets and
composes a caption into `Label21`; its former Pascal adapter had an empty body
and has since been removed with its `OnEnter` assignment. The listing remains
inactive. The memo-exit method is different: its
verified Pascal body calls `speich1(Sender)`, which retains the existing
empty-record deletion and new-person post guards. The frame forwards the
original `DBMemo1` sender to this host method; it does not call datasets or
open files directly. Other assembler-comment references to the old
`TForm1.DBMemo1` offset remain historical evidence and do not establish live
frame behavior.

The hidden related-selection tab contains `Label27` and `DBGrid2`. Its entry
listing accesses datasets, opens the `namgeb` BDE database, assigns a grid
data source, and focuses the grid; the grid double-click and mouse-down
listings also refer to unresolved lookup/global state. Their Pascal handlers
remain empty. The frame forwards events to those host boundaries, preserves
mouse arguments, and does not attach a dataset or activate any listing-only
operation.

The address tab contains `Label78` and a panel with 28 child controls. The
`TabSheet8Enter` listing reads two global data-module values to compose an
address caption; the `ComboBox4Exit` listing is a shared multi-combo handler
with dataset edit/lookup/append paths and an `ort_` BDE open. Their Pascal
bodies remain empty. Tab entry still crosses the host boundary; city-combo
exit now ends in the frame. The seven address DB edits remain unbound and no
dataset is opened.

The pictures tab contains 25 image slots and six labels. The `TabSheet9Show`
listing reads global state and inspects `bilder\` before manipulating the
image visibility/labels; `Image2Click` also branches on the clicked image,
reads image hints and updates selection labels. `TabSheet9Exit` clears all
image pictures. Those handlers had no executable Pascal statements, so the
three legacy ASM listings totaling 7,067 source lines were moved out of
`frmAhnenWinMain.pas`
to `ReverseEngineering\AhnWin52-TabSheet9-Pictures.asm.txt`. The frame owns
the original click/show/exit entry points, which intentionally remain inert;
there is no longer a pictures-to-host callback. No directory read, image
load, label mutation, or picture clearing was activated.

## Source-ownership increment — edit-field exits (2026-10-04)

The `DBEdit12/13/20/21` exit events now end in their owning
`TAHW52PersonEditFrame` and no longer forward through `TForm1`. The four old
host handlers called `wt34` or `wt36`; both helpers had empty executable
Pascal bodies. Their six legacy listings (four event wrappers and two
helpers) are preserved, uncompiled, in
`ReverseEngineering\AhnWin52-TabSheet2-EditFieldExits.asm.txt`. No date
validation or provider-backed behavior has been reconstructed or activated.

The frame test asserts these four exits do not dispatch host actions. The
focused edit-frame suite passes 4/4 and the complete suite passes 422/422;
the main Debug and test projects build. At this checkpoint, before the menu
source split, `frmAhnenWinMain.pas` contained 243 `TForm1` implementations
across 107,278 lines. Tab-enter coordination, the `DBEdit69Change` global-state reset,
navigator persistence, and host-mediated focus remain explicit boundaries.

## Source-ownership increment — Details and Relationships combo exits (2026-10-04)

The Details combo-exit events and the Relationships frame's shared combo
exits no longer dispatch to `TForm1`. Their former targets contained only
commented DeDe listings and no executable Pascal statements. The empty frame
event methods remain bound in the LFM, preserving event ownership without
claiming to restore the old listing behavior. Removed the associated Details
callback enum cases, the Relationships callback type/dispatcher, and the
`TForm1` callback plus `ComboBox20Exit`/`ComboBox11Exit` wrappers. The original
listings (1,379 lines including resource maps and method shells) are preserved,
uncompiled, in
`ReverseEngineering\AhnWin52-Details-Relationships-ComboExits.asm.txt`.

The Details `ComboBox5Change` callback remains because it requests host focus
to the unresolved legacy `Edit4` target. Tests assert that live callback and
verify that the removed combo-exit actions stay frame-bound. No provider,
database, or listing-only behavior was activated. After this increment, the
complete FPCUnit suite passed 421/421 and both projects built.

## Source-ownership increment — Address combo exit (2026-10-04)

The Address frame's `ComboBox26Exit` no longer forwards to `TForm1`. Its old
`ComboBox4Exit` target had an empty executable Pascal body, while the
commented listing implies a shared edit/lookup path and `ort_` BDE access.
Removed the obsolete host method, frame callback property, and callback test;
the streamed `ComboBox26.OnExit` binding remains frame-local. The 1,442-line
method/listing block and resource map are preserved, uncompiled, in
`ReverseEngineering\AhnWin52-Address-ComboExit.asm.txt`. No listing behavior
or dataset access was enabled. The full suite passes 420/420; the main Debug
and test projects build.

## Menu source split (2026-10-04)

The main-form LFM binds 84 menu/popup click handlers to `TForm1` (76 under
the 13 main menus and eight contextual relationship/person actions). Their
existing implementations and any attached listing comments have been moved
verbatim into nine function-area includes under
`Forms\MainMenuActions`: file/record/backup, data exchange, search,
reports/lists, ancestor/descendant, calendar/pictures, data validation,
filter/info, and relationship popups.

All method declarations and LFM-bound names remain unchanged, so existing
event routing is preserved. These files are includes compiled into the same
unit, not new controller units; this is an organizational/source-size split,
not a claim that dependencies or application behavior have been refactored.
The main source fell from 107,278 to 65,204 lines (about 39%); the moved
method implementations total approximately 42,074 source lines. The main
Debug and test projects build, the complete synthetic FPCUnit suite passes
422/422, and no genealogy database was opened. Future controller extraction
can proceed one menu area at a time after dependency tracing.

## Assembly resource inventory (2026-10-04)

Added a resource-map comment immediately before each first-party routine
containing an embedded DeDe assembly listing: 568 routines across 38 Pascal
and include files. The scan includes application units, `Forms`, `Sys`, and
the menu-area includes, and excludes `ThirdParty`.

Each note reports symbolic UI/form controls, database/provider calls,
`GlobalVar_*` references, unresolved `OFFS_*` field offsets, project and
framework calls, and possible strings/file/dialog text. Every note explicitly
marks raw addresses, opaque offsets, or indirect call targets as unresolved;
139 listings contain no symbolized resource labels. This is an inventory of
the historical commented listing, not proof of current runtime dependencies,
and does not translate or activate assembly code.

Use it to prioritize conversion: prefer routines whose dependencies are
named and locally bounded; resolve data-module fields and global-state
semantics before converting routines that touch BDE/provider resources or
unknown offsets. Both Debug and test projects build, and the complete
FPCUnit suite passes 422/422.

## Current execution boundary

All nine tabs (`TabSheet1` through `TabSheet9`) are migrated and validated.
The Details frame owns 71 controls, the relationships frame owns 37, the
siblings frame owns two, and the Text frame owns two including the
`Kommentar`-bound memo. The related-selection frame owns `Label27` and
`DBGrid2` with its nine original columns; the address frame owns 30 controls,
including seven DB edits with their original field bindings. The pictures
frame owns 25 images and six labels. The text memo's verified exit-to-save
path remains connected; pictures click/show/exit events now terminate at the
frame's inactive methods, and their original listing evidence is separate.
Listing-only dataset, database, and picture-file work remains inactive.

The complete FPCUnit suite currently passes 420 tests. The test project and
main Debug application build successfully. No genealogy database or picture
directory was opened. All nine tab resources and controls are in frames, but
source-code ownership is **not** complete: many frame events still forward
to legacy `TForm1` methods through `OnHostAction`. The host unit plus its nine
menu-area includes contain 239 `TForm1` method implementations; the main
`.pas` file itself is down to 63,860 lines (from 107,278 before the menu
split). Shared persistence, navigation, and application actions should stay
behind explicit host/service boundaries; frame-local handlers still need to
move into their frames.

The next phase is a source-level migration: inventory each event's call chain
and dependencies, move tab-local executable Pascal into its owning frame, and
remove superseded host wrappers. Keep menu/application actions, cross-tab
navigation, genuinely shared workflows, and unresolved ASM/database
boundaries in the host or named services. Listing-only behavior remains
inactive; moving code must not be confused with reconstructing assembly.
The handler-by-handler ownership map is maintained in
`AhnWin-MainForm-Handler-Ownership.md`. The Pictures slice is the first
source-migration increment; its 7,067 lines of inert listings are now kept in
`ReverseEngineering\AhnWin52-TabSheet9-Pictures.asm.txt`. Pictures, Siblings,
and the four edit-field exits now terminate in their frames; remaining host
actions are tracked per frame in `AhnWin-MainForm-Handler-Ownership.md`.

## Backlog and sequence

| Work item | Status | Exit criteria |
| --- | --- | --- |
| Inventory selection controls, events, and callers | Done | Resource bindings and direct executable references traced |
| Add selection-frame host boundary | Done | No frame-to-global-form or frame-to-sibling access |
| Migrate the selection tab | Done | Resource and callbacks covered by tests |
| Migrate the person-edit tab | Done | `TabSheet2` controls and directly bound events move together |
| Migrate the Details tab | Done | `TabSheet3` controls, field bindings, and bound events move together |
| Migrate the relationships tab | Done | `TabSheet4` controls and callbacks are frame-owned |
| Migrate the siblings tab | Done | `TabSheet5` grid and tab-entry event are frame-owned |
| Migrate the Text tab | Done | `TabSheet6` memo and save callback are frame-owned |
| Migrate hidden related selection (`TabSheet7`) | Done | Frame owns the original grid/label and event boundaries |
| Migrate the Pictures tab (`TabSheet9`) | Done | Extract image controls, lifecycle events, and their host boundaries |
| Retire the edit-frame prototype | Done | Production successor integrated and preview references updated |
| Update architecture/wiki documentation and validate | Done | All nine frame owners, host boundaries, open reconstruction issues, and successful Debug/test builds recorded; current suite is 422 passing tests |
| Inventory tab handler source ownership | In progress | Map each frame event to its active Pascal body, host adapter, dependencies, and unresolved listing boundary |
| Move tab-local handler implementations into frames | Pending | Move executable local behavior with focused tests; retain only explicit shared/host responsibilities |
| Remove superseded main-form adapters | Pending | Delete obsolete declarations, implementations, and dispatch cases after each verified migration |

## Guardrails for each increment

1. Inventory each tab's LFM/DFM subtree, event signatures, direct callers,
   active Pascal body, listing-only evidence, and data-module dependencies
   before moving controls or handlers.
2. Preserve resource names, field bindings, ordering, and bounds unless a
   measured behavior requires a change.
3. Keep tab-local event logic in the owning frame. Route only host navigation,
   application actions, cross-tab coordination, and shared workflows through
   narrow callbacks; do not use a host callback as a permanent substitute for
   moving a frame-local handler.
4. Keep database/provider behavior in the data module or an explicit service;
   do not make frames depend on a particular database engine.
5. Keep unknown assembly behavior inactive and documented until it is
   supported by a complete listing and testable contract.
6. Run focused tests, the full FPCUnit suite, and the Debug application build
   before starting the next tab.
