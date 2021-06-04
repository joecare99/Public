program prj_testOut2;
{$APPTYPE CONSOLE}
{$IFDEF FPC}{$MODE OBJFPC}{$ENDIF}
procedure test(const a:integer;out b:integer);
begin
//  inc(b);
  b := a + 1;
end;

var
 c,d:integer;

begin
  c := 100;
  test(c,c);
  writeln(c);
  test(c,c);
  writeln(c);
  test(c,d);
  writeln(d);
  readln;
end.
