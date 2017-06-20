unit frm_EditSource;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, Spin, Menus, FMUtils, fra_Documents, fra_Individual, StrUtils, LCLType,
  Buttons, ExtCtrls, Process, IniFiles;

type
  TEnumSourceEditMode=
    (esem_EditExisting,
     esem_AddNew);
  { TEditSource }

  TEditSource = class(TForm)
    Ajouter1: TMenuItem;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    fraDocuments1: TfraDocuments;
    fraIndividualwithRole1: TfraIndividualwithRole;
    lblSourceQuality: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    Modifier1: TMenuItem;
    No: TSpinEdit;
    pnlBottom: TPanel;
    PopupMenu2: TPopupMenu;
    Q: TSpinEdit;
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
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure Supprimer1Click(Sender: TObject);
    procedure TableauDepotsDblClick(Sender: TObject);
    procedure TableauDepotsEditingDone(Sender: TObject);
  private
    function GetID: LongInt;
    { private declarations }
  public
    { public declarations }
    property idSource:LongInt read GetID;
  end; 

procedure PopulateDepots;

var
  EditSource: TEditSource;

implementation

uses
  frm_Main, cls_Translation, dm_GenData, frm_Sources, frm_Usage, frm_Documents, frm_ShowImage,
  frm_EditDocuments;

{ TEditSource }

procedure PopulateDepots;
var
  i:integer;
begin
     // Populate les dépots
     dmGenData.Query1.SQL.Text:='SELECT A.no, A.S, A.D, A.M, D.T FROM A JOIN D ON D.no=A.D WHERE A.S='+EditSource.no.text;
     dmGenData.Query1.Open;
     dmGenData.Query1.First;
     EditSource.TableauDepots.RowCount:=dmGenData.Query1.RecordCount+1;
     i:=1;
     while not dmGenData.Query1.eof do
        begin
        EditSource.TableauDepots.Cells[0,i]:=dmGenData.Query1.Fields[0].AsString;
        EditSource.TableauDepots.Cells[1,i]:=dmGenData.Query1.Fields[4].AsString;
        EditSource.TableauDepots.Cells[2,i]:=dmGenData.Query1.Fields[3].AsString;
        EditSource.TableauDepots.Cells[3,i]:=dmGenData.Query1.Fields[2].AsString;
        dmGenData.Query1.Next;
        i:=i+1;
     end;
end;

procedure TEditSource.FormShow(Sender: TObject);
var
  temp, code, nocode:string;
  auteur:boolean;
  tInt: LongInt;
begin
  ActiveControl:=edtSourceTitle;
  frmStemmaMainForm.DataHist.Row:=0;
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

  Ajouter1.Caption:=Translation.Items[224];
  Modifier1.Caption:=Translation.Items[225];
  Supprimer1.Caption:=Translation.Items[226];

  MenuItem1.Caption:=Translation.Items[233];
  MenuItem2.Caption:=Translation.Items[224];
  MenuItem3.Caption:=Translation.Items[225];
  MenuItem4.Caption:=Translation.Items[226];
  fraDocuments1.DocType:='S';

  // Populate la form
  dmGenData.Query1.SQL.Clear;
  dmGenData.GetCode(Code,nocode);
  if code='A' then
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
     if code='S' then
        dmGenData.Query1.SQL.Add('SELECT S.no, S.T, S.D, S.M, S.Q, S.A FROM S WHERE S.no='+
                                     FormSources.TableauSources.Cells[1,FormSources.TableauSources.Row])
     else
        dmGenData.Query1.SQL.Add('SELECT S.no, S.T, S.D, S.M, S.Q, S.A FROM S WHERE S.no='+
                                     frmEventUsage.TableauUtilisation.Cells[0,frmEventUsage.TableauUtilisation.Row]);
     dmGenData.Query1.Open;
     dmGenData.Query1.First;
     No.Text:=dmGenData.Query1.Fields[0].AsString;
     edtSourceTitle.Text:=dmGenData.Query1.Fields[1].AsString;
     edtSourceDescription.Text:=dmGenData.Query1.Fields[2].AsString;
     temp:=dmGenData.Query1.Fields[5].AsString;
     if TryStrToInt(temp,tint) then
        fraIndividualwithRole1.idInd:=tInt
     else
        fraIndividualwithRole1.IndName:=temp;
     edtSourceInformation.Text:=dmGenData.Query1.Fields[3].AsString;
     Q.Value:=dmGenData.Query1.Fields[4].AsInteger;
     // Populate les dépots
     PopulateDepots;
     // Populate le tableau de documents
  end;
  fraDocuments1.idLink:=idSource;
end;

