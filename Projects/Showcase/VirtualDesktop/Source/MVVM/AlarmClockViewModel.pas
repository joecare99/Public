unit AlarmClockViewModel;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Services, Mvvm;

type
  TAlarmClockViewModel = class(TNotifyPropertyChangedObject)
  private
    FClock: IClockService;
    FAlarmTime: TDateTime;
    FEnabled: Boolean;
    FToggleCommand: ICommand;
    procedure ExecuteToggle(Sender: TObject; const AParameter: string);
  public
    constructor Create(const AClock: IClockService);
    procedure Toggle;
    procedure SetAlarm(const ATime: TDateTime);
    function CurrentTimeCaption: string;
    function GetAlarmCaption: string;
    property AlarmCaption:string read GetAlarmCaption;
    property Enabled: Boolean read FEnabled;
    property ToggleCommand: ICommand read FToggleCommand;
  end;

implementation

constructor TAlarmClockViewModel.Create(const AClock: IClockService);
begin
  inherited Create;
  FClock := AClock;
  FAlarmTime := EncodeTime(7, 30, 0, 0);
  FToggleCommand := TDelegateCommand.Create(@ExecuteToggle);
end;

procedure TAlarmClockViewModel.ExecuteToggle(Sender: TObject;
  const AParameter: string);
begin
  Toggle;
end;

procedure TAlarmClockViewModel.Toggle;
begin
  FEnabled := not FEnabled;
  NotifyPropertyChanged('Enabled');
end;

procedure TAlarmClockViewModel.SetAlarm(const ATime: TDateTime);
begin
  FAlarmTime := Frac(ATime);
  NotifyPropertyChanged('AlarmCaption');
end;

function TAlarmClockViewModel.CurrentTimeCaption: string;
begin
  Result := FormatDateTime('hh:nn:ss', FClock.Now);
end;

function TAlarmClockViewModel.GetAlarmCaption: string;
begin
  Result := FormatDateTime('hh:nn', FAlarmTime);
end;

end.
