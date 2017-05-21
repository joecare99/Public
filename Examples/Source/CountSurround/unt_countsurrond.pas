unit unt_CountSurrond;
{$IFDEF FPC}
{$MODE objfpc}{$H+}
{$ENDIF}

interface

uses
  {$IFNDEF FPC}
  windows,
  {$ENDIF}
  Classes, SysUtils;

procedure Execute;

implementation

type
  TSurround = (b1, b2, b3);

  TMyClass = record
    arrbool: array [TSurround] of boolean;
  end;

  TDirection = (d_itself, d_above, d_right, d_down, d_left, d_aboveright,
    d_rightdown, d_downleft, d_leftabove);

const
  DirOffset: array [TDirection] of TPoint =
    ((x: 0; y: 0), (x: 0; y: - 1), (x: 1; y: 0), (x: 0; y: 1), (x: - 1; y: 0),
    (x: 1; y: - 1), (x: 1; y: 1), (x: - 1; y: 1), (x: - 1; y: - 1));

  Bool2byte: Array [boolean] Of Byte = (0, 1);

  // [...]
  // Count all surrounding cells and the cell itself.
var
  MyClassarray: array of array of TMyClass;

function count(_type: TSurround; x, y: Byte): Byte; inline;
begin
  Result := 0; // Default value
  if (x >= 0) and (x <= high(MyClassarray)) and (y >= 0) and
    (y <= high(MyClassarray[x])) then
    Result := Bool2byte[MyClassarray[x, y].arrbool[_type]];
end;

function countSurround(_type: TSurround; x, y: Byte): Byte;
begin
  Result := count(_type, x + DirOffset[d_itself].x, y + DirOffset[d_itself].y)
    + count(_type, x + DirOffset[d_above].x, y + DirOffset[d_above].y) + count
    (_type, x + DirOffset[d_right].x, y + DirOffset[d_right].y) + count
    (_type, x + DirOffset[d_down].x, y + DirOffset[d_down].y) + count
    (_type, x + DirOffset[d_left].x, y + DirOffset[d_left].y);
end;

function countSurround2(_type: TSurround; x, y: Byte): Byte;
var
  d: TDirection;
begin
  Result := 0;
  for d := d_itself to d_left do
    inc(Result, count(_type, x + DirOffset[d].x, y + DirOffset[d].y));
end;

procedure Execute;

begin
  SetLength(MyClassarray, 20, 20);
  MyClassarray[4, 4].arrbool[b1] := true; ;
  writeln(countSurround(b1, 3, 4));
  writeln(countSurround2(b1, 4, 5));
  readln;
end;

end.
