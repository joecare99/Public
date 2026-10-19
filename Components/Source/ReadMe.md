# DBParadox

`TDBParadoxConnection` is an experimental, read-only SQLDB connection for
Paradox tables. It lets SQLDB consumers use the familiar `TSQLConnection`,
`TSQLTransaction`, and `TSQLQuery` APIs while the provider owns all Paradox
and pxlib-specific details.

> **Status:** This provider is intentionally limited to a tested read-only
> SQL subset. It is not a general SQL engine, a BDE replacement, or a
> production-ready writable database connection. Do not use it to update
> genealogy data.

## Contents

- `DBParadoxConnection.pas` — SQLDB connection, cursor, and read path.
- `DBParadoxSQLParser.pas` — strict parser for the supported SELECT subset.
- `DBParadoxWriteBuffer.pas` — provider-neutral in-memory write-set prototype;
  it is not connected to SQLDB or pxlib.
- `..\FPC\DBParadox.lpk` — Lazarus package containing the three units.
- `DBParadoxTests/` — standalone FPCUnit project for provider tests.

## Requirements and build

The current implementation targets Free Pascal/Lazarus and the pxlib **0.6.8**
runtime. The connection dynamically loads a pxlib shared library when it is
connected. Its version must be exactly `0.6.8`, and the library must export
the read functions required by the provider. The selected DLL/library path is
set using `PxlibLibraryName`.

Open `..\FPC\DBParadox.lpk` in Lazarus and build the package, or build it with
`lazbuild`:

```powershell
& C:\lazarus\lazbuild.exe C:\Projekte\Delphi\Components\FPC\DBParadox.lpk
```

The project search paths expect the pxlib Pascal bindings in
`$(FPCSrcDir)\packages\pxlib\src`. Configure the FPC source path in Lazarus if
that directory is not found automatically.

All simultaneously connected `TDBParadoxConnection` instances in a process
must use the same pxlib library path. pxlib is loaded once for the active
connections and unloaded after the last one disconnects. A connection cannot
change its `PxlibLibraryName` while connected.

## Basic SQLDB use

Set the inherited `DatabaseName` to the directory containing the Paradox
tables and set `PxlibLibraryName` to the pxlib 0.6.8 library. Then use standard
SQLDB classes for read-only queries:

```pascal
uses
  DB, SQLDB, DBParadoxConnection;

var
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
begin
  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Query := TSQLQuery.Create(nil);
  try
    Connection.DatabaseName := 'C:\Data\Paradox';
    Connection.PxlibLibraryName := 'C:\Tools\pxlib_x64.dll';
    Connection.Transaction := Transaction;
    Transaction.Database := Connection;

    Query.SQLConnection := Connection;
    Query.SQLTransaction := Transaction;
    Query.ReadOnly := True;
    Query.SQL.Text :=
      'SELECT ID, Ort FROM Table13.DB WHERE ID >= :minimum ' +
      'ORDER BY ID DESC';
    Query.Params.ParamByName('minimum').AsInteger := 2;
    Query.Open;
    try
      while not Query.EOF do
      begin
        WriteLn(Query.FieldByName('ID').AsInteger, ' ',
          Query.FieldByName('Ort').AsString);
        Query.Next;
      end;
    finally
      Query.Close;
    end;
  finally
    Query.Free;
    Transaction.Free;
    Connection.Free;
  end;
end;
```

The table is resolved relative to `DatabaseName`. A table name can omit its
extension or use `.DB`; no directory component is permitted. The provider
opens table files in read-only mode and rejects path traversal rather than
allowing SQL to select a file outside the configured directory.

## Supported SQL

The accepted grammar is deliberately narrow:

```text
SELECT * | field [, field ...]
FROM table [ . DB ]
[WHERE field operator :parameter [AND field operator :parameter ...]]
[ORDER BY field [ASC | DESC] [, field [ASC | DESC] ...]]
[;]
```

Examples:

```sql
SELECT * FROM AWD.DB
SELECT Nummer, Vater FROM AWD.DB WHERE Geschlecht = :sex
SELECT ID FROM Table13.DB WHERE ID >= :first AND ID <= :last
SELECT Ort FROM Table13.DB ORDER BY Ort ASC, ID DESC;
```

Keywords are case-insensitive. Identifiers use ASCII letters, digits, and
underscores, and cannot start with a digit. Each comparison must use a named
parameter. The supported operators are `=`, `<>`, `<`, `<=`, `>`, and `>=`.
Multiple `WHERE` predicates are combined with `AND`.

The parser rejects unsupported or invalid syntax explicitly, including
inline literals, positional parameters, `OR`, joins, aliases, qualified
paths, multiple statements, and non-SELECT statements. Selecting the same
field more than once is also unsupported.

