# BDE / SQLDB indexed-lookup comparison matrix

## Purpose and scope

This is the evidence plan for a narrow synthetic-only comparison of the
legacy BDE operations used by the retained listings and the currently
available SQLDB lookup surface. It is not a general provider-conformance
claim, and it does not authorize enabling a legacy handler.

The authorized test directory is excluded from the first comparison. Its
metadata-only catalogue already establishes that Table13's `Ort_` index is
non-unique, ascending, and on `Ort`, with `DBWINUS0` (ASCII) language driver;
the seven observed test values happen to be distinct. Since those rows cannot
exercise duplicate-key behavior, a newly created synthetic fixture is the
correct test. Opening the authorized table would add no evidence for this
question.

## Consumer-backed cases

| Case | Listing consumer / evidence | Synthetic setup and operation | Observations required | Current status |
|---|---|---|---|---|
| Named non-unique index hit | Unit14 `ListBox1DblClick` / `ListBox1KeyPress`: `FindKey([selected Ort])` on Table13 index `Ort_`; Boolean is ignored | Artificial Paradox table with `Ort_` non-unique ascending index and at least two duplicate keys; `FindKey` with one complete field value | Boolean; immediate `BOF`, `EOF`, `RecNo`; whether first duplicate is selected; selected key ordinal only, never the synthetic string | Measured on BDE fixture; duplicate hit selected synthetic ID 1. |
| Named-index miss after `First` | Same Unit14 handlers; prior probe established a unique-index miss only | Same non-unique fixture; `First`, then a guaranteed absent complete key | Boolean and immediate cursor state; verify there is no read or write after the call | Measured on BDE fixture; miss retained the current synthetic ID 1 with `BOF=True`, `EOF=False`, `RecNo=1`. |
| Composite-index prefix hit | Unit15 `spitzbas`: Table18 `num` lookup and Table8 `vat`/`mut` lookups pass one key component to composite indexes | Existing synthetic BDE probe uses matching `MRG`/`AWD` shapes; inspect SQLDB's exposed lookup API without simulating prefix traversal | BDE first matching suffix tuple and cursor state; whether SQLDB exposes a named-index prefix operation. Do not claim equality if no such operation exists. | BDE measured; SQLDB `Locate` cannot express selected named-index prefix traversal. Not an adapter candidate. |
| Filtered primary-key miss/current row | Unit15 `spitzbas` `Sppr` path ignores the Table9 `FindKey` Boolean and then reads fields | Existing artificial filtered Table9 BDE fixture; equivalent SQLDB filter/query only if a consumer-matched operation is defined | Result, flags, current record identity, visibility under filter | BDE measured; SQLDB equivalent remains unresolved. Do not treat the stale-current-row state as a normal candidate result. |
| Closed/inactive dataset | No currently approved consumer invokes the selected lookup on a closed table; Unit14 activation populates the list from an open table first | Not run in Phase 1 unless a complete caller path demonstrates the state is reachable | Exception class/category and state only | Excluded: no consumer-backed need, and exact exception parity is not a reason to access real data. Preserve explicit errors. |
| Pending edit before lookup | No inspected target listing establishes a call to `FindKey` while a dataset is in edit/insert state | Not run until a specific caller proves this precondition | Whether navigation posts/cancels/raises, with synthetic fields only | Excluded from adapter contract; existing `TBufDataset` navigation test is SQLDB behavior, not evidence of BDE parity. |

## Comparison rules

1. Use newly created disposable fixtures only. Do not point either harness at
   `C:\ProgramData\AHNENWIN Test`.
2. BDE fixtures must declare the relevant named indexes explicitly; record
   index field order, uniqueness, collation, BDE module version, and only
   cursor metadata. Store no field values in output.
3. SQLDB fixtures must use a temporary database and equivalent field/index
   definitions. Record its actual operation (for example exact-field
   `Locate`) accurately; never call it a `FindKey` implementation.
4. Run matched cases only. If SQLDB has no operation equivalent to a BDE
   named-index prefix lookup, record “not representable through this API”;
   do not simulate it by fetching all rows or changing production code.
5. Keep fixture-creation writes separate from the lookup phase. Hash the
   closed fixture directory immediately before and after each lookup batch;
   any unexpected file change stops the run.
6. Do not implement or enable a facade until the matrix demonstrates a
   concrete, consumer-needed compatible operation. Preserve existing explicit
   `TTable.FindKey` rejection for all unproven cases.

## Supplementary authorized test-data reads

The user has also authorized read-only access to the existing test data, but
the metadata inventory already resolves Table13's index uniqueness and ASCII
collation, and its values contain no duplicate `Ort`. Therefore no authorized
table-open is necessary for the current matrix. A later metadata/read-only
probe must name the exact table/index/key and unanswered question first, use a
fresh recursive hash baseline and post-read comparison, set BDE read-only
before open, and log no record values. This scope does not authorize writes,
the original application, reports, or handler wiring.

