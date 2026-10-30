program Table9ParentReferenceBDEBlackBoxProbe;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, DB, DBTables;

function CreateFixtureDirectory: string;
var
  TempDirectory: string;
  Candidate: string;
  Suffix: Integer;
begin
  TempDirectory := GetEnvironmentVariable('TEMP');
  if TempDirectory = '' then
    raise Exception.Create('TEMP is not set');
  TempDirectory := IncludeTrailingPathDelimiter(TempDirectory);
  Suffix := 0;
  repeat
    Candidate := TempDirectory + 'AhnWin52-Table9-Parent-BlackBox-' +
      FormatDateTime('yyyymmddhhnnsszzz', Now) + '-' + IntToStr(Suffix);
    Inc(Suffix);
  until not DirectoryExists(Candidate);
  if not ForceDirectories(Candidate) then
    raise Exception.Create('Cannot create synthetic fixture directory');
  Result := Candidate;
end;

function CreateNetDirectory(const FixtureDirectory: string): string;
begin
  Result := IncludeTrailingPathDelimiter(FixtureDirectory) + 'net';
  if not ForceDirectories(Result) then
    raise Exception.Create('Cannot create isolated BDE network directory');
end;

procedure RemoveDirectoryFiles(const Directory: string);
var
  Search: TSearchRec;
  SearchResult: Integer;
  FileName: string;
begin
  SearchResult := FindFirst(
    IncludeTrailingPathDelimiter(Directory) + '*.*', faAnyFile, Search);
  if SearchResult <> 0 then
    Exit;
  try
    repeat
      if (Search.Name <> '.') and (Search.Name <> '..') then
      begin
        if (Search.Attr and faDirectory) <> 0 then
          raise Exception.Create('Unexpected nested fixture directory');
        FileName := IncludeTrailingPathDelimiter(Directory) + Search.Name;
        if not DeleteFile(FileName) then
          raise Exception.CreateFmt('Cannot remove synthetic fixture file: %s',
            [FileName]);
      end;
      SearchResult := FindNext(Search);
    until SearchResult <> 0;
  finally
    FindClose(Search);
  end;
end;

procedure RemoveFixtureDirectory(const FixtureDirectory: string);
var
  NetDirectory: string;
begin
  NetDirectory := IncludeTrailingPathDelimiter(FixtureDirectory) + 'net';
  if DirectoryExists(NetDirectory) then
  begin
    RemoveDirectoryFiles(NetDirectory);
    if not RemoveDir(NetDirectory) then
      raise Exception.Create('Cannot remove isolated BDE network directory');
  end;
  RemoveDirectoryFiles(FixtureDirectory);
  if not RemoveDir(FixtureDirectory) then
    raise Exception.Create('Cannot remove synthetic fixture directory');
end;

procedure AddPerson(Table: TTable; Number, Father, Mother: Integer;
  const Gender: string);
begin
  Table.Append;
  Table.FieldByName('Nummer').AsInteger := Number;
  Table.FieldByName('Vater').AsInteger := Father;
  Table.FieldByName('Mutter').AsInteger := Mother;
  Table.FieldByName('Geschlecht').AsString := Gender;
  Table.FieldByName('Indj').AsString := '1970';
  Table.FieldByName('Indm').AsString := '01';
  Table.FieldByName('Indt').AsString := '01';
  Table.Post;
end;

procedure AddAndVerifyIndex(Table: TTable; const IndexName,
  Fields: string);
var
  IndexDef: TIndexDef;
begin
  Table.AddIndex(IndexName, Fields, []);
  Table.IndexDefs.Update;
  IndexDef := Table.IndexDefs.Find(IndexName);
  if (IndexDef = nil) or
    (CompareText(IndexDef.Fields, Fields) <> 0) or
    (ixUnique in IndexDef.Options) then
    raise Exception.CreateFmt('Unexpected synthetic index contract: %s',
      [IndexName]);
end;

function CountParentMatches(Table: TTable; const IndexName,
  ParentField: string; ParentNumber: Integer): Integer;
var
  Found: Boolean;
begin
  Table.IndexName := IndexName;
  Table.First;
  Found := Table.FindKey([ParentNumber]);
  Result := 0;
  while Found and not Table.EOF and
    (Table.FieldByName(ParentField).AsInteger = ParentNumber) do
  begin
    Inc(Result);
    Table.Next;
  end;
end;

procedure AssertMatchCount(Table: TTable; const IndexName, ParentField: string;
  ParentNumber, Expected: Integer; const Scenario: string);
var
  Actual: Integer;
begin
  Actual := CountParentMatches(Table, IndexName, ParentField, ParentNumber);
  if Actual <> Expected then
    raise Exception.CreateFmt('%s: expected %d indexed rows, got %d',
      [Scenario, Expected, Actual]);
  WriteLn(Scenario, '_MATCHES=', Actual);
end;

procedure AssertMissRetainsCurrentRow(Table: TTable; const IndexName,
  ParentField: string; ParentNumber: Integer; const Scenario: string);
var
  Found: Boolean;
  CurrentNumber: Integer;
  CurrentRecNo: Integer;
