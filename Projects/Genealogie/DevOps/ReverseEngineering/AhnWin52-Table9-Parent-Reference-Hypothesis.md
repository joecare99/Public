# Table9 parent-reference hypothesis and synthetic tests

## Question

What is the narrowest parent-link storage model supported by the Table9
metadata, retained listings, and synthetic tests, without treating missing
domain rules as facts?

## Domain rule supplied by the program owner

On 2026-10-18 the user specified the intended genealogy model:

- Each person has zero or one father and zero or one mother.
- A present father/mother reference stores the referenced person's `Table9`
  `Nummer`; `0` means that parent is absent.
- Invalid parent-reference values are possible in stored data and are reported
  by the application's data-checking operation, not necessarily when the
  parent link is entered. When implemented, the data check is intended to
  handle invalid/missing parent references, parent self-references, marriage
  self-links, and missing reciprocal marriage records. The checker reports
  such errors but does not offer a correction.
- A parent cannot be replaced directly: the UI offers insert/remove actions
  for each role, with the action not applicable to the current state disabled.
  To change a parent, remove the current reference first and then insert the
  replacement. The reconstructed unlink handler confirms removal by writing
  `0` to that one parent field and posting the person.
- The `Marr` relationship is represented by two reciprocal, otherwise
  identical records: one from person A to person B and a reverse record from
  B to A. In the current component mapping these are `Table5`/`MRG.DB`.
- The user confirms that connecting a person to a different person succeeds.
  The “Schon vorhanden” message therefore applies to an already-existing
  person-pair, not to a global one-spouse-per-person rule.
- The user reports that the application also permits a person to be connected
  to themselves, and considers this a bug. Self-marriage is therefore an
  invalid domain case even though the current UI/provider route permits it.
  The future data checker is intended to report it without offering a
  correction.
- Marriage/connection management has only insert and remove actions; the
  action that does not apply in the current state is disabled. There is no
  direct edit/replace action. The reconstructed connection-removal handler
  and user confirmation establish that removing a marriage deletes both
  reciprocal relationship records.

This is authoritative application-domain input, distinct from what the
database schema or synthetic BDE fixture alone can prove. It confirms the
meaning and cardinality of the two parent slots, resolves their domain
zero-sentinel meaning, and specifies reciprocal marriage-pair representation.
The user's UI clarification also confirms that parent replacement is a
two-step remove-then-insert operation, consistent with the separately
reconstructed unlink path that clears the selected slot to `0`.
The user further states that invalid parent references can exist and are
handled later by the data check. The check will also cover parent
self-references, marriage self-links, and missing reciprocal marriage
records, and it will report rather than offer a correction. Thus write-time
referential-integrity rejection is not a safe assumption; the checker is a
later detection boundary, not a repair or prevention mechanism.
The user further confirms that a connection to a different person succeeds,
so the observed duplicate guard is pair-specific rather than person-wide.
This aligns with the retained existing-person handler, which checks the
selected endpoint pair, and rejects an interpretation that a person may have
only one spouse. It does not prove that physical NULL is impossible. Exact
application behavior for missing spouses, history/divorce, deletion, and
partial pair-write failure remains separate from this model.
Self-connection is a separate invalid case: the user reports that the current
program permits it but considers it erroneous. The future data check is
intended to report both marriage self-links and parent self-references,
without offering correction. Do not confuse the `Marr`/spouse self-link with
the independently tested ability of the BDE provider to store
self-referential `Vater`/`Mutter` values.
The insert/remove-only UI and bidirectional row deletion clarify that an
existing connection is not edited in place; replacement is performed as
remove-then-insert. The user confirms that removal deletes both records of
the reciprocal pair, consistent with the traced handler.

Whole-person deletion is a separate, broader legacy operation. The
`TForm1.schen1Click` listing deletes all `MRG.DB` rows with that person's
number in either endpoint field (`Nummer` or `Epnum`); for an uppercased
gender prefix of `M` it clears matching child `Vater` references to `0`, and
for `W` it clears matching child `Mutter` references to `0`, before deleting
the person row. The listing exposes no transaction around this sequence.
Its assembly-to-Pascal reconstruction, including the unresolved `Edit` then
`FindKey` posting semantics, is in
`AhnWin52-Person-Deletion-Behavior.md`. This is legacy behavior evidence, not
proof that the current Paradox/SQLDB provider can safely execute it.

## Falsifiable hypothesis

