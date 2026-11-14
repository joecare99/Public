# Database structure manifest reconciliation

## Source and handling

The user identified the metadata-only source as
`C:\Projekte\CSharp\WinAhnenNew\AhnenWin52Backup\AhnWin52Backup.Core\Resources\StructureTemplate\manifest.json`.
It declares schema version `1`, template ID `ahnwin52-empty2-structure-v1`,
and `Windows-1252` encoding. The manifest defines 18 tables, 168 fields, and
32 secondary indexes.

The source model also contains a `baselineData` property. That payload was not
read or copied. The normalized catalogue
`AhnWin52-Structure-Template-Catalog.json` is an explicit allowlist containing
only physical table identity, table version/record size, field names/type
codes/lengths, database sort-order/field-number metadata, primary-index
filename/first-field convention, memo filename, and secondary-index
names/files/sort order/logical indexed fields. It contains no rows, baseline
payload, encryption key, asset hashes,
or raw header hex. Raw type codes are retained without guessed type-name
decoding.

This is evidence about the backup program's empty structure template, not
proof that every schema value matches the original application or a production
database.

## Cross-reference to the reconstructed DataModule

The current `GenealogyDataModule.lfm` and decompiled `Projects_AhnenWin\Unit2.pas`
map the most relevant table components as follows:

| Component | Physical file | Manifest entry | Structural evidence |
|---|---|---|---|
| Table9 | `AWD.DB` | Present | Manifest has 52 fields and 8 secondary indexes; DataModule confirms integer `Nummer`, `Vater`, `Mutter` and the persistent field definitions. |
| Table13 | `LOC.DB` | Present | Manifest has 13 fields; the named `Ort_` secondary index is labeled ASCII and lists `Ort` as its indexed field in the target metadata. |
| Table14 | `OUTP.db` | Present | Manifest has five fields and the `Valf` index (`Nm3`, `Nm`, `Nr`). |
| Table16 | `over.db` | Present | Manifest has 17 fields and indexes `dsn` (`Nummer`, `Nn`) and `ngh` (name/date key). |
| Table22 | `nol.db` | Present | Manifest has three fields and `namort` (`No`, `Nr`). |
| Table27 | `alfls.db` | **Absent** | Unit2 and the LFM agree on seven persistent fields. The authorized BDE catalogue now supplies the test-copy physical field sizes and three index definitions; see the runtime reconciliation below. |

The broader manifest also includes `adp.DB`, `chnt.DB`, `ftab.DB`, `gedh.db`,
`lc.DB`, `MRG.DB`, `ndh.db`, `NM.db`, `NUMRES.DB`, `occ.db`, `repso.db`,
`sour.DB`, and `sour2.DB`. A component-to-file mapping for every one of these
tables has not yet been reconciled here.

## Confirmed useful key layouts

- `AWD.DB` secondary indexes include `muto` on `Mutter` followed by birth,
  baptism, and `Nummer` fields; `vato` is the corresponding `Vater`-leading
  index. The shorter `mut` and `vat` indexes also begin with the respective
  parent field. This supports lookup/index analysis for relationship workflows.
- `LOC.db` records `ascii` database sort order and a secondary index labeled
  `Ort_`. The manifest's serialized `keyFields` are `Ort, Ort`, but the
  backup program's `ParadoxStructureWriter` explains this representation:
  it takes the table's first field (`Ort`) as the primary field and appends
  that field as a suffix to each secondary index key. The logical indexed
  fields are therefore the serialized fields except the final primary-key
  suffix: `Ort`. A metadata-only validation confirmed that all 32 secondary
  indexes in the manifest end with the table's first field. This resolves the
  apparent repeated-field discrepancy in the template model; it does not
  establish uniqueness flags or prove that a generated empty template
  reproduces the original application's runtime behavior.
- `over.DB`'s `ngh` key is ordered `Name`, `Gebjahr`, `Gebmonat`, `Gebtag`,
  `Hjahr`, `Hmonat`, `Htag`, `Nn`, matching the route-specific Table16
  projection already recorded in the report-caller note.
- `nol.db`'s `namort` index is ordered `No`, `Nr`; `OUTP.db`'s `Valf` index is
  `Nm3`, `Nm`, `Nr`.

