# AhnWin52 evidence-backed symbol map

**Status:** Evidence-backed identities; 11 no-listing units reorganized and renamed on 2026-10-03  
**Updated:** 2026-10-04

This map records names that are directly supported by streamed form metadata
or declarations in the independent decompilation. It is not a license to infer
names from neighboring object offsets or to rename global variables in bulk.
Keep legacy addresses as aliases until every caller and resource reference is
validated.

| Current identity | Proposed/recovered name | Evidence | Confidence | Legacy alias / limitation |
|---|---|---|---|---|
| `GenealogyDataModule` unit/class | `TGenealogyDataModule` | `Source\AhnWin52\DataModules\GenealogyDataModule.pas` declares the class; the moved DFM/LFM roots retain instance `DataModule2` and use the new class name; `frmAhnenWinMain.pas` listing at `005D5125` creates the binary class formerly named `TDataModule2` | High | The assembly comment records the binary-era class and its current Pascal mapping; the streamed instance remains `DataModule2`. |
| Data-module table at object offset `$09C` | `DataModule2.Table9` | `Projects_AhnenWin\Unit2.pas` declares `Table9: TTable` at `$f9C` (hex `$09C`); `Unit2.dfm` streams `Table9: TTable`; `frmAhnenWinMain.pas` accesses offset `$009C` before selecting `namgeb` | High | `$09C` is an object-component offset, not a Paradox row offset. |
| Persistent fields of `Table9` | `Table9Nummer` through `Table9Rufname` | DFM nested field components; independent declaration maps their component offsets `$874` through `$940`; approved `.XGn` header decode supplies ordered secondary-index fields | High | Component offsets alone do not reveal index membership/order; see the approved-fixture header evidence in the Paradox metadata how-to. |
| Main-form unit, class, and streamed instance | `frmAhnenWinMain.TForm1` / `Form1` | `frmAhnenWinMain.pas` declares `unit frmAhnenWinMain`, class `TForm1`, and variable `Form1: TForm1`; matching `frmAhnenWinMain.dfm` root is `Form1: TForm1` | High | Keep unit, class, and instance names distinct. The older `AHNWIN51.dpr` lists a separate `Unit1` entry; do not merge that project-level identity without reconciling the source trees. |
| Person search dialog class/instance | `TPersonSearchForm` / `PersonSearchDialog` | `Forms\PersonSearchForm.dfm` root object names the instance and class; `Button1Click` is its streamed event handler | High | The fixture's `geba` key is `Name;Vornamen;Gebjahr;Gebmonat;Gebtag;Taufjahr;Taufmonat;Tauftag;Nummer`; BDE partial-key and cursor semantics remain unknown. |
| Main-form selection tab contents | `frmAhnenWinMain.TForm1.PersonSelectionFrame: TAHW52PersonSelectionFrame` | `frmAhnenWinMain.lfm` embeds the production selection frame under `TabSheet1`; the frame LFM retains the original `DBGrid1` resource; FPCUnit streaming tests exercise it | High for streamed ownership | The main form retains the tab shell; assembly listings describe the original `TForm1` control offsets. |
| Main-form edit tab contents | `frmAhnenWinMain.TForm1.PersonEditFrame: TAHW52PersonEditFrame` | `frmAhnenWinMain.lfm` embeds the production edit frame under `TabSheet2`; its LFM retains 70 controls and 43 control-event bindings | High for streamed ownership | Host callbacks retain refresh/persistence/global-state boundaries; old assembly offsets are not offsets of the frame instance. |
| Main-form details tab contents | `frmAhnenWinMain.TForm1.PersonDetailsFrame: TAHW52PersonDetailsFrame` | `frmAhnenWinMain.lfm` embeds the production details frame under `TabSheet3`; its LFM retains 71 controls and their field/event bindings; FPCUnit tests assert streamed ownership | High for streamed ownership | Listing-only handlers remain host callbacks; the old `ComboBox5Change` target `TForm1.Edit4` is declared but not streamed in the current LFM. |
| Main-form relationships tab contents | `frmAhnenWinMain.TForm1.RelationshipsFrame: TAHW52RelationshipsFrame` | `frmAhnenWinMain.lfm` embeds the production frame under `TabSheet4`; its LFM retains all 37 controls and 11 control-event bindings; FPCUnit tests assert streamed ownership | High for streamed ownership | Unresolved BDE lookup and date-validation listings remain inert host callbacks; combo-exit adapters are shared with the Details frame. |
| Main-form siblings tab contents | `frmAhnenWinMain.TForm1.SiblingsFrame: TAHW52SiblingsFrame` | `frmAhnenWinMain.lfm` embeds the production frame under `TabSheet5`; its LFM retains `Label26` and `StringGrid4`, the original grid geometry/columns, and double-click binding; FPCUnit tests assert streamed ownership | High for streamed ownership | Tab entry and grid activation remain inert host actions; assembly-only dataset lookup and edit-tab navigation are not restored. |
| Main-form text tab contents | `frmAhnenWinMain.TForm1.PersonTextFrame: TAHW52PersonTextFrame` | `frmAhnenWinMain.lfm` embeds the production frame under `TabSheet6`; its LFM retains `Label21`, `DBMemo1`, the `Kommentar` binding, and memo-exit event; FPCUnit tests assert streamed ownership | High for streamed ownership | Memo exit preserves `DBMemo1Exit(Sender) -> speich1(Sender)`; tab-entry dataset/caption listing remains inactive. |
| Main-form hidden related-selection tab contents | `frmAhnenWinMain.TForm1.RelatedPersonSelectionFrame: TAHW52RelatedPersonSelectionFrame` | `frmAhnenWinMain.lfm` embeds the production frame under hidden `TabSheet7`; its LFM retains `Label27`, `DBGrid2`, all nine original field columns, and the double-click binding; FPCUnit tests assert hidden state, streamed ownership, geometry, and event forwarding | High for streamed ownership | Tab entry and grid activation remain inert host actions; the listing-only dataset refresh, `namgeb` BDE open, grid focus, and global-state behavior are not restored. Mouse event arguments are forwarded to the host boundary. |
| Main-form address tab contents | `frmAhnenWinMain.TForm1.AddressFrame: TAHW52AddressFrame` | `frmAhnenWinMain.lfm` embeds the production frame under `TabSheet8`; its LFM retains `Label78`, `Panel2`, the panel's 28 controls, seven DBEdit field names, and the `ComboBox26` exit event; FPCUnit tests assert all 30 streamed controls, bindings, tab metadata, and host wiring | High for streamed ownership | Tab entry and city-combo exit remain inert host actions; address caption composition, shared dataset edit/lookup, and `ort_` BDE open from retained listings are not restored. |
| Main-form pictures tab contents | `frmAhnenWinMain.TForm1.PicturesFrame: TAHW52PicturesFrame` | `frmAhnenWinMain.lfm` embeds the production frame under `TabSheet9`; its LFM retains 25 original `TImage` controls and six labels, sizing/layout, image-click binding, and lifecycle wiring; FPCUnit tests assert streamed ownership, all click bindings, bounds, label visibility, and callbacks | High for streamed ownership | Image click/show/exit remain inert host actions; `bilder\` directory reading, image loading, selection-label mutation, and picture clearing from retained listings are not restored. |
| `DataModule2` global references in the independent listing | `gvar_0061EF08` at pointer cell `$0061DC3C` | `Projects_AhnenWin\Unit1.pas` labels `$0061DC3C` as `^gvar_0061EF08:TDataModule2`; callsites dereference it and use component offsets `$5C`, `$9C`, etc. | High for type/reference, medium for role | Keep address alias `$0061DC3C`; do not assume address identity with the separately decompiled `AhnWin52` globals. |
| Person-entry choice form class/instance | `TPersonEntryChoiceForm` / `PersonEntryChoiceDialog` | `Forms\PersonEntryChoiceForm.pas` declares the class and global instance; matching DFM root is `PersonEntryChoiceDialog: TPersonEntryChoiceForm`; `AHNWIN51.dpr` lists this unit/class | High | Do not equate this form with the older `Form4` binary identity without reconciling versions. |
| Gregorian calendar form class/instance | `TGregorianCalendarForm` / `GregorianCalendarForm` | `Forms\GregorianCalendar.pas` declares the class and global instance; matching DFM root uses the same names; `AHNWIN51.dpr` lists the unit/class | High | Source comments identify legacy executable class `TForm6`; retain it only as a legacy alias, not as the current Pascal or streamed name. |
| About form class/instance | `TAboutForm` / `AboutDialog` | `Forms\AboutForm.pas` declares the class and global instance; matching DFM root is `AboutDialog: TAboutForm` | High for the resource/source pair | This establishes the reconstructed resource identity only; no `AHNWIN51.dpr` registration is asserted. |
| BDE login dialog class/instance | `TLoginDialog` / `LoginDialog` | `Sys\DBLogDlg.pas` declares the class and global instance; matching `Sys\DBLogDlg.dfm` root is `LoginDialog: TLoginDialog` | High for the resource/source pair | No project registration or runtime reachability is asserted. |
| BDE password dialog class/instance | `TPasswordDialog` / `PasswordDialog` | `Sys\DBPWDlg.pas` declares the class and global instance; matching `Sys\DBPWDlg.dfm` root uses the same names; `AHNWIN51.dpr` lists the unit/class | High | The identity does not establish when the dialog is invoked or what credentials it accepts. |
| Original password-dialog session field | `TPasswordDialog.FSession: IDBSession` | Version-matched RAD Studio 3.0 `DBPWDlg.pas` declares the private field and delegates all four button handlers through it; `DB.pas` declares `IDBSession` with `AddPassword`, `RemovePassword`, and `RemoveAllPasswords` | High | This identifies the source contract, not the behavior of a particular session implementation or its password store. |
| Original password-dialog state field at `$030C` | `TPasswordDialog.PasswordAdded: Boolean` | RAD Studio 3.0 `DBPWDlg.pas` declares and uses this field in `EditChange` and `AddButtonClick`; the target listing uses the matching byte offset | High | Dialog-local UI state; it is not proof that a password was accepted or persisted by BDE. |
| Reconstructed password-session seam | `AHW52PasswordDialog.TPasswordDialog.FSession: IAHW52PasswordSession` | The reconstructed form declares the injected property and the interface declares the three operations; synthetic tests use a recording fake | High for the code identity | Test boundary only. It is deliberately not `IDBSession`, a BDE adapter, or an implementation of the original binary ABI. |
| Fixture-backed `Table9` index metadata | `Table9IndexDefinitions.TTable9IndexDefinition` | Read-only parse of approved `AWD.XG0`–`AWD.XG7` headers in two verified snapshots; field names/order correlate with `Unit2.dfm` | High for those fixture snapshots | Static fixture metadata, not runtime discovery; a lapParadox/pxlib provider must validate the actual opened table/index files. |
| Person-search lookup request builder | `PersonSearchLookupRequest.BuildPersonSearchLookupRequest` | `Button1Click` listing selects `geba` and passes `Edit1` then `Edit2` at `00583F0C`–`00583F6E`; `.XG3` begins `Name; Vornamen` | High for index identity and key order | Covers only the name-search request; numeric lookup gate and full DFM event handler remain unreconstructed. |
| Replacement lookup boundary | `IndexedLookupContract.IIndexedLookupProvider` | Typed request carries an index name and ordered key prefix; result is not-found, single candidate, or candidate list | High for the approved replacement API | Provider-neutral application contract; intentionally does not model BDE cursor, FindKey, or miss semantics. |
| French Republican calendar class reference in `TForm1.FrzRevolutionskalender1Click` | `TFrenchRepublicanCalendarForm` | Retained listing at `005EEBFE` passes the binary class pointer formerly labeled `TForm7`; the moved Pascal class and DFM/LFM roots use `TFrenchRepublicanCalendarForm` | High for the binary-reference-to-current-source mapping | The assembly annotation now states both names. The original binary class name is preserved as historical evidence; global streamed instance `Form7` is unchanged. |
| Unit13 font-name state cell | `Unit13.GlobalVar_0061E2EC: string` | `SpeedButton12Click` listing `00570694` stores `FontDialog1.Font.Name` at `$0061E2EC`; `zerleg` listing `005675D8` passes the same cell to `TFont.SetName` | High for string type and read/write role | Address is a binary-era identity label only; the rebuilt source maps it to a managed unit-level string, not a hard-coded process address. The new private `StoreFontNameState` helper centralizes writes. |
| Unit13 `FormShow` state cell | `Unit13.GlobalVar_02535388: Integer` | Listing `00570294` writes zero to `$02535388` at the start of `TForm13.FormShow`; the Pascal declaration preserves the integer cell | High for type and initial assignment | Its broader role and later readers remain unknown; document only the proven reset, not a guessed semantic name. |
| Unit13 `FormShow` datasets and field access | `DataModule2.Table17`, `DataModule2.Table18`, `DataModule2.Table1Nummer.AsInteger` | Listing `00570294` opens offsets `$013C`/`$0140` and then calls through `$0534`; data-module field order, anchored by `Table9` at `$009C`, maps these to the named datasets/field. The sibling `Projects_AhnenWin\DB.pas` annotates VMT slot `$58` as `TField.GetAsInteger`; the restored property read has a synthetic recording-field test. | High for component identities/open order; medium-high for VMT interpretation because it is sibling corroboration | The sibling source corroborates the VMT slot but is not merged into AhnWin52. The BDE `TSession.OpenDatabase` call is intentionally omitted from the form; provider initialization remains unimplemented pending the `Cmp_SQLTable` contract. |
| Unit13 `FormShow` setup state | `GlobalVar_0061E2F4`, `GlobalVar_0061E2F8`, `GlobalVar_0061E11C`, `GlobalVar_0061E120`, `GlobalVar_011AD338`, `GlobalVar_011AD334` | Listing `00570294` assigns the first two cells to zero, sets scale `0.63`, rounds scale-derived values using `6` and `120`, and stores `20`; the translated synthetic tests assert the resulting values `4` and `76`. | High for the assignments and arithmetic | The address labels are preserved; names do not imply broader domain meanings. Chart drawing remains unsupported and explicitly guarded. |

## Reorganized no-listing units — 2026-10-03

The first-party listing scan found no recognized assembly methods in these
eleven units. That scanner result does not prove that every method has been
fully reconstructed. Each Pascal unit and its existing DFM/LFM resources were
moved with `svn move`; Pascal declarations and resource class roots were
renamed together. Streamed global instance names remain unchanged.

| Legacy unit | Current unit / class | Folder | Streamed instance |
|---|---|---|---|
| `Unit2` | `GenealogyDataModule` / `TGenealogyDataModule` | `DataModules` | `DataModule2` |
| `Unit5` | `SingleColumnA4ReportForm` / `TSingleColumnA4ReportForm` | `Reports` | `Form5` |
| `Unit15` | `SingleColumnA4ReportVariantForm` / `TSingleColumnA4ReportVariantForm` | `Reports` | `Form15` |
| `Unit7` | `FrenchRepublicanCalendarForm` / `TFrenchRepublicanCalendarForm` | `Forms` | `Form7` |
| `Unit12` | `AncestorChartOptionsForm` / `TAncestorChartOptionsForm` | `Forms` | `Form12` |
| `Unit23` | `FokoFilePrintForm` / `TFokoFilePrintForm` | `Reports` | `Form23` |
| `Unit24` | `OrtsfamilienbuchOptionsForm` / `TOrtsfamilienbuchOptionsForm` | `Forms` | `Form24` |
| `Unit25` | `TwoColumnA4ReportForm` / `TTwoColumnA4ReportForm` | `Reports` | `Form25` |
| `Unit31` | `GenealogyListOptionsForm` / `TGenealogyListOptionsForm` | `Forms` | `Form31` |
| `Unit35` | `PersonComparisonOptionsForm` / `TPersonComparisonOptionsForm` | `Forms` | `Form35` |
| `Unit38` | `FokoAbbreviationsForm` / `TFokoAbbreviationsForm` | `Forms` | `Form38` |

The report names describe the layouts visible in their resources; they do not
assert a more specific business purpose. The application and FPC project
files now refer to the moved units.

## Naming rules for future entries

- Add a semantic name only when a DFM/LFM, declaration, project startup
  creation, or consistent direct callsite establishes identity.
- Record confidence and source locations for every entry. Preserve both the
  raw address and current decompiler name where available.
- Distinguish a unit name, class name, streamed component name, and global
  instance name; they need not be identical.
- Do not infer index fields from `.XGn` filenames. Use the decoded header field
  list, correlate it with the `Table9` DFM, and keep BDE lookup behavior
  separate from static index metadata.
- Treat a DFM/Pascal identity pair as proof of resource/source naming only.
  Require a DPR entry or direct creation/call evidence before claiming project
  registration or runtime reachability.