### Data types, comparison, and ordering

The currently implemented mappings and comparisons are:

| Paradox field type | SQLDB field type | Supported behavior |
| --- | --- | --- |
| `pxfAlpha` | `ftString` | ASCII (7-bit) values and string parameters; bytewise, case-sensitive comparison |
| `pxfLong` | `ftInteger` | Integer values and integer parameters in the Paradox long range |

Other field types, including memo/blob fields, fail explicitly. Non-ASCII
alpha values or parameters are rejected until their code-page behavior is
verified. Parameter types must match the Paradox field type; the provider
does not silently coerce a string parameter to an integer or vice versa.

`ORDER BY` is performed in memory. If all requested order terms compare
equal, the physical record number is used as a stable tie-breaker. This is
not a claim of BDE collation, locale, index, or cursor-order parity. The
current provider reads and materializes the table's rows to evaluate
predicates and ordering; it does not use Paradox indexes for query execution.

NULL and deleted-record behavior is not yet established against the relevant
BDE semantics. Do not rely on SQL NULL semantics or on inclusion/exclusion of
deleted records until the separate synthetic-fixture read-contract work is
complete.

## Transactions and writes

`TSQLTransaction` is supported only as the SQLDB lifecycle/scope needed by
consumers. Its start, commit, and rollback methods do **not** create a native
Paradox transaction, provide snapshot isolation, or persist writes. The
connection remains read-only: SQLDB-generated `INSERT`, `UPDATE`, and
`DELETE` statements are unsupported and rejected.

`TDBParadoxWriteBuffer` is a separate prototype for staging opaque row images.
It provides read-your-writes resolution, rollback by discarding staged
changes, target prevalidation, and reverse-order compensation after an
ordinary in-process apply error. It is not wired to `TDBParadoxConnection`,
SQLDB DML, pxlib, or application workflows. A future target would have to
prove complete batch validation, all-or-nothing behavior for each apply, and
exact compensation. A failed compensation poisons the buffer and raises an
error. The prototype does not protect against process crashes, power loss,
or operating-system failures and must not be described as ACID or crash-safe.

pxlib write behavior and side effects on Paradox indexes and memo/blob files
have not been proven sufficiently for a production writer. Therefore no
provider write path is enabled by the presence of the buffer.

## Error behavior and resource lifetime

Provider/configuration failures use `EDBParadoxProviderError` or a descendant.
Unsupported SQL features and unsupported Paradox types fail explicitly
rather than being silently ignored or converted. A connection cannot
disconnect while a table cursor is still open; close datasets before
disconnecting. Cursors own their pxlib documents, streams, and record
buffers, and release them when closed or unprepared.

The implementation serializes pxlib calls with a process-wide lock. This
protects library calls from concurrent entry; it does not provide database
locking or isolation between processes.

## Tests

The standalone component tests are in `DBParadoxTests`. They cover
the strict SQL parser, the provider-neutral write-buffer contract using a
fake target, and SQLDB read integration against a synthetic Paradox fixture.
They never apply writes to a Paradox file.

Build and run them from PowerShell:

```powershell
Set-Location C:\Projekte\Delphi\Components\Source\DBParadoxTests
& C:\lazarus\lazbuild.exe .\DBParadoxTests.lpi
& ..\..\..\bin\x86_64-win64\DBParadoxTests.exe --all
```

The parser and fake-target tests need no Paradox fixture. To run the pxlib
integration cases, set both environment variables to a disposable synthetic
fixture directory and the matching pxlib 0.6.8 library before running the
test executable:

```powershell
$env:DBPARADOX_TEST_FIXTURE_DIR = 'C:\Path\To\SyntheticFixture'
$env:DBPARADOX_TEST_PXLIB = 'C:\Path\To\pxlib_x64.dll'
& ..\..\..\bin\x86_64-win64\DBParadoxTests.exe --all
```

The fixture must contain `Table13.DB` with the expected synthetic schema and
four test rows. If either variable is unset, the integration cases are
reported as ignored; this is not equivalent to having validated the read
integration. Never point this test suite at production genealogy data.

## Current limitations and evidence gates

- Read-only support is limited to the SQL and field types listed above.
- Paradox NULL and deleted-record semantics are still under investigation.
- BDE collation, secondary-index behavior, and locale equivalence are not
  claimed.
- Memo/blob reads, other Paradox types, DML, and native transactions are not
  supported.
- The in-memory buffer is not connected to this provider and is not a durable
  transaction mechanism.
- pxlib write and compensation behavior, including index/memo sidecar effects,
  must be established on fresh disposable fixtures before any write support
  is considered.