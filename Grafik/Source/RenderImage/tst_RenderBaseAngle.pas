unit tst_RenderBaseAngle;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils{$IFDEF FPC} , fpcunit, testregistry {$ELSE} , testframework {$ENDIF},cls_RenderBase;

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
    Procedure TestSum;
    Procedure TestAdd;
    Procedure TestDiff;
    Procedure TestSubt;
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

procedure TTestAngle.TestSum;
var
  ldir2, ldir, lmult, lmult2: Extended;
  I: Integer;
begin
  //Well Known Values (Without Overflow)
  FAngle := Angle(0.0);
  CheckEquals(Angle(0.0),FAngle.Sum(ZeroAngle),1e-15,'Summe 0° + 0°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');

  FAngle := Angle(0.1);
  CheckEquals(Angle(0.1),FAngle.Sum(ZeroAngle),1e-15,'Summe 0.1r + 0°');
  CheckEquals(Angle(0.1),FAngle,1e-15,'Startwinkel ist 0.1r');

  FAngle := Angle(0.1);
  CheckEquals(Angle(0.2),FAngle.Sum(Angle(0.1)),1e-15,'Summe 0.1r + 0.1r');
  CheckEquals(Angle(0.1),FAngle,1e-15,'Startwinkel ist 0.1r');

  FAngle := Angle(0.1);
  CheckEquals(Angle(0.0),FAngle.Sum(Angle(-0.1)),1e-15,'Summe 0.1r + (-0.1r)');
  CheckEquals(Angle(0.1),FAngle,1e-15,'Startwinkel ist 0.1r');

  //Well Known Values with(Single overflow)
  FAngle := Angle(2*pi);
  CheckEquals(Angle(0.0),FAngle.Sum(ZeroAngle),1e-15,'Summe 0° + 0°');
  CheckEquals(Angle(2*pi),FAngle,1e-15,'Startwinkel ist 2pi°');

  FAngle := Angle(-2*pi+0.1);
  CheckEquals(Angle(0.1),FAngle.Sum(ZeroAngle),1e-15,'Summe 0.1r + 0°');
  CheckEquals(Angle(-2*pi+0.1),FAngle,1e-15,'Startwinkel ist -2pi+0.1r');

  FAngle := Angle(2*pi+0.1);
  CheckEquals(Angle(0.2),FAngle.Sum(Angle(0.1)),1e-15,'Summe 0.1r + 0.1r');
  CheckEquals(Angle(2*pi+0.1),FAngle,1e-15,'Startwinkel ist 2pi+0.1r');

  FAngle := Angle(-2*pi+0.1);
  CheckEquals(Angle(0.0),FAngle.Sum(Angle(-0.1)),1e-15,'Summe 0.1r + (-0.1r)');
  CheckEquals(Angle(-2*pi+0.1),FAngle,1e-15,'Startwinkel ist -2pi+0.1r');

  FAngle := Angle(0.1);
  CheckEquals(Angle(0.2),FAngle.Sum(Angle(2*pi+0.1)),1e-15,'Summe 0.1r + 0.1r');
  CheckEquals(Angle(0.1),FAngle,1e-15,'Startwinkel ist 0.1r');

  FAngle := Angle(+0.1);
  CheckEquals(Angle(0.0),FAngle.Sum(Angle(2*pi-0.1)),1e-15,'Summe 0.1r + (-0.1r)');
  CheckEquals(Angle(0.1),FAngle,1e-15,'Startwinkel ist 0.1r');

  // Test Lot of Random Values
   for I := 0 to 50000 do
      begin
         ldir := (random -0.5)* pi*2;
         lmult := ldir+ (random(256)-128)*pi*2;
         ldir2 := (random -0.5)* pi*2;
         lmult2 := ldir2+ (random(256)-128)*pi*2;
         FAngle := angle(lmult);
         CheckEquals(Angle(ldir+ldir2).Normalize,FAngle.sum(Angle(lMult2)),5e-13,format('Sum %f + %f',[lmult,lmult2]));
         CheckEquals(Angle(lmult),FAngle,5e-15,format('Still  %f',[ldir]));
      end;

end;

procedure TTestAngle.TestAdd;
var
  ldir2, ldir, lmult, lmult2: Extended;
  I: Integer;
