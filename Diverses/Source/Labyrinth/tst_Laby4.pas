unit tst_Laby4;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, unt_Laby4;

type

  { TTestLaby4 }

  TTestLaby4= class(TTestCase)
  private
    FHeightLaby:THeightLaby;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    Procedure TestCalcPStepHeight;
    Procedure TestCalcPStepHeight2;
    Procedure TestCalcPStepHeight_n;
  end;

implementation

procedure TTestLaby4.TestSetUp;
begin
  CheckNotNull(FHeightLaby,'Object is assigned');
end;

procedure TTestLaby4.TestCalcPStepHeight;
var
  OutHgt: integer;
begin
  FHeightLaby.Dimension:=rect(0,0,3,3);
  FHeightLaby.SetLData('789...321',3,3,2);
  CheckEquals(5,FHeightLaby.LabyHeight[2,0],'LabyHeight[2,0]');
  CheckEquals(4,FHeightLaby.LabyHeight[1,0],'LabyHeight[1,0]');
  CheckEquals(3,FHeightLaby.LabyHeight[0,0],'LabyHeight[0,0]');
  CheckEquals(0,FHeightLaby.LabyHeight[2,1],'LabyHeight[2,1]');
  CheckEquals(0,FHeightLaby.LabyHeight[1,1],'LabyHeight[1,1]');
  CheckEquals(0,FHeightLaby.LabyHeight[0,1],'LabyHeight[0,1]');
  CheckEquals(9,FHeightLaby.LabyHeight[2,2],'LabyHeight[2,2]');
  CheckEquals(10,FHeightLaby.LabyHeight[1,2],'LabyHeight[1,2]');
  CheckEquals(11,FHeightLaby.LabyHeight[0,2],'LabyHeight[0,2]');
  // (0,1,0,-1)
  CheckTrue(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
  CheckEquals(4,OutHgt,'(1,0)->(1,1): 4');
  // (0,1,1,-1)
  CheckTrue(FHeightLaby.CalcPStepHeight(point(2,0),point(2,1),OutHgt),'Heightstep Found');
  CheckEquals(5,OutHgt,'(2,0)->(2,1): 5');
  // (1,1,0,-1)
  CheckTrue(FHeightLaby.CalcPStepHeight(point(0,0),point(0,1),OutHgt),'Heightstep Found');
  CheckEquals(2,OutHgt,'(0,0)->(0,1): 2');
  // (0,1,0,-1)
  CheckTrue(FHeightLaby.CalcPStepHeight(point(1,2),point(1,1),OutHgt),'Heightstep Found');
  CheckEquals(10,OutHgt,'(1,2)->(1,1): 10');
  // (0,1,1,-1)
  CheckTrue(FHeightLaby.CalcPStepHeight(point(2,2),point(2,1),OutHgt),'Heightstep Found');
  CheckEquals(8,OutHgt,'(2,2)->(2,1): 8');
  // (1,1,0,-1)
  CheckTrue(FHeightLaby.CalcPStepHeight(point(0,2),point(0,1),OutHgt),'Heightstep Found');
  CheckEquals(11,OutHgt,'(0,2)->(0,1): 11');
end;

procedure TTestLaby4.TestCalcPStepHeight2;
var
  OutHgt: integer;
begin
   FHeightLaby.Dimension:=rect(0,0,3,3);
   FHeightLaby.SetLData('4.23.12.0',3,3,2);
   CheckEquals(4,FHeightLaby.LabyHeight[2,0],'LabyHeight[2,0]');
   CheckEquals(0,FHeightLaby.LabyHeight[1,0],'LabyHeight[1,0]');
   CheckEquals(2,FHeightLaby.LabyHeight[0,0],'LabyHeight[0,0]');
   CheckEquals(5,FHeightLaby.LabyHeight[2,1],'LabyHeight[2,1]');
   CheckEquals(0,FHeightLaby.LabyHeight[1,1],'LabyHeight[1,1]');
   CheckEquals(3,FHeightLaby.LabyHeight[0,1],'LabyHeight[0,1]');
   CheckEquals(6,FHeightLaby.LabyHeight[2,2],'LabyHeight[2,2]');
   CheckEquals(0,FHeightLaby.LabyHeight[1,2],'LabyHeight[1,2]');
   CheckEquals(4,FHeightLaby.LabyHeight[0,2],'LabyHeight[0,2]');
   // (0,1,0,-1)
   CheckFalse(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
   // (0,1,0,0)
   CheckTrue(FHeightLaby.CalcPStepHeight(point(0,1),point(1,1),OutHgt),'Heightstep Found');
   CheckEquals(3,OutHgt,'(1,0)->(1,1): 3');
   // (0,1,0,0)
   CheckTrue(FHeightLaby.CalcPStepHeight(point(0,2),point(1,2),OutHgt),'Heightstep Found');
   CheckEquals(4,OutHgt,'(2,0)->(2,1): 4');
   // (1,1,0,0)
   CheckTrue(FHeightLaby.CalcPStepHeight(point(0,0),point(1,0),OutHgt),'Heightstep Found');
   CheckEquals(2,OutHgt,'(0,0)->(0,1): 2');
   // (0,1,0,-1)
   CheckTrue(FHeightLaby.CalcPStepHeight(point(2,1),point(1,1),OutHgt),'Heightstep Found');
   CheckEquals(5,OutHgt,'(1,2)->(1,1): 5');
   // (0,1,1,-1)
   CheckTrue(FHeightLaby.CalcPStepHeight(point(2,2),point(1,2),OutHgt),'Heightstep Found');
   CheckEquals(6,OutHgt,'(2,2)->(2,1): 6');
   // (0,1,0,-1)
   CheckTrue(FHeightLaby.CalcPStepHeight(point(2,0),point(1,0),OutHgt),'Heightstep Found');
   CheckEquals(4,OutHgt,'(0,2)->(0,1): 4');
end;

procedure TTestLaby4.TestCalcPStepHeight_n;
   var
     OutHgt: integer;
begin
      FHeightLaby.Dimension:=rect(0,0,3,3);
      FHeightLaby.SetLabyHeight(1,0,2);
      // (1,1,1,1)
      CheckTrue(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      CheckEquals(3,OutHgt,'(1,0)->(1,1): 3');
      FHeightLaby.SetLabyHeight(1,0,3);
      // (1,1,1,0)
      CheckTrue(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      CheckEquals(3,OutHgt,'(1,0)->(1,1): 3');
      FHeightLaby.SetLabyHeight(1,0,4);
      // (1,1,1,-1)
      CheckTrue(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      CheckEquals(3,OutHgt,'(1,0)->(1,1): 3');
      // No Solution
      FHeightLaby.SetLabyHeight(1,1,4);
      CheckFalse(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      FHeightLaby.SetLabyHeight(1,1,0);
      //
      FHeightLaby.SetLabyHeight(0,1,4);
      CheckFalse(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      FHeightLaby.SetLabyHeight(0,1,0);
      //
      FHeightLaby.SetLabyHeight(1,2,4);
      CheckFalse(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      FHeightLaby.SetLabyHeight(1,2,0);
      //
      FHeightLaby.SetLabyHeight(2,1,4);
      CheckFalse(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      FHeightLaby.SetLabyHeight(2,1,0);
end;

procedure TTestLaby4.SetUp;
begin
   FHeightLaby := THeightLaby.Create;
end;

procedure TTestLaby4.TearDown;
begin
   Freeandnil(FHeightLaby);
end;

initialization

  RegisterTest(TTestLaby4);
end.

