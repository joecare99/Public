program LangIdioms_12;
// Show n bits of a given number x
uses
  classes;

var
  Iter: integer;
  n: integer;
  x: integer;
  S: string;

begin

  n := 16;
  x := 133;

  S := '';
  for Iter := 0 to n do
    if (x shr Iter) and 1 = 0 then
      S := '0' + S
    else
      S := '1' + S;

  writeln(s);

  readln;
end.
