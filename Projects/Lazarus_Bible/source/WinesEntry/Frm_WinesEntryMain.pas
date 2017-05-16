unit Frm_WinesEntryMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask, DBCtrls, ExtCtrls, Db, ADODB;

type
  TMainForm = class(TForm)
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    DBEdit1: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
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
