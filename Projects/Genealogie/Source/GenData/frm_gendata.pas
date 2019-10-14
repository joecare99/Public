unit frm_GenData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DbCtrls, DBGrids, dm_GenData2;

type

  { TfrmGenData }

  TfrmGenData = class(TForm)
    cbxMandant: TComboBox;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    lblMandant: TLabel;
    procedure cbxMandantGetItems(Sender: TObject);
    procedure cbxMandantSelect(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmGenData: TfrmGenData;

implementation

{$R *.lfm}

{ TfrmGenData }

procedure TfrmGenData.cbxMandantGetItems(Sender: TObject);
begin
  if not dmGenData.DB_Connected then
    dmGenData.DB_Connected:=true;
  cbxMandant.Items.Clear;
  cbxMandant.Items.AddStrings(dmGenData.ListDBs);
end;

procedure TfrmGenData.cbxMandantSelect(Sender: TObject);
begin
   dmGenData.SQLDatabaseName := cbxMandant.Text;
end;

end.

