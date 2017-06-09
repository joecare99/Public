program prj_iopcc_Calc;

{$apptype console}
uses sysutils;

const
  tt :array[0..3] of integer = ( 0, -3, 38, -1 );
var
  j, i :integer;
  ch: Char;

begin
  for j in tt do
    Write( format( '%d ,', [j and 3] ) );
  writeln;
  $21200100
  for ch in '_|_  |  ' do
  write( format( '%x ,', [ord(ch )] ));

  ReadLn;
end.
