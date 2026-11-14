unit testalarmclockviewmodel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DateUtils, fpcunit, testregistry, AlarmClockViewModel,
  Services;

type
  TFakeClockService = class(TInterfacedObject, IClockService)
  private
    FCurrentTime: TDateTime;
  public
    constructor Create(const ACurrentTime: TDateTime);
    function Now: TDateTime;
  end;

  TAlarmClockViewModelTest = class(TTestCase)
  published
    procedure UsesTheClockForCurrentTimeCaption;
    procedure HasTheDefaultAlarmAndCanSetAnotherTime;
    procedure ToggleChangesEnabledState;
  end;

implementation

constructor TFakeClockService.Create(const ACurrentTime: TDateTime);
begin
  FCurrentTime := ACurrentTime;
end;

function TFakeClockService.Now: TDateTime;
begin
  Result := FCurrentTime;
end;

procedure TAlarmClockViewModelTest.UsesTheClockForCurrentTimeCaption;
var
  Clock: IClockService;
  ViewModel: TAlarmClockViewModel;
begin
  Clock := TFakeClockService.Create(EncodeDateTime(2030, 12, 24, 18, 30, 45, 123));
  ViewModel := TAlarmClockViewModel.Create(Clock);
  try
    AssertEquals('18:30:45', ViewModel.CurrentTimeCaption);
  finally
    ViewModel.Free;
  end;
end;

procedure TAlarmClockViewModelTest.HasTheDefaultAlarmAndCanSetAnotherTime;
var
  Clock: IClockService;
  ViewModel: TAlarmClockViewModel;
begin
  Clock := TFakeClockService.Create(EncodeDate(2030, 1, 1));
  ViewModel := TAlarmClockViewModel.Create(Clock);
  try
    AssertEquals('07:30', ViewModel.AlarmCaption);

    ViewModel.SetAlarm(EncodeDateTime(2030, 12, 24, 21, 5, 10, 0));
    AssertEquals('21:05', ViewModel.AlarmCaption);
  finally
    ViewModel.Free;
  end;
end;

procedure TAlarmClockViewModelTest.ToggleChangesEnabledState;
var
  Clock: IClockService;
  ViewModel: TAlarmClockViewModel;
begin
  Clock := TFakeClockService.Create(EncodeDate(2030, 1, 1));
  ViewModel := TAlarmClockViewModel.Create(Clock);
  try
    AssertFalse(ViewModel.Enabled);
    ViewModel.Toggle;
    AssertTrue(ViewModel.Enabled);
    ViewModel.Toggle;
    AssertFalse(ViewModel.Enabled);
  finally
    ViewModel.Free;
  end;
end;

initialization
  RegisterTest(TAlarmClockViewModelTest);

end.
