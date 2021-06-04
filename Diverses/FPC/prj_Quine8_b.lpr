program prj_Quine8_b;uses base64;const d='program Q8;uses base64;const r=#39;b=';
s2=''';begin write(c+r+b+r+'';c=''+r+c+DecodeStringBase64(b))end.';
begin
  write(d+#39);
  write(EncodeStringBase64(s2));
  write(#39#59#99#61#39);
  write(d);
  writeln(s2);
  readln;
end.


