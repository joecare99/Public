unit fra_Documents;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazFileUtils, Forms, Controls, Grids, StdCtrls, Menus,
  ExtCtrls, ActnList;

type

  { TfraDocuments }

  TfraDocuments = class(TFrame)
    actDocumentsAdd: TAction;
    actDocumentsEdit: TAction;
    actDocumentsDelete: TAction;
    actDocumentsDisplay: TAction;
    alsDocuments: TActionList;
    Ajouter2: TMenuItem;
    Label12: TLabel;
    MenuItem10: TMenuItem;
    MenuItem9: TMenuItem;
    Modifier2: TMenuItem;
    pnlDocumentsLeft: TPanel;
    mnuDocuments: TPopupMenu;
    Supprimer2: TMenuItem;
    tblDocuments: TStringGrid;
    procedure actDocumentsAddExecute(Sender: TObject);
    procedure actDocumentsDeleteExecute(Sender: TObject);
    procedure actDocumentsDisplayExecute(Sender: TObject);
    procedure actDocumentsEditExecute(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure Modifier2Click(Sender: TObject);
    procedure Supprimer2Click(Sender: TObject);
    procedure tblDocumentsResize(Sender: TObject);
  private
    FDocType: String;
    FidLink: integer;
    FOnParentSave: TNotifyEvent;
    function GetidDocument: Integer;
    procedure SetDocType(AValue: String);
    procedure SetidDocument(AValue: Integer);
    procedure SetidLink(AValue: integer);
    procedure SetOnParentSave(AValue: TNotifyEvent);
    { private declarations }
  public
    { public declarations }
    property idDocument:Integer read GetidDocument write SetidDocument;
    property DocType:String read FDocType write SetDocType;
    Property idLink:integer read FidLink write SetidLink;
    Property OnParentSave:TNotifyEvent read FOnParentSave write SetOnParentSave;
  end;

implementation

Uses Dialogs,dm_GenData,FMUtils,cls_Translation, frm_EditDocuments,frm_ShowImage,lclintf;

procedure UpdateDocumentInfo(const lidDocument: Integer;
  const lDocumentInfo: string);
begin
             dmGenData.Query2.Close;
             dmGenData.Query2.SQL.Text:='UPDATE X SET Z=:Z WHERE X.no=:idDocument';
  dmGenData.Query2.ParamByName('Z').AsString:=lDocumentInfo;
  dmGenData.Query2.ParamByName('idDocument').AsInteger := lidDocument;
             dmGenData.Query2.ExecSQL;
end;

{$R *.lfm}

{ TfraDocuments }

procedure TfraDocuments.tblDocumentsResize(Sender: TObject);
begin
  tblDocuments.Columns[1].Width := tblDocuments.Width-GetTableColWidthSum(tblDocuments,1);
end;

procedure TfraDocuments.actDocumentsEditExecute(Sender: TObject);
begin
  // Modifier un document à la source
  If tblDocuments.Row>0 then
     begin
//     dmGenData.PutCode(DocType,idDocument);
      frmEditDocuments.docType := docType;
      frmEditDocuments.idDocument := idDocument;
      frmEditDocuments.EditMode := eDEM_EditDocument;
     If frmEditDocuments.Showmodal=mrOK then
        dmGenData.PopulateDocuments(tblDocuments,DocType,idLink);
     end;
end;

procedure TfraDocuments.MenuItem10Click(Sender: TObject);
begin

end;

procedure TfraDocuments.MenuItem9Click(Sender: TObject);
begin

end;

procedure TfraDocuments.Modifier2Click(Sender: TObject);
begin

end;

procedure TfraDocuments.Supprimer2Click(Sender: TObject);
begin

end;

procedure TfraDocuments.actDocumentsDeleteExecute(Sender: TObject);
begin
    // Supprimer un document à la source
  If tblDocuments.Row>0 then
     if MessageDlg(SConfirmation,
       format(SAreYouSureToDelX,[SDocument, tblDocuments.Cells[2,tblDocuments.Row]])
     ,mtConfirmation,mbYesNo,0) =mrYES  then
        begin
        dmGenData.DeleteDocument(idDocument);
        tblDocuments.DeleteRow(tblDocuments.Row);
     end;
end;

procedure TfraDocuments.actDocumentsAddExecute(Sender: TObject);
begin
  // fr: Ajouter un document à la source
  If (idLink=0) and assigned(FOnParentSave) then
     FOnParentSave(Sender);
  If (idLink=0) then exit;
  //dmGenData.PutCode(DocType,idLink);
  //dmGenData.PutCode('A',idLink);
   frmEditDocuments.docType := docType;
   frmEditDocuments.idLinkID := idLink;
   frmEditDocuments.EditMode := eDEM_AddDocument;
  If frmEditDocuments.Showmodal=mrOK then
     dmGenData.PopulateDocuments(tblDocuments,DocType,idLink);
end;

procedure TfraDocuments.actDocumentsDisplayExecute(Sender: TObject);
var
  lDocumentInfo: string;

begin
   // Visualiser un document de la source
  if tblDocuments.Row>0 then
     begin
     dmGenData.Query2.SQL.Text:='SELECT X.Z, X.F FROM X WHERE X.no='+tblDocuments.Cells[0,tblDocuments.Row];
     dmGenData.Query2.Open;
     if tblDocuments.Cells[4,tblDocuments.Row]=Translation.Items[34] then
        begin
        frmShowImage.Caption:=Translation.Items[34];
        frmShowImage.Image.Visible:=false;
        frmShowImage.Memo.Visible:=true;
        frmShowImage.btnOK.Visible:=true;
        frmShowImage.btnCancel.Visible:=true;
        frmShowImage.Memo.Text:=dmGenData.Query2.Fields[0].AsString;
        lDocumentInfo:=frmShowImage.Memo.Text;
        if (frmShowImage.Showmodal=mrOk) and (lDocumentInfo<>frmShowImage.Memo.Text) then
           begin
           // Only if the memo was changed
           lDocumentInfo:=frmShowImage.Memo.Text;
           UpdateDocumentInfo(idDocument, lDocumentInfo);
        end;
     end
     else
        begin
        if uppercase(ExtractFileExt(dmGenData.Query2.Fields[1].AsString))='.PDF' then
           try
             OpenDocument(dmGenData.Query2.Fields[1].AsString);
           except

        end
        else
           begin
           frmShowImage.Caption:=dmGenData.Query2.Fields[1].AsString;
           frmShowImage.Memo.Visible:=false;
           frmShowImage.btnOK.Visible:=false;
           frmShowImage.btnCancel.Visible:=false;
           frmShowImage.Image.Visible:=true;
           frmShowImage.Image.Picture.LoadFromFile(dmGenData.Query2.Fields[1].AsString);
           frmShowImage.Showmodal;
        end;
     end;
  end;
end;

function TfraDocuments.GetidDocument: Integer;
begin
  result := ptrint(tblDocuments.Objects[0,tblDocuments.Row]);
end;

procedure TfraDocuments.SetDocType(AValue: String);
begin
  if FDocType=AValue then Exit;
  FDocType:=AValue;
end;

procedure TfraDocuments.SetidDocument(AValue: Integer);
var
  idx: Integer;
begin
  idx := tblDocuments.Cols[0].IndexOfObject(TObject(ptrint(AValue)));
  if idx>=0 then
    tblDocuments.Row:= idx;
end;

procedure TfraDocuments.SetidLink(AValue: integer);
begin
  if FidLink=AValue then Exit;
  FidLink:=AValue;
end;

procedure TfraDocuments.SetOnParentSave(AValue: TNotifyEvent);
begin
  if @FOnParentSave= @AValue then Exit;
  FOnParentSave:=AValue;
end;

end.

