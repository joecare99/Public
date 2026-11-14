unit Frm_PrintgrMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  {$IFNDEF FPC}
  Windows,
  {$ELSE}
  LCLIntf, LCLType,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, Printers;

type
  TfrmPrintgrMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Print1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    procedure Print1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    procedure PaintGraphics(C: TCanvas; ScaleX, ScaleY: Integer);
  public
    { Public declarations }
  end;

var
  frmPrintgrMain: TfrmPrintgrMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TfrmPrintgrMain.PaintGraphics(C: TCanvas;
  ScaleX, ScaleY: Integer);
var
  R: TRect;
  P: TPoint;

  function ScalePoint(X, Y: Integer): TPoint;
  begin
    Result := Point(X * ScaleX, Y * ScaleY);
  end;

  function ScaleRect(L, T, R, B: Integer): TRect;
  begin
    Result := Rect(L * ScaleX, T * ScaleY, R * ScaleX, B * ScaleY);
  end;

begin
  with C do
  begin
    Pen.Color := clBlue;
    Brush.Color := clRed;
    Brush.Style := bsCross;
    Font.Name := 'Courier New';
    Font.Size := 8;
    Font.Style := [fsBold, fsItalic];
    R := ScaleRect(12, 12, 57, 57);
    Ellipse(R.Left, R.Top, R.Right, R.Bottom);
    R := ScaleRect(100, 85, 160, 174);
    Rectangle(R.Left, R.Top, R.Right, R.Bottom);
    P := ScalePoint(12, 60);
    TextOut(P.X, P.Y, 'Ellipse');
    P := ScalePoint(12, 110);
    TextOut(P.X, P.Y, 'Rectangle');
    Font.Size := 24;
    Font.Style := [fsBold, fsItalic];
    P := ScalePoint(200, 75);
    TextOut(P.X, P.Y, 'Graphics!');
  end;
end;

procedure TfrmPrintgrMain.Print1Click(Sender: TObject);
var
  ScaleX, ScaleY: Integer;
begin
  { Fehlt kein Drucker (z. B. in WSL) oder das OS-Backend, bricht der
    Druck dennoch sauber ab statt mit einer Access Violation. }
  try
    Printer.BeginDoc;
    try
      ScaleX := GetDeviceCaps(Printer.Canvas.Handle,
        logPixelsX) div PixelsPerInch;
      ScaleY := GetDeviceCaps(Printer.Canvas.Handle,
        logPixelsY) div PixelsPerInch;
      PaintGraphics(Printer.Canvas, ScaleX, ScaleY);
    finally
      Printer.EndDoc;
    end;
  except
    on E: Exception do
      ShowMessage('Drucken nicht moeglich (' + E.ClassName + '): ' + E.Message);
  end;
end;

procedure TfrmPrintgrMain.FormPaint(Sender: TObject);
begin
  PaintGraphics(Canvas, 1, 1);
end;

procedure TfrmPrintgrMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

end.
