(*
Demonstrates how to use ini files to save/restore object properties
Copyright (C) 1995, 1998 by Danny Thorpe; All rights reserved.
  Used with permission of the author.
Revised 2/12/1998 by Tom Swan;
  See // comments for original code and new additions
Revised 2/12/2009 by C. Rosewich;
  See // Added Compatibility to D2k9
To use:
  1. Add Inidata.Pas to your project
  2. Insert Inidata in a unit's uses directive
  3. Register classes and properties with RegisterINIDataProp
  4. Call this module's SaveData... and LoadData... procedures
*)

unit Inidata;

{$I jedi.inc}
interface

uses SysUtils, Classes, INIFiles;

type
  EINIDataProp = class(Exception);

procedure SaveDataToINIFile(Instance: TComponent; const Filename: String);
procedure SaveDataToINI(Instance: TComponent; INI: TINIFile);
procedure SaveDataToStrings(Instance: TComponent; Items: TStrings);

procedure LoadDataFromINIFile(Instance: TComponent; const Filename: String);
procedure LoadDataFromINI(Instance: TComponent; INI: TINIFile);
procedure LoadDataFromStrings(Instance: TComponent; Items: TStrings);

procedure RegisterINIDataProp(const ClassName, PropName: String);

implementation

uses TypInfo;

{$ifndef SUPPORTS_DEFAULTPARAMS}
const
{$else}
var
{$endif}
  INIDataProps: TStringList = nil;

procedure RegisterINIDataProp(const ClassName, PropName: String);
var
  X: Integer;
begin
  if INIDataProps = nil then INIDataProps := TStringList.Create;
  for X := 0 to INIDataProps.Count - 1 do
    if CompareText(ClassName, INIDataProps[x]) = 0 then
      raise EINIDataProp.Create(Format('Can''t register %s.%s - %s.%s is already registered',
          [ClassName, PropName, ClassName, {$ifndef Supports_Widestring}String(INIDataProps.Objects[X]){$else}PString(INIDataProps.Objects[x])^{$endif}]));
  INIDataProps.AddObject(ClassName, TObject(PropName));
end;

function FindINIDataProp(Instance: TComponent; var PropInfo: PPropInfo): Boolean;
var
  X: Integer;
begin
  Result := False;
  if INIDataProps = nil then Exit;
  for X := 0 to INIDataProps.Count - 1 do
    if CompareText(Instance.ClassName, INIDataProps[x]) = 0 then
    begin
      PropInfo := GetPropInfo(Instance.ClassInfo, {$ifndef Supports_Widestring}String(INIDataProps.Objects[X]){$else}PString(INIDataProps.Objects[x])^{$endif});
      Result := (PropInfo <> nil) and IsStoredProp(Instance, PropInfo);
      Exit;
    end;
end;

type
  TDataFiler = class
    function ReadStr(const Key, Default: String):String; virtual; abstract;
    procedure WriteStr(const Key, Value: String); virtual; abstract;
    function ReadInt(const Key: String; Default: Longint): Longint;
    procedure WriteInt(const Key: String; Value: Longint);
    procedure LoadData(Instance: TComponent);
    procedure SaveData(Instance: TComponent);
  end;

  TDataINIFiler = class(TDataFiler)
    FINIFile: TINIFile;
{$ifndef SUPPORTS_UNICODE}
    FSection: String[64];
{$else}
    FSection: String;
{$endif}
    constructor Create(INIFile: TINIFile; const Section: String);
    function ReadStr(const Key, Default: String):String; override;
    procedure WriteStr(const Key, Value: String); override;
  end;

  TDataStringFiler = class(TDataFiler)
    FStrings: TStrings;
    constructor Create(SList: TStrings);
    function ReadStr(const Key, Default: String):String; override;
    procedure WriteStr(const Key, Value: String); override;
  end;

function TDataFiler.ReadInt(const Key: String; Default: Longint): Longint;
begin
  Result := StrToInt(ReadStr(Key, IntToStr(Default)));
end;

procedure TDataFiler.WriteInt(const Key: String; Value: Longint);
begin
  WriteStr(Key, IntToStr(Value));
end;

procedure TDataFiler.LoadData(Instance: TComponent);
var
  P : TComponent;
  X: Integer;
  PropInfo: PPropInfo;
