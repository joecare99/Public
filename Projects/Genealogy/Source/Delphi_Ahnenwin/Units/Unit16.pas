unit Unit16;

{-------------------------------------------------------------------------------
  Unit16 - TForm16, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit16.pas and the original resource
  Source\Projects_AhnenWin\Form16.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  Windows, SysUtils, Classes, ExtCtrls, QRPrntr, Dialogs, Menus, Buttons, StdCtrls, Spin, WPPDFR2, WPPDFPRP, Forms, Controls, Grids, DB, QRCtrls, QuickRpt, AHNGlobals;

type
  TForm16 = class(TForm)
  published
    Shape1: TShape; //2F0
    QRPreview1: TQRPreview; //2F4
    PrintDialog1: TPrintDialog; //2F8
    SaveDialog1: TSaveDialog; //2FC
    OpenDialog1: TOpenDialog; //300
    MainMenu1: TMainMenu; //304
    Datei1: TMenuItem; //308
    N2: TMenuItem; //30C
    Beenden1: TMenuItem; //310
    N3: TMenuItem; //314
    Anzeige1: TMenuItem; //318
    Optionen1: TMenuItem; //31C
    bersichtsseiten1: TMenuItem; //320
    keine11: TMenuItem; //324
    vier1: TMenuItem; //328
    neun1: TMenuItem; //32C
    N161: TMenuItem; //330
    Seitenausrichtung1: TMenuItem; //334
    hoch1: TMenuItem; //338
    quer1: TMenuItem; //33C
    FontDialog1: TFontDialog; //340
    Panel2: TPanel; //344
    SpeedButton2: TSpeedButton; //348
    SpeedButton3: TSpeedButton; //34C
    SpeedButton6: TSpeedButton; //350
    SpeedButton1: TSpeedButton; //354
    Button9: TButton; //358
    Label5: TLabel; //35C
    Button5: TButton; //360
    SpeedButton7: TSpeedButton; //364
    Label1: TLabel; //368
    ComboBox1: TComboBox; //36C
    SpinEdit1: TSpinEdit; //370
    Bevel2: TBevel; //374
    Bevel1: TBevel; //378
    Button1: TButton; //37C
    Button2: TButton; //380
    Button3: TButton; //384
    Button4: TButton; //388
    Label2: TLabel; //38C
    WPPDFPrinter1: TWPPDFPrinter; //390
    SpeedButton4: TSpeedButton; //394
    WPPDFProperties1: TWPPDFProperties; //398
    procedure Button9Click(Sender: TObject); //0055D7D0
    procedure bildneu; //0055D790
    procedure Button5Click(Sender: TObject); //0055DA68
    procedure Speichernunter1Click; //0055BDB0
    procedure SpeedButton1Click(Sender: TObject); //0055D394
    procedure Button1Click(Sender: TObject); //0055D774
    procedure Quickreport1NeedData; //0055E2C0
    procedure SpeedButton4Click(Sender: TObject); //0055E2E8
    procedure FormCreate(Sender: TObject); //0055E544
    procedure FormClose(sender:tobject;var action:tcloseaction); //0055DC1C
    procedure SpeedButton6Click(Sender: TObject); //0055DCC4
    procedure Beenden1Click(Sender: TObject); //0055E2AC
    procedure SpeedButton3Click(Sender: TObject); //0055D38C
    procedure showpagenumber; //0055B940
    procedure Button3Click(Sender: TObject); //0055BC10
    procedure Button4Click(Sender: TObject); //0055BC38
    procedure FormShow(Sender: TObject); //0055BA2C
    procedure showprev(APage: Integer); //0055B9F0
    procedure QRPreview1PageAvailable(Sender: TObject; Page: Integer); //0055BB34
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState); //0055BB20
    procedure Drucken1Click; //0055BD30
    procedure SpeedButton2Click(Sender: TObject); //0055BDA8
    procedure ComboBox1Click(Sender: TObject); //0055BC58
    procedure SpinEdit1Change(Sender: TObject); //0055BCE0
    procedure Button2Click(Sender: TObject); //0055BD0C
  public
    Zaehler: Integer; //39C - Zaehler von Quickreport1NeedData
  end;

var
  Form16: TForm16;

implementation

{$R ..\Forms\Form16.DFM}

uses
  Unit1, Unit2, Unit3, Unit15;


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure TForm16.Button9Click(Sender: TObject);
var
  band: Integer;
