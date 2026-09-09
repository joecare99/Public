unit CalendarViewModel;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, DateUtils, Services, Mvvm;

type
  TCalendarViewModel = class(TNotifyPropertyChangedObject)
  private
    FClock: IClockService;
    FSelectedDate: TDateTime;
  public
    constructor Create(const AClock: IClockService);
    procedure SelectDate(const ADate: TDateTime);
    function MonthCaption: string;
    function SelectedDateCaption: string;
    function SelectedDate: TDateTime;
  end;

implementation

constructor TCalendarViewModel.Create(const AClock: IClockService);
begin
  inherited Create;
  FClock := AClock;
  FSelectedDate := DateOf(FClock.Now);
end;

procedure TCalendarViewModel.SelectDate(const ADate: TDateTime);
begin
  FSelectedDate := DateOf(ADate);
  NotifyPropertyChanged('SelectedDate');
  NotifyPropertyChanged('MonthCaption');
  NotifyPropertyChanged('SelectedDateCaption');
end;

function TCalendarViewModel.MonthCaption: string;
begin
  Result := FormatDateTime('mmmm yyyy', FSelectedDate);
end;

function TCalendarViewModel.SelectedDateCaption: string;
begin
  Result := FormatDateTime('dddd, dd. mmmm yyyy', FSelectedDate);
end;

function TCalendarViewModel.SelectedDate: TDateTime;
begin
  Result := FSelectedDate;
end;

end.