begin
  for X := 0 to Instance.ComponentCount - 1 do
  begin
    P := Instance.Components[X];
    if (Length(P.Name) > 0) and FindINIDataProp(P, PropInfo) then
      case PropInfo^.PropType^.Kind of
{$ifdef Supports_Widestring}
        tkLString, tkWString,
{$endif}
{$ifdef SUPPORTS_UNICODE}
        tkUString,
{$endif}
        tkString: SetStrProp(P, PropInfo, ReadStr(P.Name, GetStrProp(P,PropInfo)));
        tkInteger: SetOrdProp(P, PropInfo, ReadInt(P.Name, GetOrdProp(P,PropInfo)));
{$ifndef Supports_Widestring}
        tkEnumeration: SetOrdProp(P, PropInfo,
          GetEnumValue(PropInfo^.PropType,
          ReadStr(P.Name, GetEnumName(PropInfo^.PropType,
          GetOrdProp(P,PropInfo))^)));
{$Else}
        tkEnumeration: SetOrdProp(P, PropInfo,
          GetEnumValue({$IFDEF FPC} PropInfo.PropType {$ELSE} PropInfo.PropType^ {$ENDIF},
          ReadStr(P.Name, GetEnumName({$IFDEF FPC} PropInfo.PropType {$ELSE} PropInfo.PropType^ {$ENDIF},
          GetOrdProp(P,PropInfo)))));
{$Endif}
      end;
  end;
end;

procedure TDataFiler.SaveData(Instance: TComponent);
var
  X: Integer;
  P: TComponent;
  PropInfo: PPropInfo;
begin
  for X := 0 to Instance.ComponentCount-1 do
  begin
    P := Instance.Components[x];
    if (Length(P.Name) > 0) and FindINIDataProp(P, PropInfo) then
      case PropInfo^.PropType^.Kind of
// added following two types
{$ifdef Supports_Widestring}
        tkLString, tkWString,
{$endif}
{$ifdef SUPPORTS_UNICODE}
        tkUString,
{$endif}
        tkString: WriteStr(P.Name, GetStrProp(P,PropInfo));
        tkInteger: WriteInt(P.Name, GetOrdProp(P,PropInfo));
{$ifndef Supports_Widestring}
        tkEnumeration: WriteStr(P.Name,
          GetEnumName(PropInfo^.PropType,
          GetOrdProp(P,PropInfo))^);
{$else}
        tkEnumeration: WriteStr(P.Name,
          GetEnumName({$IFDEF FPC} PropInfo.PropType {$ELSE} PropInfo.PropType^ {$ENDIF},
          GetOrdProp(P,PropInfo)));
{$endif}
      end;
  end;
end;

constructor TDataINIFiler.Create(INIFile: TINIFile; const Section: String);
begin
  FINIFile := INIFile;
  FSection := Section;
end;

function TDataINIFiler.ReadStr(const Key, Default: String): String;
begin
  Result := FINIFile.ReadString(FSection, Key, Default);
end;

procedure TDataINIFiler.WriteStr(const Key, Value: String);
begin
  FINIFile.WriteString(FSection, Key, Value);
end;

constructor TDataStringFiler.Create(SList: TStrings);
begin
  FStrings := SList;
end;

function TDataStringFiler.ReadStr(const Key, Default: String): String;
var
  X: Integer;
  P: Integer;
begin
  for X := 0 to FStrings.Count-1 do
  begin
    Result := FStrings[x];
    P := Pos('=',Result);
    if (P <> 0) and (CompareText(Copy(Result, 1, P - 1), Key) = 0) then
    begin
      Result := Copy(Result,P+1,255);
      Exit;
    end;
  end;
  Result := Default;
end;

procedure TDataStringFiler.WriteStr(const Key, Value: String);
begin
  FStrings.Values[Key] := Value;
end;

procedure SaveDataToINIFile(Instance: TComponent; const FileName: String);
var
  INI: TINIFile;
begin
  INI := TINIFile.Create(Filename);
  try
    SaveDataToINI(Instance, INI);
  finally
    INI.Free;
  end;
end;

procedure SaveDataToINI(Instance: TComponent; INI: TINIFile);
var
  Filer: TDataFiler;
begin
  Filer := TDataINIFiler.Create(INI, Instance.Classname);
  try
    Filer.SaveData(Instance);
  finally
    Filer.Free;
  end;
end;

procedure SaveDataToStrings(Instance: TComponent; Items: TStrings);
var
  Filer: TDataFiler;
begin
  Filer := TDataStringFiler.Create(Items);
  try
    Filer.SaveData(Instance);
  finally
    Filer.Free;
  end;
end;

procedure LoadDataFromINIFile(Instance: TComponent; const Filename: String);
var
  INI: TINIFile;
begin
  INI := TINIFile.Create(Filename);
  try
    LoadDataFromINI(Instance, INI);
  finally
    INI.Free;
  end;
end;

procedure LoadDataFromINI(Instance: TComponent; INI: TINIFile);
var
  Filer: TDataFiler;
begin
  Filer := TDataINIFiler.Create(INI, Instance.ClassName);
  try
    Filer.LoadData(Instance);
  finally
    Filer.Free;
  end;
end;

procedure LoadDataFromStrings(Instance: TComponent; Items: TStrings);
var
  Filer: TDataFiler;
begin
  Filer := TDataStringFiler.Create(Items);
  try
    Filer.LoadData(Instance);
  finally
    Filer.Free;
  end;
end;


end.
