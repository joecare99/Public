program Unit14NonUniqueFindKeyBDEProbe;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows, DB, DBTables;

type
  TProbeTable = class(TTable)
  public
    function LanguageDriver: string;
  end;

function TProbeTable.LanguageDriver: string;
begin
  Result := GetLanguageDriverName;
end;

function CreateFixtureDirectory: string;
var
  TempDirectory: string;
  Candidate: string;
begin
  TempDirectory := GetEnvironmentVariable('TEMP');
  if TempDirectory = '' then
    raise Exception.Create('TEMP is not set');
  TempDirectory := IncludeTrailingPathDelimiter(TempDirectory);
  repeat
    Candidate := TempDirectory + 'AhnWin52-Unit14-NonUnique-' +
      FormatDateTime('yyyymmddhhnnsszzz', Now);
  until not DirectoryExists(Candidate);
  if not ForceDirectories(Candidate) then
    raise Exception.CreateFmt('Cannot create fixture directory: %s',
      [Candidate]);
  Result := Candidate;
end;

function CreateNetDirectory: string;
var
  TempDirectory: string;
  Candidate: string;
begin
  TempDirectory := GetEnvironmentVariable('TEMP');
  if TempDirectory = '' then
    raise Exception.Create('TEMP is not set');
  TempDirectory := IncludeTrailingPathDelimiter(TempDirectory);
  repeat
    Candidate := TempDirectory + 'AhnWin52-Unit14-NonUnique-Net-' +
      FormatDateTime('yyyymmddhhnnsszzz', Now);
  until not DirectoryExists(Candidate);
  if not ForceDirectories(Candidate) then
    raise Exception.CreateFmt('Cannot create BDE net directory: %s',
      [Candidate]);
  Result := Candidate;
end;

function LoadedBDEModulePath: string;
var
  ModuleHandle: HMODULE;
  Buffer: array[0..MAX_PATH - 1] of Char;
  PathLength: DWORD;
begin
  ModuleHandle := GetModuleHandle('IDAPI32.DLL');
  if ModuleHandle = 0 then
    raise Exception.Create('IDAPI32.DLL is not loaded');
  PathLength := GetModuleFileName(ModuleHandle, Buffer, SizeOf(Buffer));
  if PathLength = 0 then
    RaiseLastOSError;
  SetString(Result, Buffer, PathLength);
end;

procedure ValidateSyntheticFixtureDirectory(const FixtureDirectory: string);
const
  ExpectedFiles: array[0..3] of string =
    ('Table13.db', 'Table13.PX', 'Table13.XG0', 'Table13.YG0');
var
  TempDirectory: string;
  FullDirectory: string;
  Search: TSearchRec;
  FileIndex: Integer;
  FoundCount: Integer;
  KnownFile: Boolean;
begin
  TempDirectory := GetEnvironmentVariable('TEMP');
  if TempDirectory = '' then
    raise Exception.Create('TEMP is not set');
  TempDirectory := IncludeTrailingPathDelimiter(ExpandFileName(TempDirectory));
  FullDirectory := IncludeTrailingPathDelimiter(ExpandFileName(FixtureDirectory));
  if CompareText(Copy(FullDirectory, 1, Length(TempDirectory)),
    TempDirectory) <> 0 then
    raise Exception.Create('The BDE probe accepts only a fixture under TEMP');
  if Pos('AhnWin52-Unit14-NonUnique-', ExtractFileName(
    ExcludeTrailingPathDelimiter(FullDirectory))) <> 1 then
    raise Exception.Create('The BDE probe accepts only its named fixture');

  FoundCount := 0;
  if SysUtils.FindFirst(FullDirectory + '*', faAnyFile, Search) <> 0 then
    raise Exception.Create('Cannot enumerate the synthetic fixture directory');
  try
    repeat
      if (Search.Name <> '.') and (Search.Name <> '..') then
      begin
        if (Search.Attr and faDirectory) <> 0 then
          raise Exception.Create('Unexpected subdirectory in BDE fixture');
        KnownFile := False;
        for FileIndex := Low(ExpectedFiles) to High(ExpectedFiles) do
          if SameText(Search.Name, ExpectedFiles[FileIndex]) then
            KnownFile := True;
        if not KnownFile then
          raise Exception.CreateFmt('Unexpected file in BDE fixture: %s',
            [Search.Name]);
        Inc(FoundCount);
      end;
    until SysUtils.FindNext(Search) <> 0;
  finally
    SysUtils.FindClose(Search);
  end;
  if FoundCount <> Length(ExpectedFiles) then
    raise Exception.Create('The synthetic BDE fixture is incomplete');
end;

procedure AddSyntheticPlace(Table: TTable; ID: Integer;
  const PlaceName: string);
begin
  Table.Append;
  Table.FieldByName('ID').AsInteger := ID;
  Table.FieldByName('Ort').AsString := PlaceName;
  Table.Post;
end;

procedure CreateFixture;
var
  FixtureDirectory: string;
  NetDirectory: string;
  Database: TDatabase;
  Table: TProbeTable;
  IndexDef: TIndexDef;
