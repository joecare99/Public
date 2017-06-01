unit frm_EditParents;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, Menus, FMUtils,  fra_Citations, LCLType,
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
    pnlParent: TPanel;
    pnlTop: TPanel;
    pnlParentBottom: TPanel;
    NomB: TEdit;
    NomA: TEdit;
    P1: TMemo;
    P2: TMemo;
    SD: TEdit;
    lblParent: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    M: TMemo;
    P: TMemo;
    SD2: TEdit;
    Supprimer1: TMenuItem;
    X: TCheckBox;
    Y: TComboBox;
    lblType: TLabel;
    procedure idAEditingDone(Sender: TObject);
    procedure Ajouter1Click(Sender: TObject);
    procedure idBEditingDone(Sender: TObject);
    procedure btnParentOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MEditingDone(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure P2DblClick(Sender: TObject);
    procedure PDblClick(Sender: TObject);
    procedure PEditingDone(Sender: TObject);
    procedure SDEditingDone(Sender: TObject);
    procedure Supprimer1Click(Sender: TObject);
    procedure TableauCitationsDblClick(Sender: TObject);
    procedure ParentsSaveData(Sender:Tobject);
    procedure YChange(Sender: TObject);
  private
    FEditMode: TenumEditRelation;
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

begin
  { TODO 20 : Lorsque l'on est dans A ou B, ESC ne fonctionne pas - By design Lazarus}
  frmStemmaMainForm.DataHist.Row:=0;
  Caption:=Translation.Items[186];
  btnParentOK.Caption:=Translation.Items[152];
  btnParentCancel.Caption:=Translation.Items[164];
  lblType.Caption:=Translation.Items[166];
  lblParent.Caption:=Translation.Items[187];
  Label3.Caption:=Translation.Items[171];
  Label4.Caption:=Translation.Items[172];
  Label5.Caption:=Translation.Items[189];
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
     M.Text:='';
     P.Text:='';
     SD.Text:='';
     SD2.Text:=InterpreteDate('',1);;
  end
  else
     begin
     idA.ReadOnly :=true;
     idB.ReadOnly :=true;
     ActiveControl:=idA;
     dmGenData.Query1.Close;
     dmGenData.Query1.SQL.text:='SELECT R.Y, R.X, R.A, R.B, R.M, R.P, R.SD FROM R WHERE R.no=:idRelation';
     dmGenData.Query1.ParamByName('idRelation').AsInteger:=idRelation;
     dmGenData.Query1.Open;
     Y.ItemIndex:=y.Items.IndexOfObject(TObject(ptrint(dmGenData.Query1.Fields[0].AsInteger)));
     X.Checked:=dmGenData.Query1.Fields[1].AsBoolean;
     idA.Value:=dmGenData.Query1.Fields[2].AsInteger;
     idB.Value:=dmGenData.Query1.Fields[3].AsInteger;
     NomB.Text:=DecodeName(dmGenData.GetIndividuumName(idb.Value),1);
     NomA.Text:=DecodeName(dmGenData.GetIndividuumName(ida.Value),1);
     M.Text:=dmGenData.Query1.Fields[4].AsString;
     P.Text:=dmGenData.Query1.Fields[5].AsString;
     SD2.Text:=dmGenData.Query1.Fields[6].AsString;
     SD.Text:=ConvertDate(dmGenData.Query1.Fields[6].AsString,1);
     dmGenData.Query1.Close;
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

procedure TfrmEditParents.MEditingDone(Sender: TObject);
begin
  frmStemmaMainForm.DataHist.InsertColRow(false,0);
  frmStemmaMainForm.DataHist.Cells[0,0]:='M';
  frmStemmaMainForm.DataHist.Cells[1,0]:=M.Text;
end;

procedure TfrmEditParents.MenuItem5Click(Sender: TObject);
begin
  btnParentOKClick(Sender);
  ModalResult:=mrOk;
end;

procedure TfrmEditParents.MenuItem6Click(Sender: TObject);
var
  j:integer;
  found:boolean;
begin
  if ActiveControl.Name='SD' then
     begin
     found:=false;
     For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,j]='SD' then
           begin
           SD.text:=frmStemmaMainForm.DataHist.Cells[1,j];
           SDEditingDone(Sender);
           found:=true;
           break;
        end;
     end;
     if not found then
        begin
        For j:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
           begin
           if frmStemmaMainForm.DataHist.Cells[0,j]='SD' then
              begin
              SD.text:=frmStemmaMainForm.DataHist.Cells[1,j];
              SDEditingDone(Sender);
              found:=true;
              break;
           end;
        end;
     end;
  end;
  if ActiveControl.Name='A' then
     begin
     found:=false;
     For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,j]='A' then
           begin
           idA.Value:=ptrint(frmStemmaMainForm.DataHist.Objects[1,j]);
           idAEditingDone(Sender);
           found:=true;
           break;
        end;
     end;
     if not found then
        begin
        For j:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
           begin
           if frmStemmaMainForm.DataHist.Cells[0,j]='A' then
              begin
              idA.Value:=ptrint(frmStemmaMainForm.DataHist.Objects[1,j]);
              idAEditingDone(Sender);
              found:=true;
              break;
           end;
        end;
     end;
  end;
  if ActiveControl.Name='P' then
     begin
     found:=false;
     For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,j]='P' then
           begin
           P.text:=frmStemmaMainForm.DataHist.Cells[1,j];
           PEditingDone(Sender);
           found:=true;
           break;
        end;
     end;
     if not found then
        begin
        For j:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
           begin
           if frmStemmaMainForm.DataHist.Cells[0,j]='P' then
              begin
              P.text:=frmStemmaMainForm.DataHist.Cells[1,j];
              PEditingDone(Sender);
              found:=true;
              break;
           end;
        end;
     end;
  end;
  if ActiveControl.Name='B' then
     begin
     found:=false;
     For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,j]='B' then
           begin
           idB.Value:=ptrint(frmStemmaMainForm.DataHist.Objects[1,j]);
           idBEditingDone(Sender);
           found:=true;
           break;
        end;
     end;
     if not found then
        begin
        For j:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
           begin
           if frmStemmaMainForm.DataHist.Cells[0,j]='B' then
              begin
              idB.Value:=ptrint(frmStemmaMainForm.DataHist.Objects[1,j]);
              idBEditingDone(Sender);
              found:=true;
              break;
           end;
        end;
     end;
  end;
  if ActiveControl.Name='M' then
     begin
     found:=false;
     For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,j]='M' then
           begin
           M.text:=frmStemmaMainForm.DataHist.Cells[1,j];
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
              M.text:=frmStemmaMainForm.DataHist.Cells[1,j];
              found:=true;
              break;
           end;
        end;
     end;
  end;
  if found then frmStemmaMainForm.DataHist.Row:=j+1;
