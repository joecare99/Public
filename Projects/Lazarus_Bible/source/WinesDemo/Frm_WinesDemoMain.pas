unit Frm_WinesDemoMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, StdCtrls, Buttons, Grids, DBGrids, ExtCtrls, DBCtrls, ADODB;

type
  TMainForm = class(TForm)
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    BitBtn1: TBitBtn;
    ADOTable1: TADOTable;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FDataDir: string;
//  private
    { Private declarations }
//  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation
{$IFnDEF FPC}
  {$R *.dfm}
const DirectorySeparator='\';
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
  DataDefDir = 'Data';  { The stream's Directory }
  fileName = 'wines.udl';  { The stream's file name }

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  FDataDir:=DataDefDir;
  for i := 0 to 3 do
    if not DirectoryExists(FDataDir) then
      FDataDir:='..'+DirectorySeparator+FDataDir
    else
      break;
  ADOTable1.ConnectionString:='FILE NAME=' +FDataDir+DirectorySeparator+filename;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  ADOTable1.Open;
end;

end.
