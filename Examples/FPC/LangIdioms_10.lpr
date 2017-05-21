program LangIdioms_10;
(*Shuffle a List*)
var
  n,Iter: integer;
  x: integer;
  List :array of integer;
  rr: Int64;
  tmp: LongInt;

begin
  n := 16;
  setlength(list,n);
  for Iter := 0 to high(List) do
    list[Iter]:= Iter; (*Generate Sorted List*)

  for Iter := 0 to high(List) do
    begin
      rr := random(high(List)+1);
      tmp := List[Iter];
      List[Iter] := List[rr];
      List[rr] := tmp;
    end;

  for Iter := 0 to high(List) do
    writeln(iter,': ',list[Iter]);

  readln;
end.
