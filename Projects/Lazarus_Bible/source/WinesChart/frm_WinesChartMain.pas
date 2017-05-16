unit Frm_WinesChartMain;

interface

{$I jedi.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, TeEngine, Series, ExtCtrls, TeeProcs, Chart, DBChart,
  Db,  ADODB;

type
  TMainForm = class(TForm)
    DataSource1: TDataSource;
    DBChart1: TDBChart;
    Series1: THorizBarSeries;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ADOTable1: TADOTable;
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
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

uses
  TeePrevi;

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



procedure TMainForm.BitBtn2Click(Sender: TObject);
begin
  {$ifdef compiler12_up}
  TeePreview
  {$else}
  ChartPreview
  {$endif}
  (MainForm, DBChart1);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  adotable1.Open;
end;

end.
