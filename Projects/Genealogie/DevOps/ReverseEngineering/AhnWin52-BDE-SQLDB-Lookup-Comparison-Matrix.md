# BDE / SQLDB indexed-lookup comparison matrix

## Purpose and scope

This is the evidence plan for a narrow synthetic-only comparison of the
legacy BDE operations used by the retained listings and available candidate
lookup APIs. The generic SQLDB `TSQLQuery.Locate` test is only one candidate;
it does not characterize the project-specific `Cmp_SQLTable.TSQLTable`
surface. This is not a general provider-conformance claim, and it does not
authorize enabling a legacy handler.

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
| Composite-index prefix hit | Unit15 `spitzbas`: Table18 `num` lookup and Table8 `vat`/`mut` lookups pass one key component to composite indexes | Synthetic SQLDB query ordered by `(father, birth_year, birth_month, birth_day)`; call `Locate('father', value)` with repeated father values and distinct date suffixes | First matching row in composite order and miss/current-row state after `First` | The synthetic `TSQLQuery` test found the first matching father-prefix row in the explicit composite `ORDER BY` order; after `First`, an absent father prefix returned false and retained the first row with `BOF=True`, `EOF=False`, matching the tested BDE prefix hit/miss shape. This demonstrates the proposed ordering strategy for generic SQLDB query results, not an implicit named-index feature on `TSQLTable`. |
| Filtered primary-key miss/current row | Unit15 `spitzbas` `Sppr` path ignores the Table9 `FindKey` Boolean and then reads fields | Existing artificial filtered Table9 BDE fixture; equivalent SQLDB filter/query only if a consumer-matched operation is defined | Result, flags, current record identity, visibility under filter | BDE measured; SQLDB equivalent remains unresolved. Do not treat the stale-current-row state as a normal candidate result. |
| Table9 `vat`/`mut` composite-prefix miss | Relationship lookups use the first parent-number component of these date-suffixed indexes; the caller's post-miss action is not generalized here | Synthetic Table9-shaped `AWD.DB`; on each index call `First`, then `FindKey([777])` with no matching parent number | Boolean and immediate `BOF`/`EOF`/`RecNo`/current synthetic identity | Measured on BDE 5.2.0.2: both misses returned false, retained the `First` row (`Nummer=100`, `RecNo=1`), and reported `BOF=True`, `EOF=False`. This does not establish another runtime's tie/order choice or SQLDB parity. |
| Closed/inactive dataset | No currently approved consumer invokes the selected lookup on a closed table; Unit14 activation populates the list from an open table first | Not run in Phase 1 unless a complete caller path demonstrates the state is reachable | Exception class/category and state only | Excluded: no consumer-backed need, and exact exception parity is not a reason to access real data. Preserve explicit errors. |
| Pending edit before lookup | No inspected target listing establishes a call to `FindKey` while a dataset is in edit/insert state | Not run until a specific caller proves this precondition | Whether navigation posts/cancels/raises, with synthetic fields only | Excluded from adapter contract; existing `TBufDataset` navigation test is SQLDB behavior, not evidence of BDE parity. |

## Comparison rules

1. Use newly created disposable fixtures only. Do not point either harness at
   `C:\ProgramData\AHNENWIN Test`.
2. BDE fixtures must declare the relevant named indexes explicitly; record
   index field order, uniqueness, collation, BDE module version, and only
   cursor metadata. Store no field values in output.
3. Candidate SQLDB fixtures must use a temporary database and equivalent
   field/index definitions. Test the actual exposed operation. The generic
   `TSQLQuery.Locate` result is not a substitute for a component-specific
   `Index`/`Seek`/`NoMatch` result; record exact method and flags, never infer
   equivalence from API names alone.
