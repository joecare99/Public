unit frm_parents;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Menus,
  frm_EditParents, LCLType;

type

  { TfrmParents }

  TfrmParents = class(TForm)
    mniGoTo: TMenuItem;
    mniPrimary: TMenuItem;
    mndDiv1: TMenuItem;
    mndDiv2: TMenuItem;
    mniAdd: TMenuItem;
    mniEdit: TMenuItem;
    mniDelete: TMenuItem;
    PopupMenuParent: TPopupMenu;
    TableauParents: TStringGrid;
    procedure FormClose(Sender: TObject; var {%H-}CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mniGoToClick(Sender: TObject);
    procedure mniPrimaryClick(Sender: TObject);
    procedure mniAddClick(Sender: TObject);
    procedure mniDeleteClick(Sender: TObject);
    procedure TableauParentsDblClick(Sender: TObject);
    procedure TableauParentsDrawCell(Sender: TObject; aCol, aRow: Integer;
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

{$R *.lfm}

{ TfrmParents }

procedure TfrmParents.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  dmGenData.WriteCfgFormPosition(self);
  dmGenData.WriteCfgGridPosition(TableauParents as TStringGrid,4);
end;

procedure TfrmParents.FormResize(Sender: TObject);
begin
  TableauParents.Width := (Sender as Tform).Width;
  TableauParents.Height := (Sender as Tform).Height;
  TableauParents.Columns[2].Width := (Sender as Tform).Width-131;
end;

procedure TfrmParents.FormShow(Sender: TObject);
begin
  Caption:=Translation.Items[130];
  TableauParents.Cells[2,0]:=Translation.Items[185];
  TableauParents.Cells[3,0]:=Translation.Items[216];
  TableauParents.Cells[4,0]:=Translation.Items[177];
  mniGoTo.Caption:=Translation.Items[222];
  mniPrimary.Caption:=Translation.Items[234];
  mniAdd.Caption:=Translation.Items[224];
  mniEdit.Caption:=Translation.Items[225];
  mniDelete.Caption:=Translation.Items[226];
  dmGenData.ReadCfgFormPosition(Sender as TForm,0,0,70,1000);
  dmGenData.ReadCfgGridPosition(TableauParents as TStringGrid,4);
  dmGenData.PopulateParents(frmParents.TableauParents,frmStemmaMainForm.iID);
end;

procedure TfrmParents.mniGoToClick(Sender: TObject);
begin
   if TableauParents.Row>0 then
      frmStemmaMainForm.iID:=Ptrint(TableauParents.Objects[5,TableauParents.Row]);
end;

procedure TfrmParents.mniPrimaryClick(Sender: TObject);
var
  s:string;
begin
     If TableauParents.Cells[1,TableauParents.row]='*' then
        begin
        dmGenData.Query1.SQL.Text:='UPDATE R SET X=0 WHERE no='+
                                  TableauParents.Cells[0,TableauParents.row];
        dmGenData.Query1.ExecSQL;
        // Modifie la date de modification
        dmGenData.SaveModificationTime(Ptrint(TableauParents.objects[5,TableauParents.row]));
        dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
        dmGenData.PopulateParents(frmParents.TableauParents,frmStemmaMainForm.iID);
     end
     else
        begin
        dmGenData.Query1.SQL.Clear;
        // Trouve le parent primaire du meme sexe et l'enlève
        dmGenData.Query1.SQL.Add('SELECT I.S FROM I WHERE I.no='+
                                  TableauParents.Cells[5,TableauParents.row]);
        dmGenData.Query1.Open;
        If not dmGenData.Query1.EOF then
           begin
           S:=dmGenData.Query1.Fields[0].AsString;
           dmGenData.Query1.SQL.Text:='SELECT R.no, R.B FROM R JOIN I ON R.B=I.no WHERE I.S='''+
                                     S+''' AND R.X=1 AND R.A='+frmStemmaMainForm.sID;
           dmGenData.Query1.Open;
           If not dmGenData.Query1.EOF then
              begin
              dmGenData.Query2.SQL.Text:='UPDATE R SET X=0 WHERE no='+
                                    dmGenData.Query1.Fields[0].AsString;
              dmGenData.Query2.ExecSQL;
              dmGenData.SaveModificationTime(dmGenData.Query1.Fields[1].AsInteger);
           end;
        end;
        dmGenData.Query1.SQL.Text:='UPDATE R SET X=1 WHERE no='+
                                  TableauParents.Cells[0,TableauParents.row];
        dmGenData.Query1.ExecSQL;
        // Modifie la date de modification
        dmGenData.SaveModificationTime(ptrint(TableauParents.Objects[5,TableauParents.row]));
        dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
        dmGenData.PopulateParents(frmParents.TableauParents,frmStemmaMainForm.iID);
     end;
end;

procedure TfrmParents.mniAddClick(Sender: TObject);
begin
  // Ajouter un parent
  dmGenData.PutCode('P',0);
  dmGenData.PutCode('A',0);
  if frmEditParents.Showmodal = mrOK then
     begin
     dmGenData.PopulateParents(frmParents.TableauParents,frmStemmaMainForm.iID);
  end;
end;

procedure TfrmParents.mniDeleteClick(Sender: TObject);
begin
  // Supprimer un parent
  if TableauParents.Row>0 then
     if Application.MessageBox(Pchar(Translation.Items[131]+
           TableauParents.Cells[3,TableauParents.Row]+
           Translation.Items[28]),pchar(SConfirmation),MB_YESNO)=IDYES then
        begin
        dmGenData.SaveModificationTime(ptrint(TableauParents.objects[5,TableauParents.Row]));
        dmGenData.DeleteCitationb_TypeId('R',ptrint(TableauParents.Objects[0,TableauParents.Row]));
        dmGenData.Query1.SQL.Text:='DELETE FROM R WHERE no='+TableauParents.Cells[0,TableauParents.Row];
        dmGenData.Query1.ExecSQL;
        TableauParents.DeleteRow(TableauParents.Row);
        dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
     end;
end;

procedure TfrmParents.TableauParentsDblClick(Sender: TObject);
begin
  if TableauParents.Row>0 then
     begin
     dmGenData.PutCode('P',0);
     If frmEditParents.Showmodal=mrOK then
        dmGenData.PopulateParents(frmParents.TableauParents,frmStemmaMainForm.iID);
  end;
end;

procedure TfrmParents.TableauParentsDrawCell(Sender: TObject; aCol,
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
  result := PtrInt(TableauParents.Objects[0, frmParents.TableauParents.Row]);
end;

end.

