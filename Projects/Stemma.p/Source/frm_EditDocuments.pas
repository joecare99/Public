unit frm_EditDocuments;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Menus, Spin, Buttons, IniFiles, Process;

type
  TenumDocumentsEditMode=(
    eDEM_AddDocument,
    eDEM_EditDocument);
  { TfrmEditDocuments }

  TfrmEditDocuments = class(TForm)
    Button1: TBitBtn;
    btnDisplay: TButton;
    Button2: TBitBtn;
    edtidDocument: TSpinEdit;
    edtidLink: TSpinEdit;
    pnlBottom: TPanel;
    btnSelectFile: TSpeedButton;
    edtDocumentInfo: TMemo;
    lblDocumentDescription: TLabel;
    edtDescription: TMemo;
    lblFilename: TLabel;
    lblDocumentType: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    edtDocumentType: TEdit;
    OpenDialog: TOpenDialog;
    edtDocumentTitle: TEdit;
    lblDocumentsTitle: TLabel;
    chbDocumentPrefered: TCheckBox;
    lblDocuments1: TLabel;
    edtFilename: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure btnDisplayClick(Sender: TObject);
    procedure edtFilenameDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
  private
    FEditMode: TenumDocumentsEditMode;
    function GetdocType: String;
    function GetidDocument: integer;
    function GetidLinkID: integer;
    procedure SetdocType(AValue: String);
    procedure SetEditMode(AValue: TenumDocumentsEditMode);
    procedure SetidDocument(AValue: integer);
    procedure SetidLinkID(AValue: integer);
    { private declarations }
  public
    { public declarations }
    property EditMode:TenumDocumentsEditMode read FEditMode write SetEditMode;
    property docType:String read GetdocType write SetdocType;
    property idLinkID:integer read GetidLinkID write SetidLinkID;
    property idDocument:integer read GetidDocument write SetidDocument;
  end; 

var
  frmEditDocuments: TfrmEditDocuments;

implementation

uses
  frm_Main,cls_Translation, dm_GenData, frm_ShowImage, frm_Names;


{ TfrmEditDocuments }

procedure TfrmEditDocuments.FormShow(Sender: TObject);
var
   lDocumentTitle, lDocumentDescription, lFileName, lDocType,
    lDocumentInfo:string;

  lPrefered: Boolean;
begin
  frmEditDocuments.ActiveControl:=edtDocumentTitle;
  //dmGenData.GetCode(code,nocode);
  //edtidLink.Text:=nocode;
  if FEditMode=eDEM_AddDocument then
     begin
     Caption:=rsAddADocument;
     edtidDocument.Value:=0;
     edtDocumentTitle.text:='';
     edtDescription.Text:='';
     edtFilename.Text:='';
     chbDocumentPrefered.Checked:=false;
     edtDocumentInfo.Text:='';
     end
  else
     begin
     Caption:=rsDocumentModification;
//     edtidDocument.Value:=dmGenData.Query1.Fields[0].AsInteger;

     dmGenData.SelectDocumentData(idDocument,lPrefered,  lDocumentInfo, lDocType,
       lFileName, lDocumentDescription, lDocumentTitle);
     chbDocumentPrefered.Checked:=lPrefered;
edtDocumentTitle.Text:=lDocumentTitle;
edtDescription.Text:=lDocumentDescription;
edtFilename.Text:=lFileName;
edtDocumentType.Text:=lDocType;
edtDocumentInfo.Text:=lDocumentInfo;
  end;
end;

procedure TfrmEditDocuments.MenuItem1Click(Sender: TObject);
begin
  Button1Click(Sender);
  ModalResult:=mrOk;
end;

function TfrmEditDocuments.GetidDocument: integer;
begin
  result := edtidDocument.value;
end;

function TfrmEditDocuments.GetidLinkID: integer;
begin
  result:= edtidLink.Value;
end;

function TfrmEditDocuments.GetdocType: String;
begin
  result := edtDocumentType.Text;
end;

procedure TfrmEditDocuments.SetdocType(AValue: String);
begin
  if edtDocumentType.Text=AValue then Exit;
  edtDocumentType.Text:=AValue;
end;

