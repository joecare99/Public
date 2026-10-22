# AHNENWIN 5.1 — Delphi reconstruction from the IDR disassembly

This directory contains a from-scratch **Delphi** reconstruction of the
German genealogy program *AHNENWIN 5.1*, built exclusively from the IDR
(Interactive Delphi Reconstructor) disassembly in
`Source\Projects_AhnenWin\`.

The reconstruction targets **Delphi 9 (RAD Studio 3.0)** with **BDE 5.2**,
because that is the only installed combination that provides the BDE
(`DBTables`) that the original program uses.

```
Delphi_Ahnenwin\
  AHNWIN51.dpr              the project file
  build.cmd                 dcc32 wrapper (Delphi 9, BDE 5.2)
  Units\                    Unit1 .. Unit40, Unit2 (data module), AHNGlobals
  Forms\                    the original DFM resources
  Compat\QuickReport\       QuickReport compatibility layer
  Compat\WPPDF\             WPPDFDelphi compatibility layer
  tools\                    the reconstruction tool chain
  docs\                     cross reference and reconstruction evidence
  build\                    compiler output
```

## Build

```cmd
build.cmd                    full rebuild
build.cmd -unit 15           compile one unit
build.cmd -clean             remove the build output
```

The build uses
`C:\copy\delphi\RAD Studio\3.0\Bin\DCC32.EXE` and the unit search path
`Units; Forms; Compat\QuickReport; Compat\WPPDF; build; <Delphi lib>`.

`build.cmd` writes `build\AHNWIN51.ini` after a successful build:

```ini
[Daten]
Verzeichnis=C:\ProgramData\AHNENWIN Test
```

The directory can be changed with the environment variable
`AHNENWIN_DATEN`.

## The directory of the data

The program works with relative paths — the BDE alias, the picture
directory `Bilder`, `par.cfg`, `style.css` — so the data has to be found
at run time. The original program expects the program file to lie in the
directory of the data; the reconstruction looks for the data in this
order:

1. the parameter of the program: `AHNWIN51.exe <Verzeichnis>`
2. `AHNWIN51.ini` next to the program file (`[Daten] Verzeichnis=…`)
3. the directory of the program file, if it holds `AWD.DB`
4. the current directory, if it holds `AWD.DB`
5. the directory of the program file

The current directory is then set to the directory that was found, and
the BDE alias, the net file `PDOXUSRS.NET` and the pictures are taken
from it. If the database is not found, the program names the directory it
searched instead of the bare BDE message.

`Units\AHNStart.pas` holds that logic; the program file and all the
test programs use it, so that they behave the same.

Three details of the BDE and of the VCL of Delphi 9 have to be taken
into account:

* Without a configuration file the BDE puts its net file into the root
  of the drive, where a normal user may not write
  ("Fehler beim Initialisieren des Netzwerkes / Zugriff verweigert").
  `Session.NetFileDir` is therefore set explicitly to the directory of
  the data.
* `GetCurrentDir` returns the directory **without** a trailing
  backslash, so every path that is built from it has to be closed with
  `IncludeTrailingPathDelimiter`. Without it, `par.cfg` was looked for
  as `C:\ProgramData\AHNENWIN Testpar.cfg` — a file in `C:\ProgramData`.
* The resources of the forms refer to the data module by name
  (`DataSource = DataModule2.DataSource1`). The reader of the resources
  resolves such a reference while the form is streamed. That works, but
  the splash screen has to exist by then: `TForm1.FormCreate` closes it
  with `Form8.Close`, and `TCustomForm.Close` reads the field
  `FFormState` of the splash screen — with a nil splash screen that is
  an access violation ("Zugriffsverletzung – Lesen von Adresse
  00000328"). The program file shows the splash screen first, and the
  test programs do the same; `TForm1.FormCreate` checks the splash
  screen as well, so that the main form can be created on its own.

## The order of the start

The order in which the forms are created is the order of the original
program (`Source\Projects_AhnenWin\AHNWIN51.dpr`):

```
Form8 (splash)  ->  DataModule2  ->  Form1  ->  Form3  ->  Form4  ->  ...
```

The data module is created before the forms — the original creates it
inside `TForm1.FormCreate`, but the resources of the forms refer to it,
and `TForm1.FormCreate` therefore only creates it when it does not
exist yet. The original's `FormCreate` reads its own caption through
the global variable `Form1`, which only exists after the form has been
created; `TApplication.CreateForm` sets it before the constructor runs,
which is why the test programs have to use `Application.CreateForm` and
not `Create`.

## Verification

```cmd
tools\streamcheck.cmd        load every form from its DFM and report
tools\formtest.cmd          build and run the smoke test
```

`StreamCheck` instantiates all 40 forms and the data module from their
original resources and reports the number of components each one streamed.
It is the acceptance test for the resource half of the reconstruction: a unit
is structurally correct only when its DFM round-trips through the VCL
streaming mechanism.

Current state: **40 / 40 forms stream, 0 failures.**

`FormTest` creates the data module and the main form and reports the state
of the table of the persons. It has to be started in the directory of the
data (the program looks for its tables there); `formtest.cmd` does that.
Current state: **439 components, caption `AHNENWIN 5.1`, `AWD.DB` active,
6 records.**

The behaviour of the program is compared with the original: both are
started and their window trees (class, text and visibility of every
child window) are compared. Current state: **identical, 121 controls.**

## The tool chain

| Tool | Purpose |
|---|---|
| `tools\gen-unit.ps1` | builds the class shell of a unit from the IDR output: the component list with the original component offsets, and the method declarations |
| `tools\gen-bodies.ps1` | adds a placeholder body for every method that has none yet |
| `tools\get-listing.ps1` | prints the IDR assembly listing of one method, without the `{* … *}` wrapper |
| `tools\globals.ps1` | inventory of the application-wide global variables |
| `tools\gen-globals.ps1` | writes `Units\AHNGlobals.pas` from that inventory |
| `tools\patch-dfm.ps1` | applies the documented deviations between the original resources and the copies used here (see below) |
| `tools\crossref.ps1` | regenerates `docs\CrossReference.md` — the method inventory with the reconstruction state |
| `tools\StreamCheck.dpr` | the resource verification program |
| `tools\formtest.cmd` | builds and runs the smoke test (`tools\FormTest.dpr`) in the directory of the data |
| `tools\disasm.py` | disassembles a method of the original binary, with the symbols of the IDR output as comments |
| `tools\checkevents.py` | compares the event bindings of the resources with the published methods |
| `tools\checkimpl.py` | compares the published declarations with the implementations |
| `tools\checkempty.py` | compares the methods that are marked as empty with their listing in the IDR output |
| `tools\fixsig.py` | gives the published declaration and the implementation of a method the same parameters |

`gen-unit.ps1` and `gen-bodies.ps1` never overwrite an existing unit: once
the method bodies have been reconstructed, the unit file is the primary
source of truth.

### The signatures of the methods

The generator wrote the published declarations with invented parameters
for the methods whose signature IDR could not resolve, and left the
parameters out in the implementations. The compiler only notices that
when it compiles the unit — a cached DCU hides the error, and the
project therefore only built because of the cache.

`build.cmd` deletes the cached units before every build, so that the
error is always visible. `tools\fixsig.py` gives the published
declaration and the implementation of a method the same parameters: the
parameters of the event if the method is bound to one in a resource, the
parameters of the implementation otherwise.

## How a method is reconstructed

1. **Read the listing.** `tools\get-listing.ps1 -Unit 27 -Method SpeedButton1Click`

2. **Resolve the component accesses.** IDR annotates them:
   `mov eax,dword ptr [ebx+32C];TOKBottomDlg1.RadioButton2:TRadioButton`
   — offset `$32C` — the `//32C` marker in the unit declaration — the
   component `RadioButton2`.

