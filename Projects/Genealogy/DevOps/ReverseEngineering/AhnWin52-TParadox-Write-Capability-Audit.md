# Lazarus `TParadox` marriage-write capability audit

**Date:** 2026-10-18  
**Scope:** static review only. No Paradox table was opened or modified.

## User direction

The intended architecture is a virtual SQLDB-compatible provider backed by
Paradox: application and DataModule-facing code should use the common
`TSQL...`-style component/API surface, while the provider implementation
encapsulates Paradox and pxlib. A shared `TDBParadox` component was already
recorded as a future architecture item; the user has now confirmed that this
is the intended direction, rather than migrating application components
directly to raw `TParadox`.

SQLDB/SQLite remains a long-term concrete SQLDB target. Its marriage-pair
adapter and tests are preparation only and do not establish Paradox write
safety. The exact scope of SQLDB API compatibility, component ownership,
query support, and transaction semantics for the virtual provider is not yet
specified or implemented.

## Checked-in source mapping needs reconciliation

In the checked-in `GenealogyDataModule.pas` and `.lfm`, only `Table17` and
`Table18` are declared/streamed as `TParadox` under FPC. Marriage datasets
`Table5`, `Table10`, and `Table15` are still `TSQLTable` with `MRG.DB` as the
table name. `FPC\AHW52_Main.lpr` creates this data module, but does not replace
those components. Therefore the checked-in marriage-pair adapter currently targets the
SQLDB-backed `Table5` implementation, not the intended virtual
SQLDB-compatible Paradox provider. The latter is not represented in these
files yet. This is an implementation gap, not a decision to expose raw
`TParadox` to application code.

## Installed Lazarus/FPC `TParadox` capability evidence

The FPC 3.2.2 source at
`C:\lazarus\fpc\3.2.2\source\packages\fcl-db\src\paradox\paradox.pp`
implements `TParadox` as a `TDataSet` backed by pxlib.

- `InternalPost` calls `PX_put_recordn` for edits.
- For an insert, `InternalPost` calls `InternalAddRecord`.
- `InternalAddRecord` calls `PXAppendRecord`, whose current implementation
  has an empty body. This source therefore does not implement appending rows.
- The public/published `TParadox` surface has no begin/commit/rollback API.
- The FPC pxlib binding at
  `C:\lazarus\fpc\3.2.2\source\packages\pxlib\src\pxlib.pp` declares
  `PX_insert_record`, but `TParadox.PXAppendRecord` does not call it. No
  transaction API was found in that binding.

This is static evidence about the installed FPC source, not a runtime test of
the exact Lazarus binary, pxlib DLL, or any local fork. It establishes that
this `TParadox` implementation cannot be assumed to persist `Append`/`Post`
or provide the requested transaction boundary as currently written. A
virtual provider cannot simply wrap this class and inherit working writes;
its Paradox write and recovery mechanism must be separately implemented and
proved (for example, through a different pxlib path or a validated component
implementation).

## Consequence

Application and relationship code must remain provider-neutral: it receives
the data-module interface and generic dataset abstractions, and must not
inspect `TParadox`, pxlib, `TSQLTable`, or SQLDB update APIs. Provider-specific
field writes, flush behavior, and transaction handling belong behind
`IGenealogyDataModule` in the data-module implementation.

The interface now exposes `AppendMarriageRecord` with the domain record type.
`MarriagePairDataModuleAdapter` delegates to that operation and contains no
provider-unit dependency. The concrete data-module adapter still has a
SQLDB-specific implementation for the checked-in `Table5: TSQLTable` path;
it explicitly rejects other dataset providers rather than pretending they
can persist writes. This is a transitional implementation, not the intended
Paradox architecture and not a claim that current `TParadox` can append or
roll back records. Provider selection and transaction handling remain
encapsulated behind the DataModule interface.

Do not wire the marriage coordinator to raw `TParadox`, do not treat its
`Post` as a durable append, and do not imitate a transaction with an
unapproved compensating delete. The checked-in SQLDB-backed path is
transitional and its SQLite tests establish only that implementation's
synthetic behavior; it is not the intended Paradox provider. The previous
BDE protocol is not a substitute: Delphi BDE `TTable` and Lazarus/FPC
`TParadox` backed by pxlib are different providers and require separate
evidence.

## Next steps

1. Specify the virtual provider's supported SQLDB-compatible surface from
   actual application/DataModule usage (`TSQLTable`, query, field, index,
   filter, and transaction calls). Do not assume full SQLDB compatibility
   until each required operation is enumerated.
2. Design the shared Paradox provider/component boundary (the earlier
   `TDBParadox` direction): application code keeps the common `TSQL...`-style
   surface; the DataModule selects the implementation; Paradox/pxlib details
   remain private to that implementation. Establish whether this is a
   compatible subclass/component package or an adapter exposing the required
   dataset interfaces, without making the application depend on raw
   `TParadox`.
3. Before implementing the marriage pair writer, design a read/write
   capability test on a newly created synthetic Paradox fixture. Establish
   durable single-record append after close/reopen, then second-record
   failure behavior, file/index side effects, and the exact pxlib/runtime
   implementation. The installed `TParadox` source is not sufficient proof.
4. Separately establish the virtual provider's transaction/rollback contract.
   If pxlib offers no suitable native transaction, design and test an
   explicitly crash-safe strategy; a compensating delete alone is not
   evidence of atomicity. Keep `BeginTransaction`/`CommitTransaction`/
   `RollbackTransaction` implementation behind the DataModule interface.
5. Keep SQLDB/SQLite future-provider evidence, Paradox-provider evidence,
   and original BDE behavior separate. Keep legacy relationship UI writes
   blocked until the virtual provider demonstrates the complete reciprocal
   pair write and second-row-failure recovery on synthetic data.

## Non-claims

This audit does not prove that a particular runtime is using the exact FPC
source reviewed here, that pxlib lacks every possible undocumented mechanism,
or that BDE and SQLDB behavior matches TParadox. No production or authorized
genealogy data was accessed.