begin
  //Well Known Values (Without Overflow)
  FAngle := Angle(0.0);
  CheckEquals(Angle(0.0),FAngle.Add(ZeroAngle),1e-15,'Summe 0° + 0°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');

  FAngle := Angle(0.1);
  CheckEquals(Angle(0.1),FAngle.Add(ZeroAngle),1e-15,'Summe 0.1r + 0°');
  CheckEquals(Angle(0.1),FAngle,1e-15,'Startwinkel ist 0.1r');

  FAngle := Angle(0.1);
  CheckEquals(Angle(0.2),FAngle.Add(Angle(0.1)),1e-15,'Summe 0.1r + 0.1r');
  CheckEquals(Angle(0.2),FAngle,1e-15,'Startwinkel ist 0.1r');

  FAngle := Angle(0.1);
  CheckEquals(Angle(0.0),FAngle.Add(Angle(-0.1)),1e-15,'Summe 0.1r + (-0.1r)');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0.1r');

  //Well Known Values with(Single overflow)
  FAngle := Angle(2*pi);
  CheckEquals(Angle(0.0),FAngle.Add(ZeroAngle),1e-15,'Summe 0° + 0°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 2pi°');

  FAngle := Angle(-2*pi+0.1);
  CheckEquals(Angle(0.1),FAngle.Add(ZeroAngle),1e-15,'Summe 0.1r + 0°');
  CheckEquals(Angle(0.1),FAngle,1e-15,'Startwinkel ist -2pi+0.1r');

  FAngle := Angle(2*pi+0.1);
  CheckEquals(Angle(0.2),FAngle.Add(Angle(0.1)),1e-15,'Summe 0.1r + 0.1r');
  CheckEquals(Angle(0.2),FAngle,1e-15,'Startwinkel ist 2pi+0.1r');

  FAngle := Angle(-2*pi+0.1);
  CheckEquals(Angle(0.0),FAngle.Add(Angle(-0.1)),1e-15,'Summe 0.1r + (-0.1r)');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist -2pi+0.1r');

  FAngle := Angle(0.1);
  CheckEquals(Angle(0.2),FAngle.Add(Angle(2*pi+0.1)),1e-15,'Summe 0.1r + 0.1r');
  CheckEquals(Angle(0.2),FAngle,1e-15,'Startwinkel ist 0.1r');

  FAngle := Angle(+0.1);
  CheckEquals(Angle(0.0),FAngle.Add(Angle(2*pi-0.1)),1e-15,'Summe 0.1r + (-0.1r)');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0.1r');

  // Test Lot of Random Values
   for I := 0 to 50000 do
      begin
         ldir := (random -0.5)* pi*2;
         lmult := ldir+ (random(256)-128)*pi*2;
         ldir2 := (random -0.5)* pi*2;
         lmult2 := ldir2+ (random(256)-128)*pi*2;
         FAngle := angle(lmult);
         CheckEquals(Angle(ldir+ldir2).Normalize,FAngle.Add(Angle(lMult2)),5e-13,format('Add %f + %f',[lmult,lmult2]));
         CheckEquals(Angle(ldir+ldir2).Normalize,FAngle,5e-13,format('Still  %f',[ldir+ldir2]));
      end;
end;

procedure TTestAngle.TestDiff;
var
  ldir2, ldir, lmult, lmult2: Extended;
  I: Integer;
begin
  //Well Known Values (Without Overflow)
  FAngle := Angle(0.0);
  CheckEquals(Angle(0.0),FAngle.Diff(ZeroAngle),1e-15,'Differenz 0° - 0°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');

  FAngle := Angle(0.1);
  CheckEquals(Angle(0.1),FAngle.Diff(ZeroAngle),1e-15,'Differenz 0.1r - 0°');
  CheckEquals(Angle(0.1),FAngle,1e-15,'Startwinkel ist 0.1r');

  FAngle := Angle(0.1);
  CheckEquals(Angle(0.2),FAngle.Diff(Angle(-0.1)),1e-15,'Differenz 0.1r - (-0.1r)');
  CheckEquals(Angle(0.1),FAngle,1e-15,'Startwinkel ist 0.1r');

  FAngle := Angle(0.1);
  CheckEquals(Angle(0.0),FAngle.Diff(Angle(0.1)),1e-15,'Differenz 0.1r - 0.1r');
  CheckEquals(Angle(0.1),FAngle,1e-15,'Startwinkel ist 0.1r');

  //Well Known Values with(Single overflow)
  FAngle := Angle(2*pi);
  CheckEquals(Angle(0.0),FAngle.Diff(ZeroAngle),1e-15,'Differenz 0° - 0°');
  CheckEquals(Angle(2*pi),FAngle,1e-15,'Startwinkel ist 2pi°');

  FAngle := Angle(-2*pi+0.1);
  CheckEquals(Angle(0.1),FAngle.Diff(ZeroAngle),1e-15,'Differenz 0.1r - 0°');
  CheckEquals(Angle(-2*pi+0.1),FAngle,1e-15,'Startwinkel ist -2pi+0.1r');

  FAngle := Angle(2*pi+0.1);
  CheckEquals(Angle(0.2),FAngle.Diff(Angle(-0.1)),1e-15,'Differenz 0.1r - (-0.1r)');
  CheckEquals(Angle(2*pi+0.1),FAngle,1e-15,'Startwinkel ist 2pi+0.1r');

  FAngle := Angle(-2*pi+0.1);
  CheckEquals(Angle(0.0),FAngle.Diff(Angle(0.1)),1e-15,'Differenz 0.1r - 0.1r');
  CheckEquals(Angle(-2*pi+0.1),FAngle,1e-15,'Startwinkel ist -2pi+0.1r');

  FAngle := Angle(0.1);
  CheckEquals(Angle(0.2),FAngle.Diff(Angle(2*pi-0.1)),1e-15,'Differenz 0.1r - (-0.1r)');
  CheckEquals(Angle(0.1),FAngle,1e-15,'Startwinkel ist 0.1r');

  FAngle := Angle(+0.1);
  CheckEquals(Angle(0.0),FAngle.Diff(Angle(2*pi+0.1)),1e-15,'Differenz 0.1r - 0.1r');
  CheckEquals(Angle(0.1),FAngle,1e-15,'Startwinkel ist 0.1r');

  // Test Lot of Random Values
   for I := 0 to 50000 do
      begin
         ldir := (random -0.5)* pi*2;
         lmult := ldir+ (random(256)-128)*pi*2;
         ldir2 := (random -0.5)* pi*2;
         lmult2 := ldir2+ (random(256)-128)*pi*2;
         FAngle := angle(lmult);
         CheckEquals(Angle(ldir-ldir2).Normalize,FAngle.Diff(Angle(lMult2)),5e-13,format('Diff %f - %f',[lmult,lmult2]));
         CheckEquals(Angle(lmult),FAngle,5e-15,format('Still  %f',[ldir]));
      end;

