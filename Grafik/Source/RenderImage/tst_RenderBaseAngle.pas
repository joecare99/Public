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
    PRocedure TestNormalize2;
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
var
  ldir, lmult: Extended;
  I: Integer;
begin
// Test Some Well known Values
  CheckEquals(Angle(0.0),FAngle.Normalize(Angle(0.0)),1e-15,'Startwinkel ist 0°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');
  CheckEquals(Angle(0.5*pi),FAngle.Normalize(Angle(0.5*pi)),1e-15,'Normalize  90°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');
  CheckEquals(Angle(-0.5*pi),FAngle.Normalize(Angle(-0.5*pi)),1e-15,'Normalize  -90°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');
  CheckEquals(Angle(0.9*pi),FAngle.Normalize(Angle(0.9*pi)),1e-15,'Normalize  -160°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');
  CheckEquals(Angle(-0.9*pi),FAngle.Normalize(Angle(-0.9*pi)),1e-15,'Normalize  -160°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');
  CheckEquals(Angle(-1.0*pi),FAngle.Normalize(Angle(pi)),1e-15,'Normalize  180°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');
  CheckEquals(Angle(-1.0*pi),FAngle.Normalize(Angle(-pi)),1e-15,'Normalize  -180°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');
  CheckEquals(Angle(-0.5*pi),FAngle.Normalize(Angle(1.5*pi)),1e-15,'Normalize  180°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');
  CheckEquals(Angle(0.5*pi),FAngle.Normalize(Angle(-1.5*pi)),1e-15,'Normalize  -180°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');
  CheckEquals(Angle(0.0),FAngle.Normalize(Angle(2.0*pi)),1e-15,'Normalize  180°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');
  CheckEquals(Angle(0.0),FAngle.Normalize(Angle(-2.0*pi)),1e-15,'Normalize  -180°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');
  CheckEquals(Angle(0.5*pi),FAngle.Normalize(Angle(2.5*pi)),1e-15,'Normalize  180°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');
  CheckEquals(Angle(-0.5*pi),FAngle.Normalize(Angle(-2.5*pi)),1e-15,'Normalize  -180°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');
  // Test Lot of Random Values
  for I := 0 to 50000 do
     begin
        ldir := (random -0.5)* pi*2;
        lmult := ldir+ (random(Maxint)-maxint div 2)*pi*2;
        CheckEquals(Angle(ldir),FAngle.Normalize(angle(lmult)),5e-7,format('Normalize %f',[lmult]));
        CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');
     end;
end;

procedure TTestAngle.TestNormalize2;
var
  ldir, lmult: Extended;
  I: Integer;
begin
// Test Some Well known Values
  FAngle := Angle(0.0);
  CheckEquals(Angle(0.0),FAngle.Normalize,1e-15,'Startwinkel ist 0°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');

  FAngle := Angle(0.5*pi);
 CheckEquals(Angle(0.5*pi),FAngle.Normalize,1e-15,'Normalize  90°');
 CheckEquals(Angle(0.5*pi),FAngle,1e-15,'Still Normalize  90°');
  FAngle := Angle(-0.5*pi);
 CheckEquals(Angle(-0.5*pi),FAngle.Normalize,1e-15,'Normalize  -90°');
 CheckEquals(Angle(-0.5*pi),FAngle,1e-15,'Still Normalize  -90°');
  FAngle := Angle(0.9*pi);
 CheckEquals(Angle(0.9*pi),FAngle.Normalize,1e-15,'Normalize  -160°');
 CheckEquals(Angle(0.9*pi),FAngle,1e-15,'Still Normalize  -160°');
  FAngle := Angle(-0.9*pi);
 CheckEquals(Angle(-0.9*pi),FAngle.Normalize,1e-15,'Normalize  -160°');
 CheckEquals(Angle(-0.9*pi),FAngle,1e-15,'Still Normalize  -160°');
  FAngle := Angle(pi);
 CheckEquals(Angle(-1.0*pi),FAngle.Normalize,1e-15,'Normalize  180°');
 CheckEquals(Angle(-1.0*pi),FAngle,1e-15,'Still Normalize  180°');
  FAngle := Angle(-pi);
 CheckEquals(Angle(-1.0*pi),FAngle.Normalize,1e-15,'Normalize  -180°');
 CheckEquals(Angle(-1.0*pi),FAngle,1e-15,'Still Normalize  -180°');
  FAngle := Angle(1.5*pi);
 CheckEquals(Angle(-0.5*pi),FAngle.Normalize,1e-15,'Normalize  180°');
 CheckEquals(Angle(-0.5*pi),FAngle,1e-15,'Still Normalize  180°');
  FAngle := Angle(-1.5*pi);
 CheckEquals(Angle(0.5*pi),FAngle.Normalize,1e-15,'Normalize  -180°');
 CheckEquals(Angle(0.5*pi),FAngle,1e-15,'Still Normalize  -180°');
  FAngle := Angle(2.0*pi);
 CheckEquals(Angle(0.0),FAngle.Normalize,1e-15,'Normalize  180°');
 CheckEquals(Angle(0.0),FAngle,1e-15,'Still Normalize  180°');
  FAngle := Angle(-2.0*pi);
 CheckEquals(Angle(0.0),FAngle.Normalize,1e-15,'Normalize  -180°');
 CheckEquals(Angle(0.0),FAngle,1e-15,'Still Normalize  -180°');
  FAngle := Angle(2.5*pi);
 CheckEquals(Angle(0.5*pi),FAngle.Normalize,1e-15,'Normalize  180°');
 CheckEquals(Angle(0.5*pi),FAngle,1e-15,'Still Normalize  180°');
  FAngle := Angle(-2.5*pi);
 CheckEquals(Angle(-0.5*pi),FAngle.Normalize,1e-15,'Normalize  -180°');
 CheckEquals(Angle(-0.5*pi),FAngle,1e-15,'Still Normalize  -180°');
 // Test Lot of Random Values
  for I := 0 to 50000 do
     begin
        ldir := (random -0.5)* pi*2;
        lmult := ldir+ (random(Maxint)-maxint div 2)*pi*2;
        FAngle := angle(lmult);
        CheckEquals(Angle(ldir),FAngle.Normalize,5e-7,format('Normalize %f',[lmult]));
        CheckEquals(Angle(ldir),FAngle,5e-7,format('Still Normalize %f',[ldir]));
     end;
end;


initialization

  RegisterTest(TTestAngle);
end.

