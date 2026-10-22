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
  an access violation ("Zugriffsverletzung … Lesen von Adresse
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
```

`StreamCheck` instantiates all 40 forms and the data module from their
original resources and reports the number of components each one streamed.
It is the acceptance test for the resource half of the reconstruction: a unit
is structurally correct only when its DFM round-trips through the VCL
streaming mechanism.

Current state: **40 / 40 forms stream, 0 failures.**

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

`gen-unit.ps1` and `gen-bodies.ps1` never overwrite an existing unit: once
the method bodies have been reconstructed, the unit file is the primary
source of truth.

## How a method is reconstructed

1. **Read the listing.** `tools\get-listing.ps1 -Unit 27 -Method SpeedButton1Click`

2. **Resolve the component accesses.** IDR annotates them:
   `mov eax,dword ptr [ebx+32C];TOKBottomDlg1.RadioButton2:TRadioButton`
   → offset `$32C` → the `//32C` marker in the unit declaration → the
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
its address in the AHNENWIN 5.1 binary and its reconstruction state. The
order of the work follows the dependency edges that the same file records:
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

### Wave 1 - the main form (partly done)

`Unit1` is the largest unit of the program (276 methods). The three
methods that decide what the program shows when it starts are done:

| Method | Address | What it does |
|---|---|---|
| `TForm1.FormCreate` | `005D3F80` | screen sizes, the BDE alias and the table password, the scaling of the grids, `par.cfg` |
| `TForm1.FormShow` | `005D92AC` | the scaling factor 1.9, the page that is shown first, the tables of the places, of the titles and of the notes |
| `TForm1.anzeigen` | `005D42BC` | the data of the selected person, the picture `bilder\b<Nummer><a-z>.jpg`, the age at the wedding |

`anzeigen` also contains a *local* function of the original
(`sub_005D3A70`, address `005D3A70`) that calculates the age of a person
at the date of the wedding from the dates of birth, of baptism and of the
wedding; it is reproduced as `altersberechnung` in `Units\Unit1.pas`.

Three findings of this wave are worth keeping:

* **The v-slots of the VCL.** IDR does not resolve every virtual method.
  The remaining ones were identified from the VCL that IDR decompiled:
  `TDataSet.v14C` is `GetRecordCount`, `TField.v58` is `GetAsInteger`,
  `TField.v60` is `GetAsString`, `TField.v0B0` is `SetAsString`,
  `TDataSet.v248` is `Post`. The table is in `Source\Projects_AhnenWin\`
  (`DB.pas`, `Forms.pas`, `Classes.pas`).
* **The table password.** The session gets the password `hheerrii`
  (`TSession.AddPassword` at `005D5716`); without it the BDE refuses
  every table with "Unzureichende Tabellenrechte".
* **`par.cfg` holds 51 bytes**, a short string of 50 characters; the
  original reads 33 bytes of it (`005D6397`), the reconstruction does the
  same, so that a shorter file does not raise a stream error.

### One instruction that could not be derived unambiguously

`TForm12.SpeedButton1Click` calls a *dynamic* method of `Form13.Button2`
with the selector `-21` (`mov si,0FFEB / call @CallDynaInst`). The dynamic
method table of a class depends on the exact VCL version, and the IDR
output does not preserve that table, so the selector cannot be resolved to
a unique method name from the disassembly alone. `TControl.Click` is the
only dynamic method of a button that application code invokes; it raises
the published `OnClick` handler of the button. The reconstruction uses
`Form13.Button2.Click` and the uncertainty is noted in the code.
