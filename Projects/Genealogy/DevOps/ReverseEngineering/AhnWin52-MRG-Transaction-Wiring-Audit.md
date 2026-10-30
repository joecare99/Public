# MRG transaction wiring audit

**Date:** 2026-10-18  
**Scope:** static inspection of the reconstructed Lazarus data module; no
database was opened and no legacy UI route was executed. SQLDB is a
long-term target, not the current provider direction.

## Findings

- `GenealogyDataModule.lfm` streams `Table5` as a `TSQLTable` for `MRG.DB`.
  It has `MasterSource = DataSource1` and `MasterFields = 'Nummer'`.
- The same LFM also streams `Table10` and `Table15` as `TSQLTable`
  components for `MRG.DB`. This establishes multiple dataset components for
  the same logical table, but does not establish whether they share a
  connection or transaction at runtime.
- The LFM contains no SQL connection or transaction component and no
  `Database`/`Transaction` assignments for these datasets. A repository-wide
  source search found no runtime assignment to `Table5.Database`,
  `Table5.Transaction`, `Table10.Transaction`, or `Table15.Transaction`.
- `TGenealogyDataModule.InitializeDataAccess` configures only the FPC
  `Table17`/`Table18` Paradox files and optional pxlib path. It does not
  configure the SQLDB tables.
- The current Lazarus startup, `FPC\AHW52_Main.lpr`, creates the data module,
  calls `InitializeDataAccess`, then registers the genealogy interfaces. It
  does not configure a SQLDB connection or transaction before those steps.
  The separate `FPC\AHNWIN52.dpr` is not the current startup path used by
  `AHW52_Main.lpi`.
- The new data-module adapter resolves every transaction operation from
  `Table5.Transaction`. `BeginTransaction` starts it only when inactive; if
  it is already active, the coordinator continues in that existing
  transaction, and its commit or rollback consequently applies to that
  whole transaction.

## Consequence for the future SQLDB target

The SQLite test proves reciprocal-row rollback when the synthetic Table5
transaction is used. It does not establish transaction ownership or isolation
from another dataset's pending updates. Because the streamed component file
does not show the runtime SQLDB connection/transaction wiring, the current
application's actual transaction scope cannot be established from these
sources. The marriage-pair adapter must remain unwired to production routes.

These observations are retained as preparation for a future SQLDB integration.
They are not the current implementation gate after the user's clarification
that present Lazarus work targets `TParadox`.

The application-facing `IGenealogyDataModule` now also exposes the
provider-neutral `AppendMarriageRecord` operation. Relationship code no
longer maps provider fields or calls SQLDB `ApplyUpdates`; that work remains
inside the concrete data-module adapter, which currently accepts only the
checked-in SQLDB Table5 implementation and fails explicitly for other
providers.

## Future SQLDB next steps

1. When SQLDB integration begins, reconstruct and document its runtime
   connection setup for
   `Table5`, `Table10`, and `Table15`, including who creates/activates the
   connection and transaction and whether the datasets share either object.
   Do not infer this from matching `TableName` values.
2. Once the real provider and lifecycle are known, add a focused synthetic
   isolation test: leave an unrelated write pending, perform a marriage-pair
   success and failure, and verify the pair operation neither commits nor
   rolls back that unrelated work.
3. Select a provider-supported boundary that passes the isolation test
   (for example, a separately owned transaction or a verified nested/savepoint
   scope). If the selected provider cannot provide one while Table5 is active,
   keep writes blocked and revise the adapter contract rather than silently
   committing an ambient transaction.
4. Separately prepare and request explicit approval for the BDE/Paradox
   synthetic probe described in
   `AhnWin52-MRG-Transaction-Observation-Protocol.md`. Do not run it against
   application or authorized genealogy data.
5. Only after both transaction ownership/isolation and target-provider
   rollback are demonstrated should the existing-person and new-person UI
   routes be considered for migration.

## Result

This audit closes the static wiring question only: the checked-in streamed
form, current startup, and Pascal source do not show SQLDB
connection/transaction assignments. It does not prove that no external
runtime configuration exists. Locating such configuration is now a blocker
requiring a path or deployment detail not present in the checked-in source.
