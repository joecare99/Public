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
    Procedure TestAddTo;
    Procedure TestSubt;
    Procedure TestSubtTo;
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
 CheckEquals(FTuple(3.0,-3.0),FFtupple.add(FTuple(2.0,-2.0)),1e-20,'init(1.0,-1.0).add(<2,-2>)');
 CheckEquals(1.0,FFtupple.v[0],format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-1.0,FFtupple.v[1],format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(FTuple(26.0,14.0),FFtupple.add(FTuple(3.0,-3.0)),1e-20,'init(23.0,17.0).add(<-3,3)');
 CheckEquals(26.0,FFtupple.Add(FTuple(3.0,-3.0)).v[0],format('init(%f,%f).v[0]',[23.0,17.0]));
 CheckEquals(14.0,FFtupple.Add(FTuple(3.0,-3.0)).v[1],format('init(%f,%f).v[1]',[23.0,17.0]));
 for i := 0 to 50000 do
   begin
     x1:= (random-0.5)*maxLongint;
     y1:= (random-0.5)*maxLongint;
     x2:= (random-0.5)*maxLongint;
     y2:= (random-0.5)*maxLongint;
     FFtupple.init(x1,y1);
     lFTupple.INit(x2,y2);
     CheckEquals(FTuple(x1+x2,y1+y2),FFtupple.Add(lFTupple),1e-20,format('init(%f,%f).add(%f,%f)',[x1,y1,x2,y2]));
     CheckEquals(FTuple(x1,y1),FFtupple,1e-20,format('FTupple=(%f,%f)',[x1,y1]));
   end;
end;

procedure TTestRenderBase.TestAddTo;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
begin
 CheckEquals(FTuple(0,0),ZeroTup.AddTo(ZeroTup),1e-20,'ZeroTup + ZeroTup');
 FFtupple.init(0,0);
 CheckEquals(FTuple(0,0),FFtupple.AddTo(ZeroTup),1e-20,'init(0,0) + ZeroTup');
 FFtupple.init(1.0,-1.0);
 CheckEquals(FTuple(3.0,-3.0),FFtupple.addTo(FTuple(2.0,-2.0)),1e-20,'init(1.0,-1.0).add(<2,-2>)');
 CheckEquals(3.0,FFtupple.x,format('init(%f,%f).v[0]',[1.0,-1.0]));
 CheckEquals(-3.0,FFtupple.y,format('init(%f,%f).v[1]',[1.0,-1.0]));
 FFtupple.init(23.0,17.0);
 CheckEquals(FTuple(26.0,14.0),FFtupple.addTo(FTuple(3.0,-3.0)),1e-20,'init(23.0,17.0).add(<-3,3)');
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
     CheckEquals(FTuple(x1+x2,y1+y2),FFtupple.Addto(lFTupple),1e-20,format('init(%f,%f).add(%f,%f)',[x1,y1,x2,y2]));
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

procedure TTestRenderBase.TestMul2;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
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

procedure TTestRenderBase.TestDivide;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
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

procedure TTestRenderBase.TestCopy;
var
  x1, y1,x2,y2: Extended;
  i: Integer;
  lFTupple:TFTuple;
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
begin

end;

procedure TTestRenderBase.TestCopy3;
begin

end;

procedure TTestRenderBase.TestGLen;
begin

end;

procedure TTestRenderBase.TestMLen;
begin

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

