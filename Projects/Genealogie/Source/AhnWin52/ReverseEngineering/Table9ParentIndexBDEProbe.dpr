program Table9ParentIndexBDEProbe;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, Windows, DB, DBTables;

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
    Candidate := TempDirectory + 'AhnWin52-Table9-ParentIndex-' +
      FormatDateTime('yyyymmddhhnnsszzz', Now) + '-' + IntToStr(Suffix);
    Inc(Suffix);
  until not DirectoryExists(Candidate);
  if not ForceDirectories(Candidate) then
    raise Exception.Create('Cannot create synthetic fixture directory');
  Result := Candidate;
end;

procedure RemoveFixtureFiles(const Directory: string);
var
  Search: TSearchRec;
  FileName: string;
  SearchResult: Integer;
begin
  SearchResult := FindFirst(
    IncludeTrailingPathDelimiter(Directory) + '*.*', faAnyFile, Search);
  if SearchResult = 0 then
  begin
    try
      repeat
        if ((Search.Attr and faDirectory) = 0) and
          (Search.Name <> '.') and (Search.Name <> '..') then
        begin
          FileName := IncludeTrailingPathDelimiter(Directory) + Search.Name;
          if not DeleteFile(FileName) then
            raise Exception.Create('Cannot remove synthetic fixture file');
        end;
        SearchResult := FindNext(Search);
      until SearchResult <> 0;
    finally
      FindClose(Search);
    end;
  end;
  if not RemoveDir(Directory) then
    raise Exception.Create('Cannot remove synthetic fixture directory');
end;

procedure AddPerson(Table: TTable; Number, Father, Mother: Integer;
  const Gender, Year, Month, Day: string);
begin
  Table.Append;
  Table.FieldByName('Nummer').AsInteger := Number;
  Table.FieldByName('Vater').AsInteger := Father;
  Table.FieldByName('Mutter').AsInteger := Mother;
  Table.FieldByName('Geschlecht').AsString := Gender;
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
  if (IndexDef = nil) or
    (CompareText(IndexDef.Fields, Fields) <> 0) or
    (ixUnique in IndexDef.Options) then
    raise Exception.Create('Synthetic non-unique parent index mismatch');
end;

procedure AssertSharedParentLookup(Table: TTable; const IndexName,
  ParentField: string; ParentNumber, ExpectedCount: Integer);
var
  Found: Boolean;
  MatchCount: Integer;
begin
  Table.IndexName := IndexName;
  Table.First;
  Found := Table.FindKey([ParentNumber]);
  if not Found then
    raise Exception.Create('Synthetic parent reference was not indexed');

  MatchCount := 0;
  while not Table.EOF and
    (Table.FieldByName(ParentField).AsInteger = ParentNumber) do
  begin
    Inc(MatchCount);
    Table.Next;
  end;

  if MatchCount <> ExpectedCount then
    raise Exception.CreateFmt(
      'Synthetic %s lookup returned %d rows; expected %d',
      [IndexName, MatchCount, ExpectedCount]);
  WriteLn(UpperCase(IndexName), '_SHARED_REFERENCE_ROWS=', MatchCount);
end;

var
  FixtureDirectory: string;
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
    Session.PrivateDir := FixtureDirectory;
    Session.NetFileDir := FixtureDirectory;

    Database := TDatabase.Create(nil);
    Database.DatabaseName := 'Table9Synthetic';
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

    AddPerson(Table, 100, 0, 0, 'M', '1940', '01', '01');
    AddPerson(Table, 200, 0, 0, 'W', '1942', '02', '02');
    AddPerson(Table, 301, 100, 200, 'M', '1970', '03', '03');
    AddPerson(Table, 302, 100, 200, 'W', '1972', '04', '04');
    AddPerson(Table, 303, 100, 200, 'W', '1974', '05', '05');
    AddAndVerifyIndex(Table, 'vat', 'Vater;Indj;Indm;Indt');
    AddAndVerifyIndex(Table, 'mut', 'Mutter;Indj;Indm;Indt');
    Table.Close;
    Database.Close;

    Table.Exclusive := False;
    Table.ReadOnly := True;
    Database.Connected := True;
    Table.Open;
    if not Table.ReadOnly then
      raise Exception.Create('Synthetic Table9 was not reopened read-only');

    AssertSharedParentLookup(Table, 'vat', 'Vater', 100, 3);
    AssertSharedParentLookup(Table, 'mut', 'Mutter', 200, 3);

    Table.Close;
    Database.Close;
    WriteLn('BDE_VERSION=5.2.0.2');
    WriteLn('FIXTURE=synthetic Table9-shaped AWD.DB');
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
  if FixtureDirectory <> '' then
  begin
    try
      RemoveFixtureFiles(FixtureDirectory);
      WriteLn('FIXTURE_CLEANUP=PASS');
    except
      on E: Exception do
      begin
        WriteLn('FIXTURE_CLEANUP_ERROR=', E.ClassName);
        ExitCode := 1;
      end;
    end;
  end;
  Halt(ExitCode);
end.
