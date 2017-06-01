unit frm_Documents;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Menus,
  frm_EditDocuments, frm_Images, LCLType, ActnList, ComCtrls, Types;

type

  { TfrmDocuments }

  TfrmDocuments = class(TForm)
    actDocumentsDelete: TAction;
    actDocumentsEdit: TAction;
    actDocumentsAdd: TAction;
    actDocumentsSetPrefered: TAction;
    ActionList1: TActionList;
    mniSetPrefered: TMenuItem;
    mniSeparator: TMenuItem;
    mniAdd: TMenuItem;
    mniEdit: TMenuItem;
    mniDelete: TMenuItem;
    mnuDocuments: TPopupMenu;
    tblDocuments: TStringGrid;
    ToolBar1: TToolBar;
    btnDocumentsSetPrefered: TToolButton;
    btnDocumentsSep: TToolButton;
    btnDocumentsAdd: TToolButton;
    btnDocumentsEdit: TToolButton;
    btnDocumentsDelete: TToolButton;
    procedure actDocumentsAddUpdate(Sender: TObject);
    procedure actDocumentsDeleteUpdate(Sender: TObject);
    procedure actDocumentsSetPreferedUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure tblDocumemntsResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actDocumentsSetPreferedExecute(Sender: TObject);
    procedure actDocumentsAddExecute(Sender: TObject);
    procedure actDocumentsDeleteExecute(Sender: TObject);
    procedure mnuModifyClick(Sender: TObject);
    procedure tblDocumentsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure tblDocumentsDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; {%H-}aState: TGridDrawState);
    procedure tblDocumentsPrepareCanvas(sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);
    procedure tblDocumentsSelection(Sender: TObject; {%H-}aCol, aRow: Integer);
  private
    function GetidDocument: integer;
    procedure SetidDocument(AValue: integer);
    { private declarations }
  public
    { public declarations }
    property idDocument:integer read GetidDocument write SetidDocument;
  end; 


var
  frmDocuments: TfrmDocuments;

implementation

uses
  frm_Main, cls_Translation, dm_GenData, FMUtils;


{$R *.lfm}

{ TfrmDocuments }

procedure TfrmDocuments.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  dmGenData.WriteCfgFormPosition(Self);
  dmGenData.WriteCfgGridPosition(tblDocuments as TStringGrid,4);
end;

procedure TfrmDocuments.actDocumentsSetPreferedUpdate(Sender: TObject);
begin
  actDocumentsSetPrefered.Enabled:=tblDocuments.Cells[1,tblDocuments.Row]<> '*';
end;

procedure TfrmDocuments.actDocumentsAddUpdate(Sender: TObject);
begin
  actDocumentsAdd.Enabled:=true;
end;

procedure TfrmDocuments.actDocumentsDeleteUpdate(Sender: TObject);
begin
  actDocumentsDelete.Enabled:=(tblDocuments.Cells[1,tblDocuments.row]<>'*') or
    (tblDocuments.RowCount<3);
end;

procedure TfrmDocuments.tblDocumemntsResize(Sender: TObject);
begin
  if assigned(tblDocuments.Columns) then
    tblDocuments.Columns[1].Width := tblDocuments.Width-fmutils.GetTableColWidthSum(tblDocuments,1);
end;

procedure TfrmDocuments.FormShow(Sender: TObject);
begin
  Caption:=Format(SDocuments,[]);
  tblDocuments.Cells[2,0]:=Translation.Items[154];
  tblDocuments.Cells[3,0]:=Translation.Items[185];
  tblDocuments.Cells[4,0]:=Translation.Items[201];
  dmGenData.ReadCfgFormPosition(self,0,0,200,200);
  dmGenData.ReadCfgGridPosition(tblDocuments,4);
  dmGenData.PopulateDocuments(tblDocuments,'I',frmStemmaMainForm.iID);
end;

procedure TfrmDocuments.actDocumentsSetPreferedExecute(Sender: TObject);
var
  lidDocument: Integer;
  lNewPref: Boolean;
  lidInd: LongInt;
