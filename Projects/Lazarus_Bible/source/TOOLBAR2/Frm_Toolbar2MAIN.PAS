unit Frm_Toolbar2MAIN;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Buttons, Grids, Calendar;

type
  TMainForm = class(TForm)
    ToolbarPanel: TPanel;
    RingSB: TSpeedButton;
    DateSB: TSpeedButton;
    TimeSB: TSpeedButton;
    CalendarSB: TSpeedButton;
    ExitSB: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Bevel1: TBevel;
    Calendar1: TCalendar;
    procedure SBMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SBMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RingSBClick(Sender: TObject);
    procedure DateSBClick(Sender: TObject);
    procedure TimeSBClick(Sender: TObject);
    procedure CalendarSBClick(Sender: TObject);
    procedure ExitSBClick(Sender: TObject);
  private
    { Private declarations }
    function InToolbar(Sender: TObject): Boolean;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

const
  isNotInToolbar = 0;     { SpeedButton Tag flag }
  isInToolbar    = 1;     { SpeedButton Tag flag }

{- Returns True if Sender is in the toolbar }
function TMainForm.InToolbar(Sender: TObject): Boolean;
begin
  with Sender as TSpeedButton do
  if Tag = isNotInToolbar then
  begin
    Tag := isInToolbar;   { Set Tag flag }
    Result := False;      { Return function result = False }
  end else
    Result := True;       { Return function result = True }
end;

{- Assign OnClick event handlers for buttons not in toolbar }
procedure TMainForm.SBMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  with Sender as TSpeedButton do
  if Tag = isNotInToolbar then
  begin { Assign OnClick event handler to a button }
    if Sender = RingSB then
      RingSB.OnClick := RingSBClick
    else if Sender = DateSB then
      DateSB.OnClick := DateSBClick
    else if Sender = TimeSB then
      TimeSB.OnClick := TimeSBClick
    else if Sender = CalendarSB then
      CalendarSB.OnClick := CalendarSBClick
    else if Sender = ExitSB then
      ExitSB.OnClick := ExitSBClick;
  end;
end;

{- Move buttons into the toolbar }
procedure TMainForm.SBMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  with Sender as TSpeedButton do
  if Tag = isNotInToolbar then
  begin  { Move button into the toolbar }
    Parent := ToolbarPanel;  { Toolbar now owns the button }
    Top := 0;                { Reposition button }
  end;
end;

{- Respond to Ring button click }
procedure TMainForm.RingSBClick(Sender: TObject);
begin
  if InToolbar(Sender) then
    MessageBeep(0);
end;

{- Respond to Date button click }
procedure TMainForm.DateSBClick(Sender: TObject);
begin
  if InToolbar(Sender) then
    ShowMessage('The date is ' + DateToStr(Date));
end;

{- Respond to Time button click }
procedure TMainForm.TimeSBClick(Sender: TObject);
begin
  if InToolbar(Sender) then
    ShowMessage('The time is ' + TimeToStr(Time));
end;

{- Respond to Calendar button click }
procedure TMainForm.CalendarSBClick(Sender: TObject);
begin
  if InToolbar(Sender) then
  with Calendar1 do
  begin
    Align := alClient;
    Visible := not Visible;
  end;
end;

{- Respond to Exit button click }
procedure TMainForm.ExitSBClick(Sender: TObject);
begin
  if InToolbar(Sender) then
    Close;
end;

end.

