# Portability roadmap and current evidence

## Target contract

The first portable host is 64-bit Linux analyzing legacy Delphi/Windows
PE32 files. Host pointer width is independent from target image width: PE32
VA/RVA/file offsets remain fixed-width unsigned values. The source uses no
`NativeInt`/`NativeUInt`; actual host addresses remain pointer-typed and
host-API bytecounts use explicitly sized ABI types. Target addresses are not
stored as host pointers. DFM file offsets and BSS/DOI/class-emulator DWORD
collections now use fixed-width value containers. The one Windows process-
memory boundary adapts a remote PE32 VA to the host-sized `ReadProcessMemory`
argument without storing it as a pointer-valued list entry. PE64 and ELF are
future, separate image providers.

Delivery order remains:

1. Linux/Laz64 headless CLI for PE32 analysis and project export.
2. Linux Lazarus/LCL UI over the same analysis/export API.
3. Remaining platform tools and optional image formats.

The core no longer imports VCLZip/VCLUnZip. Platform-only process dumping,
SoftIce and registry integration remain Windows-specific; the Linux BSS
dump entry point reports that process dumping is Windows-only rather than
silently substituting data.

## Implemented portability slices

- `DeDeBinaryTypes.pas` defines PE32 RVA, VA and file-offset types plus
  checked offset addition and VA-to-RVA conversion.
- DFM resource offsets carried by the analysis context and the class-dumper
  scan are now stored in `TPE32FileOffsetBox`, not encoded as `TStringList`
  object pointers. A `$F0001234` storage vector is covered by the XE/FPC
  reader test.
- `DeDeBinaryReader.pas` supplies bounded little-endian reads and preserves
  the stream position.
- Delphi VMT compiler-version detection and the Delphi-2 Boolean marker now
  use the bounded reader. Section/file bounds and truncated markers are
  rejected without overrunning the PE32 stream.
- `TDeDeCoreContext.GetByte`, `GetWord` and `GetDWord` now use checked
  PE32 VA-to-RVA/file-offset conversion and bounded little-endian reads;
  accesses crossing the code section or file are rejected.
- `TDeDeBinaryReader.ReadBytesAt` now handles XRef signature reads, preserving
  stream position and enforcing file bounds instead of manual seek/read/restore.
- `TPEImportData.CollectInfo` now reads descriptors, thunks and bounded
  null-terminated names through the same reader; malformed/truncated import
  tables fail explicitly.
- `LoadPEBinary` and `TPEHeader.Dump` parse through their explicit file/header
  objects and no longer bind the global `PEFile`/`PEHeader` while loading.
  `TClassesDumper`/`TClassDumper` also hold an explicit image pair supplied by
  the session. Remaining legacy symbol/disassembly paths use scoped bindings.
- Owning `TDeDeAnalysisSession.Analyze` calls now use a session-owned
  `TDeDeCoreContext`, activated around legacy calls and restored afterward;
  GUI-attached sessions borrow the host context. PE file/header/stream globals
  are also scoped and restored per call. Regression coverage verifies separate
  reports/warnings and image-state restoration for attached sessions.
- Compiler version, reduced version, C++Builder mode and Delphi-2 mode are
  now stored in each core context. The DSF first-byte filter, BSS mode and
  user-procedure mode are also session-owned, along with import lookup,
  custom-emulation initialization and disassembler string/import options.
  Activation binds these values for legacy routines and restores the
  previously active state afterward. The unused `FirstCodeRVA` global was
  removed. The `DeDeSym` decoder is now local to each `UnlinkCalls`
  invocation; current routine and instruction RVAs are stored in the core
  context. Signature-normalization counters, the call-CRC toggle and
  disassembler error accumulation are also per-context. SEH/END stacks,
  jump/push state, try depth and per-instruction formatting flags are now
  context-owned. Remaining shared switches are legacy UI preferences;
  concurrent analyses are still unsupported.
- `TPE32DWordList` stores 32-bit target values in a dynamic array of typed
  records, with an explicit undefined sentinel. It replaces integer-in-
  `TList` storage in BSS/DATA snapshots, class-to-instance mappings,
  emulator registers/locals, and DOI offsets.
- DFM resource offsets carried by the analysis context and class-dumper
  scan use `TPE32FileOffsetBox`, not integer-in-`TStringList.Objects` casts;
  the `$F0001234` high-offset test runs under XE, FPC/Win64 and FPC/Linux.
- `DeDeZip.pas` implements the tested single-entry ZIP subset on both XE and
  FPC using raw ZLib. See `docs/ZLIB_ZIP_SPIKE.md`.
- `DeDePAS` uses a small FPC `TBinaryObjectReader` adapter for DFM binary
  prefixes/string/list operations. The Delphi reader path remains unchanged.
- The x86 disassembler now accepts a byte-buffer length and uses
  `PAnsiChar` for machine-code bytes on both hosts. This fixes the XE
  Unicode-`PChar` interpretation of PE bytes and prevents decoder reads past
  the caller's buffer. `TdaRef.Immidiate` and `OnAddressRef.RefAddress` are
  fixed `DWORD` target values, not host pointers.
