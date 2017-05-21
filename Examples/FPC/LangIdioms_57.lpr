program LangIdioms_57;
(* Create list _y containing items from list _x satisfying predicate _p.
 Respect original ordering. Don't modify _x in-place.*)

const
  xx :array[0..4] of integer = (1,2,3,4,5);

var
  y : TBoundArray;
  v: LongInt;

function Filter(vv:integer):boolean;

begin
  result :=  vv mod 2= 0;
end;

type TFilter=function(v:integer):boolean;

function FilteredArray(const x:TBoundArray;p:TFilter):TBoundArray;
var
  Idx: Integer;

begin
  setlength(result,high(x)+1);
  Idx := 0;
  for v in x do
    if p(v) then
    begin
      result[Idx] := v;
      inc(Idx);
    end;
  setlength(result,Idx);
end;

begin
  y := FilteredArray(xx,{$IFDEF Delphi} Filter {$ELSE} @Filter {$ENDIF});

  for v in y do
    writeln(v);

  readln;
end.
