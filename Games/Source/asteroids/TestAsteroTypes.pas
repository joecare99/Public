unit TestAsteroTypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, uTypes;

type

  { TTestAstypes }

  TTestAstypes= class(TTestCase)
  private
    Procedure CheckEqualsFPnt(Exp,Act:TFloatPoint;Delta:Extended;Message:String);
  published
    procedure FPointAngle;
    procedure TestHookUp;
  end;

implementation

const Eps=1e-7;

procedure TTestAstypes.CheckEqualsFPnt(Exp, Act: TFloatPoint; Delta: Extended;
  Message: String);
begin
  CheckEquals(exp.x,act.x,Delta,Message+'(X)');
  CheckEquals(exp.y,act.y,Delta,Message+'(Y)');
end;

procedure TTestAstypes.FPointAngle;
begin
  // Test Well Known Angles
  CheckEquals(0.0,ZeroPnt.Angle,'Null-Winkel');
  CheckEquals(0.0,PointSingle(1.0,0.0).Angle,Eps,'0°-Winkel');
  CheckEquals(pi/6,PointSingle(sqrt(0.75),0.5).Angle ,Eps,'30°-Winkel');
  CheckEquals(pi/4,PointSingle(0.5,0.5).Angle,Eps ,'45°-Winkel');
  CheckEquals(pi/3,PointSingle(0.5,sqrt(0.75)).Angle ,Eps,'60°-Winkel');
  CheckEquals(pi/2,PointSingle(0.0,1.0).Angle,Eps,'90°-Winkel');
  CheckEquals(2*pi/3,PointSingle(-0.5,sqrt(0.75)).Angle ,Eps,'120°-Winkel');
  CheckEquals(3*pi/4,PointSingle(-0.5,0.5).Angle,Eps ,'135°-Winkel');
  CheckEquals(5*pi/6,PointSingle(-sqrt(0.75),0.5).Angle ,Eps,'150°-Winkel');
  CheckEquals(pi,PointSingle(-1.0,0.0).Angle,Eps,'180°-Winkel');
  CheckEquals(-5*pi/6,PointSingle(-sqrt(0.75),-0.5).Angle ,Eps,'210°-Winkel');
  CheckEquals(-3*pi/4,PointSingle(-0.5,-0.5).Angle,Eps ,'225°-Winkel');
  CheckEquals(-2*pi/3,PointSingle(-0.5,-sqrt(0.75)).Angle ,Eps,'240°-Winkel');
  CheckEquals(-pi/2,PointSingle(0.0,-1.0).Angle,Eps,'270°-Winkel');
  CheckEquals(-pi/3,PointSingle(0.5,-sqrt(0.75)).Angle ,Eps,'300°-Winkel');
  CheckEquals(-pi/4,PointSingle(0.5,-0.5).Angle,Eps ,'315°-Winkel');
  CheckEquals(-pi/6,PointSingle(sqrt(0.75),-0.5).Angle ,Eps,'330°-Winkel');
end;

procedure TTestAstypes.TestHookUp;
begin
 // Fail('Write your own test');
end;



initialization

  RegisterTest(TTestAstypes);
end.

