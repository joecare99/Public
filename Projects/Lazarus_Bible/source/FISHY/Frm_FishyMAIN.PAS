unit Frm_FishyMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  {$IF CompilerVersion < 23.0}
  Windows, DBTables, Graphics, Controls, Dialogs, Forms, DBCtrls, DB,
    DBGrids, Buttons, ExtCtrls,
  {$ELSE}
  Winapi.Windows, Bde.DBTables, Data.DB, Vcl.Graphics, Vcl.Controls,
    Vcl.Dialogs, Vcl.Forms, Vcl.DBCtrls, Vcl.DBGrids, Vcl.Buttons,
    Vcl.ExtCtrls,
  {$IFEND}
{$ELSE}
  LCLIntf, LCLType, sqldb, Graphics, Controls, Dialogs, Forms, DBCtrls,
  DB, DBGrids, Buttons, ExtCtrls,
{$ENDIF}
  SysUtils, Classes
{$IFDEF FPC}
  , SQLite3Conn
{$ENDIF};

type
  TMainForm = class(TForm)
    ScrollBox: TScrollBox;
    DBNavigator: TDBNavigator;
    Panel1: TPanel;
    DataSource1: TDataSource;
    Panel2: TPanel;
{$IFDEF FPC}
    Table1: TSQLQuery;
{$ELSE}
    Table1: TTable;
{$ENDIF}
    DBImage1: TDBImage;
    DBGrid1: TDBGrid;
    Table1NAME: TStringField;
    Table1AREA: TStringField;
    Table1BMP: TBlobField;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure DBImage1DblClick(Sender: TObject);
  private
{$IFDEF FPC}
    FConnection: TSQLite3Connection;
    FTransaction: TSQLTransaction;
    function FindDatabaseFile: string;
{$ENDIF}
  public
    { public declarations }
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
function TMainForm.FindDatabaseFile: string;
var
  Dir: string;
  I: Integer;
begin
  Dir := ExtractFilePath(ParamStr(0));
  for I := 0 to 6 do
  begin
    Result := IncludeTrailingPathDelimiter(Dir) + 'Data' + PathDelim +
      'animals.sqlite';
    if FileExists(Result) then
      Exit;
    Dir := ExtractFileDir(ExcludeTrailingPathDelimiter(Dir));
  end;
  raise Exception.Create('Data' + PathDelim + 'animals.sqlite not found');
end;
{$ENDIF}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  {$IFDEF FPC}
  FConnection := TSQLite3Connection.Create(Self);
  FConnection.DatabaseName := FindDatabaseFile;
  FConnection.LoginPrompt := False;
  FTransaction := TSQLTransaction.Create(Self);
  FTransaction.Database := FConnection;
  FConnection.Transaction := FTransaction;
  Table1.Database := FConnection;
  Table1.Transaction := FTransaction;
  Table1.SQL.Text := 'SELECT name AS NAME, size AS SIZE, weight AS WEIGHT, ' +
    'area AS AREA, bmp AS BMP FROM animals ORDER BY id';
  {$ENDIF}
  Table1.Open;
end;

{- Respond to double click in Blob image }
procedure TMainForm.DBImage1DblClick(Sender: TObject);
begin
  with DBImage1.Picture do
  ShowMessage('W=' + IntToStr(Width) +
    ' H=' + IntToStr(Height));
end;

end.
