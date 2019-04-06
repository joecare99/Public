unit testcasef3dPoint;

{$IFDEF FPC}
  {$MODE Delphi}{$H+}
{$ENDIF}
{ $Author$ : Joe Care }
/// <Author>Joe Care</Author>

interface

uses
  Classes, SysUtils, {$IFDEF FPC}fpcunit, testutils, testregistry,{$Else}testframework,
 {$ENDIF}unt_Pointf3d;

type

  { TTestf3dPoint }

  TTestf3dPoint = class(TTestCase)
  private
    FZero: T3DPointF;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetup;
    procedure TestDir3D1;
    procedure TestDir3d15;
    procedure TestDir3d22;
    procedure TestToString;
    procedure TestAdd;
    procedure TestNeg;
    procedure TestSmult;
    procedure TestGetDirNo;
  end;

implementation

procedure TTestf3dPoint.TestSetup;
begin
  CheckNotNull(FZero, 'FZero is Assigned');
  CheckEquals('T3DPointF<0,0,0>', FZero.ToString, 'FZero.ToString');
  CheckTrue(Fzero.Equals(dir3d1[0]), 'FZero = dir3d1[0]');
  CheckFalse(Fzero.Equals(dir3d1[1]), 'FZero <> dir3d1[1]');
end;

procedure TTestf3dPoint.TestDir3D1;
var
  i: integer;
  j: integer;
begin
  CheckNotNull(Dir3D1[0], 'Dir3D1[0] is Assigned');
  CheckEquals(0, Dir3D1[0].GLen, 'Dir3D1[0] Geometrische Länge');
  CheckEquals(0, Dir3D1[0].MLen, 'Dir3D1[0] Maximale Länge');
  for i := 1 to high(Dir3D1) do
  begin
    CheckNotNull(Dir3D1[i], 'Dir3D1[' + IntToStr(i) + '] is Assigned');
    CheckEquals(1, Dir3D1[i].GLen, 'Dir3D1[' + IntToStr(i) + '] Geometrische Länge');
    CheckEquals(1, Dir3D1[i].MLen, 'Dir3D1[' + IntToStr(i) + ']Maximale Länge');
    for j := i + 1 to high(Dir3D1) do
      CheckFalse(Dir3D1[i].Equals(dir3d1[j]), 'Dir3D1[' + IntToStr(i) + '] <> Dir3D1[' + IntToStr(j) + ']');
  end;
end;

procedure TTestf3dPoint.TestDir3d15;
var
  i: integer;
  j: integer;
begin
  CheckNotNull(Dir3D15[0], 'Dir3D15[0] is Assigned');
  CheckEquals(0, Dir3D15[0].GLen, 'Dir3D15[0] Geometrische Länge');
  CheckEquals(0, Dir3D15[0].MLen, 'Dir3D15[0] Maximale Länge');
  for i := 1 to high(Dir3D15) do
  begin
    CheckNotNull(Dir3D15[i], 'Dir3D15[' + IntToStr(i) + '] is Assigned');
    CheckEquals(abs(Dir3D15[i].x) + abs(Dir3D15[i].y) + abs(Dir3D15[i].z),
      Dir3D15[i].GLen, 'Dir3D15[' + IntToStr(i) + '] Geometrische Länge');
    CheckEquals(1, Dir3D15[i].MLen, 'Dir3D15[' + IntToStr(i) + ']Maximale Länge');
    for j := i + 1 to high(Dir3D15) do
      CheckFalse(Dir3D15[i].Equals(dir3d15[j]), 'Dir3D15[' + IntToStr(i) +
        '] <> Dir3D15[' + IntToStr(j) + ']');
  end;

end;

procedure TTestf3dPoint.TestDir3d22;

var
  i: integer;
  j: integer;
begin
  CheckNotNull(Dir3D22[0], 'Dir3D22[0] is Assigned');
  CheckEquals(0, Dir3D22[0].GLen, 'Dir3D22[0] Geometrische Länge');
  CheckEquals(0, Dir3D22[0].MLen, 'Dir3D22[0] Maximale Länge');
  for i := 1 to high(Dir3D22) do
  begin
    CheckNotNull(Dir3D22[i], 'Dir3D22[' + IntToStr(i) + '] is Assigned');
    CheckEquals(abs(Dir3D22[i].x) + abs(Dir3D22[i].y) + abs(Dir3D22[i].z),
      Dir3D22[i].GLen, 'Dir3D22[' + IntToStr(i) + '] Geometrische Länge');
    CheckEquals(2, Dir3D22[i].MLen, 'Dir3D22[' + IntToStr(i) + ']Maximale Länge');
    for j := i + 1 to high(Dir3D22) do
      CheckFalse(Dir3D22[i].Equals(dir3d22[j]), 'Dir3D22[' + IntToStr(i) +
        '] <> Dir3D22[' + IntToStr(j) + ']');
  end;
end;

procedure TTestf3dPoint.TestToString;
begin
  CheckEquals('',FZero.ToString,'FZero.ToString');
end;

procedure TTestf3dPoint.TestAdd;
var
  LTest: T3DPointf;
  i: integer;
