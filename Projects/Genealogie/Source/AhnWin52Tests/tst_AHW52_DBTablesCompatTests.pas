unit tst_AHW52_DBTablesCompatTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testutils, testregistry;

type
  TTestAHW52DBTablesCompat = class(TTestCase)
  published
    procedure TestRejectsLegacyQueryConstruction;
  end;

implementation

uses
  SysUtils, DBTables, DBTablesCompatErrors;

procedure AssertQueryConstructionFailsExplicitly;
var
  query: TQuery;
begin
  try
    query := TQuery.Create(nil);
    query.Free;
  except
    on E: EDBTablesCompatibilityUnsupported do
    begin
      if E.Operation <> 'TQuery.Create' then
        raise Exception.CreateFmt(
          'Expected unsupported operation "TQuery.Create", got "%s".',
          [E.Operation]);
      Exit;
    end;
  end;

  raise Exception.Create(
    'The DBTables compile-only query component was constructed.');
end;

procedure TTestAHW52DBTablesCompat.TestRejectsLegacyQueryConstruction;
begin
  AssertQueryConstructionFailsExplicitly;
end;

initialization
  RegisterTest(TTestAHW52DBTablesCompat);

end.
