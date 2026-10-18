program Unit15CompositeFindKeyBDEProbe;

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
    Candidate := TempDirectory + 'AhnWin52-Unit15-FindKey-' +
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

procedure PrintCursorState(Table: TTable; const DisplayField: string);
begin
  Write('BOF=', Ord(Table.BOF), ' EOF=', Ord(Table.EOF), ' RecNo=',
    Table.RecNo, ' ', DisplayField, '=');
  if not Table.IsEmpty and not Table.EOF then
    Write(Table.FieldByName(DisplayField).AsString)
  else
    Write('<no-current-record>');
  WriteLn;
end;

procedure AssertMissCursorState(Table: TTable; const ErrorMessage: string);
begin
  if not Table.BOF or Table.EOF or Table.IsEmpty or (Table.RecNo < 1) then
    raise Exception.Create(ErrorMessage);
end;

procedure AddMarriage(Table: TTable; PersonNumber: Integer;
  const Year, Month, Relation: string);
begin
  Table.Append;
  Table.FieldByName('Nummer').AsInteger := PersonNumber;
  Table.FieldByName('Epnum').AsInteger := 0;
  Table.FieldByName('Indj').AsString := Year;
  Table.FieldByName('Indm').AsString := Month;
  Table.FieldByName('Verbind').AsString := Relation;
  Table.Post;
end;

procedure AddPerson(Table: TTable; Number, Father, Mother: Integer;
  const BirthYear, BaptismYear, Year, Month, Day: string);
begin
  Table.Append;
  Table.FieldByName('Nummer').AsInteger := Number;
  Table.FieldByName('Vater').AsInteger := Father;
  Table.FieldByName('Mutter').AsInteger := Mother;
  Table.FieldByName('Gebjahr').AsString := BirthYear;
  Table.FieldByName('Taufjahr').AsString := BaptismYear;
  Table.FieldByName('Indj').AsString := Year;
  Table.FieldByName('Indm').AsString := Month;
  Table.FieldByName('Indt').AsString := Day;
  Table.Post;
end;

procedure AddAndVerifyIndex(Table: TTable; const IndexName, Fields: string);
var
  IndexDef: TIndexDef;
begin
  Table.AddIndex(IndexName, Fields, []);
  Table.IndexDefs.Update;
  IndexDef := Table.IndexDefs.Find(IndexName);
  if (IndexDef = nil) or (CompareText(IndexDef.Fields, Fields) <> 0) then
    raise Exception.CreateFmt('Synthetic index %s on %s was not created',
      [IndexName, Fields]);
  WriteLn('INDEX_NAME=', IndexDef.Name, ' INDEX_FIELDS=', IndexDef.Fields,
    ' UNIQUE=', Ord(ixUnique in IndexDef.Options),
    ' DESCENDING=', Ord(ixDescending in IndexDef.Options));
end;

procedure ProbeTable18(const DatabaseName: string);
var
  Table: TTable;
  Found: Boolean;