3. **Resolve the calls.**
   * `call TCustomForm.Close` — a direct call, the name is given.
   * `call dword ptr [ecx+0C8];TRadioButton.SetChecked` — a virtual call
     through the VMT slot `$C8`; IDR names the target when it can resolve
     it, and the decompiled VCL units (`Projects_AhnenWin\StdCtrls.pas`,
     `Forms.pas`, …) give the slot-to-method mapping.
   * `call @LStrCat3` — a compiler intrinsic; the argument order is
     `eax` = destination, `edx` = first string, `ecx` = second string.
   * `call 005D3A70` — a call to another method of the same unit; the
     address is looked up in the address register of the unit.

4. **Recognise the compiler artefacts.**
   * `push ebp / mov ebp,esp / add esp,-XX` — the stack frame of the
     method, `XX` is the size of the local variables.
   * `push ebp / push <addr> / push fs:[eax] / mov fs:[eax],esp` — a
     `try..finally` or `try..except`. In most methods of this program it
     is **not** a source-level `try`, but the compiler's automatic cleanup
     of the managed string locals (the handler calls `@LStrArrayClr`).
   * `ret N` — `N` is the number of stack bytes of the parameters.
   * `mov dl,1 / call dword ptr [ecx+0C8];SetChecked` — `Checked := True`.
   * `mov dx,0FFF5 / call TScreen.SetCursor` — `$FFF5` is `-11`, which is
     `crHourGlass` (Controls.pas: `crHourGlass = TCursor(-11)`).

5. **Write the Delphi code**, with a comment that names the original
   address and states what the listing does, plus a note wherever the
   listing does not allow a unique interpretation.

6. **Update the cross reference** (`tools\crossref.ps1`) and **build**.

## Structural decisions

### Names

`UnitN` stays the unit name, `TFormN` the class name and `FormN` the
global instance — exactly as in the original. The unit name must *not* be
the same as the global instance name: Delphi reports `E2004` for that
(`Form4` as a unit name and as a variable).

### The global variables

The IDR output names the application-wide globals `gvar_<ADDRESS>` but does
not contain their declarations. They are collected in `Units\AHNGlobals.pas`,
under exactly the same names, so that every reference stays traceable to
the disassembly. The **form instances are not in that unit** — they belong
to the unit that declares the class, because `Application.CreateForm` needs
them by reference.

### Unit cycles

The original program has real cycles between its units (`Unit1` calls
`TForm3.ofb2`, `Unit3` calls `TForm1.anzeigen`, and so on). Delphi 9
accepts them as long as the references are in the **implementation**
section, which is where the reconstruction puts them. Both directions of
`A.implementation uses B` / `B.implementation uses A` were verified
empirically with `dcc32` 17.0.

### The data module

`Unit2` is the data module with all 700 components (38 tables, 292
persistent fields, 39 datasets). The declaration was taken 1:1 from
`DataModule2.dfm` and cross-checked against the component offsets that IDR
recovered — a 1:1 match, no component on either side without a counterpart,
and no two components sharing an offset. The declaration is sorted by
offset, because that is the true memory layout; the DFM lists the
components in the streaming order.

