unit Frm_WinesEntryMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, DBCtrls, ExtCtrls, Db, dbf {$IFDEF FPC}  {$ELSE} ,ADODB {$ENDIF};

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
//    ADOTable1: TADOTable;
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
  {$IFDEF FPC}
//  ADOTable1.ConnectionString:='FILE NAME=' +FDataDir+DirectorySeparator+filename;
  {$ELSE}
  ADOTable1.ConnectionString:='FILE NAME=' +FDataDir+DirectorySeparator+filename;
  {$ENDIF}
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  {$IFDEF FPC}
//  ADOTable1.Open;
  {$ELSE}
  ADOTable1.Open;
  {$ENDIF}
end;

end.
