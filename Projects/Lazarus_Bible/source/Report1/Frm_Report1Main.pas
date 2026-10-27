unit Frm_Report1Main;

{ Report1, plattformneutral: Statt QuickReport (Windows/Delphi) wird der
  Bericht direkt auf eine Canvas gezeichnet - fuer die Vorschau auf ein
  Bitmap, fuer den Druck auf die Drucker-Leinwand. Datenquelle ist die
  Paradox-Tabelle Wines (DBParadox). }

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  DBTables, Windows,
{$ELSE}
  sqldb, DBParadoxConnection, Printers, LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Db, StdCtrls, Buttons;

type
  TMainForm = class(TForm)
    Table1: TSQLQuery;
    DataSource1: TDataSource;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
{$IFDEF FPC}
    FConnection: TDBParadoxConnection;
    FTransaction: TSQLTransaction;
    function FindDataDir: string;
    procedure OpenWines;
    { Zeichnet den Bericht auf die uebergebene Leinwand. }
    procedure DrawReport(ACanvas: TCanvas; APageWidth, APageHeight: Integer);
    procedure PreviewReport;
{$ENDIF}
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{$IFDEF FPC}
{ Sucht den Datenordner Data/Wines, ausgehend vom Programmverzeichnis. }
function TMainForm.FindDataDir: string;
var
  Dir: string;
  I: Integer;
begin
  Dir := 'Data' + PathDelim + 'Wines';
  for I := 0 to 5 do
    if DirectoryExists(Dir) then
      Exit(Dir)
    else
      Dir := '..' + PathDelim + Dir;
  Result := 'Data' + PathDelim + 'Wines';
end;

procedure TMainForm.OpenWines;
begin
  FConnection := TDBParadoxConnection.Create(Self);
  FConnection.DatabaseName := FindDataDir;
  FConnection.LoginPrompt := False;
  FTransaction := TSQLTransaction.Create(Self);
  FTransaction.Database := FConnection;
  FConnection.Transaction := FTransaction;
  Table1.Database := FConnection;
  Table1.Transaction := FTransaction;
  Table1.SQL.Text := 'SELECT * FROM Wines';
  try
    Table1.Open;
  except
    on E: Exception do
      ShowMessage('Konnte Wines.DB nicht oeffnen: ' + E.Message);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  OpenWines;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if Table1.Active then
    Table1.Close;
end;

{ Zeichnet Titel, Spaltenkoepfe, die Datensaetze und eine Summenzeile. }
procedure TMainForm.DrawReport(ACanvas: TCanvas;
  APageWidth, APageHeight: Integer);
const
  Cols: array[0..4] of string =
    ('Name', 'Number', 'Source', 'Vintage', 'Purchased');
  ColX: array[0..4] of Integer = (60, 320, 420, 640, 720);
var
  Y, LineH, I, Count, Total: Integer;
begin
  with ACanvas do
  begin
    Font.Name := 'Sans';
    Font.Size := 16;
    Font.Style := [fsBold];
    TextOut(60, 40, 'Weinliste');

    Font.Size := 10;
    Font.Style := [];
    TextOut(60, 64, 'Datum: ' + DateToStr(Date));

    LineH := TextHeight('X') + 6;
    Y := 100;
    Font.Style := [fsBold];
    for I := Low(Cols) to High(Cols) do
      TextOut(ColX[I], Y, Cols[I]);
    Inc(Y, LineH);
    Font.Style := [];

    Count := 0;
    Total := 0;
    if Table1.Active then
    begin
      Table1.First;
      while not Table1.EOF do
      begin
        TextOut(ColX[0], Y, Table1.FieldByName('Name').AsString);
        TextOut(ColX[1], Y, Table1.FieldByName('Number').AsString);
        TextOut(ColX[2], Y, Table1.FieldByName('Source').AsString);
        TextOut(ColX[3], Y, Table1.FieldByName('Vintage').AsString);
        TextOut(ColX[4], Y, Table1.FieldByName('Purchased').AsString);
        Inc(Total, Table1.FieldByName('Number').AsInteger);
        Inc(Count);
        Inc(Y, LineH);
        Table1.Next;
      end;
    end;

    Inc(Y, LineH div 2);
    Font.Style := [fsBold];
    TextOut(60, Y, Format('Summe Anzahl: %d    Datensaetze: %d', [Total, Count]));
  end;
end;

procedure TMainForm.BitBtn1Click(Sender: TObject);
begin
  PreviewReport;
end;

procedure TMainForm.PreviewReport;
var
  Bmp: TBitmap;
  PreviewForm: TForm;
  Image: TImage;
begin
  Bmp := TBitmap.Create;
  try
    Bmp.Width := 794;   { A4 bei 96 dpi }
    Bmp.Height := 1123;
    Bmp.Canvas.Brush.Color := clWhite;
    Bmp.Canvas.FillRect(0, 0, Bmp.Width, Bmp.Height);
    DrawReport(Bmp.Canvas, Bmp.Width, Bmp.Height);

    PreviewForm := TForm.CreateNew(Self);
    try
      PreviewForm.Caption := 'Berichtsvorschau';
      PreviewForm.Width := 820;
      PreviewForm.Height := 1000;
      PreviewForm.Position := poScreenCenter;
      Image := TImage.Create(PreviewForm);
      Image.Parent := PreviewForm;
      Image.Align := alClient;
      Image.Stretch := True;
      Image.Picture.Bitmap.Assign(Bmp);
      PreviewForm.ShowModal;
    finally
      PreviewForm.Free;
    end;
  finally
    Bmp.Free;
  end;
end;

procedure TMainForm.BitBtn2Click(Sender: TObject);
begin
  { Ohne Drucker (z. B. WSL) sauber abfangen. }
  try
    Printer.BeginDoc;
    try
      DrawReport(Printer.Canvas, Printer.PageWidth, Printer.PageHeight);
    finally
      Printer.EndDoc;
    end;
  except
    on E: Exception do
      ShowMessage('Drucken nicht moeglich: ' + E.Message);
  end;
end;
{$ELSE}
procedure TMainForm.FormCreate(Sender: TObject);
begin
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
end;

{ Respond to click of the Preview... button }
procedure TMainForm.BitBtn1Click(Sender: TObject);
begin
  ShowMessage('Report1 benoetigt QuickReport (nur Delphi/Windows).');
end;

{ Respond to click of the Print button }
procedure TMainForm.BitBtn2Click(Sender: TObject);
begin
  ShowMessage('Report1 benoetigt QuickReport (nur Delphi/Windows).');
end;
{$ENDIF}

end.
