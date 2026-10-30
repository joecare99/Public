{ Laedt den Index der Demos (JSON) fuer den BibleExplorer. }

unit BibleIndex;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, contnrs, fpjson, BibleDemoInfo;

type
  { TBibleIndex - der vollstaendige Index aller Demos und Kategorien. }
  TBibleIndex = class
  private
    FDemos: TObjectList;
    FCategories: TObjectList;
    function FindDemo(const AKey: string): TBibleDemo;
  public
    constructor Create;
    destructor Destroy; override;
    { Liest den Index aus einer JSON-Datei. }
    function LoadFromFile(const AFileName: string): Boolean;
    { Liest den Index aus einem JSON-Text. }
    function LoadFromString(const AText: string): Boolean;
    property Demos: TObjectList read FDemos;
    property Categories: TObjectList read FCategories;
    function DemoByKey(const AKey: string): TBibleDemo;
  end;

implementation

constructor TBibleIndex.Create;
begin
  inherited Create;
  FDemos := TObjectList.Create(True);
  FCategories := TObjectList.Create(True);
end;

destructor TBibleIndex.Destroy;
begin
  FreeAndNil(FCategories);
  FreeAndNil(FDemos);
  inherited Destroy;
end;

function TBibleIndex.FindDemo(const AKey: string): TBibleDemo;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FDemos.Count - 1 do
    if CompareText(TBibleDemo(FDemos[I]).Key, AKey) = 0 then
      Exit(TBibleDemo(FDemos[I]));
end;

function TBibleIndex.DemoByKey(const AKey: string): TBibleDemo;
begin
  Result := FindDemo(AKey);
end;

function TBibleIndex.LoadFromString(const AText: string): Boolean;
var
  Data: TJSONData;
  JSON: TJSONObject;
  Item: TJSONObject;
  Demo: TBibleDemo;
  Category: TBibleCategory;
  I, J: Integer;
begin
  Result := False;
  Data := GetJSON(AText);
  if Data = nil then
    Exit;
  JSON := Data as TJSONObject;
  try
    if JSON.Find('demos') <> nil then
      for I := 0 to JSON.Find('demos').Count - 1 do
      begin
        Demo := TBibleDemo.Create;
        Demo.LoadFromJSON(JSON.Find('demos').Items[I] as TJSONObject);
        FDemos.Add(Demo);
      end;
    if JSON.Find('categories') <> nil then
      for I := 0 to JSON.Find('categories').Count - 1 do
      begin
        Item := JSON.Find('categories').Items[I] as TJSONObject;
        Category := TBibleCategory.Create(Item.Get('id', ''),
          Item.Get('title', ''));
        if Item.Find('demos') <> nil then
          for J := 0 to Item.Find('demos').Count - 1 do
            Category.Demos.Add(Item.Find('demos').Items[J].AsString);
        FCategories.Add(Category);
      end;
    Result := True;
  finally
    Data.Free;
  end;
end;

function TBibleIndex.LoadFromFile(const AFileName: string): Boolean;
var
  Stream: TFileStream;
  Text: TStringList;
begin
  Result := False;
  if not FileExists(AFileName) then
    Exit;
  Text := TStringList.Create;
  Stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    Text.LoadFromStream(Stream);
    Result := LoadFromString(Text.Text);
  finally
    Stream.Free;
    Text.Free;
  end;
end;

end.
