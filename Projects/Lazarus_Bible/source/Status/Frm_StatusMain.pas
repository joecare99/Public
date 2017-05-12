unit Frm_StatusMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls, ToolWin;

type
  TMainForm = class(TForm)
    Label1: TLabel;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    Label2: TLabel;
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

{ Rather than use literal index values, this section defines
  descriptive contants for the statusbar's four panels }
const
  XPanelIndex       = 0;
  YPanelIndex       = 1;
  MessagePanelIndex = 2;
  TimePanelIndex    = 3;

{ Update X and Y coordinate values in the statusbar }
procedure TMainForm.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  StatusBar1.Panels[XPanelIndex].Text := 'X = ' + IntToStr(X);
  StatusBar1.Panels[YPanelIndex].Text := 'Y = ' + IntToStr(Y);
end;

{ Calculate width of middle panel so the others stay the
  same size when the window resizes. }
procedure TMainForm.FormResize(Sender: TObject);
const
  Fudge = 25;  // Allow extra space for width calculation
var
  W: Integer;  // Width of fixed-size panels
begin
  with StatusBar1 do
  begin
    W := Panels[XPanelIndex].Width +
      Panels[YPanelIndex].Width + Panels[TimePanelIndex].Width;
    Panels[MessagePanelIndex].Width := Width - (W + Fudge);
  end;
end;

{ Display the time in the rightmost statusbar panel }
procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  StatusBar1.Panels[TimePanelIndex].Text := TimeToStr(Time);
end;

{ Force an exception to occur and display its message
  in a statusbar panel. The call to ShowMessage is never
  made, but is included to prevent the compiler from
  optimizing out the integer division. }
procedure TMainForm.ToolButton1Click(Sender: TObject);
var
  K, J: Integer;
begin
  K := 100; J := 0;
  try
    K := K div J;  // Force divide by zero exception
    ShowMessage(IntToStr(K) + ':' + IntToStr(J));
  except on E: Exception do
    begin
      MessageBeep(0);
      StatusBar1.Panels[MessagePanelIndex].Text :=
       'Error: ' + E.Message;
    end;
  end;
end;

{ Clear the text from middle statusbar panel }
procedure TMainForm.ToolButton2Click(Sender: TObject);
begin
  StatusBar1.Panels[MessagePanelIndex].Text := '';
end;

{ End the program }
procedure TMainForm.ToolButton4Click(Sender: TObject);
begin
  Close;
end;

{ Translate mouse coordinates when the cursor moves over
  one of the two large labels, and pass the results on
  to the MainForm's OnMouseMove event handler. }
procedure TMainForm.Label1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  T: TLabel;  // Refers to Sender as a TLabel object
begin
  T := Sender as TLabel;  // Initialize T
  // Pass coordinates to MainForm's event handler
  MainForm.FormMouseMove(Sender, Shift, T.Left + X, T.Top + Y);
end;

end.
