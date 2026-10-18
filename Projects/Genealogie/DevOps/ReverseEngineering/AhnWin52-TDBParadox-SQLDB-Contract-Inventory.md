# `TDBParadox` SQLDB contract inventory

**Status:** the shared connection/package and strict SELECT parser now have a
read-only SQLDB cursor path for a small, explicit subset. `TSQLQuery` and the
project's `TSQLTable` both read the four-row artificial fixture through
pxlib 0.6.8 with exact value/order parity against BDE. Parameter predicates,
projections, and in-memory ordering are now implemented and tested against
that artificial fixture. Non-ASCII text, other field types, deleted-record
semantics, and all writes remain unsupported.

## Chosen target

The planned provider is a real FPC SQLDB `TSQLConnection` descendant in the
shared component source tree, backed by Paradox through a project-controlled
pxlib access layer. It is not a `TParadox` alias. Existing
`Cmp_SQLTable.TSQLTable` and standard `TSQLQuery` consumers must receive it
through SQLDB's normal `Database` and `Transaction` properties. Paradox
details must not escape into application code.

The eventual user-selected SQL surface includes `TSQLTable` selects and
parameterized single-table `TSQLQuery` queries (`WHERE` comparisons joined by
`AND`, plus `ORDER BY`). SQLDB-generated insert/update/delete statements are
in scope as the eventual DML interface, but they remain explicitly
unsupported until durable, crash-safe atomic write and recovery behavior is
demonstrated. The only currently implemented SQLDB transaction lifecycle is
the limited logical scope for read-only statements described below.

## SQLDB driver contract (FPC 3.2.2)

`TSQLConnection` is a driver base class, not just a path/container adapter.
The following abstract operations are required to instantiate a concrete
connection:

| Contract area | Required overrides |
|---|---|
| Cursor lifecycle | `AllocateCursorHandle`, `DeAllocateCursorHandle` |
| Statement lifecycle | `PrepareStatement`, `UnPrepareStatement`, `Execute` |
| Read cursor | `Fetch`, `AddFieldDefs`, `LoadField`, `LoadBlobIntoBuffer`, `FreeFldBuffers` |
| Transaction handle | `AllocateTransactionHandle`, `GetTransactionHandle`, `StartDBTransaction`, `Commit`, `RollBack`, `CommitRetaining`, `RollBackRetaining` |

The base class also provides virtual hooks for SQLDB-generated insert/update/
delete SQL (`ConstructInsertSQL`, `ConstructUpdateSQL`,
`ConstructDeleteSQL`, `ConstructRefreshSQL`), field-to-parameter updates,
rows-affected reporting, last-insert-id refresh, index metadata, and schema
information. These defaults must be checked against the selected SQL subset;
they must not be accepted merely because they compile.

SQLDB supplies a `TSQLCursor` base that holds prepared/selectable/type state.
It does not define a Paradox row cursor or transaction storage; those are
provider-owned. Parameters arrive as `TParams`; field metadata must populate
`TFieldDefs`; each fetched row must be converted into SQLDB's field buffers.
All cursor, pxlib document, blob and lock lifetimes require deterministic
cleanup on both success and exceptions.

`TSQLTransaction` delegates to the connection's transaction handle and
expects start, commit, rollback, retaining, and rollback-retaining behavior.
The provider currently implements only a **logical read-only SQLDB scope**
for this lifecycle: it tracks active/inactive state but performs no database
transaction, supplies no snapshot-isolation guarantee, and accepts no DML.
This limited behavior was explicitly selected so standard SQLDB readers can
open; it is not evidence or a promise of write rollback or atomicity.

## Existing project use found

### `Cmp_SQLTable.TSQLTable`

The shared `cmp_SQLTable.TSQLTable` derives from `TCustomSQLQuery`, so it
uses the normal SQLDB statement/cursor path and exposes `Database`,
`Transaction`, `TableName`, `IndexName`, `Indexes`, `Filter`, `Filtered`,
`MasterSource`, `MasterFields`, `ApplyUpdates`, and related query properties.
Its generated base query is `select * from <TableName>;`. Selecting one of
its declared indices generates a composite `ORDER BY`; changing an active
index closes, changes SQL, and reopens the dataset.

The table component's `Indexes` definitions are in-memory ordering
definitions. They do not prove that the provider can discover, create, update,
or persist Paradox secondary indexes.

