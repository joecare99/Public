unit testcase2dPoint;

{$IFDEF FPC}
  {$MODE Delphi}{$H+}
{$ENDIF}
{ $Author$ : Joe Care }
/// <Author>Joe Care</Author>

interface

uses
  Classes, SysUtils, {$IFDEF FPC}fpcunit, testregistry,{$Else}testframework,
 {$ENDIF}unt_Point2d;

type

  { TTest2dPoint }

  TTest2dPoint = class(TTestCase)
  private
    FZero: T2DPoint;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetup;
    procedure TestDir4;
    procedure TestDir8;
    procedure TestDir12;
    procedure TestAdd;
    procedure TestAdd2;
    procedure TestSubtr;
    procedure TestSubtr2;
    procedure TestNegate;
    procedure TestSmult;
    procedure TestGetDirNo;
  end;

implementation

procedure TTest2dPoint.TestSetup;
begin
  CheckNotNull(FZero, 'FZero is Assigned');
  CheckEquals('T2DPoint<0,0>', FZero.ToString, 'FZero.ToString');
  CheckTrue(Fzero.Equals(dir4[0]), 'FZero = dir4[0]');
  CheckFalse(Fzero.Equals(dir4[1]), 'FZero <> dir4[1]');
end;

procedure TTest2dPoint.TestDir4;
var
  i: integer;
  j: integer;
begin
  CheckNotNull(Dir4[0], 'Dir4[0] is Assigned');
  CheckEquals(0, Dir4[0].GLen, 'Dir4[0] Geometrische Länge');
  CheckEquals(0, Dir4[0].MLen, 'Dir4[0] Maximale Länge');
  for i := 1 to high(Dir4) do
  begin
    CheckNotNull(Dir4[i], 'Dir4[' + IntToStr(i) + '] is Assigned');
    CheckEquals(1.0, Dir4[i].Len,1e-7, 'Dir4[' + IntToStr(i) + '] Arithmetische Länge');
    CheckEquals(1, Dir4[i].GLen, 'Dir4[' + IntToStr(i) + '] Geometrische Länge');
    CheckEquals(1, Dir4[i].MLen, 'Dir4[' + IntToStr(i) + ']Maximale Länge');
    for j := i + 1 to high(Dir4) do
      CheckFalse(Dir4[i].Equals(dir4[j]), 'Dir4[' + IntToStr(i) + '] <> Dir4[' + IntToStr(j) + ']');
  end;
end;

procedure TTest2dPoint.TestDir8;
var
  i: integer;
  j: integer;
begin
  CheckNotNull(Dir8[0], 'Dir8[0] is Assigned');
  CheckEquals(0, Dir8[0].GLen, 'Dir8[0] Geometrische Länge');
  CheckEquals(0, Dir8[0].MLen, 'Dir8[0] Maximale Länge');
  for i := 1 to high(Dir8) do
  begin
    CheckNotNull(Dir8[i], 'Dir8[' + IntToStr(i) + '] is Assigned');
    CheckEquals(abs(Dir8[i].x) + abs(Dir8[i].y) ,
      Dir8[i].GLen, 'Dir8[' + IntToStr(i) + '] Geometrische Länge');
    CheckEquals(1, Dir8[i].MLen, 'Dir8[' + IntToStr(i) + ']Maximale Länge');
    for j := i + 1 to high(Dir8) do
      CheckFalse(Dir8[i].Equals(dir8[j]), 'Dir8[' + IntToStr(i) +
        '] <> Dir8[' + IntToStr(j) + ']');
  end;

end;

procedure TTest2dPoint.TestDir12;

var
  i: integer;
  j: integer;
begin
  CheckNotNull(Dir12[0], 'Dir12[0] is Assigned');
  CheckEquals(0, Dir12[0].GLen, 'Dir12[0] Geometrische Länge');
  CheckEquals(0, Dir12[0].MLen, 'Dir12[0] Maximale Länge');
  for i := 1 to high(Dir12) do
  begin
    CheckNotNull(Dir12[i], 'Dir12[' + IntToStr(i) + '] is Assigned');
    CheckEquals(abs(Dir12[i].x) + abs(Dir12[i].y),
      Dir12[i].GLen, 'Dir12[' + IntToStr(i) + '] Geometrische Länge');
    CheckEquals(2, Dir12[i].MLen, 'Dir12[' + IntToStr(i) + ']Maximale Länge');
    for j := i + 1 to high(Dir12) do
      CheckFalse(Dir12[i].Equals(dir12[j]), 'Dir12[' + IntToStr(i) +
        '] <> Dir12[' + IntToStr(j) + ']');
  end;
end;

procedure TTest2dPoint.TestAdd;
var
  LTest: T2DPoint;
  i: integer;