## The compatibility layers

`Compat\QuickReport` and `Compat\WPPDF` replace two third-party libraries
that are not available in this environment:

* **QuickReport 3.x** — `C:\copy\delphi\RAD Studio\3.0\lib` contains
  `QuickRpt.dcu`, but neither the DCUs nor the sources of `QRCtrls`,
  `QRExpr` and `QRPrntr` exist, and the IDR decompilation of those units
  is too damaged to be used as a source (`QRExpr` alone has 191 unresolved
  method signatures). The compatibility layer therefore reproduces the
  public surface that the AHNENWIN resources and the reconstructed units
  actually use. Where the original streams a value in a non-standard way,
  the mechanism of the original was reproduced: the original QuickReport
  registers the page values through
  `Filer.DefineProperty('Values', ReadValues, WriteValues, True)`
  (`TQRPage.ReadValues` at `$0051572C` in the decompilation), and so does
  the compatibility layer — Delphi 9 rejects a published array property.
* **WPPDFDelphi 5.0** — likewise unavailable; the compatibility layer
  reproduces the type surface that `Forms/Form13.dfm` and
  `Forms/Form16.dfm` stream.

Neither layer renders or prints anything. Every report that the
reconstruction actually produces goes through the plain-text / HTML export
of `Unit16.Speichernunter1Click`.

> `Source\Projects_AhnenWin\Unit16.Speichernunter1Click.pas` already holds a
> hand-translated version of that export routine. It is part of the source
> folder and was used as a cross-check when the method was reconstructed
> from the listing.

## Known deviations from the original resources

`tools\patch-dfm.ps1` applies exactly one deviation, and it is idempotent:

**`Forms/Form1.dfm`, the two runtime helper datasets `lfbh2` and `Repso2`**
(`TClientDataSet`) carry `Active = True` in the original and have their
field components nested inside them. Delphi 9 cannot stream that
combination: `TClientDataSet` keeps its records in a `Variant` with a safe
array, and assigning the field definitions to an already active dataset
tries to rebuild that `Variant` while it is locked:

```
ESafeArrayLockedError: Variante oder sicheres Array ist gesperrt
```

The original program activates both datasets explicitly in its code (they
load `lfbh2.xml` and `repso2.xml` at run time), so the design-time
`Active = True` is a leftover of the resource editor. Setting it to `False`
restores the original run-time behaviour and lets the resource stream.

