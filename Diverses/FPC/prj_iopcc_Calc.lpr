program prj_iopcc_Calc;

{$apptype console}
uses sysutils,math;

const
  s ='11110201011110100102030011200010001112201210011103101010010211112';
  tt :array[0..3] of integer = ( 0, -3, 38, -1 );
var
  j, i :integer;
  ch: Char;

  Li: Int128Rec=(lo:$0;hi:$0);
  s1: String;
  bb, bb2,rr, mm,b: Byte;

begin
  for j in tt do
    Write( format( '%d ,', [j and 3] ) );
  writeln;
//  $21200100
  for ch in '_|_  |  ' do
  write( format( '%x ,', [ord(ch )] ));
  writeln;
  writeln(s);
// SmallPush & Pop
  s1:='';
  for ch in s do
    s1:= ch+s1;
  for ch in s1 do
    begin
      // RLL Encoding
      bb := byte(ch) and 3;
      bb := bb xor (bb shr 1) xor 1;
      bb2:= 1 shl bb; //(bb and (bb shr 1)) xor 1;
      rr := min(bb+1,3);
      mm := (1 shl rr)-1;
      li.Lo := RolQWord(li.lo,rr);
      li.Hi := RolQWord(li.Hi,rr) or (li.lo and mm);
      li.Lo := ((li.lo or mm)xor mm) xor (bb2 and mm);
    end;
  writeln(inttohex(li.Hi,16),', ',inttohex(li.lo,16)) ;
  s1:='';
  while li.Lo or li.hi <>0 do
    begin
      b :=0;
      rr :=0;
      while (b=0) and (rr<3) do
      begin
      b := li.lo and 1;
      li.Lo := RorQWord(((li.lo or 1) xor 1) xor (li.hi and 1),1)  ;
      li.Hi := RorQWord((li.Hi or 1) xor 1,1);
      inc(rr);
      end;
      S1 += char(48+((rr-b) xor ((rr-b) shr 1) xor 1) );
    end;
  writeln(S1);
  ReadLn;
end.
