program LangIdioms_76;

var
  n,Iter: integer;
  x: integer;
  S: string;

begin
  n := 16;
  x := 133;

  S := '';
  for Iter := 0 to n do
    s:= Char(Ord('0')+(x shr Iter) and 1) + S;

  writeln(s);

  readln;
end.
