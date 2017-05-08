unit Frm_PrintgrMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  {$IFNDEF FPC}
  Windows,
  {$ELSE}
  LCLIntf, LCLType, PrintersDlgs,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, Printers;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Print1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    PrintDialog1: TPrintDialog;
    procedure Print1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    procedure PaintGraphics(C: TCanvas; ScaleX, ScaleY: Integer);
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

procedure TMainForm.PaintGraphics(C: TCanvas;
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

procedure TMainForm.Print1Click(Sender: TObject);
var
  ScaleX, ScaleY: Integer;
begin
  if PrintDialog1.Execute then
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
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  PaintGraphics(Canvas, 1, 1);
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

end.
