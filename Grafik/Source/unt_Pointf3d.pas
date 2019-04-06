Unit unt_Pointf3d;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}
{ $Author$ : Joe Care }
/// <Author>Joe Care</Author>

Interface

Type
  { T3DPointF }
  T3DPointF = Class
    x, y, z: Extended;
    Constructor Create(nx, ny, nz: extended); overload;
    Constructor Create(Vect: T3DPointF); overload;
    Destructor done; virtual;
    Function Copy(nx, ny, nz: extended): T3DPointF; overload; virtual;
    Function Copy(Vect: T3DPointF): T3DPointF; overload; virtual;
    Function Copy: T3DPointF; overload; virtual;
    Function add(Vect: T3DPointF): T3DPointF; virtual;
    Function Subst(Vect: T3DPointF): T3DPointF; virtual;
    Function Mult(Vect: T3DPointF): T3DPointF; virtual;
    Function SMult(Vect: T3DPointF): Extended; overload; virtual;
    function SMult(Scalar:extended;Divisor: Extended=1.0): T3DPointF; overload; virtual;
    function Equals(Obj: TObject): boolean; override;
    function ToString: {$IFDEF FPC}ansistring{$ELSE}string{$ENDIF}; override;
    function GLen:Extended ; virtual;
    function MLen: Extended; virtual;
  End;

  TArrayOF3DPoint = array Of T3DPointF ;

function Point3dF(x,y,z:Extended):T3DPointF;

Var
  Dir3D1, Dir3D15, Dir3D22: TArrayOF3DPoint;

Function getdir(radius: integer; direction: integer): T3DPointF;
function getDirNo(Vect: T3DPointF): integer;
function getInvDir(dir, radius: integer): integer;

Implementation

uses math, sysutils;

type
  TBase3dPoint = record
    x, y, z: integer;
  end;

const
  BaseDir1: array [0 .. 6] of TBase3dPoint = ((x: 0; y: 0; z: 0), (x: 1; y: 0;
    z: 0), (x: 0; y: 1; z: 0), (x: 0; y: 0; z: 1), (x: - 1; y: 0; z: 0), (x: 0;
    y: - 1; z: 0), (x: 0; y: 0; z: - 1));

  BaseDir15: array [0 .. 26] of TBase3dPoint = ((x: 0; y: 0; z: 0), { 0 }
    (x: 1; y: 0; z: 0), { 1 }
    (x: 1; y: 1; z: 0), (x: 0; y: 1; z: 0), { 2 }
    (x: - 1; y: 1; z: 0), (x: - 1; y: 0; z: 0), { 4 }
    (x: - 1; y: - 1; z: 0), (x: 0; y: - 1; z: 0), { 5 }
    (x: 1; y: - 1; z: 0), (x: 1; y: 0; z: 1), (x: 1; y: 1; z: 1), (x: 0; y: 1;
    z: 1), (x: - 1; y: 1; z: 1), (x: - 1; y: 0; z: 1), (x: - 1; y: - 1; z: 1),
    (x: 0; y: - 1; z: 1), (x: 1; y: - 1; z: 1), (x: 0; y: 0; z: 1), { 3 }
    (x: 1; y: 0; z: - 1), (x: 1; y: 1; z: - 1), (x: 0; y: 1; z: - 1), (x: - 1;
    y: 1; z: - 1), (x: - 1; y: 0; z: - 1), (x: - 1; y: - 1; z: - 1), (x: 0;
    y: - 1; z: - 1), (x: 1; y: - 1; z: - 1), (x: 0; y: 0; z: - 1)); { 6 }

  BaseDir22: array [0 .. 54] of TBase3dPoint = ((x: 0; y: 0; z: 0), (x: 2; y: 0;
    z: 0), (x: 2; y: 1; z: 0), (x: 1; y: 2; z: 0), (x: 0; y: 2; z: 0), (x: - 1;
    y: 2; z: 0), (x: - 2; y: 1; z: 0), (x: - 2; y: 0; z: 0), (x: - 2; y: - 1;
    z: 0), (x: - 1; y: - 2; z: 0), (x: 0; y: - 2; z: 0), (x: 1; y: - 2; z: 0),
    (x: 2; y: - 1; z: 0), (x: 2; y: 0; z: 1), (x: 2; y: 1; z: 1), (x: 1; y: 2;
    z: 1), (x: 0; y: 2; z: 1), (x: - 1; y: 2; z: 1), (x: - 2; y: 1; z: 1),
    (x: - 2; y: 0; z: 1), (x: - 2; y: - 1; z: 1), (x: - 1; y: - 2; z: 1), (x: 0;
    y: - 2; z: 1), (x: 1; y: - 2; z: 1), (x: 2; y: - 1; z: 1), (x: 2; y: 0;
    z: - 1), (x: 2; y: 1; z: - 1), (x: 1; y: 2; z: - 1), (x: 0; y: 2; z: - 1),
    (x: - 1; y: 2; z: - 1), (x: - 2; y: 1; z: - 1), (x: - 2; y: 0; z: - 1),
    (x: - 2; y: - 1; z: - 1), (x: - 1; y: - 2; z: - 1), (x: 0; y: - 2; z: - 1),
    (x: 1; y: - 2; z: - 1), (x: 2; y: - 1; z: - 1), (x: 1; y: 0; z: 2), (x: 1;
    y: 1; z: 2), (x: 0; y: 1; z: 2), (x: - 1; y: 1; z: 2), (x: - 1; y: 0; z: 2),
    (x: - 1; y: - 1; z: 2), (x: 0; y: - 1; z: 2), (x: 1; y: - 1; z: 2), (x: 0;
    y: 0; z: 2), (x: 1; y: 0; z: - 2), (x: 1; y: 1; z: - 2), (x: 0; y: 1;
    z: - 2), (x: - 1; y: 1; z: - 2), (x: - 1; y: 0; z: - 2), (x: - 1; y: - 1;
    z: - 2), (x: 0; y: - 1; z: - 2), (x: 1; y: - 1; z: - 2), (x: 0;
    y: 0; z: - 2));

