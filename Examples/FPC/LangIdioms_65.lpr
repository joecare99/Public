program LangIdioms_65;

uses
  SysUtils;

var
  Iter: integer;
  Items: array of TObject;
  n: integer;
  x: real;
  S: string;

begin
  x  := 0.15625;
  s :=format('%.1f%%', [100.0*x]);

  writeln(s);

  readln;
end.
