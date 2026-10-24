unit Unit13;

{-------------------------------------------------------------------------------
  Unit13 - TForm13, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit13.pas and the original resource
  Source\Projects_AhnenWin\Form13.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, StrUtils, Classes, ExtCtrls, Buttons, Dialogs, StdCtrls, WPPDFR2, WPPDFPRP, Forms, Controls, Grids, DB;

type
  TForm13 = class(TForm)
  published
    Panel1: TPanel; //2F0
    SpeedButton11: TSpeedButton; //2F4
    SpeedButton12: TSpeedButton; //2F8
    SpeedButton1: TSpeedButton; //2FC
    PrintDialog1: TPrintDialog; //300
    Label1: TLabel; //304
    Button1: TButton; //308
    FontDialog1: TFontDialog; //30C
    SpeedButton2: TSpeedButton; //310
    Button2: TButton; //314
    Button3: TButton; //318
    Button4: TButton; //31C
    SaveDialog1: TSaveDialog; //320
    PrinterSetupDialog1: TPrinterSetupDialog; //324
    SpeedButton13: TSpeedButton; //328
    Button5: TButton; //32C
    Button6: TButton; //330
    Label2: TLabel; //334
    PaintBox1: TPaintBox; //338
    ScrollBar1: TScrollBar; //33C
    ScrollBar2: TScrollBar; //340
    Memo1: TMemo; //344
    Button7: TButton; //348
    Button8: TButton; //34C
    Label3: TLabel; //350
    WPPDFPrinter1: TWPPDFPrinter; //354
    SpeedButton3: TSpeedButton; //358
    WPPDFProperties1: TWPPDFProperties; //35C
    procedure nr2; //0056CB30
    procedure nz1; //0056D6B4
    procedure nz2; //0056EB10
    procedure schieb_vm; //0056862C
    procedure schieb_vm1; //00568528
    procedure ScrollBar1Change(Sender: TObject); //00572484
    procedure ScrollBar2Change(Sender: TObject); //00572490
    procedure nr1; //0056C0D4
    procedure Nach_erm; //0056A970
    procedure kek_ord; //005686F0
    procedure Proband1Click; //005729E4
    procedure Button7Click(Sender: TObject); //00573120
    procedure vorf_erm2; //00572A78
    procedure SpeedButton3Click(Sender: TObject); //00573450
    procedure sam2; //00572D98
    procedure Symm; //00568834
    procedure kek_ord_2; //00568774
    procedure Verwandtschaft1Click(Sender: TObject); //0057249C
    procedure Button8Click(Sender: TObject); //005730D4
    procedure Vorf_erm1; //00563CF8
    procedure memein; //00566220
    procedure FormCreate(Sender: TObject); //00570740
    procedure Vorf_erm; //00567A30
    procedure Button1Click(Sender: TObject); //005707C0
    procedure Button2Click(Sender: TObject); //00570838
    procedure SpeedButton2Click(Sender: TObject); //0057082C
    procedure FormShow(Sender: TObject); //00570294
    procedure UpDown1Click; //005661E8
    procedure SpeedButton1Click(Sender: TObject); //005704A8
    procedure FormClose(sender:tobject;var action:tcloseaction); //00570728
    procedure SpeedButton12Click(Sender: TObject); //00570694
    procedure Button3Click(Sender: TObject); //00570854
    procedure vr1; //00570D1C
    procedure SpeedButton13Click(Sender: TObject); //00572478
    procedure vz1; //005711D4
    procedure vz2; //00569504
    procedure Vr2; //0056904C
    procedure nachf_neu; //00564668
    procedure Button4Click(Sender: TObject); //00570890
    procedure PaintBox1Paint(Sender:TObject); //00570C14
    procedure Button6Click(Sender: TObject); //00572448
    procedure Button5Click(Sender: TObject); //00572404
  end;

var
  Form13: TForm13;

implementation

uses
  Unit12, Unit2, AHNGlobals;
{$R ..\Forms\Form13.DFM}


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure sub_005637C4(AValue: Integer; var AResult: AnsiString);
var
  s: AnsiString;
begin
  { Formats the number to 6 digits, zero padded from the right. }
  s := '000000' + IntToStr(AValue);
  AResult := Copy(s, Length(s) - 5, 6);
end;

procedure sub_00563868(AIn: AnsiString; var AOut: AnsiString);
var
  i: Integer;
  c: AnsiChar;
begin
  { Uppercases AIn character by character; the German umlauts
    (which UpperCase does not handle) are mapped manually to
    their respective uppercase form first. }
  AOut := '';
  for i := 1 to Length(AIn) do
  begin
    c := AnsiChar(AIn[i]);
    if c = #$E4 then
      AOut := AOut + #$C4
    else
    begin
      if c = #$F6 then
        AOut := AOut + #$D6
      else
      begin
        if c = #$FC then
          AOut := AOut + #$DC
        else
          AOut := AOut + UpperCase(AnsiString(c));
      end;
    end;
  end;
end;

procedure sub_00563A0C(AIn: AnsiString; var AErgebnis: AnsiString);
var
  s: AnsiString;
  i: Integer;
begin
  { Normalizes a date/comment entry: the prefixes ("..", "HK ", "vor...",
    "nach...") are evaluated, then leading dots and blanks are removed
    and the remaining dots are stripped. }
  AErgebnis := AIn;
  s := AIn;
  if Trim(s) = '..' then
  begin
    AErgebnis := '';
    exit;
  end;
  if Copy(s, 1, 2) = 'HK' then
  begin
    AErgebnis := 'HK ' + Copy(s, 4, 7);
    exit;
  end;
  if Pos('vo.r', s) > 0 then
  begin
    AErgebnis := Copy(s, 1, 2) + Copy(s, 4, 1) + ' ' + RightStr(s, 4);
    exit;
  end;
  if Pos('na.ch', s) > 0 then
  begin
    AErgebnis := Copy(s, 1, 2) + Copy(s, 4, 2) + ' ' + RightStr(s, 4);
    exit;
  end;
  if Trim(s) = '' then
    exit;
  AErgebnis := '';
  while (Length(s) > 0) and ((s[1] = '.') or (s[1] = ' ')) do
    s := Copy(s, 2, 9);
  AErgebnis := s;
  if (Length(s) > 0) and (s[1] > '9') then
  begin
    AErgebnis := '';
    for i := 1 to Length(s) do
      if s[i] <> '.' then
        AErgebnis := AErgebnis + s[i];
    if Length(AErgebnis) > 0 then
      for i := 1 to Length(AErgebnis) do
        if AErgebnis[i] < ':' then
        begin
          Insert(' ', AErgebnis, i);
          break;
        end;
  end;
end;

procedure TForm13.nr2;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.nz1;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.nz2;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.schieb_vm;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.schieb_vm1;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.ScrollBar1Change(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.ScrollBar2Change(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.nr1;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.Nach_erm;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.kek_ord;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.Proband1Click;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.Button7Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.vorf_erm2;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.SpeedButton3Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.sam2;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.Symm;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.kek_ord_2;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.Verwandtschaft1Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.Button8Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.Vorf_erm1;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.memein;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.FormCreate(Sender: TObject);
begin
  //00570740: Anfangsmasse und Zeichenstift vorbereiten.
  gvar_02536380 := $35C;
  gvar_02536384 := $258;
  gvar_011AE31C := 0;
  gvar_011AE324 := 0;
  gvar_011AE318 := 0;
  gvar_0253637C := 0;
  PaintBox1.Height := $64;
  PaintBox1.Width := $64;
  PaintBox1.Color := $FFFFFF;
  PaintBox1.Canvas.Pen.Width := 1;
end;

procedure TForm13.Vorf_erm;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.Button1Click(Sender: TObject);
begin
  //005707C0: zwischen symmetrisch / asymmetrisch umschalten.
  if gvar_0061F2DC <> 0 then
    gvar_0061F2DC := 0
  else
    gvar_0061F2DC := 1;
  if gvar_0061F2DC <> 0 then
    Button1.Caption := 'asym.'
  else
    Button1.Caption := 'symm.';
  PaintBox1.Refresh;
end;

procedure TForm13.Button2Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.SpeedButton2Click(Sender: TObject);
begin
  //0057082C: nur Form13 schliessen.
  Close;
end;

procedure TForm13.FormShow(Sender: TObject);
begin
  //00570294: Tabellen oeffnen, Skaliermasse setzen und je nach
  //Aufrufmodus (gvar_0253692C) das Bild vorbereiten.
  gvar_02536388 := 0;
  Button1.Visible := False;
  DataModule2.Table17.Open;
  DataModule2.Table17.IndexName := '';
  DataModule2.Table18.Open;
  DataModule2.Table1Nummer.Value; //05702F3: Feldzugriff ohne Verwertung des Ergebnisses
  gvar_0061F2F4 := 0;
  gvar_0061F2F8 := 0;
  gvar_0061F120 := 0.375;
  gvar_0061F11C := Round(gvar_0061F120 * 6);
  gvar_011AE338 := $14;
  gvar_011AE334 := Round(gvar_0061F120 * 120);
  if gvar_0253692C = 'Vorgr1' then
  begin
    PaintBox1.Refresh;
    ScrollBar1.Position := 0;
    ScrollBar2.Position := 0;
    Vorf_erm;
  end;
  if gvar_0253692C = 'Vorgr2' then
  begin
    PaintBox1.Refresh;
    ScrollBar1.Position := 0;
    ScrollBar2.Position := 0;
    Vorf_erm;
  end;
  if gvar_0253692C = 'Nachgr1' then
  begin
    PaintBox1.Refresh;
    ScrollBar1.Position := 0;
    ScrollBar2.Position := 0;
    Nach_erm;
  end;
  if gvar_0253692C = 'Nachgr2' then
  begin
    PaintBox1.Refresh;
    ScrollBar1.Position := 0;
    ScrollBar2.Position := 0;
    Nach_erm;
  end;
end;

procedure TForm13.SpeedButton12Click(Sender: TObject);
begin
  //00570694: Zeichensatz waehlen (fuer Bild und Druck gleicher Stift).
  if gvar_011AE32C <> nil then
    gvar_011AE32C.Font.Name := 'Arial';
  if FontDialog1.Execute then
    gvar_0061F2EC := FontDialog1.Font.Name;
  PaintBox1.Refresh;
end;

procedure TForm13.UpDown1Click;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.SpeedButton1Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.FormClose(sender:tobject;var action:tcloseaction);
begin
  //00570728: Form12 schliessen und Form13 unsichtbar stellen.
  { gvar_0061F0F8^ ist Form12; gvar_0061F10C ist Form13. }
  Form12.Close;
  Form13.Hide;
end;

procedure TForm13.Button3Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.vr1;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.SpeedButton13Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.vz1;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.vz2;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.Vr2;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.nachf_neu;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.Button4Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.PaintBox1Paint(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.Button6Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.Button5Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;


end.
