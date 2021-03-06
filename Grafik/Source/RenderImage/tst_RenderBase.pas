unit tst_RenderBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry,cls_RenderBase;

type

  { TTestRenderBase }

  TTestRenderBase= class(TTestCase)
  private
    FFtupple:TFTuple;
    procedure CheckEquals(const Exp, Act: TFTuple; eps: extended; Msg: String);
      overload;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    Procedure TestToString;
    procedure TestInit;
    procedure TestInitLenDir;
    procedure TestOpAssign;
    Procedure TestSum;
    Procedure TestOpPlus;
    Procedure TestAdd;
    Procedure TestSubt;
    Procedure TestOpMinus;
    Procedure TestSubtTo;
    Procedure TestMul;
    Procedure TestOpMul;
    Procedure TestMul2;
    Procedure TestOpMul2;
    Procedure TestOpMul3;
    Procedure TestDivide;
    Procedure TestOpDivide;
    Procedure TestVMul;
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

uses Math,variants;

procedure TTestRenderBase.TestSetUp;
begin
//  CheckNotNull(FFtupple,'FFtuppel exists');
  CheckEquals(0.0,FFtupple.x,1e-20,'FFtuppel.x = 0');
  CheckEquals(0.0,FFtupple.y,1e-20,'FFtuppel.y = 0');
end;

procedure TTestRenderBase.TestToString;
var
  i: Integer;
  x1, y1: Extended;
  vfs: TFormatSettings;