1. A Table9/`AWD.DB` row is a person row, identified by `Nummer`.
2. `Vater` and `Mutter` are integer parent-reference slots on that same
   person row. Each slot represents zero or one parent; the user specifies
   `0` as the absent-parent value. A present value refers to that parent's
   `Table9.Nummer`. The parent-selection listing writes the selected Table9
   `Nummer` into the current Table1 person row's corresponding field.
3. The `vat` and `mut` secondary indexes are non-unique reverse lookup paths
   over those reference fields (plus date components). Therefore multiple
   child rows can store the same parent number, and the index can retrieve
   those rows by parent-number prefix.
4. In the existing-person selection branch, the exact candidate gender
   values `M` and `W` select `Vater` and `Mutter`, respectively. Other values
   do not write either parent field in that branch. This is a listing-backed
   program policy, not a universal sex/domain rule. The new-person path uses
   a separate menu-label role branch and is not unified with it.

The model would be falsified by evidence that these fields are stored on the
referenced parent row instead of the current person row, that either index is
unique, that duplicate parent numbers cannot be represented, or that the
existing-person listing writes a different field for the exact `M`/`W`
candidate cases.

## Evidence and tests

### Static evidence

- The DataModule resources map Table9 to `AWD.DB` and expose integer
  `Nummer`, `Vater`, and `Mutter` fields.
- The authorized BDE metadata catalogue reports a unique primary index on
  `Nummer` and eight non-unique secondary indexes, including `vat` on
  `Vater;Indj;Indm;Indt` and `mut` on `Mutter;Indj;Indm;Indt`.
- The complete existing-person `DBGrid2DblClick` listing writes the selected
  Table9 number into the current Table1 row's `Vater` field for exact `M`,
  or `Mutter` for exact `W`. The independently extracted Pascal helper
  `ApplySelectedParent` preserves those exact branches and does not post.

### Synthetic tests run

- Added `TestCaseRepeatedParentReferencesRemainOnChildRows` to
  `tst_AHW52_ParentSelectionTests.pas`. Its artificial in-memory fixture has
  two candidate parent rows and three child rows. It applies the exact `M`
  and `W` selection operation to each child, posts only in the test caller,
  and verifies that all three child rows hold the same father and mother
  numbers while both candidate-parent rows remain unchanged.
- The focused parent-selection suite passed **5/5**; the complete FPCUnit
  suite passed **591/591**.
- The previously executed Delphi 9/BDE 5.2.0.2 synthetic
  `Unit15CompositeFindKeyBDEProbe` created the non-unique `vat` and `mut`
  index shapes and successfully found multiple synthetic rows sharing the
  same parent-key prefix. That fixture was Table8-shaped rather than a full
  Table9 fixture, so it validates BDE index mechanics only, not all Table9
  fields or application event behavior.
- The Delphi 17 compiler/BDE 5.2.0.2 synthetic-only
  `Table9ParentReferenceBDEBlackBoxProbe.dpr` created a Table9-shaped
  `AWD.DB` with the `vat` and `mut` index definitions, reopened it read-only,
  and observed these public `TTable` results: `SHARED_FATHER=2`,
  `SHARED_MOTHER=2`, `ZERO_REFERENCE=2`, `MISSING_TARGET=1`, and
  `SELF_REFERENCE=1`. The synthetic rows were inserted and posted without a
  target-existence error; indexed lookups found rows carrying zero, a
  nonexistent target number, and their own number. The probe completed with
  exit code 0 and `FIXTURE_CLEANUP=PASS`; calling `Session.Close` after
  closing/freeing the dataset and database released the BDE network file.
  This observes provider-level representation and lookup only, not application
  validation or domain policy.
- The same Table9-shaped probe now also performs an absent one-field prefix
  lookup on each non-unique composite index after `First`. Both `vat` and
  `mut` returned `False`, with `BOF=True`, `EOF=False`, `RecNo=1`, and the
  synthetic `Nummer=100` row still current. The test asserts that this is the
  row selected by `First` before lookup and that the requested parent value
  was not present on it; it makes no claim about which row `First` selects in
  a different dataset or runtime. This is the immediate BDE cursor state for
  the tested synthetic call shape, not SQLDB parity or a safe post-miss
  application policy.

No authorized Table9 record values were read for these tests. The BDE
catalogue evidence above is schema/index metadata only.

## Conclusion and limits

