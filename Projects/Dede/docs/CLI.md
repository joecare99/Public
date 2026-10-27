# DeDe command-line exporter

## Build and usage

Build the Delphi-XE/Win32 console executable separately from the VCL
application:

```powershell
python DeDe\tools\build_xe.py --cli
```

Under WSL/Linux with native FPC installed, build and smoke-test the same
headless CLI with:

```bash
python3 DeDe/tools/build_fpc.py
python3 DeDe/tools/run_fpc_cli_smoke.py
```

For the installed Windows FPC targets:

```powershell
python DeDe\tools\build_fpc.py --compiler C:\lazarus\fpc\3.2.2b\bin\i386-win32\fpc.exe
python DeDe\tools\run_fpc_cli_smoke.py --target Win32
python DeDe\tools\build_fpc.py --compiler C:\lazarus\fpc\3.2.2\bin\x86_64-win64\fpc.exe
python DeDe\tools\run_fpc_cli_smoke.py --target Win64
```

The FPC targets build separately to `bin/Laz32/Win32`,
`bin/Laz64/Win64`, and `bin/Laz64/Linux`; the XE build remains at
`bin/D_XE/DeDeCLI/DeDeCLI.exe`.

The initial Linux LCL host is a separate GTK2 application using the same
analysis session. Build and run its WSLg export smoke with:

```bash
python3 DeDe/tools/run_lcl_gui_smoke.py \
  --input /mnt/c/install/Development/DeDe.3.50.02.1619.bin/DeDe.exe \
  --lazarusdir /usr/share/lazarus/4.8.0
```

The GUI executable is `bin/Laz64/Linux/DeDeLCL/DeDeLCL`. Its smoke opens the
form, analyzes and exports through `TDeDeAnalysisSession`, then checks the
export with the same XE/CLI structural parity verifier. This is an analysis/
export host, not a port of the legacy VCL tool windows.

The executable is `bin\D_XE\DeDeCLI\DeDeCLI.exe`; compiler DCUs are kept
separately in `bin\D_XE\Units`. GUI output and its `DSF`/`LANGRES` runtime
data are under `bin\D_XE\DeDe`. Compiler logs remain under
`DeDe\build\D_XE`.
Run the non-interactive argument/error smoke checks with
`python DeDe\tools\run_cli_smoke.py`.

The pinned XE reference export can be checked end-to-end against the supplied
DeDe 3.5 executable and its SHA-256 manifest with:

```powershell
python DeDe\tools\verify_reference_export.py --self-test
python DeDe\tools\verify_reference_export.py
```

The self-test verifies the golden export and confirms that an intentional
content-hash change is detected. The end-to-end check runs the CLI into a
temporary directory and compares every output file, analysis count, and
warning against the manifest in `DeDe\tests\fixtures`. The manifest is
generated from the existing reviewed golden export only with
`--write-manifest`; regenerate it only after reviewing and accepting a
reference change.

```text
dede-cli <binary> --output <directory> [--pas] [--dfm] [--dpr] [--txt] [--xref] [--force]
```

With no file-type flags, the tool writes PAS units, DFM resources, a DPR
project, and the event RVA listing. If any of `--pas`, `--dfm`, `--dpr`, or
`--txt` is supplied, only the selected types are written. `--all` restores
the complete set. `analysis.json` is always written on success. Existing
output files are left untouched and cause failure unless `--force` is given.
`--xref` additionally writes an opt-in `cross-references.json` sidecar with
structured direct and indirect x86 call references collected from routines
disassembled for the export and transitively reachable direct-call targets.
Relative direct-call destinations are recorded as PE32 VAs; indirect call
destinations are explicitly unresolved rather
than guessed. The report also records literal `ret n` callee cleanup and an
immediately following `add esp, n` caller cleanup as ABI evidence. For
routines with a canonical `push ebp; mov ebp, esp` prologue, it also lists
observed positive EBP-relative stack accesses with operand sizes and source
instruction VAs. Aligned cleanup byte counts are also represented as
stack-word-count candidates, not complete parameter counts. Calls also list
the last recognized writes to EAX, EDX, and
ECX before the call, with instruction VAs; these are register-state
candidates, not proof that a register carries an argument. Four-byte-aligned
frame accesses carry a zero-based stack-word slot candidate, and the report
marks whether cleanup evidence matches them. These are parameter-location
candidates, not inferred types or complete signatures. Corresponding stack
access comments are added after affected PAS method declarations; routines
with callee-cleanup evidence also receive a cleanup-evidence comment.
Targets matching known class methods or imports resolved by DeDe's existing
import resolver are named. Direct targets can also be named when the
compiler-version-specific DSF catalog beside the CLI contains one exact
normalized 50-byte signature match. The selected catalog and load status are
recorded in the sidecar; multiple matching names, incompatible versions,
and mismatched bytes remain unresolved. With `--xref`, assembly call comments
use the same unique-match rule and prefer exact class-method metadata over
DSF names. No Pascal signature is inferred from a DSF label.