- PE metadata reading no longer needs the Windows unit. Windows-only
  SoftIce/version/process facilities have conditional host implementations;
  FPC/Linux gets the explicit non-Windows behavior.
- `DeDeCore` has no direct Windows unit dependency; clock and output-file
  operations are routed through `DeDeCoreServices`.

## Reproducible WSL/Linux validation

In WSL, from the repository root:

```bash
python3 DeDe/tools/build_fpc.py
python3 DeDe/tools/run_fpc_cli_smoke.py
python3 DeDe/tools/run_binary_portability_tests.py --fpc-only
python3 DeDe/tools/run_zip_archive_tests.py --fpc-only
bin/Laz64/Linux/DeDeCLI/DeDeCLI \
  /mnt/c/install/Development/DeDe.3.50.02.1619.bin/DeDe.exe \
  --output DeDe/build/FPC-Linux/DeDeCLI/reference-export --force
python3 DeDe/tools/verify_cross_host_export.py \
  --input /mnt/c/install/Development/DeDe.3.50.02.1619.bin/DeDe.exe \
  --xe-export DeDe/build/reference-export-3.50.02 \
  --linux-export DeDe/build/FPC-Linux/DeDeCLI/reference-export \
  --report DeDe/build/FPC-Linux/cross-host-report.json
```

The WSL host is Ubuntu 26.04 with FPC 3.2.2. The full Linux CLI compiles and
analyzes the pinned PE32 reference as D6: 852 classes, 33 forms, 33 units,
and 72 exported files. Native Linux PE32-reader/disassembler and ZIP tests
pass. The ZIP matrix includes original `d2.doi`, `D6.DOI`, `VCL7.dsf`,
stored/data-descriptor/empty entries, bad CRC/name rejection and rejection
of multi-entry archives; generated archives are independently checked by
Python `zipfile`.

The cross-host checker verifies the same input SHA-256, complete file set,
analysis result and warnings, all DFM bytes, the DPR's ordered unit
references, event listing after line-ending normalization, every
procedure/function declaration, PAS field offsets and method address
comments. The verifier compares each non-empty method body's first
instruction address and checks known IDR field-offset vectors. It also
verifies every Linux-disassembled opcode byte sequence against the original
PE. Current result:

- 72/72 exported files, 36/36 DFM files byte-identical.
- 33/33 units, 1,344/1,344 procedure/function declarations, and event listing
  match; the analysis report has equal counts and warnings.
- All 672 PAS class-method declarations carry code-VA comments; 670 match
  their assembly body's first instruction and two synthetic methods have no
  decoded instructions.
- All 1,001 PAS class-field declarations carry instance-offset comments;
  field layouts match across XE and Linux.
- XE has 5,542 decoded instruction rows; Linux has 5,565. Every XE row is
  present in the Linux output, and all 5,565 Linux instruction-byte sequences
  match the input PE. Thus Linux adds 23 validated instruction rows without
  dropping XE-decoded instructions.
- Raw output bytes differ in 35 files, due to line-ending/input-path
  variation and the additional decoded instruction rows/comments. These
  deltas are reported rather than normalized away.

The XE export baseline was refreshed after correcting the Unicode-`PChar`
machine-byte bug. The pre-fix export and manifest remain saved with the
`pre-byte-fix` suffix for audit; the current manifest pins the corrected XE
output.

## Platform service boundaries

The shared analysis/export path supports file input/output, progress,
warnings and host-provided confirmation callbacks. Confirmation is
fail-closed: a missing callback or a negative response denies the action.
`TBSS.Dump` raises `EDeDeServiceUnavailable` on non-Windows hosts instead of
pretending that process-memory capture succeeded.

The legacy process enumerator/dumper, registry preferences and shell
registration, Win32 drag/drop, and plugin/tool windows remain Windows-only
and are not linked into the Linux LCL host. The Linux GUI exposes only the
portable file-analysis/export workflow; unavailable tools are not silently
emulated. Run `tools/run_binary_portability_tests.py` on Windows and its
`--fpc-only` mode under WSL to exercise callback denial and explicit service
unavailability.

## Remaining work and boundaries

- The portable PE32 reader types are still a tested foundation and have not
  yet replaced all direct legacy `TPEHeader`/image references. The loader and
  class-dump image pair are explicit; the disassembler resolves stream and RVA
  conversion from the active context, with global fallbacks for GUI callers.
  Other mutable decoder/compiler state is shared. Parallel analyses remain
  unsupported.
- The full CLI builds and passes the pinned reference export, but FPC still
  reports unrelated legacy warnings, including managed-local initialization
  diagnostics in class serialization. The BSS, class-map, emulator and DOI
  value lists no longer produce ordinal-to-pointer conversion warnings.
- An initial Linux LCL host now drives the shared analysis/export session;
  the legacy VCL tool windows, process-memory adapters, registry, shell/drop
  integration and PE64/ELF providers remain unported.
- VCLUnZip itself was not a valid independent oracle in the earlier console
  probe (it failed on an original archive too). The new adapter is validated
  against original archives, round-trips and Python ZIP, but no direct
  old-VCLUnZip acceptance claim is made.
