unit Unit7;

{-------------------------------------------------------------------------------
  Unit7 - TForm7, the French Republican calendar of AHNENWIN 5.1.

  Reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit7.pas and the original resource
  Source\Projects_AhnenWin\Form7.dfm.

  The three combo boxes hold the day, the month and the year of a date in the
  French Republican calendar; every change of one of them triggers the
  calculation "berechnen", which converts the date into the Gregorian
  calendar.

  Method addresses (original binary):
    005CE824  berechnen          (the conversion, still open)
    005CF0D0  FormCreate
    005CF118  Button1Click
    005CF120  ComboBox1Change    (day)
    005CF178  ComboBox2Change    (month)
    005CF1D0  ComboBox3Change    (year)
    005CF228  BitBtn1Click       (fertig)
    005CF234  FormKeyDown
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, ExtCtrls, StdCtrls, Buttons, Forms, Controls, Windows,
  Dialogs;

type
  TForm7 = class(TForm)
  published
    Label1: TLabel; //2F0
    Label2: TLabel; //2F4
    Label3: TLabel; //2F8
    Label4: TLabel; //2FC
    Label5: TLabel; //300
    Shape1: TShape; //304
    ComboBox1: TComboBox; //308
    ComboBox2: TComboBox; //30C
    ComboBox3: TComboBox; //310
    Edit1: TEdit; //314
    BitBtn1: TBitBtn; //318
    procedure ComboBox3Change(Sender: TObject); //005CF1D0
    procedure ComboBox2Change(Sender: TObject); //005CF178
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); //005CF234
    procedure BitBtn1Click(Sender: TObject); //005CF228
    procedure FormCreate(Sender: TObject); //005CF0D0
    procedure berechnen; //005CE824
    procedure ComboBox1Change(Sender: TObject); //005CF120
    procedure Button1Click(Sender: TObject); //005CF118
  end;

var
  Form7: TForm7;

implementation

{$R ..\Forms\Form7.DFM}

// 005CF0D0
procedure TForm7.FormCreate(Sender: TObject);
begin
  { On a screen that is larger than 640 x 480 the form is scaled down to
    that size. The listing compares the screen width with 280 hex (640)
    and the screen height with 1E0 hex (480). }
  if Screen.Width > 640 then
    if Screen.Height > 480 then
      ScaleBy(640, Screen.Width);
end;

// 005CF118
procedure TForm7.Button1Click(Sender: TObject);
begin
  { The button closes the dialog. }
  Close;
end;

// 005CF120
procedure TForm7.ComboBox1Change(Sender: TObject);
begin
  { The day was changed - the conversion runs again, but only when the
    field is not empty. }
  if Length(ComboBox1.Text) > 0 then
    berechnen;
end;

// 005CF178
procedure TForm7.ComboBox2Change(Sender: TObject);
begin
  { The month was changed. }
  if Length(ComboBox2.Text) > 0 then
    berechnen;
end;

// 005CF1D0
procedure TForm7.ComboBox3Change(Sender: TObject);
begin
  { The year was changed. }
  if Length(ComboBox3.Text) > 0 then
    berechnen;
end;

// 005CF228
procedure TForm7.BitBtn1Click(Sender: TObject);
begin
  { "fertig" - the dialog is closed. }
  Close;
end;

// 005CF234
procedure TForm7.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  { The escape key closes the dialog. }
  if Key = VK_ESCAPE then
    Close;
end;

// 005CE824
procedure TForm7.berechnen;
var
  { ebp-8 - the date of the beginning of the month, later the result }
  Datum: Double;
  Datum0: Double;
  { ebp-0C - the formatted result string }
  S: string;
  Fehler: Integer;       // esi
  Jahr: string;          // the year text local of the listing
  S30: string;               // the day text of the "jour complementary" test
  N: Integer;            // ebp-5C - the integer that is loaded into the FPU
