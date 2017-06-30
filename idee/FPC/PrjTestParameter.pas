program PrjTestParameter;

{$IFDEF MSWINDOWS}
{$APPTYPE CONSOLE}
{$ENDIF}

{ $Define WorkAround1}
{ $Define WorkAround2}

Function Test({const}Line:String;out Part1:string;{$ifndef WorkAround2} out{$else}var{$endif} Part2:string):Boolean; inline;

begin
  result := length(Line)>1;
  Part2:=copy(Line,2,length(Line)-1);
  Part1:= copy(Line,1,1);
end;

var
  BaseLine: String;
  OneChar: string;
  Baseline2: string;
  Onechar1: string;
  Rest1: string;

begin
  BaseLine := 'ABCDEFGHIJKLMNOP';
  Rest1:=BaseLine;
  if test(Rest1,Onechar1,Rest1) then
    writeln('1: ',Onechar1);

  if test(rest1,Onechar1,Rest1) then
    writeln('2: ',Onechar1);

  while Test(Baseline,OneChar,Baseline) do
    begin
     writeln(Onechar);
{$ifdef WorkAround1}
     BaseLine2:=BAseline;
{$endif}
    end;
  readln;
end.

