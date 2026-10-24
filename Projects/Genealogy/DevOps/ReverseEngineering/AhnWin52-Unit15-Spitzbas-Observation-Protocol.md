# Table27 `spitzbas` observation protocol — preparation only

## Status and authorization boundary

This is a checklist for a possible future, separately authorized observation.
It does **not** authorize starting `AHNWIN51.exe`, opening any database,
invoking a `spitzbas` caller, changing a table, or displaying a report.

The retained `TForm1.spitzbas` listing closes Table27, calls
`TTable.EmptyTable`, rebuilds it from provider-backed Table9/Table18/Table8
and sometimes Table24 state, then binds Table27 to Unit15 and reaches report
setup/preview. There is no local rollback: an exception can leave Table27
empty or partially rebuilt. The callers also have distinct setup and save
behavior. Therefore neither the authorized test directory nor a copy that
contains valued genealogy records is a safe observation target.

**Current execution gate: closed.** No bounded UI route has been established
that avoids the destructive producer and report setup. A future run requires
explicit approval for the exact executable, disposable instance, caller,
scenario, destructive Table27 effects, and any visible preview. Preparation
alone does not grant that approval.

## What an observation could establish

If later approved on a disposable fixture with artificial values only, a
visible run could establish limited UX facts such as whether the selected
caller reaches a preview, whether an error prompt appears, and whether the
operation terminates. It would not establish:

- exact provider lookup results, cursor position, or SQLDB parity;
- production dataset output, genealogy meaning, or BDE parity to another
  runtime;
- `FloatToStr` behavior outside the observed locale;
- a portable ordering for rows whose output index keys are equal; or
- safe rollback of `EmptyTable` and subsequent provider side effects.

Do not capture screenshots, window captions, report text, selected names,
dates, places, addresses, notes, or any other genealogy contents. Record
only the outcome categories below.

## Preconditions before any separately approved run

1. Identify the exact executable by full path, file version, and SHA-256.
   Confirm that no AhnWin process is active. Do not launch during preparation.
2. Identify the exact caller (`basa`, `aspitz`, or `pspitz`) and review its
   complete call chain and setup effects. If that review cannot prove the
   target and all side effects, stop before execution.
3. Use a **disposable isolated copy** containing only artificial fixture
   records. Do not use `C:\ProgramData\AHNENWIN Test` or an unknown/production
   directory. Preparing such a fixture is a separate task and requires its
   own data-write authorization; this protocol creates no fixture.
4. Capture a recursive pre-run inventory of the entire disposable instance:
   relative paths, sizes, timestamps, and SHA-256 hashes. Create a verified
   external full backup and compare its inventory with the instance before
   proceeding. Record both inventory hashes outside the instance.
5. Validate the allowed window/process identity and exact entry route
   manually. Do not reuse a profile created for another form, executable,
   process, owner window, geometry, or DPI.
6. Separately approve whether Unit15 preview may become visible. The listing
   reaches report setup after the producer; if preview itself is not approved,
   do not invoke this path.
7. Select one scenario and its fixture state locally. Do not put person,
   event, or place values into a manifest, log, test artifact, screenshot, or
   wiki. Do not batch or replay scenarios.

## Permitted action and stop rules

Only after all preconditions and separate approval:

- invoke exactly one approved caller once;
- observe only process/window visibility, completion/error category, and
  whether the user-confirmed preview appeared;
- send no additional dialog input, edits, saves, report commands, printing,
  export, or navigation; and
- stop immediately on an unexpected window, prompt, error, timeout, uncertain
  target identity, or any unapproved action.

The producer's Table27 clear/rebuild is an expected destructive effect, not a
rollback mechanism. Any failure or interruption can leave a partial table.
Do not retry or continue to another scenario in that instance.

## After-run handling

1. Preserve the disposable instance, external backup, and pre/post inventories.
   Compare the entire directory; do not dismiss Paradox header/index/memo
   changes as harmless. Report every changed, added, or removed path by
   metadata only.
2. If any change lies outside the specifically approved Table27 effects, or
   the exact expected file effects were not defined beforehand, stop and
   retain the evidence. Do not copy the backup over the instance or attempt
   an in-place repair.
3. Keep the entire disposable instance quarantined until the user decides
   whether to preserve or discard it. No deletion or reuse is implicit.
4. Record only one terminal category:
   `preview-visible`, `preview-not-visible`, `error-prompt`,
   `timeout`, `unexpected-window`, or `aborted`.
   Separately record whether the user confirmed the expected visible UX as
   `confirmed`, `not-confirmed`, or `ambiguous`. These values are not lookup
   or data-content conclusions.

## Current evidence gate

The provider-free model and its artificial tests are separate from any live
observation. The synthetic BDE probe used newly created Paradox fixtures only;
it did not run `spitzbas`, touch authorized data, or execute Unit15 report
setup. The observation protocol remains non-executable until all explicit
approvals and prerequisites above are met.