begin
  Fehler := 0;
  Datum0 := 0.0;
  Datum := Datum0;

  { The three fields have to be filled. }
  if (Length(ComboBox1.Text) <= 0) or (Length(ComboBox2.Text) <= 0) or
     (Length(ComboBox3.Text) <= 0) then
    Exit;

  { The month gives the date of its beginning in the year III of the
    republic. The jump table has twelve entries; the thirteenth month
    (the days of the revolution) leaves the date of the beginning empty. }
  case ComboBox2.ItemIndex of
    0: Datum := StrToDate('22.09.1792');
    1: Datum := StrToDate('22.10.1792');
    2: Datum := StrToDate('21.11.1792');
    3: Datum := StrToDate('21.12.1792');
    4: Datum := StrToDate('20.01.1793');
    5: Datum := StrToDate('19.02.1793');
    6: Datum := StrToDate('21.03.1793');
    7: Datum := StrToDate('20.04.1793');
    8: Datum := StrToDate('20.05.1793');
    9: Datum := StrToDate('19.06.1793');
    10: Datum := StrToDate('19.07.1793');
    11: Datum := StrToDate('18.08.1793');
  end;

  { The leap years of the republic: the years I, II, III, V, VI and VII
    are sextil and begin one day later than the equinox date above. The
    original compares the year with the roman numerals and adds one day;
    nothing is added for the other years. }
  Jahr := ComboBox3.Text;
  if (Trim(Jahr) = 'I') or (Trim(Jahr) = 'II') or (Trim(Jahr) = 'III') or
     (Trim(Jahr) = 'V') or (Trim(Jahr) = 'VI') or (Trim(Jahr) = 'VII') then
    Datum := Datum + 1.0;

  { The years XII and following are sextil again only under the rules of
    the original: the year XII gets one more day. }
  if Trim(Jahr) = 'XII' then
    Datum := Datum + 1.0;

  { The day: below the 30th the day is simply added to the date of the
    beginning of the month. }
  if ComboBox1.ItemIndex < 30 then
    Datum := Datum + StrToInt(Trim(ComboBox1.Text)) - 1.0
  else
  begin
    { The 30th and the following days exist only in the month Fructidor of
      the "jour complementary" - the original tests the day text between
      "30" and "jrev" (the string comparison of the listing) and the month
      for Fructidor. }
    S30 := Trim(ComboBox1.Text);
    if (S30 >= '30') and (S30 <= 'jrev') and
       (Trim(ComboBox2.Text) = 'Fructidor') then
    begin
      N := ComboBox1.ItemIndex;
      Datum := Datum + N;
    end
    else
    begin
      ShowMessage('Diesen Tag gibt es nicht.');
      Edit1.Text := '';
      Fehler := 1;
    end;
  end;

  { The special case of the "jour complementary": the day "jrev" in the
    month Fructidor of a sextil year has the days 3, 7 and 11 (the
    indices of the ComboBox3). }
  if (Trim(ComboBox1.Text) = 'jrev') and (Trim(ComboBox2.Text) = 'Fructidor') then
  begin
    if (ComboBox3.ItemIndex = 2) or (ComboBox3.ItemIndex = 6) or
       (ComboBox3.ItemIndex = 10) then
    begin
      N := ComboBox1.ItemIndex;
      Datum := Datum + N;
    end
    else
    begin
      ShowMessage('Diesen Tag gibt es nicht.');
      Edit1.Text := '';
      Fehler := 1;
    end;
  end;

  if Fehler = 0 then
  begin
    { The result is formatted, the year is taken over from the ComboBox3
      (the roman numeral is converted with its index), and the result is
      written into the field. }
    S := FormatDateTime('dd.mm.yyyy', Datum);
    N := StrToInt(Copy(S, 7, 4)) + ComboBox3.ItemIndex;
    S := Copy(S, 1, 6) + IntToStr(N);
    Datum := StrToDate(S);

    { The republican calendar ends with the 31st of December 1805. }
    if StrToDate('31.12.1805') >= Datum then
    begin
      S := FormatDateTime('dd.mm.yyyy', Datum);
      Edit1.Text := S;
    end
    else
    begin
      Application.MessageBox('Der republikanische Kalender gilt nur bis zum 31.12.1805.',
                             'Franzoesischer Revolutionskalender', MB_OK);
      Edit1.Text := '';
    end;
  end;
end;

end.