The current DataModule LFM streams 36 `TSQLTable` components and one
`TSQLQuery` component. Table5, Table10 and Table15 name `MRG.DB`; Table17 and
Table18 are the separate direct-`TParadox` interim components under FPC.
Existing component names, persistent fields, master/detail bindings, and
filters must not be migrated automatically as part of the generic provider
work.

Observed LFM properties include:

- per-table `TableName`;
- `FilterOptions`, including one case-insensitive filter configuration;
- `MasterSource`/`MasterFields` on Table5, Table6 and Table7;
- persistent integer, string, memo, date/number and AutoInc field components;
- empty `Query1.SQL`, `FieldDefs`, and `Params` in the current LFM.

### Active reconstructed Pascal callsites

The current executable Pascal surface found in the bounded source search is
narrower than the archived Delphi listings:

- privacy-mode actions call `TDataSet.Locate` on Table1;
- the shared DataModule adapter uses `TSQLTable.ApplyUpdates(0)` only in its
  SQLDB-specific transitional marriage write implementation;
- a field-list helper opens and traverses a generic `TDataSet`;
- the relationship SQLDB/SQLite test adapter uses the standard dataset and
  transaction interfaces.

Many `FindKey`, `EmptyTable`, and write references in `frmAhnenWinMain.pas`
and `PersonSearchForm.pas` are retained decompiler/listing comments or inert
code, not evidence that the new provider should advertise those operations.
No provider may silently map BDE `FindKey` to `Locate`.

## pxlib capability evidence and gaps

The installed FPC binding declares and dynamically resolves these candidate
operations:

- open/create/close: `PX_open_file`, `PX_create_file`, `PX_close`;
- record reads: `PX_get_num_records`, `PX_get_record`, `PX_get_record2`;
- record writes: `PX_insert_record`, `PX_update_record`, `PX_delete_record`;
- primary index helpers: `PX_read_primary_index`, `PX_add_primary_index`,
  `PX_write_primary_index`;
- memo/blob-related open/read/write calls.

This is declaration/export evidence only. It does not prove ABI correctness
for the deployed DLL, durability, atomicity, memo correctness, index
maintenance, locking, or crash recovery. No native transaction API is
declared. The installed FPC `TParadox.PXAppendRecord` body is empty, so the
standard `TParadox` insert path cannot serve as evidence or implementation
for this provider's write path.

### Supplied x64 runtime probe — corrected ownership and schema lifecycle

The user-supplied `D:\Mir\Downloads\pxlib_x64.dll` was inspected and loaded
only in a standalone synthetic probe. It is PE x86-64, file version 0.6.8.0,
SHA-256
`14447F50B39C465D2893E463E33ED5E26DC443022F4514E9E916E1EB81DBD556`;
the DLL reports pxlib 0.6.8, build date 2020-04-18. It is not digitally
signed. Its named exports match 81 of 82 names dynamically requested by the
FPC 3.2.2 binding. The discrepancy is the graphic-data symbol:
the binding requests `PX_read_graphicdata`, while this DLL exports
`PX_read_grahicdata`. The provided source is in
`C:\Projekte\Cpp\pxlib-0.6.8\pxlib-0.6.8` and the archive
`D:\Mir\Downloads\pxlib-0.6.8.tar.gz` (SHA-256
`5F9B58A5C3D9E5E60FAAD16DFBC5172EE14AE57A978732378660C0F2C9E74EF9`).
The source header declares both spellings, while the source implementation
contains the correctly spelled function; this DLL export difference remains
a graphic-data limitation, not an explanation for the cleanup crash.

Static source inspection explains the earlier heap-corruption result:
`PX_create_fp` assigns the caller's `fields` array directly to the internal
header, and `PX_delete` frees that array and each `px_fname` through pxlib's
document allocator. The first probe passed a stack array and string literals,
so it violated this ownership contract. A corrected probe allocates both the
field array and field names through `Doc^.malloc`. With that input,
`PX_create_file` succeeded; `PX_close` then `PX_delete` completed; a fresh
document reopened the same empty table, reported exactly two field names
(`ID`, `LABEL`) and zero records, and again closed/deleted cleanly. This is
limited evidence that the candidate DLL and FPC binding can perform this
synthetic schema lifecycle when used with the source-indicated ownership
discipline. It does not establish record decoding, the full ABI, or general
provider correctness.

