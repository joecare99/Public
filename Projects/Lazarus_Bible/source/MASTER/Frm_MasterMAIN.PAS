unit Frm_MasterMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Mask, DBTables, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, sqldb, DBGrids,
  ExtCtrls, Buttons;

type
  TMainForm = class(TForm)
    ScrollBox: TScrollBox;
    Label1: TLabel;
    EditCUR_PRICE: TDBEdit;
    Label2: TLabel;
    EditEXCHANGE: TDBEdit;
    Label3: TLabel;
    EditCO_NAME: TDBEdit;
    Label4: TLabel;
    EditSYMBOL: TDBEdit;
    Label5: TLabel;
    EditP_E_RATIO: TDBEdit;
    Label6: TLabel;
    EditYRL_LOW: TDBEdit;
    Label7: TLabel;
    EditYRL_HIGH: TDBEdit;
    DBNavigator: TDBNavigator;
    Panel1: TPanel;
    MasterSource: TDataSource;
    Panel2: TPanel;
    MasterTable: TSQLQuery;
    DetailTable: TSQLQuery;
    DetailSource: TDataSource;
    DBGrid1: TDBGrid;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
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

procedure TMainForm.FormCreate(Sender: TObject);
begin
  MasterTable.Open;
  DetailTable.Open;
end;

end.
