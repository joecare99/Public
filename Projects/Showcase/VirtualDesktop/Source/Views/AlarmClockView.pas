unit AlarmClockView;

{$mode objfpc}{$H+}

interface

uses
  Classes, Controls, DateUtils, ExtCtrls, Graphics, StdCtrls, SysUtils,
  AlarmClockViewModel, DesktopWindow, DesktopWorkspace;

type
  TAlarmClockView = class
  private
    FWorkspace: TDesktopWorkspace;
    FViewModel: TAlarmClockViewModel;
    FOnOpened: TNotifyEvent;
    FClockPaint: TPaintBox;
    FAlarmEnabled: TLabel;
    procedure ToggleAlarm(Sender: TObject);
    procedure WindowClosing(Sender: TDesktopWindow);
    procedure PaintClock(Sender: TObject);
    procedure OnPropertyChanged(Sender:TObject;const APropertyName: string);
  public
    constructor Create(AWorkspace: TDesktopWorkspace;
      AViewModel: TAlarmClockViewModel; AOnOpened: TNotifyEvent);
    procedure Open;
    procedure Tick;
    function IsOpen: Boolean;
  end;

implementation

constructor TAlarmClockView.Create(AWorkspace: TDesktopWorkspace;
  AViewModel: TAlarmClockViewModel; AOnOpened: TNotifyEvent);
begin
  FWorkspace := AWorkspace;
  FViewModel := AViewModel;
  FViewModel.AddPropertyChanged(@OnPropertyChanged);
  FOnOpened := AOnOpened;
end;

procedure TAlarmClockView.OnPropertyChanged(Sender:TObject;const APropertyName: string);
begin
  case APropertyName of
    'Enabled': begin
      if FViewModel.Enabled then begin
        FAlarmEnabled.Caption := 'Alarm enabled at ' + FViewModel.AlarmCaption;
        FAlarmEnabled.Font.Color := RGBToColor(55, 145, 105);
      end else begin
        FAlarmEnabled.Caption := 'Alarm is disabled';
        FAlarmEnabled.Font.Color := RGBToColor(180, 90, 70);
      end;
    end;
  end;
end;

procedure TAlarmClockView.Open;
var
  Window: TDesktopWindow;
  CaptionLabel, AlarmLabel: TLabel;
  Button: TButton;
begin
  Window := FWorkspace.CreateWindow('Analog alarm clock', 670, 10, 355, 390);
  FClockPaint := TPaintBox.Create(Window.ClientArea);
  FClockPaint.Parent := Window.ClientArea;
  FClockPaint.SetBounds(40, 14, 270, 230);
  FClockPaint.OnPaint := @PaintClock;
  CaptionLabel := TLabel.Create(Window.ClientArea);
  CaptionLabel.Parent := Window.ClientArea;
  CaptionLabel.SetBounds(18, 258, 310, 24);
  CaptionLabel.Caption := 'Alarm time:';
  CaptionLabel.Font.Color := RGBToColor(37, 59, 91);
  AlarmLabel := TLabel.Create(Window.ClientArea);
  AlarmLabel.Name := 'AlarmState';
  AlarmLabel.Parent := Window.ClientArea;
  AlarmLabel.SetBounds(18, 282, 210, 24);
  AlarmLabel.Caption := 'Alarm is disabled';
  AlarmLabel.Font.Color := RGBToColor(180, 90, 70);
  FAlarmEnabled := AlarmLabel;
  Button := TButton.Create(Window.ClientArea);
  Button.Parent := Window.ClientArea;
  Button.SetBounds(225, 276, 100, 34);
  Button.Caption := 'Toggle';
  Button.OnClick := @ToggleAlarm;
  Window.OnClosing := @WindowClosing;
  OnPropertyChanged(FViewModel, 'Enabled');
  if Assigned(FOnOpened) then
    FOnOpened(Self);
end;

function TAlarmClockView.IsOpen: Boolean;
begin
  Result := Assigned(FClockPaint);
end;

procedure TAlarmClockView.WindowClosing(Sender: TDesktopWindow);
begin
  FClockPaint := nil;
  FAlarmEnabled := nil;
end;

procedure TAlarmClockView.ToggleAlarm(Sender: TObject);
begin
  FViewModel.ToggleCommand.Execute('');
end;

procedure TAlarmClockView.Tick;
begin
  if Assigned(FClockPaint) then
    FClockPaint.Invalidate;
end;

procedure TAlarmClockView.PaintClock(Sender: TObject);
var
  Box: TPaintBox;
  CenterX, CenterY, Radius: Integer;
  Current: TDateTime;
  HourAngle, MinuteAngle, SecondAngle: Double;
  procedure Hand(const AAngle, ALength: Double; AWidth: Integer; AColor: TColor);
  begin
    Box.Canvas.Pen.Color := AColor;
    Box.Canvas.Pen.Width := AWidth;
    Box.Canvas.Line(
      CenterX, CenterY,
      CenterX + Round(Sin(AAngle) * ALength),
      CenterY - Round(Cos(AAngle) * ALength));
  end;
begin
  Box := TPaintBox(Sender);
  CenterX := Box.Width div 2;
  CenterY := Box.Height div 2;
  Radius := (Box.Height div 2) - 8;
  Box.Canvas.Brush.Color := clWhite;
  Box.Canvas.FillRect(Box.ClientRect);
  Box.Canvas.Pen.Color := RGBToColor(37, 59, 91);
  Box.Canvas.Pen.Width := 3;
  Box.Canvas.Ellipse(CenterX - Radius, CenterY - Radius,
    CenterX + Radius, CenterY + Radius);
  Current := Time;
  HourAngle := (HourOf(Current) mod 12) * Pi / 6 + MinuteOf(Current) * Pi / 360;
  MinuteAngle := MinuteOf(Current) * Pi / 30 + SecondOf(Current) * Pi / 1800;
  SecondAngle := SecondOf(Current) * Pi / 30;
  Hand(HourAngle, Radius * 0.52, 6, RGBToColor(37, 59, 91));
  Hand(MinuteAngle, Radius * 0.72, 4, RGBToColor(37, 59, 91));
  Hand(SecondAngle, Radius * 0.82, 2, RGBToColor(205, 91, 81));
  Box.Canvas.Brush.Color := RGBToColor(205, 91, 81);
  Box.Canvas.Ellipse(CenterX - 5, CenterY - 5, CenterX + 5, CenterY + 5);
end;

end.
