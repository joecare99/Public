unit Unit6;

{-------------------------------------------------------------------------------
  Unit6 - TForm6, the Gregorian calendar of AHNENWIN 5.1.

  Reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit6.pas and the original resource
  Source\Projects_AhnenWin\Form6.dfm.

  The calendar shows the three months of a quarter in three string grids and
  lets the year be changed with the two arrow buttons.

  The year is limited to the range 1581 .. 2499 (the listing compares with
  $62D and $9C3); the Gregorian calendar only starts in 1582, and the
  program supports the year 2499 as the last one.

  Method addresses (original binary):
    005CDACC  FormCreate
    005CDBE0  gridleeren
    005CDC40  Kal            (the calendar computation, still open)
    005CE104  FormShow
    005CE10C  Button1Click    (next year)
    005CE200  Button2Click    (previous year)
    005CE2F4  Edit1Change
    005CE484  BitBtn1Click
    005CE490  FormKeyDown
    005CE4A8  Edit1KeyDown
    005CE4C0  FormActivate
    005CE4C4  FormClose
    005CE4D4  SpeedButton1Click (print)
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, ExtCtrls, StdCtrls, Buttons, Grids, Forms, Controls,
  Dialogs, Windows;

type
  TForm6 = class(TForm)
  published
    Shape1: TShape; //2F0
    StringGrid1: TStringGrid; //2F4
    StringGrid2: TStringGrid; //2F8
    StringGrid3: TStringGrid; //2FC
    Edit1: TEdit; //300
    Button1: TButton; //304
    Button2: TButton; //308
    BitBtn1: TBitBtn; //30C
    Edit2: TEdit; //310
    Edit3: TEdit; //314
    Edit4: TEdit; //318
    Edit5: TEdit; //31C
    Edit6: TEdit; //320
    Edit7: TEdit; //324
    Edit8: TEdit; //328
    Edit9: TEdit; //32C
    Edit10: TEdit; //330
    Edit11: TEdit; //334
    Edit12: TEdit; //338
    Edit13: TEdit; //33C
    SpeedButton1: TSpeedButton; //340
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); //005CE4A8
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); //005CE490
    procedure BitBtn1Click(Sender: TObject); //005CE484
    procedure SpeedButton1Click(Sender: TObject); //005CE4D4
    procedure FormClose(Sender: TObject; var Action: TCloseAction); //005CE4C4
    procedure FormActivate(Sender: TObject); //005CE4C0
    procedure Edit1Change(Sender: TObject); //005CE2F4
    procedure Kal; //005CDC40
    procedure gridleeren; //005CDBE0
    procedure FormCreate(Sender: TObject); //005CDACC
    procedure Button2Click(Sender: TObject); //005CE200
    procedure Button1Click(Sender: TObject); //005CE10C
    procedure FormShow(Sender: TObject); //005CE104
  end;

var
  Form6: TForm6;

implementation

uses
  AHNGlobals;

{$R ..\Forms\Form6.DFM}

{ The year that is currently shown. }
const
  MIN_YEAR = 1581;   // $62D
  MAX_YEAR = 2499;   // $9C3

{ The wording of the three message boxes of the original is not recoverable:
  the IDR output does not annotate the string constants of the binary. The
  messages below state the same limits as the original. }

// 005CDACC
procedure TForm6.FormCreate(Sender: TObject);
var
  Factor1, Factor2: Double;
begin
  { On a screen that is larger than 640 x 480 the form is scaled down. }
  if Screen.Width > 640 then
    if Screen.Height > 480 then
      ScaleBy(640, 800);

  { The row height and the column width of the three month grids are
    computed from the height of the character (18) and the width of the
    character (23) of the standard font, multiplied by the zoom factor.
    The listing stores the two factors as the double values 1.0. }
  Factor1 := 1.0;
  Factor2 := 1.0;
  StringGrid1.DefaultRowHeight := Round(18 * Factor1);
  StringGrid1.DefaultColWidth := Round(23 * Factor2);
  StringGrid2.DefaultRowHeight := Round(18 * Factor1);
  StringGrid2.DefaultColWidth := Round(23 * Factor2);
  StringGrid3.DefaultRowHeight := Round(18 * Factor1);
  StringGrid3.DefaultColWidth := Round(23 * Factor2);
end;

// 005CDBE0
procedure TForm6.gridleeren;
var
  Row, Col: Integer;