begin
  FixtureDirectory := CreateFixtureDirectory;
  NetDirectory := CreateNetDirectory;
  WriteLn('FIXTURE=', FixtureDirectory);
  WriteLn('NET_DIRECTORY=', NetDirectory);
  Session.PrivateDir := FixtureDirectory;
  Session.NetFileDir := NetDirectory;

  Database := TDatabase.Create(nil);
  Table := TProbeTable.Create(nil);
  try
    Database.DatabaseName := 'Unit14NonUniqueSynthetic';
    Database.DriverName := 'STANDARD';
    Database.LoginPrompt := False;
    Database.Params.Values['PATH'] := FixtureDirectory;
    Database.Connected := True;
    Table.DatabaseName := Database.DatabaseName;
    Table.TableName := 'Table13.db';
    Table.TableType := ttParadox;
    Table.Exclusive := True;
    Table.FieldDefs.Add('ID', ftInteger, 0, False);
    Table.FieldDefs.Add('Ort', ftString, 40, False);
    Table.IndexDefs.Add('', 'ID', [ixPrimary, ixUnique]);
    Table.CreateTable;
    Table.Open;
    WriteLn('LANGUAGE_DRIVER=', Table.LanguageDriver);
    AddSyntheticPlace(Table, 2, 'SyntheticDuplicate');
    AddSyntheticPlace(Table, 1, 'SyntheticDuplicate');
    AddSyntheticPlace(Table, 3, 'SyntheticOther');
    Table.AddIndex('Ort_', 'Ort', [ixCaseInsensitive]);
    Table.IndexDefs.Update;
    IndexDef := Table.IndexDefs.Find('Ort_');
    if (IndexDef = nil) or (CompareText(IndexDef.Fields, 'Ort') <> 0) or
      (ixUnique in IndexDef.Options) then
      raise Exception.Create('The expected non-unique Ort_ index is missing');
    Table.IndexName := 'Ort_';
    Table.First;
    WriteLn('INDEX_NAME=', IndexDef.Name,
      ' INDEX_FIELDS=Ort UNIQUE=0 DESCENDING=',
      Ord(ixDescending in IndexDef.Options),
      ' CASE_INSENSITIVE=', Ord(ixCaseInsensitive in IndexDef.Options));
    Table.Close;
    Database.Close;
    WriteLn('BDE_MODULE=', LoadedBDEModulePath);
    WriteLn('RESULT=FIXTURE_CREATED');
  finally
    Table.Free;
    Database.Free;
  end;
end;

procedure ProbeFixture(const FixtureDirectory: string);
var
  NetDirectory: string;
  Database: TDatabase;
  Table: TProbeTable;
  IndexDef: TIndexDef;
  Found: Boolean;
  HitID: Integer;
  MissID: Integer;
begin
  ValidateSyntheticFixtureDirectory(FixtureDirectory);
  NetDirectory := CreateNetDirectory;
  Session.PrivateDir := FixtureDirectory;
  Session.NetFileDir := NetDirectory;
  WriteLn('NET_DIRECTORY=', NetDirectory);
  Database := TDatabase.Create(nil);
  Table := TProbeTable.Create(nil);
  try
    Database.DatabaseName := 'Unit14NonUniqueReadOnly';
    Database.DriverName := 'STANDARD';
    Database.LoginPrompt := False;
    Database.Params.Values['PATH'] := FixtureDirectory;
    Database.Connected := True;
    Table.DatabaseName := Database.DatabaseName;
    Table.TableName := 'Table13.db';
    Table.TableType := ttParadox;
    Table.ReadOnly := True;
    Table.Open;
    WriteLn('LANGUAGE_DRIVER=', Table.LanguageDriver);
    Table.IndexDefs.Update;
    IndexDef := Table.IndexDefs.Find('Ort_');
    if (IndexDef = nil) or (CompareText(IndexDef.Fields, 'Ort') <> 0) or
      (ixUnique in IndexDef.Options) then
      raise Exception.Create('Read-only open found an unexpected Ort_ index');
    Table.IndexName := 'Ort_';
    WriteLn('BDE_MODULE=', LoadedBDEModulePath);
    WriteLn('INDEX_NAME=', Table.IndexName,
      ' INDEX_FIELDS=Ort UNIQUE=0 CASE_INSENSITIVE=1');

    Table.First;
    Found := Table.FindKey(['SyntheticDuplicate']);
    if not Found then
      raise Exception.Create('The synthetic duplicate hit was not found');
    HitID := Table.FieldByName('ID').AsInteger;
    if (HitID <> 1) and (HitID <> 2) then
      raise Exception.Create('The duplicate hit selected a nonmatching row');
    WriteLn('HIT_FOUND=1 HIT_ID=', HitID, ' BOF=', Ord(Table.BOF),
      ' EOF=', Ord(Table.EOF), ' RECNO=', Table.RecNo);

    Table.First;
    Found := Table.FindKey(['SyntheticAbsent']);
    if Found or Table.IsEmpty or Table.EOF then
      raise Exception.Create('The non-unique index miss state is invalid');
    MissID := Table.FieldByName('ID').AsInteger;
    WriteLn('MISS_FOUND=0 MISS_ID=', MissID, ' BOF=', Ord(Table.BOF),
      ' EOF=', Ord(Table.EOF), ' RECNO=', Table.RecNo);
    Table.Close;
    Database.Close;
    WriteLn('RESULT=PASS');
  finally
    Table.Free;
    Database.Free;
  end;
end;

var
  Mode: string;
begin
  try
    if ParamCount = 0 then
      raise Exception.Create('Use --create or --probe <fixture-directory>');
    Mode := ParamStr(1);
    if SameText(Mode, '--create') and (ParamCount = 1) then
      CreateFixture
    else if SameText(Mode, '--probe') and (ParamCount = 2) then
      ProbeFixture(ExpandFileName(ParamStr(2)))
    else
      raise Exception.Create('Use --create or --probe <fixture-directory>');
  except
    on E: Exception do
    begin
      WriteLn('ERROR=', E.ClassName, ': ', E.Message);
      Halt(1);
    end;
  end;
end.