end;

procedure TfrmEditParents.idBEditingDone(Sender: TObject);
begin
  NomB.Text:=DecodeName(dmGenData.GetIndividuumName(idB.Value),1);
  P2.Text:=DecodePhrase(idA.Value,'ENFANT',P.Text,'R',No.Value);
  dmGenData.Query1.SQL.Text:='SELECT I.S FROM I WHERE I.no='+idB.Text;
  dmGenData.Query1.Open;
  if dmGenData.Query1.eof then
     btnParentOK.Enabled:=false
  else
     if dmGenData.Query1.Fields[0].AsString='?' then
        btnParentOK.Enabled:=false
     else
        btnParentOK.Enabled:=(idA.Value>0) and (idB.Value>0);
  fraEdtCitations1.Enabled:=btnParentOK.Enabled;
  MenuItem5.Enabled:=btnParentOK.Enabled;
  frmStemmaMainForm.DataHist.InsertColRow(false,0);
  frmStemmaMainForm.DataHist.Cells[0,0]:='B';
  frmStemmaMainForm.DataHist.Cells[1,0]:=idB.Text;
end;

procedure TfrmEditParents.idAEditingDone(Sender: TObject);
begin
  NomA.Text:=DecodeName(dmGenData.GetIndividuumName(idA.Value),1);
  P2.Text:=DecodePhrase(idA.Value,'ENFANT',P.Text,'R',No.Value);
  btnParentOK.Enabled:=((StrToInt(idA.Text)>0) and (StrToInt(idB.Text)>0));
  fraEdtCitations1.Enabled:=btnParentOK.Enabled;
  MenuItem5.Enabled:=btnParentOK.Enabled;
  frmStemmaMainForm.DataHist.InsertColRow(false,0);
  frmStemmaMainForm.DataHist.Cells[0,0]:='A';
  frmStemmaMainForm.DataHist.Cells[1,0]:=idA.Text;
end;

procedure TfrmEditParents.Ajouter1Click(Sender: TObject);
begin

end;

procedure TfrmEditParents.ParentsSaveData(Sender: Tobject);
var
  lStrTmp,dateev:string;
  parent1, parent2,no_eve:integer;
  prefered, existe, lIsDefaultPhrase, lPrefParExists:boolean;
