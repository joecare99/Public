# AhnWin52 evidence-backed symbol map

**Status:** Evidence-backed identities; no renames authorized  
**Updated:** 2026-10-03

This map records names that are directly supported by streamed form metadata
or declarations in the independent decompilation. It is not a license to infer
names from neighboring object offsets or to rename global variables in bulk.
Keep legacy addresses as aliases until every caller and resource reference is
validated.

| Current identity | Proposed/recovered name | Evidence | Confidence | Legacy alias / limitation |
|---|---|---|---|---|
| `Unit2` form/data-module class | `TDataModule2` | `Source\AhnWin52\Unit2.dfm` root is `DataModule2: TDataModule2`; `Source\Projects_AhnenWin\Unit2.pas` declares `TDataModule2` | High | Preserve streamed instance `DataModule2`; do not rename it to `DataModule1`. |
| Data-module table at object offset `$09C` | `DataModule2.Table9` | `Projects_AhnenWin\Unit2.pas` declares `Table9: TTable` at `$f9C` (hex `$09C`); `Unit2.dfm` streams `Table9: TTable`; `frmAhnenWinMain.pas` accesses offset `$009C` before selecting `namgeb` | High | `$09C` is an object-component offset, not a Paradox row offset. |
| Persistent fields of `Table9` | `Table9Nummer` through `Table9Rufname` | DFM nested field components; independent declaration maps their component offsets `$874` through `$940`; approved `.XGn` header decode supplies ordered secondary-index fields | High | Component offsets alone do not reveal index membership/order; see the approved-fixture header evidence in the Paradox metadata how-to. |
| Main-form unit, class, and streamed instance | `frmAhnenWinMain.TForm1` / `Form1` | `frmAhnenWinMain.pas` declares `unit frmAhnenWinMain`, class `TForm1`, and variable `Form1: TForm1`; matching `frmAhnenWinMain.dfm` root is `Form1: TForm1` | High | Keep unit, class, and instance names distinct. The older `AHNWIN51.dpr` lists a separate `Unit1` entry; do not merge that project-level identity without reconciling the source trees. |
| Person search dialog class/instance | `TPersonSearchForm` / `PersonSearchDialog` | `Forms\PersonSearchForm.dfm` root object names the instance and class; `Button1Click` is its streamed event handler | High | The fixture's `geba` key is `Name;Vornamen;Gebjahr;Gebmonat;Gebtag;Taufjahr;Taufmonat;Tauftag;Nummer`; BDE partial-key and cursor semantics remain unknown. |
| `DataModule2` global references in the independent listing | `gvar_0061EF08` at pointer cell `$0061DC3C` | `Projects_AhnenWin\Unit1.pas` labels `$0061DC3C` as `^gvar_0061EF08:TDataModule2`; callsites dereference it and use component offsets `$5C`, `$9C`, etc. | High for type/reference, medium for role | Keep address alias `$0061DC3C`; do not assume address identity with the separately decompiled `AhnWin52` globals. |
| Person-entry choice form class/instance | `TPersonEntryChoiceForm` / `PersonEntryChoiceDialog` | `Forms\PersonEntryChoiceForm.pas` declares the class and global instance; matching DFM root is `PersonEntryChoiceDialog: TPersonEntryChoiceForm`; `AHNWIN51.dpr` lists this unit/class | High | Do not equate this form with the older `Form4` binary identity without reconciling versions. |
| Gregorian calendar form class/instance | `TGregorianCalendarForm` / `GregorianCalendarForm` | `Forms\GregorianCalendar.pas` declares the class and global instance; matching DFM root uses the same names; `AHNWIN51.dpr` lists the unit/class | High | Source comments identify legacy executable class `TForm6`; retain it only as a legacy alias, not as the current Pascal or streamed name. |
| About form class/instance | `TAboutForm` / `AboutDialog` | `Forms\AboutForm.pas` declares the class and global instance; matching DFM root is `AboutDialog: TAboutForm` | High for the resource/source pair | This establishes the reconstructed resource identity only; no `AHNWIN51.dpr` registration is asserted. |
| BDE login dialog class/instance | `TLoginDialog` / `LoginDialog` | `Sys\DBLogDlg.pas` declares the class and global instance; matching `Sys\DBLogDlg.dfm` root is `LoginDialog: TLoginDialog` | High for the resource/source pair | No project registration or runtime reachability is asserted. |
| BDE password dialog class/instance | `TPasswordDialog` / `PasswordDialog` | `Sys\DBPWDlg.pas` declares the class and global instance; matching `Sys\DBPWDlg.dfm` root uses the same names; `AHNWIN51.dpr` lists the unit/class | High | The identity does not establish when the dialog is invoked or what credentials it accepts. |
| Original password-dialog session field | `TPasswordDialog.FSession: IDBSession` | Version-matched RAD Studio 3.0 `DBPWDlg.pas` declares the private field and delegates all four button handlers through it; `DB.pas` declares `IDBSession` with `AddPassword`, `RemovePassword`, and `RemoveAllPasswords` | High | This identifies the source contract, not the behavior of a particular session implementation or its password store. |
| Original password-dialog state field at `$030C` | `TPasswordDialog.PasswordAdded: Boolean` | RAD Studio 3.0 `DBPWDlg.pas` declares and uses this field in `EditChange` and `AddButtonClick`; the target listing uses the matching byte offset | High | Dialog-local UI state; it is not proof that a password was accepted or persisted by BDE. |
| Reconstructed password-session seam | `AHW52PasswordDialog.TPasswordDialog.FSession: IAHW52PasswordSession` | The reconstructed form declares the injected property and the interface declares the three operations; synthetic tests use a recording fake | High for the code identity | Test boundary only. It is deliberately not `IDBSession`, a BDE adapter, or an implementation of the original binary ABI. |

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
