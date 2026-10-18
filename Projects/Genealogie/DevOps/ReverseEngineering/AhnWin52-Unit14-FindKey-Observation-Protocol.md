# Unit14/Table13 `FindKey` evidence protocol

## Purpose

Bound the evidence needed before restoring the `TForm14.ListBox1DblClick` and
Return-key selection paths. Both listing-backed handlers call
`Table13.FindKey([selectedPlace])` before updating/showing `Form33`; they do
not inspect the Boolean result. The current SQLDB compatibility layer rejects
`FindKey`, and `Locate` is not an established substitute.

The UI/live-application steps below remain gated: this document does not
authorize starting AhnWin, opening a genealogy database, inspecting its
records, or sending UI input. The explicitly authorized synthetic BDE runtime
run is documented separately at the end of this document.

## What a UI observation can and cannot establish

The Unit14 activation listing fills its list from Table13. Consequently, every
place selectable in the ordinary UI is already a value read from that table:
the DblClick/Return route can demonstrate a hit-path UX observation, but
cannot supply an absent key through the normal list.

The selection handlers do not branch on the `FindKey` Boolean. A normal
visible dialog outcome therefore cannot establish the lookup result, cursor
position, or miss semantics. The synthetic runtime result below establishes
hit/miss and visible cursor behavior through a named `Ort_` secondary index
whose indexed field and ASCII language driver match the available Unit14
metadata. A UI-only observation remains limited to:

- whether an exception or unexpected modal prompt appeared;
- whether `Form33` became visible; and
- whether the user confirms the expected visible place selection, without
  capturing the place text or reading grid/data rows.

The existing RemoteControl profile/manifest is for the separate `TForm3`
person-search dialog. Do not reuse it for Unit14. No supported Unit14 profile
or input path has yet been validated. Since `Form33` activation copies the
selected Unit14 item into `Edit1`, seeing that editor alone is not proof that
`FindKey` succeeded.

## Preparation before any separately authorized execution

1. Identify the exact test executable by full path and SHA-256; confirm no
   other AhnWin process is active. Do not start it during preparation.
2. Obtain the user's confirmation of the isolated test-instance path and
   permitted dialog profile. Do not reuse a stale profile across executable,
   process, owner-window, geometry, or DPI changes.
3. Create a fresh recursive inventory (relative path, size, timestamp, hash)
   and a full backup outside the test-instance directory. Verify the source
   and backup inventories match before a run. Preserve both unchanged.
4. The proposed UI-only `known-hit` scenario uses one value the user locally
   verifies is already shown in Unit14's list. Do not copy that value into
   the manifest, logs, or documentation.
5. Do not label any normal Unit14 UI scenario as `known-miss`: the list is
   populated from Table13 and provides no absent value. A missing-key test
   needs a separately approved disposable synthetic BDE table/harness or
   another authoritative non-record test interface. It must not bypass the
   UI contract by reading or enumerating genealogy records.
6. If approved later, permit only the single DblClick or Return action on the
   already-selected list item. Do not edit/save, open reports, print/export,
   or invoke unrelated controls. Stop on any unexpected prompt, uncertain
   window identity, exception, or apparent mutation.
7. Capture only process/window/control visibility and terminal error
   categories. Do not read `TDBGrid` rows, field values, or screenshots
   containing place text.
8. After exit, compare the complete instance inventory with the pre-run
   inventory and inspect differences only as metadata first. Preserve the
   backup and both inventories; stop if a difference is unexplained. Prior
   observations in this project changed Paradox header bytes on table open,
   so header-only changes must not be dismissed as proof of zero writes or
   silently treated as harmless.

## Evidence gate and next decision

A UI-only known-hit observation is insufficient to implement a provider-
neutral `FindKey` contract. The authorized synthetic BDE run below established
a hit, a miss, and the immediate `TTable` cursor state on BDE 5.2.0.2 through
the named `Ort_` secondary index. That initial fixture used a unique secondary
index and did not cover duplicate positioning. The later provider catalogue
established that the authorized Table13 copy's `Ort_` index is non-unique;
its seven test values are distinct. A separate synthetic non-unique fixture
has now measured duplicate hit and miss cursor state, while an in-memory
SQLite/SQLDB test measured exact-field `Locate` under an explicit query
order. These results remain bounded to their fixtures; named-index and
composite-prefix parity is not established. The original application's exact
BDE runtime remains unverified.

Keep both Unit14 handlers listing-only, preserve the explicit `FindKey`
failure in the compatibility layer, and do not infer downstream-form behavior
from this synthetic test. Any UI/live-app run still requires its own scoped
authorization and all prerequisites above.