end;

procedure TTestAngle.TestSubt;
var
  ldir2, ldir, lmult, lmult2: Extended;
  I: Integer;
begin
  //Well Known Values (Without Overflow)
  FAngle := Angle(0.0);
  CheckEquals(Angle(0.0),FAngle.Subt(ZeroAngle),1e-15,'Subtract 0° - 0°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0°');

  FAngle := Angle(0.1);
  CheckEquals(Angle(0.1),FAngle.Subt(ZeroAngle),1e-15,'Subtract 0.1r - 0°');
  CheckEquals(Angle(0.1),FAngle,1e-15,'Startwinkel ist 0.1r');

  FAngle := Angle(0.1);
  CheckEquals(Angle(0.2),FAngle.Subt(Angle(-0.1)),1e-15,'Subtract 0.1r - (-0.1r)');
  CheckEquals(Angle(0.2),FAngle,1e-15,'Startwinkel ist 0.1r');

  FAngle := Angle(0.1);
  CheckEquals(Angle(0.0),FAngle.Subt(Angle(0.1)),1e-15,'Subtract 0.1r - 0.1r');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0.1r');

  //Well Known Values with(Single overflow)
  FAngle := Angle(2*pi);
  CheckEquals(Angle(0.0),FAngle.Subt(ZeroAngle),1e-15,'Subtract 0° - 0°');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 2pi°');

  FAngle := Angle(-2*pi+0.1);
  CheckEquals(Angle(0.1),FAngle.Subt(ZeroAngle),1e-15,'Subtract 0.1r - 0°');
  CheckEquals(Angle(0.1),FAngle,1e-15,'Startwinkel ist -2pi+0.1r');

  FAngle := Angle(2*pi+0.1);
  CheckEquals(Angle(0.2),FAngle.Subt(Angle(-0.1)),1e-15,'Subtract 0.1r - (-0.1r)');
  CheckEquals(Angle(0.2),FAngle,1e-15,'Startwinkel ist 2pi+0.1r');

  FAngle := Angle(-2*pi+0.1);
  CheckEquals(Angle(0.0),FAngle.Subt(Angle(0.1)),1e-15,'Subtract 0.1r - 0.1r)');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist -2pi+0.1r');

  FAngle := Angle(0.1);
  CheckEquals(Angle(0.2),FAngle.Subt(Angle(2*pi-0.1)),1e-15,'Subtract 0.1r - (-0.1r)');
  CheckEquals(Angle(0.2),FAngle,1e-15,'Startwinkel ist 0.1r');

  FAngle := Angle(+0.1);
  CheckEquals(Angle(0.0),FAngle.Subt(Angle(2*pi+0.1)),1e-15,'Subtract 0.1r - 0.1r');
  CheckEquals(Angle(0.0),FAngle,1e-15,'Startwinkel ist 0.1r');

  // Test Lot of Random Values
   for I := 0 to 50000 do
      begin
         ldir := (random -0.5)* pi*2;
         lmult := ldir+ (random(256)-128)*pi*2;
         ldir2 := (random -0.5)* pi*2;
         lmult2 := ldir2+ (random(256)-128)*pi*2;
         FAngle := angle(lmult);
         CheckEquals(Angle(ldir-ldir2).Normalize,FAngle.Subt(Angle(lMult2)),5e-13,format('Subt %f - %f',[lmult,lmult2]));
         CheckEquals(Angle(ldir-ldir2).Normalize,FAngle,5e-13,format('Now  %f',[ldir-ldir2]));
      end;

end;



initialization

  RegisterTest({$IFDEF FPC} TTestAngle {$ELSE} TTestAngle.suite {$ENDIF});
end.

