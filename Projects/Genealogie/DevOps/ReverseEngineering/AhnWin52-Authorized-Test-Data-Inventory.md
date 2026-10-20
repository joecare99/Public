# Authorized test-data baseline and static table catalogue

## Scope and handling

The user authorized direct work in `C:\ProgramData\AHNENWIN Test`, including
controlled changes to that test-only directory. This first pass is
read-only: it inventoried file metadata and compared physical file names with
the current and original DataModule resources. No table was opened through
BDE, SQLDB, pxlib, or the application. SHA-256 necessarily streams file
bytes, but no database rows were decoded, queried, or copied.

The complete recursive baseline is stored outside the data directory at:

`C:\Users\Mir\.copilot\session-state\bc780dc9-be21-4e10-b7a2-0aab27abfe2f\files\ahnwin-test-data-baseline-2026-10-18.json`

- 170 files; no hidden or system files were found.
- The manifest records relative path, size, UTC modification time, file
  attributes, and SHA-256 for each file.
- Manifest SHA-256:
  `0A7FA3BAA5C28752E9B6E1EDFCC5D76A5A22FE876655D3CF27B992D544A8FB42`
- Inventory includes 28 `.DB`, one `.DBF`, 28 `.PX`, seven `.MB`, one
  `.MDX`, 46 `.XG*`, and 46 `.YG*` files, as well as the other application
  and documentation assets in the directory.

No genealogy values are included in this catalogue. The JSON manifest and
its hash remain in session artifacts rather than the source tree.

## Static component-to-file reconciliation

`GenealogyDataModule.lfm` and the independent original
`Projects_AhnenWin\DataModule2.dfm` each contain 38 table components. Their
37 named physical identities agree. Table23 has no `TableName` or `FileName`
in either resource and has no persistent fields; its physical identity is
unresolved. The current LFM streams 620 persistent field components across
the 38 table objects. These are resource claims, not provider-verified
physical field definitions.

The field-by-field static extraction (component class, physical identity,
index properties, persistent field name/class, and streamed string size) is
stored in
`AhnWin52-Authorized-Static-DataModule-Catalog.json`. It contains resource
metadata only, not rows from the test databases.

| Component | Resource file identity | Persistent fields |
|---|---|---:|
| Table1 | `AWD.DB` | 49 |
| Table2 | `lc.db` | 1 |
| Table3 | `AWD.DB` | 52 |
| Table4 | `NUMRES.DB` | 1 |
| Table5 | `MRG.DB` | 23 |
| Table6 | `AWD.DB` | 52 |
| Table7 | `AWD.DB` | 52 |
| Table8 | `AWD.DB` | 52 |
| Table9 | `AWD.DB` | 52 |
| Table10 | `MRG.DB` | 23 |
| Table11 | `chnt.db` | 4 |
| Table12 | `NM.db` | 1 |
| Table13 | `LOC.db` | 13 |
| Table14 | `OUTP.db` | 5 |
| Table15 | `MRG.DB` | 23 |
| Table16 | `over.db` | 17 |
| Table17 | `awd.db` (`FileName` in LFM) | 52 |
| Table18 | `MRG.DB` (`FileName` in LFM) | 23 |
| Table19 | `FKMG.db` | 2 |
| Table20 | `FOKO.DBF` | 14 |
| Table21 | `FKHF.DB` | 5 |
| Table22 | `nol.db` | 2 |
| Table23 | **Unresolved** | 0 |
| Table24 | `VORF.DB` | 8 |
| Table25 | `gedh.db` | 3 |
| Table26 | `repso.db` | 5 |
| Table27 | `alfls.db` | 7 |
| Table28 | `ng2h` | 10 |
| Table29 | `sour` | 1 |
| Table30 | `ng2h` | 9 |
| Table31 | `adp` | 3 |
| Table32 | `ftab` | 19 |
| Table33 | `gede.db` | 2 |
| Table34 | `LOC2.db` | 13 |
| Table35 | `occ.db` | 2 |
| Table36 | `lfbh.db` | 7 |
| Table37 | `ndh.db` | 1 |
| Table38 | `sour2` | 12 |

The physical file family for each named identity is present, including the
table file and any same-basename sidecars. The two database files not mapped
by these resources are:

- `ahntab.DB` and its `MB`, `PX`, `VAL`, `XG0`, and `YG0` siblings;
- `LOC - Kopie.db` and its `PX`, `XG0`, and `YG0` siblings. This is a
  separately named copy and is not a sidecar of `LOC.db`.

These files remain unmapped; their purpose is not inferred. Table17 and
Table18 are streamed as `TParadox` in the current LFM (original DFM class:
`TTable`), while other table components use the current SQL-table
compatibility layer. This provider split is another reason not to treat a
successful SQLDB open as proof of legacy BDE parity.

## Post-static verification

A second recursive SHA-256 inventory was compared with the baseline after
the static inspection. File count remained 170; added, removed, and changed
files were all zero. The post-static inventory hash is
`59F15FC8EEE39C85E7C51AE0F3673C1276ED3E6961EB97B46B2E3DDD9FD58137`.
The comparison report is stored outside the data directory at
`C:\Users\Mir\.copilot\session-state\bc780dc9-be21-4e10-b7a2-0aab27abfe2f\files\ahnwin-test-data-static-diff-2026-10-18.json`.

## Existing structural evidence and open conflicts

The prior metadata-only structure-template catalogue describes 18 tables,
168 fields, and 32 secondary indexes. It remains corroboration only and does
not describe Table27, declare relationships, or settle the Table9
`Rufname` width conflict. See
`AhnWin52-Database-Structure-Manifest-Reconciliation.md` and
`AhnWin52-Structure-Template-Catalog.json`.

This static resource/file reconciliation does not establish actual on-disk
field definitions, record counts, index uniqueness or collation, memo
encoding, active language driver, or BDE cursor/error behavior. In
particular, it does not unblock Table13 `FindKey`, Table9 relationship
navigation, Table27 production, or any write/report path.

## Runtime probe and provider catalogue

The user supplied
`C:\copy\delphi\RAD Studio\3.0\Bin\DCC32.EXE`. Its file version is
`9.0.1882.30496` (Delphi compiler 17.0), matching the compiler/runtime used
by the earlier synthetic BDE fixture. With the Delphi 9 `lib` units on the
unit search path, the dedicated read-only allowlisted probe
`Source\AhnWin52\ReverseEngineering\AuthorizedTestDataReadOnlyBDEProbe.dpr`
builds successfully. The user supplied the authorized test-database password;
it was used locally and is intentionally absent from source, logs, and wiki.

The initial two attempts failed with password-required error 10498; after the
user supplied the correct test password, all 29 inventoried table files
opened successfully through BDE 5.2.0.2. Each table was probed individually
with a complete pre/post hash comparison. All 29 comparisons reported zero
added, removed, or changed files. The normalized metadata-only result is
`AhnWin52-Authorized-BDE-Provider-Catalog.json`; the runtime findings and
remaining provider/SQLDB parity gate are documented in
`AhnWin52-Authorized-BDE-Provider-Catalog.md`.

After the complete probe sequence, a fresh recursive comparison against the
original 170-file baseline again found zero additions, removals, or changes.