Everything else in `Forms\` is byte-identical to
`Source\Projects_AhnenWin\`.

## What is still open

`docs\CrossReference.md` lists every method of the original program with
its address in the AHNENWIN 5.1 binary and its reconstruction state.
Current state: **324 of the 615 methods are reconstructed.**

The order of the work follows the dependency edges that the same file records:
the units with the fewest dependencies first, so that every method can be
checked against methods that are already reconstructed.

### Wave 0 - the leaf units (done)

| Unit | Methods | Reconstructed | Still open |
|---|---|---|---|
| Unit4  | 5  | 5  | - |
| Unit6  | 13 | 12 | `Kal` (the calendar computation) |
| Unit7  | 8  | 7  | `berechnen` (the Republican calendar conversion) |
| Unit9  | 7  | 6  | - |
| Unit10 | 13 | 11 | `Browser`, `rechnen` (the Easter calculation) |
| Unit11 | 8  | 6  | `Fgr`, `zeichnen` (the family chart) |
| Unit12 | 5  | 5  | - |
| Unit27 | 3  | 3  | - |
| Unit31 | 4  | 4  | - |
| Unit34 | 3  | 3  | - |
| Unit35 | 4  | 4  | - |
| Unit37 | 2  | 2  | - |
| Unit38 | 1  | 1  | - |
| Unit40 | 3  | 3  | - |

The six methods that are still open are the algorithmic core of their
units: the Gregorian calendar computation, the French Republican calendar
conversion, the Easter calculation, the family chart drawing, and the
browser page generator. They are the largest listings of the program
(`Fgr` alone is 4322 lines of assembly) and they are the natural next
step after the wave 1 units.

### Wave 1b - the list dialogs (partly done)

The five dialogs that manage the lists of the program (the places, the
names, the sources, the occupations and the estates) follow the same
pattern: a list box is filled from a table of the data module, the
marked entry is remembered in a global variable, and a double click
hands the entry over to the dialog of the list. The methods of the
lists are done:

| Unit | Dialog | Methods | Reconstructed |
|---|---|---|---|
| Unit14 | the places | 7 | 6 (`Button1Click` is open) |
| Unit28 | the names | 7 | 6 (`Button1Click` is open) |
| Unit29 | the sources | 6 | 5 (`Button2Click` is open) |
| Unit36 | the occupations | 6 | 5 (`Button1Click` is open) |
| Unit39 | the estates | 6 | 5 (`Button1Click` is open) |

The original uses `SetActiveControl` to give the focus to the list box;
that method is private in Delphi 9, so the reconstruction uses
`SetFocus`.

### Wave 1 - the main form (partly done)

`Unit1` is the largest unit of the program (276 methods). The methods
that decide what the program shows when it starts are done:

| Method | Address | What it does |
|---|---|---|
| `TForm1.FormCreate` | `005D4E28` | screen sizes, the BDE alias and the table password, the scaling of the grids, `par.cfg` |
| `TForm1.FormShow` | `005D92AC` | the scaling factor 1.9, the page that is shown first, the tables of the places, of the titles and of the notes |
| `TForm1.anzeigen` | `005D42BC` | the data of the selected person, the picture `bilder\b<Nummer><a-z>.jpg`, the age at the wedding |
| `TForm1.altersberechnung` | `005D3A70` (local) | the age of a person at the date of the wedding |
| `TForm1.gridanp` | `005D3EF8` | the widths of the columns of the five grids |
| `TForm1.alineu` | `005E1DF8` | puts the directory of the data into the database name of all 35 tables |
| `TForm1.eltanz` | `005D76D0` | shows the parents of the person in `Edit1` and `Edit2` |
| `TForm1.ehenanz` | `005D6604` | the connections of the person in `StringGrid1`, their number in `Label6` |
| `TForm1.kinderanz` | `005D6E2C` | the children of the person in `StringGrid2`, their number in `Label7` |
| `TForm1.speich1` | `005D78BC` | saves the person; a new record without a name is removed again |
| `TForm1.neu1Click` | `005D8B60` | a new person: the fields are cleared and a new record is appended |
| `TForm1.Kinderentfernen1Click` | `005E7870` | the child is detached from the person |
| `TForm1.Listenaktualisieren1Click` | `005FB1A0` | the lists are rebuilt, the person is shown again |
| `TForm1.Edit2DblClick` | `005DCC94` | the person is looked for by the number in `Edit2` |
| `TForm1.ComboBox2Exit` / `ComboBox3Exit` | `00603B50` / `00603C48` | the text is written with a capital first letter |
| `TForm1.PopupMenu3Popup` / `PopupMenu4Popup` | `005EB760` / `005EB870` | the entries of the menu are enabled when a person is selected |
| `TForm1.DBGrid1DblClick` | `005E2C2C` | the person that was clicked in the list is looked for and shown |
| `TForm1.TabSheet1Show` | `0060EAF0` | the list of the persons is shown, the dialog for the selection is opened |
| `TForm1.TabSheet2Enter` | `005EC208` | the person is shown again when the page is entered |
| `TForm1.TabSheet7Enter` | `006036AC` | the list of the names is read again |
| `TForm1.TabSheet1Exit` | `005E4FB0` | the index of the table of the persons is removed |
| `TForm1.tabdisab` / `tabenab` | `005D8754` / `005D8778` | the controls of the tables are not updated while they are changed |
| `TForm1.lab18ein` | `005D8704` | the two labels that show the progress are shown |
| `TForm1.FormActivate` | `00602BF0` | the field for the name of the father gets the input |
| `TForm1.FormKeyPress` | `005E28AC` | the return key is passed on to the form |
| `TForm1.basahnen` / `aspitz` | `005E4AB8` / `005E4C30` | the ancestors without a connection resp. without parents are searched |
| `TForm1.pspitz` | `005E4D60` | the ancestors of a person are searched |
| `TForm1.ucase` | `005D7AA8` | the text in capitals, with the German umlauts |
| `TForm1.DBEdit33Exit` | `005EB1C4` | a person without a number gets the number that is written in the field |
| `TForm1.QRDefault` | `005F0170` | the report is put into its default state |
| `TForm1.DBNavigator1Click` | `005D93B8` | the entry for a new person is only enabled when a person is selected |
| `TForm1.allePersonen1Click` / `allePersonen2Click` | `005F0AA4` / `005F2E20` | all persons are shown; the place or the name of the person is determined |
| `TForm1.Osterberechnung1Click` | `005FA0EC` | the calculation of the Easter date is shown in its own form |
| `TForm1.alleBilderentfernen1Click` | `005FCB20` | all pictures of the person are removed |
| `TForm1.Druckereinstellung1Click` | `005EC69C` | the dialog for the printer is opened |
| `TForm1.beenden1Click` | `005E7844` | the data protection is removed and the program is closed |
| `TForm1.DBGrid3Exit` | `006059B8` | the grid and its label are hidden |
| `TForm1.Einzelpersonen1Click` | `006073B8` | a single person is marked |
| `TForm1.FamGrafik1Click` | `005FA868` | the family chart is shown |
| `TForm1.HofnamenVerwaltung1Click` | `0060EF00` | the list of the names of the estates is edited |
| `TForm1.NamensListeeditieren1Click` | `00603678` | the list of the names is edited |
| `TForm1.FormResize` | `005F2F3C` | the form is scaled with the height it had before |
| `TForm1.Datensichern1Click` | `005E1DC0` | the data is saved |
| `TForm1.aus1Click` | `005E9B54` | the list of the persons is cleared |
| `TForm1.Datenschutzein1Click` | `005E9D04` | only the persons born up to a given year are shown |
| `TForm1.Datenschutzaus1Click` | `005EA0B0` | the data protection is removed |
| `TForm1.ComboBox1KeyPress` | `0060750C` | a space ends the entry of the place of the marriage |
| `TForm1.TabSheet1MouseDown` / `TabSheet7MouseDown` | `005E62D4` / `005E8F94` | the dialog for the selection of a person is opened |
| `TForm1.StringGrid5KeyDown` | `005EF604` | the grid is hidden |
| `TForm1.wt33` … `wt36` | `005D7DF4` … | the name of the weekday of the birth, of the baptism, of the death and of the burial |
| `TForm1.wt37` … `wt39` | `005D8254` … | the name of the weekday of the church wedding, of the wedding at the registry office and of the separation |
| `TForm1.Wochentag` | `005D7C50` (local) | the name of the weekday of a date |
| `TForm1.roem` | `005E2CA4` | the number of a marriage as a Roman numeral |
| `TForm1.datcheck` | `005D859C` | the three parts of a date are checked; an invalid date is shown to the user |
| `TForm1.FormClose` | `005D879C` | the data is saved, the temporary files are removed, the title is written into `par.cfg`, the program is closed |
| `TForm1.TabSheet3Exit` | `005EA2B8` | the marriage of the person is written (twice), the places are collected, the index date is set |
| `TForm1.TabSheet4Enter` | `005E8FC4` | the page of the marriages is filled |
| `TForm1.TabSheet4Exit` | `005E9330` | the marriage is written into the table of the connections of the partner as well |
| `TForm1.TabSheet6Enter` | `005E28CC` | the label "Text zu:" gets the name of the person and the most important date |
| `TForm1.elem` / `elem_leer` | `005E8284` / `005E81BC` | the fields of the marriage are shown, hidden or cleared |
| `TForm1.StringGrid1DblClick` / `StringGrid2DblClick` | `005D93E8` / `005D94C0` | the person that is marked in the list is shown |
| `TForm1.DatensatzNr1Click` | `005D9598` | the record with the given number is looked for |
| `TForm1.schen1Click` | `005D8E30` | the person is given away: the marriages, the children and the record are removed |
| `TForm1.DBGrid1KeyDown` | `005E7728` | a letter jumps to the person whose name begins with it, the return key takes over the marked person |
| `TForm1.StringGrid3Click` | `005E9118` | the marriage that is marked in the list is shown in the fields of the page |
| `TForm1.PopupMenu1Popup` / `PopupMenu2Popup` | `00602C34` / `00618938` | the entries of the menus are enabled when a person is marked |
| `TForm1.TabSheet2Exit` | `00603D50` | the number of the person is remembered, the empty sources are written |
| `TForm1.TabSheet8Enter` | `005FD9DC` | the page of the address shows the name of the person |
| `TForm1.IDSatznr1Click` | `005E4FC4` | the number of the record is written into the field "ID" |
| `TForm1.IDslschen1Click` | `005E53B4` | all the IDs of the persons are removed |
| `TForm1.Verbindunglschen1Click` | `005E60B8` | the marked person is not a partner of the person any more |
| `TForm1.Kindereinfgen1Click` | `005E7A14` | a new child is created for the person and for the marked person |
| `TForm1.Verbindungeinfgen1Click` | `005E844C` | a new connection (a marriage) is created for the person |
| `TForm1.DBGrid2DblClick` | `005E89E8` | the marked person is taken over into a connection or into the parents |
| `TForm1.TabSheet3Enter` | `005EB350` | the fields of the marriage are filled with the data of the person |
| `TForm1.Vaterentfernen1Click` / `Mutterentfernen1Click` | `005EB980` / `005EBA6C` | the father or the mother of the person is not known any more |
| `TForm1.Vatereinfgen1Click` / `Muttereinfgen1Click` | `005EBB58` / `005EBEB0` | a new father or a new mother is created for the person |
| `TForm1.FOKODateierstellen1Click` | `005FC4F0` | the file of the FOKO is written again |
| `TForm1.inyTafelerstellen1Click` | `005FC5B0` | the "Tiny-Tafel" (the small family chart) is created |
| `TForm1.FOKODateieditieren1Click` | `005FC67C` | the FOKO file is edited |
| `TForm1.OFBDruck1Click` | `005FC700` | the print of the family chart is prepared |
| `TForm1.Listen2Click` / `Liste1Click` | `005FD640` / `005FBEAC` | the list of the ancestors / of the descendants is shown |
| `TForm1.Proband1Click` / `allePersonen3Click` / `Basisahnen1Click` | `0060243C` / `006024D0` / `00602544` | the family tree of the "Proband", of all the persons, of the direct ancestors |
| `TForm1.Grafikalt1Click` / `GrafikI1Click` | `006022BC` / `00600D58` | the chart of the ancestors / of the descendants is shown |
| `TForm1.DBEdit8Exit` … `DBEdit14Exit` | `005E5CF0` … `005E57B0` | the age is calculated again when a date of the birth or of the baptism is changed |
| `TForm1.DBEdit16Exit` … `DBEdit22Exit` | `005E5F70` … `005E5AC8` | the age is calculated again when a date of the death or of the burial is changed |
| `TForm1.ComboBox2KeyPress` / `ComboBox3KeyPress` | `00607554` / `0060759C` | a space ends the entry of the place of the marriage / of the separation |
| `TForm1.DBLookupComboBox1KeyPress` … `DBLookupComboBox22KeyPress` | `006073EC` … `0060781C` | a space ends the entry of a place, of a name or of a source |
| `TForm1.Verwandtschaft1Click` | `0060EC94` | the list of the relations is shown for the person |
| `TForm1.fcapt` | `0060E714` | the title of the window is asked for and written into the configuration file |
| `TForm1.Browser` | `005F2E6C` | the address is shown in the browser of the form |
| `TForm1.DBComboBox1Exit` | `00618254` | the kind of the relation is written into the field of the marriage |
| `TForm1.Lb_speich` | `006184B0` | the list of a form is written into a text file |
| `TForm1.geschw` | `005E6304` | the siblings of a person are searched and written into the grid |
| `TForm1.TabSheet5Enter` | `005E683C` | the page of the siblings is filled |
| `TForm1.zahl6` | `005D3148` (local) | a number is written into six characters |
| `TForm1.datumNormalisieren` | `005D31EC` (local) | a date is brought into the form that the program uses |
| `TForm1.StringGrid1RowMoved` / `StringGrid2RowMoved` | `005EFBF4` / `005EFD84` | the order of the marriages / of the children is written into the index fields |
| `TForm1.zuAHNENWIN1Click` | `005EF7F0` | the output of the program is shown with the date and the number of the records |
| `TForm1.Hausname1Click` | `005EF944` | the persons with the name of the estate are filtered |
| `TForm1.Grafik1Click` / `Grafikneu1Click` | `005FB294` / `005FB3CC` | the chart of the ancestors / of the descendants (the second one) is shown |
| `TForm1.entfernen1Click` | `005FAFD4` | the picture of the person is removed (the file is kept under a new name) |
| `TForm1.ID1Click` / `Name1Click` | `005E98B0` / `005EC3F4` | the persons with the given ID / with the given name are filtered |
| `TForm1.StringGrid4DblClick` | `005E7654` | the person that is marked in the list of the siblings is shown |
| `TForm1.einfgen1Click` | `005FA898` | a picture is inserted for the person and scaled to the image control |
| `TForm1.DBEdit2Exit` | `005EB534` | the number of a new person is taken from the table of the deleted persons |
| `TForm1.DBEdit7Exit` / `DBEdit40Exit` | `006026F0` / `006025B8` | the gender of the person is checked |
| `TForm1.DBEdit16Exit` … `DBEdit22Exit` | `005E5F70` … `005E5AC8` | the age is calculated again when a date of the death or of the burial changes |
| `TForm1.DBEdit37Exit` / `DBEdit44Exit` / `DBEdit47Exit` / `DBEdit52Exit` / `DBEdit55Exit` | `005EC25C` … `006029C0` | the weekday is shown again and the date is checked |
| `TForm1.Edit6Exit` / `Edit10Exit` / `Edit13Exit` | `00602A48` / `00602AD0` / `00602B58` | the weekday is shown again and the date is checked (the same fields as the `DBEdit` variants) |
| `TForm1.DBEdit3Exit` / `DBEdit32Exit` | `0060DB68` / `0060DC84` | a new entry is written into the list of the occupations |
| `TForm1.DBEdit6Exit` | `0060EDE8` | the name of the estate is written into the list of the estates |
| `TForm1.Quellenliste1Click` | `0060E890` | the list of the sources is written into the report table and printed |
| `TForm1.StringGrid5DblClick` | `005EF620` | the person that is marked in the list is shown |
| `TForm1.DBComboBox7Exit` | `00618A30` | the religion is taken over into the record of the person |
| `TForm1.DBComboBox3Exit` | `00605754` | the entry of the list is removed when the field is left empty |
| `TForm1.DBLookupComboBox4MouseDown` | `00602F3C` | the right mouse button in a place field enters a new place |
| `TForm1.DBLookupComboBox17MouseDown` | `006034D8` | the right mouse button in the name field enters a new name |
| `TForm1.DBLookupComboBox12MouseDown` | `00603EE0` | the right mouse button in a source field enters a new source |
| `TForm1.DBLookupComboBox19MouseDown` | `006044C4` | the right mouse button in the source of a marriage enters a new source |
| `TForm1.EhenKiordnen1Click` | `0060DDA4` | the marriages and the children are sorted by date and numbered within the family |
| `TForm1.NichtverknpfteBeziehungen1Click` | `00606DAC` | the relationships that are not linked are written into the grid |
| `TForm1.gitterZeile` | `005D96D8` (local) | writes a line into the grid with the relationships |
| `TForm1.TabSheet9Show` | `00615FD8` | the pictures of the person are shown (the letters 'a' to 's') |
| `TForm1.Image2Click` | `00614074` | a picture is selected; its number and its file name are shown |
| `TForm1.geb_sterb` | `005FDF68` | the text with the dates of the person: the birth (or the baptism), the death (or the burial) |
| `TForm1.Einzelpersonenmarkieren1Click` | `00605A2C` | the persons without parents, children and marriage are collected; in the mode "Dopp" the persons whose name is written twice |
| `TForm1.Datenlschen1Click` | `005E2064` | all the data is removed: the tables are emptied, the lists are cleared |
| `TForm1.frbestimmtenOrt1Click` | `005F02D8` | the names of the persons of a place are collected in a list and printed |

Thirty-two methods have an empty body in the original; they are
reconstructed as such.

`vorf_erm2` (the search of the ancestors, 00600F50) and `spitzbas`
(the search of the ancestors without a connection, 005E3454) are the two
big methods of this wave; they are still open. Every open method has a
listing in the IDR output; where the listing is cut off in the middle,
the rest has to be taken from the binary, as it was done for the missing
part of `roem`. `tools\disasm.py` reads the code of such a method from the
original binary and prints it with the symbols of the IDR output as
comments.

Six findings of this wave are worth keeping:

* **The v-slots of the VCL.** IDR does not resolve every virtual method.
  The remaining ones were identified from the VCL that IDR decompiled:
  `TDataSet.v14C` is `GetRecordCount`, `TDataSet.v190` is `SetFiltered`,
  `TDataSet.v198` is `SetFilterText`, `TField.v58` is `GetAsInteger`,
  `TField.v60` is `GetAsString`, `TField.v0B0` is `SetAsString`,
  `TDataSet.v248` is `Post`. The table is in `Source\Projects_AhnenWin\`
  (`DB.pas`, `Forms.pas`, `Classes.pas`).
* **The table password.** The session gets the password `hheerrii`
  (`TSession.AddPassword` at `005D5716`); without it the BDE refuses
  every table with "Unzureichende Tabellenrechte".
* **`par.cfg` holds 51 bytes**, a short string of 50 characters; the
  original reads 33 bytes of it (`005D6397`), the reconstruction does the
  same, so that a shorter file does not raise a stream error.
* **A mistake in the original.** `roem` has a table with the Roman
  numerals from 0 to 60; the number 49 is written "IL" there. The
  reconstruction keeps the mistake, because it is the behaviour of the
  original.
* **Two properties of Delphi 9 are protected** where the original could
  use them: `TCustomForm.SetActiveControl` and `TControl.Text`. The
  reconstruction uses `SetFocus` and `Caption` instead; the result is
  the same.
* **The state of a table** is an enumeration in the VCL of the original
  *and* in Delphi 9: `TDataSetState = (dsInactive, dsBrowse, dsEdit,
  dsInsert, dsSetKey, …)`, `dsEditModes = [dsEdit, dsInsert, dsSetKey]`.
  The state itself is the byte at offset `$9D` of the table. The original
  tests it with `add dl,0FE / sub dl,2 / jae` — that is
  `state - 4 < 0`, which is **exactly** `dsEdit` or `dsInsert` (the values
  2 and 3). `speich1`, `FormClose` and `TabSheet3Exit` therefore use
  `State in [dsEdit, dsInsert]` and not `dsEditModes`; with `dsEditModes`
  the record would have been posted one state too early.
* **IDR cannot always determine the parameters.** The methods
  `basahnen`, `aspitz` and `pspitz` are listed without parameters, but
  the listing shows that the sender of the menu entry is passed on. The
  declarations were corrected accordingly; the forms would not stream
  otherwise.
* **The Windows messages moved.** In Delphi 9 they are in the unit
  `Messages` and not in `Windows`; `FormKeyPress` needs that unit.
* **The QuickReport compatibility layer was enough.** The classes that
  `QRDefault` needs (`TQRPage`, `TQRLabel`, `TQRDBText`) were already
  there, derived from the resources of the report; the method could be
  reconstructed without more work on the layer.
* **Two more signatures had to be corrected.** `ucase` takes a string
  and a result variable, `vorf_erm2` a number, a text and a flag as a
  variable — IDR had guessed them wrong, the listing shows the
  registers that are filled.
* **The buttons of `MessageDlg` are `3` in the original.** The value is
  stored in a global variable that is used by every call of the program
  (`gvar_0060E584` and its copies in the other units) and the result is
  compared with `6`. That is the pair *Yes/No* and the answer *Yes*; the
  reconstruction uses `[mbYes, mbNo]` and `= mrYes`.
* **The data source of a table.** The original detaches the table of the
  marriages from its data source with `TTable.SetDataSource(nil)`. In
  Delphi 9 `TDataSet.DataSource` cannot be written and
  `TDataSet.SetDataSource` is private — but `TTable.MasterSource` *is*
  the data source of the table and can be written. `EhenKiordnen1Click`
  therefore uses `MasterSource := nil`.
* **`TCustomForm.SetActiveControl` is private in Delphi 9** and
  `TWinControl.FindNextControl` has three boolean parameters instead of
  a tab index and a direction. The reconstruction uses
  `FindNextControl(ActiveControl, True, True, False)` and `SetFocus`.
* **The cursor of the screen.** The original sets the value `-11` for the
  busy cursor and `0` for the standard cursor; that is `crHourGlass` and
  `crNone` in the numbering of Delphi 3, `crHourGlass` and `crDefault`
  in Delphi 9.
* **The sources of the reconstruction are UTF-8, the compiler of Delphi 9
  reads them as ANSI.** A German umlaut in a string literal would
  therefore be read as two characters. The umlauts in the texts of the
  program are written as `'verf' + #252 + 'gbar'`; the form resources use
  the same notation (`'  zur'#252'ck'`), which the loader of Delphi 9
  understands. The files of the project must therefore be edited with a
  tool that keeps the UTF-8 encoding; a round trip through
  `Get-Content`/`Set-Content` of the PowerShell 5.1 would destroy it.

