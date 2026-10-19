program DBParadoxTests;

{$mode objfpc}{$H+}

uses
  consoletestrunner,
  tst_DBParadoxConnection,
  tst_DBParadoxDMLExecutor,
  tst_DBParadoxFamilyPublisher,
  tst_DBParadoxFamilyLock,
  tst_DBParadoxFileReader,
  tst_DBParadoxIndexFileBuilder,
  tst_DBParadoxPrimaryKeyDiscovery,
  tst_DBParadoxRecordEncoder,
  tst_DBParadoxSecondaryIndexBuilder,
  tst_DBParadoxTableFileBuilder,
  tst_DBParadoxSQLParser,
  tst_DBParadoxStagedTable,
  tst_DBParadoxWriteBuffer;

var
  TestRunner: TTestRunner;
begin
  TestRunner := TTestRunner.Create(nil);
  try
    TestRunner.Initialize;
    TestRunner.Run;
  finally
    TestRunner.Free;
  end;
end.
