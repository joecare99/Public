unit unt_CShTestData;

{$mode objfpc}{$H+}
{$modeswitch advancedrecords on}

interface

uses
  Classes, SysUtils;

type     { TResultType }

    TResultType = record
        eType,
        Data,
        Ref: string;
        SubType: integer;
        function ToString: string;
        procedure SetAll(const aValue: array of variant; NoConvert: boolean=true);
          overload;
        procedure SetAll(const aValue: TStringArray); overload;
        function ToCSV(delim: string): string;
        //     property All:array of Variant write SetAll
    end;
    TResultTypeArray = array of TResultType;

implementation

uses typInfo,CShScanner;
{$if FPC_FULLVERSION = 30200 }
    {$WARN 6058 OFF}
{$ENDIF}

{ TResultType }

function TResultType.ToString: string;
begin
    Result := format('(eType:%s;Data:%s;Ref:%s;SubType:%d)',
        [QuotedStr(eType), QuotedStr(Data), QuotedStr(Ref), SubType]);
end;

procedure TResultType.SetAll(const aValue: array of variant;NoConvert:boolean=true);
begin
    if length(aValue) = 4 then
      begin
        eType := GetEnumName(TypeInfo( TToken) ,aValue[0]);
        Data := aValue[1];
        if not NoConvert then
          Data := Data.Replace('\\', '\'#1).Replace('\r', #13).Replace('\n', #10).Replace('\t', #9).Replace('\'#1, '\');
        Ref := aValue[2];
        SubType := aValue[3];
      end;
end;

procedure TResultType.SetAll(const aValue: TStringArray);
begin
    if (length(aValue) = 4) and TryStrToInt(aValue[3], SubType) then
      begin
        eType := aValue[0];
        Data := aValue[1].Replace('\\', '\'#1).Replace('\r', #13).Replace('\n', #10).Replace('\t', #9).Replace('\'#1, '\');
        Ref := aValue[2];
      end
    else
        eType := 'NIO';
end;

function TResultType.ToCSV(delim: string): string;
begin
    Result := ''.Join(delim, [eType, Data.Replace('\', '\\').Replace(
        #9, '\t').Replace(#10, '\n').Replace(#13, '\r'), ref, IntToStr(SubType)]);
end;

end.

