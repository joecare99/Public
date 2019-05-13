unit tst_RenderMath;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry;

type

  { TTestSolveCQGl }

  TTestSolveCQGl= class(TTestCase)
  protected
  published
    procedure TestSetUp;
    Procedure TestQuadraticSolvable;
    Procedure TestQuadraticUnSolvable;
  end;

implementation

uses unt_RenderMath;

procedure TTestSolveCQGl.TestSetUp;
begin
 // Fail('Write your own test');
end;

procedure TTestSolveCQGl.TestQuadraticSolvable;
var
  l1, l2, lx1, lx2: extended;
  i: Integer;
const  cEps=1e-13;
begin
  checktrue(SolveQuadratic(1,0,-1,l1,l2),'Expected to be solvable');
  CheckEquals(-1.0,l1,cEps,'First Expeted Soliution');
  CheckEquals(1.0,l2,cEps,'Second Expeted Soliution');
  checktrue(SolveQuadratic(2,0,-2,l1,l2),'Expected to be solvable 2');
  CheckEquals(-1.0,l1,cEps,'First Expeted Soliution2');
  CheckEquals(1.0,l2,cEps,'Second Expeted Soliution2');
  checktrue(SolveQuadratic(1,-2,0,l1,l2),'Expected to be solvable 3');
  CheckEquals(-0.0,l1,cEps,'First Expeted Soliution3');
  CheckEquals(2.0,l2,cEps,'Second Expeted Soliution3');
  lx1:=(random -0.5)*maxint;
  lx2:=(random -0.5)*maxint;
  if lx1>lx2 then
    begin
      l1:=lx1;
      lx1:=lx2;
      lx2:=l1;
    end;
  checktrue(SolveQuadratic(1,-lx1-lx2,lx1*lx2,l1,l2),'Expected to be solvable[0]');
  CheckEquals(lx1,l1,cEps*trunc(abs(lx1)),'First Expeted Soliution[0]');
  CheckEquals(Lx2,l2,cEps*trunc(abs(lx2)),'Second Expeted Soliution[0]');
  for i := 0 to 100000 do
    begin
      lx1:=(random -0.5)*20;
      lx2:=(random -0.5)*20;
      if lx1>lx2 then
        begin
          l1:=lx1;
          lx1:=lx2;
          lx2:=l1;
        end;
      checktrue(SolveQuadratic(1,-lx1-lx2,lx1*lx2,l1,l2),'Expected to be solvable['+inttostr(i)+']');
      CheckEquals(lx1,l1,cEps*1000,'First Expeted Soliution['+inttostr(i)+']');
      CheckEquals(Lx2,l2,cEps*1000,'Second Expeted Soliution['+inttostr(i)+']');
    end;
end;

procedure TTestSolveCQGl.TestQuadraticUnSolvable;
var
  l1, l2, lx1, lx2: extended;
  i: Integer;
const  cEps=1e-13;
begin
  CheckFalse(SolveQuadratic(1,0,1,l1,l2),'Expected to be not solvable');
  CheckFalse(SolveQuadratic(2,0,2,l1,l2),'Expected to be not solvable 2');
  checkFalse(SolveQuadratic(1,-2,2,l1,l2),'Expected to be not solvable 3');
  lx1:=(random -0.5)*maxint;
  lx2:=(random -0.5)*maxint;
  if lx1>lx2 then
    begin
      l1:=lx1;
      lx1:=lx2;
      lx2:=l1;
    end;
  checkfalse(SolveQuadratic(1,-lx1-lx2,0.25*sqr(lx1)+0.5*lx2*lx1+0.25*sqr(lx2)+1e+4,l1,l2),'Expected to be not solvable[0]');
  for i := 0 to 100000 do
    begin
      lx1:=(random -0.5)*20;
      lx2:=(random -0.5)*20;
      if lx1>lx2 then
        begin
          l1:=lx1;
          lx1:=lx2;
          lx2:=l1;
        end;
      checkfalse(SolveQuadratic(1,-lx1-lx2,0.25*sqr(lx1)+0.5*lx2*lx1+0.25*sqr(lx2)+1e-6,l1,l2),'Expected to be solvable['+inttostr(i)+']');
    end;
end;

initialization

  RegisterTest(TTestSolveCQGl);
end.

