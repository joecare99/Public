unit frm_Descendants;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ActnList, FMUtils;

type

  { TfrmDescendants }

  TfrmDescendants = class(TForm)
    actDescendantsExpand: TAction;
    actDescendantsGoto: TAction;
    alsDescendants: TActionList;
    trvDescendants: TTreeView;
    mniDescendantsGoto: TMenuItem;
    mnuDescendants: TPopupMenu;
    procedure actDescendantsExpandUpdate(Sender: TObject);
    procedure actDescendantsGotoUpdate(Sender: TObject);
    procedure actDescendantsExpandExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actDescendantsGotoExecute(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure PopulateDescendants(Sender: TObject);
  end;

var
  frmDescendants: TfrmDescendants;

implementation

uses
  frm_Main, cls_Translation, dm_GenData;

{$R *.lfm}

{ TfrmDescendants }

procedure TfrmDescendants.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if CloseAction <> caMinimize then
     begin
  dmGenData.WriteCfgFormPosition(self);
     end;
end;

procedure TfrmDescendants.actDescendantsExpandExecute(Sender: TObject);
var
  lTreeView: TTreeView;
begin
  lTreeView:=trvDescendants;
  dmGenData.AppendRelationTreeVChildren(lTreeView);
end;

procedure TfrmDescendants.actDescendantsGotoUpdate(Sender: TObject);
begin
    actDescendantsGoto.Checked := ptrint(Tobject(trvDescendants.Selected.Data)) = frmStemmaMainForm.iID;
  actDescendantsGoto.Enabled:=not actDescendantsGoto.Checked;

end;

procedure TfrmDescendants.actDescendantsExpandUpdate(Sender: TObject);
begin
   actDescendantsExpand.Checked := trvDescendants.Selected.HasChildren;
  actDescendantsExpand.Enabled:=not actDescendantsExpand.Checked;
end;

procedure TfrmDescendants.FormResize(Sender: TObject);
begin
  trvDescendants.Width:=frmDescendants.Width;
  trvDescendants.Height:=frmDescendants.Height;
end;

procedure TfrmDescendants.FormShow(Sender: TObject);
begin
  Caption:=Translation.Items[159];
  mniDescendantsGoto.Caption:=Translation.Items[222];
  dmGenData.ReadCfgFormPosition(Sender as TForm,0,0,200,200);
  PopulateDescendants(Sender);
end;

procedure TfrmDescendants.actDescendantsGotoExecute(Sender: TObject);
begin
  frmStemmaMainForm.iID:=ptrint(Tobject(trvDescendants.Selected.Data));
end;

procedure TfrmDescendants.PopulateDescendants(Sender: TObject);
var
  lidInd: LongInt;
begin
  lidInd:=frmStemmaMainForm.iID;
   trvDescendants.Items.Clear;
   trvDescendants.Items.AddFirst(
    nil,
    format('%s [%d]',[DecodeName(dmGenData.GetIndividuumName(lidInd),1),lidInd]));
  dmGenData.Query1.SQL.Clear;
   trvDescendants.Selected:= trvDescendants.Items[0];
   actDescendantsExpandExecute(Sender);
end;


end.