### The conventions of the compiler of the original

The original was not built with Delphi 9, but with an older version of the
compiler. Four of its habits had to be understood before the methods could
be read; all of them were checked with small test programs that were
compiled with `dcc32` 17.0 and then disassembled.

* **The order of the parameters is the same as in Delphi 9** — `eax`, `edx`,
  `ecx`, then the stack. The old compiler saves the third register
  parameter with `xchg ecx,[ebp-4]`; the slot that the exchange reads is
  the saved `ecx` of the prologue, so the parameter is not lost. (Read
  wrongly, the exchange looks like a compiler bug that drops a parameter.)
* **`@LStrCatN` concatenates in the order of the pushes** — the first
  argument that is pushed is the first part of the result. A test program
  (`a + '.' + b + '.' + c`) produces `AAA.BBB.CCC`.
* **The empty string is `nil` in Delphi 9.** `s := ''` gives the pointer 0,
  so the compiler tests a string for emptiness with `cmp [s],0` — the same
  instruction the original uses.
* **`DeleteFile` has to be qualified.** `Windows` is the last unit of the
  uses clause of `Unit1`, so `DeleteFile` is the `PChar` function of
  `Windows` and not the `string` function of `SysUtils`; the calls are
  written as `SysUtils.DeleteFile`.
* **The property `DataSource` of a table cannot be written in Delphi 9.**
  `TDataSet.DataSource` is `read GetDataSource` there, and the setter of
  `TTable` is private. The link to the master — the one the original
  changes with `SetDataSource` — is the published property `MasterSource`
  in Delphi 9; `schen1Click` uses it.
