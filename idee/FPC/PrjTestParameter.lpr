program PrjTestParameter;

Function Test(Line:String;out Part1,Part2:string):Boolean;

begin
  result := length(Line)>1;
  Part1:= copy(Line,1,1);
  Part2:= copy(Line,2,length(Line)-1);
end;

var
  BaseLine: String;
  OneChar: string;

begin
  BaseLine := 'ABCDEFGHIJKLMNOP';
  while Test(Baseline,OneChar,Baseline) do
    writeln(Onechar);
end.

