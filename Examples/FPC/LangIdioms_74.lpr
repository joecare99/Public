program LangIdioms_74;

function GCD(a,b:int64):int64;
(* Eukid algorithm *)
var
  t: Int64;
begin
  while b <> 0 do
    begin
       t := b;
       b := a mod b;
       a := t;
    end;
    result := a;
end;

begin
  {Compute GCD Greatest Common Divisor}
  writeln(gcd(1071,462));
  readln;
end.
