unit Unit12;

{-------------------------------------------------------------------------------
  Unit12 - TForm12, the options dialog of the ancestor / descendant chart.

  Reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit12.pas and the original resource
  Source\Projects_AhnenWin\Form12.dfm.

  The dialog collects the options of the chart that Unit13 draws:

    CheckBox1  Bilder                  -> gvar_0061F2BC
    CheckBox2  Kekul                   -> gvar_0061F2C0
    CheckBox3  Datensatz-Nr.           -> gvar_0061F2C4
    CheckBox4  ID                      -> gvar_0061F2C8
    CheckBox5  Beruf                   -> gvar_0061F2CC
    CheckBox6  Hofname                 -> gvar_0061F2D0
    CheckBox7  Bekenntnis              -> gvar_0061F2D4
    CheckBox8  leere Boxen zeichnen    -> gvar_0061F2D8

  The kind of chart is taken from the global string gvar_0253692C, which
  the caller sets to one of "Vorgr1", "Vorgr2", "Nachgr1", "Nachgr2".

  Method addresses (original binary):
    005625DC  FormShow
    005626E8  RadioButton1Click  (alle markieren)
    00562770  RadioButton2Click  (Markierungen loeschen)
    005627F8  SpeedButton2Click  (Abbruch)
    00562814  SpeedButton1Click  (Fertig)
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, ExtCtrls, StdCtrls, Buttons, Spin, Dialogs, Forms, Controls;

type
  TForm12 = class(TForm)
  published
    CheckBox1: TCheckBox; //2F0
    CheckBox2: TCheckBox; //2F4
    CheckBox3: TCheckBox; //2F8
    CheckBox4: TCheckBox; //2FC
    CheckBox5: TCheckBox; //300
    CheckBox6: TCheckBox; //304
    CheckBox7: TCheckBox; //308
    CheckBox8: TCheckBox; //30C
    Label1: TLabel; //310
    Label2: TLabel; //314
    Panel1: TPanel; //318
    RadioButton1: TRadioButton; //31C
    RadioButton2: TRadioButton; //320
    SpinEdit1: TSpinEdit; //324
    SpinEdit2: TSpinEdit; //328
    SpeedButton1: TSpeedButton; //32C
    SpeedButton2: TSpeedButton; //330
    procedure SpeedButton2Click(Sender: TObject); //005627F8
    procedure SpeedButton1Click(Sender: TObject); //00562814
    procedure RadioButton2Click(Sender: TObject); //00562770
    procedure FormShow(Sender: TObject); //005625DC
    procedure RadioButton1Click(Sender: TObject); //005626E8
  end;

var
  Form12: TForm12;

implementation

uses
  AHNGlobals, Unit13;

{$R ..\Forms\Form12.DFM}

// 005625DC
procedure TForm12.FormShow(Sender: TObject);
begin
  { All eight option flags are cleared when the dialog is shown. }
  gvar_0061F2BC := 0;
  gvar_0061F2C0 := 0;
  gvar_0061F2C4 := 0;
  gvar_0061F2C8 := 0;
  gvar_0061F2CC := 0;
  gvar_0061F2D0 := 0;
  gvar_0061F2D4 := 0;
  gvar_0061F2D8 := 0;

  { The "leere Boxen zeichnen" option and the "Kekul" option with its two
    labels are shown by default. }
  CheckBox1.Visible := True;
  CheckBox8.Visible := False;
  CheckBox2.Visible := True;
  Label2.Visible := True;
  SpinEdit2.Visible := True;

  { For a descendant chart the Kekul option does not apply and is hidden. }
  if Pos('Nachgr', gvar_0253692C) > 0 then
  begin
    CheckBox2.Visible := False;
    Label2.Visible := False;
    SpinEdit2.Visible := False;
  end;

  { The listing evaluates Pos('Vorgr', ...) and then activates the spin
    edit for the number of generations. The result of the Pos call is not
    used for a branch - the flags it sets are never tested - so the
    activation is unconditional in the original as well. }
  ActiveControl := SpinEdit1;
end;

// 005626E8
procedure TForm12.RadioButton1Click(Sender: TObject);
begin
  { "alle markieren" - all eight option check boxes are marked. }
  CheckBox1.Checked := True;
  CheckBox2.Checked := True;
  CheckBox3.Checked := True;
  CheckBox4.Checked := True;
  CheckBox5.Checked := True;
  CheckBox6.Checked := True;
  CheckBox7.Checked := True;
  CheckBox8.Checked := True;
end;

// 00562770
procedure TForm12.RadioButton2Click(Sender: TObject);
begin
  { "Markierungen loeschen" - all eight option check boxes are cleared. }
  CheckBox1.Checked := False;
  CheckBox2.Checked := False;
  CheckBox3.Checked := False;
  CheckBox4.Checked := False;
  CheckBox5.Checked := False;
  CheckBox6.Checked := False;
  CheckBox7.Checked := False;
  CheckBox8.Checked := False;
end;

// 005627F8
procedure TForm12.SpeedButton2Click(Sender: TObject);
begin
  { "Abbruch" - the global flag gvar_02536948 is set, which tells the
    caller that the chart was not to be drawn. }
  gvar_02536948 := 1;
  ModalResult := 2;
end;

// 00562814
procedure TForm12.SpeedButton1Click(Sender: TObject);
begin
  { The eight option flags are taken over from the check boxes. }
  if CheckBox1.Checked then gvar_0061F2BC := 1;
  if CheckBox2.Checked then gvar_0061F2C0 := 1;
  if CheckBox3.Checked then gvar_0061F2C4 := 1;
  if CheckBox4.Checked then gvar_0061F2C8 := 1;
  if CheckBox5.Checked then gvar_0061F2CC := 1;
  if CheckBox6.Checked then gvar_0061F2D0 := 1;
  if CheckBox7.Checked then gvar_0061F2D4 := 1;
  if CheckBox8.Checked then gvar_0061F2D8 := 1;

  { The kind of chart decides what is drawn. }
  if gvar_0253692C = 'Vorgr1' then
  begin
    if SpinEdit1.Value < 15 then
    begin
      Form13.Caption := 'Vorfahren-Grafik I';
      Form13.Show;
      ModalResult := 2;
    end
    else
      ShowMessage('Maximal 14 Generationen m' + #246 + 'glich');
  end
  else if gvar_0253692C = 'Vorgr2' then
  begin
    if SpinEdit1.Value < 15 then
    begin
      Form13.Caption := 'Vorfahren-Grafik II';
      Form13.Show;
      ModalResult := 2;
    end
    else
      ShowMessage('Maximal 14 Generationen m' + #246 + 'glich');
  end
  else if gvar_0253692C = 'Nachgr1' then
  begin
    Form13.Caption := 'Nachfahren-Grafik I';
    Form13.Show;
    { The listing calls a dynamic method of Form13.Button2 with the
      selector -21. The dynamic method table of a class depends on the
      exact VCL version, and the decompilation does not preserve that
      table, so the selector cannot be resolved to a unique name from the
      disassembly. TControl.Click is the only dynamic method of a button
      that application code invokes; it raises the published OnClick
      handler of the button. This is the one instruction of the whole
      reconstruction that could not be derived unambiguously. }
    Form13.Button2.Click;
    ModalResult := 2;
  end
  else if gvar_0253692C = 'Nachgr2' then
  begin
    Form13.Caption := 'Nachfahren-Grafik II';
    Form13.Show;
    ModalResult := 2;
  end;
end;

end.
