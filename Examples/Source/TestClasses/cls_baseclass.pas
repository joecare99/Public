unit cls_BaseClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TBaseClass }

  TBaseClass = class
  private
    class function GetTestProp: string; static;
  public
    class function Test: TStringArray; virtual; abstract;
    class function GetTest: string;
    class property TestProp: string read GetTestProp;
  end;

implementation

{ TBaseClass }

class function TBaseClass.GetTestProp: string;
var
  lString: string;
begin
  Result := '';
   for lString in Test do
    Result := Result + lString;
end;

class function TBaseClass.GetTest: string;
var
  lString: string;
begin
  Result := '';
  for lString in Test do
    Result := Result + lString;
end;

end.