* **`GetChecked` is the virtual slot `$C4` of a check box.** The two
  radio buttons of the dialog "Kind einfügen" are not asked, they are
  *read*: `Form4.RadioButton1.Checked` tells the program which of the two
  cases was chosen in the dialog.
* **The method of the IDR output can be wrong about the parameters.**
  `TForm13.Verwandtschaft1Click` is listed without a parameter, but the
  listing stores `edx` into a local — the method takes the sender. The
  declaration in `Units\Unit13.pas` was corrected accordingly. The same
  applies to `TForm1.Vorlist`.
* **A global can hold a form.** `gvar_0061F0FC` gets the instance of the
  form that shows the chart of the ancestors or of the descendants; its
  type in `Units\AHNGlobals.pas` is `TForm` (and not `Integer`, which is
  what the inventory of the globals produced).
* **Fifteen methods that were taken for empty are not empty.** The
  methods that only show the weekday of a date call `wt34` or `wt36`,
  the `KeyPress` methods of the lookup combo boxes clear a field of the
  table, and `DBNavigator1BeforeAction` saves the data. The check
  `tools\checkempty.py` compares every method that is marked as empty
  with its listing in the IDR output and reports the ones that do more
  than a `ret`.
* **The local function `altersberechnung` is a procedure.** Its result is
  the fourth parameter (a variable), the first three are the day, the
  month and the year of the birth. The reconstruction had the result
  first and a function result of its own; the declaration and the call
  in `anzeigen` were corrected, and a forward declaration was added
  because the methods that call it come first in the file.
