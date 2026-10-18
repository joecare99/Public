# BDE/Paradox MRG pair-transaction probe — preparation only

**Status:** protocol prepared; execution is not authorized by this document.

## Question

Can the installed BDE/Paradox provider roll back a `MRG.DB`-shaped row that
was successfully posted inside a transaction when the reciprocal post fails?
This question is separate from the SQLDB/SQLite adapter tests. It does not
test the original application, its UI handlers, or any genealogy data.

## Current evidence boundary

`IGenealogyDataModule` now exposes begin/commit/rollback, and the SQLDB
`TGenealogyDataModuleAdapter` delegates those calls to the transaction
associated with `Table5`. The provider-free marriage-pair coordinator and
the SQLDB adapter have separate synthetic tests. SQLDB/SQLite has demonstrated
that an injected failure on the second row leaves no row after rollback.

The original Delphi application used BDE. That runtime has not been shown to
support the same transaction boundary for Paradox tables. The result must
therefore remain unknown until the exact test below is separately approved
and run. Do not substitute the authorized test directory or an original
application launch.

## Required approval before execution

Before starting any executable, obtain explicit approval for:

- the exact compiled probe path and SHA-256;
- the exact installed Delphi/BDE runtime and version;
- one newly created disposable fixture directory and its external backup;
- the selected artificial fault-injection mechanism; and
- the exact run, cleanup, and post-run comparison.

If any item differs from the approved values, stop and request approval
again. Do not run this probe against `C:\ProgramData\AHNENWIN Test`, any
production path, or an AhnWin application process.

## Fixture and backups

1. Create a new path of the form
   `%TEMP%\AhnWin52-MRG-transaction-<fresh-id>`. It must not already exist;
   do not reuse a prior fixture directory.
2. Configure a private BDE session directory and network-control directory
   inside that fixture. Use no system-wide `PDOXUSRS.NET` or pre-existing
   Paradox files.
3. Create only artificial data. The table schema should contain `Numr`,
   `Nummer`, `Epnum`, and the 18 marriage detail fields used by
   `TMarriageDetails`. Use small synthetic endpoint numbers such as 101 and
   202 and synthetic text only.
4. For the failure fixture only, add a clearly test-only unique secondary
   index on an existing field populated identically in both reciprocal rows
   (for example `Verbind`). This deliberately makes the second provider
   `Post` fail after the first row has posted. Record that this index is not a
   claim about the original MRG index definitions or marriage constraints.
5. Close the table and capture a recursive manifest outside the fixture
   containing relative path, file size, timestamp, and SHA-256 for every
   fixture file. Make a byte-for-byte copy of the fixture and verify the
   backup against that manifest before opening the probe table.
6. Capture hashes for the executable and the BDE DLLs actually loaded by the
   probe. Do not record credentials.

## Bounded operations

Run two separate cases using fresh copies of the same fixture:

### Commit case

1. Open the synthetic table through the approved BDE provider.
2. Start one provider transaction.
3. Append and post `(101, 202)` and `(202, 101)`, with all detail values
   identical.
4. Commit, close, and reopen the table.
5. Record only whether the transaction operations returned, the exception
   class/category if any, row count, and whether both endpoint directions
   exist with matching detail fields. Do not retain field values.

### Second-post failure and rollback case

1. Open the freshly restored failure fixture.
2. Start one provider transaction.
3. Append and post `(101, 202)` successfully.
4. Attempt `(202, 101)` with the same value for the test-only unique-indexed
   field. The expected injected failure is a provider constraint error on the
   second `Post`; record its class and a normalized category only.
5. Roll back the transaction, close and reopen the table, then count rows.
6. Record whether rollback returned, whether the transaction reports active
   after rollback, the post-reopen row count, and a recursive file-manifest
   comparison. The atomicity criterion is exactly zero committed rows.

Do not continue after a failed fixture setup, a transaction-start failure, an
unexpected exception, a failure on the first post, an unrecognized prompt, or
any write outside the disposable fixture. Do not retry on a partially altered
fixture.

## Interpretation and cleanup

- A successful commit case establishes only that the provider can persist this
  artificial pair under the tested conditions.
- The rollback case passes only if the first row is absent after closing and
  reopening the table. A return from `Rollback` alone is insufficient.
- If rollback is unsupported, raises, or leaves one row, preserve the
  disposable fixture and logs, stop, and keep all relationship write paths
  blocked. Do not attempt an unapproved compensating delete.
- Compare the complete post-run manifest to the fixture's pre-run baseline.
  Any unexplained file change is a stop condition, even if the logical row
  count is zero.
- Retain the manifest, probe source/binary hash, normalized observations, and
  any changed fixture for review. Delete only the exact named disposable
  fixture and backup after their final hashes and intended cleanup are
  reviewed; never use a wildcard or recursive deletion on a parent directory.

## Explicit non-claims

This probe would not establish SQLDB/Paradox parity, original-executable
transaction use, shared-transaction isolation, commit-failure recovery,
duplicate/concurrency behavior, or atomicity across `Table1`, `LOC.db`, and
later date/index updates. It does not authorize wiring either legacy
connection route. A separate adapter review is still required before any
future production integration.