var
  InvDir3D15, InvDir3d22: array of SmallInt;

function getDirNo(Vect: T3DPointF): integer;
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
    for i := 1 to high(Dir3D15) do
      if Vect.Equals(Dir3D15[i]) then
      begin
        result := i;
        break;
      end;
  end
  else if Vect.MLen = 2 then
  begin
    for i := 1 to high(Dir3D22) do
      if Vect.Equals(Dir3D22[i]) then
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
    result := InvDir3D15[dir]
  else if radius = 22 then
    result := InvDir3d22[dir];
end;

constructor T3DPointF.Create(Vect: T3DPointF);

Begin
  Copy(Vect);
End;

constructor T3DPointF.Create(nx, ny, nz: extended);
begin
  Copy(nx, ny, nz);
end;

destructor T3DPointF.done;

Begin
  x := 0;
  y := 0;
  z := 0;
  inherited;
End;

function T3DPointF.Copy(nx, ny, nz: extended): T3DPointF;
begin
  x := nx;
  y := ny;
  z := nz;
  result := self
end;

function T3DPointF.Copy(Vect: T3DPointF): T3DPointF;

Begin
  If Not assigned(Vect) Then
  Begin
    x := 0;
    y := 0;
    z := 0;
  End
  Else
  Begin
    x := Vect.x;
    y := Vect.y;
    z := Vect.z;
  end;
  result := self
End;

function T3DPointF.Copy: T3DPointF;
begin
  result := T3DPointF.Create(self);
end;

function T3DPointF.add(Vect: T3DPointF): T3DPointF;

Begin
  if assigned(Vect) then
  begin
    x := x + Vect.x;
    y := y + Vect.y;
    z := z + Vect.z;
  end;
  result := self
End;

function T3DPointF.Subst(Vect: T3DPointF): T3DPointF;
begin
  if assigned(Vect) then
  begin
    x := x - Vect.x;
    y := y - Vect.y;
    z := z - Vect.z;
  end;
  result := self
end;

function T3DPointF.Mult(Vect: T3DPointF): T3DPointF;

Var
  nx, ny,nz: extended;

Begin
  nx := y * Vect.z - z * Vect.y;
  ny := z * Vect.x - x * Vect.z;
  nz := x * Vect.y - y * Vect.x;
  x := nx;
  y := ny;
  z := nz;
  result := self
End;

function T3DPointF.SMult(Vect: T3DPointF): Extended;

Begin
  result := x * Vect.x + y * Vect.y + z * Vect.z;
End;

function T3DPointF.SMult(Scalar: extended; Divisor: Extended): T3DPointF;
begin
  assert(Divisor <>0.0,'Divisor darf nicht 0 sein');
  x := (Scalar * (x)) / divisor;
  y := (Scalar * (y)) / divisor;
  z := (Scalar * (z)) / divisor;
  result := self
end;

