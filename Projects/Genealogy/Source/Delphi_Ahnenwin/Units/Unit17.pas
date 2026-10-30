unit Unit17;

{-------------------------------------------------------------------------------
  Unit17 - TForm17, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit17.pas and the original resource
  Source\Projects_AhnenWin\Form17.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, Buttons, ExtCtrls, StdCtrls, Forms, Controls, Grids, DB, Unit2, AHNGlobals, Unit1;

type
  TForm17 = class(TForm)
  published
    BitBtn1: TBitBtn; //2F0
    BitBtn2: TBitBtn; //2F4
    Panel1: TPanel; //2F8
    Shape1: TShape; //2FC
    CheckBox1: TCheckBox; //300
    CheckBox2: TCheckBox; //304
    CheckBox3: TCheckBox; //308
    CheckBox4: TCheckBox; //30C
    CheckBox5: TCheckBox; //310
    CheckBox6: TCheckBox; //314
    CheckBox7: TCheckBox; //318
    CheckBox8: TCheckBox; //31C
    CheckBox11: TCheckBox; //320
    CheckBox12: TCheckBox; //324
    CheckBox13: TCheckBox; //328
    CheckBox14: TCheckBox; //32C
    CheckBox15: TCheckBox; //330
    CheckBox16: TCheckBox; //334
    RadioButton1: TRadioButton; //338
    RadioButton2: TRadioButton; //33C
    CheckBox9: TCheckBox; //340
    procedure RadioButton1Click(Sender: TObject); //00545014
    procedure fambeltern; //0053FD18
    procedure FormShow(Sender: TObject); //00545204
    procedure RadioButton2Click(Sender: TObject); //0054510C
    procedure nam2(AIn: AnsiString); //0053CC38
    procedure BitBtn1Click(Sender: TObject); //005405C4
    procedure BitBtn2Click(Sender: TObject); //005405A0
    procedure gebstvn; //0053D358
    procedure gebst; //0053E878
  end;

var
  Form17: TForm17;

implementation

{$R ..\Forms\Form17.DFM}


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure TForm17.RadioButton1Click(Sender: TObject);
begin
  { (00545014) "alle markieren" - every checkbox of the parameters is checked. }
  CheckBox1.Checked  := True;
  CheckBox2.Checked  := True;
  CheckBox3.Checked  := True;
  CheckBox4.Checked  := True;
  CheckBox5.Checked  := True;
  CheckBox6.Checked  := True;
  CheckBox7.Checked  := True;
  CheckBox8.Checked  := True;
  CheckBox9.Checked  := True;
  CheckBox11.Checked := True;
  CheckBox12.Checked := True;
  CheckBox13.Checked := True;
  CheckBox14.Checked := True;
  CheckBox15.Checked := True;
  CheckBox16.Checked := True;
end;

procedure TForm17.fambeltern;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm17.FormShow(Sender: TObject);
begin
  { (00545204) The table of the parameters of the family chart is opened
    with the index 'tit' and positioned on the first record. }
  DataModule2.Table38.Open;
  DataModule2.Table38.IndexName := 'tit';
  DataModule2.Table38.First;
end;

procedure TForm17.RadioButton2Click(Sender: TObject);
begin
  { (0054510C) "alle l'oschen" - every checkbox of the parameters is unchecked. }
  CheckBox1.Checked  := False;
  CheckBox2.Checked  := False;
  CheckBox3.Checked  := False;
  CheckBox4.Checked  := False;
  CheckBox5.Checked  := False;
  CheckBox6.Checked  := False;
  CheckBox7.Checked  := False;
  CheckBox8.Checked  := False;
  CheckBox9.Checked  := False;
  CheckBox11.Checked := False;
  CheckBox12.Checked := False;
  CheckBox13.Checked := False;
  CheckBox14.Checked := False;
  CheckBox15.Checked := False;
  CheckBox16.Checked := False;
end;

procedure TForm17.nam2(AIn: AnsiString);
var
  s, t: AnsiString;
begin
  { 0053CC38: Builds the name output line "s" for the family sheet
    from the caller's name text AIn plus the current Table3 person,
    gated by the sheet's checkboxes; writes both strings to Table14.
    AIn is cleared in two listing-faithful edge cases (see below). }
  s := '';
  if CheckBox9.Checked then
  begin
    Form1.ucase(DataModule2.Table3Name.AsString, t);
    s := AIn + t + ' ' + DataModule2.Table3Vornamen.AsString +
      ' (DS ' + IntToStr(DataModule2.Table3Nummer.AsInteger) + ')';
  end
  else if Pos('                oo ', AIn) > 0 then
  begin
    Form1.ucase(DataModule2.Table3Name.AsString, t);
    s := AIn + #13#10 + '                    ' + t + ' ' +
      DataModule2.Table3Vornamen.AsString;
  end
  else
  begin
    Form1.ucase(DataModule2.Table3Name.AsString, t);
    s := AIn + t + ' ' + DataModule2.Table3Vornamen.AsString;
  end;
  if CheckBox1.Checked then
    if DataModule2.Table3IDNR.AsString <> '' then
      s := s + ' (ID: ' + DataModule2.Table3IDNR.AsString + ')';
  if CheckBox11.Checked then
    if DataModule2.Table3Beruf.AsString <> '' then
      s := s + ', ' + DataModule2.Table3Beruf.AsString;
  if CheckBox13.Checked then
    if DataModule2.Table3Hausname.AsString <> '' then
      s := s + ', ' + DataModule2.Table3Hausname.AsString;
  if CheckBox7.Checked then
    if DataModule2.Table3Religion.AsString <> '' then
      s := s + ', ' + DataModule2.Table3Religion.AsString;
  if Copy(AIn, 1, 5) = '     ' then
    AIn := Copy(AIn, 1, Length(AIn) - Length(TrimLeft(AIn)))
  else if Trim(AIn) <> '' then
    AIn := ''; {0053CF57: verbatim - nonempty AIn is cleared here
      (LStrClr [ebp-4]); listing-faithful. }
  if s <> '' then
  begin
    DataModule2.Table14.Append;
    DataModule2.Table14Zeile.AsString := s;
    DataModule2.Table14Nm2.AsString := AIn;
    DataModule2.Table14.Post;
  end;
end;

procedure TForm17.BitBtn1Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm17.BitBtn2Click(Sender: TObject);
begin
  { (005405A0) "Abbruch" - the form is closed with the value 2 in
    TCustomForm.FModalResult (mrCancel); the flag that the family chart
    was requested is cleared; the person is shown again. }
  ModalResult := 2;
  gvar_0061EFD0 := 0;
  Form1.anzeigen;
end;

procedure TForm17.gebstvn;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm17.gebst;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;


end.
