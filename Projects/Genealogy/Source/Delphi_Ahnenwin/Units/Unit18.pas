unit Unit18;

{-------------------------------------------------------------------------------
  Unit18 - TForm18, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit18.pas and the original resource
  Source\Projects_AhnenWin\Form18.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, StdCtrls, Buttons, ExtCtrls, DBTables, DBCommon, Dialogs, Forms, Controls, Grids, DB;

type
  TForm18 = class(TForm)
  published
    Label5: TLabel; //2F0
    SpeedButton1: TSpeedButton; //2F4
    Memo1: TMemo; //2F8
    Panel1: TPanel; //2FC
    Label1: TLabel; //300
    Label2: TLabel; //304
    Label3: TLabel; //308
    Label4: TLabel; //30C
    Shape1: TShape; //310
    SpeedButton2: TSpeedButton; //314
    SpeedButton3: TSpeedButton; //318
    SpeedButton4: TSpeedButton; //31C
    SpeedButton5: TSpeedButton; //320
    SpeedButton6: TSpeedButton; //324
    SpeedButton7: TSpeedButton; //328
    SpeedButton8: TSpeedButton; //32C
    SpeedButton9: TSpeedButton; //330
    SpeedButton10: TSpeedButton; //334
    ComboBox1: TComboBox; //338
    ComboBox2: TComboBox; //33C
    Edit1: TEdit; //340
    ComboBox3: TComboBox; //344
    ComboBox4: TComboBox; //348
    Edit2: TEdit; //34C
    ComboBox5: TComboBox; //350
    ComboBox6: TComboBox; //354
    Edit3: TEdit; //358
    ComboBox7: TComboBox; //35C
    ComboBox8: TComboBox; //360
    Edit4: TEdit; //364
    ComboBox9: TComboBox; //368
    ComboBox10: TComboBox; //36C
    Edit5: TEdit; //370
    ComboBox11: TComboBox; //374
    ComboBox12: TComboBox; //378
    Edit6: TEdit; //37C
    ComboBox13: TComboBox; //380
    ComboBox14: TComboBox; //384
    Edit7: TEdit; //388
    ComboBox15: TComboBox; //38C
    ComboBox16: TComboBox; //390
    ComboBox17: TComboBox; //394
    ComboBox18: TComboBox; //398
    ComboBox19: TComboBox; //39C
    ComboBox20: TComboBox; //3A0
    Edit8: TEdit; //3A4
    ComboBox21: TComboBox; //3A8
    ComboBox22: TComboBox; //3AC
    ComboBox23: TComboBox; //3B0
    ComboBox24: TComboBox; //3B4
    ComboBox25: TComboBox; //3B8
    ComboBox26: TComboBox; //3BC
    Edit9: TEdit; //3C0
    Button5: TButton; //3C4
    Button7: TButton; //3C8
    Edit23: TEdit; //3CC
    BitBtn2: TBitBtn; //3D0
    Button1: TButton; //3D4
    Query1: TQuery; //3D8
    SaveDialog1: TSaveDialog; //3DC
  public
    Mode: Integer; //24C  vom Original ueber Offset 24C adressiert
  published
    procedure ComboBox1Exit(Sender: TObject); //0054D2A0
    procedure ComboBox3Exit(Sender: TObject); //0054D33C
    procedure ComboBox5Exit(Sender: TObject); //0054D3D8
    procedure SpeedButton10Click(Sender: TObject); //0054D264
    procedure SpeedButton7Click(Sender: TObject); //0054D1B0
    procedure SpeedButton8Click(Sender: TObject); //0054D1EC
    procedure SpeedButton9Click(Sender: TObject); //0054D228
    procedure ComboBox22Exit(Sender: TObject); //0054D6E4
    procedure ComboBox25Exit(Sender: TObject); //0054D780
    procedure FormClose(sender:tobject;var action:tcloseaction); //0054D81C
    procedure ComboBox13Exit(Sender: TObject); //0054D648
    procedure ComboBox7Exit(Sender: TObject); //0054D474
    procedure ComboBox9Exit(Sender: TObject); //0054D510
    procedure ComboBox11Exit(Sender: TObject); //0054D5AC
    procedure SpeedButton1Click(Sender: TObject); //0054C2BC
    procedure suchen; //00546490
    procedure FormShow(Sender: TObject); //0054C998
    procedure speichern; //00545F08
    procedure BitBtn2Click(Sender: TObject); //00545CF8
    procedure Button5Click(Sender: TObject); //00545D20
    procedure Button7Click(Sender: TObject); //00546448
    procedure SpeedButton4Click(Sender: TObject); //0054D0FC
    procedure SpeedButton5Click(Sender: TObject); //0054D138
    procedure SpeedButton6Click(Sender: TObject); //0054D174
    procedure SpeedButton3Click(Sender: TObject); //0054D0C0
    procedure Button1Click(Sender: TObject); //0054C9C4
    procedure FormActivate(Sender: TObject); //0054CB08
    procedure SpeedButton2Click(Sender: TObject); //0054D094
  end;

var
  Form18: TForm18;

implementation

uses
  AHNGlobals, Unit16, Unit2, Unit26, Unit1, StrUtils;

procedure sub_00545A0C(AIn: AnsiString; var AOut: AnsiString);
var
  s: AnsiString;
  i: Integer;
begin
  //00545A0C: Befehlsziffern-Datumsangaben der Perfektionstabelle
  //ausdrucken und messen.
  s := AIn;
  AOut := s;
  if Trim(s) = '..' then
  begin
    AOut := '';
    Exit;
  end;
  if Copy(s, 1, 2) = 'HK' then
  begin
    AOut := 'HK ' + Copy(s, 4, 7);
    Exit;
  end;
  if Pos('vo.r', s) > 0 then
  begin
    AOut := Copy(s, 1, 2) + Copy(s, 4, 1) + ' ' + RightStr(s, 4);
    Exit;
  end;
  if Pos('na.ch', s) > 0 then
  begin
    AOut := Copy(s, 1, 2) + Copy(s, 4, 2) + ' ' + RightStr(s, 4);
    Exit;
  end;
  if Trim(s) = '' then
  begin
    AOut := '';
    Exit;
  end;
  while (Length(s) > 0) and ((s[1] = '.') or (s[1] = ' ')) do
    s := Copy(s, 2, 9);
  AOut := s;
  if (Length(s) > 0) and (s[1] > '9') then
  begin
    AOut := '';
    for i := 1 to Length(s) do
      if s[i] <> '.' then
        AOut := AOut + s[i];
    for i := 1 to Length(AOut) do
      if AOut[i] < ':' then
      begin
        Insert(' ', AOut, i);
        Break;
      end;
  end;
end;

{$R ..\Forms\Form18.DFM}


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure TForm18.SpeedButton3Click(Sender: TObject);
begin
  //0054D0C0: Suchgruppe 2 (Vorname/Ehepartner) leeren.
  ComboBox15.Text := '';
  ComboBox3.Text := '';
  ComboBox4.Text := '';
  Edit2.Text := '';
end;

procedure TForm18.SpeedButton4Click(Sender: TObject);
begin
  //0054D0FC: Suchgruppe 3 (Geburtsort) leeren.
  ComboBox16.Text := '';
  ComboBox5.Text := '';
  ComboBox6.Text := '';
  Edit3.Text := '';
end;

procedure TForm18.SpeedButton5Click(Sender: TObject);
begin
  //0054D138: Suchgruppe 4 (Gestorbensort) leeren.
  ComboBox17.Text := '';
  ComboBox7.Text := '';
  ComboBox8.Text := '';
  Edit4.Text := '';
end;

procedure TForm18.SpeedButton6Click(Sender: TObject);
begin
  //0054D174: Suchgruppe 5 (Taufpaten) leeren.
  ComboBox18.Text := '';
  ComboBox9.Text := '';
  ComboBox10.Text := '';
  Edit5.Text := '';
end;

procedure TForm18.SpeedButton7Click(Sender: TObject);
begin
  //0054D1B0: Suchgruppe 6 (Heiratsort) leeren.
  ComboBox19.Text := '';
  ComboBox11.Text := '';
  ComboBox12.Text := '';
  Edit6.Text := '';
end;

procedure TForm18.SpeedButton8Click(Sender: TObject);
begin
  //0054D1EC: Suchgruppe 7 (Beruf/Quelle) leeren.
  ComboBox20.Text := '';
  ComboBox13.Text := '';
  ComboBox14.Text := '';
  Edit7.Text := '';
end;

procedure TForm18.SpeedButton9Click(Sender: TObject);
begin
  //0054D228: Suchgruppe 8 (Sterberichtung) leeren.
  ComboBox23.Text := '';
  ComboBox22.Text := '';
  ComboBox21.Text := '';
  Edit8.Text := '';
end;

procedure TForm18.SpeedButton10Click(Sender: TObject);
begin
  //0054D264: Suchgruppe 9 (weitere Felder) leeren.
  ComboBox24.Text := '';
  ComboBox25.Text := '';
  ComboBox26.Text := '';
  Edit9.Text := '';
end;

procedure TForm18.ComboBox1Exit(Sender: TObject);
begin
  //0054D2A0: 'lebt' erzeugt die Bedingung '=' / 'j'.
  if ComboBox1.Text = 'lebt' then
  begin
    ComboBox2.Text := '=';
    Edit1.Text := 'j';
  end;
end;

procedure TForm18.ComboBox3Exit(Sender: TObject);
begin
  //0054D33C: 'lebt' erzeugt die Bedingung '=' / 'j'.
  if ComboBox3.Text = 'lebt' then
  begin
    ComboBox4.Text := '=';
    Edit2.Text := 'j';
  end;
end;

procedure TForm18.ComboBox5Exit(Sender: TObject);
begin
  //0054D3D8: 'lebt' erzeugt die Bedingung '=' / 'j'.
  if ComboBox5.Text = 'lebt' then
  begin
    ComboBox6.Text := '=';
    Edit3.Text := 'j';
  end;
end;

procedure TForm18.ComboBox7Exit(Sender: TObject);
begin
  //0054D474: 'lebt' erzeugt die Bedingung '=' / 'j'.
  if ComboBox7.Text = 'lebt' then
  begin
    ComboBox8.Text := '=';
    Edit4.Text := 'j';
  end;
end;

procedure TForm18.ComboBox9Exit(Sender: TObject);
begin
  //0054D510: 'lebt' erzeugt die Bedingung '=' / 'j'.
  if ComboBox9.Text = 'lebt' then
  begin
    ComboBox10.Text := '=';
    Edit5.Text := 'j';
  end;
end;

procedure TForm18.ComboBox11Exit(Sender: TObject);
begin
  //0054D5AC: 'lebt' erzeugt die Bedingung '=' / 'j'.
  if ComboBox11.Text = 'lebt' then
  begin
    ComboBox12.Text := '=';
    Edit6.Text := 'j';
  end;
end;

procedure TForm18.ComboBox13Exit(Sender: TObject);
begin
  //0054D648: 'lebt' erzeugt die Bedingung '=' / 'j'.
  if ComboBox13.Text = 'lebt' then
  begin
    ComboBox14.Text := '=';
    Edit7.Text := 'j';
  end;
end;

procedure TForm18.ComboBox22Exit(Sender: TObject);
begin
  //0054D6E4: 'lebt' erzeugt die Bedingung '=' / 'j'.
  if ComboBox22.Text = 'lebt' then
  begin
    ComboBox21.Text := '=';
    Edit8.Text := 'j';
  end;
end;

procedure TForm18.ComboBox25Exit(Sender: TObject);
begin
  //0054D780: 'lebt' erzeugt die Bedingung '=' / 'j'.
  if ComboBox25.Text = 'lebt' then
  begin
    ComboBox26.Text := '=';
    Edit9.Text := 'j';
  end;
end;

procedure TForm18.FormClose(sender: tobject; var action: tcloseaction);
begin
  //0054D81C: Suchbegriff Edit23 in die globale Suche merken.
  gvar_0253693C := Edit23.Text;
end;

procedure TForm18.speichern;
var
  F: TextFile;
  line, s, fn, dat: AnsiString;
  i: Integer;
begin
  //0055F08: Tabelle16 in eine TAB-getrennte Datei zur Perfektion ausgeben.
  SaveDialog1.FilterIndex := 1;
  if not SaveDialog1.Execute then
    Exit;
  SaveDialog1.DefaultExt := 'txt';
  fn := SaveDialog1.FileName;
  if Pos('.txt', fn) = 0 then
    fn := fn + '.txt';
  AssignFile(F, fn);
  Rewrite(F);
  DataModule2.Table16.First;
  Writeln(F, 'Nr.'#9'Name'#9'geb.am'#9'in'#9'gest.am'#9'in'#9'geh.am'#9'in'#9'den/...');
  Writeln(F, ' ');
  // while not Table16.EOF
  while true do
  begin
    if DataModule2.Table16.EOF then break;
    line := '';
    if DataModule2.Table16Nummer.Value = 0 then
      line := line + Format('%5s', [''])
    else
      line := line + Format('%5s', [IntToStr(DataModule2.Table16Nummer.Value)]);
    line := line + #9 + DataModule2.Table16Name.AsString;
    line := line + #9 + DataModule2.Table16Gebtag.AsString + '.' +
      DataModule2.Table16Gebmonat.AsString + '.' + DataModule2.Table16Gebjahr.AsString;
    line := line + #9 + DataModule2.Table16Gebort.AsString;
    dat := DataModule2.Table16Sttag.AsString + '.' +
      DataModule2.Table16Stmonat.AsString + '.' + DataModule2.Table16Stjahr.AsString;
    sub_00545A0C(dat, s);
    line := line + #9 + s;
    line := line + #9 + DataModule2.Table16Stort.AsString;
    line := line + #9 + DataModule2.Table16Htag.AsString + '.' +
      DataModule2.Table16Hmonat.AsString + '.' + DataModule2.Table16Hjahr.AsString;
    line := line + #9 + DataModule2.Table16Hort.AsString;
    line := line + #9 + DataModule2.Table16Hname.AsString;
    Writeln(F, line);
    DataModule2.Table16.Next;
  end;
  CloseFile(F);
end;

procedure TForm18.BitBtn2Click(Sender: TObject);
begin
  //00545CF8: Form18.Mode := 2, Form16 schliessen, dann Form18 schliessen.
  { gvar_0061EFDC ist hier Form18; gvar_0061D6EC^ ist Form16. }
  Form18.Mode := 2;
  Form16.Close;
  Close;
end;

procedure TForm18.Button5Click(Sender: TObject);
begin
  //00545D20: alle Suchfelder leeren, Fokus auf ComboBox1 setzen.
  ComboBox1.Text := '';
  ComboBox2.Text := '';
  ComboBox3.Text := '';
  ComboBox4.Text := '';
  ComboBox5.Text := '';
  ComboBox6.Text := '';
  ComboBox7.Text := '';
  ComboBox8.Text := '';
  ComboBox9.Text := '';
  ComboBox10.Text := '';
  ComboBox11.Text := '';
  ComboBox12.Text := '';
  ComboBox13.Text := '';
  ComboBox14.Text := '';
  ComboBox15.Text := '';
  ComboBox16.Text := '';
  ComboBox17.Text := '';
  ComboBox18.Text := '';
  ComboBox19.Text := '';
  ComboBox20.Text := '';
  ComboBox21.Text := '';
  ComboBox22.Text := '';
  ComboBox23.Text := '';
  ComboBox24.Text := '';
  ComboBox25.Text := '';
  ComboBox26.Text := '';
  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';
  Edit4.Text := '';
  Edit5.Text := '';
  Edit6.Text := '';
  Edit7.Text := '';
  Edit8.Text := '';
  Edit9.Text := '';
  Edit23.Text := '';
  ActiveControl := ComboBox1;
end;

procedure TForm18.Button7Click(Sender: TObject);
begin
  //00546448: Export-Datei speichern und Hinweis ausgeben.
  speichern;
  ShowMessage('Zum Drucken diese Datei in MS-Excel einlesen.');
end;

procedure TForm18.SpeedButton1Click(Sender: TObject);
var
  s, t: AnsiString;
begin
  //0054C2BC: Suchkriterien der 9 Gruppen in gvar_0061EFE4 zusammenfassen.
  //Trennzeichen: #167 (Paragraph-Zeichen) zwischen den Gruppen, '%'
  //innerhalb der Gruppen. Die erste Gruppe fuehrt Edit23 mit.
  gvar_0061EFE4 := '';
  s := Trim(ComboBox1.Text);
  if s <> '' then
    gvar_0061EFE4 := Trim(Edit23.Text) + #$A7 + ComboBox1.Text + '%' +
      ComboBox2.Text + '%' + Edit1.Text;
  s := Trim(ComboBox3.Text);
  if s <> '' then
    gvar_0061EFE4 := gvar_0061EFE4 + #$A7 + ComboBox15.Text + '%' +
      ComboBox3.Text + '%' + ComboBox4.Text + '%' + Edit2.Text;
  s := Trim(ComboBox5.Text);
  if s <> '' then
    gvar_0061EFE4 := gvar_0061EFE4 + #$A7 + ComboBox16.Text + '%' +
      ComboBox5.Text + '%' + ComboBox6.Text + '%' + Edit3.Text;
  s := Trim(ComboBox7.Text);
  if s <> '' then
    gvar_0061EFE4 := gvar_0061EFE4 + #$A7 + ComboBox17.Text + '%' +
      ComboBox7.Text + '%' + ComboBox8.Text + '%' + Edit4.Text;
  s := Trim(ComboBox9.Text);
  if s <> '' then
    gvar_0061EFE4 := gvar_0061EFE4 + #$A7 + ComboBox18.Text + '%' +
      ComboBox9.Text + '%' + ComboBox10.Text + '%' + Edit5.Text;
  s := Trim(ComboBox11.Text);
  if s <> '' then
    gvar_0061EFE4 := gvar_0061EFE4 + #$A7 + ComboBox19.Text + '%' +
      ComboBox11.Text + '%' + ComboBox12.Text + '%' + Edit6.Text;
  s := Trim(ComboBox13.Text);
  if s <> '' then
    gvar_0061EFE4 := gvar_0061EFE4 + #$A7 + ComboBox20.Text + '%' +
      ComboBox13.Text + '%' + ComboBox14.Text + '%' + Edit7.Text;
  s := Trim(ComboBox22.Text);
  if s <> '' then
    gvar_0061EFE4 := gvar_0061EFE4 + #$A7 + ComboBox23.Text + '%' +
      ComboBox22.Text + '%' + ComboBox21.Text + '%' + Edit8.Text;
  s := Trim(ComboBox25.Text);
  if s <> '' then
    gvar_0061EFE4 := gvar_0061EFE4 + #$A7 + ComboBox24.Text + '%' +
      ComboBox25.Text + '%' + ComboBox26.Text + '%' + Edit9.Text;
  Form1.MainMenu1.Items[3].Items[5].Visible := True;
  DataModule2.Table16.Open;
  DataModule2.Table16.Close;
  DataModule2.Table16.EmptyTable;
  DataModule2.Table16.Open;
  suchen;
end;

procedure TForm18.suchen;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm18.FormShow(Sender: TObject);
begin
  //0054C998: Startknopf deaktivieren, Export-Knopf deaktivieren, Fokus auf ComboBox1.
  Button1.Enabled := False;
  Button7.Enabled := False;
  ActiveControl := ComboBox1;
end;

procedure TForm18.Button1Click(Sender: TObject);
var
  i: Integer;
begin
  //0054C9C4: Treffer der Suche nach DataModule2.Table24 uebernehmen und
  //das Ergebnisfenster Form26 oeffnen.
  gvar_0061EFE0 := 'over';
  i := DataModule2.Table16.RecordCount;
  if i > 0 then
  begin
    DataModule2.Table24.Open;
    DataModule2.Table24.Close;
    DataModule2.Table24.EmptyTable;
    DataModule2.Table24.Open;
    DataModule2.Table16.First;
    while not DataModule2.Table16.EOF do
    begin
      if DataModule2.Table16Nummer.AsInteger > 0 then
      begin
        DataModule2.Table24.Append;
        DataModule2.Table24Pp.AsInteger := i;
        DataModule2.Table24Nummer.AsInteger := DataModule2.Table16Nummer.AsInteger;
        DataModule2.Table24Lfdn.AsInteger := i;
        DataModule2.Table24.Post;
        Inc(i);
      end;
      DataModule2.Table16.Next;
    end;
    Form26.los;
  end;
end;

procedure TForm18.FormActivate(Sender: TObject);
var
  s: AnsiString;

  function BisSep(ASep: AnsiChar): AnsiString;
  var
    p: Integer;
  begin
    p := Pos(ASep, s);
    if p = 0 then
    begin
      Result := Trim(s);
    end
    else
    begin
      Result := Trim(Copy(s, 1, p - 1));
      s := Copy(s, p + 1, Length(s));
    end;
  end;

begin
  //0054CB08: Suchkriterien aus gvar_0061EFE4 auf die Felder verteilen
  //(Gruppen 1-3; Trennung wie in SpeedButton1Click).
  Edit23.Text := gvar_0253693C;
  if gvar_0061EFE4 <> '' then
  begin
    s := gvar_0061EFE4;
    Edit23.Text := BisSep(#$A7);
    ComboBox1.Text := BisSep('%');
    ComboBox2.Text := BisSep('%');
    Edit1.Text := BisSep(#$A7);
    ComboBox15.Text := BisSep('%');
    ComboBox3.Text := BisSep('%');
    ComboBox4.Text := BisSep('%');
    Edit2.Text := BisSep(#$A7);
    ComboBox16.Text := BisSep('%');
    ComboBox5.Text := BisSep('%');
    ComboBox6.Text := BisSep('%');
    Edit3.Text := BisSep(#$A7);
  end;
end;

procedure TForm18.SpeedButton2Click(Sender: TObject);
begin
  //0054D094: Gruppe 1 (Name/Vornamen) loeschen.
  ComboBox1.Text := '';
  ComboBox2.Text := '';
  Edit1.Text := '';
end;

end.