begin
  CheckNotNull(Dir3D1[0], 'Dir3D1[0] is Assigned');
  CheckEquals(0, Dir3D1[0].GLen, 'Dir3D1[0] Geometrische Länge');
  CheckEquals(0, Dir3D1[0].MLen, 'Dir3D1[0] Maximale Länge');
  LTest := FZero.copy;
  try
    CheckEquals(0, LTest.GLen, '|LTest| = 0');
    CheckNotEquals(Ltest.GetHashCode, Fzero.GetHashCode, 'Obj differs');
    Checktrue(FZero.Equals(LTest), 'Ltest = FZero');
    //---------------
    CheckEquals(3, Ltest.add(Dir3D15[high(Dir3D15) - 1]).GLen, 'Summe ');
    CheckEquals(0, Ltest.copy(nil).GLen, 'Copy(nil); 0');
    for i := 1 to high(Dir3D1) do
    begin
      Ltest.add(Dir3D1[i]);
      if i = high(Dir3D1) then
        Checktrue(FZero.Equals(LTest), 'Ltest = FZero')
      else
      begin
        CheckEquals(1, LTest.MLen, '|LTest| = 1');
        Checkfalse(FZero.Equals(LTest), 'Ltest <> FZero');
      end;
    end;
    CheckEquals(0, Ltest.copy(nil).GLen, 'Copy(nil); 0');
    for i := 1 to high(Dir3D15) do
    begin
      Ltest.add(Dir3D15[i]);
      if (i = high(Dir3D15)) or (i = 8) then
        Checktrue(FZero.Equals(LTest), IntToStr(i) + ' Ltest = FZero')
      else
      begin
        Checkfalse(FZero.Equals(LTest), IntToStr(i) + ' Ltest <> FZero');
      end;
    end;
    CheckEquals(0, Ltest.copy(nil).GLen, 'Copy(nil); 0');
    for i := 1 to high(Dir3D22) do
    begin
      Ltest.add(Dir3D22[i]);
      if (i = high(Dir3D22)) or (i = 12) or (i = 36) then
        Checktrue(FZero.Equals(LTest), IntToStr(i) + ' Ltest = FZero')
      else
      begin
        Checkfalse(FZero.Equals(LTest), IntToStr(i) + ' Ltest <> FZero');
      end;
    end;

  finally
    FreeAndNil(Ltest);
  end;
end;

procedure TTestf3dPoint.TestNeg;
var
  LTest: T3DPointf;
  LTest2: T3DPointf;
  og: Extended;
  om: Extended;
  i: integer;
begin
  CheckNotNull(Dir3D1[0], 'Dir3D1[0] is Assigned');
  CheckEquals(0, Dir3D1[0].GLen, 'Dir3D1[0] Geometrische Länge');
  CheckEquals(0, Dir3D1[0].MLen, 'Dir3D1[0] Maximale Länge');
  LTest := FZero.copy;
  LTest2 := FZero.copy;
  try
    og := Ltest.add(Dir3D22[35]).GLen;
    om := LTest.MLen;
    CheckEquals(og, LTest.SMult(-1).GLen,0.001, 'Negativer vector hat selbe Länge (G)');
    CheckEquals(om, LTest.MLen,0.001, 'Negativer vector hat selbe Länge (M)');
    CheckNotEquals(0, LTest.GLen,0.001, 'Negativer vector hat Länge >0 ');
    CheckEquals(0, Ltest.add(Dir3D22[35]).GLen, ' v-v=0');

    for i := 1 to high(Dir3D22) do
    begin
      og := Ltest.copy(Dir3D22[i]).GLen;
      om := LTest.MLen;
      CheckEquals(og, LTest.SMult(-1).GLen,0.001, intToStr(i) + ' Negativer vector hat selbe Länge (G)');
      CheckEquals(om, LTest.MLen,0.001, intToStr(i) + ' Negativer vector hat selbe Länge (M)');
      CheckNotEquals(0, LTest.GLen,0.001, intToStr(i) + ' Negativer vector hat Länge >0 ');
      CheckEquals(0, Ltest.add(Dir3D22[i]).GLen,0.001, intToStr(i) + ' v-v=0');
    end;

    for i := 0 to 10000 do
    begin
      LTest2.copy(Random(int64(MaxInt)*2-1)-maxint+1,Random(int64(MaxInt)*2-1)-maxint+1,Random(int64(MaxInt)*2-1)-maxint+1);
      og := Ltest.copy(LTest2).GLen;
      om := LTest.MLen;
      CheckEquals(og, LTest.SMult(-1).GLen,0.001, 'Random'+intToStr(i) + ' Negativer vector hat selbe Länge (G)');
      CheckEquals(om, LTest.MLen,0.001, 'Random'+intToStr(i) + ' Negativer vector hat selbe Länge (M)');
      CheckNotEquals(0, LTest.GLen,0.001, 'Random'+intToStr(i) + ' Negativer vector hat Länge >0 ');
      CheckEquals(0, Ltest.add(LTest2).GLen,0.001, 'Random'+intToStr(i) + ' v-v=0');
    end;

  finally
    FreeAndNil(Ltest);
    FreeAndNil(Ltest2);
  end;
end;

procedure TTestf3dPoint.TestSmult;
begin
  // ToDo -oJC:
end;

procedure TTestf3dPoint.TestGetDirNo;
var
  i: Integer;
begin
  for i := 0 to high(Dir3D15) do
    CheckEquals(i,getDirNo(Dir3D15[i]),'GetDir(Dir3D15['+inttostr(i)+']) = i');
  for i := 0 to high(Dir3D22) do
    CheckEquals(i,getDirNo(Dir3D22[i]),'GetDir(Dir3D22['+inttostr(i)+']) = i');
end;

procedure TTestf3dPoint.SetUp;
begin
  FZero := T3DPointf.create(nil);
end;

procedure TTestf3dPoint.TearDown;
begin
  FZero.Free;
  FZero := nil;
end;

initialization

  RegisterTest('Test Point3D', TTestf3dPoint{$IFNDEF FPC}.suite
{$ENDIF ~FPC}    );
end.
