unit frm_Siblings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Menus,
  ComCtrls, ActnList;

type

  { TfrmSiblings }

  TfrmSiblings = class(TForm)
    alsSiblings: TActionList;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    mnuSiblings: TPopupMenu;
    tblSiblings: TStringGrid;
    tlbSiblings: TToolBar;
    procedure FormClose(Sender: TObject; var {%H-}CloseAction: TCloseAction);
    procedure tblSiblingsResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure PopulateFratrie(Sender:Tobject);
  end;


var
  frmSiblings: TfrmSiblings;

implementation

uses
  frm_Main,cls_Translation, dm_GenData, FMUtils;

{$R *.lfm}

{ TfrmSiblings }

procedure TfrmSiblings.PopulateFratrie(Sender: Tobject);

begin
// Cherche les parents principaux P1 et P2
  dmGenData.FillSiblingsTable(tblSiblings, frmStemmaMainForm.iID);
  Caption:=Translation.Items[116]+' ('+IntToStr(tblSiblings.RowCount-1)+')';
end;

procedure TfrmSiblings.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  dmGenData.WriteCfgFormPosition(Self);
  dmGenData.WriteCfgGridPosition(tblSiblings as TStringGrid,4);
end;

procedure TfrmSiblings.tblSiblingsResize(Sender: TObject);
begin
  tblSiblings.Columns[0].Width := tblSiblings.Width-GetTableColWidthSum(tblSiblings,0);
end;

procedure TfrmSiblings.FormShow(Sender: TObject);
begin
  Caption:=Translation.Items[116];
  tblSiblings.Cells[1,0]:=Translation.Items[205];
  tblSiblings.Cells[2,0]:='#';
  tblSiblings.Cells[3,0]:=Translation.Items[177];
  MenuItem1.Caption:=Translation.Items[222];
  MenuItem3.Caption:=Translation.Items[224];
  dmGenData.ReadCfgFormPosition(Sender as TForm,0,0,70,1000);
  dmGenData.ReadCfgGridPosition(tblSiblings as TStringGrid,4);
  frmSiblings.PopulateFratrie(Sender);
end;

procedure TfrmSiblings.MenuItem1Click(Sender: TObject);
begin
   if tblSiblings.Row>0 then
      frmStemmaMainForm.iID:=Ptrint(tblSiblings.objects[2,tblSiblings.Row]);
end;

end.
