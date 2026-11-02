unit Frm_WinesChartMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
interface


uses
 Messages,
 SysUtils,
 Classes,
 Graphics,
 Controls,
 Forms,
 Dialogs,

  StdCtrls,
 Buttons,
   ExtCtrls, Db, WinesDatabase
{$IFNDEF FPC}
  , ADODB, Windows, TeEngine, Series, TeeProcs, Chart, DBChart
{$ELSE}
  , LCLIntf, LCLType, LMessages, sqldb, DBParadoxConnection,
    TAGraph, TASeries, TATools
{$ENDIF};

type
  TMainForm = class(TForm)
    DataSource1: TDataSource;
{$IFNDEF FPC}
    DBChart1: TDBChart;
    Series1: TLineSeries;
{$ELSE}
    DBChart1: TChart;
    Series1: TLineSeries;
    Series2: TLineSeries;
{$ENDIF}
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
{$IFNDEF FPC}
    ADOTable1: TADOTable;
{$ELSE}
    ADOTable1: TSQLQuery;
{$ENDIF}
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FDataDir: string;
{$IFDEF FPC}
    FConnection: TDBParadoxConnection;
    FTransaction: TSQLTransaction;
{$ENDIF}
  end;

var
  MainForm: TMainForm;

implementation

{$IFNDEF FPC}
uses
  TeePrevi;
{$ENDIF}

{$IFNDEF FPC}
  {$R *.dfm}
const DirectorySeparator='\';
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
  DataDefDir = 'Data';
  fileName = 'wines.udl';

procedure TMainForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
{$IFDEF FPC}
  FDataDir := FindWinesDataDir;
  FConnection := TDBParadoxConnection.Create(Self);
  FConnection.DatabaseName := FDataDir;
  FConnection.LoginPrompt := False;
  FTransaction := TSQLTransaction.Create(Self);
  FTransaction.Database := FConnection;
  FConnection.Transaction := FTransaction;
  DataSource1 := TDataSource.Create(Self);
  ADOTable1 := TSQLQuery.Create(Self);
  ADOTable1.Database := FConnection;
  ADOTable1.Transaction := FTransaction;
  ADOTable1.SQL.Text := 'SELECT * FROM Wines';
  DataSource1.DataSet := ADOTable1;
  DBChart1 := TChart.Create(Self);
  DBChart1.Parent := Self;
  DBChart1.SetBounds(16, 16, 513, 233);
  DBChart1.Title.Text.Add('Wine purchases over time');
  DBChart1.BottomAxis.Title.Caption := 'Purchase date';
  DBChart1.BottomAxis.Title.Visible := True;
  DBChart1.LeftAxis.Title.Caption := 'Bottles';
  DBChart1.LeftAxis.Title.Visible := True;
  Series1 := TLineSeries.Create(DBChart1);
  Series1.Title := 'Bottles per purchase';
  Series1.ShowPoints := True;
  DBChart1.AddSeries(Series1);
  Series2 := TLineSeries.Create(DBChart1);
  Series2.Title := 'Total bottles';
  Series2.ShowPoints := True;
  DBChart1.AddSeries(Series2);
  BitBtn1 := TBitBtn.Create(Self);
  BitBtn1.Parent := Self;
  BitBtn1.SetBounds(432, 272, 75, 25);
  BitBtn1.Kind := bkClose;
  BitBtn2 := TBitBtn.Create(Self);
  BitBtn2.Parent := Self;
  BitBtn2.SetBounds(296, 272, 107, 25);
  BitBtn2.Caption := 'Print Preview...';
  BitBtn2.OnClick := BitBtn2Click;
{$ELSE}
  FDataDir := DataDefDir;
  for I := 0 to 3 do
    if not DirectoryExists(FDataDir) then
      FDataDir := '..' + DirectorySeparator + FDataDir
    else
      Break;
  ADOTable1.ConnectionString := 'FILE NAME=' + FDataDir + DirectorySeparator + fileName;
{$ENDIF}
end;



procedure TMainForm.BitBtn2Click(Sender: TObject);
begin
{$IFDEF FPC}
  ShowMessage('Die Vorschau verwendet die TeeChart-Komponente und ist nur in der Delphi-Version verfuegbar.');
{$ELSE}
  {$ifdef compiler12_up}
  TeePreview
  {$else}
  ChartPreview
  {$endif}
  (MainForm, DBChart1);
{$ENDIF}
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  NameField: TField;
  NumberField: TField;
  PurchasedField: TField;
  RunningTotal: Double;
begin
  {$IFDEF FPC}
  if not ADOTable1.Active then
    ADOTable1.Open;
  DBChart1.Title.Text.Clear;
  DBChart1.Title.Text.Add('Wine purchases over time');
  NameField := ADOTable1.FieldByName('Name');
  NumberField := ADOTable1.FieldByName('Number');
  PurchasedField := ADOTable1.FieldByName('Purchased');
  Series1.Clear;
  Series2.Clear;
  RunningTotal := 0;
  ADOTable1.First;
  while not ADOTable1.EOF do
  begin
    Series1.AddXY(PurchasedField.AsDateTime, NumberField.AsFloat,
      NameField.AsString);
    RunningTotal := RunningTotal + NumberField.AsFloat;
    Series2.AddXY(PurchasedField.AsDateTime, RunningTotal,
      NameField.AsString);
    ADOTable1.Next;
  end;
  DBChart1.Invalidate;
{$ELSE}
  ADOTable1.Open;
{$ENDIF}
end;

end.
