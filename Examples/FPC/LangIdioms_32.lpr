program LangIdioms_32;

(* Create function exp which calculates (fast) the value x power n.
   x and n are non-negative integers.*)

function exp(x: integer; n: integer): integer; overload;

begin
  if n = 0 then
    Result := 1
  else if n = 1 then
    Result := x
  else if (n and 1) = 0 then
    Result := exp(x * x, n div 2)
  else
    Result := x * exp(x * x, n div 2);
end;

function exp(x: QWord; n: integer): QWord; overload;

begin
  if n = 0 then
    Result := 1
  else if n = 1 then
    Result := x
  else if (n and 1) = 0 then
    Result := exp(x * x, n div 2)
  else
    Result := x * exp(x * x, n div 2);
end;

begin
  writeln(exp(2, 0));
  writeln(exp(2, 1));
  writeln(exp(2, 2));
  writeln(exp(2, 3));
  writeln(exp(2, 4));
  writeln(exp(2, 5));

  writeln(exp(3, 0));
  writeln(exp(3, 1));
  writeln(exp(3, 2));
  writeln(exp(3, 3));

  readln;
end.
