# Authorized test-data BDE provider catalogue

## Scope and reproducibility

The user authorized read access to `C:\ProgramData\AHNENWIN Test` and
provided its test-database password. The value was used locally by the probe
and is intentionally absent from source, logs, and this wiki page.

The Delphi 9 read-only probe is
`Source\AhnWin52\ReverseEngineering\AuthorizedTestDataReadOnlyBDEProbe.dpr`.
It was compiled with compiler 17.0 from
`C:\copy\delphi\RAD Studio\3.0\Bin\DCC32.EXE` and ran against registered BDE
`IDAPI32.DLL` 5.2.0.2. `TTable.ReadOnly` is set before open; no edit, append,
post, delete, empty, pack, index rebuild, report, application UI, or output
file operation is present in this probe.

The executable accepts only an explicit allowlist of 29 inventoried table
files. It opens one table at a time, records field and index metadata, walks
the table to count rows without emitting field values, closes the table, and
returns an error on setup/provider failures. Every table probe had a full
pre/post recursive SHA-256 comparison. Each comparison reported 170 files,
zero additions, zero removals, and zero changes.
After the complete probe sequence, a fresh whole-directory comparison against
the original 170-file baseline also reported zero additions, removals, or
changes.

The normalized metadata-only runtime catalogue is
`AhnWin52-Authorized-BDE-Provider-Catalog.json`. It contains no record values
or password. It records 29 physical tables, 292 provider fields, 76 index
definitions, and 337 rows in total; 17 of the tables are empty. All 29 opens
completed successfully, including `FOKO.DBF` through BDE's dBase driver.
`ahntab.DB` and `LOC - Kopie.db` are included despite having no DataModule
component mapping.

Field data-type values in the JSON are Delphi 9 `TFieldType` ordinals:
1 string, 3 integer, 6 float, 14 AutoInc, 16 memo, and 17 graphic. Other
field attributes are retained as reported; zero record values were copied.
The full command output and per-table hash evidence are kept in session
artifacts, outside the test-data directory.

## Resource reconciliation

Provider field definitions corroborate the streamed persistent field types
for matching fields, including the `TAutoIncField` ordinal (14). The
following explicit width discrepancies exist between this test database and
the current LFM:

| Physical table / field | LFM declaration | BDE provider result |
|---|---:|---:|
| `AWD.DB.Rufname` (components Table1, Table3, Table6–Table9, Table17) | 40 | 30 |
| `lc.DB.Ort` (Table2) | 40 | 50 |
| `LOC.db.Abk` (Table13) | size omitted | 20 |

The `AWD.DB.Rufname` width of 30 also agrees with the metadata-only
structure-template manifest. This is direct evidence about the authorized
test copy, not a guarantee about every original release.

Some resources stream only a subset of a physical table's fields: Table1
streams 49 of AWD's 52 fields; Table2 streams one of `lc.db`'s two; Table29
streams one of `sour.DB`'s two; and Table30 streams nine of `ng2h.DB`'s ten.
These are component projections, not evidence that the on-disk table is
missing fields. Table23 remains unmapped in both LFM and original DFM.

## Table13 / `LOC.db` lookup observations

The BDE provider reports 13 string fields, in the same order as the original
DataModule resources. `Abk` has provider size 20 although neither DFM/LFM
streams a size for it. The table contains seven rows; all seven `Ort` values
are distinct in this copy.

| Index | Provider fields | Unique | Descending |
|---|---|---:|---:|
| unnamed primary | `Ort` | yes | no |
| `Ort_` secondary | `Ort` | no | no |

With `Ort_` selected, a hit on an existing key returned true at `RecNo=1`,
`BOF=False`, `EOF=False`. After `First`, a guaranteed miss returned false at
`RecNo=1`, `BOF=True`, `EOF=False`. A one-character prefix of an existing
key and a key one character longer than the 40-character field also returned
false with the same immediate cursor flags. Calling `FindKey` after closing
the table raised `EDatabaseError`.

