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
        procedure tblDocumentsResize(Sender: TObject);
    private
        FDocType: string;
        FidLink: integer;
        FOnParentSave: TNotifyEvent;
        function GetidDocument: integer;
        procedure SetDocType(AValue: string);
        procedure SetidDocument(AValue: integer);
        procedure SetidLink(AValue: integer);
        procedure SetOnParentSave(AValue: TNotifyEvent);
        { private declarations }
    public
        { public declarations }
        PRocedure Clear;
        Procedure Populate;
        property idDocument: integer read GetidDocument write SetidDocument;
        property DocType: string read FDocType write SetDocType;
        property idLink: integer read FidLink write SetidLink;
        property OnParentSave: TNotifyEvent read FOnParentSave write SetOnParentSave;
    end;

implementation

uses Dialogs, dm_GenData, FMUtils, cls_Translation, frm_EditDocuments, frm_ShowImage, lclintf;

procedure UpdateDocumentInfo(const lidDocument: integer; const lDocumentInfo: string);
begin
    dmGenData.Query2.Close;
    dmGenData.Query2.SQL.Text := 'UPDATE X SET Z=:Z WHERE X.no=:idDocument';
    dmGenData.Query2.ParamByName('Z').AsString := lDocumentInfo;
    dmGenData.Query2.ParamByName('idDocument').AsInteger := lidDocument;
    dmGenData.Query2.ExecSQL;
end;

{$R *.lfm}

{ TfraDocuments }

procedure TfraDocuments.tblDocumentsResize(Sender: TObject);
begin
    tblDocuments.Columns[1].Width := tblDocuments.Width - GetTableColWidthSum(tblDocuments, 1);
end;

procedure TfraDocuments.actDocumentsEditExecute(Sender: TObject);
begin
    // Modifier un document à la source
    if tblDocuments.Row > 0 then
      begin
        //     dmGenData.PutCode(DocType,idDocument);
        frmEditDocuments.docType := docType;
        frmEditDocuments.idDocument := idDocument;
        frmEditDocuments.EditMode := eDEM_EditDocument;
        if frmEditDocuments.Showmodal = mrOk then
            dmGenData.PopulateDocuments(tblDocuments, DocType, idLink);
      end;
end;

procedure TfraDocuments.actDocumentsDeleteExecute(Sender: TObject);
begin
    // Supprimer un document à la source
    if tblDocuments.Row > 0 then
        if MessageDlg(SConfirmation,
            format(rsAreYouSureToDelX, [rsDocument, tblDocuments.Cells[2, tblDocuments.Row]])
            , mtConfirmation, mbYesNo, 0) = mrYes then
          begin
            dmGenData.DeleteDocument(idDocument);
            tblDocuments.DeleteRow(tblDocuments.Row);
          end;
end;

procedure TfraDocuments.actDocumentsAddExecute(Sender: TObject);
begin
    // fr: Ajouter un document à la source
    if (idLink = 0) and assigned(FOnParentSave) then
        FOnParentSave(Sender);
    if (idLink = 0) then
        exit;
    //dmGenData.PutCode(DocType,idLink);
    //dmGenData.PutCode('A',idLink);
    frmEditDocuments.docType := docType;
    frmEditDocuments.idLinkID := idLink;
    frmEditDocuments.EditMode := eDEM_AddDocument;
    if frmEditDocuments.Showmodal = mrOk then
        dmGenData.PopulateDocuments(tblDocuments, DocType, idLink);
end;

procedure TfraDocuments.actDocumentsDisplayExecute(Sender: TObject);
var
    lDocumentInfo: string;

begin
    // Visualiser un document de la source
    if tblDocuments.Row > 0 then
      begin
        dmGenData.Query2.SQL.Text := 'SELECT X.Z, X.F FROM X WHERE X.no=' + tblDocuments.Cells[0, tblDocuments.Row];
        dmGenData.Query2.Open;
        if tblDocuments.Cells[4, tblDocuments.Row] = Translation.Items[34] then
          begin
            frmShowImage.Caption := Translation.Items[34];
            frmShowImage.Image.Visible := False;
            frmShowImage.Memo.Visible := True;
            frmShowImage.btnOK.Visible := True;
            frmShowImage.btnCancel.Visible := True;
            frmShowImage.Memo.Text := dmGenData.Query2.Fields[0].AsString;
            lDocumentInfo := frmShowImage.Memo.Text;
            if (frmShowImage.Showmodal = mrOk) and (lDocumentInfo <> frmShowImage.Memo.Text) then
              begin
                // Only if the memo was changed
                lDocumentInfo := frmShowImage.Memo.Text;
                UpdateDocumentInfo(idDocument, lDocumentInfo);
              end;
          end
        else
        if uppercase(ExtractFileExt(dmGenData.Query2.Fields[1].AsString)) = '.PDF' then
              try
                OpenDocument(dmGenData.Query2.Fields[1].AsString);
              except

              end
        else
          begin
            frmShowImage.Caption := dmGenData.Query2.Fields[1].AsString;
            frmShowImage.Memo.Visible := False;
            frmShowImage.btnOK.Visible := False;
            frmShowImage.btnCancel.Visible := False;
            frmShowImage.Image.Visible := True;
            frmShowImage.Image.Picture.LoadFromFile(dmGenData.Query2.Fields[1].AsString);
            frmShowImage.Showmodal;
          end;
      end;
end;

function TfraDocuments.GetidDocument: integer;
begin
    Result := ptrint(tblDocuments.Objects[0, tblDocuments.Row]);
end;

procedure TfraDocuments.SetDocType(AValue: string);
begin
    if FDocType = AValue then
        Exit;
    FDocType := AValue;
end;

procedure TfraDocuments.SetidDocument(AValue: integer);
var
    idx: integer;
begin
    idx := tblDocuments.Cols[0].IndexOfObject(TObject(ptrint(AValue)));
    if idx >= 0 then
        tblDocuments.Row := idx;
end;

procedure TfraDocuments.SetidLink(AValue: integer);
begin
    if FidLink = AValue then
        Exit;
    FidLink := AValue;
end;

procedure TfraDocuments.SetOnParentSave(AValue: TNotifyEvent);
begin
    if @FOnParentSave = @AValue then
        Exit;
    FOnParentSave := AValue;
end;

procedure TfraDocuments.Clear;
begin
  tblDocuments.RowCount:=1;
end;

procedure TfraDocuments.Populate;
begin
  dmGenData.PopulateDocuments(tblDocuments,FDocType,FidLink);
end;

end.
