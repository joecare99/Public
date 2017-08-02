unit frm_Parents;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Menus,
  frm_EditParents, LCLType, ComCtrls, ActnList;

type

  { TfrmParents }

  TfrmParents = class(TForm)
    actParentCopy: TAction;
    actParentSetPrefered: TAction;
    actParentGoto: TAction;
    ActionList1: TActionList;
    mniParentGoto: TMenuItem;
    mniParentSetPrefered: TMenuItem;
    mndDiv1: TMenuItem;
    mndDiv2: TMenuItem;
    mniAdd: TMenuItem;
    mniEdit: TMenuItem;
    mniDelete: TMenuItem;
    PopupMenuParent: TPopupMenu;
    tblParents: TStringGrid;
    tlbParents: TToolBar;
    btnParentGoto: TToolButton;
    ToolButton1: TToolButton;
    btnParentSetPrefered: TToolButton;
    procedure FormClose(Sender: TObject; var {%H-}CloseAction: TCloseAction);
    procedure tblParentsResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actParentGotoExecute(Sender: TObject);
    procedure actParentSetPreferedExecute(Sender: TObject);
    procedure mniAddClick(Sender: TObject);
    procedure mniDeleteClick(Sender: TObject);
    procedure CopyParent(Sender: TObject);
    procedure tblParentsDblClick(Sender: TObject);
    procedure tblParentsDrawCell(Sender: TObject; aCol, aRow: integer;
      aRect: TRect; {%H-}aState: TGridDrawState);
  private
    function GetIdRelation: integer;
    { private declarations }
  public
    { public declarations }
    property idRelation: integer read GetIdRelation;
  end;

var
  frmParents: TfrmParents;

implementation

uses
  frm_Main, cls_Translation, dm_GenData;

{$R *.lfm}

{ TfrmParents }

procedure TfrmParents.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  dmGenData.WriteCfgFormPosition(self);
  dmGenData.WriteCfgGridPosition(tblParents as TStringGrid, 4);
end;

procedure TfrmParents.tblParentsResize(Sender: TObject);
begin
  tblParents.Columns[2].Width := tblParents.Width - 131;
end;

procedure TfrmParents.FormShow(Sender: TObject);
begin
  Caption := rsParents;
  tblParents.Cells[2, 0] := Translation.Items[185];
  tblParents.Cells[3, 0] := Translation.Items[216];
  tblParents.Cells[4, 0] := Translation.Items[177];
  dmGenData.ReadCfgFormPosition(Sender as TForm, 0, 0, 70, 1000);
  dmGenData.ReadCfgGridPosition(tblParents as TStringGrid, 4);
  dmGenData.PopulateParents(tblParents, frmStemmaMainForm.iID);
end;

procedure TfrmParents.actParentGotoExecute(Sender: TObject);
begin
  if tblParents.Row > 0 then
    frmStemmaMainForm.iID := Ptrint(tblParents.Objects[5, tblParents.Row]);
end;

procedure TfrmParents.actParentSetPreferedExecute(Sender: TObject);
var
  lidRelation: integer;
  lidIndRel: integer;
  lidInd: integer;
begin
  lidRelation := idRelation;
  lidIndRel := Ptrint(tblParents.objects[5, tblParents.row]);
  lidInd := frmStemmaMainForm.iID;
  if tblParents.Cells[1, tblParents.row] = '*' then
  begin
    dmGenData.ResetRelationPrefered(lidInd, lidIndRel, lidRelation);
    dmGenData.PopulateParents(tblParents, frmStemmaMainForm.iID);
  end
  else
  begin
    dmGenData.SetRelationPrefered(lidInd, lidIndRel, lidRelation);
    dmGenData.PopulateParents(tblParents, frmStemmaMainForm.iID);
  end;
end;

procedure TfrmParents.mniAddClick(Sender: TObject);
begin
  // Ajouter un parent
  //dmGenData.PutCode('P',0);
  //dmGenData.PutCode('A',0);
  frmEditParents.EditMode := eERT_appendParent;
  ;
  if frmEditParents.Showmodal = mrOk then
  begin
    dmGenData.PopulateParents(tblParents, frmStemmaMainForm.iID);
  end;
end;

procedure TfrmParents.mniDeleteClick(Sender: TObject);
begin
  // Supprimer un parent
  if tblParents.Row > 0 then
    if Application.MessageBox(PChar(Translation.Items[131] +
      tblParents.Cells[3, tblParents.Row] + Translation.Items[28]),
      PChar(SConfirmation), MB_YESNO) = idYes then
    begin
      dmGenData.DeleteRelationFull(frmStemmaMainForm.iID, ptrint(
        tblParents.objects[5, tblParents.Row]), ptrint(tblParents.Objects[0, tblParents.Row]));
      tblParents.DeleteRow(tblParents.Row);
    end;
end;

procedure TfrmParents.tblParentsDblClick(Sender: TObject);
begin
  if tblParents.Row > 0 then
  begin
    //dmGenData.PutCode('P',0);
    frmEditParents.EditMode := eERT_EditParent;
    frmEditParents.idRelation := idRelation;
    if frmEditParents.Showmodal = mrOk then
      dmGenData.PopulateParents(tblParents, frmStemmaMainForm.iID);
  end;
end;

procedure TfrmParents.tblParentsDrawCell(Sender: TObject; aCol, aRow: integer;
  aRect: TRect; aState: TGridDrawState);
begin
  if ((Sender as TStringGrid).Cells[1, aRow] = '*') and (aCol = 3) then
  begin
    (Sender as TStringGrid).Canvas.Font.Bold := True;
    (Sender as TStringGrid).Canvas.TextOut(aRect.Left + 2, aRect.Top + 2,
      (Sender as TStringGrid).Cells[aCol, aRow]);
  end;
end;

function TfrmParents.GetIdRelation: integer;
begin
  Result := PtrInt(tblParents.Objects[0, tblParents.Row]);
end;

procedure TfrmParents.CopyParent(Sender: TObject);
var
  lidRelation: integer;
  RelLastID: longint;
begin
  lidRelation := frmParents.idRelation;

  RelLastID := dmGenData.CopyRelation(frmParents.idRelation);
  dmGenData.UpdateIndModificationTimesByRelation(RelLastID);

  // en: Copy Citation
  dmGenData.CopyCitation('R', lidRelation, RelLastID);

  dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
  dmGenData.PopulateParents(frmParents.tblParents, frmStemmaMainForm.iID);
end;

end.
