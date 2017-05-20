unit frm_Children;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Menus,
  FMUtils, frm_EditParents, LCLType, ActnList;

type

  { TfrmChildren }

  TfrmChildren = class(TForm)
    Action1: TAction;
    alsChildren: TActionList;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    PopupMenuEnfant: TPopupMenu;
    TableauEnfants: TStringGrid;
    procedure FormClose(Sender: TObject; var {%H-}CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure TableauEnfantsDblClick(Sender: TObject);
    procedure TableauEnfantsDrawCell(Sender: TObject; aCol, aRow: integer;
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
  dmGenData.FillChildrenList(TableauEnfants, frmStemmaMainForm.iID, principaux);
  Caption := Translation.Items[57] + ' (' + IntToStr(principaux) + ' & ' +
    IntToStr(TableauEnfants.RowCount - 1 - principaux) + ')';
end;

procedure TfrmChildren.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  dmGenData.WriteCfgFormPosition(Self);
  dmGenData.WriteCfgGridPosition(TableauEnfants as TStringGrid, 5);
end;

procedure TfrmChildren.FormResize(Sender: TObject);
begin
  TableauEnfants.Width := (Sender as TForm).Width;
  TableauEnfants.Height := (Sender as TForm).Height;
  TableauEnfants.Columns[2].Width := (Sender as TForm).Width - 142;
end;

procedure TfrmChildren.FormShow(Sender: TObject);
begin
  Caption := Translation.Items[57];
  TableauEnfants.Cells[2, 0] := Translation.Items[185];
  TableauEnfants.Cells[3, 0] := Translation.Items[200];
  TableauEnfants.Cells[4, 0] := Translation.Items[177];
  MenuItem1.Caption := Translation.Items[222];
  MenuItem3.Caption := Translation.Items[224];
  MenuItem4.Caption := Translation.Items[225];
  MenuItem5.Caption := Translation.Items[226];
  dmGenData.ReadCfgFormPosition(Sender as TForm, 0, 0, 70, 1000);
  dmGenData.ReadCfgGridPosition(TableauEnfants as TStringGrid, 5);
  PopulateEnfants(Sender);
end;

procedure TfrmChildren.MenuItem1Click(Sender: TObject);
begin
  if TableauEnfants.Row > 0 then
    frmStemmaMainForm.iID := ptrint(TableauEnfants.Objects[5, TableauEnfants.Row]);
end;

procedure TfrmChildren.MenuItem3Click(Sender: TObject);
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

procedure TfrmChildren.MenuItem5Click(Sender: TObject);

begin
  // Supprimer un enfant
  if TableauEnfants.Row > 0 then
    if Application.MessageBox(PChar(Translation.Items[58] +
      TableauEnfants.Cells[3, TableauEnfants.Row] +
      Translation.Items[28]), PChar(SConfirmation), MB_YESNO) = idYes then
    begin
      dmGenData.DeleteRelationFull(frmStemmaMainForm.iID,
        ptrint(TableauEnfants.objects[5, TableauEnfants.Row]), idRelation);
      TableauEnfants.DeleteRow(TableauEnfants.Row);
    end;
end;

procedure TfrmChildren.TableauEnfantsDblClick(Sender: TObject);
begin
  if TableauEnfants.Row > 0 then
  begin
    //dmGenData.PutCode('E',0);
    frmEditParents.EditMode := eERT_editChild;
    frmEditParents.idRelation := idRelation;
    if frmEditParents.Showmodal = mrOk then
      PopulateEnfants(Sender);
  end;
end;

procedure TfrmChildren.TableauEnfantsDrawCell(Sender: TObject;
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
  Result := PtrInt(TableauEnfants.Objects[1, TableauEnfants.Row]);
end;

function TfrmChildren.GetIdRelation: integer;
begin
  Result := PtrInt(TableauEnfants.Objects[0, TableauEnfants.Row]);
end;


end.
