program LangIdioms_42;
(*Continue outer Loop*)

const
  a :array[0..4] of integer = (1,2,3,4,5);
  b :array[0..1] of integer= (3,5);
var
  v: LongInt;
  w: LongInt;


begin
  for v in a do
    begin
      for  w in b do
        if (v = w) then
          break;
      if (v = w) then
        Continue;
      writeln(v);
    end;
  readln;
end.
