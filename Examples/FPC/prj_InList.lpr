program prj_InList;


Function InList(x:integer;l:array of integer):boolean;

var
  II: LongInt;
begin
  result := false;
  for II in l do
    if II=x then
      begin
        result := true;
        break;
      end;
end;

var
  x: Integer;
  TestList:array of integer;
begin
  x := 5000;
  setlength(TestList,3);
  TestList[0] := 5;
  TestList[1] := 5000;
  TestList[2] := 555000;
  if Inlist(x,TestList) then writeln('yes');
end.

