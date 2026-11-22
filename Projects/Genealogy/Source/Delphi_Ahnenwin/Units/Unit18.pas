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
  AHNGlobals, Unit16, Unit2, Unit26, Unit1, Unit15, QuickRpt, QRCtrls,
  StrUtils;

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
{@
  00546490: Globale Suche ueber Form1.StringGrid5 / DataModule2.Table16.
  Zweistufige Exception-Konstrukte des Originals:
  aeusserer Frame gepusht @005464A7 (Handler 0054BC10: jmp @HandleFinally),
  innerer Frame @00546F32 (Handler 0054AE56: jmp @HandleFinally),
  Resume-Knoten des inneren Finally @0054AE5D -> setzt nach 0054AE42 fort.

  Original-Lokale als [ebp-xx] adressiert:
  crit       [ebp-0C]   gesammelter WHERE-SQL-Text
  pname      [ebp-14]   Edit-Text des Zeilenpaars (Partner-Name-Uebernahme)
  pcond      [ebp-1C]   Combo-Text des Zeilenpaars
  frag       [ebp-1204] Fragment-Cache (Copy aus KriteriumMap)
  teil       [ebp-12C0]/[ebp-12D0] je-Zeile-Baustein
  Textzone: esi-Flag gesetzt, wenn ein ItemIndex der Kriterien-ComboBoxen in
  30..44 liegt (Test: cmp 1D/jle, cmp 2D/jge, mov esi,1).
@}
const
  {*
    KriteriumMap @00546C27-00546F21: 45 fixe Fragment-Puffer a je 81 Byte ab
    [ebp-1090], initialisiert aus rodata 54BC24-54BE10. Auslesen je Zeile:
    lea eax,[ebp+eax*81-1090]; mov ecx,14; mov edx,3; call @Copy
    (Index*81 adressiert den Puffer, Copy ab Offset 3, Laenge 14).
    Abweichung (Restplan.md): Rohtext der Fragmente nicht rekonstruierbar
    (Chunk-Dump leer); Platzhalter '' – muessen spaeter ergaenzt werden.
  *}
  KriteriumMap: array[0..46] of AnsiString = (
    '',      //0  Name
    '',      //1  and.Namensschreibw.
    '',      //2  Vornamen
    '',      //3  Rufname
    '',      //4  Geschlecht
    '',      //5  lebt
    '',      //6  Bekenntnis
    '',      //7  Beruf
    '',      //8  Hofname
    '',      //9  ID-Nr.
    '',      //10 Geburt: Tag
    '',      //11 Geburt: Monat
    '',      //12 Geburt: Jahr
    '',      //13 Geburtsort
    '',      //14 Taufe: Tag
    '',      //15 Taufe: Monat
    '',      //16 Taufe: Jahr
    '',      //17 Taufort
    '',      //18 Taufpate
    '',      //19 Lebensort
    '',      //20 Tod: Tag
    '',      //21 Tod: Monat
    '',      //22 Tod: Jahr
    '',      //23 Sterbeort
    '',      //24 Todesursache
    '',      //25 Bestattung: Tag
    '',      //26 Bestattung: Monat
    '',      //27 Bestattung: Jahr
    '',      //28 Bestattungsort
    '',      //29 Text
    '',      //30 Verbindung  — Textzone beginnt (30..44)
    '',      //31 K.Heirat: Tag
    '',      //32 K.Heirat: Monat
    '',      //33 K.Heirat: Jahr
    '',      //34 K.Heiratsort
    '',      //35 K.Trauzeuge
    '',      //36 S.Heirat: Tag
    '',      //37 S.Heirat: Monat
    '',      //38 S.Heirat: Jahr
    '',      //39 S.Heiratsort
    '',      //40 S.Trauzeuge
    '',      //41 Scheidung: Tag
    '',      //42 Scheidung: Monat
    '',      //43 Scheidung: Jahr
    '',      //44 Scheidungsort
    '',      //45 Datensatz-Nr.
    ''       //46 Partner-Name
  );
var
  i: Integer;
  cb: TComboBox;
  textzone: Boolean;   //esi-Flag: Kriterium aus Textzone (ItemIndex 30..44)
  crit: AnsiString;    //[ebp-0C]  WHERE-Kriterium
  frag: AnsiString;    //[ebp-1204] Fragment-Cache
  teil: AnsiString;    //[ebp-12C0/12D0] Zeilen-Baustein
  pname: AnsiString;   //[ebp-14] Partner-Name-Text des Zeilenpaars
  pcond: AnsiString;   //[ebp-1C] Combo-Text des Zeilenpaars
  letzteNummer: Integer; //[ebx] nummer des zuletzt uebernommenen Datensatzes
  treffer: Integer;      //[esi] Partner-Treffer-Flag (0/1) im Fuell-Block
