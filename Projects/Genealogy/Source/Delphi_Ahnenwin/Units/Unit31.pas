unit Unit31;

{-------------------------------------------------------------------------------
  Unit31 - TForm31, the FOKO list field selection of AHNENWIN 5.1.

  Reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit31.pas and the original resource
  Source\Projects_AhnenWin\Form31.dfm.

  The dialog selects the fields that the FOKO list is to contain. Two of the
  check boxes are action buttons:

    CheckBox9  "alle markieren"   - marks all the other fifteen
    CheckBox10 "alle loeschen"    - clears all the other fifteen

  Both leave their own state untouched - the listing of the two handlers
  contains the other fifteen check boxes and not the respective one.

  Method addresses (original binary):
    00562F00  CheckBox9Click    (alle markieren)
    00562FF8  CheckBox10Click   (alle loeschen)
    005630F0  BitBtn1Click      (Fertig)
    005630FC  BitBtn2Click      (close)
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, ExtCtrls, StdCtrls, Buttons, Forms, Controls;

type
  TForm31 = class(TForm)
  published
    BitBtn1: TBitBtn; //2F0
    BitBtn2: TBitBtn; //2F4
    Panel1: TPanel; //2F8
    CheckBox2: TCheckBox; //2FC
    CheckBox1: TCheckBox; //300
    CheckBox3: TCheckBox; //304
    CheckBox4: TCheckBox; //308
    CheckBox5: TCheckBox; //30C
    CheckBox6: TCheckBox; //310
    CheckBox12: TCheckBox; //314
    CheckBox13: TCheckBox; //318
    CheckBox14: TCheckBox; //31C
    CheckBox15: TCheckBox; //320
    CheckBox16: TCheckBox; //324
    Panel2: TPanel; //328
    CheckBox7: TCheckBox; //32C
    CheckBox8: TCheckBox; //330
    CheckBox11: TCheckBox; //334
    Panel3: TPanel; //338
    CheckBox9: TCheckBox; //33C
    CheckBox10: TCheckBox; //340
    procedure BitBtn1Click(Sender: TObject); //005630F0
    procedure BitBtn2Click(Sender: TObject); //005630FC
    procedure CheckBox9Click(Sender: TObject); //00562F00
    procedure CheckBox10Click(Sender: TObject); //00562FF8
  end;

var
  Form31: TForm31;

implementation

{$R ..\Forms\Form31.DFM}

// 00562F00
procedure TForm31.CheckBox9Click(Sender: TObject);
begin
  { "alle markieren" - all the field check boxes are marked. The check box
    itself is not part of the list, the listing touches fifteen boxes. }
  CheckBox1.Checked := True;
  CheckBox2.Checked := True;
  CheckBox3.Checked := True;
  CheckBox4.Checked := True;
  CheckBox5.Checked := True;
  CheckBox6.Checked := True;
  CheckBox7.Checked := True;
  CheckBox8.Checked := True;
  CheckBox11.Checked := True;
  CheckBox12.Checked := True;
  CheckBox13.Checked := True;
  CheckBox14.Checked := True;
  CheckBox15.Checked := True;
  CheckBox16.Checked := True;
  CheckBox10.Checked := True;
end;

// 00562FF8
procedure TForm31.CheckBox10Click(Sender: TObject);
begin
  { "alle loeschen" - all the field check boxes are cleared. As above, the
    check box itself is not part of the list. }
  CheckBox1.Checked := False;
  CheckBox2.Checked := False;
  CheckBox3.Checked := False;
  CheckBox4.Checked := False;
  CheckBox5.Checked := False;
  CheckBox6.Checked := False;
  CheckBox7.Checked := False;
  CheckBox8.Checked := False;
  CheckBox9.Checked := False;
  CheckBox11.Checked := False;
  CheckBox12.Checked := False;
  CheckBox13.Checked := False;
  CheckBox14.Checked := False;
  CheckBox15.Checked := False;
  CheckBox16.Checked := False;
end;

// 005630F0
procedure TForm31.BitBtn1Click(Sender: TObject);
begin
  { "Fertig" - the dialog is hidden, the selection is read by the caller
    when the form is shown again. }
  Hide;
end;

// 005630FC
procedure TForm31.BitBtn2Click(Sender: TObject);
begin
  { The second button closes the dialog. }
  Close;
end;

end.
