Unit unt_Point2d;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
{ $Author$ : Joe Care }
/// <Author>Joe Care</Author>

Interface

Type 
  { T2DPoint }
  T2DPoint = Class
    x, y: longint;
    Constructor init(nx, ny: longint); overload;
    Constructor init(Vect: T2DPoint); overload;
    Destructor done; virtual;
    Function Copy(nx, ny: longint): T2DPoint; overload; virtual;
    Function Copy(Vect: T2DPoint): T2DPoint; overload; virtual;
    Function Copy: T2DPoint; overload; virtual;
    Function add(vect: T2DPoint): T2DPoint; virtual;
    Function Subst(Vect: T2DPoint): T2DPoint; virtual;
    Function Mult(vect: T2DPoint): T2DPoint; virtual;
    Function SMult(vect: T2DPoint): longint; overload; virtual;
    function SMult(Scalar:integer;Divisor: integer=1): T2DPoint; overload; virtual;
    function Equals(Obj: TObject): boolean; override;
    function ToString: {$IFDEF FPC}ansistring{$ELSE}string{$ENDIF}; override;
    function GLen: longint; virtual;
    function MLen: longint; virtual;
  End;

  TArrayOF2DPoint = array Of T2DPoint ;

Var 
  dir4, dir8, dir12: TArrayOF2DPoint;

Function getdir(radius: integer; direction: integer): T2DPoint;
function getDirNo(Vect: T2DPoint): integer;
function getInvDir(dir, radius: integer): integer;

Implementation

uses math, sysutils;

{
 type
   TBase2dPoint = record
     x, y: integer;
   end;
}

var
  InvDir2D15, InvDir2d22: array of SmallInt;

function getDirNo(Vect: T2DPoint): integer;
var
  i: integer;
begin
  result := -1;
  if not assigned(Vect) then
    exit;
  if Vect.GLen = 0 then
    result := 0
  else if Vect.MLen = 1 then
  begin
    for i := 1 to high(Dir8) do
      if Vect.Equals(Dir8[i]) then
      begin
        result := i;
        break;
      end;
  end
  else if Vect.MLen = 2 then
  begin
    for i := 1 to high(Dir12) do
      if Vect.Equals(Dir12[i]) then
      begin
        result := i;
        break;
      end;
  end
end;

function getInvDir(dir, radius: integer): integer;
begin
  if dir < 1 then
    result := dir
  else if radius = 10 then
    result := ((dir + 2) mod 6) + 1
  else if radius = 15 then
    result := InvDir2D15[dir]
  else if radius = 22 then
    result := InvDir2D22[dir];
end;

Constructor T2DPoint.init(Vect: T2DPoint);

Begin
  Copy(Vect);
End;

constructor T2DPoint.init(nx, ny: longint);
begin
  Copy(nx, ny);
end;

destructor T2DPoint.Done;

Begin
  x := 0;
  y := 0;
  inherited;
End;

function T2DPoint.Copy(nx, ny: longint): T2dPoint;
begin
  x := nx;
  y := ny;
  result := self
end;

function T2DPoint.Copy(Vect: T2DPoint): T2DPoint;

Begin
  If Not assigned(vect) Then
    Begin
      x := 0;
      y := 0;
    End
  Else
    Begin
      x := Vect.x;
      y := Vect.y;
    End;
  result := self
End;

function T2DPoint.Copy: T2DPoint;
begin
  result := T2DPoint.init(self);
end;

Function T2DPoint.Add(Vect: T2DPoint): T2DPoint;

Begin
  if assigned(Vect) then
  begin
    x := x + Vect.x;
    y := y + Vect.y;
  end;
  result := self
End;

Function T2DPoint.Subst(Vect: T2DPoint): T2DPoint;

Begin
  if assigned(Vect) then
  begin
    x := x - Vect.x;
    y := y - Vect.y;
  end;
  result := self
End;

Function T2DPoint.Mult(Vect: T2DPoint): T2DPoint;

Var 
  nx, ny: integer;

Begin
  nx := x * Vect.x - y * Vect.y;
  ny := x * Vect.y + y * Vect.x;
  x := nx;
  y := ny;
  result := self
End;

Function T2DPoint.Smult(Vect: T2DPoint): longint;

Begin
  smult := x * Vect.x + y * Vect.y;
End;

function T2DPoint.SMult(Scalar: integer; Divisor: integer): T2DPoint;
begin
  x := (Scalar * int64(x)) div divisor;
  y := (Scalar * int64(y)) div divisor;
  result := self
end;

function T2DPoint.Equals(Obj: TObject): boolean;
begin
  if not assigned(Obj) or not Obj.InheritsFrom(T2DPoint) then
    result := inherited Equals(Obj)
  else
    result := (x = T2DPoint(Obj).x) and (y = T2DPoint(Obj).y);