* **The enumeration of the open dialog has been reordered.** The original
  writes the value 2 into the options of the save dialog; in the VCL of the
  original that was `ofCreateNone`, in Delphi 9 the value 2 is
  `ofHideReadOnly` (the list of the options starts with `ofReadOnly`
  there). `Lb_speich` uses the Delphi 9 meaning and says so in a
  comment.
* **The cross reference counted methods that do not exist in the
  reconstruction.** A method of the IDR output that is only mentioned in a
  comment (`sub_005D3148`, `sub_005FCB74`) was marked as *reconstructed*,
  because it does not appear in the list of the open methods either.
  `tools\crossref.ps1` now only marks a method as *done* when it also has
  a body in the unit; the total (244) was not affected, but the list was
  misleading.
* **The old compiler loses a register parameter.** The method `geschw`
  takes ten parameters; the third one (in `ecx`) is overwritten by the
  compiler before it is used — the original never reads it. The
  reconstruction keeps the parameter (the signature of the call is the
  same) but does not use it.
* **`Windows` wins in the uses clause of the implementation.** The units
  `SysUtils` and `Windows` both have `DeleteFile`, `ExtractFileName` and
  `ExtractFilePath`; because `Windows` is the last unit of the uses
  clause of `Unit1`, the `PChar` variants of the Windows unit would be
  used. The calls are written as `SysUtils.DeleteFile` /
  `SysUtils.ExtractFileName` / `SysUtils.ExtractFilePath`.