These layouts are useful for synthetic key construction and static call-site
comparison. They do not by themselves establish BDE cursor, duplicate-key,
partial-key, exception, or SQLDB behavior.

## Reconciliation gaps and conflicts

1. **Table9 `Rufname` width conflict:** the manifest declares length 30, while
   `GenealogyDataModule.lfm` declares `Table9Rufname.Size = 40`. Preserve both
   source claims. Do not choose one for a production migration until the source
   schema/version difference is explained.
2. **Table27 missing from the structure-template manifest:** Unit2's decompiled component map
   and the current DataModule LFM agree on the following persistent field
   order for `alfls.db`. The field classes come from Unit2; LFM sizes are
   component declarations, and the final column adds direct BDE metadata from
   the authorized test copy:

   | Order | Field | Unit2 / LFM field class | LFM size | BDE test-copy type / size |
   |---:|---|---|---:|---|
   | 0 | `Nr` | `TAutoIncField` | — | AutoInc / — |
   | 1 | `Dsn` | `TIntegerField` | — | Integer / — |
   | 2 | `Kn` | `TStringField` | not specified | String / 20 |
   | 3 | `Namvorn` | `TStringField` | 125 | String / 125 |
   | 4 | `Geb` | `TStringField` | 60 | String / 60 |
   | 5 | `Sterb` | `TStringField` | 60 | String / 60 |
   | 6 | `Kmt` | `TStringField` | 100 | String / 100 |

   The BDE test-copy reports three ascending indexes: unnamed unique primary
   `Nr;Dsn`, non-unique `Ds` on `Dsn`, and non-unique `namvg` on
   `Namvorn;Geb`. The current LFM streams `Table27` as `TSQLTable` with
   `FieldDefs = <>` and no index definitions. Thus `Kn.Size` is now known as
   20 for this test copy, not universally. The table contains zero records.
   This schema does not establish the `spitzbas` producer's source traversal,
   mode-dependent filtering, output ordering, or errors; the producer still
   calls `EmptyTable` and remains blocked.
3. **No database relationship declarations:** the manifest has no relation
   collection, foreign-key constraints, or cascade rules. `AWD.DB.Vater` and
   `.Mutter` are integer fields with matching leading secondary indexes. The
   user specified the application-domain meaning: each is a zero-or-one
   reference to a person's `Table9.Nummer`, with `0` meaning no parent.
   Separately, the user specifies that a marriage in `Marr` is stored as two
   reciprocal, otherwise identical records referencing the two persons; the
   current component map is `Table5`/`MRG.DB`. The user has not observed
   multiple marriages as supported, but this is not a confirmed uniqueness
   constraint. These domain statements do not add physical foreign-key
   enforcement to the manifest. Invalid parent references can be stored.
   When implemented, the application's data check is intended to report
   invalid/missing parent references, parent self-references, marriage
   self-links, and missing reciprocal marriage records, without offering
   correction. Exact diagnostics, write-time rejection behavior, physical
   NULL handling, pair-write atomicity, duplicate recovery, and deletion
   semantics remain open.
4. **Index uniqueness/runtime flags:** the normalized semantic catalogue
   records index field order and collation but not a verified uniqueness or
   duplicate-key runtime contract. The generated template's primary-key
   suffix convention must not be confused with a declaration that the
   corresponding legacy secondary index is unique.

## Next evidence boundary

The structure-template manifest materially helps by defining schema for its
listed tables without opening records. The separate authorized BDE catalogue
now supplies runtime schema/index metadata for the `alfls.db` test copy,
without copying records. This closes the prior Table27 field-width/index
metadata gap, but it is not enough to unblock relationship writes or the
`spitzbas` producer: authoritative Table9 parent-child rules are absent, and
the producer's source traversal/filter/order/error contract remains
unresolved. BDE index metadata also does not establish SQLDB parity.

Continue by statically tracing the `spitzbas` producer inputs and their
mode-specific filtering/order against the complete retained listing and
component map. Request a metadata-only supplement only if that trace exposes a
remaining schema gap; request authoritative Table9 relationship rules before
relationship-write work. Do not request or inspect genealogy records. Until
the producer contract is complete, keep production paths blocked and do not
invent synthetic rows or semantics.