begin
  Table := TTable.Create(nil);
  try
    Table.DatabaseName := DatabaseName;
    Table.TableName := 'MRG.DB';
    Table.TableType := ttParadox;
    Table.Exclusive := True;
    Table.FieldDefs.Add('Numr', ftAutoInc, 0, False);
    Table.FieldDefs.Add('Nummer', ftInteger, 0, False);
    Table.FieldDefs.Add('Epnum', ftInteger, 0, False);
    Table.FieldDefs.Add('Indj', ftString, 4, False);
    Table.FieldDefs.Add('Indm', ftString, 2, False);
    Table.FieldDefs.Add('Verbind', ftString, 20, False);
    Table.IndexDefs.Add('', 'Numr', [ixPrimary, ixUnique]);
    Table.CreateTable;
    Table.Open;

    AddMarriage(Table, 900, '1980', '02', 'Ehes');
    AddMarriage(Table, 1, '1970', '01', 'Ehes');
    AddMarriage(Table, 1, '1960', '12', 'other');
    AddAndVerifyIndex(Table, 'num', 'Nummer;Indj;Indm');

    Table.First;
    Write('MRG_DEFAULT_INDEX=', Table.IndexName, ' ');
    Found := Table.FindKey([1]);
    Write('MRG_PRIMARY_KEY_1_FOUND=', Ord(Found), ' ');
    PrintCursorState(Table, 'Nummer');
    if not Found or (Table.FieldByName('Numr').AsInteger <> 1) then
      raise Exception.Create('Synthetic MRG primary-index lookup mismatch');

    Table.First;
    Found := Table.FindKey([777]);
    Write('MRG_PRIMARY_PREFIX_777_FOUND=', Ord(Found), ' ');
    PrintCursorState(Table, 'Verbind');
    if Found or (Table.FieldByName('Verbind').AsString <> 'Ehes') then
      raise Exception.Create('Synthetic MRG primary-index miss state changed');
    AssertMissCursorState(Table, 'Synthetic MRG primary miss cursor changed');

    Table.IndexName := 'num';
    Table.First;
    Found := Table.FindKey([1]);
    Write('MRG_NUM_PREFIX_1_FOUND=', Ord(Found), ' ');
    PrintCursorState(Table, 'Indj');
    if not Found or (Table.FieldByName('Nummer').AsInteger <> 1) then
      raise Exception.Create('Synthetic MRG num prefix hit failed');

    Table.First;
    Found := Table.FindKey([777]);
    Write('MRG_NUM_PREFIX_777_FOUND=', Ord(Found), ' ');
    PrintCursorState(Table, 'Verbind');
    if Found or (Table.FieldByName('Verbind').AsString <> 'other') then
      raise Exception.Create('Synthetic MRG num miss current row changed');
    AssertMissCursorState(Table, 'Synthetic MRG num miss cursor changed');

    Table.Close;
  finally
    Table.Free;
  end;
end;

procedure ProbeTable8(const DatabaseName: string);
var
  Table: TTable;
  Found: Boolean;
begin
  Table := TTable.Create(nil);
  try
    Table.DatabaseName := DatabaseName;
    Table.TableName := 'AWD.DB';
    Table.TableType := ttParadox;
    Table.Exclusive := True;
    Table.FieldDefs.Add('Nummer', ftInteger, 0, False);
    Table.FieldDefs.Add('Vater', ftInteger, 0, False);
    Table.FieldDefs.Add('Mutter', ftInteger, 0, False);
    Table.FieldDefs.Add('Gebjahr', ftString, 4, False);
    Table.FieldDefs.Add('Taufjahr', ftString, 4, False);
    Table.FieldDefs.Add('Indj', ftString, 4, False);
    Table.FieldDefs.Add('Indm', ftString, 2, False);
    Table.FieldDefs.Add('Indt', ftString, 2, False);
    Table.IndexDefs.Add('', 'Nummer', [ixPrimary, ixUnique]);
    Table.CreateTable;
    Table.Open;

    AddPerson(Table, 100, 5, 8, '1960', '1960', '1970', '01', '02');
    AddPerson(Table, 101, 5, 9, '1970', '1970', '1960', '12', '31');
    AddPerson(Table, 102, 6, 8, '1950', '1950', '1950', '05', '10');
    AddAndVerifyIndex(Table, 'vat', 'Vater;Indj;Indm;Indt');
    AddAndVerifyIndex(Table, 'mut', 'Mutter;Indj;Indm;Indt');

    Table.IndexName := 'vat';
    Table.First;
    Found := Table.FindKey([5]);
    Write('AWD_VAT_PREFIX_5_FOUND=', Ord(Found), ' ');
    PrintCursorState(Table, 'Nummer');
    if not Found or (Table.FieldByName('Nummer').AsInteger <> 101) then
      raise Exception.Create('Synthetic AWD vat prefix hit mismatch');

    Table.First;
    Found := Table.FindKey([77]);
    Write('AWD_VAT_PREFIX_77_FOUND=', Ord(Found), ' ');
    PrintCursorState(Table, 'Nummer');
    if Found or (Table.FieldByName('Nummer').AsInteger <> 101) then
      raise Exception.Create('Synthetic AWD vat miss current row changed');
    AssertMissCursorState(Table, 'Synthetic AWD vat miss cursor changed');

    Table.IndexName := 'mut';
    Table.First;
    Found := Table.FindKey([8]);
    Write('AWD_MUT_PREFIX_8_FOUND=', Ord(Found), ' ');
    PrintCursorState(Table, 'Nummer');
    if not Found or (Table.FieldByName('Nummer').AsInteger <> 102) then
      raise Exception.Create('Synthetic AWD mut prefix hit mismatch');

    Table.First;
    Found := Table.FindKey([77]);
    Write('AWD_MUT_PREFIX_77_FOUND=', Ord(Found), ' ');
    PrintCursorState(Table, 'Nummer');
    if Found or (Table.FieldByName('Nummer').AsInteger <> 102) then
      raise Exception.Create('Synthetic AWD mut miss current row changed');
    AssertMissCursorState(Table, 'Synthetic AWD mut miss cursor changed');

    Table.Filter := 'Gebjahr<=1965 and Taufjahr<=1965';
    Table.Filtered := True;
    Table.IndexName := 'vat';
    Table.First;
    Found := Table.FindKey([5]);
    Write('AWD_FILTERED_VAT_PREFIX_5_FOUND=', Ord(Found), ' ');
    PrintCursorState(Table, 'Nummer');
    if not Found or (Table.FieldByName('Nummer').AsInteger <> 100) then
      raise Exception.Create('Synthetic AWD filtered vat lookup mismatch');

    Table.First;
    Found := Table.FindKey([77]);
    Write('AWD_FILTERED_VAT_PREFIX_77_FOUND=', Ord(Found), ' ');
    PrintCursorState(Table, 'Nummer');
    if Found or (Table.FieldByName('Nummer').AsInteger <> 100) then
      raise Exception.Create('Synthetic AWD filtered miss current row changed');
    AssertMissCursorState(Table, 'Synthetic AWD filtered miss cursor changed');
    Table.Filtered := False;

    Table.Close;
  finally
    Table.Free;
  end;
