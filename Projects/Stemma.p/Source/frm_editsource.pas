unit frm_EditSource;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, Spin, Menus, fra_Documents, fra_Individual, StrUtils, LCLType,
  Buttons, ExtCtrls;

type
  TEnumSourceEditMode=
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
    procedure edtSourceDescriptionKeyDown(Sender: TObject; var Key: Word; {%H-}Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure edtSourceInformationEditingDone(Sender: TObject);
    procedure mniSourceRepeatClick(Sender: TObject);
    procedure Supprimer1Click(Sender: TObject);
    procedure TableauDepotsDblClick(Sender: TObject);
    procedure TableauDepotsEditingDone(Sender: TObject);
  private
    FEditMode: TEnumSourceEditMode;
    function GetID: LongInt;
    procedure SetEditMode(AValue: TEnumSourceEditMode);
    procedure SetidSource(AValue: LongInt);
    { private declarations }
  public
    { public declarations }
    property idSource:LongInt read GetID write SetidSource;
    Property EditMode:TEnumSourceEditMode read FEditMode write SetEditMode;
  end; 

procedure PopulateDepots;

var
  frmEditSource: TfrmEditSource;

implementation

uses
  frm_Main, cls_Translation, dm_GenData, LCLIntf;

procedure GetSourceData(const lidSource: LongInt; out lQuality: LongInt;
  out lInformation: string; out lDescription: string; out lTitle: string;
  out lIndLink: string);
begin
  with dmGenData.Query1 do begin
  Close;
    SQL.text:='SELECT S.no, S.T, S.D, S.M, S.Q, S.A FROM S WHERE S.no=:idSource';
    ParamByName('idSource').AsInteger:=lidSource;
    Open;
    First;

    lTitle:=Fields[1].AsString;
    lDescription:=Fields[2].AsString;
    lIndLink:=Fields[5].AsString;
    lInformation:=Fields[3].AsString;
    lQuality:=Fields[4].AsInteger;
    Close;
  end;
end;


{ TfrmEditSource }

procedure PopulateDepots;
var
  i:integer;
begin
     // Populate les dépots
     dmGenData.Query1.SQL.Text:='SELECT A.no, A.S, A.D, A.M, D.T FROM A JOIN D ON D.no=A.D WHERE A.S='+frmEditSource.no.text;
     dmGenData.Query1.Open;
     dmGenData.Query1.First;
     frmEditSource.TableauDepots.RowCount:=dmGenData.Query1.RecordCount+1;
     i:=1;
     while not dmGenData.Query1.eof do
        begin
        frmEditSource.TableauDepots.Cells[0,i]:=dmGenData.Query1.Fields[0].AsString;
        frmEditSource.TableauDepots.Cells[1,i]:=dmGenData.Query1.Fields[4].AsString;
        frmEditSource.TableauDepots.Cells[2,i]:=dmGenData.Query1.Fields[3].AsString;
        frmEditSource.TableauDepots.Cells[3,i]:=dmGenData.Query1.Fields[2].AsString;
        dmGenData.Query1.Next;
        i:=i+1;
     end;
end;

procedure TfrmEditSource.FormShow(Sender: TObject);
var
  lIndLink, lTitle, lDescription, lInformation:string;

  tInt, lQuality, lidSource: LongInt;
begin
  ActiveControl:=edtSourceTitle;
  frmStemmaMainForm.SetHistoryToActual(Sender);
  Caption:=Translation.Items[190];
  btnOK.Caption:=Translation.Items[152];
  btnCancel.Caption:=Translation.Items[164];
  lblSourceInformation.Caption:=Translation.Items[171];
  lblRepository.Caption:=Translation.Items[193];
  fraIndividualwithRole1.Role:=Translation.Items[191];
  lblSourceDescription.Caption:=Translation.Items[162];
  lblSourceTitle.Caption:=Translation.Items[179];
  lblSourceQuality.Caption:=Translation.Items[192];
  TableauDepots.Cells[1,0]:=Translation.Items[194];
  TableauDepots.Cells[2,0]:=Translation.Items[156];

  Ajouter1.Caption:=rsAdd;
  Modifier1.Caption:=rsModify;
  Supprimer1.Caption:=rsCmdDelete;

  mniRepositories.Caption:=rsRepositories;
  mniRepositoryAdd.Caption:=rsCmdUsageOf;
  mniRepositoryEdit.Caption:=rsModify;
  mniRepositoryDelete.Caption:=rsCmdDelete;

  fraDocuments1.DocType:='S';

  // Populate la form
  dmGenData.Query1.SQL.Clear;

  if FEditMode=esem_AddNew then
     begin
     Caption:=Translation.Items[43];
     edtSourceTitle.Text:='';
     edtSourceDescription.Text:='';
     fraIndividualwithRole1.idInd:=0;
     edtSourceInformation.Text:='';
     Q.Value:=0;
     TableauDepots.RowCount:=1;
     No.Value:=0;
  end
  else
     begin
     lidSource:=idSource;
     GetSourceData(lidSource, lQuality, lInformation, lDescription, lTitle,
       lIndLink);
     edtSourceTitle.Text:=lTitle;
     edtSourceDescription.Text:=lDescription;
     if TryStrToInt(lIndLink,tint) then
        fraIndividualwithRole1.idInd:=tInt
     else
        fraIndividualwithRole1.IndName:=lIndLink;
     edtSourceInformation.Text:=lInformation;
     Q.Value:=lQuality;
     // Populate les dépots
     PopulateDepots;
     // Populate le tableau de documents
  end;
  fraDocuments1.idLink:=idSource;
end;

procedure TfrmEditSource.edtSourceInformationEditingDone(Sender: TObject);
begin
  frmStemmaMainForm.AppendHistoryData('M',edtSourceInformation.Text);
end;

procedure TfrmEditSource.mniSourceRepeatClick(Sender: TObject);
var
  lsResult: String;
begin
    if ActiveControl.Name = edtSourceInformation.Name then
   begin
    lsResult := frmStemmaMainForm.RetreiveFromHistoy('M');
    if lsResult <> '' then
     begin
      edtSourceInformation.Text := lsResult;
      edtSourceInformationEditingDone(Sender);
     end;
   end
end;

procedure TfrmEditSource.Supprimer1Click(Sender: TObject);
begin
  // Supprimer un Dépot
  if TableauDepots.Row>0 then
     if Application.MessageBox(Pchar(Translation.Items[44]+
        TableauDepots.Cells[1,TableauDepots.Row]+Translation.Items[28]),pchar(SConfirmation),MB_YESNO)=IDYES then
        begin
        dmGenData.Query1.SQL.Text:='DELETE FROM A WHERE no='+TableauDepots.Cells[0,TableauDepots.Row];
        dmGenData.Query1.ExecSQL;
        TableauDepots.DeleteRow(TableauDepots.Row);
     end;
end;

procedure TfrmEditSource.TableauDepotsDblClick(Sender: TObject);
var
  d:string;
begin
  // modification d'un dépot
  if TableauDepots.Row>0 then
     begin
     d:='0';
     if InputQuery(Translation.Items[45],Translation.Items[46],d) then
        begin
        dmGenData.Query1.SQL.Text:='SELECT D.T FROM D WHERE D.no='+d;
        dmGenData.Query1.Open;
        dmGenData.Query1.First;
        if not dmGenData.Query1.EOF then
           begin
           TableauDepots.Cells[1,TableauDepots.Row]:=dmGenData.Query1.Fields[0].AsString;
           TableauDepots.Cells[3,TableauDepots.Row]:=d;
           TableauDepotsEditingDone(Sender);
           PopulateDepots;
        end;
     end;
  end;
end;

procedure TfrmEditSource.Ajouter1Click(Sender: TObject);
var
  d:string;
begin
  // Ajouter un dépot
  d:='0';
  if InputQuery(Translation.Items[47],Translation.Items[46],d) then
     begin
     dmGenData.Query1.SQL.Text:='SELECT D.T FROM D WHERE D.no='+d;
     dmGenData.Query1.Open;
     dmGenData.Query1.First;
     if not dmGenData.Query1.EOF then
        begin
        TableauDepots.RowCount:=TableauDepots.RowCount+1;
        TableauDepots.Row:=TableauDepots.RowCount;
        TableauDepots.Cells[0,TableauDepots.Row]:='0';
        TableauDepots.Cells[1,TableauDepots.Row]:=dmGenData.Query1.Fields[0].AsString;
        TableauDepots.Cells[2,TableauDepots.Row]:='';
        TableauDepots.Cells[3,TableauDepots.Row]:=d;
        TableauDepotsEditingDone(Sender);
        PopulateDepots;
     end;
  end;
end;

procedure TfrmEditSource.btnOKClick(Sender: TObject);
var
  lsAuthor :string;

begin
  if fraIndividualwithRole1.idInd>0 then
    lsAuthor:=IntToStr(fraIndividualwithRole1.idInd)
  else
    lsAuthor:=fraIndividualwithRole1.IndName;

  no.Value :=dmGenData.SaveSourceData(idSource, Q.Value, edtSourceTitle.text, edtSourceDescription.text,
    edtSourceInformation.text, lsAuthor);

end;

procedure TfrmEditSource.edtSourceDescriptionKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_F3 then
     edtSourceDescription.Text:=edtSourceTitle.Text;
end;


procedure TfrmEditSource.TableauDepotsEditingDone(Sender: TObject);
begin
  if no.text='0' then
     btnOKClick(Sender);
  dmGenData.Query1.SQL.Clear;
  if TableauDepots.Cells[0,TableauDepots.Row]='0' then
     dmGenData.Query1.SQL.Add('INSERT INTO A (S, D, M) VALUES ('+No.Text+', '+
        AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(TableauDepots.Cells[3,TableauDepots.Row]),'\','\\'),'"','\"'),'''','\''')+', '''+
        AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(TableauDepots.Cells[2,TableauDepots.Row]),'\','\\'),'"','\"'),'''','\''')+
        ''')')
  else
     dmGenData.Query1.SQL.Add('UPDATE A SET M='''+
        AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(TableauDepots.Cells[2,TableauDepots.Row]),'\','\\'),'"','\"'),'''','\''')+
        ''', D='+TableauDepots.Cells[3,TableauDepots.Row]+
        ' WHERE no='+TableauDepots.Cells[0,TableauDepots.Row]);
  dmGenData.Query1.ExecSQL;
  if TableauDepots.Cells[0,TableauDepots.Row]='0' then
     begin
     TableauDepots.Cells[0,TableauDepots.Row]:=InttoStr(dmGenData.GetLastIDOfTable('A'));
  end;
end;

function TfrmEditSource.GetID: LongInt;
begin
  result := no.Value;
end;

procedure TfrmEditSource.SetEditMode(AValue: TEnumSourceEditMode);
begin
  if FEditMode=AValue then Exit;
  FEditMode:=AValue;
end;

procedure TfrmEditSource.SetidSource(AValue: LongInt);
begin
  if (GetID = AValue) then exit;
  no.Value:=AValue;
end;

{ TfrmEditSource }


{$R *.lfm}

end.