The DSF asset is loaded from `DSF\<versioned-vcl-file>` beside the CLI
executable (for example `DSF\vcl6.dsf` for Delphi 6); filename case is
matched without regard to case for Windows/Linux parity. The source repository
does not currently bundle these historical catalog files; if the asset is
absent, or cannot be parsed, the sidecar reports `not_found` or
`load_failed` respectively and exports continue without RTL names. A loaded
but unsupported pattern size or compiler mask is also reported explicitly.
The complete output list is validated, including case-insensitive filename
collisions, before a new output directory is created. Files are generated in a
staging directory and installed only after their generation succeeds;
replacement failures attempt to restore prior files.

Each method declaration in an exported PAS class has a trailing comment with
its 8-digit target code VA, for example `//00489410`, to locate the routine in
the assembly listing. When the VMT scan confirms a virtual slot, the comment
uses IDR-style `//v<offset>//<VA>` notation; non-virtual methods still receive
their code VA without a VMT offset. Instance fields in each class declaration
also carry an IDR-style object-relative offset, for example
`Panel1: TPanel;//f2F0`.

Exit codes are `0` for success, `1` for analysis/export failure, and `2` for
command-line usage errors. Diagnostics go to stderr. The CLI does not show
dialogs. Core analysis/export code has no direct VCL dialog or `MessageBox`
calls; disassembler exceptions are collected in the warning report rather
than displayed one at a time.

`analysis.json` is UTF-8 and contains the input path, project name, detected
compiler version, class/form/unit counts, generated filenames, and analysis
warnings. The filenames are relative to the requested output directory.

## Current compatibility and verification

The analysis entry point uses DeDe's existing class-layout/version
recognition; it is not a general-purpose modern Delphi decompiler. In
particular, the Delphi-XE self-build is rejected as an unsupported target,
which matches the legacy analyzer's current Delphi 2-6-era metadata support.
The supplied reference executable
`C:\install\Development\DeDe.3.50.02.1619.bin\DeDe.exe` is recognized as D6.
The end-to-end CLI run produced 852 classes, 33 forms, and 72 files. All
exported DFM payloads match PE resources, all 33 PAS unit names and all 33
DPR unit references correspond to `Decomp\DeDe`; the current byte-corrected
XE export contains 542 unique named generated routine declarations found in
those saved decompilation units and 712 synthetic `_PROC_<RVA>` declarations.
The old XE path treated target bytes as Unicode `PChar`, causing corrupted
disassembly and seven nonfatal end-of-stream warnings. It now uses explicit
`PAnsiChar` buffers with a length bound; the corrected XE and Linux runs both
produce zero boundary warnings.

The Linux output was compared with the corrected XE export by
`tools/verify_cross_host_export.py`. File list and counts, all DFM bytes, the
33 DPR unit references, event listing and all 1,344 procedure/function
declarations match. Linux contains 23 additional decoded instruction rows,
all byte-verified against the input PE, and loses none of the XE-decoded rows.
Raw PAS/DPR bytes are not expected to match across hosts because of
line-ending/input-path differences and those validated instruction additions.
See `DeDe\docs\PORTABILITY.md` for the command and measured report.

`TDeDeAnalysisSession.Analyze` owns a per-session core context; calls into
legacy adapters activate and then restore that context. GUI-attached sessions
borrow the UI context. The loader/class dumper and core image lookups use
explicit session image references. The disassembler reads from the active
session image, retaining global stream/converter fallbacks for GUI callers;
other mutable decoder state is still shared. Concurrent sessions in one
process remain unsupported. The VCL
application uses the same core exporter through a non-owning session adapter
and invokes the shared session for class dumping/finalization. `MainUnit.PreBtnClick`
still owns target identification, UI-list population, and DSF/DOI setup;
moving those remaining host-preparation steps into callbacks is still open.