begin
  { All three month grids are cleared. The listing loops over the rows of
    the first grid and over eight columns, and writes an empty string into
    every cell of the three grids. }
  Row := StringGrid1.ColCount - 1;
  while Row > 0 do
  begin
    Col := 1;
    while Col <> 8 do
    begin
      StringGrid1.Cells[Col, Row] := '';
      StringGrid2.Cells[Col, Row] := '';
      StringGrid3.Cells[Col, Row] := '';
      Inc(Col);
    end;
    Inc(Row);
  end;
end;

// 005CE104
procedure TForm6.FormShow(Sender: TObject);
begin
  { The calendar is calculated when the window is shown. }
  Kal;
end;

// 005CE10C
procedure TForm6.Button1Click(Sender: TObject);
begin
  { The ">" button shows the next year. When the year would exceed the
    upper limit, a message is shown and the year stays. }
  if StrToInt(Edit1.Text) < MAX_YEAR then
  begin
    Edit1.Text := IntToStr(gvar_025368E8 + 1);
    Kal;
  end
  else
  begin
    Application.MessageBox(PChar('Das Jahr darf hoechstens ' + IntToStr(MAX_YEAR) + ' sein.'),
                           PChar('Gregorianischer Kalender'), MB_OK);
    Edit1.Text := IntToStr(gvar_025368E8);
  end;
end;

// 005CE200
procedure TForm6.Button2Click(Sender: TObject);
begin
  { The "<" button shows the previous year. When the year would fall below
    the lower limit, a message is shown and the year stays. }
  if StrToInt(Edit1.Text) > MIN_YEAR then
  begin
    Edit1.Text := IntToStr(gvar_025368E8 - 1);
    Kal;
  end
  else
  begin
    Application.MessageBox(PChar('Das Jahr darf fruehestens ' + IntToStr(MIN_YEAR) + ' sein.'),
                           PChar('Gregorianischer Kalender'), MB_OK);
    Edit1.Text := IntToStr(gvar_025368E8);
  end;
end;

// 005CE2F4
procedure TForm6.Edit1Change(Sender: TObject);
begin
  { The year was typed in. Only four digits are accepted, and the year has
    to lie between 1581 and 2499; otherwise a message is shown and the
    field is reset to the year that is currently shown. }
  if Length(Edit1.Text) = 4 then
  begin
    if (StrToInt(Edit1.Text) > MIN_YEAR) and (StrToInt(Edit1.Text) < MAX_YEAR + 1) then
      Kal
    else
    begin
      if StrToInt(Edit1.Text) < MIN_YEAR then
        Application.MessageBox(PChar('Das Jahr muss mindestens ' + IntToStr(MIN_YEAR) + ' sein.'),
                               PChar('Gregorianischer Kalender'), MB_OK);
      if StrToInt(Edit1.Text) > MAX_YEAR then
        Application.MessageBox(PChar('Das Jahr darf hoechstens ' + IntToStr(MAX_YEAR) + ' sein.'),
                               PChar('Gregorianischer Kalender'), MB_OK);
      Edit1.Text := IntToStr(gvar_025368E8);
    end;
  end;
end;

// 005CE484
procedure TForm6.BitBtn1Click(Sender: TObject);
begin
  { The close button closes the calendar. }
  Close;
end;

// 005CE490
procedure TForm6.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  { The escape key closes the calendar. }
  if Key = VK_ESCAPE then
    Close;
end;

// 005CE4A8
procedure TForm6.Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  { The escape key closes the calendar. }
  if Key = VK_ESCAPE then
    Close;
end;

// 005CE4C0
procedure TForm6.FormActivate(Sender: TObject);
begin
  { The listing is empty - the method exists because the DFM binds
    OnActivate. }
end;

// 005CE4C4
procedure TForm6.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { The window is minimised when it is closed. }
  WindowState := wsMinimized;
end;

// 005CE4D4
procedure TForm6.SpeedButton1Click(Sender: TObject);
begin
  { The print button hides the controls that must not appear on the print
    out, prints the form and shows them again. }
  Button1.Visible := False;
  Button2.Visible := False;
  BitBtn1.Visible := False;
  SpeedButton1.Visible := False;
  Print;
  Button1.Visible := True;
  Button2.Visible := True;
  BitBtn1.Visible := True;
  SpeedButton1.Visible := True;
end;

// 005CDC40
procedure TForm6.Kal;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

end.