begin
 vfs.DecimalSeparator:='.';
 vfs.ThousandSeparator:=#0;
 CheckEquals('<0.00; 0.00>',FFtupple.ToString,'FFtupple.ToString');
 CheckEquals('<0.00; 0.00>',ZeroTup.ToString,'ZeroTup.ToString');
 FFtupple.init(1.0,-1.0);
 CheckEquals('<1.00; -1.00>',FFtupple.ToString,'init(1.0,-1.0).ToString');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals('<23.00; 17.00>',FFtupple.ToString,'init(23.0,17.0).ToString');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     CheckEquals('<'+format('%f',[x1],vfs)+'; '+format('%f',[y1],vfs)+'>',FFtupple.Tostring,format('init(%f,%f)',[x1,y1]));
     CheckEquals(x1,FFtupple.x,format('init(%f,%f).x',[x1,y1]));
     CheckEquals(y1,FFtupple.y,format('init(%f,%f).y',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestInit;
var
  x1, y1: Extended;
  i: Integer;
begin
 CheckEquals(FTuple(0,0),ZeroTup,1e-20,'ZeroTup');
 FFtupple.init(0,0);
 CheckEquals(FTuple(0,0),FFtupple,1e-20,'init(0,0)');
 FFtupple.init(1.0,-1.0);
 CheckEquals(FTuple(1.0,-1.0),FFtupple,1e-20,'init(1.0,-1.0)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(FTuple(23.0,17.0),FFtupple,1e-20,'init(23.0,17.0)');
 CheckEquals(23.0,FFtupple.v[0],format('init(%f,%f).v[0]',[23.0,17.0]));
 CheckEquals(17.0,FFtupple.v[1],format('init(%f,%f).v[1]',[23.0,17.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('init(%f,%f)',[x1,y1]));
     CheckEquals(x1,FFtupple.x,format('init(%f,%f).x',[x1,y1]));
     CheckEquals(y1,FFtupple.y,format('init(%f,%f).y',[x1,y1]));
     CheckEquals(x1,FFtupple.v[0],format('init(%f,%f).v[0]',[x1,y1]));
     CheckEquals(y1,FFtupple.v[1],format('init(%f,%f).v[1]',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestInitLenDir;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
begin
 FFtupple.InitLenDir(0,0);
 CheckEquals(ZeroTup,FFtupple,1e-20,'InitLenDir(0,0)');
// Check Well Known Values
 FFtupple.InitLenDir(1.0,0.0);
 CheckEquals(FTuple(1.0,0.0),FFtupple,1e-15,'InitLenDir(1.0,0.)');
 FFtupple.InitLenDir(1.0, pi/6);  // 30°
 CheckEquals(FTuple(sqrt(3/4),0.5),FFtupple,1e-15,'InitLenDir(0.866,0.5)');
 CheckEquals(sqrt(3/4),FFtupple.v[0],1e-15,format('InitLenDir(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(0.5,FFtupple.v[1],1e-15,format('InitLenDir(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.InitLenDir(sqrt(2),pi/4);    // 45°
 CheckEquals(FTuple(1.0,1.0),FFtupple,1e-15,'InitLenDir(1.0,1.0)');
 FFtupple.InitLenDir(1.0,pi/3); // 60°
 CheckEquals(FTuple(0.5,sqrt(3/4)),FFtupple,1e-15,'InitLenDir(0.5,0.866)');
 FFtupple.InitLenDir(1.0,pi/2);  // 90°
 CheckEquals(FTuple(0.0,1.0),FFtupple,1e-15,'InitLenDir(0.0,1.0)');
 FFtupple.InitLenDir(1.0,2*pi/3); // 120°
 CheckEquals(FTuple(-0.5,sqrt(3/4)),FFtupple,1e-15,'InitLenDir(-0.5,0.866)');
 FFtupple.InitLenDir(sqrt(2),3*pi/4);  // 135°
 CheckEquals(FTuple(-1.0,1.0),FFtupple,1e-15,'InitLenDir(-1.0,1.0)');
 FFtupple.InitLenDir(1.0,5*pi/6); // 150°
 CheckEquals(FTuple(-sqrt(3/4),0.5),FFtupple,1e-15,'InitLenDir(-0.866,0.5)');
 FFtupple.InitLenDir(1.0,pi);  // 180°
 CheckEquals(FTuple(-1.0,0.0),FFtupple,1e-15,'InitLenDir(-1.0,0.0)');
 FFtupple.InitLenDir(1.0,-5*pi/6);  // -150°
 CheckEquals(FTuple(-sqrt(3/4),-0.5),FFtupple,1e-15,'InitLenDir(-0.866,-0.5)');
 FFtupple.InitLenDir(sqrt(2.0),-3*pi/4);  // -135°
 CheckEquals(FTuple(-1.0,-1.0),FFtupple,1e-15,'InitLenDir(-1.0,-1.0)');
 FFtupple.InitLenDir(1.0,-2*pi/3); // -120°
 CheckEquals(FTuple(-0.5,-sqrt(3/4)),FFtupple,1e-15,'InitLenDir(-0.5,-0.866)');
 FFtupple.InitLenDir(1.0,-pi/2);  // -90°
 CheckEquals(FTuple(0.0,-1.0),FFtupple,1e-15,'InitLenDir(0.0,-1.0)');
 FFtupple.InitLenDir(1.0,-pi/3); // -60°
 CheckEquals(FTuple(0.5,-sqrt(3/4)),FFtupple,1e-15,'InitLenDir(0.5,-0.866)');
 FFtupple.InitLenDir(sqrt(2.0),-pi/4);    // -45°
 CheckEquals(FTuple(1.0,-1.0),FFtupple,1e-15,'InitLenDir(1.0,-1.0)');
 FFtupple.InitLenDir(1.0,-pi/6);  // -30°
 CheckEquals(FTuple(sqrt(3/4),-0.5),FFtupple,1e-15,'InitLenDir(0.866,-0.5)');
// Some other Values
 FFtupple.InitLenDir(sqrt(818.0),0.636508215787951);
 CheckEquals(FTuple(23.0,17.0),FFtupple,1e-14,'InitLenDir(23.0,17.0)');
 FFtupple.InitLenDir(sqrt(818.0),pi-0.636508215787951);
 CheckEquals(FTuple(-23.0,17.0),FFtupple,1e-14,'InitLenDir(-23.0,17.0)');
 FFtupple.InitLenDir(sqrt(458.0),0.917949695694122);
 CheckEquals(FTuple(13.0,17.0),FFtupple,1e-14,'InitLenDir(13.0,17.0)');
 FFtupple.InitLenDir(sqrt(458.0),-pi+0.917949695694122);
 CheckEquals(FTuple(-13.0,-17.0),FFtupple,1e-14,'InitLenDir(-13.0,-17.0)');
 for i := 0 to 50000 do
   begin
     y2:= (random-0.5)*pi*2;
     x2:= (random+1e-15)*maxLongint;
     x1:= cos(y2)*x2;
     y1:= sin(y2)*x2;;
     FFtupple.InitLenDir(x2,y2);
     lFTupple.Init(x1,y1);
     CheckEquals(lFTupple,FFtupple,1e-15,format('InitLenDir(%f,%f)',[x1,y1]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestOpAssign;

var
  i: Integer;
  x1, y1: Extended;
begin
 CheckEquals(FTuple(0,0),ZeroTup,1e-20,'ZeroTup');
 FFtupple:=VarArrayOf([0.0,0.0]);
 CheckEquals(FTuple(0,0),FFtupple,1e-20,'init(0,0)');
 FFtupple:=VarArrayOf([1.0,-1.0]);
 CheckEquals(FTuple(1.0,-1.0),FFtupple,1e-20,'init(1.0,-1.0)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple:=VarArrayOf([23.0,17.0]);
 CheckEquals(FTuple(23.0,17.0),FFtupple,1e-20,'init(23.0,17.0)');
 CheckEquals(23.0,FFtupple.v[0],format('init(%f,%f).v[0]',[23.0,17.0]));
 CheckEquals(17.0,FFtupple.v[1],format('init(%f,%f).v[1]',[23.0,17.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     FFtupple:=VarArrayOf([x1,y1]);
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('init(%f,%f)',[x1,y1]));
     CheckEquals(x1,FFtupple.x,format('init(%f,%f).x',[x1,y1]));
     CheckEquals(y1,FFtupple.y,format('init(%f,%f).y',[x1,y1]));
     CheckEquals(x1,FFtupple.v[0],format('init(%f,%f).v[0]',[x1,y1]));
     CheckEquals(y1,FFtupple.v[1],format('init(%f,%f).v[1]',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestSum;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
begin
 CheckEquals(FTuple(0,0),ZeroTup.Sum(ZeroTup),1e-20,'ZeroTup + ZeroTup');
 FFtupple.init(0,0);
 CheckEquals(FTuple(0,0),FFtupple.Sum(ZeroTup),1e-20,'init(0,0) + ZeroTup');
 FFtupple.init(1.0,-1.0);
 CheckEquals(FTuple(3.0,-3.0),FFtupple.Sum(FTuple(2.0,-2.0)),1e-20,'init(1.0,-1.0).add(<2,-2>)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(FTuple(26.0,14.0),FFtupple.Sum(FTuple(3.0,-3.0)),1e-20,'init(23.0,17.0).add(<-3,3)');
 CheckEquals(26.0,FFtupple.Sum(FTuple(3.0,-3.0)).v[0],format('init(%f,%f).v[0]',[23.0,17.0]));
 CheckEquals(14.0,FFtupple.Sum(FTuple(3.0,-3.0)).v[1],format('init(%f,%f).v[1]',[23.0,17.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     lFTupple.INit(x2,y2);
     CheckEquals(FTuple(x1+x2,y1+y2),FFtupple.Sum(lFTupple),1e-20,format('init(%f,%f).add(%f,%f)',[x1,y1,x2,y2]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestOpPlus;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
begin
 CheckEquals(FTuple(0,0),ZeroTup + ZeroTup,1e-20,'ZeroTup + ZeroTup');
 FFtupple.init(0,0);
 CheckEquals(FTuple(0,0),FFtupple+ ZeroTup,1e-20,'init(0,0) + ZeroTup');
 FFtupple.init(1.0,-1.0);
 CheckEquals(FTuple(3.0,-3.0),FFtupple + FTuple(2.0,-2.0),1e-20,'init(1.0,-1.0).add(<2,-2>)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(FTuple(26.0,14.0),FFtupple + FTuple(3.0,-3.0),1e-20,'init(23.0,17.0).add(<-3,3)');
 CheckEquals(26.0,FFtupple.Sum(FTuple(3.0,-3.0)).v[0],format('init(%f,%f).v[0]',[23.0,17.0]));
 CheckEquals(14.0,FFtupple.Sum(FTuple(3.0,-3.0)).v[1],format('init(%f,%f).v[1]',[23.0,17.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     lFTupple.INit(x2,y2);
     CheckEquals(FTuple(x1+x2,y1+y2),FFtupple +lFTupple,1e-20,format('init(%f,%f).add(%f,%f)',[x1,y1,x2,y2]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;

end;

procedure TTestRenderBase.TestAdd;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
begin
 CheckEquals(FTuple(0,0),ZeroTup.Add(ZeroTup),1e-20,'ZeroTup + ZeroTup');
 FFtupple.init(0,0);
 CheckEquals(FTuple(0,0),FFtupple.Add(ZeroTup),1e-20,'init(0,0) + ZeroTup');
 FFtupple.init(1.0,-1.0);
 CheckEquals(FTuple(3.0,-3.0),FFtupple.Add(FTuple(2.0,-2.0)),1e-20,'init(1.0,-1.0).add(<2,-2>)');
 CheckEquals(3.0,FFtupple.x,format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-3.0,FFtupple.y,format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(FTuple(26.0,14.0),FFtupple.Add(FTuple(3.0,-3.0)),1e-20,'init(23.0,17.0).add(<-3,3)');
 CheckEquals(26.0,FFtupple.v[0],format('init(%f,%f).v[0]',[23.0,17.0]));
 CheckEquals(14.0,FFtupple.v[1],format('init(%f,%f).v[1]',[23.0,17.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     lFTupple.INit(x2,y2);
     CheckEquals(FTuple(x1+x2,y1+y2),FFtupple.Add(lFTupple),1e-20,format('init(%f,%f).add(%f,%f)',[x1,y1,x2,y2]));
     CheckEquals(FTuple(x1+x2,y1+y2),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1+x2,y1+y2]));
   end;
end;

procedure TTestRenderBase.TestSubt;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
begin
 CheckEquals(FTuple(0,0),ZeroTup.Subt(ZeroTup),1e-20,'ZeroTup - ZeroTup');
 FFtupple.init(0,0);
 CheckEquals(FTuple(0,0),FFtupple.Subt(ZeroTup),1e-20,'init(0,0) - ZeroTup');
 FFtupple.init(1.0,-1.0);
 CheckEquals(FTuple(-1.0,1.0),FFtupple.Subt(FTuple(2.0,-2.0)),1e-20,'init(1.0,-1.0).Subt(<2,-2>)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(FTuple(20.0,20.0),FFtupple.Subt(FTuple(3.0,-3.0)),1e-20,'init(23.0,17.0).Subt(<-3,3)');
 CheckEquals(20.0,FFtupple.Subt(FTuple(3.0,-3.0)).v[0],format('init(%f,%f).v[0]',[23.0,17.0]));
 CheckEquals(20.0,FFtupple.Subt(FTuple(3.0,-3.0)).v[1],format('init(%f,%f).v[1]',[23.0,17.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     lFTupple.INit(x2,y2);
     CheckEquals(FTuple(x1-x2,y1-y2),FFtupple.Subt(lFTupple),1e-20,format('init(%f,%f).Subt(%f,%f)',[x1,y1,x2,y2]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestOpMinus;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
begin
 CheckEquals(FTuple(0,0),ZeroTup-ZeroTup,1e-20,'ZeroTup - ZeroTup');
 FFtupple.init(0,0);
 CheckEquals(FTuple(0,0),FFtupple-ZeroTup,1e-20,'init(0,0) - ZeroTup');
 FFtupple.init(1.0,-1.0);
 CheckEquals(FTuple(-1.0,1.0),FFtupple-FTuple(2.0,-2.0),1e-20,'init(1.0,-1.0).Subt(<2,-2>)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(FTuple(20.0,20.0),FFtupple-FTuple(3.0,-3.0),1e-20,'init(23.0,17.0).Subt(<-3,3)');
 CheckEquals(20.0,FFtupple.Subt(FTuple(3.0,-3.0)).v[0],format('init(%f,%f).v[0]',[23.0,17.0]));
 CheckEquals(20.0,FFtupple.Subt(FTuple(3.0,-3.0)).v[1],format('init(%f,%f).v[1]',[23.0,17.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     lFTupple.INit(x2,y2);
     CheckEquals(FTuple(x1-x2,y1-y2),FFtupple-lFTupple,1e-20,format('init(%f,%f).Subt(%f,%f)',[x1,y1,x2,y2]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestSubtTo;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
begin
 CheckEquals(FTuple(0,0),ZeroTup.SubtTo(ZeroTup),1e-20,'ZeroTup - ZeroTup');
 FFtupple.init(0,0);
 CheckEquals(FTuple(0,0),FFtupple.SubtTo(ZeroTup),1e-20,'init(0,0) - ZeroTup');
 FFtupple.init(1.0,-1.0);
 CheckEquals(FTuple(-1.0,1.0),FFtupple.SubtTo(FTuple(2.0,-2.0)),1e-20,'init(1.0,-1.0).add(<2,-2>)');
 CheckEquals(-1.0,FFtupple.x,format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(1.0,FFtupple.y,format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(FTuple(20.0,20.0),FFtupple.SubtTo(FTuple(3.0,-3.0)),1e-20,'init(23.0,17.0).add(<-3,3)');
 CheckEquals(20.0,FFtupple.v[0],format('init(%f,%f).v[0]',[23.0,17.0]));
 CheckEquals(20.0,FFtupple.v[1],format('init(%f,%f).v[1]',[23.0,17.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     lFTupple.INit(x2,y2);
     CheckEquals(FTuple(x1-x2,y1-y2),FFtupple.SubtTo(lFTupple),1e-20,format('init(%f,%f).add(%f,%f)',[x1,y1,x2,y2]));
     CheckEquals(FTuple(x1-x2,y1-y2),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1+x2,y1+y2]));
   end;
end;

procedure TTestRenderBase.TestMul;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
begin
 CheckEquals(0.0,ZeroTup.Mul(ZeroTup),1e-20,'ZeroTup * ZeroTup');
 FFtupple.init(0,0);
 CheckEquals(0.0,FFtupple.Mul(ZeroTup),1e-20,'init(0,0) * ZeroTup');
 FFtupple.init(1.0,-1.0);
 CheckEquals(4.0,FFtupple.Mul(FTuple(2.0,-2.0)),1e-20,'init(1.0,-1.0).Mul(<2,-2>)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(18.0,FFtupple.Mul(FTuple(3.0,-3.0)),1e-20,'init(23.0,17.0).Mul(<3,-3)');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     lFTupple.INit(x2,y2);
     CheckEquals(x1*x2+y1*y2,FFtupple.Mul(lFTupple),1e-20,format('init(%f,%f).Mul(%f,%f)',[x1,y1,x2,y2]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestOpMul;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
begin
 CheckEquals(0.0,ZeroTup*ZeroTup,1e-20,'ZeroTup * ZeroTup');
 FFtupple.init(0,0);
 CheckEquals(0.0,FFtupple*ZeroTup,1e-20,'init(0,0) * ZeroTup');
 FFtupple.init(1.0,-1.0);
 CheckEquals(4.0,FFtupple*FTuple(2.0,-2.0),1e-20,'init(1.0,-1.0).Mul(<2,-2>)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(18.0,FFtupple*FTuple(3.0,-3.0),1e-20,'init(23.0,17.0).Mul(<3,-3)');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     lFTupple.INit(x2,y2);
     CheckEquals(x1*x2+y1*y2,FFtupple*lFTupple,1e-20,format('init(%f,%f).Mul(%f,%f)',[x1,y1,x2,y2]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestMul2;
var
  x1, y1,x2: Extended;
  i: Integer;
//  lFTupple:TFTuple;
begin
 CheckEquals(FTuple(0,0),ZeroTup.Mul(0.0),1e-20,'ZeroTup * ZeroTup');
 FFtupple.init(0,0);
 CheckEquals(FTuple(0,0),FFtupple.Mul(1.0),1e-20,'init(0,0) * ZeroTup');
 FFtupple.init(1.0,-1.0);
 CheckEquals(FTuple(2.0,-2.0),FFtupple.Mul(2.0),1e-20,'init(1.0,-1.0).Mul(2.0)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(FTuple(-69.0,-51.0),FFtupple.Mul(-3.0),1e-20,'init(23.0,17.0).Mul(-3.0)');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     CheckEquals(FTuple(x1*x2,y1*x2),FFtupple.Mul(X2),1e-20,format('init(%f,%f).Mul(%f)',[x1,y1,x2]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestOpMul2;
var
  x1, y1,x2: Extended;
  i: Integer;
//  lFTupple:TFTuple;
begin
 CheckEquals(FTuple(0,0),ZeroTup*0.0,1e-20,'ZeroTup * ZeroTup');
 FFtupple.init(0,0);
 CheckEquals(FTuple(0,0),FFtupple*1.0,1e-20,'init(0,0) * ZeroTup');
 FFtupple.init(1.0,-1.0);
 CheckEquals(FTuple(2.0,-2.0),FFtupple*2.0,1e-20,'init(1.0,-1.0).Mul(2.0)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(FTuple(-69.0,-51.0),FFtupple*-3.0,1e-20,'init(23.0,17.0).Mul(-3.0)');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     CheckEquals(FTuple(x1*x2,y1*x2),FFtupple*X2,1e-20,format('init(%f,%f).Mul(%f)',[x1,y1,x2]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestOpMul3;
var
  x1, y1,x2: Extended;
  i: Integer;
//  lFTupple:TFTuple;
begin
 CheckEquals(FTuple(0,0),0.0*ZeroTup,1e-20,'ZeroTup * ZeroTup');
 FFtupple.init(0,0);
 CheckEquals(FTuple(0,0),1.0*FFtupple,1e-20,'init(0,0) * ZeroTup');
 FFtupple.init(1.0,-1.0);
 CheckEquals(FTuple(2.0,-2.0),2.0*FFtupple,1e-20,'init(1.0,-1.0).Mul(2.0)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(FTuple(-69.0,-51.0),-3.0*FFtupple,1e-20,'init(23.0,17.0).Mul(-3.0)');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     CheckEquals(FTuple(x1*x2,y1*x2),X2*FFtupple,1e-20,format('init(%f,%f).Mul(%f)',[x1,y1,x2]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestDivide;
var
  x1, y1,x2: Extended;
  i: Integer;
//  lFTupple:TFTuple;
begin
 CheckEquals(FTuple(0,0),ZeroTup.Divide(1.0),1e-20,'ZeroTup * ZeroTup');
 FFtupple.init(0,0);
 CheckEquals(FTuple(0,0),FFtupple.Divide(1.0),1e-20,'init(0,0) * ZeroTup');
 FFtupple.init(1.0,-1.0);
 CheckEquals(FTuple(0.5,-0.5),FFtupple.Divide(2.0),1e-20,'init(1.0,-1.0).Divide(2.0)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(-69.0,-51.0);
 CheckEquals(FTuple(23.0,17.0),FFtupple.Divide(-3.0),1e-20,'init(-69.0,-51.0).Divide(-3.0)');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:=0.0;
     while x2 = 0.0 do
     x2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     CheckEquals(FTuple(x1/x2,y1/x2),FFtupple.Divide(X2),1e-20,format('init(%f,%f).Divide(%f)',[x1,y1,x2]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestOpDivide;
var
  x1, y1,x2: Extended;
  i: Integer;
//  lFTupple:TFTuple;
begin
 CheckEquals(FTuple(0,0),ZeroTup/1.0,1e-20,'ZeroTup * ZeroTup');
 FFtupple.init(0,0);
 CheckEquals(FTuple(0,0),FFtupple/1.0,1e-20,'init(0,0) * ZeroTup');
 FFtupple.init(1.0,-1.0);
 CheckEquals(FTuple(0.5,-0.5),FFtupple/2.0,1e-20,'init(1.0,-1.0).Divide(2.0)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(-69.0,-51.0);
 CheckEquals(FTuple(23.0,17.0),FFtupple/-3.0,1e-20,'init(-69.0,-51.0).Divide(-3.0)');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:=0.0;
     while x2 = 0.0 do
     x2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     CheckEquals(FTuple(x1/x2,y1/x2),FFtupple/X2,1e-20,format('init(%f,%f).Divide(%f)',[x1,y1,x2]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestVMul;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
begin
 CheckEquals(FTuple(0,0),ZeroTup.VMul(ZeroTup),1e-20,'ZeroTup x ZeroTup');
 FFtupple.init(0,0);
 CheckEquals(FTuple(0,0),FFtupple.VMul(ZeroTup),1e-20,'init(0,0) x ZeroTup');
 FFtupple.init(1.0,-1.0);
 CheckEquals(FTuple(0.0,-4.0),FFtupple.VMul(FTuple(2.0,-2.0)),1e-20,'init(1.0,-1.0).VMul(<2,-2>)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(FTuple(120.0,-18.0),FFtupple.VMul(FTuple(3.0,-3.0)),1e-20,'init(23.0,17.0).VMul(<-3,3)');
 CheckEquals(120.0,FFtupple.VMul(FTuple(3.0,-3.0)).v[0],format('init(%f,%f).v[0]',[23.0,17.0]));
 CheckEquals(-18.0,FFtupple.VMul(FTuple(3.0,-3.0)).v[1],format('init(%f,%f).v[1]',[23.0,17.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     lFTupple.INit(x2,y2);
     CheckEquals(FTuple(x1*x2-y1*y2,x2*y1+y2*x1),FFtupple.VMul(lFTupple),1e-20,format('init(%f,%f).VMul(%f,%f)',[x1,y1,x2,y2]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestEquals;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
begin
 CheckEquals(true,ZeroTup.Equals(ZeroTup,1e-20),'ZeroTup = ZeroTup');
 FFtupple.init(0,0);
 CheckEquals(true,FFtupple.Equals(ZeroTup,1e-20),'init(0,0) = ZeroTup');
 FFtupple.init(1.0,-1.0);
 CheckEquals(false,FFtupple.Equals(FTuple(2.0,-2.0),1e-20),'init(1.0,-1.0).Equals(<2,-2>)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(false,FFtupple.Equals(FTuple(3.0,-3.0),1e-20),'init(23.0,17.0).Equals(<-3,3>)');
 FFtupple.init(23.0,17.0);
 CheckEquals(false,FFtupple.Equals(FTuple(23.0,-3.0),1e-20),'init(23.0,17.0).Equals(<23,3>)');
 FFtupple.init(23.0,17.0);
 CheckEquals(false,FFtupple.Equals(FTuple(3.0,17.0),1e-20),'init(23.0,17.0).Equals(<-3,17>)');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     if random >0.5 then
       begin
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
       end
     else
       begin
         x2:=x1;
         y2:=y1;
       end;
     FFtupple.init(x1,y1);
     lFTupple.INit(x2,y2);
     CheckEquals((abs(x1-x2)<1e-20) and (abs(y1-y2)<1e-20),FFtupple.Equals(lFTupple,1e-20),format('init(%f,%f).Equals(%f,%f)',[x1,y1,x2,y2]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestOpEquals;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
begin
 CheckEquals(true,ZeroTup=ZeroTup,'ZeroTup = ZeroTup');
 FFtupple.init(0,0);
 CheckEquals(true,FFtupple=ZeroTup,'init(0,0) = ZeroTup');
 FFtupple.init(1.0,-1.0);
 CheckEquals(false,FFtupple=FTuple(2.0,-2.0),'init(1.0,-1.0)=(<2,-2>)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(false,FFtupple=FTuple(3.0,-3.0),'init(23.0,17.0)=(<-3,3>)');
 FFtupple.init(23.0,17.0);
 CheckEquals(false,FFtupple=FTuple(23.0,-3.0),'init(23.0,17.0)=(<23,3>)');
 FFtupple.init(23.0,17.0);
 CheckEquals(false,FFtupple=FTuple(3.0,17.0),'init(23.0,17.0)=(<-3,17>)');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     if random >0.5 then
       begin
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
       end
     else
       begin
         x2:=x1;
         y2:=y1;
       end;
     FFtupple.init(x1,y1);
     lFTupple.INit(x2,y2);
     CheckEquals((abs(x1-x2)<1e-20) and (abs(y1-y2)<1e-20),FFtupple=lFTupple,format('init(%f,%f).Equals(%f,%f)',[x1,y1,x2,y2]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestCopy;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
//  lFTupple:TFTuple;
begin
 CheckEquals(FTuple(0,0),ZeroTup.Copy(0,0),1e-20,'0,0 x 0,0');
 FFtupple.init(0,0);
 CheckEquals(FTuple(0,0),FFtupple.Copy(0,0),1e-20,'init(0,0) x 0,0');
 FFtupple.init(1.0,-1.0);
 CheckEquals(FTuple(2.0,-2.0),FFtupple.Copy(2.0,-2.0),1e-20,'init(1.0,-1.0).Copy(<2,-2>)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(FTuple(3.0,-3.0),FFtupple.Copy(3.0,-3.0),1e-20,'init(23.0,17.0).Copy(<3,-3)');
 CheckEquals(3.0,FFtupple.Copy(3.0,-3.0).v[0],format('init(%f,%f).v[0]',[23.0,17.0]));
 CheckEquals(-3.0,FFtupple.Copy(3.0,-3.0).v[1],format('init(%f,%f).v[1]',[23.0,17.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
//     lFTupple.INit(x2,y2);
     CheckEquals(FTuple(x2,y2),FFtupple.Copy(x2,y2),1e-20,format('init(%f,%f).Copy(%f,%f)',[x1,y1,x2,y2]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestCopy2;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
begin
 CheckEquals(FTuple(0,0),ZeroTup.Copy(FTuple(0,0)),1e-20,'0,0 x 0,0');
 FFtupple.init(0,0);
 CheckEquals(FTuple(0,0),FFtupple.Copy(FTuple(0,0)),1e-20,'init(0,0) x 0,0');
 FFtupple.init(1.0,-1.0);
 CheckEquals(FTuple(2.0,-2.0),FFtupple.Copy(FTuple(2.0,-2.0)),1e-20,'init(1.0,-1.0).Copy(<2,-2>)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(FTuple(3.0,-3.0),FFtupple.Copy(FTuple(3.0,-3.0)),1e-20,'init(23.0,17.0).Copy(<3,-3>)');
 CheckEquals(3.0,FFtupple.Copy(FTuple(3.0,-3.0)).v[0],format('init(%f,%f).v[0]',[23.0,17.0]));
 CheckEquals(-3.0,FFtupple.Copy(FTuple(3.0,-3.0)).v[1],format('init(%f,%f).v[1]',[23.0,17.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     lFTupple.INit(x2,y2);
     CheckEquals(FTuple(x2,y2),FFtupple.Copy(lFTupple),1e-20,format('init(%f,%f).Copy(<%f,%f>)',[x1,y1,x2,y2]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestCopy3;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
begin
 CheckEquals(FTuple(0,0),ZeroTup.Copy,1e-20,'0,0 x 0,0');
 FFtupple.init(0,0);
 CheckEquals(FTuple(0,0),FFtupple.Copy,1e-20,'init(0,0) x 0,0');
 FFtupple.init(1.0,-1.0);
 CheckEquals(FTuple(1.0,-1.0),FFtupple.Copy,1e-20,'init(1.0,-1.0).Copy(<2,-2>)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(FTuple(23.0,17.0),FFtupple.Copy,1e-20,'init(23.0,17.0).Copy(<3,-3>)');
 CheckEquals(23.0,FFtupple.Copy.v[0],format('init(%f,%f).v[0]',[23.0,17.0]));
 CheckEquals(17.0,FFtupple.Copy.v[1],format('init(%f,%f).v[1]',[23.0,17.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     lFTupple.INit(x2,y2);
     CheckEquals(FTuple(x1,y1),FFtupple.Copy,1e-20,format('init(%f,%f).Copy',[x1,y1]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestGLen;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
begin
 CheckEquals(0.0,ZeroTup.GLen,1e-20,'ZeroTup.GLen');
 FFtupple.init(0,0);
 CheckEquals(0.0,FFtupple.GLen,1e-20,'init(0,0).GLen');
 FFtupple.init(1.0,-1.0);
 CheckEquals(Sqrt(2.0),FFtupple.GLen,1e-20,'init(1.0,-1.0).GLen');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(sqrt(818.0),FFtupple.GLen,1e-20,'init(23.0,17.0).GLen');
 FFtupple.init(-23.0,17.0);
 CheckEquals(sqrt(818.0),FFtupple.GLen,1e-20,'init(-23.0,17.0).GLen');
 FFtupple.init(13.0,17.0);
 CheckEquals(sqrt(458.0),FFtupple.GLen,1e-20,'init(13.0,17.0).GLen');
 FFtupple.init(-13.0,-17.0);
 CheckEquals(sqrt(458.0),FFtupple.GLen,1e-20,'init(-13.0,-17.0).GLen');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     lFTupple.INit(x2,y2);
     CheckEquals(sqrt(sqr(x1)+sqr(y1)),FFtupple.GLen,1e-20,format('init(%f,%f).GLen',[x1,y1]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestFktAbs;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
begin
 CheckEquals(0.0,abs(ZeroTup),1e-20,'ZeroTup.GLen');
 FFtupple.init(0,0);
 CheckEquals(0.0,abs(FFtupple),1e-20,'init(0,0).GLen');
 FFtupple.init(1.0,-1.0);
 CheckEquals(Sqrt(2.0),abs(FFtupple),1e-20,'init(1.0,-1.0).GLen');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(sqrt(818.0),abs(FFtupple),1e-20,'init(23.0,17.0).GLen');
 FFtupple.init(-23.0,17.0);
 CheckEquals(sqrt(818.0),abs(FFtupple),1e-20,'init(-23.0,17.0).GLen');
 FFtupple.init(13.0,17.0);
 CheckEquals(sqrt(458.0),abs(FFtupple),1e-20,'init(13.0,17.0).GLen');
 FFtupple.init(-13.0,-17.0);
 CheckEquals(sqrt(458.0),abs(FFtupple),1e-20,'init(-13.0,-17.0).GLen');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     lFTupple.INit(x2,y2);
     CheckEquals(sqrt(sqr(x1)+sqr(y1)),abs(FFtupple),1e-20,format('init(%f,%f).GLen',[x1,y1]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestGDir;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
begin
 CheckEquals(0.0,ZeroTup.GDir,1e-20,'ZeroTup.GDir');
 FFtupple.init(0,0);
 CheckEquals(0.0,FFtupple.GDir,1e-20,'init(0,0).GDir');
// Check Well Known Values
 FFtupple.init(1.0,0.0);
 CheckEquals(0.0,FFtupple.GDir,1e-15,'init(1.0,0.0).GDir');
 FFtupple.init(sqrt(3/4),0.5);  // 30°
 CheckEquals(pi/6,FFtupple.GDir,1e-15,'init(0.866,0.5).GDir');
 CheckEquals(sqrt(3/4),FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(0.5,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(1.0,1.0);    // 45°
 CheckEquals(pi/4,FFtupple.GDir,1e-15,'init(1.0,1.0).GDir');
 FFtupple.init(0.5,sqrt(3/4)); // 60°
 CheckEquals(pi/3,FFtupple.GDir,1e-15,'init(0.5,0.866).GDir');
 FFtupple.init(0.0,1.0);  // 90°
 CheckEquals(pi/2,FFtupple.GDir,1e-15,'init(0.0,1.0).GDir');
 FFtupple.init(-0.5,sqrt(3/4)); // 120°
 CheckEquals(2*pi/3,FFtupple.GDir,1e-15,'init(-0.5,0.866).GDir');
 FFtupple.init(-1.0,1.0);  // 135°
 CheckEquals(3*pi/4,FFtupple.GDir,1e-15,'init(-1.0,1.0).GDir');
 FFtupple.init(-sqrt(3/4),0.5); // 150°
 CheckEquals(5*pi/6,FFtupple.GDir,1e-15,'init(-0.866,0.5).GDir');
 FFtupple.init(-1.0,0.0);  // 180°
 CheckEquals(pi,FFtupple.GDir,1e-15,'init(-1.0,0.0).GDir');
 FFtupple.init(-sqrt(3/4),-0.5);  // -150°
 CheckEquals(-5*pi/6,FFtupple.GDir,1e-15,'init(-0.866,-0.5).GDir');
 FFtupple.init(-1.0,-1.0);  // -135°
 CheckEquals(-3*pi/4,FFtupple.GDir,1e-15,'init(-1.0,-1.0).GDir');
 FFtupple.init(-0.5,-sqrt(3/4)); // -120°
 CheckEquals(-2*pi/3,FFtupple.GDir,1e-15,'init(-0.5,-0.866).GDir');
 FFtupple.init(0.0,-1.0);  // -90°
 CheckEquals(-pi/2,FFtupple.GDir,1e-15,'init(0.0,-1.0).GDir');
 FFtupple.init(0.5,-sqrt(3/4)); // -60°
 CheckEquals(-pi/3,FFtupple.GDir,1e-15,'init(0.5,-0.866).GDir');
 FFtupple.init(1.0,-1.0);    // -45°
 CheckEquals(-pi/4,FFtupple.GDir,1e-15,'init(1.0,-1.0).GDir');
 FFtupple.init(sqrt(3/4),-0.5);  // -30°
 CheckEquals(-pi/6,FFtupple.GDir,1e-15,'init(0.866,-0.5).GDir');
// Some other Values
 FFtupple.init(23.0,17.0);
 CheckEquals(0.636508215787951,FFtupple.GDir,1e-15,'init(23.0,17.0).GDir');
 FFtupple.init(-23.0,17.0);
 CheckEquals(pi-0.636508215787951,FFtupple.GDir,1e-15,'init(-23.0,17.0).GDir');
 FFtupple.init(13.0,17.0);
 CheckEquals(0.917949695694122,FFtupple.GDir,1e-15,'init(13.0,17.0).GDir');
 FFtupple.init(-13.0,-17.0);
 CheckEquals(-pi+0.917949695694122,FFtupple.GDir,1e-15,'init(-13.0,-17.0).GDir');
 for i := 0 to 50000 do
   begin
     y2:= (random-0.5)*pi*2;
     x2:= (random+1e-15)*maxLongint;
     x1:= cos(y2)*x2;
     y1:= sin(y2)*x2;;
     FFtupple.init(x1,y1);
     lFTupple.INit(x2,y2);
     CheckEquals(y2,FFtupple.GDir,1e-15,format('init(%f,%f).GDir',[x1,y1]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestMLen;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
begin
 CheckEquals(0.0,ZeroTup.MLen,1e-20,'ZeroTup.MLen');
 FFtupple.init(0,0);
 CheckEquals(0.0,FFtupple.MLen,1e-20,'init(0,0).MLen');
 FFtupple.init(1.0,-1.0);
 CheckEquals(1.0,FFtupple.MLen,1e-20,'init(1.0,-1.0).MLen');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(23.0,FFtupple.MLen,1e-20,'init(23.0,17.0).MLen');
 FFtupple.init(-23.0,17.0);
 CheckEquals(23.0,FFtupple.MLen,1e-20,'init(-23.0,17.0).MLen');
 FFtupple.init(13.0,17.0);
 CheckEquals(17.0,FFtupple.MLen,1e-20,'init(13.0,17.0).MLen');
 FFtupple.init(-13.0,-17.0);
 CheckEquals(17.0,FFtupple.MLen,1e-20,'init(-13.0,-17.0).MLen');
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     lFTupple.INit(x2,y2);
     CheckEquals(max(abs(x1),abs(y1)),FFtupple.MLen,1e-20,format('init(%f,%f).MLen',[x1,y1]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.CheckEquals(const Exp, Act: TFTuple;eps:extended; Msg: String);
begin
  CheckEquals(exp.X,act.X,eps,Msg+'[X]');
  CheckEquals(exp.Y,act.Y,eps,Msg+'[Y]');
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

