program Prj_WritePascal2;

const
  i64: int64 = 1055120232691680095;
  cc: array[-1..15] of string =
    ('_______v---',
    '   ', '_  ', '    ', '_   ',
    '___', ' \_', '____', ' \__',
    ' __', '___', '  __', '_  _',
    '/  ', '   ', '_/  ', ' \/ ');
var
  x, y: integer;

begin
  for y := 0 to 7 do
  begin
    Write(StringOfChar(cc[(y and 1) shl 2][1], 7 - y div 2));
    Write(cc[((i64 shr (y div 2)) and 1) shl 3 + (y and 1) shl 2 + 2]);
    for x := 0 to 15 do
      Write(cc[((i64 shr ((x and 15) * 4 + y div 2)) and 1) +
        ((i64 shr (((x + 1) and 15) * 4 + y div 2)) and 1) shl 3 +
        (x mod 3) and 2 + (y and 1) shl 2]);
    writeln(cc[1 + (y and 1) shl 2] + cc[(not y and 1) - 1]);
  end;
  readln;
end.
