unit cls_Test2DIndex;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, cls_2dIndex, GraphMath;

type

  { TTest2DIndex }

  TTest2DIndex= class(TTestCase)
  private
    F2DIndex: TwoDIndex;
    FDataPath:string;
    FPointArray:array of TFloatPoint;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    procedure TestIndex;
    procedure TestMove;
  end;

implementation

procedure GetValProc(obj: Tobject; out val1, val2: double);
type pFloatPoint=^TFloatPoint;
begin
  val1 := PFloatPoint(obj)^.X;
  val2 := PFloatPoint(obj)^.Y;
end;

procedure TTest2DIndex.TestSetUp;
begin
  CheckNotNull(F2DIndex,'Object is created');
  CheckNotNull(Tobject(FPointArray),'Array is created');
end;

procedure TTest2DIndex.TestIndex;
var
  lList: TIndexArr;
  ix, i: Integer;

  // Only if RandSeed is set
const cix:array[0..4] of integer =(468,482,681,759,848);
begin
  lList := F2DIndex.GetList(0.5,0.5);
  // Only if RandSeed is set
  CheckEquals(4,high(lList),'Index of Points at (0.5,0.5)');
  i := 0;
  for ix in lList do
    begin
      Check(ix < 1000,'Index in Range');
      CheckEquals(0.5,FPointArray[ix].x ,0.1,'X-Offset');
      CheckEquals(0.5,FPointArray[ix].y ,0.1,'Y-Offset');
      // Only if RandSeed is set
      CheckEquals(cix[i],ix,'index[%d]'.Format([i]));
      inc(i);
    end;
  for i := 0 to 1000 do
    begin
      lList := F2DIndex.GetList(0.5*cos(i)+0.5,0.5*sin(i)+0.5);
      for ix in lList do
        begin
          Check(ix < 1000,'Index in Range');
          CheckEquals(0.5*cos(i)+0.5,FPointArray[ix].x ,0.1,'X-Offset');
          CheckEquals(0.5*sin(i)+0.5,FPointArray[ix].y ,0.1,'Y-Offset');
        end;
    end;
end;

procedure TTest2DIndex.TestMove;
var
  i, ix: Integer;
  lList: TIndexArr;

  // Only if RandSeed is set
const cix:array[0..3] of integer =(319,716,718,992);

begin
  for i := 0 to high(FPointArray) do
    begin
      FPointArray[i]:= FloatPoint(random,random);
      F2DIndex.MoveObject(TObject(@FPointArray[i]),i);
    end;
  lList := F2DIndex.GetList(0.5,0.5);
  // Only if RandSeed is set
  CheckEquals(3,high(lList),'Index of Points at (0.5,0.5)');
  i := 0;
  for ix in lList do
    begin
      Check(ix < 1000,'Index in Range');
      CheckEquals(0.5,FPointArray[ix].x ,0.1,'X-Offset');
      CheckEquals(0.5,FPointArray[ix].y ,0.1,'Y-Offset');
      // Only if RandSeed is set
      CheckEquals(cix[i],ix,'index[%d]'.format([i]));
      inc(i);
    end;

end;

procedure TTest2DIndex.SetUp;

var
  i: Integer;
begin
  FDatapath := 'Data';
  for i := 0 to 2 do
    if DirectoryExists(FDatapath) then
      break
    else
      FDataPath:='..'+DirectorySeparator+FDatapath;
  if DirectoryExists(FDatapath) then
    begin
      FDataPath+= DirectorySeparator+'2DIndex';
    end;
  F2DIndex := TwoDIndex.create(0,1,0,1,1000);
  F2DIndex.GetIdxValuesProc := @GetValProc;
  setlength(FPointArray,1000);
  RandSeed:=1;
  for i := 0 to high(FPointArray) do
    begin
      FPointArray[i]:= FloatPoint(random,random);
      F2DIndex.AppendObject(TObject(@FPointArray[i]),i);
    end;
end;

procedure TTest2DIndex.TearDown;
begin
  freeandnil(F2DIndex);
end;

initialization

  RegisterTest(TTest2DIndex);
end.