end;

procedure ProbeTable9(const DatabaseName: string);
var
  Table: TTable;
  Found: Boolean;
begin
  Table := TTable.Create(nil);
  try
    Table.DatabaseName := DatabaseName;
    Table.TableName := 'AWD9.DB';
    Table.TableType := ttParadox;
    Table.Exclusive := True;
    Table.FieldDefs.Add('Nummer', ftInteger, 0, False);
    Table.FieldDefs.Add('Gebjahr', ftString, 4, False);
    Table.FieldDefs.Add('Taufjahr', ftString, 4, False);
    Table.IndexDefs.Add('', 'Nummer', [ixPrimary, ixUnique]);
    Table.CreateTable;
    Table.Open;

    Table.Append;
    Table.FieldByName('Nummer').AsInteger := 101;
    Table.FieldByName('Gebjahr').AsString := '1970';
    Table.FieldByName('Taufjahr').AsString := '1970';
    Table.Post;
    Table.Append;
    Table.FieldByName('Nummer').AsInteger := 102;
    Table.FieldByName('Gebjahr').AsString := '1960';
    Table.FieldByName('Taufjahr').AsString := '1960';
    Table.Post;

    Table.Filter := 'Gebjahr<=1965 and Taufjahr<=1965';
    Table.Filtered := True;
    Table.First;
    Found := Table.FindKey([101]);
    Write('AWD9_FILTERED_PRIMARY_101_FOUND=', Ord(Found), ' ');
    PrintCursorState(Table, 'Nummer');
    if Found or (Table.FieldByName('Nummer').AsInteger <> 102) then
      raise Exception.Create('Synthetic AWD9 filtered miss current row changed');
    AssertMissCursorState(Table, 'Synthetic AWD9 filtered miss cursor changed');

    Table.First;
    Found := Table.FindKey([102]);
    Write('AWD9_FILTERED_PRIMARY_102_FOUND=', Ord(Found), ' ');
    PrintCursorState(Table, 'Nummer');
    if not Found or (Table.FieldByName('Nummer').AsInteger <> 102) then
      raise Exception.Create('Synthetic AWD9 filtered included-key miss');
    Table.Filtered := False;
    Table.Close;
  finally
    Table.Free;
  end;
end;

procedure AddTable27Row(Table: TTable; const Key, Name, Comment: string);
begin
  Table.Append;
  Table.FieldByName('Kn').AsString := Key;
  Table.FieldByName('Namvorn').AsString := Name;
  Table.FieldByName('Kmt').AsString := Comment;
  Table.Post;
end;

procedure ProbeTable27(const DatabaseName: string);
var
  Table: TTable;
  RowNumber: Integer;
