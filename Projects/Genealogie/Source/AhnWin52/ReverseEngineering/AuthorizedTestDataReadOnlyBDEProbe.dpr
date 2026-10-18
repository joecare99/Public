program AuthorizedTestDataReadOnlyBDEProbe;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, Windows, DB, DBTables;

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

procedure WriteCursorState(const Prefix: string; Table: TTable);
begin
  WriteLn(Prefix, '_BOF=', Ord(Table.BOF));
  WriteLn(Prefix, '_EOF=', Ord(Table.EOF));
  WriteLn(Prefix, '_RECNO=', Table.RecNo);
end;

function BuildMissingKey(Seen: TStringList): string;
var
  Suffix: Integer;
begin
  Suffix := 0;
  repeat
    Result := '__AHNWIN52_READ_ONLY_PROBE_MISSING__' +
      IntToStr(Suffix);
    Inc(Suffix);
  until Seen.IndexOf(Result) < 0;
end;

function NormalizeIndexFields(const Value: string): string;
begin
  Result := UpperCase(StringReplace(Trim(Value), ';', ',', [rfReplaceAll]));
  Result := StringReplace(Result, ' ', '', [rfReplaceAll]);
end;

function IsAllowedTableName(const Value: string): Boolean;
const
  AllowedTableNames: array[0..28] of string =
    ('adp.DB', 'ahntab.DB', 'alfls.db', 'AWD.DB', 'chnt.DB',
     'FKHF.DB', 'FKMG.DB', 'FOKO.DBF', 'ftab.DB', 'gede.DB',
     'gedh.db', 'lc.DB', 'lfbh.db', 'LOC - Kopie.db', 'LOC.db',
     'loc2.db', 'MRG.DB', 'ndh.db', 'ng2h.DB', 'NM.db',
     'nol.db', 'NUMRES.DB', 'occ.db', 'OUTP.db', 'over.db',
     'repso.db', 'sour.DB', 'sour2.DB', 'VORF.DB');
var
  Index: Integer;
begin
  Result := False;
  for Index := Low(AllowedTableNames) to High(AllowedTableNames) do
    if CompareText(Value, AllowedTableNames[Index]) = 0 then
    begin
      Result := True;
      Exit;
    end;
end;

procedure ProbeTable9Indexes(Table: TTable);
const
  IndexNames: array[0..7] of string =
    ('muto', 'vato', 'namgeb', 'geba', 'gebnam', 'mut', 'vat', 'gebo');
  IndexFields: array[0..7] of string =
    ('Mutter,Gebjahr,Gebmonat,Gebtag,Taufjahr,Taufmonat,Tauftag',
     'Vater,Gebjahr,Gebmonat,Gebtag,Taufjahr,Taufmonat,Tauftag',
     'Name,Vornamen,Gebjahr,Indj,Indm,Indt',
     'Name,Vornamen,Gebjahr,Gebmonat,Gebtag,Taufjahr,Taufmonat,Tauftag',
     'Indj,Indm,Indt,Name,Vornamen',
     'Mutter,Indj,Indm,Indt',
     'Vater,Indj,Indm,Indt',
     'Gebort');
var
  Index: Integer;
  IndexDef: TIndexDef;
begin
  for Index := Low(IndexNames) to High(IndexNames) do
  begin
    IndexDef := Table.IndexDefs.Find(IndexNames[Index]);
    if IndexDef = nil then
      raise Exception.Create('Required Table9 index is unavailable');
    if NormalizeIndexFields(IndexDef.Fields) <>
      NormalizeIndexFields(IndexFields[Index]) then
      raise Exception.Create('Table9 index field order mismatch');

    WriteLn('TABLE9_INDEX=', IndexDef.Name, '|', IndexDef.Fields, '|',
      Ord(ixUnique in IndexDef.Options), '|',
      Ord(ixDescending in IndexDef.Options));
    Table.IndexName := IndexDef.Name;
    Table.First;
    WriteCursorState(IndexNames[Index] + '_FIRST', Table);
    if not Table.EOF then
    begin
      Table.Next;
      WriteCursorState(IndexNames[Index] + '_NEXT', Table);
      Table.Last;
      WriteCursorState(IndexNames[Index] + '_LAST', Table);
    end;
  end;
end;

