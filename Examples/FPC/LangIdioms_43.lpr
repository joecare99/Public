program LangIdioms_43;

(* Look for a negative value _v in 2D integer matrix _m.
   Print it and stop searching. *)

var
  m: array of array of integer;
  i: integer;
  j: integer;
  v: integer;
  flag: boolean;

begin
  setlength(m, 21, 19);
  for i := 0 to high(m) do
    for j := 0 to high(m[i]) do
      m[i, j] := random(100) - 1;

for i := 0 to length(m) * length(m[0]) - 1 do
begin
  v := m[i mod length(m), i div length(m)];
  if v < 0 then
  begin
    writeln(v);
    break;
  end;
end;

for i := 0 to high(m) do
begin
  for v in m[i] do
  begin
    flag := (v < 0);
    if flag then
    begin
      writeln(v);
      break;
    end;
  end;
  if flag then
    break;
end;

  readln;
end.
