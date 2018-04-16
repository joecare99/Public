unit frm_EditSource;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, Spin, Menus, fra_Documents, fra_Individual, LCLType,
  Buttons, ExtCtrls;

type
  TEnumSourceEditMode =
    (esem_EditExisting,
    esem_AddNew);
  { TfrmEditSource }

  TfrmEditSource = class(TForm)
    Ajouter1: TMenuItem;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    fraDocuments1: TfraDocuments;
    fraIndividualwithRole1: TfraIndividualwithRole;
    lblSourceQuality: TLabel;
    mnuSourceMain: TMainMenu;
    mniRepositories: TMenuItem;
    mniRepositoryAdd: TMenuItem;
    mniRepositoryEdit: TMenuItem;
    mniRepositoryDelete: TMenuItem;
    mniSourceClose: TMenuItem;
    mniSourceRepeat: TMenuItem;
    Modifier1: TMenuItem;
    edtNo: TSpinEdit;
    pnlBottom: TPanel;
    mnuDepotTable: TPopupMenu;
    edtQuality: TSpinEdit;
    Splitter1: TSplitter;
    Supprimer1: TMenuItem;
    edtSourceTitle: TEdit;
    lblSourceTitle: TLabel;
    lblSourceInformation: TLabel;
    lblRepository: TLabel;
    lblSourceDescription: TLabel;
    edtSourceInformation: TMemo;
    edtSourceDescription: TEdit;
    tblDepots: TStringGrid;
    procedure Ajouter1Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtSourceDescriptionKeyDown(Sender: TObject; var Key: word;
    {%H-}Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure edtSourceInformationEditingDone(Sender: TObject);
    procedure mniSourceRepeatClick(Sender: TObject);
    procedure Supprimer1Click(Sender: TObject);
    procedure tblDepotsDblClick(Sender: TObject);
    procedure tblDepotsEditingDone(Sender: TObject);
  private
    FEditMode: TEnumSourceEditMode;
    function GetID: longint;
    procedure SetEditMode(AValue: TEnumSourceEditMode);
    procedure SetidSource(AValue: longint);
    { private declarations }
  public
    { public declarations }
    property idSource: longint read GetID write SetidSource;
    property EditMode: TEnumSourceEditMode read FEditMode write SetEditMode;
  end;


var
  frmEditSource: TfrmEditSource;

implementation

uses
  frm_Main, frm_SelectDialog, cls_Translation, dm_GenData, LCLIntf;

{ TfrmEditSource }

procedure TfrmEditSource.FormShow(Sender: TObject);
var
  lIndLink, lTitle, lDescription, lInformation: string;

  tInt, lQuality, lidSource: longint;
begin
  ActiveControl := edtSourceTitle;
  frmStemmaMainForm.SetHistoryToActual(Sender);
  Caption := Translation.Items[190];
  btnOK.Caption := Translation.Items[152];
  btnCancel.Caption := Translation.Items[164];
  lblSourceInformation.Caption := Translation.Items[171];
  lblRepository.Caption := Translation.Items[193];
  fraIndividualwithRole1.Role := Translation.Items[191];
  lblSourceDescription.Caption := Translation.Items[162];
  lblSourceTitle.Caption := Translation.Items[179];
  lblSourceQuality.Caption := Translation.Items[192];
  tblDepots.Cells[1, 0] := Translation.Items[194];
  tblDepots.Cells[2, 0] := Translation.Items[156];

  Ajouter1.Caption := rsAdd;
  Modifier1.Caption := rsModify;
  Supprimer1.Caption := rsCmdDelete;

  mniRepositories.Caption := rsRepositories;
  mniRepositoryAdd.Caption := rsCmdUsageOf;
  mniRepositoryEdit.Caption := rsModify;
  mniRepositoryDelete.Caption := rsCmdDelete;

  fraDocuments1.DocType := 'S';

  // Populate la form
  if FEditMode = esem_AddNew then
  begin
    Caption := Translation.Items[43];
    edtSourceTitle.Text := '';
    edtSourceDescription.Text := '';
    fraIndividualwithRole1.idInd := 0;
    edtSourceInformation.Text := '';
    edtQuality.Value := 0;
    tblDepots.RowCount := 1;
    edtNo.Value := 0;
  end
  else
  begin
    lidSource := idSource;
    dmGenData.GetSourceData(lidSource, lQuality, lInformation, lDescription, lTitle,
      lIndLink);
    edtSourceTitle.Text := lTitle;
    edtSourceDescription.Text := lDescription;
    if TryStrToInt(lIndLink, tint) then
      fraIndividualwithRole1.idInd := tInt
    else
      fraIndividualwithRole1.IndName := lIndLink;
    edtSourceInformation.Text := lInformation;
    edtQuality.Value := lQuality;
    // Populate les dépots
    dmGenData.PopulateDepots(idSource, tblDepots);
    // Populate le tableau de documents
  end;
  fraDocuments1.idLink := idSource;
end;

procedure TfrmEditSource.edtSourceInformationEditingDone(Sender: TObject);
begin
  frmStemmaMainForm.AppendHistoryData('M', edtSourceInformation.Text);
end;

procedure TfrmEditSource.mniSourceRepeatClick(Sender: TObject);
var
  lsResult: string;
begin
  if ActiveControl.Name = edtSourceInformation.Name then
  begin
    lsResult := frmStemmaMainForm.RetreiveFromHistoy('M');
    if lsResult <> '' then
    begin
      edtSourceInformation.Text := lsResult;
      edtSourceInformationEditingDone(Sender);
    end;
  end;
end;

procedure TfrmEditSource.Supprimer1Click(Sender: TObject);
begin
  // Supprimer un Dépot
  if tblDepots.Row > 0 then
    if Application.MessageBox(PChar(Translation.Items[44] +
      tblDepots.Cells[1, tblDepots.Row] + Translation.Items[28]),
      PChar(SConfirmation), MB_YESNO) = idYes then
    begin
      dmGenData.DeleteSourceLink(ptrint(tblDepots.Objects[0, tblDepots.Row]));
      tblDepots.DeleteRow(tblDepots.Row);
    end;
end;

procedure TfrmEditSource.tblDepotsDblClick(Sender: TObject);
var
  d: integer;
  lstl: TStrings;
  lTitle: string;
begin
  // modification d'un dépot
  if tblDepots.Row > 0 then
  begin
    d := ptrint(tblDepots.Objects[3, tblDepots.Row]);
    lstl := TStringList.Create;
    dmGenData.FillDepotsSL(lStL);
    try
      if SelectDialog(Translation.Items[45], Translation.Items[46], lstl, d) then
      begin
        lTitle := dmGenData.GetDepotTitle(d);
        if lTitle <> '' then
        begin
          tblDepots.Cells[1, tblDepots.Row] := lTitle;
          tblDepots.Cells[3, tblDepots.Row] := IntToStr(d);
          tblDepots.Objects[3, tblDepots.Row] := TObject(ptrint(d));
          tblDepotsEditingDone(Sender);
          dmGenData.PopulateDepots(idSource, tblDepots);
        end;
      end;

    finally
      FreeAndNil(lstl);
    end;
  end;

end;

procedure TfrmEditSource.Ajouter1Click(Sender: TObject);
var
  d: integer;
  lStL: TStrings;
  lTitle: string;
begin
  // Ajouter un dépot
  d := 0;
  lstl := TStringList.Create;
  dmGenData.FillDepotsSL(lStL);
  try
    if SelectDialog(Translation.Items[47], Translation.Items[46], lStL, d) then
      lTitle := dmGenData.GetDepotTitle(d);
    if lTitle <> '' then
    begin
      tblDepots.RowCount := tblDepots.RowCount + 1;
      tblDepots.Row := tblDepots.RowCount;
      tblDepots.Cells[0, tblDepots.Row] := '0';
      tblDepots.Objects[0, tblDepots.Row] := TObject(ptrint(0));
      tblDepots.Cells[1, tblDepots.Row] := lTitle;
      tblDepots.Cells[2, tblDepots.Row] := '';
      tblDepots.Cells[3, tblDepots.Row] := IntToStr(d);
      tblDepots.Objects[3, tblDepots.Row] := TObject(ptrint(d));
      tblDepotsEditingDone(Sender);
      dmGenData.PopulateDepots(idSource, tblDepots);
    end;
  finally
    FreeAndNil(lStL);
  end;
end;

procedure TfrmEditSource.btnOKClick(Sender: TObject);
var
  lsAuthor: string;

begin
  if fraIndividualwithRole1.idInd > 0 then
    lsAuthor := IntToStr(fraIndividualwithRole1.idInd)
  else
    lsAuthor := fraIndividualwithRole1.IndName;

  edtNo.Value := dmGenData.SaveSourceData(idSource, edtQuality.Value, edtSourceTitle.Text,
    edtSourceDescription.Text, edtSourceInformation.Text, lsAuthor);

end;

procedure TfrmEditSource.edtSourceDescriptionKeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  if Key = VK_F3 then
    edtSourceDescription.Text := edtSourceTitle.Text;
end;


procedure TfrmEditSource.tblDepotsEditingDone(Sender: TObject);
var
  lidSource: longint;
  lidSourceDepot, lidRepository: integer;
  lMemoText: string;
begin
  if edtNo.Text = '0' then
    btnOKClick(Sender);
  lidSource := idSource;
  lidSourceDepot := PtrInt(tblDepots.Objects[0, tblDepots.Row]);
  lidRepository := PtrInt(tblDepots.Objects[3, tblDepots.Row]);
  lMemoText := tblDepots.Cells[2, tblDepots.Row];
  lidSourceDepot := dmGenData.SaveSourceRepositoryData(lidSourceDepot, lMemoText,
    lidRepository, lidSource);
  tblDepots.Objects[0, tblDepots.Row] := TObject(ptrint(lidSourceDepot));
  tblDepots.Cells[0, tblDepots.Row] := IntToStr(lidSourceDepot);
end;

function TfrmEditSource.GetID: longint;
begin
  Result := edtNo.Value;
end;

procedure TfrmEditSource.SetEditMode(AValue: TEnumSourceEditMode);
begin
  if FEditMode = AValue then
    Exit;
  FEditMode := AValue;
end;

procedure TfrmEditSource.SetidSource(AValue: longint);
begin
  if (GetID = AValue) then
    exit;
  edtNo.Value := AValue;
end;

{ TfrmEditSource }


{$R *.lfm}

end.
