unit unt_ChildClass;

{$mode Delphi}

interface

uses
  Classes,  unt_BaseClass;

type

  { TChildClass }
   // see §1
  TChildClass = class(TBaseClass)
    class function Something: TStringArray; override;
  end;

implementation

uses SysUtils;
{ TChildClass }

class function TChildClass.Something: TStringArray;
begin
  setlength(Result, 2);
  Result[0] := 'Hello';
  Result[1] := Format('%s%s',['Wor','ld']);
end;

end.

