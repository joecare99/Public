unit Frm_WinesEntryMain;

{ WinesEntry, plattformneutral: Statt BDE/ADO (Windows) liest das Demo die
  Paradox-Tabelle Wines.DB ueber die BDE-freie DBParadox-Engine
  (TDBParadoxConnection, eine SQLDB-Verbindung). }

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, DBCtrls, ExtCtrls, Db
{$IFnDEF FPC}
  , Windows, ADODB
{$ELSE}
  , DBParadoxConnection, sqldb
{$ENDIF}
  ;

type

  { TMainForm }

  TMainForm = class(TForm)
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    edtName: TDBEdit;
    lblName: TLabel;
    lblNumber: TLabel;
    lblSource: TLabel;
    lblVintage: TLabel;
    lblPurchased: TLabel;
    edtNumber: TDBEdit;
    edtSource: TDBEdit;
    edtVintage: TDBEdit;
    edtPurchased: TDBEdit;
    btnClose: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FDataDir: string;
{$IFDEF FPC}
    FConnection: TDBParadoxConnection;
    FTransaction: TSQLTransaction;
    FQuery: TSQLQuery;
{$ELSE}
    FADOTable: TADOTable;
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

const
  DataDefDir = 'Data';  { The stream's Directory }
  fileName = 'wines.udl';  { The stream's file name }

{ Sucht den Datenordner Data/Wines, ausgehend vom Programmverzeichnis. }
function FindDataDir: string;
var
  Dir: string;
  I: Integer;
begin
  Dir := DataDefDir + PathDelim + 'Wines';
  for I := 0 to 5 do
    if DirectoryExists(Dir) then
      Exit(Dir)
    else
      Dir := '..' + PathDelim + Dir;
  Result := DataDefDir + PathDelim + 'Wines';
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FDataDir := FindDataDir;
  {$IFDEF FPC}
  { BDE-freie Paradox-Engine: DatabaseName ist der Ordner mit den .DB-Dateien. }
  FConnection := TDBParadoxConnection.Create(Self);
  FConnection.DatabaseName := FDataDir;
  FConnection.LoginPrompt := False;
  FTransaction := TSQLTransaction.Create(Self);
  FTransaction.Database := FConnection;
  FConnection.Transaction := FTransaction;
  FQuery := TSQLQuery.Create(Self);
  FQuery.Database := FConnection;
  FQuery.Transaction := FTransaction;
  FQuery.SQL.Text := 'SELECT * FROM Wines';
  DataSource1.DataSet := FQuery;
  {$ELSE}
  FADOTable := TADOTable.Create(Self);
  FADOTable.ConnectionString := 'FILE NAME=' + FDataDir + PathDelim + fileName;
  DataSource1.DataSet := FADOTable;
  {$ENDIF}
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  {$IFDEF FPC}
  try
    FQuery.Open;
  except
    on E: Exception do
      ShowMessage('Konnte Wines.DB nicht oeffnen (' + FDataDir + '): ' + E.Message);
  end;
  {$ELSE}
  FADOTable.Open;
  {$ENDIF}
end;

end.
