unit CalendarView;

{$mode objfpc}{$H+}

interface

uses
  Classes, Controls, DateUtils, SysUtils, Graphics, Calendar, StdCtrls,
  CalendarViewModel, DesktopWindow, DesktopWorkspace;

type
  TCalendarView = class
  private
    FWorkspace: TDesktopWorkspace;
    FViewModel: TCalendarViewModel;
    FOnOpened: TNotifyEvent;
    procedure CalendarChanged(Sender: TObject);
  public
    constructor Create(AWorkspace: TDesktopWorkspace;
      AViewModel: TCalendarViewModel; AOnOpened: TNotifyEvent);
    procedure Open;
  end;

implementation

constructor TCalendarView.Create(AWorkspace: TDesktopWorkspace;
  AViewModel: TCalendarViewModel; AOnOpened: TNotifyEvent);
begin
  FWorkspace := AWorkspace;
  FViewModel := AViewModel;
  FOnOpened := AOnOpened;
end;

procedure TCalendarView.Open;
var
  Window: TDesktopWindow;
  Month: TCalendar;
  CaptionLabel: TLabel;
begin
  Window := FWorkspace.CreateWindow('Calendar', 320, 10, 330, 330);
  Month := TCalendar.Create(Window);
  Month.Parent := Window;
  Month.SetBounds(18, 48, 290, 210);
  Month.Date := DateToStr(FViewModel.SelectedDate);
  Month.OnChange := @CalendarChanged;
  CaptionLabel := TLabel.Create(Window);
  CaptionLabel.Name := 'CalendarSelection';
  CaptionLabel.Parent := Window;
  CaptionLabel.SetBounds(18, 270, 290, 28);
  CaptionLabel.Caption := FViewModel.SelectedDateCaption;
  CaptionLabel.Font.Color := RGBToColor(37, 59, 91);
  if Assigned(FOnOpened) then
    FOnOpened(Self);
end;

procedure TCalendarView.CalendarChanged(Sender: TObject);
var
  CalendarControl: TCalendar;
  Index: Integer;
  ParentControl: TWinControl;
begin
  CalendarControl := TCalendar(Sender);
  FViewModel.SelectDate(StrToDate(CalendarControl.Date));
  ParentControl := CalendarControl.Parent;
  for Index := 0 to ParentControl.ControlCount - 1 do
    if ParentControl.Controls[Index] is TLabel then
      if TLabel(ParentControl.Controls[Index]).Name = 'CalendarSelection' then
        TLabel(ParentControl.Controls[Index]).Caption :=
          FViewModel.SelectedDateCaption;
end;

end.