There were no duplicate `Ort` values in the seven test rows, so duplicate-hit
positioning was not exercised. The provider does establish that the actual
`Ort_` index is non-unique; this differs from the earlier synthetic unique
index fixture. The hit/miss cursor result corroborates the synthetic miss
baseline, but does not establish SQLDB parity or authorize production
handler integration.

## Table9 / `AWD.DB` navigation observations

The BDE provider reports 52 fields, nine index definitions (the unnamed
unique primary index on `Nummer` plus eight non-unique secondary indexes),
and four rows in this test copy. All eight expected names and logical field
orders were found: `muto`, `vato`, `namgeb`, `geba`, `gebnam`, `mut`, `vat`,
and `gebo`.

The BDE `TIndexDef.Fields` strings use semicolon separators and omit the
implicit primary-key suffix `Nummer`. The existing decoded Paradox key
catalogue includes that suffix; the two representations reconcile when that
suffix is removed. No claim is made that a SQLDB index API exposes the same
representation.

For each of the eight selected indexes, the observed immediate states were:

| Operation | BOF | EOF | RecNo |
|---|---:|---:|---:|
| `First` | true | false | 1 |
| `Next` | false | false | 2 |
| `Last` | false | true | 4 |

This is the exact result on the four-row authorized test copy; do not infer
provider parity from it. `Rufname` is 30 bytes in the provider schema versus
40 in current LFM persistent fields. The test copy therefore supports the
metadata-manifest width but does not resolve release/version differences.

## Table27 / `alfls.db` schema reconciliation

The authorized BDE probe opened `alfls.db` successfully. It reports seven
fields in the same order as the Unit2 component map and current LFM, zero
records, and three indexes:

| Order | Field | BDE type code | BDE size | LFM persistent field |
|---:|---|---:|---:|---|
| 0 | `Nr` | 14 (AutoInc) | — | `TAutoIncField` |
| 1 | `Dsn` | 3 (Integer) | — | `TIntegerField` |
| 2 | `Kn` | 1 (String) | 20 | `TStringField`, size omitted |
| 3 | `Namvorn` | 1 (String) | 125 | `TStringField`, size 125 |
| 4 | `Geb` | 1 (String) | 60 | `TStringField`, size 60 |
| 5 | `Sterb` | 1 (String) | 60 | `TStringField`, size 60 |
| 6 | `Kmt` | 1 (String) | 100 | `TStringField`, size 100 |

The provider reports an unnamed unique primary index on `Nr;Dsn`, a
non-unique `Ds` index on `Dsn`, and a non-unique `namvg` index on
`Namvorn;Geb`; all are ascending. The resources do not stream these index
definitions. This resolves the test-copy physical schema and the previously
unknown `Kn` width, but the table's zero rows provide no evidence about the
legacy producer's row contents or generated order. The metadata is specific
to this authorized copy and is not assumed universal across releases.

## Reconstruction gate

This work completes an initial provider catalogue and bounded read-only
Table13/Table9 observations. It does **not** justify wiring either path into
the current SQLDB compatibility layer: BDE hit, miss, closed-table exception,
and cursor behavior are not yet proven equivalent there. Keep Unit14
`FindKey` handlers, relationship writes, destructive report producers, and
production UI flows blocked until that provider boundary is independently
implemented and tested.

The current `FindKey` compatibility method deliberately raises
`EDBTablesCompatibilityUnsupported`; the existing SQLDB `Locate` tests use
only `TBufDataset` and do not exercise Paradox-backed `TSQLTable` or a
connection. Thus there is no current SQLDB fixture establishing index
ordering, BDE comparison behavior, miss cursor state, or provider errors.
`Locate` remains an unverified substitute, not an integration path.

The `alfls.db` schema metadata alone does not unblock the Table27
`spitzbas` producer: its source-table traversal, mode-dependent filtering,
row construction, ordering, and failure behavior still require a complete
contract. The producer calls `EmptyTable`; do not exercise it on this copy or
production data as part of this metadata-only reconciliation.
