unit Unit10;

{-------------------------------------------------------------------------------
  Unit10 - TForm10, the browser that shows the computed Easter date.

  Reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit10.pas and the original resource
  Source\Projects_AhnenWin\Form10.dfm.

  The form shows the result of the Easter calculation in a web browser. The
  buttons of the browser control are driven through ExecWB:

    OLECMDID_SAVEAS    = 4   (save the page)
    OLECMDID_PRINTPREVIEW = 6 (print preview)

  The year can be changed with the two arrow buttons and in the edit field;
  the allowed range is 1582 .. 2499.

  Method addresses (original binary):
    0055A124  BitBtn1Click       (print preview)
    0055A138  BitBtn2Click       (save the page)
    0055A160  SpeedButton1Click  (Fertig)
    0055A1AC  SpeedButton2Click  (print preview)
    0055A1C0  SpeedButton3Click  (save the page)
    0055A1D4  SpeedButton4Click  (the style sheet generator)
    0055A4B8  SpeedButton5Click
    0055A4C8  Browser            (still open)
    0055A54C  rechnen            (the Easter calculation, still open)
    0055AEF8  FormShow
    0055B000  Edit1Change
    0055B0E4  Button2Click       (previous year)
    0055B1CC  Button1Click       (next year)
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, ExtCtrls, StdCtrls, Buttons, SHDocVw, Dialogs, Forms,
  Controls, Graphics, Windows;

type
  TForm10 = class(TForm)
  published
    WebBrowser1: TWebBrowser; //2F0
    Panel1: TPanel; //2F4
    PrintDialog1: TPrintDialog; //2F8
    SaveDialog1: TSaveDialog; //2FC
    SpeedButton1: TSpeedButton; //300
    SpeedButton2: TSpeedButton; //304
    SpeedButton3: TSpeedButton; //308
    SpeedButton4: TSpeedButton; //30C
    FontDialog1: TFontDialog; //310
    OpenDialog1: TOpenDialog; //314
    SpeedButton5: TSpeedButton; //318
    Edit1: TEdit; //31C
    Button2: TButton; //320
    Button1: TButton; //324
    procedure Browser(AUrl: AnsiString); //0055A4C8
    procedure rechnen(AJahr: AnsiString); //0055A54C
    procedure FormShow(Sender: TObject); //0055AEF8
    procedure Button1Click(Sender: TObject); //0055B1CC
    procedure Button2Click(Sender: TObject); //0055B0E4
    procedure Edit1Change(Sender: TObject); //0055B000
    procedure SpeedButton5Click(Sender: TObject); //0055A4B8
    procedure SpeedButton1Click(Sender: TObject); //0055A160
    procedure BitBtn2Click(Sender: TObject); //0055A138
    procedure BitBtn1Click(Sender: TObject); //0055A124
    procedure SpeedButton4Click(Sender: TObject); //0055A1D4
    procedure SpeedButton3Click(Sender: TObject); //0055A1C0
    procedure SpeedButton2Click(Sender: TObject); //0055A1AC
  end;

var
  Form10: TForm10;

implementation

uses
  AHNGlobals, Unit1, Unit32;

{$R ..\Forms\Form10.DFM}

// 0055A124
procedure TForm10.BitBtn1Click(Sender: TObject);
begin
  { The print preview of the browser is shown. }
  WebBrowser1.ExecWB(OLECMDID_PRINTPREVIEW, 0);
end;

// 0055A138
procedure TForm10.BitBtn2Click(Sender: TObject);
begin
  { The page is saved. The file name is asked for first. }
  if SaveDialog1.Execute then
    WebBrowser1.ExecWB(OLECMDID_SAVEAS, 0);
end;

// 0055A160
procedure TForm10.SpeedButton1Click(Sender: TObject);
begin
  { "Fertig" - the browser window is closed and restored to its normal
    size. When the main form is in the "large" mode, the colour of its
    status area is reset. }
  Close;
  Width := 800;
  Height := 600;
  if gvar_02536BA0 > 1 then
    Form1.DBText1.Color := clYellow;
end;

// 0055A1AC
procedure TForm10.SpeedButton2Click(Sender: TObject);
begin
  { The print preview of the browser is shown. }
  WebBrowser1.ExecWB(OLECMDID_PRINTPREVIEW, 0);
end;

// 0055A1C0
procedure TForm10.SpeedButton3Click(Sender: TObject);
begin
  { The page is saved. }
  WebBrowser1.ExecWB(OLECMDID_SAVEAS, 0);
end;

// 0055A1D4
procedure TForm10.SpeedButton4Click(Sender: TObject);
var
  StyleFile, CorrFile: TextFile;
  Line, FontName, FontSize: string;
  HasFamily, HasSize: Boolean;
begin
  { The style sheet of the page is regenerated from the chosen font. The
    original file "style.css" is read, the rules for the font family and
    the font size are replaced, and the result is written back - first into
    a temporary file "corr.css", which then replaces "style.css". }
  if FontDialog1.Execute then
  begin
    HasFamily := False;
    HasSize := False;

    FontName := Trim(FontDialog1.Font.Name);
    if Length(FontName) > 0 then
      Font.Name := FontName;

    if FontDialog1.Font.Size > 0 then
    begin
      FontSize := IntToStr(FontDialog1.Font.Size);
      Font.Size := FontDialog1.Font.Size;
    end;

    AssignFile(StyleFile, 'style.css');
    Reset(StyleFile);
    AssignFile(CorrFile, 'corr.css');
    Rewrite(CorrFile);
    while not Eof(StyleFile) do
    begin
      ReadLn(StyleFile, Line);
      if (not HasFamily) and (Pos('font-family', Line) > 0) then
      begin
        Line := 'font-family: ' + FontName + ';';
        HasFamily := True;
      end;
      if (not HasSize) and (Pos('font-size', Line) > 0) then
      begin
        Line := 'font-size: ' + FontSize + 'pt;';
        HasSize := True;
      end;
      WriteLn(CorrFile, Line);
    end;
    CloseFile(StyleFile);
    CloseFile(CorrFile);
    DeleteFile('style.css');
    RenameFile('corr.css', 'style.css');
  end;
  WebBrowser1.Refresh;
end;

// 0055A4B8
procedure TForm10.SpeedButton5Click(Sender: TObject);
begin
  { The list of the person is shown. }
  Form32.Show;
end;

// 0055AEF8
procedure TForm10.FormShow(Sender: TObject);
var
  Year, Month, Day: Word;
begin
  { For the Easter calculation the window is enlarged and the year is set
    to the current one; the calculation is then started. }
  if gvar_0253692C = 'Oster' then
  begin
    Edit1.Visible := True;
    Button1.Visible := True;
    Button2.Visible := True;
    Width := 425;
    Height := 680;
    Refresh;
    DecodeDate(Now, Year, Month, Day);
    Edit1.Text := IntToStr(Year);
    rechnen(IntToStr(Year));
  end;
end;

// 0055B000
procedure TForm10.Edit1Change(Sender: TObject);
begin
  { The year was typed in. Only years between 1581 and 2500 are accepted. }
  if (Trim(Edit1.Text) > '1581') and (Trim(Edit1.Text) < '2501') then
    rechnen(Trim(Edit1.Text));
end;

// 0055B0E4
procedure TForm10.Button2Click(Sender: TObject);
begin
  { The "<" button shows the previous year. The earliest year is 1582. }
  if Trim(Edit1.Text) > '1582' then
    Edit1.Text := IntToStr(StrToInt(Edit1.Text) - 1);
  Edit1.Refresh;
end;

// 0055B1CC
procedure TForm10.Button1Click(Sender: TObject);
begin
  { The ">" button shows the next year. The latest year is 2500. }
  if Trim(Edit1.Text) < '2500' then
    Edit1.Text := IntToStr(StrToInt(Edit1.Text) + 1);
  Edit1.Refresh;
end;

// 0055A4C8
procedure TForm10.Browser(AUrl: AnsiString);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

// 0055A54C
procedure TForm10.rechnen(AJahr: AnsiString);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

end.