begin
  Table := TTable.Create(nil);
  try
    Table.DatabaseName := DatabaseName;
    Table.TableName := 'ALFLS.DB';
    Table.TableType := ttParadox;
    Table.Exclusive := True;
    Table.FieldDefs.Add('Nr', ftAutoInc, 0, False);
    Table.FieldDefs.Add('Dsn', ftInteger, 0, False);
    Table.FieldDefs.Add('Kn', ftString, 20, False);
    Table.FieldDefs.Add('Namvorn', ftString, 125, False);
    Table.FieldDefs.Add('Geb', ftString, 60, False);
    Table.FieldDefs.Add('Sterb', ftString, 60, False);
    Table.FieldDefs.Add('Kmt', ftString, 100, False);
    Table.IndexDefs.Add('', 'Nr;Dsn', [ixPrimary, ixUnique]);
    Table.CreateTable;
    Table.Open;

    AddTable27Row(Table, '      2', 'Zebra synthetic', 'synthetic');
    AddTable27Row(Table, '      1', 'Alpha synthetic', 'synthetic');
    Table.First;
    WriteLn('ALFLS_FIRST_APPEND_DEFAULTS=DsnNull=',
      Ord(Table.FieldByName('Dsn').IsNull), ' Dsn=',
      Table.FieldByName('Dsn').AsString, ' GebNull=',
      Ord(Table.FieldByName('Geb').IsNull), ' Geb=',
      Table.FieldByName('Geb').AsString, ' SterbNull=',
      Ord(Table.FieldByName('Sterb').IsNull), ' Sterb=',
      Table.FieldByName('Sterb').AsString);
    if not Table.FieldByName('Dsn').IsNull or
      not Table.FieldByName('Geb').IsNull or
      not Table.FieldByName('Sterb').IsNull then
      raise Exception.Create('Synthetic ALFLS append defaults were not null');

    AddAndVerifyIndex(Table, 'Namvg', 'Namvorn;Geb');
    Table.IndexName := 'Namvg';
    Table.First;
    RowNumber := 0;
    while not Table.Eof do
    begin
      Inc(RowNumber);
      Write('ALFLS_NAMVG_ROW_', RowNumber, '=');
      WriteLn(Table.FieldByName('Namvorn').AsString, '|',
        Table.FieldByName('Geb').AsString, '|DsnNull=',
        Ord(Table.FieldByName('Dsn').IsNull), '|Dsn=',
        Table.FieldByName('Dsn').AsString);
      if (RowNumber = 1) and
        (Table.FieldByName('Namvorn').AsString <> 'Alpha synthetic') then
        raise Exception.Create('Synthetic ALFLS Namvg first row mismatch');
      if (RowNumber = 2) and
        (Table.FieldByName('Namvorn').AsString <> 'Zebra synthetic') then
        raise Exception.Create('Synthetic ALFLS Namvg second row mismatch');
      if not Table.FieldByName('Dsn').IsNull or
        not Table.FieldByName('Geb').IsNull or
        not Table.FieldByName('Sterb').IsNull then
        raise Exception.Create('Synthetic ALFLS untouched fields changed');
      Table.Next;
    end;
    if RowNumber <> 2 then
      raise Exception.CreateFmt('Expected two ALFLS synthetic rows, got %d',
        [RowNumber]);

    Table.Close;
  finally
    Table.Free;
  end;
end;

var
  FixtureDirectory: string;
  Database: TDatabase;
begin
  Database := nil;
  try
    FixtureDirectory := CreateFixtureDirectory;
    WriteLn('FIXTURE=', FixtureDirectory);
    Session.PrivateDir := FixtureDirectory;
    Session.NetFileDir := FixtureDirectory;

    Database := TDatabase.Create(nil);
    Database.DatabaseName := 'Unit15CompositeFindKeySynthetic';
    Database.DriverName := 'STANDARD';
    Database.LoginPrompt := False;
    Database.Params.Values['PATH'] := FixtureDirectory;
    Database.Connected := True;
    WriteLn('BDE_MODULE=', LoadedBDEModulePath);

    ProbeTable18(Database.DatabaseName);
    ProbeTable8(Database.DatabaseName);
    ProbeTable9(Database.DatabaseName);
    ProbeTable27(Database.DatabaseName);

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
      if Assigned(Database) and Database.Connected then
        Database.Close;
      Halt(1);
    end;
    on E: Exception do
    begin
      WriteLn('ERROR=', E.ClassName, ': ', E.Message);
      if Assigned(Database) and Database.Connected then
        Database.Close;
      Halt(1);
    end;
  end;
  Database.Free;
end.
