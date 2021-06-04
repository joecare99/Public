unit tst_Filter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, cmp_Filter;

type

  { TTestFilter }

  TTestFilter= class(TTestCase)
  private
    FFilter:TBaseFilter;
    FResult:TStringlist;
    FTestSchema:TStringlist;
    procedure ComputeFiltered(CType: byte; Text: String);
    Procedure FilterOnLineChange(Sender:TObject);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    procedure TestFilter1;
    procedure TestFilter2;
    procedure TestFilter3;
  end;

implementation

const
  CTestSchema = '[TS: B'+LineEnding+LineEnding;
  CTestSchema2 = ']TS: B '+LineEnding+'[XXX '+LineEnding+LineEnding;
  CTestSchema3 = '[TS: B'+LineEnding+'+Hello'+LineEnding;
  CTestSchema4 = 'j03A'+LineEnding+'j04B'+LineEnding+']--'+Lineending+'[--'+LineEnding;
  CTestSchema5 = 'J03A'+LineEnding+'J04B'+LineEnding+'[--'+Lineending+']--'+LineEnding;

procedure TTestFilter.TestSetUp;
begin
  CheckNotNull(FFilter,'Filter assigned');
end;

procedure TTestFilter.TestFilter1;
begin
  FTestSchema.text := CTestSchema;
  FFilter.Schema := FTestSchema;
  CheckFalse(FFilter.TestFilter('Test',@ComputeFiltered),'Message no Filter');
  CheckEquals(0,Fresult.Count,'Result0');
  CheckEquals(0,FFilter.TestLine,'testLine0');
  CheckTrue(FFilter.TestFilter('TS: BR',@ComputeFiltered),'Message Filter');
  CheckEquals(1,Fresult.Count,'Result1');
  CheckEquals('1: TBaseFilter',Fresult[Fresult.Count-1],'Result1');
  CheckEquals(1,FFilter.TestLine,'testLine1');
  CheckFaLSE(FFilter.TestFilter('S: Test',@ComputeFiltered),'Message Filter');    //??
  CheckEquals(1,Fresult.Count,'Result1');
  CheckEquals('1: TBaseFilter',Fresult[Fresult.Count-1],'Result1');
  CheckEquals(1,FFilter.TestLine,'testLine1');
 end;

procedure TTestFilter.TestFilter2;
begin
  FTestSchema.text := CTestSchema2;
  FFilter.Schema := FTestSchema;
  CheckFalse(FFilter.TestFilter('TS: BR',@ComputeFiltered),'Message no Filter');
  CheckEquals(0,Fresult.Count,'Result0');
  CheckEquals(0,FFilter.TestLine,'testLine0');
  CheckFalse(FFilter.TestFilter('TS: B',@ComputeFiltered),'Message Filter');
  CheckEquals(1,Fresult.Count,'Result1');
  CheckEquals('1: TBaseFilter',Fresult[Fresult.Count-1],'Result1');
  CheckEquals(1,FFilter.TestLine,'testLine1');
  CheckFalse(FFilter.TestFilter('S: Test',@ComputeFiltered),'Message Filter');
  CheckEquals(1,Fresult.Count,'Result1');
  CheckEquals('1: TBaseFilter',Fresult[Fresult.Count-1],'Result1');
  CheckEquals(1,FFilter.TestLine,'testLine1');
  CheckTrue(FFilter.TestFilter('XXX',@ComputeFiltered),'Message Filter XXX');
  CheckEquals(2,Fresult.Count,'Result1');
  CheckEquals('2: TBaseFilter',Fresult[Fresult.Count-1],'Result1');
  CheckEquals(2,FFilter.TestLine,'testLine1');
 end;

procedure TTestFilter.TestFilter3;
begin
  FTestSchema.text := CTestSchema3;
  FFilter.Schema := FTestSchema;
  CheckFalse(FFilter.TestFilter('TS: Q',@ComputeFiltered),'Message no Filter');
  CheckEquals(0,Fresult.Count,'Result0');
  CheckEquals(0,FFilter.TestLine,'testLine0');
  CheckTrue(FFilter.TestFilter('TS: B',@ComputeFiltered),'Message Filter');
  CheckEquals(3,Fresult.Count,'Result1');
  CheckEquals('2: TBaseFilter',Fresult[Fresult.Count-1],'Result1');
  CheckEquals('CF 0: Hello',Fresult[Fresult.Count-2],'Result1');
  CheckEquals('1: TBaseFilter',Fresult[Fresult.Count-3],'Result1');
  CheckEquals(2,FFilter.TestLine,'testLine1');
  CheckFalse(FFilter.TestFilter('S: Test',@ComputeFiltered),'Message Filter');
  CheckEquals(3,Fresult.Count,'Result1');
  CheckEquals(2,FFilter.TestLine,'testLine1');
  CheckFalse(FFilter.TestFilter('XXX',@ComputeFiltered),'Message Filter XXX');
  CheckEquals(3,Fresult.Count,'Result1');
  CheckEquals(2,FFilter.TestLine,'testLine1');
 end;


procedure TTestFilter.FilterOnLineChange(Sender: TObject);
begin
  FResult.Append(inttostr(FFilter.TestLine)+': '+Sender.ToString);
end;

procedure TTestFilter.ComputeFiltered(CType: byte; Text: String);
var
  line: String;
begin
  line := Format('CF %d: %s',[CType,Text]);
  FResult.Append(Line);
end;

procedure TTestFilter.SetUp;
begin
  FFilter := TBaseFilter.Create(nil);
  FFilter.OnLineChange:=@FilterOnLineChange;
  FFilter.Verbose:=true;
  FResult := TStringList.Create;
  FTestSchema := TStringList.Create;
end;

procedure TTestFilter.TearDown;
begin
  freeandnil(FTestSchema);
  freeandnil(FResult);
  freeandnil(FFilter);
end;

initialization

  RegisterTest(TTestFilter);
end.

