unit tst_RenderBase2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry,cls_RenderBase;

type

  { TTestRenderBase2 }

  TTestRenderBase2= class(TTestCase)
  private
    FFtriple:TFTriple;
    procedure CheckEquals(const Exp, Act: TFTriple; eps: extended; Msg: String);
      overload;
    procedure CheckEquals(const Exp, Act: TFTuple; eps: extended; Msg: String);
      overload;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    Procedure TestToString;
    procedure TestInit;
    Procedure TestAdd;
    Procedure TestOpPlus;
    Procedure TestAddTo;
    Procedure TestSubt;
    Procedure TestOpMinus;
    Procedure TestSubtTo;
    Procedure TestMul;
    Procedure TestOpMultiply;
    Procedure TestMul2;
    Procedure TestOpMultiply2;
    Procedure TestOpMultiply3;
    Procedure TestDivide;
    Procedure TestOpDivide;
    procedure TestXMul;
    Procedure TestEquals;
    Procedure TestOpEquals;
    Procedure TestCopy;
    Procedure TestCopy2;
    Procedure TestCopy3;
    Procedure TestGLen;
    Procedure TestFktAbs;
    Procedure TestGDir;
    Procedure TestMLen;
  end;

implementation

uses Math;

procedure TTestRenderBase2.TestSetUp;
begin
//  CheckNotNull(FFtriple,'FFtuppel exists');
  CheckEquals(0.0,FFtriple.x,1e-20,'FFtuppel.x = 0');
  CheckEquals(0.0,FFtriple.y,1e-20,'FFtuppel.y = 0');
  CheckEquals(0.0,FFtriple.z,1e-20,'FFtuppel.z = 0');
end;

procedure TTestRenderBase2.TestToString;
var
  i: Integer;
  x1, y1, z1: Extended;
  vfs: TFormatSettings;