begin
  { (0055D7D0) Die Schrift fuer den Uebersichtsdruck waehlen und die
    Bandhoehen der Uebersicht in Form15 passend skalieren. }
  if FontDialog1.Execute then
  begin
    Form15.QRBand4.Height := 6 + Round(FontDialog1.Font.Size *
      FontDialog1.Font.PixelsPerInch / 72);
    band := Round(Form15.QRBand1.Height / 2) and $FF;
    Form15.QRBand3.Top := band;
    Form15.QRBand1.Height := 3 + band;
    Form15.QRBand3.Top := Form15.QRBand1.Height - 3;
    Form15.QRMemo1.Font := FontDialog1.Font;
    Form15.QRLabel1.Font := FontDialog1.Font;
    Form15.QRLabel2.Font := FontDialog1.Font;
    Form15.QRShape1.Font := FontDialog1.Font;
    Form15.QRLabel1.Font.Size := 8;
    Form15.QRLabel1.Font.Style := [];
    Form15.QRLabel2.Font.Style := [];
    Form15.QRShape1.Font := FontDialog1.Font;
    Form15.QRDBText1.Font := FontDialog1.Font;
    Form15.QRDBText2.Font := FontDialog1.Font;
    Form15.QRDBText3.Font := FontDialog1.Font;
    Form15.QRSysData1.Font := FontDialog1.Font;
    Form15.QRSysData1.Font.Size := 8;
    Form15.QRSysData2.Font := FontDialog1.Font;
    Form15.QRSysData2.Font.Size := 8;
    bildneu;
  end;
end;

procedure TForm16.bildneu;
begin
  { (0055D790) Form15 baut die Uebersichtsseiten in der Vorschau neu
    auf.
    Form15.QuickRep1.Preview;
    - die Vorschau ist im Kompatibilitaetsschicht nicht implementiert. }
end;

procedure TForm16.Button5Click(Sender: TObject);
begin
  { (0055DA68) Umschalten der Papiergroesse fuer die Uebersichtsseiten:
    A 3 mit 4 Spalten gegen A 4 mit 3 Spalten - und Uebersicht neu
    aufbauen. }
  if Button5.Caption = 'A 3' then
  begin
    Form15.QuickRep1.Page.PaperSize := TQRPaperSize(8);
    if Form15.QuickRep1.Page.Columns = 3 then
      Form15.QuickRep1.Page.Columns := 4
    else
    begin
      if Form15.QuickRep1.Page.Columns = 2 then
        Form15.QuickRep1.Page.Columns := 3;
    end;
    Button5.Caption := 'A 4';
    { Form15.QuickRep1.Preview; - die Vorschau ist im
      Kompatibilitaetsschicht nicht implementiert. }
  end;
  if Button5.Caption = 'A 4' then
  begin
    Form15.QuickRep1.Page.PaperSize := TQRPaperSize(9);
    if Form15.QuickRep1.Page.Columns = 4 then
      Form15.QuickRep1.Page.Columns := 3
    else
    begin
      if Form15.QuickRep1.Page.Columns = 3 then
        Form15.QuickRep1.Page.Columns := 2;
    end;
    Button5.Caption := 'A 3';
    { Form15.QuickRep1.Preview; - die Vorschau ist im
      Kompatibilitaetsschicht nicht implementiert. }
  end;
end;

