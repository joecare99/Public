# Paradox evidence-based best-guess resolution

**Status:** Bounded synthetic BDE ordering verified; fixture provenance
classified but not historically proven.

This note closes two investigation gates only to the extent supported by the
available artifacts. Confidence values below are engineering confidence in the
stated, bounded claim, not statistical probabilities. Facts, hypotheses, and
remaining limits are kept separate.

## 1. Fixture provenance and schema conflict

### Direct evidence

- The 2026-09-29 artifact inventory records the authorized test-copy
  `AWD.DB` as 18,432 bytes with a 2021-06-05 timestamp. Its later observed
  timestamp differs, while the recorded byte length remains 18,432.
- Two separately retained test-instance snapshots each contain four Table9
  rows. Their row-value comparison found no differences. The `.XG` headers
  decoded from both snapshots declare the same eight index names, ordered
  field lists, and `intl850` collation identifier.
- The authorized BDE 5.2.0.2 metadata-only catalogue reports the test-copy
  `Rufname` width as 30. The independent structure-template manifest also
  says 30; the current LFM persistent field declaration says 40.
- The inventory and existing comparison reports do not identify the program,
  action, or date that caused the changed Paradox file hashes/timestamps.

### Best-guess disposition

| Claim | Best guess | Confidence | Safe use |
|---|---|---:|---|
| Effective `Rufname` width in this test-copy schema | 30 bytes | 9/10 | Use 30 only for test-copy metadata and synthetic schema examples. |
| Why the LFM says 40 | Stale or wider persistent-field declaration relative to this copy; source/version mismatch is plausible | 4/10 | Preserve both declarations; do not silently change the LFM or production schema. |
| Why the Paradox file timestamps/hashes changed | A BDE/application-session rewrite or index maintenance is plausible because the application ran between retained snapshots and row values remained equal | 3/10 | Do not attribute the changes to a particular application action or treat either snapshot as the canonical original. |

The historical provenance remains unknown. For metadata work, this is no
longer a blocking dependency: use only facts independently repeated in the
snapshots and BDE catalogue, label them as test-copy facts, and preserve each
snapshot as a separate artifact. Any task that depends on the cause of the
file rewrite, a universal `Rufname` width, or original-release lineage remains
blocked.

## 2. Synthetic secondary-index traversal

The existing Delphi 9 synthetic probe
`Source\AhnWin52\ReverseEngineering\Unit15CompositeFindKeyBDEProbe.dpr`
created an artificial Paradox Table27-shaped table. It appended
`Zebra synthetic` before `Alpha synthetic`, created a secondary `Namvg` index
on `Namvorn;Geb`, reopened/traversed that named index, and asserted the
traversal order was Alpha then Zebra. The recorded result is PASS under BDE
5.2.0.2. Its evidence artifact is
`C:\Users\Mir\.copilot\session-state\bc780dc9-be21-4e10-b7a2-0aab27abfe2f\files\unit15-composite-findkey-bde-probe-2026-10-18.json`.
The source SHA-256 was rechecked against the run record and matches. The
disposable fixture has since been removed.

### Bounded conclusion

- **Verified:** BDE 5.2.0.2 built and traversed a secondary Paradox index in
  key order for these distinct synthetic ASCII names, independently of their
  append order. Confidence: 9/10 for this exact probe.
- **Reasonable implementation guess:** use index traversal, not physical
  `.XG` row order, as the expected logical ordering of a BDE secondary index.
  Confidence: 8/10 for ordinary distinct keys under the tested runtime.
- **Not verified:** equal-key tie order, accented/case-folded `intl850`
  ordering, original application's exact BDE configuration, raw `.YG` tree
  page interpretation, or a pxlib secondary-index reader. The probe does not
  justify implementing a `.YG` parser or claiming SQLDB parity.

This BDE-created synthetic `.XG`/`.YG` pair is a valid independent runtime
ordering oracle for the narrow ASCII traversal case. It closes the question
of whether the BDE runtime can provide a useful synthetic sort oracle; it does
not close binary-format or collation questions. Keep those future questions
separate and blocked until a parser implementation needs them.

## Decision and reopened boundaries

The `resolve-paradox-fixture-provenance` investigation is closed as a
documented uncertainty disposition, not as a claim that the historical cause
was discovered. The synthetic secondary-ordering task is closed for the
bounded BDE traversal result. No approved AhnWin table was opened for this
follow-up; no application, report, data write, or production code path was
used. Existing relationship, production, and SQLDB integration gates remain
unchanged.
