unit Frm_PrnInfoMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Printers, StdCtrls, Buttons;

type
  TMainForm = class(TForm)
    PrintButton: TButton;
    CloseBitBtn: TBitBtn;
    procedure PrintButtonClick(Sender: TObject);
  private
    { Private declarations }
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

procedure TMainForm.PrintButtonClick(Sender: TObject);
var
  FPrn: System.Text;
{$IFNDEF FPC}
  Extent: TSize;
  Metrics: TTextMetric;
{$ENDIF}
  I, LinesPerPage, CharsPerLine, AverageWidth, Y, TextW, TextH: Integer;
  S : String;
begin
  {$IFDEF FPC}
  { Free Pascal kennt AssignPrn und die GDI-Textmetriken nicht; die
    Kennzahlen werden ueber die Drucker-Leinwand ermittelt und ausgegeben.
    Ohne Drucker (z. B. WSL) sauber abfangen. }
  try
    Printer.BeginDoc;
    try
      with Printer, Canvas do
      begin
        Font.Name := 'Courier New';
        Font.Size := 12;
      {- Fill test string with ASCII values 32 to 255 }
        SetLength(S, 224);
        for I := 32 to 255 do
          S[I - 31] := Chr(I);
        TextW := TextWidth(S);
        TextH := TextHeight(S);
        if Length(S) > 0 then
          AverageWidth := TextW div Length(S)
        else
          AverageWidth := 1;
        if AverageWidth < 1 then
          AverageWidth := 1;
      {- Determine number of lines per page }
        LinesPerPage := PageHeight div (TextH + 2);
        if PageHeight mod (TextH + 2) <> 0 then
          Dec(LinesPerPage);
      {- Determine average number of characters per line }
        CharsPerLine := PageWidth div AverageWidth;
      {- Print the report }
        Y := TextH;
        TextOut(100, Y, 'Device = ' + Printers[PrinterIndex]); Inc(Y, TextH + 2);
        TextOut(100, Y, 'Font = ' + Font.Name); Inc(Y, TextH + 2);
        TextOut(100, Y, 'Font Size = ' + IntToStr(Font.Size) + ' points'); Inc(Y, TextH + 2);
        TextOut(100, Y, 'PageHeight = ' + IntToStr(PageHeight) + ' pixels'); Inc(Y, TextH + 2);
        TextOut(100, Y, 'PageWidth = ' + IntToStr(PageWidth) + ' pixels'); Inc(Y, TextH + 2);
        TextOut(100, Y, 'TextWidth = ' + IntToStr(TextW) + ' pixels'); Inc(Y, TextH + 2);
        TextOut(100, Y, 'TextHeight = ' + IntToStr(TextH) + ' pixels'); Inc(Y, TextH + 2);
        TextOut(100, Y, 'Lines per page = ' + IntToStr(LinesPerPage)); Inc(Y, TextH + 2);
        TextOut(100, Y, 'Chars per line = ' + IntToStr(CharsPerLine));
      end;
    finally
      Printer.EndDoc;
    end;
  except
    on E: Exception do
      ShowMessage('Drucken nicht moeglich: ' + E.Message);
  end;
  {$ELSE}
  printer.AssignPrn(FPrn);
  Rewrite(FPrn);

  with Printer.Canvas do
  begin
    Font.Name := 'Courier New';
    Font.Size := 12;
  end;

{- Fill test string with ASCII values 32 to 255 }
  try
    SetLength(S, 224);       // Use this method instead
    for I := 32 to 255 do    // Fill string with test chars
      S[I - 31] := Chr(I);
    with Printer, Canvas do
    begin
    {- Determine number of lines per page }
      GetTextExtentPoint(Handle, @S[1], Length(S), Extent);
      LinesPerPage := PageHeight div (Extent.Cy + 2);
      if PageHeight mod Extent.Cy <> 0 then
        Dec(LinesPerPage);
    {- Determine average number of characters per line }
      GetTextMetrics(Handle, Metrics);
      AverageWidth := Metrics.tmAveCharWidth;
      CharsPerLine := PageWidth div AverageWidth;
    {- Print the report }
      Writeln(FPrn, 'Device = ', Printers[PrinterIndex]);
      Writeln(FPrn, 'Font = ', Font.Name);
      Writeln(FPrn, 'Font Size = ', Font.Size, ' points');
      Writeln(FPrn, 'PageHeight = ', PageHeight, ' pixels');
      Writeln(FPrn, 'PageWidth = ', PageWidth, ' pixels');
      Writeln(FPrn, 'Extent.Cx = ', Extent.Cx, ' pixels');
      Writeln(FPrn, 'Extent.Cy = ', Extent.Cy, ' pixels');
      Writeln(FPrn, 'Lines per page = ', LinesPerPage);
      Writeln(FPrn, 'Chars per line = ', CharsPerLine);
    end;
  finally
    CloseFile(FPrn);
  end;
  {$ENDIF}
end;

end.