4. Run matched cases only. A named-index prefix operation may be represented
   by a query ordered on the full index field list plus an exact `Locate` on
   its leading key field; verify the generated query order, duplicate choice,
   collation, and miss/cursor state rather than inferring them from the API
   name. Do not emulate BDE behavior by fetching rows in an unspecified order.
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
creation and read-only lookup. The fixture creates four artificial rows,
including two identical `Ort` keys with different integer IDs and a separate
mixed-case lookup target, then creates
the named non-unique ascending `Ort_` index. Delphi 9 compiler 17.0 ran
against BDE 5.2.0.2 (`IDAPI32.DLL`); both table/index language driver reads
reported `DBWINUS0`. The BDE network file was isolated in its own temporary
directory, outside the hashed table fixture.

Delphi 9's Paradox `TTable.AddIndex` required an index option for a named
single-field index whose name differs from the field. The fixture therefore
uses `ixCaseInsensitive`; `Ort_` remained non-unique and ascending. A separate
lower-case `FindKey` query for the mixed-case synthetic target returned its
row, as expected from the fixture option. The actual authorized Table13
catalogue says `Ort_` is non-unique, but does not expose its case-insensitive
flag, so this does not establish target-index case behavior.

Observed:

| Operation | Result | Immediate BDE state |
|---|---|---|
| `FindKey` for duplicate exact key | true; selected synthetic ID 1 | `BOF=False`, `EOF=False`, `RecNo=1` |
| `FindKey` for lower-case variant on the case-insensitive fixture index | true; selected synthetic ID 4 | `BOF=False`, `EOF=False`, `RecNo=4` |
| `First`, then `FindKey` for absent exact key | false; current synthetic ID 1 retained | `BOF=True`, `EOF=False`, `RecNo=1` |

The four fixture files (`.db`, `.PX`, `.XG0`, `.YG0`) had identical SHA-256
inventories immediately before and after the read-only lookup batch (4/4
files; zero changes). Fixture, network directory, and temporary compiler
output were removed after successful verification. The original and
follow-up bounded results are persisted outside the repository in the session
artifact `unit14-nonunique-findkey-bde-probe-2026-10-18.log`; the case variant
follow-up used BDE 5.2.0.2 and the four-file read-only hash diff was zero.

### SQLDB exact-field `Locate`

Extended `tst_AHW52_SQLDBLocateTests.pas` with
`SQLDBLocateMatchesDuplicateValueInQueryOrder`. It creates an in-memory
SQLite database through FPC SQLDB's `TSQLite3Connection` and `TSQLQuery`,
defines a non-unique index, and checks exact-field `Locate` on two duplicate
values. The query explicitly orders by integer ID. `Locate` found the first
matching query row (ID 1); after `First`, a missing value returned false and
retained ID 1 with `BOF=True`, `EOF=False`. This tests generic SQLDB `TSQLQuery` behavior, not the
`Cmp_SQLTable.TSQLTable` wrapper. The focused SQLDB suite passes 4/4; the full
FPCUnit suite passes 590/590 at that earlier checkpoint.

### Classification

| Requested behavior | Classification | Reason |
|---|---|---|
| Exact full-field hit and miss on these fixtures | Compatible only within tested limits | Both returned hit/miss and the observed cursor flags/current row matched when SQLDB query order was explicitly fixed. |
| Duplicate exact-key winner | Not an index-parity result | BDE chose ID 1 in its index order; SQLDB chose ID 1 because the query explicitly ordered by ID. A different SQL query order can change the first match. |
| Composite key-prefix lookup with explicit ordering (`num`, `vat`, `mut`) | Compatible for the tested generic SQLDB `TSQLQuery` scenario | An explicit `ORDER BY` over the complete composite key followed by `Locate` on its leading field selected the first matching prefix row; a miss after `First` retained the current first row with `BOF=True`, `EOF=False`. Tied suffix order, collation, filters, and provider exceptions remain untested. |
| Filtered composite-prefix lookup | Compatible in the matched synthetic call shape only | BDE and `TSQLTable`/SQLite both skipped an excluded row that sorted before the eligible matching row; the absent-prefix miss after `First` retained the current visible row with `BOF=True`, `EOF=False`. This does not prove all filter expressions or providers. |
| Case sensitivity / collation | Candidate behavior measured, target parity unresolved | BDE `FindKey` found a lower-case key value on the synthetic `ixCaseInsensitive` index. `TSQLTable.Locate` was case-sensitive with `[]` and found it with `[loCaseInsensitive]`. The authorized target index's case-insensitive flag and exact cross-provider behavior are still unknown. |
| Exceptions, inactive state, pending edits | Unresolved or excluded | These states were not required by this bounded lookup comparison. |