procedure TForm16.Speichernunter1Click;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm16.SpeedButton1Click(Sender: TObject);
begin
  { (0055D394) Schliessen der Vorschau: Bei der Namensregister- oder
    Ortsregister-Ausgabe wird nachgefragt, ob fehlende Registerteile
    noch erzeugt werden sollen. Gibt es einen Abbruch, werden die
    vorbereiteten Eintragslisten wieder freigegeben. }
  Form16.Close;
  if gvar_0253692C = 'Vorf' then
  begin
    if gvar_0061F0BC = 0 then
    begin
      if MessageDlg('Namensregister ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        gvar_0061F0BC := 1;
        Form1.Refresh;
        gvar_02536440 := gvar_0061F050;
        Form3.NList;
      end
      else
      begin
        try
          TObject(Pointer(gvar_02536440)).Free;
        except
        end;
      end;
    end;
    if gvar_0061F0C0 = 0 then
    begin
      if MessageDlg('Ortsregister ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        gvar_0061F0C0 := 1;
        gvar_0061F0BC := 1;
        Form1.Refresh;
        gvar_02536444 := gvar_0061F054;
        Form3.OList;
      end
      else
      begin
        try
          TObject(Pointer(gvar_02536444)).Free;
        except
        end;
      end;
    end;
  end;
end;

procedure TForm16.Button1Click(Sender: TObject);
begin
  { (0055D774) "Seite 1" - the first page is shown. }
  QRPreview1.PageNumber := 1;
  showpagenumber;
end;

procedure TForm16.Quickreport1NeedData;
var
  AErgebnis: Boolean;
begin
  { (0055E2C0) Detail-Treiber der bersichtsseiten: der Zaehler wird
    weitergezaehlt und mit der Seitenanzahl verglichen;
    das Ergebnis-Flag (var-Parameter in NeedData-Mechanik) liefert
    das Vergleichsergebnis. }
  Inc(Zaehler);
  { AErgebnis := Zaehler <= Form15.QuickRep1.?QRPrinter.?PageCount;
    - der Seitenzaehler ist im Kompatibilitaetsschicht nicht gegeben. }
  AErgebnis := False;
end;

procedure TForm16.SpeedButton4Click(Sender: TObject);
var
  s_pdf: AnsiString;
begin
  { (0055E2E8) Alle bersichtsseiten als PDF-Datei unter dem Namen des
    laufenden Registers ausgeben. Der PDF-Drucker bekommt den Datei-
    namen, die Reportseite wird unsichtbar geschaltet, die Seiten
    werden einzeln gerendert und am Ende wird die Reportseite wieder
    angezeigt und in der Vorschau angezeigt. }
  s_pdf := gvar_0253692C + '.pdf';
  { Form16.WPPDFPrinter1.Filename := String(s_pdf); - im
    Kompatibilitaetsschicht nicht unterstuetzt (WPPDFR1-Shell). }
  Zaehler := 0;
  { Form15.QuickRep1.Visible := False; - die Reportseite bietet
    Anfang/Ende des Lesens nur im Original (sichtbar bei Prepare). }
  try
    { Die komplette PDF-Ausgabe (BeginDoc/Prepare/Render/Einzelseiten/
      EndDoc) ist im Kompatibilitaetsschicht nicht implementiert. }
  finally
    { Form15.QuickRep1.Visible := True; }
    { Form15.QuickRep1.Preview; - die Vorschau ist im
      Kompatibilitaetsschicht nicht implementiert. }
  end;
end;

procedure TForm16.FormCreate(Sender: TObject);
begin
  { (0055E544) Lizenz des PDF-Druckers beim Erzeugen der Form setzen. }
  { WPPDFPrinter1.?DLLName := 'Ahnw50.dll'; und Lizenz 'Heribert
    Reitmeier'/'A144arg6fm45afqf96d4@80B340EF':
    im Kompatibilitaetsschicht (WPPDFR1-Shell) nicht implementiert. }
end;

procedure TForm16.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { (0055DC1C) Navigationsleiste befreien: Nur bei den Registerausgaben
    "Vorf"/"Nach"/"OFB" bleibt der Merkstring erhalten, sonst wird er
    gelst; die berschrift der Vorschau und der Stand der selektierten
    Person wird zurckgesetzt. }
  if (gvar_0253692C <> 'Vorf') and (gvar_0253692C <> 'Nach') and
     (gvar_0253692C <> 'OFB') then
    gvar_0253692C := '';
  Form15.QRLabel3.Caption := '';
  if gvar_02536BA0 > 1 then
    Form1.DBText1.Color := $FFFF;
end;

procedure TForm16.SpeedButton6Click(Sender: TObject);
begin
  { (0055DCC4) Alle bersichtsseiten als HTML-Datei speichern: der Dialog
    und der HTML-Koerper bis zur "<OL>"-Liste der Orte. Der restliche
    Teil (je Ort die Personenliste) gehrt zum zweiten Haeppchen. }
  { TODO: Listing fehlt noch - uebriger Teil ab 0055DECE. }
end;

procedure TForm16.Beenden1Click(Sender: TObject);
begin
  { (0055E2AC) Der Menpunkt lst den Klick auf die Abbrechen-Taste
    (SpeedButton1) aus. }
  SpeedButton1Click(nil);
end;

procedure TForm16.SpeedButton3Click(Sender: TObject);
begin
  { (0055D38C) The save button calls the same method as the menu entry. }
  Speichernunter1Click;
end;

procedure TForm16.showpagenumber;
begin
  { (0055B940) The label under the preview shows the page number and
    the total number of pages. }
  Label2.Caption := 'Seite ' + IntToStr(QRPreview1.PageNumber) + ' von ' + IntToStr(gvar_0061F0B8);
end;

procedure TForm16.Button3Click(Sender: TObject);
begin
  { (0055BC10) "Vor" - the next page is shown. }
  if QRPreview1.PageNumber < gvar_0061F0B8 then
    QRPreview1.PageNumber := QRPreview1.PageNumber + 1;
  showpagenumber;
end;

procedure TForm16.Button4Click(Sender: TObject);
begin
  { (0055BC38) "Letzte Seite" - the last page is shown. }
  QRPreview1.PageNumber := gvar_0061F0B8;
  showpagenumber;
end;

procedure TForm16.FormShow(Sender: TObject);
begin
  { (0055BA2C) Die Form skaliert sich nicht mit, die benoetigten
    Tabellen (14, 16 und 22) werden geoeffnet und die Vorschau auf
    100 % mit dem Icon "Seitenbreite" initialisiert. }
  Form16.Scaled := True;
  DataModule2.Table14.Open;
  DataModule2.Table16.Open;
  DataModule2.Table22.Open;
  QRPreview1.Zoom := 100;
  ComboBox1.ItemIndex := 0;
  SpinEdit1.Value := 91;
  ComboBox1.Text := 'Seitenbreite';
  QRPreview1.PageNumber := 1;
  showpagenumber;
  Form15.QuickRep1.Page.PaperSize := TQRPaperSize(9);
  Button5.Caption := 'A 3';
end;

procedure TForm16.showprev(APage: Integer);
begin
  { (0055B9F0) Setzt die Vorschau auf die uebergebene Seite: der
    Seitenkopf von Form15 wird auf 17 Pixel Hoehe verkleinert, die
    Seitenzuordnung wird ueber QRPreview1PageAvailable bekanntgegeben
    und die Seite in die Vorschau geladen. }
  Form15.QRBand1.Height := 17;
  QRPreview1PageAvailable(nil, APage);
  QRPreview1.PageNumber := APage;
end;

procedure TForm16.QRPreview1PageAvailable(Sender: TObject; Page: Integer);
begin
  { (0055BB34) Called by TQRPreview when the page count is known.
    The total number is remembered, the page is set to one, the label
    is updated, and the print dialog gets the range. }
  QRPreview1.PageNumber := 1;
  Label2.Caption := 'Seite ' + IntToStr(QRPreview1.PageNumber) + ' von ' + IntToStr(Page);
  gvar_0061F0B8 := Page;
  PrintDialog1.MaxPage := Page;
  PrintDialog1.ToPage  := Page;
end;

procedure TForm16.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  { (0055BB20) Escape schliesst die Vorschau. }
  if Key = VK_ESCAPE then
    Close;
end;

procedure TForm16.Drucken1Click;
begin
  { (0055BD30) Der Druckdialog wird auf den Seitenbereich der Vorschau
    eingestellt und angezeigt. Wird er besttigt, wird der Seiten-
    bereich in den Druckerbereich von Form15 uebernommen und Form15
    druckt. }
  PrintDialog1.MinPage := 1;
  PrintDialog1.FromPage := 1;
  PrintDialog1.MaxPage := gvar_0061F0B8;
  if PrintDialog1.Execute then
  begin
    { Form15.QuickRep1.PageRangeFrom := PrintDialog1.FromPage;
      Form15.QuickRep1.PageRangeTo := PrintDialog1.ToPage;
      Form15.QuickRep1.Print;
      - Das Drucken ist im Kompatibilitaetsschicht nicht implementiert. }
  end;
end;

procedure TForm16.SpeedButton2Click(Sender: TObject);
begin
  { (0055BDA8) The print button calls the same method as the menu entry. }
  Drucken1Click;
end;

procedure TForm16.ComboBox1Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm16.SpinEdit1Change(Sender: TObject);
begin
  { (0055BCE0) The zoom factor is read from the spin edit. }
  QRPreview1.Zoom := SpinEdit1.Value;
  ComboBox1.Text := '';
end;

procedure TForm16.Button2Click(Sender: TObject);
begin
  { (0055BD0C) "Zurck" - the previous page is shown. }
  if QRPreview1.PageNumber > 1 then
    QRPreview1.PageNumber := QRPreview1.PageNumber - 1;
  showpagenumber;
end;


end.
