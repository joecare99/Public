program Unit14FindKeyBDEProbe;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, Windows, DB, DBTables;

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
    Candidate := TempDirectory + 'AhnWin52-Unit14-FindKey-' +
      FormatDateTime('yyyymmddhhnnsszzz', Now);
  until not DirectoryExists(Candidate);

  if not ForceDirectories(Candidate) then
    raise Exception.CreateFmt('Cannot create fixture directory: %s',
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

procedure AddSyntheticPlace(Table: TTable; ID: Integer;
  const PlaceName: string);
begin
  Table.Append;
  Table.FieldByName('ID').AsInteger := ID;
  Table.FieldByName('Ort').AsString := PlaceName;
  Table.Post;
end;

procedure PrintCursorState(Table: TTable);
begin
  Write('BOF=', Ord(Table.BOF), ' EOF=', Ord(Table.EOF), ' RecNo=',
    Table.RecNo);
  if not Table.IsEmpty and not Table.EOF then
    Write(' Ort=', Table.FieldByName('Ort').AsString);
  WriteLn;
end;

var
  FixtureDirectory: string;
  Database: TDatabase;
  Table: TTable;
  IndexDef: TIndexDef;
  Found: Boolean;
begin
  Database := nil;
  Table := nil;
  try
    FixtureDirectory := CreateFixtureDirectory;
    WriteLn('FIXTURE=', FixtureDirectory);

    Session.PrivateDir := FixtureDirectory;
    Session.NetFileDir := FixtureDirectory;

    Database := TDatabase.Create(nil);
    Database.DatabaseName := 'Unit14FindKeySynthetic';
    Database.DriverName := 'STANDARD';
    Database.LoginPrompt := False;
    Database.Params.Values['PATH'] := FixtureDirectory;
    Database.Connected := True;
    WriteLn('BDE_MODULE=', LoadedBDEModulePath);

    Table := TTable.Create(nil);
    Table.DatabaseName := Database.DatabaseName;
    Table.TableName := 'Table13.db';
    Table.TableType := ttParadox;
    Table.Exclusive := True;
    Table.FieldDefs.Add('ID', ftInteger, 0, False);
    Table.FieldDefs.Add('Ort', ftString, 40, False);
    Table.IndexDefs.Add('', 'ID', [ixPrimary, ixUnique]);
    Table.CreateTable;
    WriteLn('TABLE_CREATED=1');

    Table.Open;
    AddSyntheticPlace(Table, 1, 'Berlin');
    AddSyntheticPlace(Table, 2, 'Dresden');
    AddSyntheticPlace(Table, 3, 'Muenchen');
    { Paradox requires an option to name a plain single-field index differently. }
    Table.AddIndex('Ort_', 'Ort', [ixUnique]);
    Table.IndexDefs.Update;
    IndexDef := Table.IndexDefs.Find('Ort_');
    if (IndexDef = nil) or (IndexDef.Fields <> 'Ort') then
      raise Exception.Create('Synthetic Ort_ index definition is missing');
    Table.IndexName := 'Ort_';
    WriteLn('INDEX_NAME=', Table.IndexName, ' INDEX_FIELDS=', IndexDef.Fields,
      ' UNIQUE=', Ord(ixUnique in IndexDef.Options),
      ' DESCENDING=', Ord(ixDescending in IndexDef.Options));

    Table.First;
    Found := Table.FindKey(['Dresden']);
    Write('HIT_FOUND=', Ord(Found), ' ');
    PrintCursorState(Table);
    if not Found or (Table.FieldByName('Ort').AsString <> 'Dresden') then
      raise Exception.Create('Synthetic known-hit assertion failed');

    Table.First;
    Found := Table.FindKey(['Hamburg']);
    Write('MISS_FOUND=', Ord(Found), ' ');
    PrintCursorState(Table);
    if Found then
      raise Exception.Create('Synthetic known-miss assertion failed');

    Table.Close;
    Database.Close;
    WriteLn('RESULT=PASS');
  except
    on E: EDBEngineError do
    begin
      WriteLn('ERROR=', E.ClassName, ': ', E.Message);
      if E.ErrorCount > 0 then
        WriteLn('DBI_ERROR_CODE=', E.Errors[0].ErrorCode,
          ' NATIVE_ERROR=', E.Errors[0].NativeError,
          ' CATEGORY=', E.Errors[0].Category,
          ' SUBCODE=', E.Errors[0].SubCode);
      if Assigned(Table) and Table.Active then
        Table.Close;
      if Assigned(Database) and Database.Connected then
        Database.Close;
      Halt(1);
    end;
    on E: Exception do
    begin
      WriteLn('ERROR=', E.ClassName, ': ', E.Message);
      if Assigned(Table) and Table.Active then
        Table.Close;
      if Assigned(Database) and Database.Connected then
        Database.Close;
      Halt(1);
    end;
  end;
  Table.Free;
  Database.Free;
end.