procedure TEditSource.edtSourceInformationEditingDone(Sender: TObject);
begin
  frmStemmaMainForm.DataHist.InsertColRow(false,0);
  frmStemmaMainForm.DataHist.Cells[0,0]:='M';
  frmStemmaMainForm.DataHist.Cells[1,0]:=edtSourceInformation.Text;
end;

procedure TEditSource.MenuItem10Click(Sender: TObject);
var
  ini:TIniFile;
  pdf:string;
begin

end;

procedure TEditSource.MenuItem5Click(Sender: TObject);
begin
  btnOKClick(Sender);
  ModalResult:=mrOk;
end;

procedure TEditSource.MenuItem6Click(Sender: TObject);
var
  j:integer;
  found:boolean;
begin
  if EditSource.ActiveControl.Name='M' then
     begin
     found:=false;
     For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,j]='M' then
           begin
           edtSourceInformation.text:=frmStemmaMainForm.DataHist.Cells[1,j];
           found:=true;
           break;
        end;
     end;
     if not found then
        begin
        For j:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
           begin
           if frmStemmaMainForm.DataHist.Cells[0,j]='M' then
              begin
              edtSourceInformation.text:=frmStemmaMainForm.DataHist.Cells[1,j];
              found:=true;
              break;
           end;
        end;
     end;
  end;
end;

procedure TEditSource.Supprimer1Click(Sender: TObject);
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

procedure TEditSource.TableauDepotsDblClick(Sender: TObject);
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

procedure TEditSource.Ajouter1Click(Sender: TObject);
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

procedure TEditSource.btnOKClick(Sender: TObject);
var
  temp:string;
  auteur:boolean;
begin
  dmGenData.Query1.SQL.Clear;
  auteur:=fraIndividualwithRole1.idInd>0;
  if no.text='0' then
     begin
     if auteur then
        dmGenData.Query1.SQL.Add('INSERT INTO S (T, D, M, A, Q) VALUES ('''+
           AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(edtSourceTitle.text),'\','\\'),'"','\"'),'''','\''')+
           ''', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(edtSourceDescription.text),'\','\\'),'"','\"'),'''','\''')+
           ''', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(edtSourceInformation.text),'\','\\'),'"','\"'),'''','\''')+
           ''', '''+IntToStr(fraIndividualwithRole1.idInd)+''', '+InttoStr(Q.Value)+')')
     else
        dmGenData.Query1.SQL.Add('INSERT INTO S (T, D, M, A, Q) VALUES ('''+
           AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(edtSourceTitle.text),'\','\\'),'"','\"'),'''','\''')+
           ''', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(edtSourceDescription.text),'\','\\'),'"','\"'),'''','\''')+
           ''', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(edtSourceInformation.text),'\','\\'),'"','\"'),'''','\''')+
           ''', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(fraIndividualwithRole1.IndName),'\','\\'),'"','\"'),'''','\''')+
           ''', '+InttoStr(Q.Value)+')');
  end
  else
    begin
     if auteur then
        dmGenData.Query1.SQL.Add('UPDATE S SET T='''+
           AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(edtSourceTitle.text),'\','\\'),'"','\"'),'''','\''')+
           ''', D='''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(edtSourceDescription.text),'\','\\'),'"','\"'),'''','\''')+
           ''', M='''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(edtSourceInformation.text),'\','\\'),'"','\"'),'''','\''')+
           ''', A='''+IntToStr(fraIndividualwithRole1.idInd)+''', Q='+InttoStr(Q.Value)+' WHERE no='+no.text)
     else
        dmGenData.Query1.SQL.Add('UPDATE S SET T='''+
           AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(edtSourceTitle.text),'\','\\'),'"','\"'),'''','\''')+
           ''', D='''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(edtSourceDescription.text),'\','\\'),'"','\"'),'''','\''')+
           ''', M='''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(edtSourceInformation.text),'\','\\'),'"','\"'),'''','\''')+
           ''', A='''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(fraIndividualwithRole1.IndName),'\','\\'),'"','\"'),'''','\''')+
           ''', Q='+InttoStr(Q.Value)+' WHERE no='+no.text);
    end;
  dmGenData.Query1.ExecSQL;
  if no.text='0' then
     begin
     no.text:=InttoStr(dmGenData.GetLastIDOfTable('S'));
  end;
end;

procedure TEditSource.edtSourceDescriptionKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_F3 then
     edtSourceDescription.Text:=edtSourceTitle.Text;
end;


procedure TEditSource.TableauDepotsEditingDone(Sender: TObject);
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

function TEditSource.GetID: LongInt;
begin
  result := no.Value;
end;

{ TEditSource }


{$R *.lfm}

end.

