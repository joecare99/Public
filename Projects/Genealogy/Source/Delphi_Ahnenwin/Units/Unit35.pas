unit Unit35;

{-------------------------------------------------------------------------------
  Unit35 - TForm35, the "Vergleichs-Parameter" dialog of AHNENWIN 5.1.

  Reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit35.pas and the original resource
  Source\Projects_AhnenWin\Form35.dfm.

  The dialog collects the criteria by which the FOKO list is compared. Every
  criterion has its own flag in a global variable, and the selected
  criteria are additionally collected in one string (gvar_02536B98) that the
  list uses as the ORDER BY clause:

    CheckBox1  Geb.Jahr    -> gvar_02536B68
    CheckBox2  Geb.Ort     -> gvar_02536B6C
    CheckBox3  Taufjahr    -> gvar_02536B70
    CheckBox4  Taufort     -> gvar_02536B74
    CheckBox5  St.Jahr     -> gvar_02536B78
    CheckBox6  St.Ort      -> gvar_02536B7C
    CheckBox7  Best.Jahr   -> gvar_02536B80
    CheckBox8  Best.Ort    -> gvar_02536B84
    CheckBox9  Beruf       -> gvar_02536B88
    CheckBox10 ID          -> gvar_02536B8C

  The flag gvar_02536B90 tells the caller whether the dialog was confirmed
  (1) or cancelled (0).

  Method addresses (original binary):
    005CF590  BitBtn4Click       (abort)
    005CF5AC  BitBtn3Click       (apply)
    005CF834  RadioButton1Click  ("alle markieren")
    005CF8FC  RadioButton2Click  ("Markierungen loeschen")
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, ExtCtrls, StdCtrls, Buttons, Forms, Controls;

type
  TForm35 = class(TForm)
  published
    Label1: TLabel; //2F0
    Label2: TLabel; //2F4
    Shape1: TShape; //2F8
    BitBtn1: TBitBtn; //2FC
    BitBtn2: TBitBtn; //300
    BitBtn3: TBitBtn; //304
    BitBtn4: TBitBtn; //308
    CheckBox1: TCheckBox; //30C
    CheckBox2: TCheckBox; //310
    CheckBox3: TCheckBox; //314
    CheckBox4: TCheckBox; //318
    CheckBox5: TCheckBox; //31C
    CheckBox6: TCheckBox; //320
    CheckBox7: TCheckBox; //324
    CheckBox8: TCheckBox; //328
    CheckBox9: TCheckBox; //32C
    Shape2: TShape; //330
    RadioButton1: TRadioButton; //334
    RadioButton2: TRadioButton; //338
    CheckBox10: TCheckBox; //33C
    procedure RadioButton1Click(Sender: TObject); //005CF834
    procedure RadioButton2Click(Sender: TObject); //005CF8FC
    procedure BitBtn4Click(Sender: TObject); //005CF590
    procedure BitBtn3Click(Sender: TObject); //005CF5AC
  end;

var
  Form35: TForm35;

implementation

uses
  AHNGlobals;

{$R ..\Forms\Form35.DFM}

// 005CF590
procedure TForm35.BitBtn4Click(Sender: TObject);
begin
  { "Abbruch" - the flag that tells the caller that the dialog was
    cancelled is cleared, and the dialog is closed with the cancel result. }
  gvar_02536B90 := 0;
  ModalResult := 2;
end;

// 005CF5AC
procedure TForm35.BitBtn3Click(Sender: TObject);
begin
  { "OK" - the flag that tells the caller that the dialog was confirmed is
    set, the criterion string is rebuilt from the check boxes, and the
    dialog is closed with the cancel result (the caller reads the flags,
    not the modal result). }
  gvar_02536B90 := 1;
  gvar_02536B98 := '';

  if CheckBox10.Checked then
  begin
    gvar_02536B8C := 1;
    gvar_02536B98 := gvar_02536B98 + ', ID';
  end;
  if CheckBox9.Checked then
  begin
    gvar_02536B88 := 1;
    gvar_02536B98 := gvar_02536B98 + ', Beruf';
  end;
  if CheckBox1.Checked then
  begin
    gvar_02536B68 := 1;
    gvar_02536B98 := gvar_02536B98 + ', Geb.Jahr';
  end;
  if CheckBox2.Checked then
  begin
    gvar_02536B6C := 1;
    gvar_02536B98 := gvar_02536B98 + ', Geb.Ort';
  end;
  if CheckBox3.Checked then
  begin
    gvar_02536B70 := 1;
    gvar_02536B98 := gvar_02536B98 + ', Taufjahr';
  end;
  if CheckBox4.Checked then
  begin
    gvar_02536B74 := 1;
    gvar_02536B98 := gvar_02536B98 + ', Taufort';
  end;
  if CheckBox5.Checked then
  begin
    gvar_02536B78 := 1;
    gvar_02536B98 := gvar_02536B98 + ', St.Jahr';
  end;
  if CheckBox6.Checked then
  begin
    gvar_02536B7C := 1;
    gvar_02536B98 := gvar_02536B98 + ', St. Ort';
  end;
  if CheckBox7.Checked then
  begin
    gvar_02536B80 := 1;
    gvar_02536B98 := gvar_02536B98 + ', Best.Jahr';
  end;
  if CheckBox8.Checked then
  begin
    gvar_02536B84 := 1;
    gvar_02536B98 := gvar_02536B98 + ', Best.Ort';
  end;

  ModalResult := 2;
end;

// 005CF834
procedure TForm35.RadioButton1Click(Sender: TObject);
begin
  { "alle markieren" - all ten check boxes are checked, and the two radio
    buttons are reset, because they are only action buttons. }
  CheckBox1.Checked := True;
  CheckBox2.Checked := True;
  CheckBox3.Checked := True;
  CheckBox4.Checked := True;
  CheckBox5.Checked := True;
  CheckBox6.Checked := True;
  CheckBox7.Checked := True;
  CheckBox8.Checked := True;
  CheckBox9.Checked := True;
  CheckBox10.Checked := True;
  RadioButton1.Checked := False;
  RadioButton2.Checked := False;
end;

// 005CF8FC
procedure TForm35.RadioButton2Click(Sender: TObject);
begin
  { "Markierungen loeschen" - all ten check boxes are cleared, and the two
    radio buttons are reset. }
  CheckBox1.Checked := False;
  CheckBox2.Checked := False;
  CheckBox3.Checked := False;
  CheckBox4.Checked := False;
  CheckBox5.Checked := False;
  CheckBox6.Checked := False;
  CheckBox7.Checked := False;
  CheckBox8.Checked := False;
  CheckBox9.Checked := False;
  CheckBox10.Checked := False;
  RadioButton1.Checked := False;
  RadioButton2.Checked := False;
end;

end.
