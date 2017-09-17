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
    No: TSpinEdit;
    pnlBottom: TPanel;
    PopupMenu2: TPopupMenu;
    Q: TSpinEdit;
    Splitter1: TSplitter;
    Supprimer1: TMenuItem;
    edtSourceTitle: TEdit;
    lblSourceTitle: TLabel;
    lblSourceInformation: TLabel;
    lblRepository: TLabel;
    lblSourceDescription: TLabel;
    edtSourceInformation: TMemo;
    edtSourceDescription: TEdit;
    TableauDepots: TStringGrid;
    procedure Ajouter1Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtSourceDescriptionKeyDown(Sender: TObject; var Key: word;
    {%H-}Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure edtSourceInformationEditingDone(Sender: TObject);
    procedure mniSourceRepeatClick(Sender: TObject);
    procedure Supprimer1Click(Sender: TObject);
    procedure TableauDepotsDblClick(Sender: TObject);
    procedure TableauDepotsEditingDone(Sender: TObject);
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

procedure GetSourceData(const lidSource: longint; out lQuality: longint;
  out lInformation: string; out lDescription: string; out lTitle: string;
  out lIndLink: string);
begin
  with dmGenData.Query1 do
  begin
    Close;
    SQL.Text := 'SELECT S.no, S.T, S.D, S.M, S.Q, S.A FROM S WHERE S.no=:idSource';
    ParamByName('idSource').AsInteger := lidSource;
    Open;
    First;
    lTitle := Fields[1].AsString;
    lDescription := Fields[2].AsString;
    lIndLink := Fields[5].AsString;
    lInformation := Fields[3].AsString;
    lQuality := Fields[4].AsInteger;
    Close;
  end;
end;

function SaveSourceRepositoryData(lidSourceDepot: integer; const lMemoText: string;
  const lidRepository: integer; const lidSource: longint): integer;
begin
  with dmGenData.Query1 do
  begin
    Close;
    if lidSourceDepot = 0 then
    begin
      SQL.Text := 'INSERT INTO A (S, D, M) VALUES (:idSource, :idRepository, :Memo)';
      ParamByName('idSource').AsInteger := lidSource;
    end
    else
    begin
      SQL.Text := 'UPDATE A SET M=:Memo, D=:idRepository WHERE no=:idSourceDepot';
      ParamByName('idSourceDepot').AsInteger := lidSourceDepot;
    end;
    ParamByName('Memo').AsString := lMemoText;
    ParamByName('idRepository').AsInteger := lidRepository;
    ExecSQL;
  end;

  if lidSourceDepot = 0 then
    Result := dmGenData.GetLastIDOfTable('A')
  else
    Result := lidSourceDepot;
end;

function GetDepotTitle(var d: integer): string;
var
  lTitle: string;
begin
  with dmGenData.Query1 do
  begin

    SQL.Text := 'SELECT D.T FROM D WHERE D.no=:idDepot';
    ParamByName('idDepot').AsInteger := d;
    Open;
    First;
    if not EOF then
      lTitle := Fields[0].AsString
    else
      lTitle := '';
  end;
  Result := lTitle;
end;


{ TfrmEditSource }

procedure PopulateDepots(lidSource: integer; const lTblDepots: TStringGrid);
var
  i: integer;

begin
  // Populate les dépots
  with dmGenData.Query1 do
  begin
    Close;
    SQL.Text :=
      'SELECT A.no, A.S, A.D, A.M, D.T FROM A JOIN D ON D.no=A.D WHERE A.S=:idsource';
    ParamByName('idSource').AsInteger := lidSource;
    Open;
    First;
    lTblDepots.RowCount := RecordCount + 1;
    i := 1;
    while not EOF do
    begin
      lTblDepots.Objects[0, i] := TObject(ptrint(Fields[0].AsInteger));
      lTblDepots.Cells[0, i] := Fields[0].AsString;
      lTblDepots.Cells[1, i] := Fields[4].AsString;
      lTblDepots.Cells[2, i] := Fields[3].AsString;
      lTblDepots.Objects[3, i] := TObject(ptrint(Fields[2].AsInteger));
      lTblDepots.Cells[3, i] := Fields[2].AsString;
      Next;
      i := i + 1;
    end;
    Close;
  end;
end;

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
  TableauDepots.Cells[1, 0] := Translation.Items[194];
  TableauDepots.Cells[2, 0] := Translation.Items[156];

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
    Q.Value := 0;
    TableauDepots.RowCount := 1;
    No.Value := 0;
  end
  else
  begin
    lidSource := idSource;
    GetSourceData(lidSource, lQuality, lInformation, lDescription, lTitle,
      lIndLink);
    edtSourceTitle.Text := lTitle;
    edtSourceDescription.Text := lDescription;
    if TryStrToInt(lIndLink, tint) then
      fraIndividualwithRole1.idInd := tInt
    else
      fraIndividualwithRole1.IndName := lIndLink;
    edtSourceInformation.Text := lInformation;
    Q.Value := lQuality;
    // Populate les dépots
    PopulateDepots(idSource, TableauDepots);
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
  if TableauDepots.Row > 0 then
    if Application.MessageBox(PChar(Translation.Items[44] +
      TableauDepots.Cells[1, TableauDepots.Row] + Translation.Items[28]),
      PChar(SConfirmation), MB_YESNO) = idYes then
    begin
      dmGenData.Query1.SQL.Text :=
        'DELETE FROM A WHERE no=' + TableauDepots.Cells[0, TableauDepots.Row];
      dmGenData.Query1.ExecSQL;
      TableauDepots.DeleteRow(TableauDepots.Row);
    end;
end;

procedure TfrmEditSource.TableauDepotsDblClick(Sender: TObject);
var
  d: integer;
  lstl: TStrings;
  lTitle: string;
begin
  // modification d'un dépot
  if TableauDepots.Row > 0 then
  begin
    d := ptrint(TableauDepots.Objects[3, TableauDepots.Row]);
    lstl := TStringList.Create;
    dmGenData.FillDepotsSL(lStL);
    try
      if SelectDialog(Translation.Items[45], Translation.Items[46], lstl, d) then
      begin
        lTitle := GetDepotTitle(d);
        if lTitle <> '' then
        begin
          TableauDepots.Cells[1, TableauDepots.Row] := lTitle;
          TableauDepots.Cells[3, TableauDepots.Row] := IntToStr(d);
          TableauDepots.Objects[3, TableauDepots.Row] := TObject(ptrint(d));
          TableauDepotsEditingDone(Sender);
          PopulateDepots(idSource, TableauDepots);
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
      lTitle := GetDepotTitle(d);
    if lTitle <> '' then
    begin
      TableauDepots.RowCount := TableauDepots.RowCount + 1;
      TableauDepots.Row := TableauDepots.RowCount;
      TableauDepots.Cells[0, TableauDepots.Row] := '0';
      TableauDepots.Objects[0, TableauDepots.Row] := TObject(ptrint(0));
      TableauDepots.Cells[1, TableauDepots.Row] := lTitle;
      TableauDepots.Cells[2, TableauDepots.Row] := '';
      TableauDepots.Cells[3, TableauDepots.Row] := IntToStr(d);
      TableauDepots.Objects[3, TableauDepots.Row] := TObject(ptrint(d));
      TableauDepotsEditingDone(Sender);
      PopulateDepots(idSource, TableauDepots);
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

  no.Value := dmGenData.SaveSourceData(idSource, Q.Value, edtSourceTitle.Text,
    edtSourceDescription.Text, edtSourceInformation.Text, lsAuthor);

end;

procedure TfrmEditSource.edtSourceDescriptionKeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  if Key = VK_F3 then
    edtSourceDescription.Text := edtSourceTitle.Text;
end;


procedure TfrmEditSource.TableauDepotsEditingDone(Sender: TObject);
var
  lidSource: longint;
  lidSourceDepot, lidRepository: integer;
  lMemoText: string;
begin
  if no.Text = '0' then
    btnOKClick(Sender);
  lidSource := idSource;
  lidSourceDepot := PtrInt(TableauDepots.Objects[0, TableauDepots.Row]);
  lidRepository := PtrInt(TableauDepots.Objects[3, TableauDepots.Row]);
  lMemoText := TableauDepots.Cells[2, TableauDepots.Row];
  lidSourceDepot := SaveSourceRepositoryData(lidSourceDepot, lMemoText,
    lidRepository, lidSource);
  TableauDepots.Objects[0, TableauDepots.Row] := TObject(ptrint(lidSourceDepot));
  TableauDepots.Cells[0, TableauDepots.Row] := IntToStr(lidSourceDepot);
end;

function TfrmEditSource.GetID: longint;
begin
  Result := no.Value;
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
  no.Value := AValue;
end;

{ TfrmEditSource }


{$R *.lfm}

end.
