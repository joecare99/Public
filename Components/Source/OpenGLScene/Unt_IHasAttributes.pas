unit Unt_IHasAttributes;

{$mode delphi}

interface

uses
  variants;

type

{ IHasAttributes }

 IHasAttributes=interface
        ['{50CDF743-3ACE-438E-B797-843148610163}']
        function AttrCount:integer;
        function GetAttributes(idx: variant): variant;
        procedure SetAttributes(idx: variant; AValue: variant);
        Function ListAttr:variant;
        property Attributes[idx:variant]:variant read GetAttributes write SetAttributes;
     end;

Function IndexOfString2(aArray:array of string;aStr:String;out oIdx:integer):boolean;

implementation

function IndexOfString2(aArray: array of string; aStr: String; out oIdx: integer
  ): boolean;
var
  lStr: String;
  i: Integer;
begin
  result := false;
  oIdx:=-1;
  lStr := LowerCase(aStr);
  for i := 0 to high(aArray) div 2 do
    if Lowercase(aArray[i*2]) = lStr then
      begin
        oIdx:=i;
        exit(true);
      end;
end;

end.