begin
  // Si l'enfant n'idA pas de parent de ce sexe, mettre la relation prefered.
  prefered:=false;
   lStrTmp:='';
  If dmGenData.IsValidIndividuum(idB.Value) then
     begin
      lStrTmp:=dmGenData.GetSexOfInd(idB.Value);
     dmGenData.Query1.SQL.Text:='SELECT R.no, R.B FROM R JOIN I ON R.B=I.no WHERE I.S=:Sex  AND R.X=1 AND R.A=:idIndA';
     dmgenData.Query1.ParamByName('Sex').AsString:=lStrTmp;
     dmgenData.Query1.ParamByName('idIndA').AsInteger:=idA.Value;
     dmGenData.Query1.Open;
     prefered:=not dmGenData.Query1.EOF;
  end;
  if X.Checked or ((no.Value=0) and prefered) then
     begin
     if lStrTmp='F' then lStrTmp:='M' else lStrTmp:='F';
     dmGenData.Query1.SQL.Text:='SELECT R.no, R.B, N.N FROM R JOIN I ON R.B=I.no JOIN N on N.I=R.B WHERE I.S=:Sex AND R.X=1 AND N.X=1 AND R.A=:idChild';
     dmGendata.Query1.ParamByName('Sex').AsString:=lStrTmp;
     dmGendata.Query1.ParamByName('idChild').AsInteger:=idA.Value;
     dmGenData.Query1.Open;
     lPrefParExists := not dmGenData.Query1.EOF;
     if lPrefParExists then
        begin;
        lStrTmp:=dmGenData.Query1.Fields[2].AsString;
        parent2:=dmGenData.Query1.Fields[1].AsInteger;
     end;
     dmGenData.Query1.close;
     parent1:=idB.Value; //Done -oJC : Convert to Integer

     If lPrefParExists then
        begin
        // Vérifier qu'il n'y idA pas déjà une union entre ces deux parents
        dmGenData.Query1.SQL.text:='SELECT COUNT(E.no) FROM E JOIN W ON W.E=E.no JOIN Y on E.Y=Y.no WHERE (W.I=:idParentA OR W.I=:idParentB) AND W.X=1 AND E.X=1 AND Y.Y=''M'' GROUP BY E.no';
        dmGendata.Query1.ParamByName('idParentA').AsInteger:=idA.Value;
        dmGendata.Query1.ParamByName('idParentB').AsInteger:=parent1;
        dmGenData.Query1.Open;
        existe:=false;
        while not dmGenData.Query1.EOF do
           begin
           existe:=existe or (dmGenData.Query1.Fields[0].AsInteger=2);
           dmGenData.Query1.Next;
        end;
        if not existe then
           if Application.MessageBox(Pchar(Translation.Items[300]+
                 nomB.Text+Translation.Items[299]+
                 DecodeName(lStrTmp,1)+
                 Translation.Items[28]),pchar(SConfirmation),MB_YESNO)=IDYES then
              begin
              // Unir les parents
              // Ajouter l'événement mariage
              dmGenData.Query1.SQL.text:='INSERT INTO E (Y, L, X) VALUES (300, 1, 1)';
              dmGenData.Query1.ExecSQL;
              no_eve:=dmGenData.GetLastIDOfTable('E');
              // Ajouter les témoins
              dmGenData.Query1.SQL.text:='INSERT INTO W (I, E, X, R)'+
                ' VALUES (:idParent, :idEvent, 1, ''CONJOINT'')';
	      dmGenData.Query1.ParamByName('idEvent').AsInteger:=no_eve;
	      dmGenData.Query1.ParamByName('idParent').AsInteger:=parent1;
              dmGenData.Query1.ExecSQL;
	      dmGenData.Query1.ParamByName('idParent').AsInteger:=parent2;
              dmGenData.Query1.ExecSQL;
              // Ajouter les références
              // noter que l'on doit ajouter les références (frmStemmaMainForm.Code.Text='X')
              // sur l'événement # frmStemmaMainForm.no.Text
              dmGenData.PutCode('P',no_eve);
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
  dmGenData.Query1.Close;
  lIsDefaultPhrase:= Label6.Visible;
  if no.value=0 then
        dmGenData.Query1.SQL.text:='INSERT INTO R (Y, A, B, M, SD, P, X) VALUES (:idType, :idIndA, :idIndB, :M, :SDate, :P, :X)'
  else
     begin
       dmGenData.Query1.SQL.text:='UPDATE R SET Y=:idType, A=:idIndA, B=:idIndB, M=:M, SD=:SDate, P=:P, X=:X where no=:idRel';
       dmGenData.Query1.ParamByName('idRel').AsInteger:=no.Value;
     end;
     dmGenData.Query1.ParamByName('idType').AsInteger:=ptrint(Y.items.objects[Y.ItemIndex]);
     dmGenData.Query1.ParamByName('idIndA').AsInteger:=idA.Value;
     dmGenData.Query1.ParamByName('idIndB').AsInteger:=idB.Value;
     dmGenData.Query1.ParamByName('M').AsString:=M.text;
     dmGenData.Query1.ParamByName('SDate').AsString:=sd2.text;
     If lIsDefaultPhrase then
        dmGenData.Query1.ParamByName('P').AsString:=''
     else
     dmGenData.Query1.ParamByName('P').AsString:=P.text;
     dmGenData.Query1.ParamByName('X').AsBoolean:=prefered;
  dmGenData.Query1.ExecSQL;

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
     dmGenData.Query2.SQL.Text:='UPDATE I SET V=''N'' WHERE no='+idA.Text;
     dmGenData.Query2.ExecSQL;
     dmGenData.Query2.SQL.Text:='UPDATE I SET V=''N'' WHERE no='+idB.Text;
     dmGenData.Query2.ExecSQL;
     If (frmStemmaMainForm.actWinNameAndAttr.Checked) then
       frmNames.PopulateNom(self);
  end;
