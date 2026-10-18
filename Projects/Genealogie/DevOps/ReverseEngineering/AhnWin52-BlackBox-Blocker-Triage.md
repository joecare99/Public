# Black-box triage of remaining reconstruction blockers

## Principle

Treat the Paradox storage/index implementation as an opaque provider detail.
The application-level contract is the observable behavior of the selected
dataset operation: request/index selection, result, cursor/current-row state,
exception, and any documented mutation. Do not decode `.XG`/`.YG`, implement
an index-file reader, or require knowledge of index-tree internals to
reconstruct application behavior.

Use artificial fixtures for provider experiments. Compare BDE and SQLDB only
for the same externally observable operation and state. If the candidate
provider cannot represent the operation, record an incompatibility rather
than emulating it by enumerating rows or guessing order. A black-box test can
establish storage/API mechanics; it cannot alone establish genealogy-domain
rules or user intent.

## Remaining blocked work, grouped by evidence gate

| Workstream | Blocked todos | Black-box test or evidence that can advance it | What remains outside a test's proof |
|---|---|---|---|
| Lookup and relationship provider boundary | `resolve-unit14-findkey-runtime-contract`, `select-readonly-data-integration`, `recover-structural-integration-evidence`, `revisit-relationship-slices-with-facade`, `extract-relationship-selection-logic`, `reconstruct-parent-insertion-slice`, `reconstruct-child-insertion-slice`, `restore-domain-slices`, `resume-evidence-gated-production-integration` | `TSQLTable` maps a configured `IndexName` to composite `ORDER BY`; synthetic SQLite tests cover prefix hit/miss, active switch, descending fields, client filters, and case-sensitive default Locate. A synthetic BDE `ixCaseInsensitive` index accepted a case-variant FindKey that SQLDB only finds when `loCaseInsensitive` is requested. Added the tested, provider-neutral `IIndexedSeekProvider` request/result contract for index-prefix input, hit/miss, cursor flags, and row-identity state; it intentionally has no adapter. User-confirmed domain rules: parent slots are zero-or-one with `0` absent; marriage is a reciprocal pair of `Marr` rows; different partners are allowed and duplicate rejection is pair-scoped; connection UI offers only insert/remove and removing a link removes both endpoint directions. Self-marriage is currently permitted but explicitly considered a bug. The future data check is intended to report invalid/missing parent references, parent self-references, marriage self-links, and missing reciprocal records; it offers no correction. `IGenealogyDataModule` exposes transaction begin/commit/rollback, delegated to `Table5.Transaction`. `MarriagePairDataModuleAdapter` writes reciprocal rows with all 18 details and applies both updates before commit. Artificial SQLite tests prove the configured trigger rejects the second insert and rollback leaves zero rows (adapter suite 5/5; full FPCUnit 644/644). | Marriage duplicate behavior matches the existing-person endpoint-pair check; the new-person route has no visible pre-insert duplicate scan. The checker is future detection/reporting, not write-time prevention/repair. These tests do not prove BDE/Paradox behavior or exclusive ownership of `Table5.Transaction`, which may be shared. The adapter remains unwired to both legacy routes; its scope excludes the new person, LOC additions, and later date/index updates. A non-executable BDE rollback probe protocol is prepared but not run. Remaining gates include shared-transaction isolation, target-provider rollback proof, duplicate concurrency, and UI cleanup. |
| Report producers and output | `migrate-unit16-report-output`, `observe-table14-report-output`, `profile-report-output-flow`, `restore-unit16-export-mode-boundary`, `verify-unit16-preview-caller-contract`, `retire-legacy-report-dependencies` | Static caller/field tracing and artificial in-memory row projections can establish route-specific source-to-report mappings. The new generic `ReportLifecycleContract` separately verifies request/source/preparation/capability/output handoff and passes 15 synthetic tests; existing FOKO and Unit16 text-export suites remain green. A visible-output comparison would need a separately approved, disposable application instance and exact scenario. | The lifecycle contract has no production adapter and does not merge workflows or prove original rendering, printer/PDF output, caller reachability, or missing WPTools/QuickReport behavior. Unit16 preview/PDF remains blocked. No report run is authorized by this triage. |
| Destructive Table27 producer | `restore-unit15-table27-spitzbas-producer` | The already implemented provider-free `Unit15SpitzbasModel` and its artificial branch tests cover the listing-derived row model. Further black-box producer comparison requires a disposable database fixture and a complete safe, rollback-tested producer contract. | Do not execute `EmptyTable` or wire the destructive producer merely because its schema is known. The in-memory model is not a production producer. |
| Native build | `attempt-ahnenwin-native-dcc-build`, `reassess-native-build-dependencies` | Static comparison now identifies `frmAhnenWinMain`/`TForm1` and `AboutForm`/`TAboutForm` as current successors to legacy Unit1 and Unit9, respectively. A native retry requires a coherent matching-version DPR/source/resource set and compatible report dependencies. | The legacy Unit1/Unit9 decompiler listings are not drop-in current sources; matching class/resource lineage does not prove source parity. QuickReport still lacks `QRPrntr.dcu`. Do not mix variants or patch project paths to conceal the mismatch. See `AhnWin52-Unit1-Unit9-Renamed-Unit-Mapping.md`. |
| Main-form handler migration | `migrate-tab-handler-implementations`, `restore-selected-tab-handler`, `select-bounded-tab-handler`, `test-tab-handler-restoration`, `remove-obsolete-mainform-callbacks` | Continue only when a complete listing/resource binding exposes a local, provider-free handler or a narrow tested boundary. Existing residual host actions lead to provider-backed `anzeigen` or shared persistence. | Do not invent callbacks or remove wrappers with active callers. |
| Remaining bounded screens/schema selection | `screen-next-unit22-helper`, `select-schema-backed-synthetic-boundary` | Select a new pure/listing-backed boundary only if its full behavior is not already covered. Unit22's Table14 route calls `EmptyTable`; Table27 schema evidence exists, but producer/provider safety remains separate. | Repeated scans or schema facts alone do not justify destructive behavior. |

