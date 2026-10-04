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
| `TabSheet1` / `TAHW52PersonSelectionFrame` | grid activation, key-down, tab exit/show/mouse-down | Audit source callers. The BDE-backed listings stay inert; move evidence and remove no-op host adapters where no active host action is required. |
| `TabSheet2` / `TAHW52PersonEditFrame` | tab enter, global-state change, navigator pre-action, focus request | Four field exits (`DBEdit12/13/20/21`) now terminate as frame-local no-ops. Their old host wrappers called `wt34`/`wt36`, which had no executable Pascal body; all six ASM listings are preserved in `ReverseEngineering\AhnWin52-TabSheet2-EditFieldExits.asm.txt`. Keep tab-entry coordination, shared save, global-state change, and host focus explicit. |
| `TabSheet3` / `TAHW52PersonDetailsFrame` | tab enter/exit, several DBEdit exits, combo change/key/exit | `ComboBox5Change` still requests the unresolved `Edit4` host focus target. Combo-exit handlers now terminate locally; their former host calls reached only empty Pascal wrappers. |
| `TabSheet4` / `TAHW52RelationshipsFrame` | tab enter/exit, grid click, DBEdit exits, DBComboBox exit, combo exits | All handlers terminate in the frame. The old combo-exit host dispatcher and two empty `TForm1` wrappers are removed; their historical listings remain inactive in `ReverseEngineering\AhnWin52-Details-Relationships-ComboExits.asm.txt`. |
| `TabSheet5` / `TAHW52SiblingsFrame` | none; enter and grid double-click terminate in the frame | **Source migration complete.** Removed both no-op host handlers and the dispatcher; preserved 1,551 lines of inactive listing evidence in `ReverseEngineering\AhnWin52-TabSheet5-Siblings.asm.txt`. BDE lookup/navigation remains deferred. |
| `TabSheet6` / `TAHW52PersonTextFrame` | tab enter, memo exit | Memo exit saves through the shared person-persistence workflow; remove the redundant event wrapper when direct callback wiring is validated. |
| `TabSheet7` / `TAHW52RelatedPersonSelectionFrame` | tab enter, grid double-click, tab mouse-down | Audit for cross-tab navigation and global selection state; preserve those as explicit host actions. |
| `TabSheet8` / `TAHW52AddressFrame` | tab enter | City-combo exit now terminates in the frame. The old empty host wrapper was removed and its inactive listing was archived; address DB/BDE behavior remains unresolved. |
| `TabSheet9` / `TAHW52PicturesFrame` | none; click/show/exit terminate in the frame | **First source migration complete.** Removed the pictures host dispatcher and three `TForm1` methods. Preserved their 7,067 source lines of listing evidence in `ReverseEngineering\AhnWin52-TabSheet9-Pictures.asm.txt`; frame handlers remain inert. |

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
handlers. `ComboBox5Change` remains because it requests an unresolved host
focus target. The two Details/Relationships listings are preserved, uncompiled, in
`ReverseEngineering\AhnWin52-Details-Relationships-ComboExits.asm.txt` and
the Address listing in `ReverseEngineering\AhnWin52-Address-ComboExit.asm.txt`.
The complete suite passes 420/420, and the main Debug and test projects build.

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
