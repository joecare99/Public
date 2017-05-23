unit frm_Ancestors;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, FMUtils, LCLType, ActnList, Types;

type

  { TfrmAncestors }

  TfrmAncestors = class(TForm)
    actAncestorsExpand: TAction;
    actAncestorsGoTo: TAction;
    alsAncestors: TActionList;
    mniAncestorsSep: TMenuItem;
    mniAncestorsExpand: TMenuItem;
    trvAncestors: TTreeView;
    mniAncestorsGoto: TMenuItem;
    mnuAncestors: TPopupMenu;
    procedure actAncestorsExpandExecute(Sender: TObject);
    procedure actAncestorsExpandUpdate(Sender: TObject);
    procedure actAncestorsGoToUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actAncestorsGoToExecute(Sender: TObject);
    procedure trvAncestorsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private
    { private declarations }
  public
    procedure PopulateAncetres(Sender: TObject);
    { public declarations }
  end; 


var
  frmAncestors: TfrmAncestors;

implementation

uses
  frm_Main, cls_Translation, dm_GenData;

{$R *.lfm}

{ TfrmAncestors }

procedure TfrmAncestors.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  if CloseAction <> caMinimize then
    dmGenData.WriteCfgFormPosition(self);
end;

procedure TfrmAncestors.actAncestorsExpandExecute(Sender: TObject);
var
  lTreeView: TTreeView;
begin
  lTreeView:=trvAncestors;
  dmGenData.AppendRelationTreeVParents(lTreeView);
end;

procedure TfrmAncestors.actAncestorsExpandUpdate(Sender: TObject);
begin
  actAncestorsExpand.Checked := trvAncestors.Selected.HasChildren;
  actAncestorsExpand.Enabled:=not actAncestorsExpand.Checked;
end;

procedure TfrmAncestors.actAncestorsGoToUpdate(Sender: TObject);
begin
  actAncestorsGoTo.Checked := ptrint(Tobject(trvAncestors.Selected.Data)) = frmStemmaMainForm.iID;
  actAncestorsGoTo.Enabled:=not actAncestorsGoTo.Checked;
end;

procedure TfrmAncestors.FormResize(Sender: TObject);
begin
  trvAncestors.Width:=frmAncestors.Width;
  trvAncestors.Height:=frmAncestors.Height;
end;

procedure TfrmAncestors.FormShow(Sender: TObject);
begin
  Caption:=Translation.Items[146];
  mniAncestorsGoto.Caption:=Translation.Items[222];
  dmGenData.ReadCfgFormPosition(Sender as TForm,0,0,200,200);
  PopulateAncetres(Sender);
end;

procedure TfrmAncestors.actAncestorsGoToExecute(Sender: TObject);
begin
  frmStemmaMainForm.iID:=ptrint(Tobject(trvAncestors.Selected.Data));
end;

procedure TfrmAncestors.trvAncestorsContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  Tn: TTreeNode;
begin
  Tn:=trvAncestors.GetNodeAt(MousePos.x,MousePos.y);
  if assigned(tn) then trvAncestors.Selected:=tn;
  handled:=false;
end;

procedure TfrmAncestors.PopulateAncetres(Sender: TObject);
var
  LidInd: LongInt;
begin
   trvAncestors.Items.Clear;
   LidInd:=frmStemmaMainForm.iID;
   trvAncestors.Items.AddChildObjectFirst(
     nil,
     format('%s [%d]',[decodeName(dmGenData.GetIndividuumName(LidInd),1),LidInd]),
     pointer(Tobject(ptrint(LidInd))));
   trvAncestors.Selected:= trvAncestors.Items[0];
   actAncestorsExpandExecute(sender);
end;

end.