The evidence **supports the storage/selection hypothesis within the tested
boundaries**: parent numbers are represented as fields on the current
person/child row, repeated references are representable, the non-unique
indexes can retrieve shared references, and the existing-person selection
helper follows the exact `M`/`W` field mapping. The user-provided domain rule
further establishes zero-or-one cardinality per parent slot, `0` as the
no-parent value, and `Table9.Nummer` as the person identifier used by parent
and spouse references.

This is not proof of physical referential integrity or a complete genealogy
contract. The synthetic BDE fixture shows that its provider can store and
index zero, missing-target, and self-reference parent values; the user
confirms that the future data check is intended to flag invalid/missing parent
references, parent self-references, marriage self-links, and missing
reciprocal marriage records. The checker will not offer corrections. Its
exact diagnostics and treatment of physical NULL remain unspecified. Still
unknown are biological versus adoptive meaning, cross-field gender
consistency, update/delete cascades, and cancellation or provider-error
behavior.

The reciprocal `Marr` rule establishes the domain shape but does not make
pair creation atomic. The mapped legacy route posts the two rows separately,
and no transaction/rollback spanning both posts is visible; an error after
the first post may leave an asymmetric pair. The user reports “Schon
vorhanden” for the same pair and confirms that creating a connection to a
different person succeeds. Thus one-spouse-per-person exclusivity is not the
rule; the duplicate check is scoped to the pair. This agrees with the
existing-person handler's endpoint comparison, which detects the reciprocal
pair whether traversed in either row orientation. The new-person route has no
visible pre-insert duplicate scan. Existing-pair repair, delete/unlink
behavior, and duplicate concurrency need their own evidence. The four-row
authorized test copy was not used to infer any of these rules.

The owner reports that failures in the reciprocal-row write have previously
made the database unusable and requests a transaction/rollback safety boundary.
`Source\AhnWin52\Relationships\MarriagePairTransactionContract.pas` now
provides a provider-neutral coordinator: validate distinct positive endpoints,
append both rows with the same `TMarriageDetails` in opposite directions,
commit only after both appends, and attempt rollback on append or commit
failure. Rollback failure is raised with both failure messages. It rejects
self-marriage before starting the transaction. The synthetic contract suite
passes 8/8; the full FPCUnit suite passes 637/637, and the main Debug project
builds.

`IGenealogyDataModule` now exposes begin, commit, and rollback operations.
`TGenealogyDataModuleAdapter` delegates them to the SQLDB transaction assigned
to `Table5` (`MRG.DB`), and reports explicitly when that transaction is
missing or is not a SQLDB transaction. `MarriagePairDataModuleAdapter` now
maps the reciprocal coordinator onto the active/browse SQLDB `Table5`, sets
both endpoint fields and all 18 marriage details, posts and applies each row
inside the coordinator's transaction, and validates required field types.
Synthetic SQLite tests cover the committed reciprocal pair and an injected
second-insert trigger failure; after rollback and reopen, the persisted row
count is zero. The focused adapter suite passes 5/5 and the full FPCUnit suite
passes 644/644.

This is not target-provider proof. The concrete implementation uses the
transaction currently assigned to `Table5`; whether that transaction is
shared with other datasets and whether it isolates unrelated pending work are
unresolved. BDE/Paradox rollback remains untested. A non-executable,
approval-gated synthetic probe protocol is recorded in
`AhnWin52-MRG-Transaction-Observation-Protocol.md`. Neither reconstructed
form route uses the pair coordinator. The pair contract does not transact the
new `Table1` person, location table writes, or subsequent index/date edits.
Keep production integration blocked pending transaction-isolation review and
target-provider evidence.

The domain-level parent model is no longer blocked on parent cardinality or
the meaning of zero, and the marriage domain now specifies reciprocal pairs.
Parent reassignment is also clarified as remove-then-insert, not direct
replacement.
The future data checker will report invalid/missing parent references,
parent self-references, marriage self-links, and missing reciprocal marriage
records. It will not offer correction. These checks do not prevent bad writes
from occurring before the checker is implemented or run.
Keep the multi-mode production handler, SQLDB/BDE integration, and
relationship write workflows blocked pending provider miss/error behavior,
cancellation and post/write lifecycle, data-check implementation/diagnostic
behavior,
pair consistency/recovery, and UI cleanup evidence. This result does not authorize
wiring `ApplySelectedParent` into the UI or enabling provider-backed edits.
