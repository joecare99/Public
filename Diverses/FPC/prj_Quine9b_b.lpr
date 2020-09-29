program prj_Quine9b_b;
const c='program Q9;const r=#39;b=';
      b=''';var d:char;begin write(c+r+b+r+'';c=''+r+c);for d in b do write(char(byte(d)-3))end.';
var
  d: Char;
begin
  write(c+#39);
  for d in b do write(char(byte(d)+3));
  write(#39#59#99#61#39);
  write(c);
  writeln(b);
  readln;
end.


