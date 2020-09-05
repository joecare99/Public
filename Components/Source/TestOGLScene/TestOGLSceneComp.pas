unit TestOGLSceneComp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, Cmp_OpenGLScene;

type

  { TTestOGlSceneBase }

  TTestOGlSceneBase= class(TTestCase)
  private
    FDatapath: RawByteString;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    procedure CheckEqualPoint(exp, Act: TPointF; Msg: String=''; e: Double=1e-15);
    function RandomPoint(rMax:Double= 1.0):TPointF;
  public
    constructor Create; override;
  published
    procedure TestSetUp;virtual;
  end;

  { TTestOGlScenePoint }

  TTestOGlScenePoint= class(TTestOGlSceneBase)
  private
    procedure ExcStringtoVar;
    procedure ExcVarAr3t0Var;
  published
    procedure TestSetUp;override;
    Procedure TestPointF;
    Procedure TestConsts;
    Procedure TestNeg;
    Procedure TestAdd;
    Procedure TestSMult;
    Procedure TestRot90;
    Procedure TestEquals;
    Procedure TestAsVariant;
  end;

const
    TestFormatSettings : TFormatSettings = (
    CurrencyFormat: 1;
    NegCurrFormat: 5;
    ThousandSeparator: ',';
    DecimalSeparator: '.';
    CurrencyDecimals: 2;
    DateSeparator: '-';
    TimeSeparator: ':';
    ListSeparator: ',';
    CurrencyString: '$';
    ShortDateFormat: 'd/m/y';
    LongDateFormat: 'dd" "mmmm" "yyyy';
    TimeAMString: 'AM';
    TimePMString: 'PM';
    ShortTimeFormat: 'hh:nn';
    LongTimeFormat: 'hh:nn:ss' );


implementation
uses Unt_VariantProcs,variants;

const CDataPath ='data'+DirectorySeparator+'OGLScene';


{ TTestOGlScenePoint }

procedure TTestOGlScenePoint.ExcStringtoVar;
begin
   Zero.AsVariant := '1,2,3'
end;

procedure TTestOGlScenePoint.ExcVarAr3t0Var;
begin
   Zero.AsVariant:= VarArrayOf(['X',2,3]);
end;

procedure TTestOGlScenePoint.TestSetUp;
begin
  inherited TestSetUp;
end;

procedure TTestOGlScenePoint.TestPointF;
var
  lPnt: TPointF;
begin
  lPnt := PointF(0,1,2);
  AssertEquals('Test PointF.x',0.0,lPnt.x,1e-15);
  AssertEquals('Test PointF.y',1.0,lPnt.y,1e-15);
  AssertEquals('Test PointF.z',2.0,lPnt.z,1e-15);
  AssertEquals('Test PointF.d[0]',0.0,lPnt.d[0],1e-15);
  AssertEquals('Test PointF.d[1]',1.0,lPnt.d[1],1e-15);
  AssertEquals('Test PointF.d[2]',2.0,lPnt.d[2],1e-15);
  lPnt := PointF(3,2,1);
  AssertEquals('Test PointF2.x',3.0,lPnt.x,1e-15);
  AssertEquals('Test PointF2.y',2.0,lPnt.y,1e-15);
  AssertEquals('Test PointF2.z',1.0,lPnt.z,1e-15);
  AssertEquals('Test PointF2.d[0]',3.0,lPnt.d[0],1e-15);
  AssertEquals('Test PointF2.d[1]',2.0,lPnt.d[1],1e-15);
  AssertEquals('Test PointF2.d[2]',1.0,lPnt.d[2],1e-15);
  lPnt := PointF(-4,-1,-2);
  AssertEquals('Test PointF3.x',-4.0,lPnt.x,1e-15);
  AssertEquals('Test PointF3.y',-1.0,lPnt.y,1e-15);
  AssertEquals('Test PointF3.z',-2.0,lPnt.z,1e-15);
  AssertEquals('Test PointF3.d[0]',-4.0,lPnt.d[0],1e-15);
  AssertEquals('Test PointF3.d[1]',-1.0,lPnt.d[1],1e-15);
  AssertEquals('Test PointF3.d[2]',-2.0,lPnt.d[2],1e-15);
  //Todo: Testschleife;
end;

procedure TTestOGlScenePoint.TestConsts;
begin
  CheckEqualPoint(pointF(0,0,0),Zero,'Test Zero');
  CheckEqualPoint(pointF(1,0,0),eX,'Test eX');
  CheckEqualPoint(pointF(0,1,0),eY,'Test eY');
  CheckEqualPoint(pointF(0,0,1),eZ,'Test eZ');
end;

