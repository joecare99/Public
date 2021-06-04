program prj_Quine10.b;const b='program d.w;var e,d,o,r,b:string;f:int8=-32;begin r:=(#39)+#39;o:=r[1];e:=''';
                            e=';write(b,e,o,'';b:='',o,b,r);for d in e do write(b[word(d[1])+f])end.';  // ,b[1+word(d)+f
f=-32;
var
  o,d,r: string;
  i2,c3,c2: Int16;
begin
  (* i2 := 1;
   while i2 <= length(e) do
       begin
       if Pos(copy(e,i2,2),b)<>0 then
         begin
           inc(c2);
           write(c2,':!',copy(e,i2,2),', ');
           inc(i2);
         end
       else
       if Pos(e[i2],copy(e,1,i2-1))=0 then
         begin
           inc(c3);
           write(c3,':',e[i2],', ');
         end;
        inc(i2);
       end;
  writeln;    *)
  r:= (#39)+#39;
  (o):=r[1];
  write(b);
  for d in e do
     if Pos(d,b)=0 then
       write(#1)
else
     write(char(Pos(d,b)-f));
  write(''';b:=''');
  write(b+r);
  writeln(e);
  readln;
end.


