unit speedtests;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, testdecorator;

type

  { TRepeatedTest }

  TRepeatedTest = class(TTestSetup)
  private
    FRepeatCount: integer;
  public
    procedure OneTimeSetup; override;
    procedure OneTimeTeardown; override;
    function  CountTestCases: integer; override;
    procedure BasicRun(AResult: TTestResult); override;
    property  RepeatCount: integer read FRepeatCount write FRepeatCount;
  end;

  TMySpeedTest = class(TTestCase)
  public
    constructor Create; override;
  published
    procedure TestSpeed;
    procedure TestSpeed2;
    procedure TestSpeed3;
    procedure TestSpeed4;
  end;

implementation

{ TMySpeedTest }

constructor TMySpeedTest.Create;
begin
  inherited Create;
  Writeln('calling....  constructor TMySpeedTest.Create');
end;

procedure TMySpeedTest.TestSpeed;
begin
  Check(true);
end;

procedure TMySpeedTest.TestSpeed2;
begin
  Check(true);
end;

procedure TMySpeedTest.TestSpeed3;
begin
  Check(true);
end;

procedure TMySpeedTest.TestSpeed4;
begin
  Check(true);
end;

{ TRepeatedTest }

procedure TRepeatedTest.OneTimeSetup;
begin
  FRepeatCount := 5;
end;

procedure TRepeatedTest.OneTimeTeardown;
begin
  //
end;

function TRepeatedTest.CountTestCases: integer;
begin
  Result := inherited CountTestCases * FRepeatCount;
end;

procedure TRepeatedTest.BasicRun(AResult: TTestResult);
var
  i: integer;
begin
  i := FRepeatCount;
  while i > 0 do
  begin
    inherited BasicRun(AResult);
    dec(i);
  end;
end;


initialization
  RegisterTestDecorator(TRepeatedTest, TMySpeedTest);


end.

