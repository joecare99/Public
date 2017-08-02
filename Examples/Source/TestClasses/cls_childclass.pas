unit cls_ChildClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_BaseClass;

type

  { TChildClass }

  TChildClass = class(TBaseClass)
    class function Test: TStringArray; override;
  end;

implementation

{ TChildClass }

class function TChildClass.Test: TStringArray;
begin
  setlength(Result, 1);
  Result[0] := 'Test';
end;

end.

