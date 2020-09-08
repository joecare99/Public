program prj_Quine9c_b;
const c='const b=';
      b=''';var d:char;begin write(c+#39+b+#39'';c=''#39+c);for d in b do write(char(byte(d)-3))end.';
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


