program prj_CompileErr;

uses
  SysUtils,
  unt_BaseClass,
  unt_ChildClass;

var
  lS: TStringArray;
  i: integer;

begin
  lS := TChildClass.Something;
  for i := 0 to high(ls) do
    writeln(Format('%d %s', [i, ls[i]]));
  readln;
end.