## Expected deliverable and gate

The result will classify each matched operation as:

- **compatible within tested limits**;
- **incompatible**, with the concrete semantic difference; or
- **unresolved/not representable**, with the missing API or evidence named.

No production integration follows automatically. Relationship mutation,
Table27 rebuilding, Unit16 report output, and provider startup remain separate
blocked workstreams.

## Executed synthetic comparison — 2026-10-18

### BDE non-unique `Ort_` fixture

Added
`Source\AhnWin52\ReverseEngineering\Unit14NonUniqueFindKeyBDEProbe.dpr`.
It supports separate `--create` and `--probe <fixture-directory>` modes so
the Paradox table/index files can be SHA-256 inventoried between fixture
creation and read-only lookup. The fixture creates three artificial rows,
including two identical `Ort` keys with different integer IDs, then creates
the named non-unique ascending `Ort_` index. Delphi 9 compiler 17.0 ran
against BDE 5.2.0.2 (`IDAPI32.DLL`); both table/index language driver reads
reported `DBWINUS0`. The BDE network file was isolated in its own temporary
directory, outside the hashed table fixture.

Delphi 9's Paradox `TTable.AddIndex` required an index option for a named
single-field index whose name differs from the field. The fixture therefore
uses `ixCaseInsensitive`; `Ort_` remained non-unique and ascending. The
duplicate keys were byte-for-byte identical, so this probe does not establish
case-folding equivalence with the target index. The actual authorized Table13
catalogue says `Ort_` is non-unique, but does not expose its case-insensitive
flag.

Observed:

| Operation | Result | Immediate BDE state |
|---|---|---|
| `FindKey` for duplicate exact key | true; selected synthetic ID 1 | `BOF=False`, `EOF=False`, `RecNo=1` |
| `First`, then `FindKey` for absent exact key | false; current synthetic ID 1 retained | `BOF=True`, `EOF=False`, `RecNo=1` |

The four fixture files (`.db`, `.PX`, `.XG0`, `.YG0`) had identical SHA-256
inventories immediately before and after the read-only lookup batch (4/4
files; zero changes). Fixture and separate network directories were removed
after successful verification. The bounded output is persisted outside the
repository in the session artifact
`unit14-nonunique-findkey-bde-probe-2026-10-18.log`.

### SQLDB exact-field `Locate`

Extended `tst_AHW52_SQLDBLocateTests.pas` with
`SQLDBLocateMatchesDuplicateValueInQueryOrder`. It creates an in-memory
SQLite database through FPC SQLDB's `TSQLite3Connection` and `TSQLQuery`,
defines a non-unique index, and checks exact-field `Locate` on two duplicate
values. The query explicitly orders by integer ID. `Locate` found the first
matching query row (ID 1); after `First`, a missing value returned false and
retained ID 1 with `BOF=True`, `EOF=False`. This tests generic SQLDB
`TSQLQuery` behavior, not the externally compiled project `Cmp_SQLTable`
component. The focused SQLDB suite passes 4/4; the full FPCUnit suite passes
590/590.

### Classification

| Requested behavior | Classification | Reason |
|---|---|---|
| Exact full-field hit and miss on these fixtures | Compatible only within tested limits | Both returned hit/miss and the observed cursor flags/current row matched when SQLDB query order was explicitly fixed. |
| Duplicate exact-key winner | Not an index-parity result | BDE chose ID 1 in its index order; SQLDB chose ID 1 because the query explicitly ordered by ID. A different SQL query order can change the first match. |
| Named-index selection and composite key-prefix lookup (`num`, `vat`, `mut`) | Not represented by SQLDB `Locate` | `Locate` accepts exact field/value criteria and does not select a named BDE index or express a prefix of its ordered key components. Do not emulate this by enumerating rows or assuming SQLDB's default order. |
| Filtered Table9 stale-current-row case | Unresolved across providers | Synthetic BDE behavior is measured; no matched SQLDB operation reproduces the BDE filter/cursor contract. |
| Case sensitivity, locale/collation parity, exceptions, inactive state, pending edits | Unresolved or excluded | The fixture index used `ixCaseInsensitive`; these states were not consumer-required for this bounded comparison. |

This comparison does not justify a `FindKey` facade or legacy handler wiring.
The existing `TSQLTable.FindKey` compatibility stub continues to raise an
explicit unsupported-operation error. No authorized table was opened: the
matrix's remaining exact-key duplicate behavior was answerable with artificial
rows, and the existing test copy has no duplicate `Ort` values. The compiled
`Cmp_SQLTable` implementation source was not available in this source tree, so
the generic SQLDB query result must not be promoted to its component-specific
behavior.
