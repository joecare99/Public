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
    KriteriumMap @00546C27-00546F21: C2 ist KEINE Schleife, sondern eine
    ungerollte Folge von 46 festen Kopien (movs dword/word/byte) aus den
    rodata-ShortStrings 54BC24..54BE19 nach [ebp-1090 + i*81] (i=0..45,
    Schrittweite 81 = string[80]; Endpuffer i=45 liegt auf [ebp-253]).
    Auslesen je Zeile:
    lea eax,[ebp+eax*81-1090]; mov ecx,14; mov edx,3; call @Copy
    (Index*81 adressiert den Puffer, Copy ab Offset 3, Laenge 14).
    Index 46 ('Partner-Name') besitzt im Original KEINEN Puffer: der Slot
    [ebp-202] liegt im Prolog-Nullbereich und ist dort leer, daher ''.
    Inhalte aus dem Original-Binary (AHNWIN51.exe vom 12.08.2014) gelesen.
  *}
  KriteriumMap: array[0..46] of AnsiString = (
    'a.name',       //0  Name
    'a.namex',      //1  and.Namensschreibw.
    'a.vornamen',   //2  Vornamen
    'a.rufname',    //3  Rufname
    'a.geschlecht', //4  Geschlecht
    'a.lebt',       //5  lebt
    'a.religion',   //6  Bekenntnis
    'a.beruf',      //7  Beruf
    'a.hausname',   //8  Hofname
    'a.IDNR',       //9  ID-Nr.
    'a.gebtag',     //10 Geburt: Tag
    'a.gebmonat',   //11 Geburt: Monat
    'a.gebjahr',    //12 Geburt: Jahr
    'a.gebort',     //13 Geburtsort
    'a.tauftag',    //14 Taufe: Tag
    'a.taufmonat',  //15 Taufe: Monat
    'a.taufjahr',   //16 Taufe: Jahr
    'a.taufort',    //17 Taufort
    'a.taufpat',    //18 Taufpate
    'a.lebensort',  //19 Lebensort
    'a.sttag',      //20 Tod: Tag
    'a.stmonat',    //21 Tod: Monat
    'a.stjahr',     //22 Tod: Jahr
    'a.stort',      //23 Sterbeort
    'a.todesurs',   //24 Todesursache
    'a.begtag',     //25 Bestattung: Tag
    'a.begmonat',   //26 Bestattung: Monat
    'a.begjahr',    //27 Bestattung: Jahr
    'a.begort',     //28 Bestattungsort
    'a.kommentar',  //29 Text
    'b.verbind',    //30 Verbindung  - Textzone beginnt (30..44)
    'b.htag',       //31 K.Heirat: Tag
    'b.hmonat',     //32 K.Heirat: Monat
    'b.hjahr',      //33 K.Heirat: Jahr
    'b.hort',       //34 K.Heiratsort
    'b.trauz',      //35 K.Trauzeuge
    'b.satag',      //36 S.Heirat: Tag
    'b.samonat',    //37 S.Heirat: Monat
    'b.sajahr',     //38 S.Heirat: Jahr
    'b.saort',      //39 S.Heiratsort
    'b.satrauz',    //40 S.Trauzeuge
    'b.schtag',     //41 Scheidung: Tag
    'b.schmonat',   //42 Scheidung: Monat
    'b.schjahr',    //43 Scheidung: Jahr
    'b.schort',     //44 Scheidungsort
    'a.nummer',     //45 Datensatz-Nr.
    ''              //46 Partner-Name (im Original ohne Puffer)
  );