function T3DPointF.Equals(Obj: TObject): boolean;
begin
  if not assigned(Obj) or not Obj.InheritsFrom(T3DPointF) then
    result := inherited Equals(Obj)
  else
    result := (x = T3DPointF(Obj).x) and (y = T3DPointF(Obj).y) and
      (z = T3DPointF(Obj).z);
end;

function T3DPointF.ToString: {$IFDEF FPC}ansistring{$ELSE}string{$ENDIF};
begin
  result := inherited ToString;
  result := result + '<' + FloatToStr(x) + ',' + FloatToStr(y) + ',' +
    FloatToStr(z) + '>';
end;

function T3DPointF.GLen: Extended;
begin
  result := abs(x) + abs(y) + abs(z);
end;

function T3DPointF.MLen: Extended;
begin
  result := max(abs(x), max(abs(y), abs(z)));
end;

Var
  Sqrt2: extended;

function Point3dF(x, y, z: Extended): T3DPointF;
begin
  result := T3DPointF.Create(x,y,z);
end;

Function getdir(radius: integer; direction: integer): T3DPointF;

Var
  imax: longint;

Var
  hp: T3DPointF;
Var
  nr: integer;

Begin
  imax := round(radius * Sqrt2 * 4);
  If (round(radius * Sqrt2) Mod 2) = 0 Then
    imax := imax + 4;
  nr := direction Mod (imax Div 2);
  nr := nr Mod (imax Div 4);
  If nr > imax Div 8 Then
    nr := (imax Div 4) - nr;
  If direction = 0 Then
    hp := T3DPointF.create(Dir3D1[0])
  Else
    Case ((direction - 1) * 8 Div imax) Of
      0:
        Begin
          hp := T3DPointF.create(round(sqrt(radius * radius - nr * nr)), nr, 0);
        End;
      1:
        Begin
          hp := T3DPointF.create(nr, round(sqrt(radius * radius - nr * nr)), 0);
        End;
      2:
        Begin
          hp := T3DPointF.create(-nr, round(sqrt(radius * radius - nr * nr)), 0);
        End;
      3:
        Begin
          hp := T3DPointF.create(-round(sqrt(radius * radius - nr * nr)), nr, 0);
        End;
      4:
        Begin
          hp := T3DPointF.create(-round(sqrt(radius * radius - nr * nr)), -nr, 0);
        End;
      5:
        Begin
          hp := T3DPointF.create(-nr, -round(sqrt(radius * radius - nr * nr)), 0);
        End;
      6:
        Begin
          hp := T3DPointF.create(nr, -round(sqrt(radius * radius - nr * nr)), 0);
        End;
      7:
        Begin
          hp := T3DPointF.create(round(sqrt(radius * radius - nr * nr)), -nr, 0);
        End
    Else
      hp := T3DPointF.create(Dir3D1[0]);
    End;
  result := hp;
End;

var
  i: integer;
  tdp: T3DPointF;

initialization

Sqrt2 := sqrt(2.0);
setlength(Dir3D1, high(BaseDir1) + 1);
for i := 0 to high(BaseDir1) do
  Dir3D1[i] := T3DPointF.create(BaseDir1[i].x, BaseDir1[i].y, BaseDir1[i].z);

tdp := T3DPointF.create(nil);
setlength(Dir3D15, high(BaseDir15) + 1);
for i := 0 to high(BaseDir15) do
  Dir3D15[i] := T3DPointF.create(BaseDir15[i].x, BaseDir15[i].y, BaseDir15[i].z);

setlength(InvDir3D15, high(BaseDir15) + 1);
for i := 0 to high(BaseDir15) do
  InvDir3D15[i] := getDirNo(tdp.Copy(Dir3D15[i]).SMult(-1));

setlength(Dir3D22, high(BaseDir22) + 1);
for i := 0 to high(BaseDir22) do
  Dir3D22[i] := T3DPointF.create(BaseDir22[i].x, BaseDir22[i].y, BaseDir22[i].z);

setlength(InvDir3d22, high(BaseDir22) + 1);
for i := 0 to high(BaseDir22) do
  InvDir3d22[i] := getDirNo(tdp.Copy(Dir3D22[i]).SMult(-1));

FreeAndNil(tdp);

finalization

for i := 0 to high(Dir3D1) do
  Dir3D1[i].free;
setlength(Dir3D1, 0);

for i := 0 to high(Dir3D15) do
  Dir3D15[i].free;
setlength(Dir3D15, 0);
setlength(InvDir3D15, 0);

for i := 0 to high(Dir3D22) do
  Dir3D22[i].free;
setlength(Dir3D22, 0);
setlength(InvDir3d22, 0);

End.
