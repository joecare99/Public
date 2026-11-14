# Delphi XE ZLib / ZIP spike

## Ergebnis

Delphi XE's installed `ZLib.dcu` can both inflate existing ZIP raw-DEFLATE
members and create raw-DEFLATE members that a ZIP reader accepts. The unit
source is ZLib 1.2.3 and exposes `InflateInit2_` / `DeflateInit2_`; passing
`windowBits = -15` selects the raw DEFLATE stream required by ZIP. The
high-level `TCompressionStream` wrapper is not used for this test.

The spike script extracts the compressed member from an existing DeDe archive,
asks the Delphi program to inflate and recompress it, then builds a minimal
single-entry ZIP around the Delphi output and verifies that Python's ZIP reader
can read the original payload. Three existing fixtures passed:

| Fixture | Raw input | Member | Delphi raw output |
| --- | ---: | ---: | ---: |
| `d2.doi` | 9,543 bytes | 44,848 bytes | 9,543 bytes |
| `D6.DOI` | 47,316 bytes | 219,916 bytes | 47,008 bytes |
| `VCL7.dsf` | 907,360 bytes | 4,941,492 bytes | 904,926 bytes |

The local Delphi XE install has `ZLib.dcu`, but not `System.Zip.dcu`. ZLib
provides the compression layer; DeDe's ZIP container is implemented by the
small bounded adapter described below.

## Produktionsumsetzung

`DeDe/src/Core/DeDeZip.pas` now provides the bounded single-entry ZIP
container around raw ZLib DEFLATE. The four active archive consumers
(`DeDeDPJEng`, `DeDeDUF`, `DeDeOffsInf`, and `DeDeBPL`) now use this adapter;
the unused VCLZip imports were removed from `DeDeSym` and `StatsUnit`.
Production source no longer imports VCLZip/VCLUnZip, and XE build scripts no
longer stage or search the vendor VCLZip sources.

The adapter accepts single-disk, single-entry ZIP files using stored or
DEFLATE data, rejects encryption and ZIP64, validates local/central headers,
file bounds, declared sizes, and CRC32, and writes a standard single-entry
ZIP with deterministic DOS timestamps. Run `python DeDe/tools/run_zip_archive_tests.py`
to compile and run identical tests under
Delphi XE/Win32 and FPC/Win64, round-trips `d2.doi`, `D6.DOI`, and `VCL7.dsf`,
also tests stored entries, data descriptors, empty entries, CRC/name
rejection, and multi-entry rejection without partial output, and verifies the
generated archives using Python's independent ZIP reader. The XE DUnit suite
also exercises save/load round-trips through the DOI, DUF, and BPL consumers.

The original raw-DEFLATE proof did not exercise the old VCLUnZip reader.
The new adapter's outputs are independently accepted by Python ZIP, but an
old-reader comparison is still not claimed: the earlier isolated VCLUnZip
console probe failed even on an original archive. This does not block the
existing DeDe ZIP formats' tested round-trip path; it remains a distinct
legacy-reader compatibility check.

## Scope and limits

The raw-DEFLATE API spike remains isolated to `tests/ZLibZipSpike.dpr` and
`tools/run_zlib_zip_spike.py`. Run it with:

```powershell
python DeDe\tools\run_zlib_zip_spike.py
```

The isolated spike remains a low-level API proof. The production behavior
and its current verification are described above.
