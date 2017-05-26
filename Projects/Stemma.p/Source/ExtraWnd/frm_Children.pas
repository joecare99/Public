unit frm_Children;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Menus,
  frm_EditParents, LCLType, ActnList, ComCtrls;

type

  { TfrmChildren }

  TfrmChildren = class(TForm)
    actChildrenGoto: TAction;
    actChildrenAdd: TAction;
    actChildrenEdit: TAction;
    actChildrenDetach: TAction;
    alsChildren: TActionList;
    mniChildrenGoTo: TMenuItem;
    mniChildrenSep: TMenuItem;
    mniChildrenAdd: TMenuItem;
    mniChildrenEdit: TMenuItem;
    mniChildrenDetach: TMenuItem;
    mnuChildren: TPopupMenu;
    tblChildren: TStringGrid;
    ToolBar1: TToolBar;
    btnChildrenGoto: TToolButton;
    btnChildrenSep: TToolButton;
    btnChildrenAdd: TToolButton;
    btnChildrenEdit: TToolButton;
    btnChildrenDetach: TToolButton;
    procedure FormClose(Sender: TObject; var {%H-}CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actChildrenGoToExecute(Sender: TObject);
    procedure actChildrenAddExecute(Sender: TObject);
    procedure actChildrenDetachExecute(Sender: TObject);
    procedure actChildrenEditExecute(Sender: TObject);
    procedure tblChildrenDrawCell(Sender: TObject; aCol, aRow: integer;
      aRect: TRect; {%H-}aState: TGridDrawState);
  private
    function GetIdChild: integer;
    function GetIdRelation: integer;
    { private declarations }
  public
    { public declarations }
    procedure PopulateEnfants(Sender: TObject);
    property idRelation: integer read GetIdRelation;
    property idChild: integer read GetIdChild;
  end;


var
  frmChildren: TfrmChildren;

implementation

uses
  frm_Main, cls_Translation, dm_GenData;

{$R *.lfm}

{ TfrmChildren }

procedure TfrmChildren.PopulateEnfants(Sender: TObject);
var
  principaux: integer;

begin
  dmGenData.FillChildrenList(tblChildren, frmStemmaMainForm.iID, principaux);
  Caption := Translation.Items[57] + ' (' + IntToStr(principaux) + ' & ' +
    IntToStr(tblChildren.RowCount - 1 - principaux) + ')';
end;

procedure TfrmChildren.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  dmGenData.WriteCfgFormPosition(Self);
  dmGenData.WriteCfgGridPosition(tblChildren as TStringGrid, 5);
end;

procedure TfrmChildren.FormResize(Sender: TObject);
begin
  tblChildren.Columns[2].Width := tblChildren.Width - 142;
end;

procedure TfrmChildren.FormShow(Sender: TObject);
begin
  Caption := Translation.Items[57];
  tblChildren.Cells[2, 0] := Translation.Items[185];
  tblChildren.Cells[3, 0] := Translation.Items[200];
  tblChildren.Cells[4, 0] := Translation.Items[177];
  mniChildrenGoTo.Caption := Translation.Items[222];
  mniChildrenAdd.Caption := Translation.Items[224];
  mniChildrenEdit.Caption := Translation.Items[225];
  mniChildrenDetach.Caption := Translation.Items[226];
  dmGenData.ReadCfgFormPosition(Sender as TForm, 0, 0, 70, 1000);
  dmGenData.ReadCfgGridPosition(tblChildren as TStringGrid, 5);
  PopulateEnfants(Sender);
end;

procedure TfrmChildren.actChildrenGoToExecute(Sender: TObject);
begin
  if tblChildren.Row > 0 then
    frmStemmaMainForm.iID := ptrint(tblChildren.Objects[5, tblChildren.Row]);
end;

procedure TfrmChildren.actChildrenAddExecute(Sender: TObject);
begin
  // Ajouter un enfant
  //dmGenData.PutCode('E',0);
  //dmGenData.PutCode('A',0);
  frmEditParents.EditMode := eERT_appendChild;
  if frmEditParents.Showmodal = mrOk then
  begin
    PopulateEnfants(Sender);
  end;
end;

procedure TfrmChildren.actChildrenDetachExecute(Sender: TObject);

begin
  // Supprimer un enfant
  if tblChildren.Row > 0 then
    if Application.MessageBox(PChar(Translation.Items[58] +
      tblChildren.Cells[3, tblChildren.Row] +
      Translation.Items[28]), PChar(SConfirmation), MB_YESNO) = idYes then
    begin
      dmGenData.DeleteRelationFull(frmStemmaMainForm.iID,
        ptrint(tblChildren.objects[5, tblChildren.Row]), idRelation);
      tblChildren.DeleteRow(tblChildren.Row);
    end;
end;

procedure TfrmChildren.actChildrenEditExecute(Sender: TObject);
begin
  if tblChildren.Row > 0 then
  begin
    //dmGenData.PutCode('E',0);
    frmEditParents.EditMode := eERT_editChild;
    frmEditParents.idRelation := idRelation;
    if frmEditParents.Showmodal = mrOk then
      PopulateEnfants(Sender);
  end;
end;

procedure TfrmChildren.tblChildrenDrawCell(Sender: TObject;
  aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
begin
  if ((Sender as TStringGrid).Cells[1, aRow] = '*') and (aCol = 3) then
  begin
    (Sender as TStringGrid).Canvas.Font.Bold := True;
    (Sender as TStringGrid).Canvas.TextOut(aRect.Left + 2, aRect.Top + 2,
      (Sender as TStringGrid).Cells[aCol, aRow]);
  end;
end;

function TfrmChildren.GetIdChild: integer;
begin
  Result := PtrInt(tblChildren.Objects[1, tblChildren.Row]);
end;

function TfrmChildren.GetIdRelation: integer;
begin
  Result := PtrInt(tblChildren.Objects[0, tblChildren.Row]);
end;


end.