## Authorized synthetic BDE runtime run — 2026-10-18

The user explicitly authorized a disposable synthetic fixture/harness. The
standalone harness is
`Source\AhnWin52\ReverseEngineering\Unit14FindKeyBDEProbe.dpr`; it compiled
with Delphi Win32 compiler 17.0 (DCC32 9.0.1882.30496) and loaded
`C:\Program Files (x86)\Common Files\Borland Shared\BDE\IDAPI32.DLL`,
file version 5.2.0.2. The harness set the BDE session's `PrivateDir` and
`NetFileDir` to a newly created directory under `%TEMP%`, then created only a
synthetic `Table13.db` there.

The table had an integer `ID` field, a `CHAR(40)`-equivalent `Ort` field, an
unnamed unique primary index on `ID`, and three artificial values: `Berlin`,
`Dresden`, and `Muenchen`. It then created and selected the named unique,
ascending secondary index `Ort_` on `Ort`. The table and index headers both
recorded BDE language driver `DBWINUS0` (the ASCII language driver); the
runtime also produced `.XG0` and `.YG0` sidecars. The known-hit call
`FindKey(['Dresden'])` returned true with `RecNo=2` and `Ort=Dresden`. After
`First`, the known-miss call `FindKey(['Hamburg'])` returned false; the
immediate `TTable` state remained `BOF=True`, `EOF=False`, `RecNo=1`,
`Ort=Berlin`. The executable reported `RESULT=PASS`.

The `DBWINUS0` to ASCII language-driver mapping is documented in Embarcadero's
[BDE international compatibility reference](https://docwiki.embarcadero.com/RADStudio/Alexandria/en/International_Compatibility_%28BDE%29).

The installed Delphi 9 `DBTables.pas` source independently shows
`FindKey -> GotoKey -> DbiGetRecordForKey`; it calls `Resync` and
`DoAfterScroll` only when that lookup returns success. This is consistent
with the observed visible current-record state after the miss. No AhnWin
process was started, no genealogy database or record was opened/read, and no
UI input was sent. The temporary fixture contained only the synthetic table
and BDE lock/network file.

This initial run exercised the target index name, indexed field, and ASCII
language driver, but did not establish behavior for partial keys, duplicate
values on a non-unique index, lookup exceptions, another BDE version, or
SQLDB. Its unique index was only a fixture limitation; the authorized
catalogue later established the test-copy target index is non-unique. The
handlers remain blocked because the SQLDB operation does not preserve named
index/prefix semantics and downstream `Form33` behavior is still separately
gated.

## Synthetic non-unique BDE / SQLDB comparison — 2026-10-18

The bounded matrix and classifications are in
`AhnWin52-BDE-SQLDB-Lookup-Comparison-Matrix.md`.
`Unit14NonUniqueFindKeyBDEProbe.dpr` created a disposable Paradox table with
two identical artificial `Ort` keys and a non-unique ascending `Ort_` index.
The table and index headers reported `DBWINUS0`; installed BDE was 5.2.0.2.
Because Delphi's Paradox `AddIndex` required an option for this differently
named single-field index, the fixture used `ixCaseInsensitive`. Exact
duplicate strings avoid testing case-folding, but the target's case flag
remains unknown.

The hit returned true at the first duplicate (synthetic ID 1,
`BOF=False`, `EOF=False`, `RecNo=1`). After `First`, the miss returned false
and retained synthetic ID 1 (`BOF=True`, `EOF=False`, `RecNo=1`). Four
fixture table/index files had identical SHA-256 hashes before/after the
read-only lookup batch. The BDE network directory was kept outside the
fixture, and both disposable directories were removed after verification.

The FPCUnit SQLite/SQLDB case uses `TSQLite3Connection` with an in-memory
database, a non-unique index, and a `TSQLQuery` explicitly ordered by ID.
Exact `Locate` found the first matching ID 1; a miss retained ID 1 with
`BOF=True`, `EOF=False`. This establishes generic SQLDB query behavior only;
the external project `Cmp_SQLTable` implementation source is not available
here. Focused SQLDB tests pass 4/4 and the full suite passes 590/590.

This is only a limited match for exact-field hit/miss on fixtures. SQLDB
`Locate` follows query order and does not expose BDE named-index selection or
composite-key-prefix lookup. It therefore cannot replace `FindKey` for
`num`, `vat`, or `mut`; the filtered Table9 stale-current-row case is not
reproduced. Keep the compatibility exception and all legacy handlers
unchanged. No authorized data, application UI, or report was opened.
