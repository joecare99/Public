program prj_Rangecheck;

uses
  Windows,
  SysUtils;

  function ToIP4(const A, B, C, D: byte): integer; // inline;
  begin
    Result := integer(cardinal(A) shl 24) + (B shl 16) + (C shl 8) + D;
  end;
  //---------------------------------------------------------------------------

  function ToIP4v2(const A, B, C, D: byte): integer; // inline;
  type
    TIntCast = record
        cd, cc, cb, ca: byte;
    end;
    PintCast = ^TIntCast;

  begin
    with Pintcast(@Result)^ do
    begin
      ca := A;
      cb := B;
      cc := C;
      cd := D;
    end;
  end;
  //---------------------------------------------------------------------------

var
  tt: cardinal;
  k: integer;
  i: integer;
begin
  Writeln('Start');
  k := 0;
  tt := GetTickCount;
  for i := 1 to 100000000 do
  begin
    K := ToIP4v2(byte(k and 255), 2, 3, I mod 255);
  end;
  writeln(IntToStr(GetTickCount - tt));
  writeln(k);
  writeln(IntToStr(ToIP4v2(1, 2, 3, 4)));
  writeln(IntToStr(ToIP4v2(128, 122, 123, 124)));
  k := 0;
  tt := GetTickCount;
  for i := 1 to 100000000 do
  begin
    K := ToIP4(byte(k and 255), 2, 3, I mod 255);
  end;
  writeln(IntToStr(GetTickCount - tt));
  writeln(k);
  writeln(IntToStr(ToIP4(1, 2, 3, 4)));
  writeln(IntToStr(ToIP4(128, 122, 123, 124)));
  readln;
end.