procedure TTestOGlScenePoint.TestNeg;
begin
  CheckEqualPoint(Zero.Neg,Zero,'TestNeg Zero');
  CheckEqualPoint(pointF(-1,0,0).Neg,eX,'TestNeg eX');
  CheckEqualPoint(pointF(0,-1,0).Neg,eY,'TestNeg eY');
  CheckEqualPoint(pointF(0,0,-1).Neg,eZ,'TestNeg eZ');
  //Todo: Testschleife;
end;

procedure TTestOGlScenePoint.TestAdd;
begin
  CheckEqualPoint(Zero.add(Zero),Zero,'TestNeg Zero');
  CheckEqualPoint(pointF(-1,0,0).add(eX),Zero,'TestAdd eX');
  CheckEqualPoint(pointF(0,-1,0).add(eY),Zero,'TestAdd eY');
  CheckEqualPoint(pointF(0,0,-1).Add(eZ),Zero,'TestAdd eZ');
  //Todo: Testschleife;
end;

procedure TTestOGlScenePoint.TestSMult;
begin
  // Neutrale Elemente
  CheckEqualPoint(Zero,Zero.SMult(1.0),'TestSMult (Zero * 1)');
  CheckEqualPoint(Zero,eX.SMult(0.0)  ,'TestSMult (eX * 0)');
  CheckEqualPoint(Zero,eY.SMult(0.0)  ,'TestSMult (eY * 0)');
  CheckEqualPoint(Zero,eZ.SMult(0.0)  ,'TestSMult (eZ * 0)');

  CheckEqualPoint(eX,eX.SMult(1.0),'TestSMult (eX * 1)');
  CheckEqualPoint(eY,eY.SMult(1.0),'TestSMult (eY * 1)');
  CheckEqualPoint(eZ,eZ.SMult(1.0),'TestSMult (eZ * 1)');

  CheckEqualPoint(eX,pointF(-1,0,0).SMult(-1.0),'TestSMult (-eX * -1)');
  CheckEqualPoint(eY,pointF(0,-1,0).SMult(-1.0),'TestSMult (-eY * -1)');
  CheckEqualPoint(eZ,pointF(0,0,-1).SMult(-1.0),'TestSMult (-eZ * -1)');

  //Todo: Testschleife;
end;

procedure TTestOGlScenePoint.TestRot90;
begin
  // Neutrale Elemente
  //  - Zero
  CheckEqualPoint(Zero,Zero.Rotxp90,'TestRotxp90 Zero');
  CheckEqualPoint(Zero,Zero.Rotxm90,'TestRotxm90 Zero');
  CheckEqualPoint(Zero,Zero.Rotyp90,'TestRotyp90 Zero');
  CheckEqualPoint(Zero,Zero.Rotym90,'TestRotym90 Zero');
  CheckEqualPoint(Zero,Zero.Rotzp90,'TestRotzp90 Zero');
  CheckEqualPoint(Zero,Zero.Rotzm90,'TestRotzm90 Zero');

  //  - Einheitsvektoren
  CheckEqualPoint(eX,eX.Rotxp90,'TestRotxp90 eX');
  CheckEqualPoint(eX,eX.Rotxm90,'TestRotxm90 eX');
  CheckEqualPoint(eY,eY.Rotyp90,'TestRotyp90 eY');
  CheckEqualPoint(eY,eY.Rotym90,'TestRotym90 eY');
  CheckEqualPoint(eZ,eZ.Rotzp90,'TestRotzp90 eZ');
  CheckEqualPoint(eZ,eZ.Rotzm90,'TestRotzm90 eZ');

  // Wohldefinierte Elemente (Einheitsvektoren)
  CheckEqualPoint(PointF(0,0,-1),eX.Rotyp90,'TestRotyp90 eX');
  CheckEqualPoint(ez            ,eX.Rotym90,'TestRotym90 eX');
  CheckEqualPoint(ey            ,eX.Rotzp90,'TestRotzp90 eX');
  CheckEqualPoint(PointF(0,-1,0),eX.Rotzm90,'TestRotzm90 eX');

  CheckEqualPoint(PointF(-1,0,0),eY.Rotzp90,'TestRotzp90 eY');
  CheckEqualPoint(ex            ,eY.Rotzm90,'TestRotzm90 eY');
  CheckEqualPoint(ez            ,eY.Rotxp90,'TestRotxp90 eY');
  CheckEqualPoint(PointF(0,0,-1),eY.Rotxm90,'TestRotxm90 eY');

  CheckEqualPoint(PointF(0,-1,0),eZ.Rotxp90,'TestRotxp90 eZ');
  CheckEqualPoint(ey            ,eZ.Rotxm90,'TestRotxm90 eZ');
  CheckEqualPoint(ex            ,eZ.Rotyp90,'TestRotyp90 eZ');
  CheckEqualPoint(PointF(-1,0,0),eZ.Rotym90,'TestRotym90 eZ');