begin
  Table.IndexName := IndexName;
  Table.First;
  if Table.IsEmpty or Table.EOF then
    raise Exception.CreateFmt('%s: fixture unexpectedly has no current row',
      [Scenario]);
  CurrentNumber := Table.FieldByName('Nummer').AsInteger;
  CurrentRecNo := Table.RecNo;
  Found := Table.FindKey([ParentNumber]);
  if Found or Table.IsEmpty or Table.EOF or not Table.BOF or
    (Table.RecNo <> CurrentRecNo) or
    (Table.FieldByName('Nummer').AsInteger <> CurrentNumber) or
    (Table.FieldByName(ParentField).AsInteger = ParentNumber) then
    raise Exception.CreateFmt('%s: unexpected FindKey miss state', [Scenario]);
  WriteLn(Scenario, '_FOUND=0 BOF=', Ord(Table.BOF), ' EOF=',
    Ord(Table.EOF), ' RECNO=', Table.RecNo, ' CURRENT_NUMBER=',
    Table.FieldByName('Nummer').AsInteger);
end;

var
  FixtureDirectory: string;
  NetDirectory: string;
  Database: TDatabase;
  Table: TTable;
  ExitCode: Integer;
begin
  FixtureDirectory := '';
  Database := nil;
  Table := nil;
  ExitCode := 0;
  try
    FixtureDirectory := CreateFixtureDirectory;
    NetDirectory := CreateNetDirectory(FixtureDirectory);
    Session.PrivateDir := FixtureDirectory;
    Session.NetFileDir := NetDirectory;

    Database := TDatabase.Create(nil);
    Database.DatabaseName := 'Table9ParentBlackBox';
    Database.DriverName := 'STANDARD';
    Database.LoginPrompt := False;
    Database.Params.Values['PATH'] := FixtureDirectory;
    Database.Connected := True;

    Table := TTable.Create(nil);
    Table.DatabaseName := Database.DatabaseName;
    Table.TableName := 'AWD.DB';
    Table.TableType := ttParadox;
    Table.Exclusive := True;
    Table.FieldDefs.Add('Nummer', ftInteger, 0, False);
    Table.FieldDefs.Add('Vater', ftInteger, 0, False);
    Table.FieldDefs.Add('Mutter', ftInteger, 0, False);
    Table.FieldDefs.Add('Geschlecht', ftString, 1, False);
    Table.FieldDefs.Add('Indj', ftString, 4, False);
    Table.FieldDefs.Add('Indm', ftString, 2, False);
    Table.FieldDefs.Add('Indt', ftString, 2, False);
    Table.IndexDefs.Add('', 'Nummer', [ixPrimary, ixUnique]);
    Table.CreateTable;
    Table.Open;

    AddPerson(Table, 100, 0, 0, 'M');
    AddPerson(Table, 200, 0, 0, 'W');
    AddPerson(Table, 301, 100, 200, 'M');
    AddPerson(Table, 302, 100, 200, 'W');
    AddPerson(Table, 303, 9999, 303, 'W');
    AddAndVerifyIndex(Table, 'vat', 'Vater;Indj;Indm;Indt');
    AddAndVerifyIndex(Table, 'mut', 'Mutter;Indj;Indm;Indt');
    Table.Close;
    Database.Close;

    Table.Exclusive := False;
    Table.ReadOnly := True;
    Database.Connected := True;
    Table.Open;
    if not Table.ReadOnly then
      raise Exception.Create('Fixture did not reopen in read-only mode');

    AssertMatchCount(Table, 'vat', 'Vater', 100, 2, 'SHARED_FATHER');
    AssertMatchCount(Table, 'mut', 'Mutter', 200, 2, 'SHARED_MOTHER');
    AssertMatchCount(Table, 'vat', 'Vater', 0, 2, 'ZERO_REFERENCE');
    AssertMatchCount(Table, 'vat', 'Vater', 9999, 1, 'MISSING_TARGET');
    AssertMatchCount(Table, 'mut', 'Mutter', 303, 1, 'SELF_REFERENCE');
    AssertMissRetainsCurrentRow(Table, 'vat', 'Vater', 777,
      'VAT_PREFIX_MISS');
    AssertMissRetainsCurrentRow(Table, 'mut', 'Mutter', 777,
      'MUT_PREFIX_MISS');

    Table.Close;
    Database.Close;
    WriteLn('BDE_VERSION=5.2.0.2');
    WriteLn('FIXTURE=synthetic Table9-shaped table; no real records');
    WriteLn('READ_ONLY_REOPEN=1');
    WriteLn('RESULT=PASS');
  except
    on E: Exception do
    begin
      WriteLn('ERROR_CLASS=', E.ClassName);
      WriteLn('ERROR_MESSAGE=', E.Message);
      ExitCode := 1;
    end;
  end;

  if Assigned(Table) and Table.Active then
    Table.Close;
  if Assigned(Database) and Database.Connected then
    Database.Close;
  Table.Free;
  Database.Free;
  Session.Close;
  if FixtureDirectory <> '' then
  begin
    try
      RemoveFixtureDirectory(FixtureDirectory);
      WriteLn('FIXTURE_CLEANUP=PASS');
    except
      on E: Exception do
      begin
        WriteLn('FIXTURE_CLEANUP_ERROR=', E.ClassName, ': ', E.Message);
        WriteLn('FIXTURE_DIRECTORY=', FixtureDirectory);
        ExitCode := 1;
      end;
    end;
  end;
  Halt(ExitCode);
end.
