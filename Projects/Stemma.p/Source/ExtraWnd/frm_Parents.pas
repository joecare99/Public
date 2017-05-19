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
    Procedure CopyParent(Sender: TObject);
    procedure tblParentsDblClick(Sender: TObject);
    procedure tblParentsDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; {%H-}aState: TGridDrawState);
  private
    function GetIdRelation: integer;
    { private declarations }
  public
    { public declarations }
    property idRelation:integer read GetIdRelation;
  end;

var
  frmParents: TfrmParents;

implementation

uses
  frm_Main,cls_Translation, dm_GenData;

procedure SetRelationPrefered(const lidInd: LongInt; const lidIndRel: integer;
  const lidRelation: Integer);
var
  s: string;
begin
  If dmGenData.IsValidIndividuum(lidIndRel) then
     begin
     S:=dmGenData.GetSexOfInd(lidIndRel);
     dmGenData.Query1.Close;
     dmGenData.Query1.SQL.Text:='SELECT R.no, R.B FROM R JOIN I ON R.B=I.no WHERE I.S=:Sex AND R.X=1 AND R.A=:idind';
     dmGenData.Query1.ParamByName('idInd').AsInteger:= lidInd;
     dmGenData.Query1.ParamByName('Sex').AsString:= S;
     dmGenData.Query1.Open;
     If not dmGenData.Query1.EOF then
        begin
        dmGenData.Query2.SQL.Text:='UPDATE R SET X=0 WHERE no=idRelation';
        dmGenData.Query2.ParamByName('idRelation').AsInteger:= dmGenData.Query1.Fields[0].AsInteger;
        dmGenData.Query2.ExecSQL;
        dmGenData.SaveModificationTime(dmGenData.Query1.Fields[1].AsInteger);
     end;
  end;
  dmGenData.Query1.Close;
  dmGenData.Query1.SQL.Text:='UPDATE R SET X=1 WHERE no=:idRelation';
  dmGenData.Query1.ParamByName('idRelation').AsInteger:= lidRelation;
  dmGenData.Query1.ExecSQL;
  // Modifie la date de modification
  dmGenData.SaveModificationTime(lidIndRel);
  dmGenData.SaveModificationTime(lidind);
end;

procedure ResetRelationPrefered(const lidInd,lidIndRel: integer;
  const lidRelation: Integer);
begin
  dmGenData.Query1.SQL.Text:='UPDATE R SET X=0 WHERE no=:idRelation';
     dmGenData.Query1.ParamByName('idRelation').AsInteger:=lidRelation;
     dmGenData.Query1.ExecSQL;
     // Modifie la date de modification
     dmGenData.SaveModificationTime(lidIndRel);
     dmGenData.SaveModificationTime(lidInd);
end;

{$R *.lfm}

{ TfrmParents }

procedure TfrmParents.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  dmGenData.WriteCfgFormPosition(self);
  dmGenData.WriteCfgGridPosition(tblParents as TStringGrid,4);
end;

procedure TfrmParents.tblParentsResize(Sender: TObject);
begin
  tblParents.Columns[2].Width := tblParents.Width-131;
end;

procedure TfrmParents.FormShow(Sender: TObject);
begin
  Caption:=SParents;
  tblParents.Cells[2,0]:=Translation.Items[185];
  tblParents.Cells[3,0]:=Translation.Items[216];
  tblParents.Cells[4,0]:=Translation.Items[177];
  dmGenData.ReadCfgFormPosition(Sender as TForm,0,0,70,1000);
  dmGenData.ReadCfgGridPosition(tblParents as TStringGrid,4);
  dmGenData.PopulateParents(tblParents,frmStemmaMainForm.iID);
end;

procedure TfrmParents.actParentGotoExecute(Sender: TObject);
begin
   if tblParents.Row>0 then
      frmStemmaMainForm.iID:=Ptrint(tblParents.Objects[5,tblParents.Row]);
end;

procedure TfrmParents.actParentSetPreferedExecute(Sender: TObject);
var
  lidRelation: Integer;
  lidIndRel: integer;
  lidInd: integer;
begin
  lidRelation:=idRelation;
  lidIndRel:=Ptrint(tblParents.objects[5,tblParents.row]);
  lidInd := frmStemmaMainForm.iID;
     If tblParents.Cells[1,tblParents.row]='*' then
        begin
        ResetRelationPrefered(lidInd, lidIndRel, lidRelation);
        dmGenData.PopulateParents(tblParents,frmStemmaMainForm.iID);
     end
     else
        begin
        SetRelationPrefered(lidInd, lidIndRel, lidRelation);
        dmGenData.PopulateParents(tblParents,frmStemmaMainForm.iID);
     end;
end;

procedure TfrmParents.mniAddClick(Sender: TObject);
begin
  // Ajouter un parent
  //dmGenData.PutCode('P',0);
  //dmGenData.PutCode('A',0);
  frmEditParents.EditMode:=eERT_appendParent;;
  if frmEditParents.Showmodal = mrOK then
     begin
     dmGenData.PopulateParents(tblParents,frmStemmaMainForm.iID);
  end;
end;

procedure TfrmParents.mniDeleteClick(Sender: TObject);
begin
  // Supprimer un parent
  if tblParents.Row>0 then
     if Application.MessageBox(Pchar(Translation.Items[131]+
           tblParents.Cells[3,tblParents.Row]+
           Translation.Items[28]),pchar(SConfirmation),MB_YESNO)=IDYES then
        begin
        dmGenData.SaveModificationTime(ptrint(tblParents.objects[5,tblParents.Row]));
        dmGenData.DeleteCitationb_TypeId('R',ptrint(tblParents.Objects[0,tblParents.Row]));
        dmGenData.Query1.SQL.Text:='DELETE FROM R WHERE no='+tblParents.Cells[0,tblParents.Row];
        dmGenData.Query1.ExecSQL;
        tblParents.DeleteRow(tblParents.Row);
        dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
     end;
end;

procedure TfrmParents.tblParentsDblClick(Sender: TObject);
begin
  if tblParents.Row>0 then
     begin
     //dmGenData.PutCode('P',0);
    frmEditParents.EditMode:=eERT_EditParent;
     If frmEditParents.Showmodal=mrOK then
        dmGenData.PopulateParents(tblParents,frmStemmaMainForm.iID);
  end;
end;

procedure TfrmParents.tblParentsDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin
  if ((Sender as TStringGrid).Cells[1,aRow]='*') and (aCol=3) then
     begin
     (Sender as TStringGrid).Canvas.Font.Bold := true;
     (Sender as TStringGrid).Canvas.TextOut(aRect.Left+2,aRect.Top+2,(Sender as TStringGrid).Cells[aCol,aRow]);
  end;
end;

function TfrmParents.GetIdRelation: integer;
begin
  result := PtrInt(tblParents.Objects[0, tblParents.Row]);
end;

procedure TfrmParents.CopyParent(Sender: TObject);
var
  lidRelation: Integer;
  RelLastID: LongInt;
begin
    lidRelation := frmParents.idRelation;

    RelLastID := dmGenData.CopyRelation(frmParents.idRelation);
    dmGenData.SaveModificationTime(dmGenData.Query1.Fields[2].AsInteger);

    // en: Copy Citation
    dmGenData.CopyCitation('R', lidRelation, RelLastID);

    dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
    dmGenData.PopulateParents(frmParents.tblParents, frmStemmaMainForm.iID);
end;

end.

