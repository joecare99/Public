unit cls_HejBase;

{$mode objfpc}{$H+}

interface

uses Classes, DB;

type
    TIndexRec=Record
      id:integer;
      case Boolean of
      False:(Date:TdateTime);
      true:(value:double);
    end;

    { TClsHejBase }

    TClsHejBase = class(TInterfacedPersistent)
    protected
        function GetCount: integer; virtual; abstract;
    public
        property Count: integer read GetCount;
    public
        function TestStreamHeader(st: Tstream): boolean; virtual; abstract;
        procedure Clear; virtual; abstract;
        Function IndexOf(Krit:variant):integer;virtual;abstract;
        procedure ReadfromStream(st: Tstream; cls: TClsHejBase = nil); virtual; abstract;
        procedure WriteToStream(st: TStream); virtual; abstract;
        procedure ReadFromDataset(const ds: TDataSet; cls: TClsHejBase = nil); virtual; abstract;
        procedure UpdateDataset(const ds: TDataSet); virtual; abstract;
    end;

function HejDate2DateStr(Day, Month, Year: string;dtOnly:boolean=false): string;
procedure DateStr2HeyDate(aDate:String;out Day, Month, Year: string);

implementation

uses SysUtils;

function HejDate2DateStr(Day, Month, Year: string; dtOnly: boolean): string;
var
    lNum: integer;
begin
    if not TryStrToInt(day, lNum) then
       if  TryStrToInt(RightStr(day,2) , lNum) then
          if dtOnly  then
            Result := RightStr(day,2)+'.'
          else
            Result := Day +'.'
        else if (day <>'') and not dtOnly then
          Result := Day +' 01.'
        else
          Result := '01.'
    else
        Result := Day + '.';

    if not TryStrToInt(month, lNum) then
        Result := Result + '01.'
    else
        Result := Result + Month + '.';
    if not TryStrToInt(Year, lNum) then
      begin
        if Result <> '01.01.' then
            Result := Result + '1900'
        else
            Result := Result + '01';
      end
    else
        Result := Result + Year;
    if Result = '01.01.01' then
        Result := '';
end;

procedure DateStr2HeyDate(aDate: String; out Day, Month, Year: string);
var
  lParts: TStringArray;
begin
  lParts := aDate.Split(['.']);
  if Length(lParts) = 3 then
    begin
      day:= lParts[0];
      Month:=lParts[1];
      Year:=lParts[2];
    end;
end;

end.