begin
  //@005464A7: aeusserer Exception-Frame (Handler 54BC10 -> jmp @HandleFinally)
  try
    //=== C1: ItemIndex-Fixups @0054649D-00546C27 ==================================
    //Pro Kriterien-ComboBox: wenn der Text (eventuell getippt) einem Item exakt
    //entspricht, wird der ItemIndex neu gesetzt (Original loest das je ComboBox
    //mit Count-Loop + Trim-@LStrCmp manuell nach; Ergebnis identisch):
    //ComboBox1, 3, 5, 7, 9, 11, 13, 22, 25.
    for i := 0 to 8 do
    begin
      case i of
        0: cb := ComboBox1;
        1: cb := ComboBox3;
        2: cb := ComboBox5;
        3: cb := ComboBox7;
        4: cb := ComboBox9;
        5: cb := ComboBox11;
        6: cb := ComboBox13;
        7: cb := ComboBox22;
        else
          cb := ComboBox25;
      end;
      if Trim(cb.Text) <> '' then
      begin
        for i := 0 to cb.Items.Count - 1 do
          if Trim(cb.Items[i]) = Trim(cb.Text) then
          begin
            cb.ItemIndex := i;
            Break;
          end;
      end;
    end;
    //@00546C27-00546F21: C2 – Fragment-Puffer aus rodata initialisieren.
    //In der Rekonstruktion uebernimmt das der lokale const KriteriumMap oben
    //(Inhalte = Platzhalter, s.o.).

    //@00546F32: innerer Exception-Frame (Handler 54AE56 -> jmp @HandleFinally)
    try
      //=== C3: Cursor, Knopf, SQL-Freigabe @00546F22-00546FA3 =====================
      Screen.Cursor := crHourGlass;                //@00546F22
      Button1.Enabled := True;                     //@00546F40
      Button7.Enabled := True;                     //@00546F50
      crit := '';                                  //@00546F60: [ebp-0C] freigeben
      Query1.SQL.Clear;                            //@00546F70
      Query1.SQL.Add('*');                         //@00546F84: rodata 54BE24
      Form15.QRLabel3.Caption := 'Globale Suche';  //@00546FA3 (rodata 54BE30)

      //=== ORT-Kriterium @00546FA8-00547285 =======================================
      if Trim(Edit23.Text) <> '' then              //@00546FCD (jbe -> 54A6FD4)
      begin
        Form15.QRLabel3.Caption := 'Ort = ' + Edit23.Text;   //@00546FFF/54BE48
        crit := crit + '((a.lebensort like "%' + Edit23.Text + '%"))' +
          ' or (a.gebort like "' + Edit23.Text + '%")' +
          ' or (a.taufort like "' + Edit23.Text + '%")' +
          ' or (a.stort like "' + Edit23.Text + '%")' +
          ' or (a.begort like "' + Edit23.Text + '%")' +
          ' or (a.beruf like "' + Edit23.Text + '%")' +
          ' or (b.hort like "' + Edit23.Text + '%")' +
          ' or (b.saort like "' + Edit23.Text + '%")' +
          ' or (b.schort like "' + Edit23.Text + '%"))';      //@0054701C-47204
        {Textbausteine rodata: 54BE58 '((a.lebensort like "%',
        54BE78 '%"', 54BE84 ')', 54BE90 ' or (a.gebort like ',
        54BEB8 ' or (a.taufort like ', 54BED8 ' or (a.stort like ',
        54BEF4 ' or (a.begort like ', 54BF10 ' or (a.beruf like ',
        54BF2C ' or (b.hort like ', 54BF48 ' or (b.saort like ',
        54BF64 ' or (b.schort like ', 54BF80 '))' – genau so @LStrCatN 4/6.}
      end;
      DataModule2.Table16.Open;                    //@00547242
      DataModule2.Table16.Close;                   //@00547254
      DataModule2.Table16.EmptyTable;              //@00547266
      DataModule2.Table16.Open;                    //@00547278

      //=== BLOCK B: die neun Kriterien-Zeilen @0054728A-005498EB =================
      //Pro Zeile: Skip-Fall (KriteriumComb.Text='Partner-Name' UNTRIMMED @LStrCmp;
      //KriteriumComb.Text=''; BedingungsComb.Text=''), ItemIndex-Textzone-Test
      //(29<ix<45 -> esi=1), Verknuepfungs-Rewrite IN PLACE per TControl.SetText
      //(rodata: 'and' 54C000, 'and not' 54C01C, 'not'/'or' 54C02C/54C048), dabei
      //frag := Copy(KriteriumMap[ItemIndex], 3, 14) aus Handle [ebp-1204]
      //gefuellt, dann je nach Bedingungs-ComboBox ('in' @54BFA4 vs. sonst) und
      //crit<>'' einer der vier @LStrCatN-Attachee. @LStrCatN fuegt bei jedem
      //Aufruf ans CRIT-Ende an (self-append, auch im Leerfall).
      //Ri2-Allererste: Verknuepfungs-ComboBox wird nur in den Nichtleer-Zweigen
      //mitconcat-tt; im Leerfall fehlt sie im Ergebnis (Original-Quirk).

      //--- R1: ComboBox1 (Kriterium), ComboBox2 (Bedingung), Edit1 ===============
      //@0054728A-005475F2 (Sprung zu R2: 005475F3)
      if (AnsiCompareText(ComboBox1.Text, 'Partner-Name') <> 0) and
        (ComboBox1.Text <> '') and (ComboBox2.Text <> '') then
      begin
        if (ComboBox1.ItemIndex > 29) and (ComboBox1.ItemIndex < 45) then
          textzone := True;                                       //@00547307-547322
        frag := Copy(KriteriumMap[ComboBox1.ItemIndex], 3, 14);   //@0054736A-5473A3
        if AnsiCompareText(ComboBox2.Text, 'in') = 0 then         //@00547341-54744B
        begin
          if crit <> '' then                                      //@0054734B
            //@LStrCatN 7: crit + ' and ' + frag + ' like ' + '"%' + Edit + '%"'
            //(' and ' wird in R1 hart kodiert – keine Verknuepfungs-ComboBox)
            crit := crit + ' and ' + frag + ' like ' + '"%' +
              Edit1.Text + '%"'                                     //@0054735B-5473E4
          else begin                                               //@005473E9
            //@LStrCatN 3 via PStr-Klammer [ebp-1264]/[ebp-12C0]
            //(PStrNCat-Caps cl=56h/58h = Puffer-MaxLaengen, nie schlaechtend)
            teil := frag + ' like ' + '"%';
            crit := crit + teil + Edit1.Text + '%"'
          end;                                                     //@005474A6
        end else begin                                             //@005474AB-5474AF
          if crit <> '' then
            //@LStrCatN 8: crit + ' ' + frag + ' ' + CB2 + '"' + Edit + '"'
            crit := crit + ' ' + frag + ' ' + ComboBox2.Text + '"' +
              Edit1.Text + '"'                                      //@005474B5-547558
          else
            //@LStrCatN 5: frag + CB2 + '"' + Edit + '"' (ohne Leerraum vorm Kond.)
            crit := frag + ComboBox2.Text + '"' + Edit1.Text + '"'
          ;
        end;                                                       //@005475F3
      end;

      //--- R2: ComboBox3, ComboBox4, ComboBox15 (Verknuepfer), Edit2 ===========
      //@005475F3-00547A7C (Sprung zu R3: 00547A7D)
      if (AnsiCompareText(ComboBox3.Text, 'Partner-Name') <> 0) and
        (ComboBox3.Text <> '') and (ComboBox4.Text <> '') then
      begin
        if (ComboBox3.ItemIndex > 29) and (ComboBox3.ItemIndex < 45) then
          textzone := True;                                       //@00547670-547689
        if ComboBox15.Text = '' then
          ComboBox15.Text := 'and'                                 //@005476A9-5476AB
        else if AnsiCompareText(ComboBox15.Text, 'und') = 0 then
          ComboBox15.Text := 'and';                                //@005476AD-5476D1
        if AnsiCompareText(ComboBox15.Text, 'nicht') = 0 then      //@005476F1-54770A
        begin
          //R2-Eigenart: Leercheck vor dem Umschreiben:
          if crit <> '' then
            ComboBox15.Text := 'and not'                           //@00547712 (54C01C)
          else
            ComboBox15.Text := 'not';                              //@00547727 (54C02C)
        end;
        if AnsiCompareText(ComboBox15.Text, 'oder') = 0 then
          ComboBox15.Text := 'or';                                 //@00547760 (54C048)
        frag := Copy(KriteriumMap[ComboBox3.ItemIndex], 3, 14);
        if AnsiCompareText(ComboBox4.Text, 'in') = 0 then          //@0054778D-547797
        begin
          if crit <> '' then                                      //@005477A1
            //@LStrCatN 9: crit + ' ' + CB15 + ' ' + frag + ' like ' + '"%' + Edit + '%"'
            crit := crit + ' ' + ComboBox15.Text + ' ' + frag + ' like ' +
              '"%' + Edit2.Text + '%"'                             //@005477A7-54784F
          else begin                                               //@005477C1-547854
            teil := frag + ' like ' + '"%';
            crit := crit + teil + Edit2.Text + '%"'
          end;                                                     //@00547911
        end else begin                                             //@0054791A-547916
          if crit <> '' then
            //@LStrCatN 10: crit + ' ' + CB15 + ' ' + frag + ' ' + CB4 + '"' + Edit + '"'
            crit := crit + ' ' + ComboBox15.Text + ' ' + frag + ' ' +
              ComboBox4.Text + '"' + Edit2.Text + '"'              //@00547920-5479E2
          else
            //@LStrCatN 5: frag + CB4 + '"' + Edit + '"' (CB15 fallen gelassen)
            crit := frag + ComboBox4.Text + '"' + Edit2.Text + '"'
          ;
        end;                                                       //@00547A7D
      end;

      //--- R3: ComboBox5, ComboBox6, ComboBox16, Edit3 =========================
      //@00547A7D-00547EEC (Sprung zu R4: 00547EEC)
      if (AnsiCompareText(ComboBox5.Text, 'Partner-Name') <> 0) and
        (ComboBox5.Text <> '') and (ComboBox6.Text <> '') then
      begin
        if (ComboBox5.ItemIndex > 29) and (ComboBox5.ItemIndex < 45) then
          textzone := True;                                       //@00547AFD-547B1A
        if ComboBox16.Text = '' then
          ComboBox16.Text := 'and'                                 //@00547B2E-547B35
        else if AnsiCompareText(ComboBox16.Text, 'und') = 0 then
          ComboBox16.Text := 'and';                                //@00547B37-547B5B
        if AnsiCompareText(ComboBox16.Text, 'nicht') = 0 then
          ComboBox16.Text := 'and not';                            //@00547B94-547BA9
        if AnsiCompareText(ComboBox16.Text, 'oder') = 0 then
          ComboBox16.Text := 'or';                                 //@00547BCD-547BE2
        frag := Copy(KriteriumMap[ComboBox5.ItemIndex], 3, 14);
        if AnsiCompareText(ComboBox6.Text, 'in') = 0 then          //@00547BFD-547C06
        begin
          if crit <> '' then
            //@LStrCatN 9
            crit := crit + ' ' + ComboBox16.Text + ' ' + frag +
              ' like ' + '"%' + Edit3.Text + '%"'                  //@00547C0C-547CBE
          else begin
            teil := frag + ' like ' + '"%';
            crit := crit + teil + Edit3.Text + '%"'
          end;                                                     //@00547D80
        end else begin                                             //@00547D85-547D89
          if crit <> '' then
            //@LStrCatN 10
            crit := crit + ' ' + ComboBox16.Text + ' ' + frag + ' ' +
              ComboBox6.Text + '"' + Edit3.Text + '"'
          else
            //@LStrCatN 5
            crit := frag + ComboBox6.Text + '"' + Edit3.Text + '"'
        end;                                                       //@00547EEC
      end;

      //--- R4: ComboBox7, ComboBox8, ComboBox17, Edit4 =========================
      //@00547EEC-0054835B (Sprung zu R5: 0054835B)
      if (AnsiCompareText(ComboBox7.Text, 'Partner-Name') <> 0) and
        (ComboBox7.Text <> '') and (ComboBox8.Text <> '') then
      begin
        if (ComboBox7.ItemIndex > 29) and (ComboBox7.ItemIndex < 45) then
          textzone := True;                                       //@00547F69-547F84
        if ComboBox17.Text = '' then
          ComboBox17.Text := 'and'                                 //@00547FA4-547FAC
        else if AnsiCompareText(ComboBox17.Text, 'und') = 0 then
          ComboBox17.Text := 'and';                                //@00547FA6-547FCA
        if AnsiCompareText(ComboBox17.Text, 'nicht') = 0 then
          ComboBox17.Text := 'and not';                            //@00548003-547FDA
        if AnsiCompareText(ComboBox17.Text, 'oder') = 0 then
          ComboBox17.Text := 'or';                                 //@0054803C-547FE1
        frag := Copy(KriteriumMap[ComboBox7.ItemIndex], 3, 14);
        if AnsiCompareText(ComboBox8.Text, 'in') = 0 then          //@00548070-547F75
        begin
          if crit <> '' then
            crit := crit + ' ' + ComboBox17.Text + ' ' + frag +
              ' like ' + '"%' + Edit4.Text + '%"'                  //@LStrCatN 9 @0054807F
          else begin
            teil := frag + ' like ' + '"%';
            crit := crit + teil + Edit4.Text + '%"'
          end;
        end else begin
          if crit <> '' then
            crit := crit + ' ' + ComboBox17.Text + ' ' + frag + ' ' +
              ComboBox8.Text + '"' + Edit4.Text + '"'
          else
            crit := frag + ComboBox8.Text + '"' + Edit4.Text + '"'
        end;                                                       //@0054835B
      end;

      //--- R5: ComboBox9, ComboBox10, ComboBox18, Edit5 ========================
      //@0054835B-005487CA (Sprung zu R6: 005487CA)
      if (AnsiCompareText(ComboBox9.Text, 'Partner-Name') <> 0) and
        (ComboBox9.Text <> '') and (ComboBox10.Text <> '') then
      begin
        if (ComboBox9.ItemIndex > 29) and (ComboBox9.ItemIndex < 45) then
          textzone := True;                                       //@005483D8-547F3
        if ComboBox18.Text = '' then
          ComboBox18.Text := 'and'                                 //@0054840C-547F13
        else if AnsiCompareText(ComboBox18.Text, 'und') = 0 then
          ComboBox18.Text := 'and';                                //@00548415-547F39
        if AnsiCompareText(ComboBox18.Text, 'nicht') = 0 then
          ComboBox18.Text := 'and not';                            //@00548472-547F87
        if AnsiCompareText(ComboBox18.Text, 'oder') = 0 then
          ComboBox18.Text := 'or';                                 //@005484AB-547FC0
        frag := Copy(KriteriumMap[ComboBox9.ItemIndex], 3, 14);
        if AnsiCompareText(ComboBox10.Text, 'in') = 0 then         //@005484DA-547E44
        begin
          if crit <> '' then
            crit := crit + ' ' + ComboBox18.Text + ' ' + frag +
              ' like ' + '"%' + Edit5.Text + '%"'                  //@LStrCatN 9 @005484EE
          else begin
            teil := frag + ' like ' + '"%';
            crit := crit + teil + Edit5.Text + '%"'
          end;
        end else begin
          if crit <> '' then
            crit := crit + ' ' + ComboBox18.Text + ' ' + frag + ' ' +
              ComboBox10.Text + '"' + Edit5.Text + '"'
          else
            crit := frag + ComboBox10.Text + '"' + Edit5.Text + '"'
        end;                                                       //@005487CA
      end;

      //--- R6: ComboBox11, ComboBox12, ComboBox19, Edit6 =======================
      //@005487CA-00548C39 (Sprung zu R7: 00548C39)
      if (AnsiCompareText(ComboBox11.Text, 'Partner-Name') <> 0) and
        (ComboBox11.Text <> '') and (ComboBox12.Text <> '') then
      begin
        if (ComboBox11.ItemIndex > 29) and (ComboBox11.ItemIndex < 45) then
          textzone := True;                                       //@00548847-547F62
        if ComboBox19.Text = '' then
          ComboBox19.Text := 'and'                                 //@00548882-547FAA
        else if AnsiCompareText(ComboBox19.Text, 'und') = 0 then
          ComboBox19.Text := 'and';                                //@00548884-547FA8
        if AnsiCompareText(ComboBox19.Text, 'nicht') = 0 then
          ComboBox19.Text := 'and not';                            //@005488E1-547FF6
        if AnsiCompareText(ComboBox19.Text, 'oder') = 0 then
          ComboBox19.Text := 'or';                                 //@0054891A-547FCF
        frag := Copy(KriteriumMap[ComboBox11.ItemIndex], 3, 14);
        if AnsiCompareText(ComboBox12.Text, 'in') = 0 then         //@0054894E-547F53
        begin
          if crit <> '' then
            crit := crit + ' ' + ComboBox19.Text + ' ' + frag +
              ' like ' + '"%' + Edit6.Text + '%"'                  //@LStrCatN 9 @0054895D
          else begin
            teil := frag + ' like ' + '"%';
            crit := crit + teil + Edit6.Text + '%"'
          end;
        end else begin
          if crit <> '' then
            crit := crit + ' ' + ComboBox19.Text + ' ' + frag + ' ' +
              ComboBox12.Text + '"' + Edit6.Text + '"'
          else
            crit := frag + ComboBox12.Text + '"' + Edit6.Text + '"'
        end;                                                       //@00548C39
      end;

      //--- R7: ComboBox13, ComboBox14, ComboBox20, Edit7 =======================
      //@00548C39 (Sprung zu R8: 005490A8)
      if (AnsiCompareText(ComboBox13.Text, 'Partner-Name') <> 0) and
        (ComboBox13.Text <> '') and (ComboBox14.Text <> '') then
      begin
        if (ComboBox13.ItemIndex > 29) and (ComboBox13.ItemIndex < 45) then
          textzone := True;                                       //@00548CB6-547FD1
        if ComboBox20.Text = '' then
          ComboBox20.Text := 'and'                                 //@00548CF1-547FD9
        else if AnsiCompareText(ComboBox20.Text, 'und') = 0 then
          ComboBox20.Text := 'and';                                //@00548CF3-547FD7
        if AnsiCompareText(ComboBox20.Text, 'nicht') = 0 then
          ComboBox20.Text := 'and not';                            //@00548D50-547FD5
        if AnsiCompareText(ComboBox20.Text, 'oder') = 0 then
          ComboBox20.Text := 'or';                                 //@00548D89-547F9E
        frag := Copy(KriteriumMap[ComboBox13.ItemIndex], 3, 14);
        if AnsiCompareText(ComboBox14.Text, 'in') = 0 then         //@00548DB8-547FC2
        begin
          if crit <> '' then
            crit := crit + ' ' + ComboBox20.Text + ' ' + frag +
              ' like ' + '"%' + Edit7.Text + '%"'                  //@LStrCatN 9 @00548DCC
          else begin
            teil := frag + ' like ' + '"%';
            crit := crit + teil + Edit7.Text + '%"'
          end;
        end else begin
          if crit <> '' then
            crit := crit + ' ' + ComboBox20.Text + ' ' + frag + ' ' +
              ComboBox14.Text + '"' + Edit7.Text + '"'
          else
            crit := frag + ComboBox14.Text + '"' + Edit7.Text + '"'
        end;                                                       //@005490A8
      end;

      //--- R8: ComboBox22, ComboBox21, ComboBox23, Edit8 =======================
      //@005490A8 (Sprung zu R9: 00549517)
      if (AnsiCompareText(ComboBox22.Text, 'Partner-Name') <> 0) and
        (ComboBox22.Text <> '') and (ComboBox21.Text <> '') then
      begin
        if (ComboBox22.ItemIndex > 29) and (ComboBox22.ItemIndex < 45) then
          textzone := True;                                       //@00549125-547FD1
        if ComboBox23.Text = '' then
          ComboBox23.Text := 'and'                                 //@00549160-547F88
        else if AnsiCompareText(ComboBox23.Text, 'und') = 0 then
          ComboBox23.Text := 'and';                                //@00549162-547F86
        if AnsiCompareText(ComboBox23.Text, 'nicht') = 0 then
          ComboBox23.Text := 'and not';                            //@005491BF-547FD4
        if AnsiCompareText(ComboBox23.Text, 'oder') = 0 then
          ComboBox23.Text := 'or';                                 //@005491F8-547F7C
        frag := Copy(KriteriumMap[ComboBox22.ItemIndex], 3, 14);
        if AnsiCompareText(ComboBox21.Text, 'in') = 0 then         //@00549227-547F31
        begin
          if crit <> '' then
            //@LStrCatN 9 @0054923B
            crit := crit + ' ' + ComboBox23.Text + ' ' + frag +
              ' like ' + '"%' + Edit8.Text + '%"'
          else begin
            {B-Tail ueber PStr-Puffer [ebp-1264]/[ebp-12C0]}
            teil := frag + ' like ' + '"%';
            crit := crit + teil + Edit8.Text + '%"'
          end;
        end else begin
          if crit <> '' then
            //@LStrCatN 10 @005493B4
            crit := crit + ' ' + ComboBox23.Text + ' ' + frag + ' ' +
              ComboBox21.Text + '"' + Edit8.Text + '"'             //@005493BA-54794C
          else
            //@LStrCatN 5 @005493F4
            crit := frag + ComboBox21.Text + '"' + Edit8.Text + '"'
        end;                                                       //@00549517
      end;

      //--- R9: ComboBox25, ComboBox26, ComboBox24, Edit9 =======================
      //@00549517 (Sprung zum Join-Split: 00549986)
      if (AnsiCompareText(ComboBox25.Text, 'Partner-Name') <> 0) and
        (ComboBox25.Text <> '') and (ComboBox26.Text <> '') then
      begin
        if (ComboBox25.ItemIndex > 29) and (ComboBox25.ItemIndex < 45) then
          textzone := True;                                       //@00549594-547FB4
        if ComboBox24.Text = '' then
          ComboBox24.Text := 'and'                                 //@005495CF-547FF7
        else if AnsiCompareText(ComboBox24.Text, 'und') = 0 then
          ComboBox24.Text := 'and';                                //@005495D1-547FF5
        if AnsiCompareText(ComboBox24.Text, 'nicht') = 0 then
          ComboBox24.Text := 'and not';                            //@0054962E-547F43
        if AnsiCompareText(ComboBox24.Text, 'oder') = 0 then
          ComboBox24.Text := 'or';                                 //@00549667-547F7C
        frag := Copy(KriteriumMap[ComboBox25.ItemIndex], 3, 14);
        if AnsiCompareText(ComboBox26.Text, 'in') = 0 then         //@00549696-547FA0
        begin
          if crit <> '' then
            //@LStrCatN 9 @005496AA
            crit := crit + ' ' + ComboBox24.Text + ' ' + frag +
              ' like ' + '"%' + Edit9.Text + '%"'
          else begin
            teil := frag + ' like ' + '"%';
            crit := crit + teil + Edit9.Text + '%"'
          end;
        end else begin
          if crit <> '' then
            //@LStrCatN 10 @00549823
            crit := crit + ' ' + ComboBox24.Text + ' ' + frag + ' ' +
              ComboBox26.Text + '"' + Edit9.Text + '"'
          else
            //@LStrCatN 5 @005498F0: frag + CB26 + '"' + Edit + '"' (CB24 fallengelassen)
            crit := frag + ComboBox26.Text + '"' + Edit9.Text + '"'
        end;                                                       //@00549986
      end;

      //=== JOIN-SPLIT @00549986-00549A52 =======================================
      //ebx := Query1; Zweig nach esi/textzone-Flag. Achtung @LStrCat3-Konvention
      //in diesem RTL-Build: Ergebnis = edx-Wert & ecx-Wert (vgl. ORT)
      //@00546FFF -> 'Ort = '+Edit23: edx=Const, ecx=Var-Zeichenkette).
      if textzone then                                        //@0054998F/547991
      begin                                                   //Textzonen-Pfad:
        Query1.SQL.Add('select a.nummer as nummer, ' +
          'a.geschlecht as geschlecht, b.epnum as PNr, a.name'@54C054);
        //  54C054-Rohtext ist im Dump an dieser Stelle verkuerzt
        //  (Setzt nach 'a.name' [sic] fort – Rest s. Restplan.md).
        Query1.SQL.Add('from awd a, mrg b'@54C0E0);           //@005499A9-5479B2
        //WoKriterium wird immer anhaengt, auch wenn crit leer ist:
        Query1.SQL.Add('where b.nummer=a.nummer and ' + crit);   //@005499B3/54C0FC
      end
      else                                                     //Standard-Pfad:
      begin                                                   //@005499E9-549A1D
        Query1.SQL.Add('select a.nummer as nummer, ' +
          'a.geschlecht as geschlecht, b.epnum as PNr, a.name'@54C054);
        Query1.SQL.Add('from awd a left outer join mrg b'@54C174); //@005499FF-549A0E
        Query1.SQL.Add('on a.nummer=b.nummer'@54C1A0);         //@00549A10-549A18
        if crit <> '' then                                    //@00549A19-549A1D
          Query1.SQL.Add('where ' + crit);                    //@00549A25/54C1C0
      end;
      Query1.SQL.Add('order by a.name, a.vornamen, a.gebjahr, ' +
        'a.taufjahr, b.hjahr, b.sajahr'@54C124);             //@00549A43-549A51

      //=== CHUNK C: Tabellen oeffnen / Partner-Name-Scan / Zeitfilter ==========
      //@00549A53-00549AD6: Tabellen und Query oeffnen, Indizes zuruecksetzen.
      DataModule2.Table10.Open;                    //@00549A53-549A60 (T10, +0A4)
      DataModule2.Table10.IndexName := '';         //@00549A65-549A74 (xor edx)
      Query1.Open;                                 //@00549A79-549A82 (Query1, +3D8)
      DataModule2.Table9.Open;                     //@00549A87-549A94 (T9, +9C)
      DataModule2.Table9.IndexName := '';          //@00549A99-549AA8 (xor edx)
      DataModule2.Table15.Open;                    //@00549AAD-549ABA (T15, +E8)
      DataModule2.Table15.IndexName := 'num';      //@00549ABF-549AD1 (rodata 54C1D0)
      letzteNummer := 0;                           //@00549AD6 (xor ebx,ebx)
      pname := '';                                 //@00549AD8-549ADB (@LStrClr)
      pcond := '';                                 //@00549AE0-549AE3 (@LStrClr)

      //@00549AE8-00549E04: Partner-Name-Scan ueber alle neun Zeilenpaare.
      //Je Paar: Trim(Kriterien-Combo)='Partner-Name' (@LStrCmp ->
      //AnsiCompareText) -> pname := Edit.Text, pcond := Konditions-Combo.Text.
      //Ueberschreibt ohne else – bei mehreren Treffern gewinnt die letzte Zeile.
      if AnsiCompareText(Trim(ComboBox1.Text), 'Partner-Name') = 0 then //@00549AE8-549B1D
      begin
        pname := Edit1.Text;                       //@00549B1F-549B2B (+340)
        pcond := ComboBox2.Text;                   //@00549B30-549B3C (+33C)
      end;
      if AnsiCompareText(Trim(ComboBox3.Text), 'Partner-Name') = 0 then //@00549B41-549B76
      begin
        pname := Edit2.Text;                       //@00549B78-549B84 (+34C)
        pcond := ComboBox4.Text;                   //@00549B89-549B95 (+348)
      end;
      if AnsiCompareText(Trim(ComboBox5.Text), 'Partner-Name') = 0 then //@00549B9A-549BCF
      begin
        pname := Edit3.Text;                       //@00549BD1-549BDD (+358)
        pcond := ComboBox6.Text;                   //@00549BE2-549BEE (+354)
      end;
      if AnsiCompareText(Trim(ComboBox7.Text), 'Partner-Name') = 0 then //@00549BF3-549C28
      begin
        pname := Edit4.Text;                       //@00549C2A-549C36 (+364)
        pcond := ComboBox8.Text;                   //@00549C3B-549C47 (+360)
      end;
      if AnsiCompareText(Trim(ComboBox9.Text), 'Partner-Name') = 0 then //@00549C4C-549C81
      begin
        pname := Edit5.Text;                       //@00549C83-549C8F (+370)
        pcond := ComboBox10.Text;                  //@00549C94-549CA0 (+36C)
      end;
      if AnsiCompareText(Trim(ComboBox11.Text), 'Partner-Name') = 0 then //@00549CA5-549CDA
      begin
        pname := Edit6.Text;                       //@00549CDC-549CE8 (+37C)
        pcond := ComboBox12.Text;                  //@00549CED-549CF9 (+378)
      end;
      if AnsiCompareText(Trim(ComboBox13.Text), 'Partner-Name') = 0 then //@00549CFE-549D33
      begin
        pname := Edit7.Text;                       //@00549D35-549D41 (+388)
        pcond := ComboBox14.Text;                  //@00549D46-549D52 (+384)
      end;
      if AnsiCompareText(Trim(ComboBox22.Text), 'Partner-Name') = 0 then //@00549D57-549D8C
      begin
        pname := Edit8.Text;                       //@00549D8E-549D9A (+3A4)
        pcond := ComboBox21.Text;                  //@00549D9F-549DAB (+3A8)
      end;
      if AnsiCompareText(Trim(ComboBox25.Text), 'Partner-Name') = 0 then //@00549DB0-549DE5
      begin
        pname := Edit9.Text;                       //@00549DE7-549DF3 (+3C0)
        pcond := ComboBox26.Text;                  //@00549DF8-549E04 (+3BC)
      end;

      //@00549E09-549E29: Quirk – Query1.First nur, wenn eine Partner-Kondition
      //uebernommen wurde (Trim(pcond)<>'' ; jbe -> 549E2E), sonst bleibt der
      //Zeiger auf dem zuletzt geoeffneten Stand.
      if Trim(pcond) <> '' then                    //@00549E09-549E1E
        Query1.First;                              //@00549E20-549E29

      //@00549E2E-549ECF: optionaler Zeitfilter auf der Personentabelle (T9).
      if gvar_02536BA0 > 1 then                    //@00549E2E-549E36 (jle -> 54AE24)
      begin
        DataModule2.Table9.Filter := 'gebjahr<=' + IntToStr(gvar_02536BA0) +
          ' and taufjahr<=' + IntToStr(gvar_02536BA0);  //@00549E3C-549E81 (@LStrCatN 4)
        DataModule2.Table9.Filtered := True;        //@00549E86-549EB2 (vtbl+198/+190)
        Form1.DBText1.Color := $FFFF;               //@00549EB8-549ECA (clYellow)
      end;
      //@00549ECF: jmp 54AE24 -> Schleifenkopf der Fuell-Schleife (Chunk D1).

      //=== CHUNK D1: Fuell-Schleife – Kopf, FindKey, Partner-Filter ============
      //@0054AE24-54AE34: Schleifenkopf (edi := Query1, FEOF-Test).
      //@00549ED4: Einstieg in den Koerper; 0054AE04 ist das Continue-Ziel
      //(Query1.Next am Ende des Koerpers).
      while not Query1.EOF do                                  //@0054AE24-54AE34
      begin
        treffer := 0;                                          //@00549ED4 (xor esi,esi)
        //@00549ED6-549F09: Personentabelle auf den Query-Datensatz stellen
        //(Rueckgabewert wird verworfen – Quirk).
        DataModule2.Table9.FindKey([Query1.FieldByName('nummer').AsInteger]);

        //@00549F0E-54A068: Partner-Filter. Nur wenn pname gesetzt, wird der
        //Ehepartner ueber T15.Nummer -> T15.Epnum -> T9 gesucht; pcond '='
        //vergleicht uppercaset, pcond 'in' testet mit Pos (case-sensitiv).
        if Trim(pname) <> '' then                              //@00549F0E-549F23 (jbe)
        begin
          if DataModule2.Table15.FindKey(                      //@00549F29-549F6A (je)
            [Query1.FieldByName('nummer').AsInteger]) then
            if DataModule2.Table9.FindKey(                     //@00549F70-549FB5 (je)
              [DataModule2.Table15Epnum.AsInteger]) then
            begin
              if AnsiCompareText(pcond, '=') = 0 then          //@00549FBB-549FC8 (@LStrCmp)
                if UpperCase(DataModule2.Table9Name.AsString) =
                  UpperCase(pname) then                        //@00549FCA-54A01E (@LStrCmp)
                  treffer := 1;                                //@0054A020
              if AnsiCompareText(pcond, 'in') = 0 then         //@0054A025-54A032 (@LStrCmp)
                if Pos(pname, DataModule2.Table9Name.AsString) > 0 then //@0054A034-54A066 (@LStrPos)
                  treffer := 1;                                //@0054A068
            end;
        end;

        //@0054A06D-54A0A7: T9 erneut auf die Person zuruecksetzen (Rueckgabe
        //wird wieder verworfen – Quirk); ab hier folgt die Anhaeng-Entscheidung.
        DataModule2.Table9.FindKey([Query1.FieldByName('nummer').AsInteger]);


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

