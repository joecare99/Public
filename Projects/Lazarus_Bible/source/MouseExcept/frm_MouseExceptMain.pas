unit frm_MouseExceptMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TMainForm = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    procedure FormMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
    procedure CheckMouseLocation(X, Y: Integer);
    procedure ExitOnClick(X, Y: Integer);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
  rLeft   = 25;
  rTop    = 25;
  rRight  = 100;
  rBottom = 100;

type
  TMouseException = class(Exception)
    X, Y: Integer;
    constructor Create(const Msg: string; XX, YY: Integer);
  end;

constructor TMouseException.Create(const Msg: string;
  XX, YY: Integer);
begin
  X := XX;    // Save X and Y values in object
  Y := YY;
  Message :=  // Create message string
    Msg + ' (X=' + IntToStr(X) + ', Y=' + IntToStr(Y) + ')';
end;

procedure TMainForm.CheckMouseLocation(X, Y: Integer);
begin
  if (X < rLeft) or (X > rRight) or
     (Y < rTop)  or (Y > rBottom) then
    raise
      TMouseException.Create('Mouse location error', X, Y);
end;

procedure TMainForm.ExitOnClick(X, Y: Integer);
begin
  try
    CheckMouseLocation(X, Y);  // Bad values raise exception
    Close;                     // Exit the program
  except
    on TMouseException do
    begin
      if MessageDlg('Mouse error. Exit anyway?',
        mtError, [mbYes, mbNo], 0) = mrYes
      then
        Close
      else
        raise;
    end;
  end;
end;

procedure TMainForm.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ExitOnClick(X, Y);
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  Canvas.Rectangle(rLeft, rTop, rRight, rBottom);
end;

end.
