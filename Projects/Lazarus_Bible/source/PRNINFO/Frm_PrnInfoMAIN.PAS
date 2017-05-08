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
uses printer;
{$ENDIF}

procedure TMainForm.PrintButtonClick(Sender: TObject);
var
  FPrn: System.Text;
  Extent: TSize;
  Metrics: TTextMetric;
  I, LinesPerPage, CharsPerLine, AverageWidth: Integer;
  S : String;
begin
  printer.AssignPrn(FPrn);
  Rewrite(FPrn);

  with Printer.Canvas do
  begin
    Font.Name := 'Courier New';
    Font.Size := 12;
  end;

{- Fill test string with ASCII values 32 to 255 }
  try
(*    S[0] := Chr(224);      // This is no longer allowed *)
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
end;

end.