var
  DataDirectory: string;
  PrivateDirectory: string;
  TableFileName: string;
  Password: string;
  PasswordRegistered: Boolean;
  Database: TDatabase;
  Table: TTable;
  SeenPlaces: TStringList;
  FieldDef: TFieldDef;
  IndexDef: TIndexDef;
  PlaceField: TField;
  FirstPlace: string;
  MissingPlace: string;
  RecordCount: Integer;
  DuplicateValueCount: Integer;
  I: Integer;
  HitFound: Boolean;
  MissFound: Boolean;
  PartialFound: Boolean;
  MalformedFound: Boolean;
  ExitCode: Integer;
begin
  Database := nil;
  Table := nil;
  SeenPlaces := nil;
  Password := '';
  PasswordRegistered := False;
  ExitCode := 0;
  try
    if ParamCount <> 3 then
      raise Exception.Create(
        'Usage: AuthorizedTestDataReadOnlyBDEProbe <data-directory> ' +
        '<private-directory> <LOC.db|AWD.DB>');

    DataDirectory := ExpandFileName(ParamStr(1));
    PrivateDirectory := ExpandFileName(ParamStr(2));
    TableFileName := ParamStr(3);
    if not IsAllowedTableName(TableFileName) then
      raise Exception.Create('Table is not in the probe allowlist');
    if not DirectoryExists(DataDirectory) then
      raise Exception.Create('Data directory does not exist');
    if not DirectoryExists(PrivateDirectory) and
      not ForceDirectories(PrivateDirectory) then
      raise Exception.Create('Cannot create BDE private directory');

    Session.PrivateDir := PrivateDirectory;
    Session.NetFileDir := PrivateDirectory;
    Password := GetEnvironmentVariable('AHNWIN52_BDE_PASSWORD');
    if Password <> '' then
    begin
      Session.AddPassword(Password);
      PasswordRegistered := True;
    end;

    Database := TDatabase.Create(nil);
    Database.DatabaseName := 'AuthorizedLOCReadOnlyProbe';
    Database.DriverName := 'STANDARD';
    Database.LoginPrompt := False;
    Database.Params.Values['PATH'] := DataDirectory;
    Database.Connected := True;

    Table := TTable.Create(nil);
    Table.DatabaseName := Database.DatabaseName;
    Table.TableName := TableFileName;
    if CompareText(ExtractFileExt(TableFileName), '.DBF') = 0 then
      Table.TableType := ttDBase
    else
      Table.TableType := ttParadox;
    Table.ReadOnly := True;

    WriteLn('BDE_MODULE=', LoadedBDEModulePath);
    WriteLn('BDE_VERSION=5.2.0.2');
    WriteLn('TABLE=', TableFileName);
    Table.Open;

    Table.FieldDefs.Update;
    Table.IndexDefs.Update;
    WriteLn('OPEN=1');
    WriteLn('FIELD_COUNT=', Table.FieldDefs.Count);
    for I := 0 to Table.FieldDefs.Count - 1 do
    begin
      FieldDef := Table.FieldDefs[I];
      WriteLn('FIELD=', I, '|', FieldDef.Name, '|',
        Ord(FieldDef.DataType), '|', FieldDef.Size, '|',
        Ord(FieldDef.Required));
    end;

    WriteLn('INDEX_COUNT=', Table.IndexDefs.Count);
    for I := 0 to Table.IndexDefs.Count - 1 do
    begin
      IndexDef := Table.IndexDefs[I];
      WriteLn('INDEX=', IndexDef.Name, '|', IndexDef.Fields, '|',
        Ord(ixUnique in IndexDef.Options), '|',
        Ord(ixDescending in IndexDef.Options));
    end;

    RecordCount := 0;
    Table.First;
    while not Table.EOF do
    begin
      Inc(RecordCount);
      Table.Next;
    end;
    WriteLn('RECORD_COUNT=', RecordCount);

    if CompareText(TableFileName, 'LOC.db') = 0 then
    begin
      IndexDef := Table.IndexDefs.Find('Ort_');
      if IndexDef = nil then
        raise Exception.Create('Required index Ort_ is unavailable');
      if CompareText(Trim(IndexDef.Fields), 'Ort') <> 0 then
        raise Exception.Create('Index Ort_ does not match expected field');

      PlaceField := Table.FieldByName('Ort');
      SeenPlaces := TStringList.Create;
      SeenPlaces.Sorted := True;
      SeenPlaces.Duplicates := dupIgnore;
      SeenPlaces.CaseSensitive := True;
      DuplicateValueCount := 0;
      FirstPlace := '';
      Table.First;
      while not Table.EOF do
      begin
        if SeenPlaces.IndexOf(PlaceField.AsString) >= 0 then
          Inc(DuplicateValueCount)
        else
        begin
          if SeenPlaces.Count = 0 then
            FirstPlace := PlaceField.AsString;
          SeenPlaces.Add(PlaceField.AsString);
        end;
        Table.Next;
      end;
      WriteLn('DISTINCT_ORT_VALUES=', SeenPlaces.Count);
      WriteLn('DUPLICATE_ORT_ROWS=', DuplicateValueCount);

      if RecordCount > 0 then
      begin
        Table.IndexName := 'Ort_';
        Table.First;
        HitFound := Table.FindKey([FirstPlace]);
        WriteLn('HIT_FOUND=', Ord(HitFound));
        WriteCursorState('HIT', Table);

        MissingPlace := BuildMissingKey(SeenPlaces);
        Table.First;
        MissFound := Table.FindKey([MissingPlace]);
        WriteLn('MISS_FOUND=', Ord(MissFound));
        WriteCursorState('MISS', Table);

        if Length(FirstPlace) > 1 then
        begin
          Table.First;
          PartialFound := Table.FindKey([Copy(FirstPlace, 1, 1)]);
          WriteLn('PARTIAL_FOUND=', Ord(PartialFound));
          WriteCursorState('PARTIAL', Table);
        end
        else
          WriteLn('PARTIAL_TEST=SKIPPED_KEY_TOO_SHORT');

        Table.First;
        try
          MalformedFound := Table.FindKey(
            [StringOfChar('X', PlaceField.Size + 1)]);
          WriteLn('OVERSIZE_FOUND=', Ord(MalformedFound));
          WriteCursorState('OVERSIZE', Table);
        except
          on E: EDBEngineError do
          begin
            WriteLn('OVERSIZE_EXCEPTION=', E.ClassName);
            if E.ErrorCount > 0 then
              WriteLn('OVERSIZE_DBI_ERROR_CODE=',
                E.Errors[0].ErrorCode);
          end;
          on E: Exception do
            WriteLn('OVERSIZE_EXCEPTION=', E.ClassName);
        end;
      end
      else
        WriteLn('LOOKUP_TESTS=SKIPPED_EMPTY_TABLE');
    end
    else
      if CompareText(TableFileName, 'AWD.DB') = 0 then
        ProbeTable9Indexes(Table);

    Table.Close;
    WriteLn('CLOSED=1');
    if CompareText(TableFileName, 'LOC.db') = 0 then
      try
        HitFound := Table.FindKey([FirstPlace]);
        WriteLn('CLOSED_FINDKEY_RETURNED=', Ord(HitFound));
      except
        on E: EDBEngineError do
        begin
          WriteLn('CLOSED_FINDKEY_EXCEPTION=', E.ClassName);
          if E.ErrorCount > 0 then
            WriteLn('CLOSED_FINDKEY_DBI_ERROR_CODE=',
              E.Errors[0].ErrorCode);
        end;
        on E: Exception do
          WriteLn('CLOSED_FINDKEY_EXCEPTION=', E.ClassName);
      end;
    Database.Close;
    WriteLn('RESULT=PASS');
  except
    on E: EDBEngineError do
    begin
      WriteLn('ERROR_CLASS=', E.ClassName);
      WriteLn('ERROR_MESSAGE=', E.Message);
      if E.ErrorCount > 0 then
      begin
        WriteLn('DBI_ERROR_CODE=', E.Errors[0].ErrorCode);
        WriteLn('DBI_NATIVE_ERROR=', E.Errors[0].NativeError);
        WriteLn('DBI_CATEGORY=', E.Errors[0].Category);
        WriteLn('DBI_SUBCODE=', E.Errors[0].SubCode);
      end;
      ExitCode := 1;
    end;
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
  if PasswordRegistered then
    Session.RemovePassword(Password);
  Password := '';
  SeenPlaces.Free;
  Table.Free;
  Database.Free;
  Halt(ExitCode);
end.