procedure TfrmEditDocuments.SetEditMode(AValue: TenumDocumentsEditMode);
begin
  if FEditMode=AValue then Exit;
  FEditMode:=AValue;
end;

procedure TfrmEditDocuments.SetidDocument(AValue: integer);
begin
  if edtidDocument.value = AValue then exit;
  edtidDocument.value:= AValue;
end;

procedure TfrmEditDocuments.SetidLinkID(AValue: integer);
begin
  if edtidLink.Value=AValue then Exit;
  edtidLink.Value:=AValue;
end;

procedure TfrmEditDocuments.edtFilenameDblClick(Sender: TObject);
begin
  OpenDialog.FileName:=edtFilename.Text;
  OpenDialog.InitialDir:=ExtractFilePath(edtFilename.Text);
  if OpenDialog.Execute then
     edtFilename.Text:=OpenDialog.FileName;
end;

procedure TfrmEditDocuments.btnDisplayClick(Sender: TObject);
var
  ini:TIniFile;
  pdf:string;
  lImageMemoText: TCaption;
begin
  if length(edtFilename.Text)=0 then
     begin
     frmShowImage.Caption:=Translation.Items[34];
     frmShowImage.Image.Visible:=false;
     frmShowImage.Memo.Visible:=true;
     frmShowImage.btnOK.Visible:=true;
     frmShowImage.btnCancel.Visible:=true;
     if edtidDocument.text='0' then
        frmShowImage.Memo.Text:=''
     else
        frmShowImage.Memo.Text:=edtDocumentInfo.Text;
     if frmShowImage.Showmodal=mrOk then
        begin
        if edtidDocument.text='0' then
           Button1Click(Sender);

        lImageMemoText:=frmShowImage.Memo.Text;
        edtDocumentInfo.Text:=lImageMemoText;

        dmGenData.UpdateDocumentMemo(edtidDocument.Value, lImageMemoText);
        // Enregistrer la date de la dernière modification pour tout les individus reliés
        // à cet exhibits.
        if edtDocumentType.Text='I' then
           begin
           dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
        end;
        if edtDocumentType.Text='E' then
           begin
           dmGenData.UpdateModificationByEventDocument(edtidDocument.Value);
           frmNames.PopulateNom(Sender);
        end;
     end;
  end
  else
        begin
        if AnsiPos('.PDF',edtFilename.Text)>0 then
           begin
           Ini := TIniFile.Create(iniFileName);
           pdf := ini.ReadString('Parametres','PDF','C:\Program Files (x86)\Adobe\Reader 10.0\Reader\AcroRd32.exe');
           with TProcess.Create(nil) do
           try
              Parameters.text:=pdf+' '+edtFilename.Text;
              Execute;
              ini.WriteString('Parametres','PDF',pdf);
           finally
              Free;
           end;
           Ini.Free;
        end
        else
           begin
           frmShowImage.Caption:=edtFilename.Text;
           frmShowImage.Memo.Visible:=false;
           frmShowImage.btnOK.Visible:=false;
           frmShowImage.btnCancel.Visible:=false;
           frmShowImage.Image.Visible:=true;
           frmShowImage.Image.Picture.LoadFromFile(edtFilename.Text);
           frmShowImage.Showmodal;
        end;
     end;
end;

procedure TfrmEditDocuments.Button1Click(Sender: TObject);
var
  lDocumentTitle, lDocumentDescription, lFileName, lDocumentType: TCaption;
  lLinkID, lidDocument: Integer;
begin

  lDocumentTitle:=edtDocumentTitle.Text;
  lDocumentDescription:=edtDescription.Text;
  lFileName:=edtFilename.Text;
  lDocumentType:=edtDocumentType.text;
  lLinkID:=edtidLink.Value;
  lidDocument:=idDocument;
  idDocument:=dmGenData.SaveDocumentData(lidDocument, lLinkID, lDocumentType, lFileName,
    lDocumentDescription, lDocumentTitle);
  if lDocumentType='I' then
     begin
     dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
  end;
  if lDocumentType='E' then
     begin
       dmGenData.UpdateModificationByEventDocument(idDocument);
       frmNames.PopulateNom(Sender);
  end;
end;

{ TfrmEditDocuments }


{$R *.lfm}

end.