begin
  CheckNotNull(Dir4[0], 'Dir4[0] is Assigned');
  CheckEquals(0, Dir4[0].GLen, 'Dir4[0] Geometrische Länge');
  CheckEquals(0, Dir4[0].MLen, 'Dir4[0] Maximale Länge');
  LTest := FZero.copy;
  try
    CheckEquals(0, LTest.GLen, '|LTest| = 0');
    CheckNotEquals(Ltest.GetHashCode, Fzero.GetHashCode, 'Obj differs');
    Checktrue(FZero.Equals(LTest), 'Ltest = FZero');
    //---------------
    CheckEquals(1, Ltest.add(Dir8[high(Dir8) - 1]).GLen, 'Summe ');
    CheckEquals(0, Ltest.copy(nil).GLen, 'Copy(nil); 0');
    for i := 1 to high(Dir4) do
    begin
      Ltest.add(Dir4[i]);
      if i = high(Dir4) then
        Checktrue(FZero.Equals(LTest), 'Ltest = FZero')
      else
      begin
        CheckEquals(1, LTest.MLen, '|LTest| = 1');
        Checkfalse(FZero.Equals(LTest), 'Ltest <> FZero');
      end;
    end;
    CheckEquals(0, Ltest.copy(nil).GLen, 'Copy(nil); 0');
    for i := 1 to high(Dir8) do
    begin
      Ltest.add(Dir8[i]);
      if (i = high(Dir8)) or (i = 8) then
        Checktrue(FZero.Equals(LTest), IntToStr(i) + ' Ltest = FZero')
      else
      begin
        Checkfalse(FZero.Equals(LTest), IntToStr(i) + ' Ltest <> FZero');
      end;
    end;
    CheckEquals(0, Ltest.copy(nil).GLen, 'Copy(nil); 0');
    for i := 1 to high(Dir12) do
    begin
      Ltest.add(Dir12[i]);
      if (i = high(Dir12)) or (i = 12) or (i = 36) then
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

procedure TTest2dPoint.TestAdd2;
begin

end;

procedure TTest2dPoint.TestSubtr;
begin

end;

procedure TTest2dPoint.TestSubtr2;
begin

end;

procedure TTest2dPoint.TestNegate;

var
  LTest: T2DPoint;
  LTest2: T2DPoint;
  og: longint;
  om: longint;
  i: integer;
begin
  CheckNotNull(Dir4[0], 'Dir4[0] is Assigned');
  CheckEquals(0, Dir4[0].GLen, 'Dir4[0] Geometrische Länge');
  CheckEquals(0, Dir4[0].MLen, 'Dir4[0] Maximale Länge');
  LTest := FZero.copy;
  LTest2 := FZero.copy;
  try
    og := Ltest.add(Dir12[11]).GLen;
    om := LTest.MLen;
    CheckEquals(og, LTest.SMult(-1).GLen, 'Negativer vector hat selbe Länge (G)');
    CheckEquals(om, LTest.MLen, 'Negativer vector hat selbe Länge (M)');
    CheckNotEquals(0, LTest.GLen, 'Negativer vector hat Länge >0 ');
    CheckEquals(0, Ltest.add(Dir12[11]).GLen, ' v-v=0');

    for i := 1 to high(Dir12) do
    begin
      og := Ltest.copy(Dir12[i]).GLen;
      om := LTest.MLen;
      CheckEquals(og, LTest.SMult(-1).GLen, IntToStr(i) + ' Negativer vector hat selbe Länge (G)');
      CheckEquals(om, LTest.MLen, IntToStr(i) + ' Negativer vector hat selbe Länge (M)');
      CheckNotEquals(0, LTest.GLen, IntToStr(i) + ' Negativer vector hat Länge >0 ');
      CheckEquals(0, Ltest.add(Dir12[i]).GLen, IntToStr(i) + ' v-v=0');
    end;

    for i := 0 to 10000 do
    begin
      LTest2.copy(Random(int64(MaxInt)*2-1)-maxint+1,Random(int64(MaxInt)*2-1)-maxint+1);
      og := Ltest.copy(LTest2).GLen;
      om := LTest.MLen;
      CheckEquals(og, LTest.SMult(-1).GLen, 'Random'+IntToStr(i) + ' Negativer vector hat selbe Länge (G)');
      CheckEquals(om, LTest.MLen, 'Random'+IntToStr(i) + ' Negativer vector hat selbe Länge (M)');
      CheckNotEquals(0, LTest.GLen, 'Random'+IntToStr(i) + ' Negativer vector hat Länge >0 ');
      CheckEquals(0, Ltest.add(LTest2).GLen, 'Random'+IntToStr(i) + ' v-v=0');
    end;

  finally
    FreeAndNil(Ltest);
    FreeAndNil(Ltest2);
  end;
end;

procedure TTest2dPoint.TestSmult;
begin
  // ToDo -oJC:
end;

procedure TTest2dPoint.TestGetDirNo;
var
  i: Integer;
begin
  for i := 0 to high(Dir8) do
    CheckEquals(i,getDirNo(Dir8[i]),'GetDir(Dir8['+inttostr(i)+']) = i');
  for i := 0 to high(Dir12) do
    CheckEquals(i,getDirNo(Dir12[i]),'GetDir(Dir12['+inttostr(i)+']) = i');
end;

procedure TTest2dPoint.SetUp;
begin
  FZero := T2DPoint.init(nil);
end;

procedure TTest2dPoint.TearDown;
begin
  FZero.Free;
  FZero := nil;
end;

initialization

  RegisterTest('Test Point3D', TTest2dPoint{$IFNDEF FPC}.suite
{$ENDIF ~FPC}    );
end.