begin
 vfs.DecimalSeparator:='.';
 vfs.ThousandSeparator:=#0;
 CheckEquals('<0.00; 0.00; 0.00>',FFtriple.ToString,'FFTriple.ToString');
 CheckEquals('<0.00; 0.00; 0.00>',ZeroTrp.ToString,'ZeroTup.ToString');
 FFtriple.init(1.0,-1.0, 0.5);
 CheckEquals('<1.00; -1.00; 0.50>',FFtriple.ToString,'init(1.0,-1.0,0.5)');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals('<23.00; 17.00; 13.00>',FFtriple.ToString,'init(23.0,17.0,13.0)');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     CheckEquals('<'+format('%f',[x1],vfs)+'; '+format('%f',[y1],vfs)+'; '+format('%f',[z1],vfs)+'>',FFtriple.ToString,format('init(%f,%f,%f)',[x1,y1,z1]));
     CheckEquals(x1,FFtriple.x,format('init(%f,%f,%f).x',[x1,y1,z1]));
     CheckEquals(y1,FFtriple.y,format('init(%f,%f,%f).y',[x1,y1,z1]));
     CheckEquals(z1,FFtriple.z,format('init(%f,%f,%f).z',[x1,y1,z1]));
     CheckEquals(x1,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[x1,y1,z1]));
     CheckEquals(y1,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[x1,y1,z1]));
     CheckEquals(z1,FFtriple.v[2],format('init(%f,%f,%f).v[2]',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestInit;
var
  x1, y1, z1: Extended;
  i: Integer;
begin
 CheckEquals(FTriple(0,0,0),ZeroTrp,1e-20,'ZeroTrp');
 FFtriple.init(0,0,0);
 CheckEquals(FTriple(0,0,0),FFtriple,1e-20,'init(0,0,0)');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(FTriple(1.0,-1.0,0.5),FFtriple,1e-20,'init(1.0,-1.0,0.5)');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(FTriple(23.0,17.0,13.0),FFtriple,1e-20,'init(23.0,17.0,13.0)');
 CheckEquals(23.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[23.0,17.0,13.0]));
 CheckEquals(17.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[23.0,17.0,13.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('init(%f,%f,%f)',[x1,y1,z1]));
     CheckEquals(x1,FFtriple.x,format('init(%f,%f,%f).x',[x1,y1,z1]));
     CheckEquals(y1,FFtriple.y,format('init(%f,%f,%f).y',[x1,y1,z1]));
     CheckEquals(x1,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[x1,y1,z1]));
     CheckEquals(y1,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestAdd;
var
  x1, y1,x2,y2, z1, z2: Extended;
  i: Integer;
  lFTriple:TFTriple;
begin
 CheckEquals(FTriple(0,0,0),ZeroTrp.Add(ZeroTrp),1e-20,'ZeroTrp + ZeroTrp');
 FFtriple.init(0,0,0);
 CheckEquals(FTriple(0,0,0),FFtriple.Add(ZeroTrp),1e-20,'init(0,0,0) + ZeroTrp');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(FTriple(3.0,-3.0,2.5),FFtriple.add(FTriple(2.0,-2.0,2.0)),1e-20,'init(1.0,-1.0,0.5).add(<2,-2,2>)');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(FTriple(26.0,14.0,14.5),FFtriple.add(FTriple(3.0,-3.0,1.5)),1e-20,'init(23.0,17.0,13.0).add(<-3,3,1.5>)');
 CheckEquals(26.0,FFtriple.Add(FTriple(3.0,-3.0,1.5)).v[0],format('init(%f,%f,%f).v[0]',[23.0,17.0,13.0]));
 CheckEquals(14.0,FFtriple.Add(FTriple(3.0,-3.0,1.5)).v[1],format('init(%f,%f,%f).v[1]',[23.0,17.0,13.0]));
 CheckEquals(14.5,FFtriple.Add(FTriple(3.0,-3.0,1.5)).v[2],format('init(%f,%f,%f).v[2]',[23.0,17.0,13.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     z2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     lFTriple.INit(x2,y2,z2);
     CheckEquals(FTriple(x1+x2,y1+y2,z1+z2),FFtriple.Add(lFTriple),1e-20,format('init(%f,%f,%f).add(%f,%f,%f)',[x1,y1,z1,x2,y2,z2]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestOpPlus;
var
  x1, y1,x2,y2, z1, z2: Extended;
  i: Integer;
  lFTriple:TFTriple;
begin
 CheckEquals(FTriple(0,0,0),ZeroTrp+ZeroTrp,1e-20,'ZeroTrp + ZeroTrp');
 FFtriple.init(0,0,0);
 CheckEquals(FTriple(0,0,0),FFtriple+ZeroTrp,1e-20,'init(0,0,0) + ZeroTrp');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(FTriple(3.0,-3.0,2.5),FFtriple+FTriple(2.0,-2.0,2.0),1e-20,'init(1.0,-1.0,0.5).add(<2,-2,2>)');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(FTriple(26.0,14.0,14.5),FFtriple+FTriple(3.0,-3.0,1.5),1e-20,'init(23.0,17.0,13.0).add(<-3,3,1.5>)');
 CheckEquals(26.0,FFtriple.Add(FTriple(3.0,-3.0,1.5)).v[0],format('init(%f,%f,%f).v[0]',[23.0,17.0,13.0]));
 CheckEquals(14.0,FFtriple.Add(FTriple(3.0,-3.0,1.5)).v[1],format('init(%f,%f,%f).v[1]',[23.0,17.0,13.0]));
 CheckEquals(14.5,FFtriple.Add(FTriple(3.0,-3.0,1.5)).v[2],format('init(%f,%f,%f).v[2]',[23.0,17.0,13.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     z2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     lFTriple.INit(x2,y2,z2);
     CheckEquals(FTriple(x1+x2,y1+y2,z1+z2),FFtriple+lFTriple,1e-20,format('init(%f,%f,%f).add(%f,%f,%f)',[x1,y1,z1,x2,y2,z2]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestAddTo;
var
  x1, y1,x2,y2, z1, z2: Extended;
  i: Integer;
  lFTriple:TFTriple;
begin
 CheckEquals(FTriple(0,0,0),ZeroTrp.AddTo(ZeroTrp),1e-20,'ZeroTrp + ZeroTrp');
 FFtriple.init(0,0,0);
 CheckEquals(FTriple(0,0,0),FFtriple.AddTo(ZeroTrp),1e-20,'init(0,0,0) + ZeroTrp');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(FTriple(3.0,-3.0,2.5),FFtriple.addTo(FTriple(2.0,-2.0,2.0)),1e-20,'init(1.0,-1.0,0.5).add(<2,-2,2>)');
 CheckEquals(3.0,FFtriple.x,format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-3.0,FFtriple.y,format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(FTriple(26.0,14.0,14.5),FFtriple.addTo(FTriple(3.0,-3.0,1.5)),1e-20,'init(23.0,17.0,13.0).add(<3,-3,1.5>)');
 CheckEquals(26.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[23.0,17.0,13.0]));
 CheckEquals(14.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[23.0,17.0,13.0]));
 CheckEquals(14.5,FFtriple.v[2],format('init(%f,%f,%f).v[2]',[23.0,17.0,13.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     z2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     lFTriple.INit(x2,y2,z2);
     CheckEquals(FTriple(x1+x2,y1+y2,z1+z2),FFtriple.Addto(lFTriple),1e-20,format('init(%f,%f,%f).add(%f,%f,%f)',[x1,y1,z1,x2,y2,z2]));
     CheckEquals(FTriple(x1+x2,y1+y2,z1+z2),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1+x2,y1+y2,z1+z2]));
   end;
end;

procedure TTestRenderBase2.TestSubt;
var
  x1, y1,x2,y2, z2, z1: Extended;
  i: Integer;
  lFTriple:TFTriple;
begin
 CheckEquals(FTriple(0,0,0),ZeroTrp.Subt(ZeroTrp),1e-20,'ZeroTrp - ZeroTrp');
 FFtriple.init(0,0,0);
 CheckEquals(FTriple(0,0,0),FFtriple.Subt(ZeroTrp),1e-20,'init(0,0,0) - ZeroTrp');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(FTriple(-1.0,1.0,-1.5),FFtriple.Subt(FTriple(2.0,-2.0,2.0)),1e-20,'init(1.0,-1.0,0.5).Subt(<2,-2,2>)');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 CheckEquals(0.5,FFtriple.v[2],format('init(%f,%f,%f).v[2]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(FTriple(20.0,20.0,11.5),FFtriple.Subt(FTriple(3.0,-3.0,1.5)),1e-20,'init(23.0,17.0,13.0).Subt(<-3,3,1.5>)');
 CheckEquals(20.0,FFtriple.Subt(FTriple(3.0,-3.0,1.5)).v[0],format('init(%f,%f,%f).v[0]',[23.0,17.0,13.0]));
 CheckEquals(20.0,FFtriple.Subt(FTriple(3.0,-3.0,1.5)).v[1],format('init(%f,%f,%f).v[1]',[23.0,17.0,13.0]));
 CheckEquals(11.5,FFtriple.Subt(FTriple(3.0,-3.0,1.5)).v[2],format('init(%f,%f,%f).v[2]',[23.0,17.0,13.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     z2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     lFTriple.INit(x2,y2,z2);
     CheckEquals(FTriple(x1-x2,y1-y2,z1-z2),FFtriple.Subt(lFTriple),1e-20,format('init(%f,%f,%f).Subt(%f,%f,%f)',[x1,y1,z1,x2,y2,z2]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestOpMinus;
var
  x1, y1,x2,y2, z2, z1: Extended;
  i: Integer;
  lFTriple:TFTriple;
begin
 CheckEquals(FTriple(0,0,0),ZeroTrp-ZeroTrp,1e-20,'ZeroTrp - ZeroTrp');
 FFtriple.init(0,0,0);
 CheckEquals(FTriple(0,0,0),FFtriple-ZeroTrp,1e-20,'init(0,0,0) - ZeroTrp');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(FTriple(-1.0,1.0,-1.5),FFtriple-FTriple(2.0,-2.0,2.0),1e-20,'init(1.0,-1.0,0.5).Subt(<2,-2,2>)');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 CheckEquals(0.5,FFtriple.v[2],format('init(%f,%f,%f).v[2]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(FTriple(20.0,20.0,11.5),FFtriple-FTriple(3.0,-3.0,1.5),1e-20,'init(23.0,17.0,13.0).Subt(<-3,3,1.5>)');
 CheckEquals(20.0,FFtriple.Subt(FTriple(3.0,-3.0,1.5)).v[0],format('init(%f,%f,%f).v[0]',[23.0,17.0,13.0]));
 CheckEquals(20.0,FFtriple.Subt(FTriple(3.0,-3.0,1.5)).v[1],format('init(%f,%f,%f).v[1]',[23.0,17.0,13.0]));
 CheckEquals(11.5,FFtriple.Subt(FTriple(3.0,-3.0,1.5)).v[2],format('init(%f,%f,%f).v[2]',[23.0,17.0,13.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     z2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     lFTriple.INit(x2,y2,z2);
     CheckEquals(FTriple(x1-x2,y1-y2,z1-z2),FFtriple-lFTriple,1e-20,format('init(%f,%f,%f).Subt(%f,%f,%f)',[x1,y1,z1,x2,y2,z2]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestSubtTo;
var
  x1, y1,x2,y2, z1, z2: Extended;
  i: Integer;
  lFTriple:TFTriple;
begin
 CheckEquals(FTriple(0,0,0),ZeroTrp.SubtTo(ZeroTrp),1e-20,'ZeroTrp - ZeroTrp');
 FFtriple.init(0,0,0);
 CheckEquals(FTriple(0,0,0),FFtriple.SubtTo(ZeroTrp),1e-20,'init(0,0,0) - ZeroTrp');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(FTriple(-1.0,1.0,-1.5),FFtriple.SubtTo(FTriple(2.0,-2.0,2.0)),1e-20,'init(1.0,-1.0,0.5).add(<2,-2>)');
 CheckEquals(-1.0,FFtriple.x,format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(1.0,FFtriple.y,format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(FTriple(20.0,20.0,11.5),FFtriple.SubtTo(FTriple(3.0,-3.0,1.5)),1e-20,'init(23.0,17.0,13.0).add(<-3,3)');
 CheckEquals(20.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[23.0,17.0,13.0]));
 CheckEquals(20.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[23.0,17.0,13.0]));
 CheckEquals(11.5,FFtriple.v[2],format('init(%f,%f,%f).v[2]',[23.0,17.0,13.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     z2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     lFTriple.INit(x2,y2,z2);
     CheckEquals(FTriple(x1-x2,y1-y2,z1-z2),FFtriple.SubtTo(lFTriple),1e-20,format('init(%f,%f,%f).add(%f,%f,%f)',[x1,y1,z1,x2,y2,z2]));
     CheckEquals(FTriple(x1-x2,y1-y2,z1-z2),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1+x2,y1+y2,z1+z2]));
   end;
end;

procedure TTestRenderBase2.TestMul;
var
  x1, y1,x2,y2, z1, z2: Extended;
  i: Integer;
  lFTriple:TFTriple;
begin
 CheckEquals(0.0,ZeroTrp.Mul(ZeroTrp),1e-20,'ZeroTrp * ZeroTrp');
 FFtriple.init(0,0,0);
 CheckEquals(0.0,FFtriple.Mul(ZeroTrp),1e-20,'init(0,0,0) * ZeroTrp');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(5.0,FFtriple.Mul(FTriple(2.0,-2.0,2.0)),1e-20,'init(1.0,-1.0,0.5).Mul(<2,-2,2>)');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 CheckEquals(0.5,FFtriple.v[2],format('init(%f,%f,%f).v[2]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(37.5,FFtriple.Mul(FTriple(3.0,-3.0,1.5)),1e-20,'init(23.0,17.0,13.0).Mul(<3,-3,1.5>)');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     z2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     lFTriple.INit(x2,y2,z2);
     CheckEquals(x1*x2+y1*y2+z1*z2,FFtriple.Mul(lFTriple),1e-20,format('init(%f,%f,%f).Mul(%f,%f,%f)',[x1,y1,z1,x2,y2,z2]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestOpMultiply;
var
  x1, y1,x2,y2, z1, z2: Extended;
  i: Integer;
  lFTriple:TFTriple;
begin
 CheckEquals(0.0,ZeroTrp*ZeroTrp,1e-20,'ZeroTrp * ZeroTrp');
 FFtriple.init(0,0,0);
 CheckEquals(0.0,FFtriple*ZeroTrp,1e-20,'init(0,0,0) * ZeroTrp');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(5.0,FFtriple*FTriple(2.0,-2.0,2.0),1e-20,'init(1.0,-1.0,0.5).Mul(<2,-2,2>)');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 CheckEquals(0.5,FFtriple.v[2],format('init(%f,%f,%f).v[2]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(37.5,FFtriple*FTriple(3.0,-3.0,1.5),1e-20,'init(23.0,17.0,13.0).Mul(<3,-3,1.5>)');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     z2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     lFTriple.INit(x2,y2,z2);
     CheckEquals(x1*x2+y1*y2+z1*z2,FFtriple*lFTriple,1e-20,format('init(%f,%f,%f).Mul(%f,%f,%f)',[x1,y1,z1,x2,y2,z2]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestMul2;
var
  x1, y1,x2, z1: Extended;
  i: Integer;

begin
 CheckEquals(FTriple(0,0,0),ZeroTrp.Mul(0.0),1e-20,'ZeroTrp * ZeroTrp');
 FFtriple.init(0,0,0);
 CheckEquals(FTriple(0,0,0),FFtriple.Mul(1.0),1e-20,'init(0,0,0) * ZeroTrp');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(FTriple(2.0,-2.0,1.0),FFtriple.Mul(2.0),1e-20,'init(1.0,-1.0,0.5).Mul(2.0)');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(FTriple(-69.0,-51.0,-39.0),FFtriple.Mul(-3.0),1e-20,'init(23.0,17.0,13.0).Mul(-3.0)');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     CheckEquals(FTriple(x1*x2,y1*x2,z1*x2),FFtriple.Mul(X2),1e-20,format('init(%f,%f,%f).Mul(%f)',[x1,y1,z1,x2]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestOpMultiply2;
var
  x1, y1,x2, z1: Extended;
  i: Integer;

begin
 CheckEquals(FTriple(0,0,0),ZeroTrp*0.0,1e-20,'ZeroTrp * ZeroTrp');
 FFtriple.init(0,0,0);
 CheckEquals(FTriple(0,0,0),FFtriple*1.0,1e-20,'init(0,0,0) * ZeroTrp');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(FTriple(2.0,-2.0,1.0),FFtriple*2.0,1e-20,'init(1.0,-1.0,0.5)*2.0');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(FTriple(-69.0,-51.0,-39.0),FFtriple*-3.0,1e-20,'init(23.0,17.0,13.0)*-3.0');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     CheckEquals(FTriple(x1*x2,y1*x2,z1*x2),FFtriple*X2,1e-20,format('init(%f,%f,%f)*%f',[x1,y1,z1,x2]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestOpMultiply3;
var
  x1, y1,x2, z1: Extended;
  i: Integer;

begin
 CheckEquals(FTriple(0,0,0),0.0*ZeroTrp,1e-20,'ZeroTrp * ZeroTrp');
 FFtriple.init(0,0,0);
 CheckEquals(FTriple(0,0,0),1.0*FFtriple,1e-20,'init(0,0,0) * 1.0');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(FTriple(2.0,-2.0,1.0),2.0*FFtriple,1e-20,'init(1.0,-1.0,0.5)*2.0');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(FTriple(-69.0,-51.0,-39.0),-3.0*FFtriple,1e-20,'init(23.0,17.0,13.0)*-3.0');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     CheckEquals(FTriple(x1*x2,y1*x2,z1*x2),X2*FFtriple,1e-20,format('init(%f,%f,%f)*%f',[x1,y1,z1,x2]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestDivide;
var
  x1, y1,x2, z1: Extended;
  i: Integer;

begin
 CheckEquals(FTriple(0,0,0),ZeroTrp.Divide(1.0),1e-20,'ZeroTrp * ZeroTrp');
 FFtriple.init(0,0,0);
 CheckEquals(FTriple(0,0,0),FFtriple.Divide(1.0),1e-20,'init(0,0,0) * ZeroTrp');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(FTriple(0.5,-0.5,0.25),FFtriple.Divide(2.0),1e-20,'init(1.0,-1.0,0.5).Divide(2.0)');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 FFtriple.init(-69.0,-51.0,-39.0);
 CheckEquals(FTriple(23.0,17.0,13.0),FFtriple.Divide(-3.0),1e-20,'init(-69.0,-51.0).Divide(-3.0)');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:=0.0;
     while x2 = 0.0 do
     x2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     CheckEquals(FTriple(x1/x2,y1/x2,z1/x2),FFtriple.Divide(X2),1e-20,format('init(%f,%f,%f).Divide(%f)',[x1,y1,z1,x2]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestOpDivide;
var
  x1, y1,x2, z1: Extended;
  i: Integer;

begin
 CheckEquals(FTriple(0,0,0),ZeroTrp/1.0,1e-20,'ZeroTrp / 1.0');
 FFtriple.init(0,0,0);
 CheckEquals(FTriple(0,0,0),FFtriple/1.0,1e-20,'init(0,0,0) / 1.0');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(FTriple(0.5,-0.5,0.25),FFtriple/2.0,1e-20,'init(1.0,-1.0,0.5)/2.0');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 FFtriple.init(-69.0,-51.0,-39.0);
 CheckEquals(FTriple(23.0,17.0,13.0),FFtriple/-3.0,1e-20,'init(-69.0,-51.0)/-3.0');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:=0.0;
     while x2 = 0.0 do
     x2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     CheckEquals(FTriple(x1/x2,y1/x2,z1/x2),FFtriple/X2,1e-20,format('init(%f,%f,%f)/%f',[x1,y1,z1,x2]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestXMul;
var
  x1, y1,x2,y2, z1, z2: Extended;
  i: Integer;
  lFTriple:TFTriple;
begin
 CheckEquals(FTriple(0,0,0),ZeroTrp.XMul(ZeroTrp),1e-20,'ZeroTrp x ZeroTrp');
 FFtriple.init(0,0,0);
 CheckEquals(FTriple(0,0,0),FFtriple.XMul(ZeroTrp),1e-20,'init(0,0,0) x ZeroTrp');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(FTriple(-1.0,-1.0,0.0),FFtriple.XMul(FTriple(2.0,-2.0,2.0)),1e-20,'init(1.0,-1.0,0.5).XMul(<2,-2,2>)');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(FTriple(64.5,4.5,-120.0),FFtriple.XMul(FTriple(3.0,-3.0,1.5)),1e-20,'init(23.0,17.0,13.0).XMul(<3,-3,1.5>)');
 CheckEquals(64.5,FFtriple.XMul(FTriple(3.0,-3.0,1.5)).v[0],format('init(%f,%f,%f).v[0]',[23.0,17.0,13.0]));
 CheckEquals(4.5,FFtriple.XMul(FTriple(3.0,-3.0,1.5)).v[1],format('init(%f,%f,%f).v[1]',[23.0,17.0,13.0]));
 CheckEquals(-120.0,FFtriple.XMul(FTriple(3.0,-3.0,1.5)).v[2],format('init(%f,%f,%f).v[1]',[23.0,17.0,13.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     z2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     lFTriple.INit(x2,y2,z2);
     CheckEquals(FTriple(y1*z2-z1*y2,z1*x2-x1*z2,x1*y2-y1*x2),FFtriple.XMul(lFTriple),1e-20,format('init(%f,%f,%f).XMul(%f,%f,%f)',[x1,y1,z1,x2,y2,z2]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestEquals;
var
  x1, y1,x2,y2, z1, z2: Extended;
  i: Integer;
  lFTriple:TFTriple;
begin
 CheckEquals(true,ZeroTrp.Equals(ZeroTrp,1e-20),'ZeroTrp = ZeroTrp');
 FFtriple.init(0,0,0);
 CheckEquals(true,FFtriple.Equals(ZeroTrp,1e-20),'init(0,0,0) = ZeroTrp');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(false,FFtriple.Equals(FTriple(2.0,-2.0,2.0),1e-20),'init(1.0,-1.0,0.5).Equals(<2,-2,2>)');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(false,FFtriple.Equals(FTriple(3.0,-3.0,1.5),1e-20),'init(23.0,17.0,13.0).Equals(<-3,3,1.5>)');
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(false,FFtriple.Equals(FTriple(23.0,-3.0,13.0),1e-20),'init(23.0,17.0,13.0).Equals(<23,3,13>)');
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(false,FFtriple.Equals(FTriple(3.0,17.0,13.0),1e-20),'init(23.0,17.0,13.0).Equals(<-3,17,13>)');
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(false,FFtriple.Equals(FTriple(23.0,17.0,3.0),1e-20),'init(23.0,17.0,13.0).Equals(<23,17,3>)');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     if random >0.5 then
       begin
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     z2:= (random-0.5)*maxLongint;
       end
     else
       begin
         x2:=x1;
         y2:=y1;
         z2:=z1;
       end;
     FFtriple.init(x1,y1,z1);
     lFTriple.INit(x2,y2,z2);
     CheckEquals((abs(x1-x2)<1e-20) and (abs(y1-y2)<1e-20),FFtriple.Equals(lFTriple,1e-20),format('init(%f,%f,%f).Equals(%f,%f,%f)',[x1,y1,z1,x2,y2,z2]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestOpEquals;
var
  x1, y1,x2,y2, z1, z2: Extended;
  i: Integer;
  lFTriple:TFTriple;
begin
 CheckEquals(true,ZeroTrp=ZeroTrp,'ZeroTrp = ZeroTrp');
 FFtriple.init(0,0,0);
 CheckEquals(true,FFtriple=ZeroTrp,'init(0,0,0) = ZeroTrp');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(false,FFtriple=FTriple(2.0,-2.0,2.0),'init(1.0,-1.0,0.5)=(<2,-2,2>)');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(false,FFtriple=FTriple(3.0,-3.0,1.5),'init(23.0,17.0,13.0)=(<-3,3,1.5>)');
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(false,FFtriple=FTriple(23.0,-3.0,13.0),'init(23.0,17.0,13.0)=(<23,3,13>)');
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(false,FFtriple=FTriple(3.0,17.0,13.0),'init(23.0,17.0,13.0)=(<-3,17,13>)');
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(false,FFtriple=FTriple(23.0,17.0,3.0),'init(23.0,17.0,13.0)=(<23,17,3>)');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     if random >0.5 then
       begin
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     z2:= (random-0.5)*maxLongint;
       end
     else
       begin
         x2:=x1;
         y2:=y1;
         z2:=z1;
       end;
     FFtriple.init(x1,y1,z1);
     lFTriple.INit(x2,y2,z2);
     CheckEquals((abs(x1-x2)<1e-20) and (abs(y1-y2)<1e-15),FFtriple=lFTriple,format('init(%f,%f,%f).Equals(%f,%f,%f)',[x1,y1,z1,x2,y2,z2]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestCopy;
var
  x1, y1,x2,y2, z1, z2: Extended;
  i: Integer;
//  lFTriple:TFTriple;
begin
 CheckEquals(FTriple(0,0,0),ZeroTrp.Copy(0,0,0),1e-20,'0,0 x 0,0');
 FFtriple.init(0,0,0);
 CheckEquals(FTriple(0,0,0),FFtriple.Copy(0,0,0),1e-20,'init(0,0,0) x 0,0');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(FTriple(2.0,-2.0,2.0),FFtriple.Copy(2.0,-2.0,2.0),1e-20,'init(1.0,-1.0,0.5).Copy(<2,-2,2>)');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(FTriple(3.0,-3.0,1.5),FFtriple.Copy(3.0,-3.0,1.5),1e-20,'init(23.0,17.0,13.0).Copy(<3,-3,1.5>)');
 CheckEquals(3.0,FFtriple.Copy(3.0,-3.0,1.5).v[0],format('init(%f,%f,%f).v[0]',[23.0,17.0,13.0]));
 CheckEquals(-3.0,FFtriple.Copy(3.0,-3.0,1.5).v[1],format('init(%f,%f,%f).v[1]',[23.0,17.0,13.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     z2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
//     lFTriple.INit(x2,y2,z2);
     CheckEquals(FTriple(x2,y2,z2),FFtriple.Copy(x2,y2,z2),1e-20,format('init(%f,%f,%f).Copy(%f,%f,%f)',[x1,y1,z1,x2,y2,z2]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestCopy2;
var
  x1, y1,x2,y2, z1, Z2: Extended;
  i: Integer;
  lFTriple:TFTriple;
begin
 CheckEquals(FTriple(0,0,0),ZeroTrp.Copy(FTriple(0,0,0)),1e-20,'0,0 x 0,0');
 FFtriple.init(0,0,0);
 CheckEquals(FTriple(0,0,0),FFtriple.Copy(FTriple(0,0,0)),1e-20,'init(0,0,0) x 0,0');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(FTriple(2.0,-2.0,2.0),FFtriple.Copy(FTriple(2.0,-2.0,2.0)),1e-20,'init(1.0,-1.0,0.5).Copy(<2,-2>)');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(FTriple(3.0,-3.0,1.5),FFtriple.Copy(FTriple(3.0,-3.0,1.5)),1e-20,'init(23.0,17.0,13.0).Copy(<3,-3>)');
 CheckEquals(3.0,FFtriple.Copy(FTriple(3.0,-3.0,1.5)).v[0],format('init(%f,%f,%f).v[0]',[23.0,17.0,13.0]));
 CheckEquals(-3.0,FFtriple.Copy(FTriple(3.0,-3.0,1.5)).v[1],format('init(%f,%f,%f).v[1]',[23.0,17.0,13.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     Z2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     lFTriple.INit(x2,y2,z2);
     CheckEquals(FTriple(x2,y2,z2),FFtriple.Copy(lFTriple),1e-20,format('init(%f,%f,%f).Copy(<%f,%f,%f>)',[x1,y1,z1,x2,y2,z2]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestCopy3;
var
  x1, y1,x2,y2, z1, z2: Extended;
  i: Integer;
  lFTriple:TFTriple;
begin
 CheckEquals(FTriple(0,0,0),ZeroTrp.Copy,1e-20,'0,0 x 0,0');
 FFtriple.init(0,0,0);
 CheckEquals(FTriple(0,0,0),FFtriple.Copy,1e-20,'init(0,0,0) x 0,0');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(FTriple(1.0,-1.0,0.5),FFtriple.Copy,1e-20,'init(1.0,-1.0,0.5).Copy');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 CheckEquals(0.5,FFtriple.v[2],format('init(%f,%f,%f).v[2]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(FTriple(23.0,17.0,13.0),FFtriple.Copy,1e-20,'init(23.0,17.0,13.0).Copy');
 CheckEquals(23.0,FFtriple.Copy.v[0],format('init(%f,%f,%f).Copy.v[0]',[23.0,17.0,13.0]));
 CheckEquals(17.0,FFtriple.Copy.v[1],format('init(%f,%f,%f).Copy.v[1]',[23.0,17.0,13.0]));
 CheckEquals(13.0,FFtriple.Copy.v[2],format('init(%f,%f,%f).Copy.v[2]',[23.0,17.0,13.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     z2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     lFTriple.INit(x2,y2,z2);
     CheckEquals(FTriple(x1,y1,z1),FFtriple.Copy,1e-20,format('init(%f,%f,%f).Copy',[x1,y1,z1]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestGLen;
var
  x1, y1,x2,y2, z1, z2: Extended;
  i: Integer;
  lFTriple:TFTriple;
begin
 CheckEquals(0.0,ZeroTrp.GLen,1e-20,'ZeroTrp.GLen');
 FFtriple.init(0,0,0);
 CheckEquals(0.0,FFtriple.GLen,1e-20,'init(0,0,0).GLen');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(1.5,FFtriple.GLen,1e-20,'init(1.0,-1.0,0.5).GLen');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(sqrt(818.0+169.0),FFtriple.GLen,1e-20,'init(23.0,17.0,13.0).GLen');
 FFtriple.init(-23.0,17.0,13.0);
 CheckEquals(sqrt(818.0+169.0),FFtriple.GLen,1e-20,'init(-23.0,17.0,13.0).GLen');
 FFtriple.init(13.0,17.0,11.0);
 CheckEquals(sqrt(458.0+121.0),FFtriple.GLen,1e-20,'init(13.0,17.0,11.0).GLen');
 FFtriple.init(-13.0,-17.0,11.0);
 CheckEquals(sqrt(458.0+121.0),FFtriple.GLen,1e-20,'init(-13.0,-17.0,11.0).GLen');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     z2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     lFTriple.INit(x2,y2,z2);
     CheckEquals(sqrt(sqr(x1)+sqr(y1)+sqr(z1)),FFtriple.GLen,1e-20,format('init(%f,%f,%f).GLen',[x1,y1,z1]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestFktAbs;
 var
  x1, y1,x2,y2, z1, z2: Extended;
  i: Integer;
  lFTriple:TFTriple;
begin
 CheckEquals(0.0,abs(ZeroTrp),1e-20,'ZeroTrp.GLen');
 FFtriple.init(0,0,0);
 CheckEquals(0.0,abs(FFtriple),1e-20,'abs(init(0,0,0))');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(1.5,abs(FFtriple),1e-20,'abs(init(1.0,-1.0,0.5))');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(sqrt(818.0+169.0),abs(FFtriple),1e-20,'abs(init(23.0,17.0,13.0))');
 FFtriple.init(-23.0,17.0,13.0);
 CheckEquals(sqrt(818.0+169.0),abs(FFtriple),1e-20,'abs(init(-23.0,17.0,13.0))');
 FFtriple.init(13.0,17.0,11.0);
 CheckEquals(sqrt(458.0+121.0),abs(FFtriple),1e-20,'abs(init(13.0,17.0,11.0))');
 FFtriple.init(-13.0,-17.0,11.0);
 CheckEquals(sqrt(458.0+121.0),abs(FFtriple),1e-20,'abs(init(-13.0,-17.0,11.0))');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     z2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     lFTriple.INit(x2,y2,z2);
     CheckEquals(sqrt(sqr(x1)+sqr(y1)+sqr(z1)),abs(FFtriple),1e-20,format('abs(init(%f,%f,%f))',[x1,y1,z1]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestGDir;
var
  x1, y1,x2,y2, Z2, z1: Extended;
  i: Integer;
  lFTriple:TFTriple;
begin
 CheckEquals(ZeroTup,ZeroTrp.GDir,1e-20,'ZeroTrp.GDir');
 FFtriple.init(0,0,0);
 CheckEquals(Zerotup,FFtriple.GDir,1e-20,'init(0,0,0).GDir');
// Check Well Known Values
 FFtriple.init(1.0,0.0,0.0);
 CheckEquals(ZeroTup,FFtriple.GDir,1e-15,'init(1.0,0.0).GDir');
 FFtriple.init(sqrt(3/4),0.5,0.0);  // 30°
 CheckEquals(FTuple(pi/6,0),FFtriple.GDir,1e-15,'init(0.866,0.5,0.0).GDir');
 CheckEquals(sqrt(3/4),FFtriple.v[0],format('init(%f,%f,%f).v[0]',[0.866,0.5,0.0]));
 CheckEquals(0.5,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[0.866,0.5,0.0]));
 FFtriple.init(1.0,1.0,0.0);    // 45°
 CheckEquals(FTuple(pi/4,0),FFtriple.GDir,1e-15,'init(1.0,1.0).GDir');
 FFtriple.init(0.5,sqrt(3/4),0.0); // 60°
 CheckEquals(FTuple(pi/3,0),FFtriple.GDir,1e-15,'init(0.5,0.866).GDir');
 FFtriple.init(0.0,1.0,0.0);  // 90°
 CheckEquals(FTuple(pi/2,0),FFtriple.GDir,1e-15,'init(0.0,1.0).GDir');
 FFtriple.init(-0.5,sqrt(3/4),0.0); // 120°
 CheckEquals(FTuple(2*pi/3,0),FFtriple.GDir,1e-15,'init(-0.5,0.866).GDir');
 FFtriple.init(-1.0,1.0,0.0);  // 135°
 CheckEquals(FTuple(3*pi/4,0),FFtriple.GDir,1e-15,'init(-1.0,1.0).GDir');
 FFtriple.init(-sqrt(3/4),0.5,0.0); // 150°
 CheckEquals(FTuple(5*pi/6,0),FFtriple.GDir,1e-15,'init(-0.866,0.5).GDir');
 FFtriple.init(-1.0,0.0,0.0);  // 180°
 CheckEquals(FTuple(pi,0),FFtriple.GDir,1e-15,'init(-1.0,0.0).GDir');
 FFtriple.init(-sqrt(3/4),-0.5,0);  // -150°
 CheckEquals(FTuple(5*pi/6,pi),FFtriple.GDir,1e-15,'init(-0.866,-0.5).GDir');
 FFtriple.init(-1.0,-1.0,0.0);  // -135°
 CheckEquals(FTuple(3*pi/4,pi),FFtriple.GDir,1e-15,'init(-1.0,-1.0).GDir');
 FFtriple.init(-0.5,-sqrt(3/4),0.0); // -120°
 CheckEquals(FTuple(2*pi/3,pi),FFtriple.GDir,1e-15,'init(-0.5,-0.866).GDir');
 FFtriple.init(0.0,-1.0,0.0);  // -90°
 CheckEquals(FTuple(pi/2,pi),FFtriple.GDir,1e-15,'init(0.0,-1.0).GDir');
 FFtriple.init(0.5,-sqrt(3/4),0.0); // -60°
 CheckEquals(FTuple(pi/3,pi),FFtriple.GDir,1e-15,'init(0.5,-0.866).GDir');
 FFtriple.init(1.0,-1.0,0.0);    // -45°
 CheckEquals(FTuple(pi/4,pi),FFtriple.GDir,1e-15,'init(1.0,-1.0,0.5).GDir');
 FFtriple.init(sqrt(3/4),-0.5,0.0);  // -30°
 CheckEquals(FTuple(pi/6,pi),FFtriple.GDir,1e-15,'init(0.866,-0.5).GDir');
// Some other Values
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(FTuple(0.74939949238095,0.652846631100774),FFtriple.GDir,1e-15,'init(23.0,17.0,13.0).GDir');
 FFtriple.init(-23.0,17.0,13.0);
 CheckEquals(FTuple(pi-0.74939949238095,0.652846631100774),FFtriple.GDir,1e-15,'init(-23.0,17.0).GDir');
 FFtriple.init(13.0,17.0,13.0);
 CheckEquals(FTuple(1.02491680674777,0.652846631100774),FFtriple.GDir,1e-14,'init(13.0,17.0,13.0).GDir');
 FFtriple.init(-13.0,-17.0,13.0);
 CheckEquals(FTuple(pi-1.02491680674777,pi-0.652846631100774),FFtriple.GDir,1e-14,'init(-13.0,-17.0,13.0).GDir');
 for i := 0 to 50000 do
   begin
     y2:= random*pi;
     Z2:= (random-0.5)*pi*2;
     x2:= (random+1e-15)*maxLongint;
     x1:= cos(y2)*x2;
     y1:= sin(y2)*x2*cos(z2);
     z1:= sin(y2)*x2*sin(z2);

     FFtriple.init(x1,y1,z1);
     lFTriple.INit(x2,y2,z2);
     CheckEquals(FTuple(y2,z2),FFtriple.GDir,1e-15,format('init(%f,%f,%f).GDir',[x1,y1,z1]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.TestMLen;
var
  x1, y1,x2,y2, z1, z2: Extended;
  i: Integer;
  lFTriple:TFTriple;
begin
 CheckEquals(0.0,ZeroTrp.MLen,1e-20,'ZeroTrp.MLen');
 FFtriple.init(0,0,0);
 CheckEquals(0.0,FFtriple.MLen,1e-20,'init(0,0,0).MLen');
 FFtriple.init(1.0,-1.0,0.5);
 CheckEquals(1.0,FFtriple.MLen,1e-20,'init(1.0,-1.0,0.5).MLen');
 CheckEquals(1.0,FFtriple.v[0],format('init(%f,%f,%f).v[0]',[1.0,-1.0,0.5]));
 CheckEquals(-1.0,FFtriple.v[1],format('init(%f,%f,%f).v[1]',[1.0,-1.0,0.5]));
 CheckEquals(0.5,FFtriple.v[2],format('init(%f,%f,%f).v[2]',[1.0,-1.0,0.5]));
 FFtriple.init(23.0,17.0,13.0);
 CheckEquals(23.0,FFtriple.MLen,1e-20,'init(23.0,17.0,13.0).MLen');
 FFtriple.init(-23.0,17.0,13.0);
 CheckEquals(23.0,FFtriple.MLen,1e-20,'init(-23.0,17.0).MLen');
 FFtriple.init(13.0,17.0,13.0);
 CheckEquals(17.0,FFtriple.MLen,1e-20,'init(13.0,17.0).MLen');
 FFtriple.init(-13.0,-17.0,-13.0);
 CheckEquals(17.0,FFtriple.MLen,1e-20,'init(-13.0,-17.0).MLen');
 FFtriple.init(11.0,13.0,17.0);
 CheckEquals(17.0,FFtriple.MLen,1e-20,'init(13.0,17.0).MLen');
 FFtriple.init(-13.0,-11.0,-17.0);
 CheckEquals(17.0,FFtriple.MLen,1e-20,'init(-13.0,-17.0).MLen');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     z1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     z2:= (random-0.5)*maxLongint;
     FFtriple.init(x1,y1,z1);
     lFTriple.INit(x2,y2,z2);
     CheckEquals(max(abs(x1),max(abs(y1),abs(z1))),FFtriple.MLen,1e-20,format('init(%f,%f,%f).MLen',[x1,y1,z1]));
     CheckEquals(FTriple(x1,y1,z1),FFtriple,1e-20,format('FTriple=(%f,%f,%f)',[x1,y1,z1]));
   end;
end;

procedure TTestRenderBase2.CheckEquals(const Exp, Act: TFTriple; eps: extended;
  Msg: String);
begin
  CheckEquals(exp.X,act.X,eps,Msg+'[X]');
  CheckEquals(exp.Y,act.Y,eps,Msg+'[Y]');
  CheckEquals(exp.Z,act.Z,eps,Msg+'[Z]');
end;

procedure TTestRenderBase2.CheckEquals(const Exp, Act: TFTuple; eps: extended;
  Msg: String);
begin
 CheckEquals(exp.X,act.X,eps,Msg+'[X]');
 CheckEquals(exp.Y,act.Y,eps,Msg+'[Y]');
end;

procedure TTestRenderBase2.SetUp;
begin
 FFtriple.Init(0,0,0);
end;

procedure TTestRenderBase2.TearDown;
begin
// Nothing to do here
end;

initialization

  RegisterTest(TTestRenderBase2);
end.

