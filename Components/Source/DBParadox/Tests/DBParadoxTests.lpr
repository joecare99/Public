program DBParadoxTests;

{$mode objfpc}{$H+}

uses
  SysUtils,
  consoletestrunner,
  tst_DBParadoxConnection,
  tst_DBParadoxDMLExecutor,
  tst_DBParadoxFamilyPublisher,
  tst_DBParadoxFamilyLock,
  tst_DBParadoxFamilySnapshot,
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
  if (ParamCount = 4) and
    (ParamStr(1) = '--dbparadox-crash-writer') then
  begin
    RunPublisherCrashChild(ParamStr(4), StrToInt(ParamStr(2)),
      StrToInt(ParamStr(3)));
    Halt(0);
  end;
  if (ParamCount = 3) and
    (ParamStr(1) = '--dbparadox-crash-recovery') then
  begin
    RunRecoveryCrashChild(ParamStr(3), StrToInt(ParamStr(2)));
    Halt(0);
  end;
  if (ParamCount = 5) and
    (ParamStr(1) = '--dbparadox-crash-bde-writer') then
  begin
    RunBdePublisherCrashChild(ParamStr(5), StrToInt(ParamStr(2)),
      StrToInt(ParamStr(3)), StrToInt(ParamStr(4)));
    Halt(0);
  end;
  TestRunner := TTestRunner.Create(nil);
  try
    TestRunner.Initialize;
    TestRunner.Run;
  finally
    TestRunner.Free;
  end;
end.
