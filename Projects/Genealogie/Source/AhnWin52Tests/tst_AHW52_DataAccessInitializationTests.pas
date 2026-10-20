unit tst_AHW52_DataAccessInitializationTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms;

type
  TTestAHW52DataAccessInitialization = class(TTestCase)
  published
    procedure TestDataModuleStreamsParadoxDatasetsAndAppliesConfiguredLibrary;
    procedure TestMissingConfiguredLibraryRaisesExplicitError;
    procedure TestMissingTableFileRaisesExplicitErrorWithoutPartialAssignment;
  end;

implementation

uses
  Classes, SysUtils, Windows, GenealogyDataModule;

const
  PxLibraryEnvironmentVariable = 'AHNWIN52_PXLIBRARY';
  DataDirectoryEnvironmentVariable = 'AHNWIN52_DATA_DIRECTORY';

function SetTestEnvironmentVariable(const Name, Value: string): Boolean;
var
  variableName: AnsiString;
  variableValue: AnsiString;
begin
  variableName := Name;
  variableValue := Value;
  if variableValue = '' then
    Result := Windows.SetEnvironmentVariableA(PAnsiChar(variableName), nil)
  else
    Result := Windows.SetEnvironmentVariableA(PAnsiChar(variableName),
      PAnsiChar(variableValue));
end;

procedure CreateEmptyTableFile(const FileName: string);
var
  tableFile: TFileStream;
begin
  tableFile := TFileStream.Create(FileName, fmCreate);
  tableFile.Free;
end;

function CreateDataDirectoryFixture: string;
begin
  Result := IncludeTrailingPathDelimiter(GetTempDir(False)) +
    'ahnwin52-data-access-' + IntToStr(GetCurrentProcessId) + '-' +
    IntToStr(GetTickCount64);
  if DirectoryExists(Result) then
    raise EFOpenError.CreateFmt(
      'Test data directory "%s" already exists.', [Result]);
  if not ForceDirectories(Result) then
    raise EFOpenError.CreateFmt(
      'Could not create test data directory "%s".', [Result]);
  try
    CreateEmptyTableFile(IncludeTrailingPathDelimiter(Result) + 'awd.db');
    CreateEmptyTableFile(IncludeTrailingPathDelimiter(Result) + 'MRG.DB');
  except
    SysUtils.DeleteFile(IncludeTrailingPathDelimiter(Result) + 'awd.db');
    SysUtils.DeleteFile(IncludeTrailingPathDelimiter(Result) + 'MRG.DB');
    SysUtils.RemoveDir(Result);
    raise;
  end;
end;

procedure RemoveDataDirectoryFixture(const DataDirectory: string);
begin
  SysUtils.DeleteFile(IncludeTrailingPathDelimiter(DataDirectory) + 'awd.db');
  SysUtils.DeleteFile(IncludeTrailingPathDelimiter(DataDirectory) + 'MRG.DB');
  if not SysUtils.RemoveDir(DataDirectory) then
    raise Exception.CreateFmt(
      'Could not remove test data directory "%s".', [DataDirectory]);
end;

procedure TTestAHW52DataAccessInitialization.
  TestDataModuleStreamsParadoxDatasetsAndAppliesConfiguredLibrary;
var
  dataModule: TGenealogyDataModule;
  dataDirectory: string;
  previousDataDirectory: string;
  previousLibraryPath: string;
  configuredLibraryPath: string;
begin
  Application.Initialize;
  previousDataDirectory := SysUtils.GetEnvironmentVariable(
    DataDirectoryEnvironmentVariable);
  previousLibraryPath := SysUtils.GetEnvironmentVariable(
    PxLibraryEnvironmentVariable);
  configuredLibraryPath := ExpandFileName(ParamStr(0));
  dataDirectory := CreateDataDirectoryFixture;
  dataModule := nil;
  try
    AssertTrue('The data-directory environment variable should be set.',
      SetTestEnvironmentVariable(DataDirectoryEnvironmentVariable,
        dataDirectory));
    AssertTrue('The pxlib environment variable should be set.',
      SetTestEnvironmentVariable(PxLibraryEnvironmentVariable,
        configuredLibraryPath));
    dataModule := TGenealogyDataModule.Create(nil);
    AssertEquals('awd.db', dataModule.Table17.FileName);
    AssertEquals('MRG.DB', dataModule.Table18.FileName);
    dataModule.InitializeDataAccess;
    AssertEquals(ExpandFileName(dataDirectory + '\awd.db'),
      dataModule.Table17.FileName);
    AssertEquals(ExpandFileName(dataDirectory + '\MRG.DB'),
      dataModule.Table18.FileName);
    AssertTrue('DataSource17 remains attached to Table17.',
      dataModule.DataSource17.DataSet = dataModule.Table17);
    AssertTrue('DataSource18 remains attached to Table18.',
      dataModule.DataSource18.DataSet = dataModule.Table18);
    AssertTrue('Table17 persistent fields are streamed.',
      dataModule.Table17.FindField('Nummer') <> nil);
    AssertTrue('Table18 persistent fields are streamed.',
      dataModule.Table18.FindField('Nummer') <> nil);
    AssertEquals(configuredLibraryPath, dataModule.Table17.PXLibrary);
    AssertEquals(configuredLibraryPath, dataModule.Table18.PXLibrary);
  finally
    try
      dataModule.Free;
      if not SetTestEnvironmentVariable(DataDirectoryEnvironmentVariable,
        previousDataDirectory) then
        RaiseLastOSError;
      if not SetTestEnvironmentVariable(PxLibraryEnvironmentVariable,
        previousLibraryPath) then
        RaiseLastOSError;
    finally
      RemoveDataDirectoryFixture(dataDirectory);
    end;
  end;