### Authorized Table13 index-option read — blocked at open

Added `Source\AhnWin52\ReverseEngineering\Table13IndexOptionBDEProbe.dpr`,
a metadata-only probe restricted to `LOC.db` and the named `Ort_` index. It
would report only field/index identity, index flags, language driver, and
read-only status; it does not traverse records or read field values.

A fresh 170-file SHA-256/timestamp inventory was taken at
`files\table13-index-option-20261018-1829\preflight-inventory.json`
(manifest SHA-256
`64BAA4DBEE7E22DA583E6DF239B51AB68D1B6A4BD1B35E07A03BD5B1806C6775`).
No `AHNWIN51.exe` process was running. The BDE open failed before index
enumeration with `EDBEngineError` / password required. No field or index
metadata was returned and no records were read. The complete postflight
inventory matches the preflight across all 170 files by path, size,
timestamp, and SHA-256 (zero differences). The required local
`AHNWIN52_BDE_PASSWORD` environment variable was not present in the probe
process; do not put the password into source, command-line arguments, logs,
or chat. The target `Ort_` case-sensitivity flag therefore remains unresolved.

This comparison does not by itself justify a `FindKey` facade or legacy
handler wiring. The existing `TSQLTable.FindKey` compatibility stub continues
to raise an explicit unsupported-operation error. No authorized table was
opened: the relevant ordering and duplicate cases were answerable with
artificial rows, and the existing test copy has no duplicate `Ort` values.

### SQLDB composite-order prefix hypothesis — tested synthetic case

The user proposed selecting the full composite index order and then calling
`Locate` on its leading field as the SQLDB equivalent of a BDE one-field
`FindKey` prefix. Added
`SQLDBLocateUsesCompositeIndexOrderForPrefix` to
`tst_AHW52_SQLDBLocateTests.pas`. Its SQLite fixture inserts rows out of
order, defines `(father, birth_year, birth_month, birth_day)`, opens a query
with that exact `ORDER BY`, and calls `Locate('father', 100)`. It selected the
first row in composite order (synthetic ID 20) among the duplicate father
values. After `First`, a missing prefix returned false and retained that row
with `BOF=True`, `EOF=False`. Focused SQLDB tests pass 5/5.

This validates the proposed strategy in the tested generic `TSQLQuery`
case: with a deterministic ordered result, `Locate` can find the first
matching leading-key value, and the tested miss state matches the BDE
`FindKey` call shape. It does not prove equal-suffix tie order, collation/
case behavior, filtering parity, or other error states.

The user's `Cmp_SQLTable` source is available at
`C:\Projekte\Delphi\Components\Source\SQLTable\cmp_SQLTable.pas`. It declares
`TSQLTable = class(TCustomSQLQuery)` and originally generated an unordered
`select * from <table>;` in its `TableName` setter. The wrapper did not
originally define an `Index`-to-`ORDER BY` mapping. The synthetic integration
added below verifies the new component behavior; it does not establish BDE
parity beyond the tested SQLDB call shape.

### `TSQLTable` named-index ordering — synthetic integration

Extended `TSQLTable` with an `Indexes` collection and an
`IndexName` property. Define entries using
`Table.Indexes.Add('vat', 'father;birth_year;birth_month;birth_day')`; optional
descending fields can be supplied as the third argument, for example
`Table.Indexes.Add('vat_desc', 'father;birth_year;birth_month', 'birth_year')`.
Selecting the name generates `ORDER BY` in the declared field order. Changing
`IndexName` while active closes, rebuilds, and reopens the query. Unknown
names and malformed field/direction specifications raise `EDatabaseError`;
only bare SQL identifiers are accepted as index fields.

