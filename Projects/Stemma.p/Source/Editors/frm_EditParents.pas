unit frm_EditParents;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus, FMUtils,  fra_Citations, fra_Memo, LCLType,
  Spin, ExtCtrls, Buttons;

type
  TenumEditRelation=(
    eERT_appendParent,
    eERT_editParent,
    eERT_appendChild,
    eERT_editChild);

  { TfrmEditParents }

  TfrmEditParents = class(TForm)
    Ajouter1: TMenuItem;
    fraMemo1: TfraMemo;
    idA: TSpinEdit;

    idB: TSpinEdit;
    btnParentOK: TBitBtn;
    btnParentCancel: TBitBtn;
    fraEdtCitations1: TfraEdtCitations;
    Label6: TLabel;
    Label7: TLabel;
    lblChild: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    Modifier1: TMenuItem;
    No: TSpinEdit;
    pnlDateLeft: TPanel;
    pnlParentDate: TPanel;
    pnlParent: TPanel;
    pnlTop: TPanel;
    pnlParentBottom: TPanel;
    NomB: TEdit;
    NomA: TEdit;
    P1: TMemo;
    P2: TMemo;
    SD: TEdit;
    lblParent: TLabel;
    Label4: TLabel;
    lblDate: TLabel;
    P: TMemo;
    SD2: TEdit;
    Supprimer1: TMenuItem;
    X: TCheckBox;
    Y: TComboBox;
    lblType: TLabel;
    procedure idAEditingDone(Sender: TObject);
    procedure idBEditingDone(Sender: TObject);
    procedure btnParentOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure P2DblClick(Sender: TObject);
    procedure PDblClick(Sender: TObject);
    procedure PEditingDone(Sender: TObject);
    procedure SDEditingDone(Sender: TObject);
    procedure Supprimer1Click(Sender: TObject);
    procedure ParentsSaveData(Sender:Tobject);
    procedure YChange(Sender: TObject);
  private
    FEditMode: TenumEditRelation;
    FidEvent: Integer;
    function GetIdRelation: integer;
    procedure SetEditMode(AValue: TenumEditRelation);
    procedure SetIdRelation(AValue: integer);
    { private declarations }
  public
    { public declarations }
    property EditMode:TenumEditRelation read FEditMode write SetEditMode;
    property idRelation:integer read GetIdRelation write SetIdRelation;
  end;

var
  frmEditParents: TfrmEditParents;

implementation

uses
   frm_Main, cls_Translation, dm_GenData, frm_Names;


{ TfrmEditParents }

procedure TfrmEditParents.FormShow(Sender: TObject);

var
  lRelType, lidChild, lidParent: LongInt;
  lPrefered: Boolean;
  lMemoText, lPhraseText, lSortDate: String;
  lidRelation: Integer;
