{ Metadaten einer Demo fuer den BibleExplorer. }

unit BibleDemoInfo;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, contnrs, fpjson;

type
  { TBibleMarker - eine markierte Code-Stelle innerhalb einer Demo. }
  TBibleMarker = class
  private
    FFileName: string;
    FText: string;
    FTitle: string;
  public
    constructor Create(const AFileName, AText, ATitle: string);
    { Dateiname der Unit, relativ zum Demoordner. }
    property FileName: string read FFileName;
    { Text, an dem die Stelle erkannt wird. }
    property Text: string read FText;
    { Ueberschrift der Stelle. }
    property Title: string read FTitle;
  end;

  { TBibleDemo - Metadaten zu einer Demo. }
  TBibleDemo = class
  private
    FKey: string;
    FTitle: string;
    FSummary: string;
    FLearning: string;
    FFolder: string;
    FProject: string;
    FNotes: string;
    FUnits: TStringList;
    FMarkers: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
    { Liest die Metadaten aus einem JSON-Objekt. }
    procedure LoadFromJSON(AJSON: TJSONObject);
    { Sucht den Ordner der Demo im Quellbaum. }
    function LocateSourcePath(const ARoot: string): string;
    property Key: string read FKey;
    property Title: string read FTitle;
    property Summary: string read FSummary;
    property Learning: string read FLearning;
    property Folder: string read FFolder;
    property Project: string read FProject;
    property Notes: string read FNotes;
    property Units: TStringList read FUnits;
    property Markers: TObjectList read FMarkers;
  end;

  { TBibleCategory - eine Kategorie (Thema) mit den zugehoerigen Demos. }
  TBibleCategory = class
  private
    FId: string;
    FTitle: string;
    FDemos: TStringList;
  public
    constructor Create(const AId, ATitle: string);
    property Id: string read FId;
    property Title: string read FTitle;
    property Demos: TStringList read FDemos;
  end;

implementation

{ TBibleMarker }

constructor TBibleMarker.Create(const AFileName, AText, ATitle: string);
begin
  inherited Create;
  FFileName := AFileName;
  FText := AText;
  FTitle := ATitle;
end;

{ TBibleDemo }

constructor TBibleDemo.Create;
begin
  inherited Create;
  FUnits := TStringList.Create;
  FMarkers := TObjectList.Create(True);
end;

destructor TBibleDemo.Destroy;
begin
  FreeAndNil(FMarkers);
  FreeAndNil(FUnits);
  inherited Destroy;
end;

procedure TBibleDemo.LoadFromJSON(AJSON: TJSONObject);
var
  Item: TJSONObject;
  I: Integer;
begin
  if AJSON = nil then
    Exit;
  FKey := AJSON.Get('key', '');
  FTitle := AJSON.Get('title', FKey);
  FSummary := AJSON.Get('summary', '');
  FLearning := AJSON.Get('learning', '');
  FFolder := AJSON.Get('folder', FKey);
  FProject := AJSON.Get('project', FKey);
  FNotes := AJSON.Get('notes', '');
  FUnits.Clear;
  if AJSON.Find('units') <> nil then
    for I := 0 to AJSON.Find('units').Count - 1 do
      FUnits.Add(AJSON.Find('units').Items[I].AsString);
  if AJSON.Find('markers') <> nil then
    for I := 0 to AJSON.Find('markers').Count - 1 do
    begin
      Item := AJSON.Find('markers').Items[I] as TJSONObject;
      FMarkers.Add(TBibleMarker.Create(Item.Get('file', ''),
        Item.Get('text', ''), Item.Get('title', '')));
    end;
end;

function TBibleDemo.LocateSourcePath(const ARoot: string): string;
var
  Candidate: string;
begin
  Result := '';
  if (ARoot = '') or (FFolder = '') then
    Exit;
  Candidate := IncludeTrailingPathDelimiter(ARoot) + FFolder;
  if DirectoryExists(Candidate) then
    Result := Candidate
  else
  begin
    { Gross-/Kleinschreibung ignorieren }
    if not DirectoryExists(Candidate) then
    begin
      if FileExists(IncludeTrailingPathDelimiter(Candidate) + 'view') then
        Result := Candidate;
    end;
  end;
end;

{ TBibleCategory }

constructor TBibleCategory.Create(const AId, ATitle: string);
begin
  inherited Create;
  FId := AId;
  FTitle := ATitle;
  FDemos := TStringList.Create;
end;

end.