The flawed and corrected synthetic probe artifacts and stage logs, with
hashes, remain under
`C:\Users\Mir\.copilot\session-state\bc780dc9-be21-4e10-b7a2-0aab27abfe2f\files\dbparadox-fixture-20261018-2101\`.

Do not reuse the original stack-backed probe. Further calls are limited to
fresh, artificial fixtures and must allocate pxlib-owned inputs according to
the inspected source. The x86 DLL remains incompatible with the current
x86-64 build. Read-cursor implementation may proceed to the next
synthetic-record-read gate; write durability and transaction work remain
blocked.

### Synthetic record-read smoke test

The existing BDE probe executable created a synthetic `Table13.db` family
with `ID` and `Ort` fields. Its read-only hit/miss probe passed. A standalone
pxlib reader then used `PX_get_record`, `PX_get_data_long`, and
`PX_get_data_alpha` to decode three rows:

| Record number | ID | Ort |
|---:|---:|---|
| 0 | 1 | SyntheticDuplicate |
| 1 | 2 | SyntheticDuplicate |
| 2 | 3 | SyntheticOther |

It reported record size 44 and exited successfully after freeing the alpha
buffers through `Doc^.free` and closing/deleting the document. SHA-256
inventories of the four fixture files (`.db`, `.PX`, `.XG0`, `.YG0`) were
identical before and after the pxlib read. The full manifests are preserved
as `pxlib-read-before.json` and `pxlib-read-after.json` beside the run log in
the session artifacts.

The initially expected fourth row was not a pxlib omission: the prebuilt
`Unit14NonUniqueFindKeyBDEProbe.exe` used to generate this table is older than
its checked-in source (`14:41` versus `18:20` on 2026-10-18), so it did not
run the later fourth-row fixture revision. Its BDE probe confirms only its
own older duplicate-hit/miss cases, not a complete BDE row-count oracle. The
pxlib smoke test establishes successful raw decoding for the three rows it
reported, but not complete cross-provider row parity.

Source inspection found that pxlib 0.6.8 `PX_open_file` calls
`fopen(filename, "rb+")`, even for reads. A follow-up used the same
`msvcrt.dll` imported by pxlib to open the synthetic table as `"rb"` and
passed that `FILE*` to `PX_open_fp`. It decoded the same three rows,
completed `PX_close`, `fclose`, and `PX_delete`, and left the complete
four-file SHA-256 inventory unchanged. This validates the explicit read-only
stream path for this fixture; ordinary `PX_open_file` is not an
OS-level read-only open and must not be used to claim one. No real table was
opened.

Secondary-index creation and update capability remains specifically
unproven. SQL `ORDER BY` can be evaluated in memory only if that algorithm,
collation, null ordering and duplicate-key stability are explicitly defined
and tested; that would not constitute a writable Paradox secondary index or
BDE `FindKey` parity.

### Current four-row BDE/pxlib parity gate — passed

Rebuilt the current artificial BDE fixture probe from
`Source\AhnWin52\ReverseEngineering\Unit14NonUniqueFindKeyBDEProbe.dpr`
with Delphi 9, then created a fresh four-row `Table13.db` fixture containing
only `ID` and `Ort`. A read-only BDE reopen traversed the complete primary
key sequence:

| Position | ID | Ort |
|---:|---:|---|
| 0 | 1 | SyntheticDuplicate |
| 1 | 2 | SyntheticDuplicate |
| 2 | 3 | SyntheticOther |
| 3 | 4 | SyntheticOtherCase |

The same fixture was opened with pxlib 0.6.8 through `PX_open_fp`, using an
`msvcrt.dll` `fopen(..., "rb")` stream. The probe asserted field metadata,
record size, count, and every value at each zero-based position against the
expected sequence. Both probes passed; all four `.db`/`.PX`/`.XG0`/`.YG0`
SHA-256 hashes were identical before and after each read. BDE additionally
passed the synthetic `Ort_` duplicate hit, case-variant hit, and miss cursor
checks. Probe logs and before/after manifests are retained under the local
session artifact directory `files\dbparadox-bde-read-fixture-20261018`.

This resolves the earlier stale-fixture uncertainty: the old three-row probe
was not a parity comparison, while this exact current fixture establishes
record count, order, and values for these two artificial field types. It does
not establish decoding of other Paradox types, deleted-record behavior,
secondary-index ordering, collation parity, field nulls, or concurrent access.
The subsequent SQLDB integration was tested separately as described below;
all write and atomic-transaction gates remain closed.

## Compatibility status

| Feature | Status |
|---|---|
| SQLDB `TSQLConnection` class shape | Implemented as a read-only provider for the limited subset below |
| `TSQLTable` base `SELECT * FROM table` | Implemented and tested on the synthetic four-row fixture |
| In-memory `TSQLTable.Indexes` → composite `ORDER BY` | Implemented; tested ordering is an in-memory ASCII-byte comparison, not BDE/index parity |
| Parameterized single-table `TSQLQuery` projection/filter/order | Implemented for supported fields and comparisons; artificial fixture tests cover operators, `AND`, and ordering |
| SQLDB field metadata and row-buffer conversion | Implemented/tested for ASCII `pxfAlpha` and `pxfLong` only |
| `TDataSet.Locate` behavior | Not established for this provider |
| BDE `FindKey`/prefix semantics | Explicitly unsupported until separately proven |
| SQLDB-generated DML | Deferred behind durable pxlib write evidence |
| Read-only `TSQLTransaction` lifecycle | Logical state only; no locking or snapshot guarantee |
| Write `TSQLTransaction` / commit / rollback | Deferred behind crash-safe atomic recovery proof |
| Memo/blob write fidelity | Unknown |
| Paradox secondary-index mutation | Unknown |
| Full arbitrary SQL / joins / DDL | Out of scope; must fail explicitly |

## Next design/implementation gates

1. Generate a separate artificial BDE fixture that explicitly contains
   nullable fields and a deleted record. Record only fixture structure,
   expected synthetic row identities, and pre/post file-family hashes. Probe
   read-only BDE and pxlib on that exact fixture to establish NULL decoding
   and deleted-row enumeration before changing provider behavior.
2. Use the fixture evidence to choose and test an explicit SQLDB NULL contract
   (including predicate and sort behavior); keep deleted-record behavior
   explicitly rejected if pxlib cannot distinguish deleted slots reliably.
3. Continue synthetic error/lifecycle coverage for unsupported field types,
   open failures, and cursor cleanup. Do not infer broader BDE or SQLDB parity
   from the current subset.
4. Keep the shared package unregistered from the application until the
   supported component surface and its explicit rejection behavior are
   independently reviewed.
5. Independently prove pxlib writes on artificial fixtures. Design the
   crash-safe journal/recovery transaction contract and fault-inject every
   commit boundary before implementing SQLDB write hooks.
6. Only after passing both read and write gates, package/register the provider
   and separately migrate DataModule components one table at a time.

No authorized genealogy data, production table, original executable, UI,
report, or write route was accessed for this inventory.

## Read-only SQLDB cursor implementation checkpoint

`TDBParadoxConnection` now loads the configured pxlib 0.6.8 DLL, resolves
tables only beneath `DatabaseName` (configured as the data directory), and
opens each `.DB` through `msvcrt` `fopen(..., "rb")` plus `PX_open_fp`.
Cursor cleanup closes the pxlib document and C stream deterministically.
Active connections share one loaded pxlib runtime path and serialize pxlib
calls; a different DLL cannot be loaded while a connection is active.

The executable statement subset is a single-table
`SELECT <field-list>|* FROM <table>` with optional parameter comparisons
(`=`, `<>`, `<`, `<=`, `>`, `>=`) joined by `AND`, and optional composite
`ORDER BY` terms with `ASC`/`DESC`. Only ASCII `pxfAlpha` and `pxfLong`
values can be projected, filtered, or ordered; a projection decodes only its
selected, predicate, and ordering fields. Alpha comparison is case-sensitive
lexicographic byte order, and equal sort keys use ascending physical record
number as a deterministic tie-breaker. This is an implementation policy,
not BDE collation or secondary-index parity. Null predicate behavior, null
ordering, non-ASCII/code-page conversion, memo/blob, other field types,
deleted-record semantics, DML and write transactions are not claimed. SQLDB
transaction methods only track the logical read-only-scope lifecycle selected
by the user; they provide no database locking, repeatable-read or snapshot
semantics.

## Staged write transaction direction — selected process-level guarantee

The user selected an **in-memory staged-write model** for the near-term
provider, with rollback on ordinary in-process write failures. Process crash,
power loss, and operating-system failure during commit are explicitly outside
this guarantee. This is not a native Paradox transaction and must not be
described as crash-safe or durable atomicity.

The intended SQLDB boundary is:

1. `StartDBTransaction` creates a transaction-owned write set. Insert, update,
   and delete requests are validated and staged in memory; no Paradox bytes
   are changed before commit.
2. Reads in that transaction merge the committed base rows with its pending
   changes (read-your-writes). Rollback discards the pending set. Other
   transactions must not see uncommitted rows.
3. Commit first validates the whole write set, captures the required
   before-images and affected file-family state, then applies the write set.
   If an ordinary operation fails, the provider compensates already-applied
   operations in reverse order. A successful compensation restores the
   pre-commit state and returns an explicit commit error; it must not report
   success.
4. If compensation itself fails, the provider reports both the original and
   compensation failures, marks the connection/table state as uncertain, and
   rejects further writes until closed and checked. It must never return a
   success-shaped rollback result.
5. Concurrent writers to the same Paradox family are rejected until locking
   and conflict detection are independently proven. In-memory staging does
   not prevent another process from modifying the table.

This is a design choice, **not implemented write support**. Before enabling
SQLDB DML, synthetic pxlib evidence must prove the exact insert/update/delete
effects and whether compensation can restore every affected `.DB`, `.PX`,
`.XG*`, `.YG*`, and memo/blob file. In particular, the pxlib 0.6.8 update and
delete paths delete associated blob data before replacing/removing a record;
the current provider cannot compensate that effect. Secondary-index
maintenance is also unproven. Therefore writes to blob-bearing tables and
tables with unverified index families remain rejected even within this
process-level model.

A provider-neutral prototype now exists in
`Components\Source\DBParadoxWriteBuffer.pas`. It stages insert/update/delete
byte images, assigns temporary negative row IDs to inserts, resolves staged
rows for read-your-writes, discards changes on rollback, and asks the target
to validate the complete change set before applying it. Apply failures
trigger reverse-order compensation; compensation failures poison the buffer.
Fake-target tests cover those state transitions and verify that failed
preflight, including a stale before-image, causes no apply calls.
Staged byte images are copied at the buffer boundary, and a temporary-row
update/delete must provide the current staged before-image.

This prototype is not yet a complete transaction engine: it is not connected
to SQLDB, `TDBParadoxConnection`, pxlib, or a table-row enumerator; it does not
parse/encode Paradox records, lock files, protect secondary indexes or memo
files, or provide crash recovery. A future target must validate the whole
batch without mutation, make each apply all-or-unchanged, and compensate the
exact prior state from its opaque undo token. The fake store demonstrates
only the buffer protocol; it does not prove any pxlib property.

The implementation is registered in `DBParadox.lpk` and the test runner.
Validation: package and test-project builds succeeded; the focused buffer
suite passed **10/10**; the complete FPCUnit suite passed **676/676** with the
synthetic pxlib fixture configured (zero ignored tests). These results verify
the provider-neutral buffer contract only.

Next, finish the separate pxlib read-contract gate (NULL and deleted-record
behavior), then prove pxlib record writes and compensation on fresh artificial
fixtures. Only after those independent gates pass may the buffer be connected
to SQLDB-generated DML and logical `TSQLTransaction` hooks. The existing
SQLite marriage-pair adapter remains separate; no legacy UI or DataModule
write is enabled here.

The fixture integration suite uses
`DBPARADOX_TEST_FIXTURE_DIR` and `DBPARADOX_TEST_PXLIB`; without these
environment variables its runtime-dependent cases are marked ignored. With
the fresh artificial four-row BDE fixture and supplied x64 pxlib 0.6.8 DLL,
the focused suite passed **12/12**. Tests cover `TSQLQuery` and project
`TSQLTable` reads, a selected-field projection, all six integer comparison
operators, ASCII string equality, conjunction, empty results, mixed
ascending/descending sort terms, and stable ordering of equal keys. A
string-to-integer parameter mismatch, an unknown selected field, and a table
path traversal attempt all fail explicitly; after the invalid-field failure,
the connection is closed and successfully reused, proving the cursor is
released. Existing full-row tests still assert the exact expected values and
physical row sequence.
Pre/post SHA-256 comparisons of all four Paradox-family files were identical
in the earlier parity run; this latest test run also used the same artificial
fixture and performed no writes. After adding the `TSQLTable` composite-index
ordering and error-path cases, the complete FPCUnit suite passed **666/666** with the pxlib
integration tests enabled, and all four fixture-file SHA-256 hashes were
unchanged.
The `DBParadox` Lazarus package and FPCUnit project both built.

This is a first read-only execution slice, not a general SQLDB-compatible
provider. No authorized genealogy data, production table, original
executable, UI, report, or write route was accessed.
