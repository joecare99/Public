unit Frm_Fishy2MAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  DBTables, ADODB, Windows,
{$ELSE}
 LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Dialogs, Forms, DBCtrls, DB, sqldb, DBGrids,
   Buttons, ExtCtrls;

type
  TMainForm = class(TForm)
    ScrollBox: TScrollBox;
    DBNavigator: TDBNavigator;
    Panel1: TPanel;
    DataSource1: TDataSource;
    Panel2: TPanel;
    DBImage1: TDBImage;
    DBGrid1: TDBGrid;
    BitBtn1: TBitBtn;
    ADOTable1: TSQLQuery;
    procedure FormCreate(Sender: TObject);
    procedure DBImage1DblClick(Sender: TObject);
  private
    { private declarations }
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

{- Open the Table1 dataset }
procedure TMainForm.FormCreate(Sender: TObject);
begin
  ADOTable1.Open;
end;

{- Respond to double click in Blob image }
procedure TMainForm.DBImage1DblClick(Sender: TObject);
begin
  with DBImage1.Picture do
  ShowMessage('W=' + IntToStr(Width) +
    ' H=' + IntToStr(Height));
end;

end.
