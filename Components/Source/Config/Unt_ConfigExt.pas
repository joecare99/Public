unit Unt_ConfigExt;

{*V 1.01}
{*H 1.00 Neu WriteTSring ReadTString}

interface

uses classes;

type TarrayOfString=array of String;
//    Procedure ReadCnfVArrString(VAName: String; Var VA: TarrayOfString; temp: Variant);
//    Procedure WriteCnfVArrString(VAName: String; Var VA: TarrayOfString);
procedure WriteTStringsOfObject(lines: TStrings; CObject: TObject);
procedure ReadTStringsOfObject(lines: TStrings; CObject: TObject);
procedure WriteTStrings(lines: TStrings; Section, Index: String);
procedure ReadTStrings(lines: TStrings; Section, Index: String);


implementation

uses Unt_config,variants,sysutils;

resourcestring
  StrCfgObjNotInit = 'Konfigurationsobjekt nicht initialisiert';

procedure WriteTStringsOfObject(lines: TStrings; CObject: TObject);
var
  i: Integer;
begin
  assert(assigned(Config),StrCfgObjNotInit);
  config.value[CObject, 'Anzahl'] := Lines.Count;
  for I := 0 to Lines.Count - 1 do
    Config.value[CObject, inttostr(I)] := lines[i];
end;

procedure ReadTStringsOfObject(lines: TStrings; CObject: TObject);
var
  I: Integer;
begin
  assert(assigned(Config),StrCfgObjNotInit);
  lines.Clear;
  for I := 0 to config.getvalue(cobject, 'Anzahl',0) - 1 do
    lines.add(Config.getvalue(cobject, inttostr(I),''));
end;

procedure WriteTStrings(lines: TStrings; Section, Index: String);
var
  i: Integer;
begin
  assert(assigned(Config),StrCfgObjNotInit);
  config.Setvalue(Section, Index+'.Anzahl', Lines.Count);
  for I := 0 to Lines.Count - 1 do
    Config.setvalue(Section, Index+'.'+inttostr(I), lines[i]);
end;

procedure ReadTStrings(lines: TStrings; Section, Index: String);
var
  I: Integer;
begin
  assert(assigned(Config),StrCfgObjNotInit);
  lines.Clear;
  for I := 0 to config.getvalue(Section, Index+'.Anzahl',0) - 1 do
    lines.add(Config.getvalue(Section, Index+'.'+inttostr(I),''));
end;


end.