end;

function T2DPoint.ToString: {$IFDEF FPC}ansistring{$ELSE}string{$ENDIF};
begin
  result := inherited ToString;
  result := result + '<' + inttostr(x) + ',' + inttostr(y) + '>';
end;

function T2DPoint.GLen: longint;
begin
  result := abs(x) + abs(y);
end;

function T2DPoint.MLen: longint;
begin
  result := max(abs(x), abs(y));
end;


Var 
  Sqrt2: extended;

function getdir(radius: integer; direction: integer): T2DPoint;

Var 
  imax: longint;

Var 
  hp: T2DPoint;
Var 
  nr: integer;

Begin
  imax := round(radius * sqrt2 * 4);
  If (round(radius * sqrt2) Mod 2) = 0 Then
    imax := imax + 4;
  nr := direction Mod (imax Div 2);
  nr := nr Mod (imax Div 4);
  If nr > imax Div 8 Then
    nr := (imax Div 4) - nr;
  If direction = 0 Then
    hp := T2DPoint.init(dir4[0])
  Else
    Case ((direction - 1) * 8 Div imax) Of
      0:
        Begin
          hp := T2DPoint.init(round(sqrt(radius * radius - nr * nr)), nr);
        End;
      1:
        Begin
          hp := T2DPoint.init(nr, round(sqrt(radius * radius - nr * nr)));
        End;
      2:
        Begin
          hp := T2DPoint.init(-nr, round(sqrt(radius * radius - nr * nr)));
        End;
      3:
        Begin
          hp := T2DPoint.init(-round(sqrt(radius * radius - nr * nr)), nr);
        End;
      4:
        Begin
          hp := T2DPoint.init(-round(sqrt(radius * radius - nr * nr)), -nr);
        End;
      5:
        Begin
          hp := T2DPoint.init(-nr, -round(sqrt(radius * radius - nr * nr)));
        End;
      6:
        Begin
          hp := T2DPoint.init(nr, -round(sqrt(radius * radius - nr * nr)));
        End;
      7:
        Begin
          hp := T2DPoint.init(round(sqrt(radius * radius - nr * nr)), -nr);
        End
    Else
      hp := T2DPoint.init(dir4[0]);
    End;
  result := hp;
End;

var
  i: integer;
  tdp: T2DPoint;

initialization

  sqrt2 := sqrt(2.0);
  setlength(Dir4, 5);
  dir4[0] := T2DPoint.init(0, 0);
  dir4[1] := T2DPoint.init(1, 0);
  dir4[2] := T2DPoint.init(0, 1);
  dir4[3] := T2DPoint.init(-1, 0);
  dir4[4] := T2DPoint.init(0, -1);

tdp := T2DPoint.init(nil);
  setlength(Dir8, 9);
  dir8[0] := Dir4[0];
  dir8[1] := Dir4[1];
  dir8[2] := T2DPoint.init(1, 1);
  dir8[3] := Dir4[2];
  dir8[4] := T2DPoint.init(-1, 1);
  dir8[5] := Dir4[3];
  dir8[6] := T2DPoint.init(-1, -1);
  dir8[7] := Dir4[4];
  dir8[8] := T2DPoint.init(1, -1);
setlength(InvDir2D15, high(dir8) + 1);
for i := 0 to high(dir8) do
  InvDir2D15[i] := getDirNo(tdp.Copy(Dir8[i]).SMult(-1));

  setlength(Dir12, 13);
  dir12[0] := Dir4[0];
  dir12[1] := T2DPoint.init(2, 0);
  dir12[2] := T2DPoint.init(2, 1);
  dir12[3] := T2DPoint.init(1, 2);
  dir12[4] := T2DPoint.init(0, 2);
  dir12[5] := T2DPoint.init(-1, 2);
  dir12[6] := T2DPoint.init(-2, 1);
  dir12[7] := T2DPoint.init(-2, 0);
  dir12[8] := T2DPoint.init(-2, -1);
  dir12[9] := T2DPoint.init(-1, -2);
  dir12[10] := T2DPoint.init(0, -2);
  dir12[11] := T2DPoint.init(1, -2);
  dir12[12] := T2DPoint.init(2, -1);
setlength(InvDir2d22, high(dir12) + 1);
for i := 0 to high(dir12) do
  InvDir2d22[i] := getDirNo(tdp.Copy(Dir12[i]).SMult(-1));

FreeAndNil(tdp);

finalization
for i := 0 to high(dir8) do
  dir8[i].free;
SetLength(dir4,0);
SetLength(dir8,0);

for i := 1 to high(dir12) do
  dir12[i].free;
SetLength(dir12,0);

End.