begin
  if tblDocuments.Cells[3,tblDocuments.row]='I' then
     begin
     lidDocument := idDocument;
     lidInd:=frmStemmaMainForm.iID;
     lNewPref := tblDocuments.Cells[1,tblDocuments.row]<>'*';
     dmGenData.UpdateDocument_SRPrefered(lidInd, lNewPref, lidDocument);
     // Modifie la date de modification
     dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
     dmGenData.PopulateDocuments(tblDocuments,'I',frmStemmaMainForm.iID);
  end
  else
     ShowMessage(SOnlyTheExhibitsAssoc);
end;

procedure TfrmDocuments.actDocumentsAddExecute(Sender: TObject);
begin
  // Ajouter un exhibit
  //dmGenData.PutCode('I',frmStemmaMainForm.iID);
  //dmGenData.PutCode('A',frmStemmaMainForm.iID);
   frmEditDocuments.docType := 'I';
   frmEditDocuments.idLinkID := frmStemmaMainForm.iID;
   frmEditDocuments.Editmode := eDEM_AddDocument;
  If frmEditDocuments.Showmodal=mrOK then
      dmGenData.PopulateDocuments(tblDocuments,'I',frmStemmaMainForm.iID);
end;

procedure TfrmDocuments.actDocumentsDeleteExecute(Sender: TObject);
var
  lidDocument: Integer;
begin
  // Supprimer un exhibit
  if tblDocuments.Row>0 then
     if Application.MessageBox(Pchar(Translation.Items[62]+
        tblDocuments.Cells[2,tblDocuments.Row]+Translation.Items[28]),pchar(SConfirmation),MB_YESNO)=IDYES then
        begin
        lidDocument := idDocument;
        dmGenData.DeleteDocument(lidDocument);
        tblDocuments.DeleteRow(tblDocuments.Row);
        if frmStemmaMainForm.actWinImages.Checked then
           begin
           if tblDocuments.Row>0 then
              tblDocumentsSelection(Sender,0,tblDocuments.Row)
           else
              FormImage.Im.Picture.Clear;
        end;
        dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
     end;
end;

procedure TfrmDocuments.mnuModifyClick(Sender: TObject);
begin
  If tblDocuments.Row>0 then
     begin
//     dmGenData.PutCode('E',tblDocuments.Cells[0,tblDocuments.Row]);
     frmEditDocuments.idDocument := idDocument;
     frmEditDocuments.Editmode := eDEM_EditDocument;
     If frmEditDocuments.Showmodal=mrOK then
        dmGenData.PopulateDocuments(tblDocuments,'I',frmStemmaMainForm.iID);
     end;
end;

procedure TfrmDocuments.tblDocumentsContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
   tblDocuments.Row:=tblDocuments.MouseToCell(MousePos).y;
   Handled:=false;
end;

procedure TfrmDocuments.tblDocumentsDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin
  if ((Sender as TStringGrid).Cells[1,aRow]='*') and (aCol=2) then
     begin
     (Sender as TStringGrid).Canvas.Font.Bold := true;
     (Sender as TStringGrid).Canvas.TextOut(aRect.Left+2,aRect.Top+2,(Sender as TStringGrid).Cells[aCol,aRow]);
  end;
end;

procedure TfrmDocuments.tblDocumentsPrepareCanvas(sender: TObject; aCol,
  aRow: Integer; aState: TGridDrawState);
begin

end;

procedure TfrmDocuments.tblDocumentsSelection(Sender: TObject; aCol,
  aRow: Integer);
begin
  if tblDocuments.Cells[1,aRow]='*' then
     PopulateImage(0)
  else
     PopulateImage(StrToInt(tblDocuments.Cells[0,aRow]));
end;

function TfrmDocuments.GetidDocument: integer;
begin
  result := PtrInt(tblDocuments.Objects[0,tblDocuments.Row]);
end;

procedure TfrmDocuments.SetidDocument(AValue: integer);
var
  id: Integer;
begin
  id :=
   tblDocuments.Cols[0].IndexOfObject(TObject(ptrint(AValue)));
  if id>=0 then
     tblDocuments.Row:=id;;
end;


end.