## Evidence already available

- BDE 5.2.0.2 synthetic tests observe duplicate-key hits, misses with
  retained current rows, composite-index prefixes, and selected filter
  behavior through the public dataset API; no `.XG`/`.YG` parsing is required.
- Generic SQLDB `TSQLQuery.Locate` and the actual `Cmp_SQLTable.TSQLTable`
  wrapper have both been tested on composite-ordered synthetic queries. The
  wrapper maps `Indexes.Add(name, fields[, descFields])` plus `IndexName` to
  SQL `ORDER BY`, and changing the selected index while active reopens it.
  Prefix hits select the first row in that order; with a client-side filter,
  the tested lookup skips an excluded earlier row and selects the first
  eligible row. The tested miss after `First` retains the current visible row
  with `BOF=True`, `EOF=False`.
- A synthetic BDE `Ort_` index created with `ixCaseInsensitive` found a
  mixed-case key when queried with different letter case. `TSQLTable.Locate`
  on SQLite is case-sensitive by default and matches the variant only when
  called with `[loCaseInsensitive]`. The BDE and SQLDB cases expose a possible
  mismatch, but the authorized target index's case flag remains unrecorded;
  do not generalize either fixture to target collation.
- A new metadata-only BDE probe for the authorized `LOC.db`/`Ort_` index was
  compiled but could not pass table open: BDE returned password-required
  before index enumeration. A fresh 170-file pre/post inventory matched
  exactly; no field values or index metadata were read. Resume only when the
  password is locally available through the designated environment variable,
  never through source, command-line, logs, or chat.
- The Table9 hypothesis test establishes that three synthetic child rows can
  share stored parent references and that the role helper applies exact
  `M`/`W` writes to the child row. This is not a domain-integrity test.
- A separate synthetic Table9-shaped BDE 5.2.0.2 `TTable` probe reopened its
  fixture read-only and observed two shared father matches, two shared mother
  matches, two zero-reference rows, one missing-target row, and one
  self-reference row. `Append`/`Post` accepted all synthetic values and the
  public indexes retrieved them. This proves only provider-level
  representation/lookup mechanics; it does not authorize or establish
  application/domain acceptance. The probe used no real records and parsed no
  Paradox index internals.
- That same synthetic Table9 probe now checks a miss on each `vat`/`mut`
  composite index after `First`: both `FindKey` calls returned false while
  retaining the initial synthetic row (`Nummer=100`, `RecNo=1`) and reporting
  `BOF=True`, `EOF=False`. The synthetic ordered-SQLDB `Locate` case now
  matches that limited leading-prefix hit/miss pattern when the explicit
  `ORDER BY` uses all composite fields, and `TSQLTable` now generates that
  order from its configured index. A synthetic SQLDB filter test also skips
  the excluded earlier match and confirms filtered miss cursor flags. This
  remains a limited SQLite-vs-BDE observation. Case-sensitivity behavior has
  been observed only for the synthetic `ixCaseInsensitive` BDE index and
  SQLite Locate options; target collation, suffix ties, provider-specific
  exception behavior, and caller behavior after the miss remain unresolved.
- The Table27 provider-free row model and tests validate listing-derived
  in-memory branches only, not `EmptyTable`, database writes, or report output.

## Next execution rule

Choose the next item by asking: “What exact public operation, input, and
observable result would falsify the current theory?” Run only that operation
against fresh synthetic data. If the missing fact is a domain rule, caller
authorization, or absent source/dependency, document it as an evidence gate
instead of trying to infer it from provider internals.