var
  i: Integer;
  j: Integer;        //Zaehler der inneren Count-Loop in C1 (getrennt von i,
                     //im Original eigener Register-/Stackplatz)
  cb: TComboBox;
  textzone: Boolean;   //esi-Flag: Kriterium aus Textzone (ItemIndex 30..44)
  crit: AnsiString;    //[ebp-0C]  WHERE-Kriterium
  frag: AnsiString;    //[ebp-1204] Fragment-Cache
  teil: AnsiString;    //[ebp-12C0/12D0] Zeilen-Baustein
  pname: AnsiString;   //[ebp-14] Partner-Name-Text des Zeilenpaars
  k: string[3];        //[ebp-18] Ehe-Kennung 'o-o'/'oo' (+'K'/'S') in D3
                       //(Original: 4-Byte ShortString; @PStrNCat mit cl=3 begrenzt,
                       //'o-o'+'K' bleibt 'o-o', 'oo'+'K' ergibt 'ooK' - Quirk)
  pcond: AnsiString;   //[ebp-1C] Combo-Text des Zeilenpaars
  letzteNummer: Integer; //[ebx] nummer des zuletzt uebernommenen Datensatzes
  treffer: Integer;      //[esi] Partner-Treffer-Flag (0/1) im Fuell-Block
  spalte: Integer;       //[esi] Spalten-Basis der Ergebniszeile (Chunk E, bleibt 0)
  zeile: Integer;        //[ebx] Ergebnis-Zeilenindex (Chunk E, ab 2)
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
        for j := 0 to cb.Items.Count - 1 do
          if Trim(cb.Items[j]) = Trim(cb.Text) then
          begin
            cb.ItemIndex := j;
            Break;
          end;
      end;
    end;
    //@00546C27-00546F21: C2 – Fragment-Puffer aus rodata initialisieren.
    //In der Rekonstruktion uebernimmt das der lokale const KriteriumMap oben
    //(Inhalt aus dem Original-Binary gelesen, s.o.).

    //=== C3: Cursor, Knopf, SQL-Freigabe @00546F22-00546FA3 =====================
    Screen.Cursor := crHourGlass;                  //@00546F22
    //@00546F32: innerer Exception-Frame (Handler 54AE56 -> jmp @HandleFinally)
    //Quirk: im Original liegt der SetCursor @00546F22 VOR dem Frame-Hook
    //@00546F32 - der try beginnt daher erst nach der Cursor-Zuweisung.
    try
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
        Query1.SQL.Add('select a.nummer as nummer, a.geschlecht as ' +
          'geschlecht, b.epnum as PNr, a.name, a.vornamen, a.gebjahr, ' +
          'a.taufjahr, b.hjahr, b.sajahr');                   //@00549999 (54C054, len 131)
        Query1.SQL.Add('from awd a, mrg b');                  //@005499A9-5499B2 (54C0E0)
        //WoKriterium wird immer anhaengt, auch wenn crit leer ist:
        Query1.SQL.Add('where b.nummer=a.nummer and ' + crit); //@005499B3/54C0FC
      end
      else                                                     //Standard-Pfad:
      begin                                                   //@005499E9-549A1D
        Query1.SQL.Add('select a.nummer as nummer, a.geschlecht as ' +
          'geschlecht, b.epnum as PNr, a.name, a.vornamen, a.gebjahr, ' +
          'a.taufjahr, b.hjahr, b.sajahr');                   //@005499EF (54C054)
        Query1.SQL.Add('from awd a left outer join mrg b');   //@005499FF-549A0E (54C174)
        Query1.SQL.Add('on a.nummer=b.nummer');               //@00549A10-549A18 (54C1A0)
        if crit <> '' then                                    //@00549A19-549A1D
          Query1.SQL.Add('where ' + crit);                    //@00549A25/54C1C0
      end;
      Query1.SQL.Add('order by a.name, a.vornamen, a.gebjahr, ' +
        'a.taufjahr, b.hjahr, b.sajahr');                     //@00549A43-549A51 (54C124)

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
        //wird wieder verworfen - Quirk); ab hier folgt die Anhaeng-Entscheidung.
        DataModule2.Table9.FindKey([Query1.FieldByName('nummer').AsInteger]);

        //@0054A0AC-54A0E4: Anhaengen nur, wenn kein Partner-Name gesetzt wurde
        //oder der Partner-Test treffer=1 gesetzt hat. Quirk: Trim(pname) wird
        //doppelt ausgewertet (der zweite Test @0054A0C3 ist unerreichbar, wenn
        //der erste durchlaeuft); das Original prueft hier mit dec esi/jne und
        //veraendert treffer dabei (irrelevant, es wird neu initialisiert).
        if (Trim(pname) = '') or ((Trim(pname) <> '') and (treffer = 1)) then
        begin
          DataModule2.Table16.Append;                         //@0054A0E5-54A0F2
          //@0054A0F7-54A111: Quirk - der Dedup-Test steht erst NACH dem Append,
          //eine doppelte nummer erzeugt damit eine leere Ergebniszeile.
          if Query1.FieldByName('nummer').AsInteger <> letzteNummer then
          begin
            DataModule2.Table16Nummer.AsInteger :=
              DataModule2.Table9Nummer.AsInteger;             //@0054A117-54A13A
            DataModule2.Table16Geschlecht.AsString :=
              DataModule2.Table9Geschlecht.AsString;          //@0054A140-54A16D
            DataModule2.Table16Name.AsString :=
              DataModule2.Table9Name.AsString + ' ' +
              DataModule2.Table9Vornamen.AsString;            //@0054A173-54A1D9 (@LStrCatN 3)
            letzteNummer := Query1.FieldByName('nummer').AsInteger; //@0054A1DF-54A1F7 (ebx)

            //@0054A1F9-54A725: Datumsfelder mit Marker-Zeichen nach Table16
            //uebernehmen. Geburt ('*'), sonst Taufe ('~') in die Geb-Felder;
            //Tod ('+'), sonst Beerdigung ('#') in die St-Felder. jeweils nur,
            //wenn Jahr oder Ort des jeweiligen Abschnitts gefuellt ist.
            if (Trim(DataModule2.Table9Gebjahr.AsString) <> '') or
              (Trim(DataModule2.Table9Gebort.AsString) <> '') then
            begin
              DataModule2.Table16Gebtag.AsString :=
                '*' + DataModule2.Table9Gebtag.AsString;      //@0054A261-54A2A4 (@LStrCat3)
              DataModule2.Table16Gebmonat.AsString :=
                DataModule2.Table9Gebmonat.AsString;          //@0054A2AA-54A2D7
              DataModule2.Table16Gebjahr.AsString :=
                DataModule2.Table9Gebjahr.AsString;           //@0054A2DD-54A30A
              DataModule2.Table16Gebort.AsString :=
                DataModule2.Table9Gebort.AsString;            //@0054A310-54A33D
            end
            else if (Trim(DataModule2.Table9Taufjahr.AsString) <> '') or
              (Trim(DataModule2.Table9Taufort.AsString) <> '') then
            begin
              DataModule2.Table16Gebtag.AsString :=
                '~' + DataModule2.Table9Tauftag.AsString;     //@0054A3B0-54A3F3 (@LStrCat3)
              DataModule2.Table16Gebmonat.AsString :=
                DataModule2.Table9Taufmonat.AsString;         //@0054A3F9-54A426
              DataModule2.Table16Gebjahr.AsString :=
                DataModule2.Table9Taufjahr.AsString;          //@0054A42C-54A459
              DataModule2.Table16Gebort.AsString :=
                DataModule2.Table9Taufort.AsString;           //@0054A45F-54A48C
            end;

            if (Trim(DataModule2.Table9Stjahr.AsString) <> '') or
              (Trim(DataModule2.Table9Stort.AsString) <> '') then
            begin
              DataModule2.Table16Sttag.AsString :=
                '+' + DataModule2.Table9Sttag.AsString;       //@0054A4FA-54A53D (@LStrCat3)
              DataModule2.Table16Stmonat.AsString :=
                DataModule2.Table9Stmonat.AsString;           //@0054A543-54A570
              DataModule2.Table16Stjahr.AsString :=
                DataModule2.Table9Stjahr.AsString;            //@0054A576-54A5A3
              DataModule2.Table16Stort.AsString :=
                DataModule2.Table9Stort.AsString;             //@0054A5A9-54A5D6
            end
            else if (Trim(DataModule2.Table9Begjahr.AsString) <> '') or
              (Trim(DataModule2.Table9Begort.AsString) <> '') then
            begin
              DataModule2.Table16Sttag.AsString :=
                '#' + DataModule2.Table9Begtag.AsString;      //@0054A649-54A68C (@LStrCat3)
              DataModule2.Table16Stmonat.AsString :=
                DataModule2.Table9Begmonat.AsString;          //@0054A692-54A6BF
              DataModule2.Table16Stjahr.AsString :=
                DataModule2.Table9Begjahr.AsString;           //@0054A6C5-54A6F2
              DataModule2.Table16Stort.AsString :=
                DataModule2.Table9Begort.AsString;            //@0054A6F8-54A725
            end;
            //@0054A72B-54AE04: CHUNK D3 - Ehepartner-Fuell-Block (T15 -> T16).
            //Der Block liegt vollstaendig im Dedup-Zweig: ein gleiches nummer
            //(je 54A111) ueberspringt auch ihn, ein FindKey-Fehler ebenfalls
            //(je 54AE04 -> Query1.Next).
            treffer := 0;                                   //@0054A72B (xor esi,esi)
            if DataModule2.Table15.FindKey(                 //@0054A72D-54A76E (je 54AE04)
              [Query1.FieldByName('nummer').AsInteger]) then
              //@0054A774 -> 54ADD0: die Schleifenbedingung wird zuerst geprueft
              while Query1.FieldByName('nummer').AsInteger =
                DataModule2.Table15Nummer.AsInteger do      //@0054ADD0-54ADFE (je 54A779)
              begin
                //@0054A779-54A78D: leere Epnum -> sofort zum Join (jle 54AD81)
                if DataModule2.Table15Epnum.AsInteger > 0 then
                begin
                  //@0054A793-54A7B0: die erste T15-Zeile fuellt die von D2
                  //angehaengte Ergebniszeile, jede weitere haengt eine neue an.
                  if treffer > 0 then
                    DataModule2.Table16.Append              //@0054A797-54A7A4
                  else
                    treffer := 1;                           //@0054A7AB (mov esi,1)
                  k := 'o-o';                               //@0054A7B0 (6F2D6F03)
                  if Pos('Ehes', DataModule2.Table15Verbind.AsString) > 0 then
                    k := 'oo';                              //@0054A7B7-54A7EF (@LStrPos)
                  //@0054A7F0-54A852: Trau-Daten (Hort oder Hjahr gefuellt)
                  if (Trim(DataModule2.Table15Hort.AsString) <> '') or
                    (Trim(DataModule2.Table15Hjahr.AsString) <> '') then
                  begin
                    k := k + 'K';                           //@0054A858-54A862 (@PStrNCat cl=3)
                    DataModule2.Table16Htag.AsString :=
                      k + ' ' + DataModule2.Table15Htag.AsString; //@0054A867-54A8D8
                    DataModule2.Table16Hmonat.AsString :=
                      DataModule2.Table15Hmonat.AsString;   //@0054A8DE-54A90B
                    DataModule2.Table16Hjahr.AsString :=
                      DataModule2.Table15Hjahr.AsString;    //@0054A911-54A93E
                    DataModule2.Table16Hort.AsString :=
                      DataModule2.Table15Hort.AsString;     //@0054A944-54A971
                    //@0054A977-54A9AB: Quirk - das FindKey-Ergebnis wird hier
                    //verworfen (im Else-Zweig dagegen wird es getestet).
                    DataModule2.Table9.FindKey(
                      [DataModule2.Table15Epnum.AsInteger]);
                    DataModule2.Table16Hname.AsString :=
                      DataModule2.Table9Name.AsString + ' ' +
                      DataModule2.Table9Vornamen.AsString;  //@0054A9B0-54AA16 (@LStrCatN 3)
                  end
                  //@0054AA21-54AA83: Sauf-/Tauf-Daten (Saort oder Sajahr gefuellt)
                  else if (Trim(DataModule2.Table15Saort.AsString) <> '') or
                    (Trim(DataModule2.Table15Sajahr.AsString) <> '') then
                  begin
                    k := k + 'S';                           //@0054AA89-54AA93 (@PStrNCat cl=3)
                    //@0054AA98-54AB09: Quirk - Satag wandert in das Htag-Feld
                    DataModule2.Table16Htag.AsString :=
                      k + ' ' + DataModule2.Table15Satag.AsString;
                    DataModule2.Table16Hmonat.AsString :=
                      DataModule2.Table15Samonat.AsString;  //@0054AB0F-54AB3C
                    DataModule2.Table16Hjahr.AsString :=
                      DataModule2.Table15Sajahr.AsString;   //@0054AB42-54AB6F
                    DataModule2.Table16Hort.AsString :=
                      DataModule2.Table15Saort.AsString;    //@0054AB75-54ABA2
                    //@0054ABA8-54ABDC: Quirk - Ergebnis wird verworfen
                    DataModule2.Table9.FindKey(
                      [DataModule2.Table15Epnum.AsInteger]);
                    DataModule2.Table16Hname.AsString :=
                      DataModule2.Table9Name.AsString + ' ' +
                      DataModule2.Table9Vornamen.AsString;  //@0054ABE1-54AC47 (@LStrCatN 3)
                  end
                  else
                  begin
                    //@0054AC52-54AC8D: ohne Treffer wird nichts gefuellt
                    if DataModule2.Table9.FindKey(
                      [DataModule2.Table15Epnum.AsInteger]) then
                      //@0054AC93-54ACF5: Vornamen oder Name muessen gefuellt sein
                      if (Trim(DataModule2.Table9Vornamen.AsString) <> '') or
                        (Trim(DataModule2.Table9Name.AsString) <> '') then
                      begin
                        DataModule2.Table16Htag.AsString := 'oo'; //@0054ACFB-54AD0F (54C288)
                        DataModule2.Table16Hname.AsString :=
                          DataModule2.Table9Name.AsString + ' ' +
                          DataModule2.Table9Vornamen.AsString;    //@0054AD15-54AD7B (@LStrCatN 3)
                      end;
                  end;
                end;
                //@0054AD81-54ADB5: Join - Zeile schliessen, T15 weiterzaehlen.
                DataModule2.Table16.Post;                   //@0054AD81-54AD90 (vtbl+248)
                DataModule2.Table16.Edit;                   //@0054AD96-54ADA3
                DataModule2.Table15.Next;                   //@0054ADA8-54ADB5
                if DataModule2.Table15.EOF then             //@0054ADBA-54ADCE (jne 54AE04)
                  Break;
              end;
          end;                                              //@0054A111: Dedup-Zweig
        end;                                                //@0054A0AC: Anhaeng-Zweig
        Query1.Next;                                        //@0054AE04
      end;                                                  //@0054AE24: Fuell-Schleife
    finally                                                 //@0054AE3A: Frame2 abbauen
      //@0054AE3A-54AE3F: Frame-Abbau (xor eax,eax / pop edx / pop ecx / pop
      //ecx / mov fs:[eax],edx). @0054AE42-54AE55: Finally-Koerper mit
      //push 54AE5D als Resume-Adresse; ab @0054AE5D laeuft der Ablauf nach
      //dem finally weiter.
      Screen.Cursor := crDefault;                           //@0054AE47-54AE50 (xor edx,edx)
    end;                                                    //@0054AE55 (ret) -> 54AE5D

    //=== CHUNK E: Trefferliste nach Form1.StringGrid5 uebernehmen ============
    //@0054AE5D-54B4F1: Auswertung von DataModule2.Table16 (Suchergebnis).
    //@0054AE5D-54AE80: Post nur im dsEdit/dsInsert - die Folge add dl,FE /
    //sub dl,2 / jae testet modular (State-2) < 2, also genau Zustand 2..3.
    if DataModule2.Table16.State in [dsEdit, dsInsert] then  //@0054AE5D-54AE76
      DataModule2.Table16.Post;                             //@0054AE78-54AE80 (vtbl+248)
    DataModule2.Table16.First;                              //@0054AE86-54AE93
    if DataModule2.Table16.RecordCount > 0 then             //@0054AE98-54AEAF (vtbl+14C, jle 54B4AD)
    begin
      //@0054AEB5-54AF59: alte Inhalte leeren. Quirk: die Schleife laeuft
      //einschliesslich RowCount - der Bound wird einmalig aus [grid+24C]
      //(FRowCount) gelesen, der Zaehler esi laeuft von 0 aufwaerts, waehrend
      //ebx mit Bound+1 runterzaehlt; es wird also eine Zeile mehr geleert,
      //als RowCount angibt.
      for i := 0 to Form1.StringGrid5.RowCount do
      begin
        Form1.StringGrid5.Cells[0, i] := '';                 //@0054AED3-54AEE6
        Form1.StringGrid5.Cells[1, i] := '';                 //@0054AEEB-54AF01
        Form1.StringGrid5.Cells[2, i] := '';                 //@0054AF06-54AF1C
        Form1.StringGrid5.Cells[3, i] := '';                 //@0054AF21-54AF37
        Form1.StringGrid5.Cells[4, i] := '';                 //@0054AF3C-54AF52
      end;                                                   //@0054AF57-54AF59 (inc esi / dec ebx)
      //@0054AF5F-54AF94: Kopfzeile anlegen - Spaltenbasis 0, ab Zeile 2.
      spalte := 0;                                           //@0054AF5F (xor esi,esi)
      zeile := 2;                                            //@0054AF61 (mov ebx,2)
      Form1.StringGrid5.RowCount := zeile + 1;               //@0054AF66-54AF76 (lea edx,[ebx+1])
      Form1.StringGrid5.Cells[1, 0] := 'Globale Suche';      //@0054AF7B-54AF94
      //@0054AF99-54B057: Ortsangabe ueberschreibt Titelzelle und Report-Titel.
      //Getrimmt wird nur fuer die Bedingung, geschrieben wird der ungetrimmte
      //Edit-Text (fuer jede der beiden Zuweisungen frisch konkatiniert).
      if Trim(Edit23.Text) <> '' then                        //@0054AF99-54AFC5 (jbe 54B43D)
      begin
        Form1.StringGrid5.Cells[1, 0] := 'Ort = ' + Edit23.Text; //@0054AFCB-54B010 (@LStrCat3)
        Form15.QRLabel3.Caption := 'Ort = ' + Edit23.Text;   //@0054B015-54B052 (@LStrCat3)
      end;
      //@0054B43D-54B451: Schleifenkopf (FEOF-Test, springt je 54B05C in den
      //Koerper; der Rueckweg testet unter 54B427 ein zweites Mal).
      while not DataModule2.Table16.EOF do
      begin
        //@0054B05C-54B070: Datensaetze ohne Nummer werden uebersprungen
        //(AsInteger <= 0 -> jle 54B415 = Next, ohne Zeilenzuschlag).
        if DataModule2.Table16Nummer.AsInteger > 0 then      //@0054B05C-54B070 (vtbl+58)
        begin
          Form1.StringGrid5.Cells[spalte, zeile] :=
            IntToStr(DataModule2.Table16Nummer.AsInteger);   //@0054B076-54B0AB
          Form1.StringGrid5.Cells[spalte + 1, zeile] :=
            DataModule2.Table16Name.AsString;                //@0054B0B0-54B0E1 (vtbl+60)
          //@0054B0E6-54B209: Geburtsjahr mit Kennbuchstabe aus Gebtag.
          if Trim(DataModule2.Table16Gebjahr.AsString) <> '' then //@0054B0E6-54B116
          begin
            if Pos('*', DataModule2.Table16Gebtag.AsString) > 0 then //@0054B11C-54B146
              Form1.StringGrid5.Cells[spalte + 2, zeile] :=
                '* ' + DataModule2.Table16Gebjahr.AsString   //@0054B148-54B18F
            else if Pos('~', DataModule2.Table16Gebtag.AsString) > 0 then //@0054B196-54B1C0
              Form1.StringGrid5.Cells[spalte + 2, zeile] :=
                '~ ' + DataModule2.Table16Gebjahr.AsString;  //@0054B1C2-54B209
          end;
          //@0054B20E-54B3FA: Heirats- bzw. Sterbejahr in Spalte 3.
          if Trim(DataModule2.Table16Hjahr.AsString) <> '' then //@0054B20E-54B23E
            Form1.StringGrid5.Cells[spalte + 3, zeile] :=
              Trim(Copy(DataModule2.Table16Htag.AsString, 1, 3)) +
              DataModule2.Table16Hjahr.AsString              //@0054B244-54B2CD (@LStrCopy / @LStrCat)
          else if Trim(DataModule2.Table16Stjahr.AsString) <> '' then //@0054B2D7-54B307
          begin
            if Pos('+', DataModule2.Table16Sttag.AsString) > 0 then //@0054B30D-54B337
              Form1.StringGrid5.Cells[spalte + 3, zeile] :=
                '+ ' + DataModule2.Table16Stjahr.AsString    //@0054B339-54B380
            else if Pos('#', DataModule2.Table16Sttag.AsString) > 0 then //@0054B387-54B3B1
              Form1.StringGrid5.Cells[spalte + 3, zeile] :=
                '# ' + DataModule2.Table16Stjahr.AsString;   //@0054B3B3-54B3FA
          end;
          //@0054B3FF-54B410: Zeilenzuschlag nur fuer uebernommene Datensaetze,
          //RowCount der Ergebnisliste mitfuehren.
          Inc(zeile);                                        //@0054B3FF (inc ebx)
          Form1.StringGrid5.RowCount := zeile + 1;           //@0054B400-54B410 (lea edx,[ebx+1])
        end;
        DataModule2.Table16.Next;                            //@0054B415-54B422
      end;                                                   //@0054B427/54B43D (FEOF-Tests)
      //@0054B457-54B4A8: Ergebnisliste sichtbar schalten, Menuepunkt
      //einblenden, HelpContext 22 setzen (Disasm fuehrt das als $16).
      Form1.StringGrid5.Visible := True;                     //@0054B457-54B466 (vtbl+34 SetVisible)
      Form1.MainMenu1.Items[3].Items[5].Visible := True;     //@0054B46B-54B491 (GetItem 3 / GetItem 5)
      Form1.StringGrid5.HelpContext := 22;                   //@0054B496-54B4A8 (mov edx,$16)
    end;                                                     //@0054B4AD: Join (jle von 54AEAF)
    //@0054B4AD-54B4F1: Aufraeumen - Filter/Indizes zuruecksetzen, Flag loeschen.
    DataModule2.Table9.Filtered := False;                    //@0054B4AD-54B4BE (vtbl+190)
    DataModule2.Table9.IndexName := '';                      //@0054B4C4-54B4D3 (SetIndexName)
    DataModule2.Table15.IndexName := '';                     //@0054B4D8-54B4E7
    gvar_0061EFE0 := '';                                     //@0054B4EC-54B4F1 (@LStrClr)
  finally
    //@0054B4F6-54B4FB: aeusserer Frame abbauen (xor eax,eax / pop edx / pop
    //ecx / pop ecx / mov fs:[eax],edx), Resume-Adresse push 54BC1A.
    //Der Finally-Koerper des Originals enthaelt ausschliesslich die
    //compilergenerierte Raeumung der verwalteten Lokalen
    //@0054B503-54BC0F (@LStrArrayClr / @LStrClr); der Exception-Pfad laeuft
    //@0054BC10 -> @HandleFinally -> jmp 0054B503 ueber denselben Block.
    //@0054BC1A: Epilog (pop edi / pop esi / pop ebx / mov esp,ebp / pop ebp).
  end;
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