end;

procedure TTestOGlScenePoint.TestEquals;
begin
  CheckEquals(true,Zero.Equals(Zero),'TestEquals Zero=Zero');
  CheckEquals(false,eX.Equals(Zero),'TestEquals eX=Zero');
  CheckEquals(false,eY.Equals(Zero),'TestEquals eY=Zero');
  CheckEquals(false,eZ.Equals(Zero),'TestEquals eZ=Zero');
  CheckEquals(false,eX.Equals(eY),'TestEquals eX=eY');
  CheckEquals(false,eY.Equals(eZ),'TestEquals eY=eZ');
  CheckEquals(false,eZ.Equals(eX),'TestEquals eZ=eX');
end;

procedure TTestOGlScenePoint.TestAsVariant;
var lPnt:TPointF;

begin
  CheckEquals('("PointF",("X",0,"Y",0,"Z",0))',Var2string(Zero.AsVariant,true),'Test Zero.AsVariant');
  CheckEquals('("PointF",("X",1,"Y",0,"Z",0))',Var2string(eX.AsVariant,true),'Test eX.AsVariant');
  CheckEquals('("PointF",("X",0,"Y",1,"Z",0))',Var2string(eY.AsVariant,true),'Test eY.AsVariant');
  CheckEquals('("PointF",("X",0,"Y",0,"Z",1))',Var2string(eZ.AsVariant,true),'Test eZ.AsVariant');
  lPnt.AsVariant := VarArrayOf(['X',0,'Y',0,'Z',0]);
  CheckEqualPoint(Zero,lPnt,'lPnt1.AsVariant := ...');
  lPnt.AsVariant := VarArrayOf(['z',1]);
  CheckEqualPoint(eZ,lPnt,'lPnt2.AsVariant := ...');
  lPnt.AsVariant := VarArrayOf(['X',2]);
  CheckEqualPoint(pointf(2,0,1),lPnt,'lPnt3.AsVariant := ...');
  lPnt.AsVariant := eY.AsVariant;
  CheckEqualPoint(eY,lPnt,'lPnt4.AsVariant := ...');
  CheckException(@ExcStringtoVar,Exception,'Illegal Value 1,2,3');
  CheckException(@ExcVarAr3t0Var,Exception,'Illegal VarArray');
end;

//"Test Zero.AsVariant" expected: <> but was: <("PointF",("X",0,"Y",0,"Z",0))>
{ TTestOGlSceneBase }

constructor TTestOGlSceneBase.Create;
var
  i: Integer;
begin
  inherited Create;
  FDatapath := ExtractFilePath(CDataPath);
  for i := 0 to 2 do
    if not DirectoryExists(FDatapath) then
      FDatapath := '..'+DirectorySeparator+FDatapath
    else
      break;
// Todo: Plan B if data-Dir not found
  if DirectoryExists(FDatapath) then
    begin
      FDatapath:= FDatapath+ExtractFileName(CDataPath);
      ForceDirectories(FDatapath);
    end;
end;

procedure TTestOGlSceneBase.SetUp;
begin
  // Nothing to do yet
end;

procedure TTestOGlSceneBase.TearDown;
begin
  // Nothing to do yet
end;

procedure TTestOGlSceneBase.CheckEqualPoint(exp, Act: TPointF; Msg: String='';e:Double=1e-15);
var
  lAddr: Pointer;
begin
  lAddr:= CallerAddr;
  AssertTrue(ComparisonMsg(Msg+'.x',FloatToStr(exp.x), FloatToStr(act.x)),abs(exp.x-act.x)<e,lAddr);
  AssertTrue(ComparisonMsg(Msg+'.y',FloatToStr(exp.y), FloatToStr(act.y)),abs(exp.y-act.y)<e,lAddr);
  AssertTrue(ComparisonMsg(Msg+'.z',FloatToStr(exp.z), FloatToStr(act.z)),abs(exp.z-act.z)<e,lAddr);
end;

function TTestOGlSceneBase.RandomPoint(rMax: Double): TPointF;
begin
  result := PointF(-rMax+Random*rMax*2.0,-rMax+Random*rMax*2.0,-rMax+Random*rMax*2.0);
end;

procedure TTestOGlSceneBase.TestSetUp;
begin
  CheckTrue(DirectoryExists(FDatapath));
end;


initialization

  RegisterTest('TTestOGlScene',TTestOGlScenePoint);
end.

