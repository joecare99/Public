unit Unit24;

{-------------------------------------------------------------------------------
  Unit24 - TForm24, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit24.pas and the original resource
  Source\Projects_AhnenWin\Form24.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, StdCtrls, ExtCtrls, Buttons, Forms, Controls, Grids, DB, AHNGlobals, Unit1;

type
  TForm24 = class(TForm)
  published
    Label1: TLabel; //2F0
    Label2: TLabel; //2F4
    ListBox1: TListBox; //2F8
    ListBox2: TListBox; //2FC
    ListBox3: TListBox; //300
    ListBox4: TListBox; //304
    Button2: TButton; //308
    Button3: TButton; //30C
    Button4: TButton; //310
    Button5: TButton; //314
    Button6: TButton; //318
    Button7: TButton; //31C
    Panel1: TPanel; //320
    Shape1: TShape; //324
    Panel2: TPanel; //328
    Button9: TButton; //32C
    CheckBox4: TCheckBox; //330
    CheckBox5: TCheckBox; //334
    CheckBox6: TCheckBox; //338
    CheckBox7: TCheckBox; //33C
    CheckBox8: TCheckBox; //340
    CheckBox9: TCheckBox; //344
    Panel3: TPanel; //348
    RadioButton4: TRadioButton; //34C
    RadioButton5: TRadioButton; //350
    SpeedButton1: TSpeedButton; //354
    SpeedButton2: TSpeedButton; //358
    CheckBox2: TCheckBox; //35C
    CheckBox10: TCheckBox; //360
    ListBox5: TListBox; //364
    ListBox6: TListBox; //368
    Button1: TButton; //36C
    Button8: TButton; //370
    Button10: TButton; //374
    Label4: TLabel; //378
    CheckBox1: TCheckBox; //37C
    Panel4: TPanel; //380
    Label3: TLabel; //384
    RadioButton1: TRadioButton; //388
    RadioButton2: TRadioButton; //38C
    RadioButton3: TRadioButton; //390
    CheckBox14: TCheckBox; //394
    CheckBox16: TCheckBox; //398
    CheckBox15: TCheckBox; //39C
    CheckBox17: TCheckBox; //3A0
    Label5: TLabel; //3A4
    CheckBox18: TCheckBox; //3A8
    CheckBox3: TCheckBox; //3AC
    CheckBox11: TCheckBox; //3B0
    procedure RadioButton5Click(Sender: TObject); //0055F5E0
    procedure SpeedButton1Click(Sender: TObject); //0055F698
    procedure SpeedButton2Click(Sender: TObject); //0055F78C
    procedure ListBox4DblClick(Sender: TObject); //0055F11C
    procedure FormClose(sender:tobject;var action:tcloseaction); //0055F144
    procedure RadioButton4Click(Sender: TObject); //0055F528
    procedure Button8Click(Sender: TObject); //0055F8C4
    procedure Button10Click(Sender: TObject); //0055F920
    procedure ListBox5DblClick(Sender: TObject); //0055F954
    procedure CheckBox17Click(Sender: TObject); //0055F7BC
    procedure CheckBox18Click(Sender: TObject); //0055F7E4
    procedure Button1Click(Sender: TObject); //0055F80C
    procedure Button2Click(Sender: TObject); //0055EEAC
    procedure Button4Click(Sender: TObject); //0055EF20
    procedure Button6Click(Sender: TObject); //0055EF48
    procedure Button9Click(Sender: TObject); //0055EE60
    procedure FormShow(Sender: TObject); //0055EE78
    procedure listanz; //0055EC64
    procedure ListBox1DblClick(Sender: TObject); //0055F00C
    procedure ListBox2DblClick(Sender: TObject); //0055F080
    procedure ListBox3DblClick(Sender: TObject); //0055F0F4
    procedure Button3Click(Sender: TObject); //0055EF5C
    procedure Button5Click(Sender: TObject); //0055EFD0
    procedure Button7Click(Sender: TObject); //0055EFF8
  end;

var
  Form24: TForm24;

implementation

{$R ..\Forms\Form24.DFM}


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure TForm24.RadioButton5Click(Sender: TObject);
begin
  { None of the kinds of the relations is wanted. }
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
  CheckBox11.Checked := False;
end;

procedure TForm24.SpeedButton1Click(Sender: TObject);
begin
  { The print of the family chart is started.  The user gets a warning
    when nothing was selected at all. }
  if (ListBox3.Items.Count = 0) and (ListBox4.Items.Count = 0) and
     (ListBox6.Items.Count = 0) then
    Application.MessageBox('Weder Name noch Ort noch Hofname ausgew' + #228 + 'hlt',
      'OFB-Druck', 0);
  gvar_02536B50 := 'butt1';
  ModalResult := mrCancel;
end;

procedure TForm24.SpeedButton2Click(Sender: TObject);
begin
  gvar_02536B50 := 'butt8';
  ModalResult := mrCancel;
end;

procedure TForm24.ListBox4DblClick(Sender: TObject);
begin
  { The marked entry is removed. }
  ListBox4.Items.Delete(ListBox4.ItemIndex);
end;

procedure TForm24.FormClose(sender:tobject;var action:tcloseaction);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm24.RadioButton4Click(Sender: TObject);
begin
  { All the kinds of the relations are wanted. }
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
  CheckBox11.Checked := True;
end;

procedure TForm24.Button8Click(Sender: TObject);
begin
  { The marked entry is removed from the list of the persons. }
  ListBox6.Items.Delete(ListBox6.ItemIndex);
  if ListBox6.Items.Count = 0 then
  begin
    RadioButton1.Enabled := True;
    RadioButton3.Enabled := True;
  end;
end;

procedure TForm24.Button10Click(Sender: TObject);
begin
  { The list of the persons is cleared. }
  ListBox6.Clear;
  RadioButton1.Enabled := True;
  RadioButton3.Enabled := True;
end;

procedure TForm24.ListBox5DblClick(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm24.CheckBox17Click(Sender: TObject);
begin
  { The two choices exclude each other. }
  if not CheckBox17.Checked then
    CheckBox18.Checked := True;
end;

procedure TForm24.CheckBox18Click(Sender: TObject);
begin
  { The two choices exclude each other. }
  if not CheckBox17.Checked then
    CheckBox18.Checked := True;
end;

procedure TForm24.Button1Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm24.Button2Click(Sender: TObject);
begin
  { The marked entry is taken over into the list of the selection. }
  ListBox3.Items.Add(ListBox1.Items[ListBox1.ItemIndex]);
end;

procedure TForm24.Button4Click(Sender: TObject);
begin
  { The marked entry is removed. }
  ListBox3.Items.Delete(ListBox3.ItemIndex);
end;

procedure TForm24.Button6Click(Sender: TObject);
begin
  { The list is cleared. }
  ListBox3.Clear;
end;

procedure TForm24.Button9Click(Sender: TObject);
begin
  { The lists are rebuilt. }
  Form1.listen_akt;
  listanz;
end;

procedure TForm24.FormShow(Sender: TObject);
begin
  { The lists are filled; the two choices are enabled. }
  listanz;
  RadioButton1.Enabled := True;
  RadioButton3.Enabled := True;
  { The original uses SetActiveControl, which is private in Delphi 9. }
  ListBox1.SetFocus;
end;

procedure TForm24.listanz;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm24.ListBox1DblClick(Sender: TObject);
begin
  { The marked entry is taken over into the list of the selection. }
  ListBox3.Items.Add(ListBox1.Items[ListBox1.ItemIndex]);
end;

procedure TForm24.ListBox2DblClick(Sender: TObject);
begin
  { The marked entry is taken over into the list of the selection. }
  ListBox4.Items.Add(ListBox2.Items[ListBox2.ItemIndex]);
end;

procedure TForm24.ListBox3DblClick(Sender: TObject);
begin
  { The marked entry is removed. }
  ListBox3.Items.Delete(ListBox3.ItemIndex);
end;

procedure TForm24.Button3Click(Sender: TObject);
begin
  { The marked entry is taken over into the list of the selection. }
  ListBox4.Items.Add(ListBox2.Items[ListBox2.ItemIndex]);
end;

procedure TForm24.Button5Click(Sender: TObject);
begin
  { The marked entry is removed. }
  ListBox4.Items.Delete(ListBox4.ItemIndex);
end;

procedure TForm24.Button7Click(Sender: TObject);
begin
  { The list is cleared. }
  ListBox4.Clear;
end;


end.
