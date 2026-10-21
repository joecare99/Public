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
