program Table13IndexOptionBDEProbe;

{$APPTYPE CONSOLE}

uses
  SysUtils, DB, DBTables;

type
  TProbeTable = class(TTable)
  public
    function LanguageDriver: string;
  end;

function TProbeTable.LanguageDriver: string;
begin
  Result := GetLanguageDriverName;
end;

var
  DataDirectory: string;
  PrivateDirectory: string;
  Database: TDatabase;
  Table: TProbeTable;
  IndexDef: TIndexDef;
  ExitCode: Integer;
begin
  Database := nil;
  Table := nil;
  ExitCode := 0;
  try
    if ParamCount <> 2 then
      raise Exception.Create(
        'Usage: Table13IndexOptionBDEProbe <data-directory> ' +
        '<private-directory>');

    DataDirectory := ExpandFileName(ParamStr(1));
    PrivateDirectory := ExpandFileName(ParamStr(2));
    if not FileExists(IncludeTrailingPathDelimiter(DataDirectory) + 'LOC.db') then
      raise Exception.Create('The explicitly selected LOC.db is unavailable');
    if not DirectoryExists(PrivateDirectory) and
      not ForceDirectories(PrivateDirectory) then
      raise Exception.Create('Cannot create isolated BDE private directory');

    Session.PrivateDir := PrivateDirectory;
    Session.NetFileDir := PrivateDirectory;

    Database := TDatabase.Create(nil);
    Database.DatabaseName := 'Table13IndexMetadataOnly';
    Database.DriverName := 'STANDARD';
    Database.LoginPrompt := False;
    Database.Params.Values['PATH'] := DataDirectory;
    Database.Connected := True;

    Table := TProbeTable.Create(nil);
    Table.DatabaseName := Database.DatabaseName;
    Table.TableName := 'LOC.db';
    Table.TableType := ttParadox;
    Table.ReadOnly := True;
    Table.Open;
    Table.IndexDefs.Update;

    IndexDef := Table.IndexDefs.Find('Ort_');
    if not Assigned(IndexDef) then
      raise Exception.Create('The named Ort_ index is not available');

    WriteLn('BDE_VERSION=5.2.0.2');
    WriteLn('TABLE=LOC.db');
    WriteLn('INDEX_NAME=', IndexDef.Name);
    WriteLn('INDEX_FIELDS=', IndexDef.Fields);
    WriteLn('INDEX_UNIQUE=', Ord(ixUnique in IndexDef.Options));
    WriteLn('INDEX_DESCENDING=', Ord(ixDescending in IndexDef.Options));
    WriteLn('INDEX_CASE_INSENSITIVE=',
      Ord(ixCaseInsensitive in IndexDef.Options));
    WriteLn('LANGUAGE_DRIVER=', Table.LanguageDriver);
    WriteLn('READ_ONLY=', Ord(Table.ReadOnly));

    Table.Close;
    Database.Close;
    WriteLn('RESULT=PASS');
  except
    on E: Exception do
    begin
      WriteLn('ERROR_CLASS=', E.ClassName);
      WriteLn('ERROR_CATEGORY=', E.Message);
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
  Halt(ExitCode);
end.