end;

procedure TTestAHW52DataAccessInitialization.
  TestMissingConfiguredLibraryRaisesExplicitError;
var
  dataModule: TGenealogyDataModule;
  dataDirectory: string;
  previousDataDirectory: string;
  previousLibraryPath: string;
  missingLibraryPath: string;
  errorWasRaised: Boolean;
begin
  Application.Initialize;
  previousDataDirectory := SysUtils.GetEnvironmentVariable(
    DataDirectoryEnvironmentVariable);
  previousLibraryPath := SysUtils.GetEnvironmentVariable(
    PxLibraryEnvironmentVariable);
  missingLibraryPath := IncludeTrailingPathDelimiter(GetTempDir(False)) +
    'ahnwin52-missing-pxlib-' + IntToStr(GetCurrentProcessId) + '-' +
    IntToStr(GetTickCount64) + '.dll';
  dataDirectory := CreateDataDirectoryFixture;
  dataModule := nil;
  try
    AssertTrue('The data-directory environment variable should be set.',
      SetTestEnvironmentVariable(DataDirectoryEnvironmentVariable,
        dataDirectory));
    AssertTrue('The pxlib environment variable should be set.',
      SetTestEnvironmentVariable(PxLibraryEnvironmentVariable,
        missingLibraryPath));
    dataModule := TGenealogyDataModule.Create(nil);
    errorWasRaised := False;
    try
      dataModule.InitializeDataAccess;
    except
      on E: EFOpenError do
        errorWasRaised := True;
    end;
    AssertTrue('A missing configured pxlib file must fail explicitly.',
      errorWasRaised);
  finally
    try
      dataModule.Free;
      if not SetTestEnvironmentVariable(DataDirectoryEnvironmentVariable,
        previousDataDirectory) then
        RaiseLastOSError;
      if not SetTestEnvironmentVariable(PxLibraryEnvironmentVariable,
        previousLibraryPath) then
        RaiseLastOSError;
    finally
      RemoveDataDirectoryFixture(dataDirectory);
    end;
  end;
end;

procedure TTestAHW52DataAccessInitialization.
  TestMissingTableFileRaisesExplicitErrorWithoutPartialAssignment;
var
  dataModule: TGenealogyDataModule;
  dataDirectory: string;
  previousDataDirectory: string;
  previousLibraryPath: string;
  errorMessage: string;
begin
  Application.Initialize;
  previousDataDirectory := SysUtils.GetEnvironmentVariable(
    DataDirectoryEnvironmentVariable);
  previousLibraryPath := SysUtils.GetEnvironmentVariable(
    PxLibraryEnvironmentVariable);
  dataDirectory := CreateDataDirectoryFixture;
  dataModule := nil;
  try
    AssertTrue('The second table stub should be removed.',
      SysUtils.DeleteFile(
        IncludeTrailingPathDelimiter(dataDirectory) + 'MRG.DB'));
    AssertTrue('The data-directory environment variable should be set.',
      SetTestEnvironmentVariable(DataDirectoryEnvironmentVariable,
        dataDirectory));
    AssertTrue('The pxlib environment variable should be set.',
      SetTestEnvironmentVariable(PxLibraryEnvironmentVariable,
        ExpandFileName(ParamStr(0))));
    dataModule := TGenealogyDataModule.Create(nil);
    errorMessage := '';
    try
      dataModule.InitializeDataAccess;
    except
      on E: EFOpenError do
        errorMessage := E.Message;
    end;
    AssertTrue('The missing MRG.DB error identifies its path.',
      Pos('MRG.DB', errorMessage) > 0);
    AssertEquals('Initialization does not partially replace Table17.FileName.',
      'awd.db', dataModule.Table17.FileName);
    AssertEquals('Initialization does not partially replace Table18.FileName.',
      'MRG.DB', dataModule.Table18.FileName);
  finally
    try
      dataModule.Free;
      if not SetTestEnvironmentVariable(DataDirectoryEnvironmentVariable,
        previousDataDirectory) then
        RaiseLastOSError;
      if not SetTestEnvironmentVariable(PxLibraryEnvironmentVariable,
        previousLibraryPath) then
        RaiseLastOSError;
    finally
      RemoveDataDirectoryFixture(dataDirectory);
    end;
  end;
end;

initialization
  RegisterTest(TTestAHW52DataAccessInitialization);

end.
