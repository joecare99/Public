unit frm_EditCitations;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, Menus, ExtCtrls, Buttons, fra_Memo;

type
  enumCitationEditType = (
    eCET_EditExisting,
    eCET_New);
  { TEditCitations }

  TEditCitations = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    fraMemo1: TfraMemo;
    lblSource: TLabel;
    lblQuality: TLabel;
    MainMenu1: TMainMenu;
    mniCitationQuit: TMenuItem;
    mniCitationRepeat: TMenuItem;
    edtLinkID: TSpinEdit;
    edtidCitation: TSpinEdit;
    pnlBottom: TPanel;
    edtSourceID: TSpinEdit;
    cbxSource: TComboBox;
    edtQuality: TSpinEdit;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mniCitationQuitClick(Sender: TObject);
    procedure mniCitationRepeatClick(Sender: TObject);
    procedure edtSourceIDEditingDone(Sender: TObject);
    procedure cbxSourceEditingDone(Sender: TObject);
  private
    FEditType: enumCitationEditType;
    FTypeCode: string;
    function GetidCitation: integer;
    function GetidLink: integer;
    procedure SetEditType(AValue: enumCitationEditType);
    procedure SetidCitation(AValue: integer);
    procedure SetidLink(AValue: integer);
    procedure SetTypeCode(AValue: string);
    { private declarations }
  public
    { public declarations }
    property EditType: enumCitationEditType read FEditType write SetEditType;
    property TypeCode: string read FTypeCode write SetTypeCode;
    property idCitation: integer read GetidCitation write SetidCitation;
    property idLink: integer read GetidLink write SetidLink;
  end;

var
  EditCitations: TEditCitations;

implementation

uses
  frm_Main, cls_Translation, dm_GenData;

{$R *.lfm}

{ TEditCitations }

procedure TEditCitations.FormShow(Sender: TObject);
var
  lidCitation: integer;
  lMemoText, lTypeCode: string;
  LStr: TStrings;
  lidSource, lLinkID, lQuality: integer;
begin
  EditCitations.ActiveControl := edtSourceID;
  frmStemmaMainForm.SetHistoryToActual(Sender);
  Caption := Translation.Items[160];
  lblSource.Caption := Translation.Items[161];
  fraMemo1.lblMemo.Caption := Translation.Items[162];
  lblQuality.Caption := Translation.Items[163];
  btnOK.Caption := Translation.Items[152];
  btnCancel.Caption := Translation.Items[164];
  // Populate Citations
  // GET TYPE AND edtidCitation FROM CALLER
  // Populate le ComboBox
  LStr := cbxSource.Items;
  dmgendata.FillSourcesSL(LStr);
  // Populate la form
  //   dmGenData.GetCode(codex,nocode);
  if FEditType = eCET_New then
   begin
    EditCitations.Caption := Translation.Items[29];
    edtidCitation.Value := 0;
    cbxSource.ItemIndex := 0;
    fraMemo1.Text := '';
    //      dmGenData.GetCode(codex,nocode)
    edtQuality.Value := 0;
    edtSourceID.Value := 0;
   end
  else
   begin
    lidCitation := idCitation;
    dmgendata.GetCitationData(lidCitation, lTypeCode, lLinkID,
      lMemoText, lidSource, lQuality);
    cbxSource.ItemIndex := cbxSource.Items.IndexOfObject(TObject(ptrint(lidSource)));
    fraMemo1.Text := lMemoText;
    FTypeCode := lTypeCode;
    edtLinkID.Value := lLinkID;
    edtQuality.Value := lQuality;
    if cbxSource.ItemIndex >= 0 then
      edtSourceID.Value := ptrint(cbxSource.Items.Objects[cbxSource.ItemIndex]);
   end;
end;

procedure TEditCitations.mniCitationQuitClick(Sender: TObject);
begin
  btnOKClick(Sender);
  ModalResult := mrOk;
end;

procedure TEditCitations.mniCitationRepeatClick(Sender: TObject);
var
  temp, lResult: string;
begin
  lResult := frmStemmaMainForm.RetreiveFromHistoy('R');
  if lResult <> '' then
   begin
    edtSourceID.Text := copy(lResult, 1, AnsiPos('|', lResult) - 1);
    edtSourceIDEditingDone(Sender);
    temp := copy(lResult, AnsiPos('|', lResult) + 1, length(lResult));
    fraMemo1.Text := copy(temp, 1, AnsiPos('|', temp) - 1);
    temp := copy(temp, AnsiPos('|', temp) + 1, length(temp));
    edtQuality.Value := StrToInt(copy(temp, 1, length(temp)));
   end;
end;

procedure TEditCitations.edtSourceIDEditingDone(Sender: TObject);

begin
  if edtSourceID.Value > 0 then
   begin
    cbxSource.ItemIndex := cbxSource.Items.IndexOfObject(
      TObject(ptrint(edtSourceID.Value)));
   end;
end;

procedure TEditCitations.cbxSourceEditingDone(Sender: TObject);

begin
  edtSourceID.Value := ptrint(cbxSource.Items.Objects[cbxSource.ItemIndex]);
  edtQuality.Value := dmGenData.GetSourceQuality(edtSourceID.Value);
end;

procedure TEditCitations.SetEditType(AValue: enumCitationEditType);
begin
  if FEditType = AValue then
    Exit;
  FEditType := AValue;
end;

function TEditCitations.GetidCitation: integer;
begin
  Result := edtidCitation.Value;
end;

function TEditCitations.GetidLink: integer;
begin
  Result := edtLinkID.Value;
end;

procedure TEditCitations.SetidCitation(AValue: integer);
begin
  if edtidCitation.Value = AValue then
    exit;
  edtidCitation.Value := AValue;
end;

procedure TEditCitations.SetidLink(AValue: integer);
begin
  if edtLinkID.Value = AValue then
    Exit;
  edtLinkID.Value := AValue;
end;

procedure TEditCitations.SetTypeCode(AValue: string);
begin
  if FTypeCode = AValue then
    Exit;
  FTypeCode := AValue;
end;

procedure TEditCitations.btnOKClick(Sender: TObject);
var
  lTypeCode: string;
  lLinkID, lidCitation, lQuality: integer;
  lidSource: PtrInt;
  lMemoText: string;
begin
  lidCitation := edtidCitation.Value;
  lTypeCode := FTypeCode;
  lLinkID := edtLinkID.Value;
  lMemoText := fraMemo1.Text;
  lidSource := ptrint(cbxSource.Items.Objects[cbxSource.ItemIndex]);
  lQuality := edtQuality.Value;

  edtidCitation.Value := dmGenData.SaveCitationData(lidCitation, lTypeCode,
    lLinkID, lMemoText, lidSource, lQuality);

  // Sauvegarder les dates de modifications ??
  case FTypeCode of
    'R': dmGenData.UpdateIndModificationTimesByRelation(lLinkID);
    'N': dmGenData.UpdateIndModificationTimeByName(lLinkID);
    'E': dmGenData.UpdateIndModificationTimesByEvent(lLinkID);
    else;
   end;

  frmStemmaMainForm.AppendHistoryData('R', IntToStr(lidSource) + '|' +
    lMemoText + '|' + IntToStr(lQuality));
end;

end.
