unit DRAWPAGE;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses SysUtils, Graphics, StdCtrls;

{ Call DrawOnePage to form each sampler page either during
printing or for previewing with an offscreen bitmap. }

procedure DrawOnePage(
  Canvas: TCanvas;        { Printer or TBitmap Canvas for preview }
  FontListBox: TListBox;  { List of fonts with multiple selections }
  Page,                   { Page number (FontList selection index) }
  {%H-}PageWidth,              { Unscaled page width in pixels }
  {%H-}PageHeight: Integer;    { Unscaled page height in pixels }
  Previewing: Boolean;    { True if previewing; else printing }
  PpiX, PpiY: Integer     { Pixels per inch on X and Y axes }
);

implementation

uses frm_FontsampMain;

var
  C: TCanvas;
  FontName, HeaderName: String;
  PixelsPerInchX, PixelsPerInchY: Integer;
  Preview: Boolean;

{ Return selected font at index }
function SelectedFont(ListBox: TListBox; Index: Integer): String;
var
  I: Integer;
begin
  with ListBox do
  for I := 0 to Items.Count - 1 do
  if Selected[I] then
  begin
    Dec(Index);
    if Index <= 0 then
    begin
      Result := Items[I];
      Exit;
    end;
  end;
  Result := 'System';  { Shouldn't happen, but... }
end;

{ Assign font name, style, and size to Canvas font }
procedure SetFont(const Name: String; Style: TFontStyles;
  Size: Integer);
begin
{ Adjust point size for preview page's logical pixels per
inch relative to the form's actual pixels per inch. This allows
the program to draw into the bitmap with TextOut, and then
display the bitmap in real size with Canvas.Draw. Some print
previewers use StretchDraw, which produces relatively poor results.}
  if Preview then
    Size := Round(Size * (PixelsPerInchY / MainForm.PixelsPerInch));
{ Assign parameters to Canvas C Font property }
  C.Font.Name := Name;
  C.Font.Style := Style;
  C.Font.Size := Size;
end;

{ Return pixel width of Name in inches }
function InchWidth(const Name: String): Double;
begin
  Result := C.TextWidth(Name);
  Result := Result / PixelsPerInchX;
end;

{ Return pixel height of Name in inches }
function InchHeight(const Name: String): Double;
begin
  Result := C.TextHeight(Name);
  Result := Result / PixelsPerInchY;
end;

{ Write string S at inch coordinates X and Y }
procedure TextAtInch(X, Y: Double; const S: String);
var
  Px, Py: Integer;
begin
  Px := Round(X * PixelsPerInchX);
  Py := Round(Y * PixelsPerInchY);
  C.TextOut(Px, Py, S);
end;

{ Draw a line at inch coordinates X1, Y1, X2, Y2 }
procedure LineAtInch(X1, Y1, X2, Y2: Double);
var
  Px1, Py1, Px2, Py2: Integer;
begin
  Px1 := Round(X1 * PixelsPerInchX);
  Py1 := Round(Y1 * PixelsPerInchY);
  Px2 := Round(X2 * PixelsPerInchX);
  Py2 := Round(Y2 * PixelsPerInchY);
  C.MoveTo(Px1, Py1);
  C.LineTo(Px2, Py2);
end;

{ Draw header at top of page }
procedure DrawHeader(const Name: String);
var
  S: String[24];
begin
  SetFont(HeaderName, [fsBold], 12);
  TextAtInch(0.5, 0.5, Name);
  SetFont(HeaderName, [fsItalic], 12);
  S := 'Font Sampler by Tom Swan';
  TextAtInch(8.0 - InchWidth(S), 0.5, S);
  LineAtInch(0.5, 0.5, 8.0, 0.5);
end;

{ Draw footer at bottom of page }
procedure DrawFooter(Page: Integer);
begin
  SetFont(HeaderName, [], 12);
  TextAtInch(0.5, 10.5, 'Page ' + IntToStr(Page));
end;

{ Draw sample character set (Ascii 32-255) }
procedure DrawCharacterSet;
var
  H: Double;
  procedure DrawOneLine(J, K: Integer);
  var
    I: Integer;
    S: String;
  begin
    S := '';
    for I := J to K do
      S := S + Chr(I);
    TextAtInch(0.5, H, S);
    H := H + InchHeight('M');
  end;
begin
  SetFont(HeaderName, [fsBold], 12);
  TextAtInch(0.5, 1.4, 'Character set:');
  SetFont(FontName, [], 10);
  H := 1.5 + InchHeight('M');
  DrawOneLine(32, 80);
  DrawOneLine(81, 129);
  DrawOneLine(130, 178);
  DrawOneLine(179, 227);
  DrawOneLIne(228, 255);
end;

{ Draw sample text in 8, 14, and 24 point sizes }
procedure DrawPointSamples;
var
  H, M: Double;
  procedure DrawOneSample(Pts: Integer);
  begin
    SetFont(HeaderName, [fsBold], 12);
    TextAtInch(0.5, H, IntToStr(Pts) + ' points:');
    M := InchHeight('M');
    H := H + M;
    SetFont(FontName, [], Pts);
    TextAtInch(0.5, H, 'AaBbCc 1234567890');
    H := H + M * 2;
  end;
begin
  H := 4.0;
  DrawOneSample(8);
  DrawOneSample(14);
  DrawOneSample(24);
end;

{ Draw normal, italic, bold, and bold-italic samples }
procedure DrawNormBoldItal;
var
  H, M: Double;
  procedure DrawOneLine(const S: String; Style: TFontStyles);
  begin
    SetFont(HeaderName, [fsBold], 12);
    TextAtInch(0.5, H, S);
    M := InchHeight('M');
    H := H + M;
    SetFont(FontName, Style, 12);
    TextAtInch(0.5, H, 'AaBbCc 1234567890');
    H := H + M * 2;
  end;
begin
  H := 7.0;
  DrawOneLine('Normal 12 points:', []);
  DrawOneLine('Italic 12 points:', [fsItalic]);
  DrawOneLine('Bold 12 points:', [fsBold]);
  DrawOneLine('Bold Italic 12 points:', [fsBold, fsItalic]);
end;

{ Printing and preview code calls this procedure to draw
each page. See declaration at top of file for descriptions
of the parameters. }
procedure DrawOnePage(Canvas: TCanvas; FontListBox: TListBox;
  Page, PageWidth, PageHeight: Integer; Previewing: Boolean;
  PpiX, PpiY: Integer);
begin
{ Save some parameters in global variables for easy access }
  C := Canvas;
  C.Pen.Color := clBlack;
  PixelsPerInchX := PpiX;
  PixelsPerInchY := PpiY;
  Preview := Previewing;
{ Draw the font samples on the Canvas (Printer or Preview) }
  with Canvas do
  begin
    FillRect(ClipRect);  { Erase page }
    if (FontListBox = nil) or (FontListBox.SelCount < 1) then
      Exit;  { Display / print blank page if no font selected }
    FontName := SelectedFont(FontListBox, Page);
    HeaderName := 'Arial';
    DrawHeader(FontName);  { These statements draw the }
    DrawFooter(Page);      { header, footer, and font samples }
    DrawCharacterSet;
    DrawPointSamples;
    DrawNormBoldItal;
  end;
end;

end.
