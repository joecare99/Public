unit tst_RenderBaseAngle;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,cls_RenderBase;

type

  { TTestAngle }

  TTestAngle= class(TTestCase)
  Private
    FAngle:TAngle;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    procedure CheckEquals(const Exp, Act: TAngle; eps: extended; Msg: String);
      overload;

  published
    procedure TestSetUp;
    PRocedure TestNormalize;
  end;

implementation

procedure TTestAngle.SetUp;
begin
  FAngle.value := 0.0;
end;

procedure TTestAngle.TearDown;
begin

end;

procedure TTestAngle.CheckEquals(const Exp, Act: TAngle; eps: extended;
  Msg: String);
begin
   CheckEquals(exp.value,act.value,eps,Msg);
end;

procedure TTestAngle.TestSetUp;
begin
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');
end;

procedure TTestAngle.TestNormalize;
begin
// Test Some Well known Values
  CheckEquals(Angle(0.0),FAngle.Normalize(Angle(0.0)),1e-15,'Startwinkel ist 0°');
  CheckEquals(Angle(0.5*pi),FAngle.Normalize(Angle(0.5*pi)),1e-15,'Normalize  90°');
  CheckEquals(Angle(-0.5*pi),FAngle.Normalize(Angle(-0.5*pi)),1e-15,'Normalize  -90°');
  CheckEquals(Angle(0.9*pi),FAngle.Normalize(Angle(0.9*pi)),1e-15,'Normalize  -160°');
  CheckEquals(Angle(-0.9*pi),FAngle.Normalize(Angle(-0.9*pi)),1e-15,'Normalize  -160°');
  CheckEquals(Angle(-1.0*pi),FAngle.Normalize(Angle(pi)),1e-15,'Normalize  180°');
  CheckEquals(Angle(-1.0*pi),FAngle.Normalize(Angle(-pi)),1e-15,'Normalize  -180°');
  CheckEquals(Angle(-0.5*pi),FAngle.Normalize(Angle(1.5*pi)),1e-15,'Normalize  180°');
  CheckEquals(Angle(0.5*pi),FAngle.Normalize(Angle(-1.5*pi)),1e-15,'Normalize  -180°');
  CheckEquals(Angle(0.0),FAngle.Normalize(Angle(2.0*pi)),1e-15,'Normalize  180°');
  CheckEquals(Angle(0.0),FAngle.Normalize(Angle(-2.0*pi)),1e-15,'Normalize  -180°');
  CheckEquals(Angle(0.5*pi),FAngle.Normalize(Angle(2.5*pi)),1e-15,'Normalize  180°');
  CheckEquals(Angle(-0.5*pi),FAngle.Normalize(Angle(-2.5*pi)),1e-15,'Normalize  -180°');

end;


initialization

  RegisterTest(TTestAngle);
end.