end;

procedure TfrmEditParents.btnParentOKClick(Sender: TObject);
var
  nocode:string;
  lType, lNewType: Char;
  lidRelation: Integer;
  lidNewID: Integer;
begin
  ParentsSaveData(Sender);
  // Donc déplacer ce bloc à la fin de btnParentOK et
  // exécuter seulement si c'est vraiment une sortie par Button1 ou F10
 // dmGenData.GetCode(code,nocode);
  if FEditMode=eERT_appendParent then
     begin
     lType := 'R';
     lNewType:='E';
     lidRelation:= no.Value;
     lidNewID:=strtoint(nocode); //??
     dmGenData.CopyCitation('R',lidRelation,'E',lidNewID);
     dmGenData.Query1.SQL.Text:='SELECT S, Q, M FROM C WHERE Y=:Type AND N=:idRelation';
     dmGenData.Query1.ParamByName('Type').AsString:=lType;
     dmGenData.Query1.ParamByName('idRelation').AsInteger:=lidRelation;
     dmGenData.Query1.Open;
     dmGenData.Query1.First;
     dmGenData.Query2.Close;
     While not dmGenData.Query1.EOF do
        begin
        dmGenData.Query2.SQL.text:='INSERT INTO C (Y, N, S, Q, M) VALUES (:Type, :Linkid, :idSource, :Q, :M)';
        dmGenData.Query2.ParamByName('Type').AsString:=lNewType;
        dmGenData.Query2.ParamByName('Linkid').AsInteger:=lidNewID;
        dmGenData.Query2.ParamByName('idSource').AsInteger:=dmGenData.Query1.Fields[0].AsInteger;
        dmGenData.Query2.ParamByName('Q').AsInteger:=dmGenData.Query1.Fields[1].AsInteger;
        dmGenData.Query2.ParamByName('M').AsString:=dmGenData.Query1.Fields[2].AsString;
        dmGenData.Query2.ExecSQL;
        dmGenData.Query1.Next;
     end;
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
  frmStemmaMainForm.DataHist.InsertColRow(false,0);
  frmStemmaMainForm.DataHist.Cells[0,0]:='P';
  frmStemmaMainForm.DataHist.Cells[1,0]:=P.Text;
end;

procedure TfrmEditParents.SDEditingDone(Sender: TObject);
begin
  SD2.Text:=InterpreteDate(SD.Text,1);
  SD.Text:=convertDate(SD.Text,1);
  frmStemmaMainForm.DataHist.InsertColRow(false,0);
  frmStemmaMainForm.DataHist.Cells[0,0]:='SD';
  frmStemmaMainForm.DataHist.Cells[1,0]:=SD2.Text;
end;

procedure TfrmEditParents.Supprimer1Click(Sender: TObject);
begin
  //If TableauCitations.Row>0 then
  //   if Application.MessageBox(Pchar(Translation.Items[31]+
  //      TableauCitations.Cells[1,TableauCitations.Row]+Translation.Items[28]),pchar(SConfirmation),MB_YESNO)=IDYES then
  //      begin
  //      dmGenData.Query1.SQL.Text:='DELETE FROM C WHERE no='+TableauCitations.Cells[0,TableauCitations.Row];
  //      dmGenData.Query1.ExecSQL;
  //      TableauCitations.DeleteRow(TableauCitations.Row);
  //      // Sauvegarder les modifications
  //      if StrtoInt(idA.Text)>0 then dmGenData.SaveModificationTime(idA.Value);
  //      if StrtoInt(idB.Text)>0 then dmGenData.SaveModificationTime(idB.Value);
  //   end;
end;

procedure TfrmEditParents.TableauCitationsDblClick(Sender: TObject);
begin

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

