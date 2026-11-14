unit Frm_WinesCalcMain;

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
 Grids,
 DBGrids,
 ExtCtrls,
  DBCtrls, Db, WinesDatabase
{$IFNDEF FPC}
  , Windows, DBTables
{$ELSE}
  , LCLIntf, LCLType, LMessages, sqldb, DBParadoxConnection
{$ENDIF};

type
  TMainForm = class(TForm)
    DataSource1: TDataSource;
{$IFNDEF FPC}
    Table1: TTable;
{$ELSE}
    Table1: TSQLQuery;
{$ENDIF}
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    BitBtn1: TBitBtn;
{$IFDEF FPC}
    Table1Name: TStringField;
    Table1Source: TStringField;
    Table1Vintage: TStringField;
    Table1Purchased: TDateField;
    Table1DaysOld: TIntegerField;
{$ENDIF}
{$IFNDEF FPC}
    Table1Name: TStringField;
    Table1Source: TStringField;
    Table1Vintage: TStringField;
    Table1Purchased: TDateField;
    Table1DaysOld: TIntegerField;
{$ENDIF}
{$IFDEF FPC}
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
{$ENDIF}
    procedure Table1DaysOldGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  private
{$IFDEF FPC}
    FConnection: TDBParadoxConnection;
    FTransaction: TSQLTransaction;
{$ENDIF}
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
procedure TMainForm.FormCreate(Sender: TObject);
begin
  FConnection := TDBParadoxConnection.Create(Self);
  FConnection.DatabaseName := FindWinesDataDir;
  FConnection.LoginPrompt := False;
  FTransaction := TSQLTransaction.Create(Self);
  FTransaction.Database := FConnection;
  FConnection.Transaction := FTransaction;
  Table1.Database := FConnection;
  Table1.Transaction := FTransaction;
  Table1.SQL.Text := 'SELECT * FROM Wines';
  Table1Name := TStringField.Create(Self);
  Table1Name.FieldName := 'Name';
  Table1Name.DataSet := Table1;
  Table1Source := TStringField.Create(Self);
  Table1Source.FieldName := 'Source';
  Table1Source.DataSet := Table1;
  Table1Vintage := TStringField.Create(Self);
  Table1Vintage.FieldName := 'Vintage';
  Table1Vintage.DataSet := Table1;
  Table1Purchased := TDateField.Create(Self);
  Table1Purchased.FieldName := 'Purchased';
  Table1Purchased.DataSet := Table1;
  Table1DaysOld := TIntegerField.Create(Self);
  Table1DaysOld.FieldName := 'Days Old';
  Table1DaysOld.FieldKind := fkCalculated;
  Table1DaysOld.OnGetText := Table1DaysOldGetText;
  Table1DaysOld.DataSet := Table1;
  DataSource1.DataSet := Table1;
  Table1.Open;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if Table1.Active then
    Table1.Close;
end;
{$ENDIF}

{ Calculate the Days Old virtual field using today's
  date (returned by the SysUtils Date function) and
  the value of the database table's Purchased value. }
procedure TMainForm.Table1DaysOldGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := IntToStr(Trunc(Date - Table1.FieldByName('Purchased').AsDateTime));
end;

end.
