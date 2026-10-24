unit Unit19;

{-------------------------------------------------------------------------------
  Unit19 - TForm19, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit19.pas and the original resource
  Source\Projects_AhnenWin\Form19.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, Buttons, ExtCtrls, StdCtrls, Forms, Controls, Grids, DB;

type
  TForm19 = class(TForm)
  public
    Mode: Integer; //24C  vom Original ueber Offset 24C adressiert
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
    Panel4: TPanel; //33C
    Label1: TLabel; //340
    RadioButton1: TRadioButton; //344
    RadioButton2: TRadioButton; //348
    Edit1: TEdit; //34C
    Button1: TButton; //350
    Button2: TButton; //354
    Panel5: TPanel; //358
    ComboBox1: TComboBox; //35C
    Label2: TLabel; //360
    Label3: TLabel; //364
    Edit2: TEdit; //368
    Button3: TButton; //36C
    Button4: TButton; //370
    CheckBox9: TCheckBox; //374
    CheckBox10: TCheckBox; //378
    CheckBox17: TCheckBox; //37C
    procedure Button4Click(Sender: TObject); //005588F4
    procedure voralph; //005574EC
    procedure vorf; //00557E64
    procedure Button3Click(Sender: TObject); //00558850
    procedure vorchron; //005574B4
    procedure namgv; //0055748C
    procedure CheckBox15Click(Sender: TObject); //00558A00
    procedure alphlist; //00557514
    procedure ComboBox1Change(Sender: TObject); //00558964
    procedure nachf; //00557E8C
    procedure RadioButton2Click(Sender: TObject); //005511C0
    procedure Button1Click(Sender: TObject); //005512D8
    procedure BitBtn2Click(Sender: TObject); //0055108C
    procedure RadioButton1Click(Sender: TObject); //005510A8
    procedure Button2Click(Sender: TObject); //0055137C
    procedure Namgeb; //005513EC
    procedure FormShow(Sender: TObject); //005587E0
    procedure BitBtn1Click(Sender: TObject); //00558730
    procedure Nachliste; //00552034
  end;

var
  Form19: TForm19;

implementation

uses
  Unit1, AHNGlobals, StrUtils;

{$R ..\Forms\Form19.DFM}

procedure sub_00550AB8(AValue: Integer; var AResult: AnsiString);
var
  s: AnsiString;
begin
  //00550AB8: Zahl auf 6 Stellen mit fuehrenden Nullen formatieren.
  s := '000000' + IntToStr(AValue);
  AResult := Copy(s, Length(s) - 5, 6);
end;

procedure sub_00550B5C(AValue: Integer; var AResult: AnsiString);
var
  s: AnsiString;
begin
  //00550B5C: Zahl auf 3 Stellen mit fuehrenden Leerzeichen formatieren.
  s := '   ' + IntToStr(AValue);
  AResult := Copy(s, Length(s) - 2, 3);
end;

procedure sub_00550BFC(AIn: AnsiString; var AOut: AnsiString);
var
  i: Integer;
  c: AnsiChar;
begin
  //00550BFC: Grossbuchstaben inkl. deutscher Umlaute, Zeichen fuer Zeichen.
  AOut := '';
  for i := 1 to Length(AIn) do
  begin
    c := AnsiChar(AIn[i]);
    if (c = #$E4) or (c = #$F6) or (c = #$FC) then
    begin
      if c = #$E4 then
        AOut := AOut + #$C4
      else if c = #$F6 then
        AOut := AOut + #$D6
      else
        AOut := AOut + #$DC;
    end
    else
      AOut := AOut + UpperCase(string(c));
  end;
end;

procedure sub_00550DA0(const AIn: AnsiString; var AOut: AnsiString);
var
  s: AnsiString;
  i, n: Integer;
begin
  //00550DA0: Datums-/Sternzeichen-Normalisierer (Schwester von sub_00545A0C).
  AOut := AIn;
  s := Trim(AIn);
  if s = '..' then
  begin
    AOut := '';
    Exit;
  end;
  if Copy(AIn, 1, 2) = 'HK' then
  begin
    AOut := 'HK ' + Copy(AIn, 4, 7);
    Exit;
  end;
  if Pos('vo.r', AIn) > 0 then
  begin
    AOut := Copy(AIn, 1, 2) + Copy(AIn, 4, 1) + ' ' + RightStr(AIn, 4);
    Exit;
  end;
  if Pos('na.ch', AIn) > 0 then
  begin
    AOut := Copy(AIn, 1, 2) + Copy(AIn, 4, 2) + ' ' + RightStr(AIn, 4);
    Exit;
  end;
  s := Trim(AIn);
  if s = '' then
    Exit;
  while Pos(Copy(s, 1, 1), '. ') > 0 do
    s := Copy(s, 2, 9);
  AOut := s;
  if Length(AIn) > 39 then
  begin
    AOut := '';
    for i := 1 to Length(AIn) do
      if AIn[i] <> '.' then
        AOut := AOut + AIn[i];
    n := Length(AOut);
    for i := 1 to n do
    begin
      if AnsiChar(AOut[i]) < ':' then
      begin
        Insert(' ', AOut, i);
        Break;
      end;
    end;
  end;
end;

{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure TForm19.Button4Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm19.voralph;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm19.vorf;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm19.Button3Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm19.vorchron;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm19.namgv;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm19.CheckBox15Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm19.alphlist;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm19.ComboBox1Change(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm19.nachf;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm19.RadioButton2Click(Sender: TObject);
begin
  //005511C0: alle Selektions-CheckBoxen abwaehlen.
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
  CheckBox12.Checked := False;
  CheckBox13.Checked := False;
  CheckBox14.Checked := False;
  CheckBox15.Checked := False;
  CheckBox16.Checked := False;
  CheckBox17.Checked := False;
end;

procedure TForm19.Button1Click(Sender: TObject);
begin
  //005512D8: Positionszahl in Edit1 um 1 verkleinern (unter 1 nicht).
  if Edit1.Text > '1' then
    Edit1.Text := IntToStr(StrToInt(Edit1.Text) - 1);
end;

procedure TForm19.BitBtn2Click(Sender: TObject);
begin
  //0055108C: Form19.Mode := 2 und Form1 anzeige neu aufbauen.
  { gvar_0061F010 ist hier Form19; Form1 global per gvar_02536908^. }
  Form19.Mode := 2;
  Form1.anzeigen;
end;

procedure TForm19.RadioButton1Click(Sender: TObject);
begin
  //005510A8: alle Selektions-CheckBoxen anwaehlen.
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
  CheckBox12.Checked := True;
  CheckBox13.Checked := True;
  CheckBox14.Checked := True;
  CheckBox15.Checked := True;
  CheckBox16.Checked := True;
  CheckBox17.Checked := True;
end;

procedure TForm19.Button2Click(Sender: TObject);
begin
  //0055137C: Positionszahl in Edit1 um 1 vergroessern.
  Edit1.Text := IntToStr(StrToInt(Edit1.Text) + 1);
end;

procedure TForm19.Namgeb;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm19.FormShow(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm19.BitBtn1Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm19.Nachliste;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;


end.
