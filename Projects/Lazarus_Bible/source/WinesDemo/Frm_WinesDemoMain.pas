unit Frm_WinesDemoMain;

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

  Db,
 StdCtrls,
 Buttons,
 Grids,
 DBGrids,
 ExtCtrls,
   DBCtrls, WinesDatabase,
{$IFNDEF FPC}
  ADODB, Windows, DBTables
{$ELSE}
  LCLIntf, LCLType, LMessages, sqldb, DBParadoxConnection
{$ENDIF};

type
  TMainForm = class(TForm)
{$IFNDEF FPC}
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    BitBtn1: TBitBtn;
    ADOTable1: TADOTable;
{$ELSE}
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    BitBtn1: TBitBtn;
{$ENDIF}
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FDataDir: string;
{$IFDEF FPC}
    FConnection: TDBParadoxConnection;
    FTransaction: TSQLTransaction;
    FQuery: TSQLQuery;
    FDataSource: TDataSource;
{$ENDIF}
  end;

var
  MainForm: TMainForm;

implementation
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
  FQuery := TSQLQuery.Create(Self);
  FQuery.Database := FConnection;
  FQuery.Transaction := FTransaction;
  FQuery.SQL.Text := 'SELECT * FROM Wines';
  FDataSource := TDataSource.Create(Self);
  FDataSource.DataSet := FQuery;
  DBNavigator1 := TDBNavigator.Create(Self);
  DBNavigator1.Parent := Self;
  DBNavigator1.SetBounds(32, 24, 240, 25);
  DBNavigator1.DataSource := FDataSource;
  DBGrid1 := TDBGrid.Create(Self);
  DBGrid1.Parent := Self;
  DBGrid1.SetBounds(8, 64, 609, 153);
  DBGrid1.DataSource := FDataSource;
  BitBtn1 := TBitBtn.Create(Self);
  BitBtn1.Parent := Self;
  BitBtn1.SetBounds(544, 232, 75, 25);
  BitBtn1.Kind := bkClose;
  BitBtn1.NumGlyphs := 2;
  FQuery.Open;
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

procedure TMainForm.FormShow(Sender: TObject);
begin
{$IFNDEF FPC}
  if not ADOTable1.Active then
    ADOTable1.Open;
{$ENDIF}
end;

end.