* **The original counts the letters of the picture names from the
  character 61 on.** `einfgen1Click` stores a new picture as
  `b<Nummer><Chr(i + 61)>.jpg` — the first letter is therefore `=`, while
  the pictures that are already in the database use `a` to `z` (the search
  in `anzeigen` starts with `a`). The reconstruction keeps the behaviour
  of the original and says so in a comment.
* **Three filters follow the same scheme.** `ID1Click`, `Name1Click` and
  `Hausname1Click` ask for a criterion, look for a record that has it,
  and only then set the filter of the tables of the persons and of the
  names (`idnr=`, `name=`, `hausname=`); if nothing is found, a message
  says that the criterion was not found.
* **The argument order of `datcheck` is the order of the date.** The
  method is called with the day, the month and the year; in the listing
  the three values are read in the reverse order (the last one pushed is
  the first parameter), so the reconstruction has to name them the other
  way round: `datcheck(DBEdit42.Text, DBEdit43.Text, DBEdit44.Text)` for
  the date of the birth.
* **The method `druck` takes the title and the subtitle of the report.**
  IDR could not resolve the parameters; the call in
  `Quellenliste1Click` shows them (the two global strings with the name
  of the report and its subtitle). The declaration was corrected
  accordingly.
* **The compatibility layer of QuickReport has no preview.** The original
  shows the preview of the report after printing it; the layer has
  neither `Preview` nor a print dialog, so the call is left out and
  noted in the code.


### One instruction that could not be derived unambiguously

`TForm12.SpeedButton1Click` calls a *dynamic* method of `Form13.Button2`
with the selector `-21` (`mov si,0FFEB / call @CallDynaInst`). The dynamic
method table of a class depends on the exact VCL version, and the IDR
output does not preserve that table, so the selector cannot be resolved to
a unique method name from the disassembly alone. `TControl.Click` is the
only dynamic method of a button that application code invokes; it raises
the published `OnClick` handler of the button. The reconstruction uses
`Form13.Button2.Click` and the uncertainty is noted in the code.
