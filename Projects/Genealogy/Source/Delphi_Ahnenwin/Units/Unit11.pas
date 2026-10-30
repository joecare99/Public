unit Unit11;

{-------------------------------------------------------------------------------
  Unit11 - TForm11, the family chart of AHNENWIN 5.1.

  Reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit11.pas and the original resource
  Source\Projects_AhnenWin\Form11.dfm.

  The chart is drawn into the paint box by the method "zeichnen"; the
  printer output uses the same method with the printer canvas.

  The globals of this unit are the printer metrics that FormCreate reads
  from the device context:

    gvar_025368B0  HORZRES / 10       (pixels per millimetre, horizontal)
    gvar_025368B4  VERTRES            (vertical resolution)
    gvar_025368B8  LOGPIXELSX / 10    (horizontal, second reading)
    gvar_025368BC  LOGPIXELSY         (vertical, device units)
    gvar_025368C0  gvar_025368B4 / gvar_025368B0
    gvar_025368C4  gvar_025368BC / gvar_025368B8

  Method addresses (original binary):
    005C7068  Fgr               (the family graph, still open)
    005C95E4  zeichnen          (the drawing, still open)
    005CB270  PaintBox1Paint
    005CB2A0  FormCreate
    005CB41C  SpeedButton1Click   (Fertig)
    005CB428  SpeedButton2Click   (print)
    005CB488  Button1Click        (um 5 Jahre verl.)
    005CB49C  FormActivate
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, ExtCtrls, StdCtrls, Buttons, Forms, Controls, Graphics,
  Printers, Dialogs, Windows;

type
  TForm11 = class(TForm)
  published
    Panel1: TPanel; //2F0
    ScrollBox1: TScrollBox; //2F4
    PaintBox1: TPaintBox; //2F8
    PrintDialog1: TPrintDialog; //2FC
    SpeedButton1: TSpeedButton; //300
    SpeedButton2: TSpeedButton; //304
    Button1: TButton; //308
    procedure SpeedButton2Click(Sender: TObject); //005CB428
    procedure SpeedButton1Click(Sender: TObject); //005CB41C
    procedure FormActivate(Sender: TObject); //005CB49C
    procedure Button1Click(Sender: TObject); //005CB488
    procedure Fgr(ANummer: Integer; A1, A2, A3, A4: Integer); //005C7068
    procedure PaintBox1Paint(Sender: TObject); //005CB270
    procedure zeichnen(ACanvas: TCanvas); //005C95E4
    procedure FormCreate(Sender: TObject); //005CB2A0
  end;

var
  Form11: TForm11;

implementation

uses
  AHNGlobals, Unit1;

{$R ..\Forms\Form11.DFM}

// 005CB270
procedure TForm11.PaintBox1Paint(Sender: TObject);
begin
  { While the chart is drawn for the printer, the paint box keeps its own
    background; the listing compares the canvas of the paint box with the
    canvas that is currently being drawn on. }
  if PaintBox1.Canvas = gvar_02536894 then
    PaintBox1.Color := clBtnFace;
  zeichnen(gvar_02536894);
end;

// 005CB2A0
procedure TForm11.FormCreate(Sender: TObject);
begin
  { The printer metrics are read from the device context of the default
    printer:
      4 = HORZRES  (horizontal resolution)
      8 = VERTRES  (vertical resolution)
      6 = LOGPIXELSX
      10 = LOGPIXELSY }
  gvar_025368B0 := GetDeviceCaps(Printer.Handle, HORZRES) div 10;
  gvar_025368B4 := GetDeviceCaps(Printer.Handle, VERTRES);
  gvar_025368B8 := GetDeviceCaps(Printer.Handle, LOGPIXELSX) div 10;
  gvar_025368BC := GetDeviceCaps(Printer.Handle, LOGPIXELSY);

  { The original divides without a guard. That crashes when the machine
    has no usable printer, because HORZRES and LOGPIXELSX are then zero.
    The guard keeps the reconstruction usable and does not change the
    result on a machine with a printer. }
  if gvar_025368B0 <> 0 then
    gvar_025368C0 := gvar_025368B4 div gvar_025368B0
  else
    gvar_025368C0 := 0;
  if gvar_025368B8 <> 0 then
    gvar_025368C4 := gvar_025368BC div gvar_025368B8
  else
    gvar_025368C4 := 0;

  { The chart is drawn on the canvas of the paint box. }
  gvar_02536894 := PaintBox1.Canvas;

  { The form is scaled to the size of the main form. The two globals
    gvar_02536BA8 and gvar_02536BAC hold the screen dimensions of the
    main form at the time of the last scaling - TForm1.FormCreate stores
    Screen.Height and Screen.Width in them. They are only valid once the
    main form has been created, so the scaling is skipped while they are
    still zero; the original would divide by zero in that case. }
  Scaled := True;
  if (gvar_02536BA8 <> 0) and (gvar_02536BAC <> 0) then
    if (Screen.Height <> gvar_02536BA8) or (Screen.Width <> gvar_02536BAC) then
    begin
      { The height is scaled to the client height of the main form, the
        remaining space is taken from the top of the form. }
      Height := (Screen.Height * Form1.ClientHeight) div gvar_02536BA8 +
                Form1.Top - ClientHeight;
      Width := (Screen.Width * Form1.ClientWidth) div gvar_02536BAC +
               Form1.Left - ClientWidth;
      ScaleBy(gvar_02536BAC, Screen.Width);
    end;

  gvar_025368A8 := 0;
end;

// 005CB41C
procedure TForm11.SpeedButton1Click(Sender: TObject);
begin
  { "Fertig" - the chart window is closed. }
  Close;
end;

// 005CB428
procedure TForm11.SpeedButton2Click(Sender: TObject);
begin
  { The print button prints the chart on the printer. The chart is drawn
    by the same method that draws it on the screen, only with the canvas
    of the printer instead of the canvas of the paint box. }
  if PrintDialog1.Execute then
  begin
    gvar_02536894 := Printer.Canvas;
    Printer.BeginDoc;
    zeichnen(gvar_02536894);
    Printer.EndDoc;
  end;
  gvar_02536894 := PaintBox1.Canvas;
  PaintBox1.Refresh;
end;

// 005CB488
procedure TForm11.Button1Click(Sender: TObject);
begin
  { "um 5 Jahre verlangern" - the counter of the displayed generations is
    increased and the chart is drawn again. }
  Inc(gvar_025368A8);
  zeichnen(gvar_02536894);
end;

// 005CB49C
procedure TForm11.FormActivate(Sender: TObject);
begin
  { The generation counter is reset when the window is opened. }
  gvar_025368A8 := 0;
end;

// 005C7068
procedure TForm11.Fgr(ANummer: Integer; A1, A2, A3, A4: Integer);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

// 005C95E4
procedure TForm11.zeichnen(ACanvas: TCanvas);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

end.
