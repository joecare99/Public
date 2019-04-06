unit tst_RenderBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,cls_RenderBase;

type

  { TTestRenderBase }

  TTestRenderBase= class(TTestCase)
  private
    FFtupple:TFTuple;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    Procedure TestToString;
    procedure TestInit;
    Procedure TestAdd;
    Procedure TestSubt;
    Procedure TestMul;
    Procedure TestMul2;
    Procedure TestDivide;
    Procedure TestVMul;
    Procedure TestEquals;
    Procedure TestCopy;
    Procedure TestCopy2;
    Procedure TestCopy3;
    Procedure TestGLen;
    Procedure TestMLen;
  end;

implementation

procedure TTestRenderBase.TestSetUp;
begin
//  CheckNotNull(FFtupple,'FFtuppel exists');
  CheckEquals(0.0,FFtupple.x,1e-20,'FFtuppel.x = 0');
  CheckEquals(0.0,FFtupple.y,1e-20,'FFtuppel.y = 0');
end;

procedure TTestRenderBase.TestToString;
begin
 CheckEquals('<0.00; 0.00>',FFtupple.ToString,'FFtupple.ToString');
 CheckEquals('<0.00; 0.00>',ZeroTup.ToString,'ZeroTup.ToString');
end;

procedure TTestRenderBase.SetUp;
begin
 FFtupple.Init(0,0);
end;

procedure TTestRenderBase.TearDown;
begin
// Nothing to do here
end;

initialization

  RegisterTest(TTestRenderBase);
end.

