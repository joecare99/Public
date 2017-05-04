unit Frm_FishyMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  DBTables, Windows,
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
    Table1: TSQLQuery;
    DBImage1: TDBImage;
    DBGrid1: TDBGrid;
    Table1NAME: TStringField;
    Table1AREA: TStringField;
    Table1BMP: TBlobField;
    BitBtn1: TBitBtn;
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
