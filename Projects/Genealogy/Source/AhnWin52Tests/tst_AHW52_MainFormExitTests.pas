unit tst_AHW52_MainFormExitTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testutils, testregistry;

type
  TTestAHW52MainFormExit = class(TTestCase)
  published
    procedure TestCaseExitMenuSequence;
    procedure TestCaseExitStopsAfterFailure;
    procedure TestCaseInvalidActionsAreRejected;
  end;

implementation

uses
  Classes, SysUtils, MainFormExitBehavior;

type
  TRecordingExitActions = class(TInterfacedObject, IMainFormExitActions)
  private
    FCalls: TStringList;
    FFailAt: string;
    procedure RecordCall(const Name: string);
  public
    constructor Create(const FailAt: string = '');
    destructor Destroy; override;
    procedure DisablePrivacyMode;
    procedure ActivateDataPage;
    procedure CloseMainForm;
    property Calls: TStringList read FCalls;
  end;

constructor TRecordingExitActions.Create(const FailAt: string);
begin
  inherited Create;
  FCalls := TStringList.Create;
  FFailAt := FailAt;
end;

destructor TRecordingExitActions.Destroy;
begin
  FCalls.Free;
  inherited Destroy;
end;

procedure TRecordingExitActions.RecordCall(const Name: string);
begin
  FCalls.Add(Name);
  if Name = FFailAt then
    raise Exception.CreateFmt('Injected failure at %s.', [Name]);
end;

procedure TRecordingExitActions.DisablePrivacyMode;
begin
  RecordCall('disable-privacy');
end;

procedure TRecordingExitActions.ActivateDataPage;
begin
  RecordCall('activate-data-page');
end;

procedure TRecordingExitActions.CloseMainForm;
begin
  RecordCall('close-main-form');
end;

procedure AssertEqual(const Description, Expected, Actual: string);
begin
  if Expected <> Actual then
    raise Exception.CreateFmt('%s: expected "%s", got "%s".',
      [Description, Expected, Actual]);
end;

procedure AssertCallSequence(Actions: TRecordingExitActions;
  const Expected: array of string);
var
  Index: Integer;
begin
  if Actions.Calls.Count <> Length(Expected) then
    raise Exception.CreateFmt('Expected %d calls, got %d.',
      [Length(Expected), Actions.Calls.Count]);

  for Index := 0 to High(Expected) do
    AssertEqual(Format('Call %d', [Index]), Expected[Index],
      Actions.Calls[Index]);
end;

procedure TestExitMenuSequence;
var
  ActionsObject: TRecordingExitActions;
  Actions: IMainFormExitActions;
begin
  ActionsObject := TRecordingExitActions.Create;
  Actions := ActionsObject;
  ExecuteMainFormExit(Actions);
  AssertCallSequence(ActionsObject, [
    'disable-privacy',
    'activate-data-page',
    'close-main-form'
  ]);
  Actions := nil;
end;

procedure TestExitStopsAfterFailure;
var
  ActionsObject: TRecordingExitActions;
  Actions: IMainFormExitActions;
  Raised: Boolean;
begin
  ActionsObject := TRecordingExitActions.Create('activate-data-page');
  Actions := ActionsObject;
  Raised := False;
  try
    ExecuteMainFormExit(Actions);
  except
    on E: Exception do
      Raised := True;
  end;
  if not Raised then
    raise Exception.Create('Exit action failure was swallowed.');
  AssertCallSequence(ActionsObject, [
    'disable-privacy',
    'activate-data-page'
  ]);
  Actions := nil;
end;

procedure TestInvalidActionsAreRejected;
var
  Raised: Boolean;
begin
  Raised := False;
  try
    ExecuteMainFormExit(nil);
  except
    on E: EArgumentNilException do
      Raised := True;
  end;
  if not Raised then
    raise Exception.Create('Nil exit actions were accepted.');
end;

procedure TTestAHW52MainFormExit.TestCaseExitMenuSequence;
begin
    TestExitMenuSequence;
end;

procedure TTestAHW52MainFormExit.TestCaseExitStopsAfterFailure;
begin
    TestExitStopsAfterFailure;
end;

procedure TTestAHW52MainFormExit.TestCaseInvalidActionsAreRejected;
begin
    TestInvalidActionsAreRejected;
end;

initialization
  RegisterTest(TTestAHW52MainFormExit);

end.