The SQLite-backed `TSQLTable` tests prove ascending composite prefix lookup, active index
switching, descending-field order, explicit rejection of unknown/malformed
definitions, and filtered prefix behavior. In the filter fixture, the ordered
prefix lookup skipped an excluded earlier row and selected the first eligible
row; an absent prefix retained the current visible row and reported
`BOF=True`, `EOF=False`. The focused SQLDB suite passes 9/9. This tests
`TSQLTable` against synthetic SQLite rows, not Paradox/BDE collation, suffix
ties, or provider exception parity. SQLDB local `Filter` behavior is now
measured for this call shape, but no general BDE filter parity is implied.
`SQLTableLocateCaseSensitivityIsExplicit` confirms that SQLDB's default
`Locate(..., [])` misses a case variant while `[loCaseInsensitive]` finds it.
A synthetic BDE `ixCaseInsensitive` `FindKey` likewise found the case variant.
This identifies a default-behavior mismatch for those fixture options, not
proof of the authorized `Ort_` index flags or all text collations. The full
FPCUnit suite passes 596/596. The `FindKey` compatibility stub and production
handler gates remain unchanged.

### Synthetic Table9 `vat`/`mut` miss-state probe — 2026-10-18

The separate
`Source\AhnWin52\ReverseEngineering\Table9ParentReferenceBDEBlackBoxProbe.dpr`
now asserts an absent one-component prefix lookup on both Table9-shaped
composite indexes after `First`. On BDE 5.2.0.2, both returned false while
retaining the row selected immediately before lookup (`Nummer=100`,
`RecNo=1`) and reporting `BOF=True`, `EOF=False`. The probe ran after a
read-only reopen and completed with `RESULT=PASS` and `FIXTURE_CLEANUP=PASS`.
This is a fixture-specific cursor observation; it does not characterize
SQLDB, error paths, other BDE versions, or what an application caller should
do after a miss.

## Provider-neutral cursor-aware contract — 2026-10-18

Added `Source\AhnWin52\IndexedSeekContract.pas` as an explicit, provider-
neutral boundary for a future named-index leading-prefix lookup. Its request
retains the index name and ordered scalar key values. Its result separates
hit/miss from the immediate `BOF`/`EOF` flags and current-row identity
(`known record ordinal`, `no current row`, or `identity unavailable`).
The ordinal is a dataset position such as `RecNo`, not a genealogy/domain
identifier. Contract validation rejects empty index/key requests,
unsupported/non-scalar variant values, and inconsistent current-row result
states.

`IIndexedSeekProvider.LookupIndexPrefix` has no implementation in this
change. `ExecuteIndexedSeek` validates the request and response and lets
provider exceptions propagate. The contract explicitly distinguishes
unavailable/unsupported conditions from a normal miss. The existing
`IIndexedLookupProvider` remains unchanged and cursorless, returning ordered
candidate record numbers for selection; these two abstractions must not be
collapsed.

The new artificial suite passes 18/18, including the measured BDE-shaped miss
with a retained current row (`BOF=True`, `EOF=False`), a miss with no current
row, unavailable identity, invalid result states, and propagated provider
errors/unsupported semantics. The existing cursorless provider suite still
passes 15/15. These tests validate only request/result invariants and error
propagation; they do not execute a dataset, SQL statement, or provider.

**Still unresolved:** precise key conversion for each real consumer, index
definition/selection availability, target collation and equal-key order,
closed/inactive and edit-state behavior, concrete provider exceptions, and
whether an implementation can report row identity consistently. No
`TSQLTable` adapter, BDE `Seek`/`NoMatch` facade, `FindKey` compatibility
change, legacy-handler wiring, or authorized-data access follows from this
contract. `FindKey` remains explicitly unsupported.