begin
  { TODO 20 : Lorsque l'on est dans A ou B, ESC ne fonctionne pas - By design Lazarus}
  frmStemmaMainForm.SetHistoryToActual(Sender);
  Caption:=Translation.Items[186];
  btnParentOK.Caption:=Translation.Items[152];
  btnParentCancel.Caption:=Translation.Items[164];
  lblType.Caption:=Translation.Items[166];
  lblParent.Caption:=Translation.Items[187];
//  Label3.Caption:=Translation.Items[171];
  Label4.Caption:=Translation.Items[172];
  lblDate.Caption:=Translation.Items[189];
  Label6.Caption:=Translation.Items[173];
  lblChild.Caption:=Translation.Items[188];

  MenuItem1.Caption:=Translation.Items[228];
  MenuItem2.Caption:=Translation.Items[224];
  MenuItem3.Caption:=Translation.Items[225];
  MenuItem4.Caption:=Translation.Items[226];

  // Populate le ComboBox
  dmGenData.GetTypeList(Y.Items,'R',false);

  fraEdtCitations1.CType:='R';
  fraEdtCitations1.OnSaveData:=@ParentsSaveData;
  // Populate la form
//  dmGenData.GetCode(code,nocode);
  if FEditMode in [eERT_appendChild,eERT_appendParent] then
     begin
     fraEdtCitations1.Clear;

     Y.ItemIndex:=0;
     No.Value:=0;
     X.Checked:=False;
     //dmGenData.GetCode(code,nocode);
     if FEditMode=eERT_appendChild then
        begin
        ActiveControl:=idA;
        Caption:=Translation.Items[41];
        idB.Value:=frmStemmaMainForm.iID;
        NomB.Text:=DecodeName(dmGenData.GetIndividuumName(frmStemmaMainForm.iID),1);
        idB.ReadOnly :=true;
        idA.Value:=0;
        NomA.Text:='';
        idA.ReadOnly :=false;
     end
     else
     begin
        ActiveControl:=idB;
        Caption:=Translation.Items[42];
        idA.Value:=frmStemmaMainForm.iID;
        NomA.Text:=decodename(dmGenData.GetIndividuumName(frmStemmaMainForm.iID),1);
        idA.ReadOnly :=true;
        idB.Value:=0;
        NomB.Text:='';
        idB.ReadOnly :=false;
     end;
     fraMemo1.Text:='';
     P.Text:='';
     SD.Text:='';
     SD2.Text:=InterpreteDate('',1);;
  end
  else
     begin
     idA.ReadOnly :=true;
     idB.ReadOnly :=true;
     ActiveControl:=idA;
     lidRelation := idRelation;
     dmGenData.GetRelationData(lidRelation, lSortDate, lPhraseText, lMemoText, lPrefered,
       lidParent, lidChild, lRelType);
     Y.ItemIndex:=y.Items.IndexOfObject(TObject(ptrint(lRelType)));
     X.Checked:=lPrefered;
     idA.Value:=lidChild;
     idB.Value:=lidParent;
     NomB.Text:=DecodeName(dmGenData.GetIndividuumName(idb.Value),1);
     NomA.Text:=DecodeName(dmGenData.GetIndividuumName(ida.Value),1);
     fraMemo1.Text:=lMemoText;
     P.Text:=lPhraseText;
     SD2.Text:=lSortDate;
     SD.Text:=ConvertDate(lSortDate,1);

     // Populate le tableau de citations
     fraEdtCitations1.LinkID:=No.Value;
  end;
  P1.Text:=dmGenData.GetTypePhrase(ptrint(Y.Items.Objects[Y.ItemIndex]));
  if length(P.Text)=0 then
     begin
     P.Text:=P1.Text;
     Label6.Visible:=true;
  end;
  P2.Text:=DecodePhrase(idA.Value,'ENFANT',P.Text,'R',No.Value);
  btnParentOK.Enabled:=(idA.Value>0) and (idB.Value>0);
  fraEdtCitations1.Enabled:=btnParentOK.Enabled;
  MenuItem5.Enabled:=btnParentOK.Enabled;
end;

procedure TfrmEditParents.MenuItem5Click(Sender: TObject);
begin
  btnParentOKClick(Sender);
  ModalResult:=mrOk;
end;

procedure TfrmEditParents.MenuItem6Click(Sender: TObject);
var
  lsResult:String;
  liResult:integer;
begin
  if ActiveControl.name=SD.name then
     begin
       lsResult := frmStemmaMainForm.RetreiveFromHistoy('SD');
       if lsResult <>'' then
         begin
           SD.text:=lsResult;
           SDEditingDone(Sender);
        end;
     end
  else if activeControl.Name=idA.Name then
     begin
     liResult:=frmStemmaMainForm.RetreiveFromHistoyID('A');
        if liResult>0 then
           begin
           idA.Value:=liResult;
           idAEditingDone(Sender);
           end;
     end
  else if ActiveControl.Name=P.Name then
     begin
       lsResult:=frmStemmaMainForm.RetreiveFromHistoy('P');
       if lsResult<>'' then
           begin
           P.text:=lsResult;
           PEditingDone(Sender);
        end;
     end
  else if activeControl.Name=idB.Name then
     begin
     liResult:=frmStemmaMainForm.RetreiveFromHistoyID('B');
        if liResult>0 then
           begin
           idB.Value:=liResult;
           idBEditingDone(Sender);
          end;
     end
  else if ActiveControl.Name=fraMemo1.edtMemoText.name then
     begin
     lsResult:=frmStemmaMainForm.RetreiveFromHistoy('M');
     if lsResult<>'' then
       begin
         fraMemo1.text:=lsResult;
       end;
  end;
end;

procedure TfrmEditParents.idBEditingDone(Sender: TObject);
var
  lSex: String;
begin
  NomB.Text:=DecodeName(dmGenData.GetIndividuumName(idB.Value),1);
  P2.Text:=DecodePhrase(idA.Value,'ENFANT',P.Text,'R',No.Value);
  lSex := dmGenData.GetSexOfInd(idB.Value);
  if (lSex = '') or ( lSex='?')  then
        btnParentOK.Enabled:=false
     else
        btnParentOK.Enabled:=(idA.Value>0) and (idB.Value>0);
  fraEdtCitations1.Enabled:=btnParentOK.Enabled;
  MenuItem5.Enabled:=btnParentOK.Enabled;
  frmStemmaMainForm.AppendHistoryData('B',idB.Value);
end;

procedure TfrmEditParents.idAEditingDone(Sender: TObject);
begin
  NomA.Text:=DecodeName(dmGenData.GetIndividuumName(idA.Value),1);
  P2.Text:=DecodePhrase(idA.Value,'ENFANT',P.Text,'R',No.Value);
  btnParentOK.Enabled:=((StrToInt(idA.Text)>0) and (StrToInt(idB.Text)>0));
  fraEdtCitations1.Enabled:=btnParentOK.Enabled;
  MenuItem5.Enabled:=btnParentOK.Enabled;
  frmStemmaMainForm.AppendHistoryData('A',idA.Value);
end;

procedure TfrmEditParents.ParentsSaveData(Sender: Tobject);
var
  lStrTmp,dateev, lMemoText:string;
  parent1, parent2,no_eve, lidRelation, lidChild, lidParent:integer;
  prefered, existe, lIsDefaultPhrase, lPrefParExists:boolean;
  lidType: PtrInt;
  lSDate, lPhrase: TCaption;
begin
  // Si l'enfant n'idA pas de parent de ce sexe, mettre la relation prefered.
  prefered:=false;
   lStrTmp:='';
   FidEvent := -1;
  If dmGenData.IsValidIndividuum(idB.Value) then
     begin
      lStrTmp:=dmGenData.GetSexOfInd(idB.Value);
      prefered:=not dmgendata.CheckPrefParentExists(lStrTmp,idA.Value);
  end;
  if X.Checked or ((no.Value=0) and prefered) then
     begin
     if lStrTmp='F' then lStrTmp:='M' else lStrTmp:='F';

     lidChild:=idA.Value;
     lPrefParExists:=dmgendata.GetRelationOtherParent(lidChild,lStrTmp, parent2, lStrTmp);
     parent1:=idB.Value; //Done -oJC : Convert to Integer

     If lPrefParExists then
        begin
        existe:=dmgendata.GetEventMarriageExists(parent1, parent2);
        if not existe then
           if Application.MessageBox(Pchar(Translation.Items[300]+
                 nomB.Text+Translation.Items[299]+
                 DecodeName(lStrTmp,1)+
                 Translation.Items[28]),pchar(SConfirmation),MB_YESNO)=IDYES then
              begin
              // Unir les parents
              // Ajouter l'événement mariage
              no_eve:=dmgenData.SaveEventData(0,300,1,true);
              // Ajouter les témoins
              dmGenData.AppendWitness('CONJOINT','',parent1,no_eve,true);
              dmGenData.AppendWitness('CONJOINT','',parent2,no_eve,true);
              // Ajouter les références
              // noter que l'on doit ajouter les références (frmStemmaMainForm.Code.Text='X')
              // sur l'événement # frmStemmaMainForm.no.Text
              //dmGenData.PutCode('P',no_eve);
              FidEvent:=no_Eve;
              // Sauvegarder les modifications
              dmGenData.SaveModificationTime(parent1);
              dmGenData.SaveModificationTime(parent2);
              // UPDATE DÉCÈS si la date est il y idA 100 ans !!!
              if (copy(SD2.text,1,1)='1') and not (SD2.text='100000000030000000000') then
                 dateev:=Copy(SD2.text,2,4)
              else
                 dateev:=FormatDateTime('YYYY',now);
              if ((StrtoInt(FormatDateTime('YYYY',now))-StrtoInt(dateev))>100) then
                 begin
                   dmGenData.UpdateIndLiving(parent1,'N',sender);
                   dmGenData.UpdateIndLiving(parent2,'N',sender);
                 dmGenData.NamesChanged(frmEditParents);
              end;
              dmGenData.EventChanged(frmEditParents);
           end;
     end;
  end;
  lIsDefaultPhrase:= Label6.Visible;

  lidRelation:=no.Value;
  lidType:=ptrint(Y.items.objects[Y.ItemIndex]);
  lidChild:=idA.Value;
  lidParent:=idB.Value;
  lMemoText:=fraMemo1.text;
  lSDate:=sd2.text;
  If lIsDefaultPhrase then
     lPhrase:=''
  else
     lPhrase:=P.text;
  dmgendata.SaveRelationData(lidRelation,lPhrase, lSDate, lidType, prefered, lidParent, lidChild,
     lMemoText);
  if no.text='0' then
     begin
     no.text:=InttoStr(dmGenData.GetLastIDOfTable('R'));
  end;
  // Sauvegarder les modifications
  if StrtoInt(idA.Text)>0 then dmGenData.SaveModificationTime(idA.Value);
  if StrtoInt(idB.Text)>0 then dmGenData.SaveModificationTime(idB.Value);
  // UPDATE DÉCÈS si la date est il y idA 100 ans !!!
  if (copy(SD2.text,1,1)='1') and not (SD2.text='100000000030000000000') then
     dateev:=Copy(SD2.text,2,4)
  else
     dateev:=FormatDateTime('YYYY',now);
  if ((StrtoInt(FormatDateTime('YYYY',now))-StrtoInt(dateev))>100) then
     begin
       dmGenData.UpdateIndLiving(idA.Value,'N',Sender);
       dmGenData.UpdateIndLiving(idB.Value,'N',Sender);
     If (frmStemmaMainForm.actWinNameAndAttr.Checked) then
       frmNames.PopulateNom(self);
  end;
end;

procedure TfrmEditParents.btnParentOKClick(Sender: TObject);
var
  lidRelation: Integer;
  lidNewID: Integer;
begin
  ParentsSaveData(Sender);
  // Donc déplacer ce bloc à la fin de btnParentOK et
  // exécuter seulement si c'est vraiment une sortie par Button1 ou F10
 // dmGenData.GetCode(code,nocode);
  if FidEvent<>-1 then
     begin

     lidRelation:= no.Value;
     lidNewID:=FidEvent;
     dmGenData.CopyCitation('R',lidRelation,'E',lidNewID);
     end;
end;

procedure TfrmEditParents.P2DblClick(Sender: TObject);
begin
  P.Visible:=true;
  P2.Visible:=false;
end;

procedure TfrmEditParents.PDblClick(Sender: TObject);
begin
  P2.Visible:=true;
  P.Visible:=false;
end;

procedure TfrmEditParents.PEditingDone(Sender: TObject);
begin
  If length(P.Text)=0 then
     P.Text:=P1.Text;
  Label6.Visible:=(P.Text=P1.Text);
  P2.Text:=DecodePhrase(idA.Value,'ENFANT',P.Text,'R',No.Value);
  frmStemmaMainForm.AppendHistoryData('P',P.Text);
end;

procedure TfrmEditParents.SDEditingDone(Sender: TObject);
begin
  SD2.Text:=InterpreteDate(SD.Text,1);
  SD.Text:=convertDate(SD.Text,1);
  frmStemmaMainForm.AppendHistoryData('SD',SD2.Text);
end;

procedure TfrmEditParents.Supprimer1Click(Sender: TObject);
begin
  //If TableauCitations.Row>0 then
  //   if Application.MessageBox(Pchar(Translation.Items[31]+
  //      TableauCitations.Cells[1,TableauCitations.Row]+Translation.Items[28]),pchar(SConfirmation),MB_YESNO)=IDYES then
  //      begin
  //      dm.Query1.SQL.Text:='DELETE FROM C WHERE no='+TableauCitations.Cells[0,TableauCitations.Row];
  //      dm.Query1.ExecSQL;
  //      TableauCitations.DeleteRow(TableauCitations.Row);
  //      // Sauvegarder les modifications
  //      if StrtoInt(idA.Text)>0 then dmGenData.SaveModificationTime(idA.Value);
  //      if StrtoInt(idB.Text)>0 then dmGenData.SaveModificationTime(idB.Value);
  //   end;
end;

procedure TfrmEditParents.YChange(Sender: TObject);

begin
  Y.ItemIndex;
  P1.Text:=dmGenData.GetTypePhrase(ptrint(Y.Items.Objects[Y.itemindex]));
  If Label6.Visible and (idA.Value>0) Then
     begin
     P.Text:=P1.Text;
     P2.Text:=DecodePhrase(idA.Value ,'ENFANT',P.Text,'R',No.Value);
  end
  else
     Label6.Visible:=(P.Text=P1.Text);
end;

procedure TfrmEditParents.SetEditMode(AValue: TenumEditRelation);
begin
  if FEditMode=AValue then Exit;
  FEditMode:=AValue;
end;

procedure TfrmEditParents.SetIdRelation(AValue: integer);
begin
  if no.Value=AValue then Exit;
  no.Value:=AValue;

end;

function TfrmEditParents.GetIdRelation: integer;
begin
  result := no.Value;
end;

{$R *.lfm}

{ TfrmEditParents }

end.

