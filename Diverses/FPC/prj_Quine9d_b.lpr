program prj_Quine9d_b;
uses Sysutils;
const c='const b='#39;
      b=''';var d:char;begin write(''const b=''#39+b);for d in b do write(char(byte(d)-%0:s))end.';
var
  d: Char;
  I: Integer;
begin
  writeln(32-byte('§'[1]));
  for I := 1 to 20 do
  begin
  write('const b='+#39);
  for d in wr format(b,[inttostr(I)]) do write(char(byte(d)-I));
//  write(#39);
//  write(c);
  writeln(b);
end;//  write(#39);
//  write(c);
  writeln(b);
  readln;
end.


