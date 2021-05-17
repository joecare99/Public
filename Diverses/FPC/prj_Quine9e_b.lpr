program prj_Quine9e_b;
const c='const b=';
      b=''';a=#39;var d:char;begin write(c+a+b+a'';c=''a+c);for d in b do write(char(ord(d)-3))end.';
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


