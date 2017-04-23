program Prj_WritePascal4;

const
  i64: int64 = 1055120232691680095; (* This defines "Pascal" *)
  cc: array[-3..3] of string = (* Here are all string-constants *)
    ('\ '#8' \  ', #8'__    ', #8'__/\  ',
    '  '#8'    ', #8'__/\  ', '  '#8'    ', #8'__/\  ');
var
  x, y: integer;

begin
  for y := 0 to 11 do
  begin
    Write(StringOfChar(cc[0][1], 13 - y));
    for x := 0 to 16 do
      Write(copy(cc[(((i64 shr ((x and 15) * 4 + y div 3)) and (3 -
        (y div 9) shl 1))-4 + (2 - y mod 3) shl 2) mod 4], 1,
         5 + (x mod 3) and 2));
    writeln;
  end;
  readln;
end.
