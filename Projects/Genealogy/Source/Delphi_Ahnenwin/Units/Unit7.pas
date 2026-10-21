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
  SysUtils, Classes, ExtCtrls, StdCtrls, Buttons, Forms, Controls, Windows;

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
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

end.
