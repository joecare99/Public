unit frm_EditEvents;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, Menus, FMUtils, fra_Citations, fra_Documents, StrUtils, LCLType,
  Buttons, Spin, ExtCtrls, fra_Phrase, fra_Date;

type
 enumEventEditType = (
    eEET_EditExisting,
    eEET_New,
    eEET_AddBirth,
    eEET_AddBaptism,
    eEET_AddDeath,
    eEET_AddBurial);

  { TfrmEditEvents }
  TfrmEditEvents = class(TForm)
    Button1: TBitBtn;
    Button2: TBitBtn;
    fraDate1: TfraDate;
    fraDocuments1: TfraDocuments;
    fraEdtCitations1: TfraEdtCitations;
    fraPhrase1: TfraPhrase;
    L3: TEdit;
    L4: TEdit;
    L0: TEdit;
    LA: TEdit;
    Label1: TLabel;
    Label11: TLabel;
    Label3: TLabel;
    Label8: TLabel;
    M: TMemo;
    mnuEventsMain: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    ModifierTemoin: TMenuItem;
    AjouterTemoin: TMenuItem;
    No: TSpinEdit;
    pnlBottom: TPanel;
    Splitter1: TSplitter;
    SupprimerTemoin: TMenuItem;
    L1: TEdit;
    L2: TEdit;
    mnuWitnes: TPopupMenu;
    Role: TEdit;
    TableauTemoins: TStringGrid;
    X: TEdit;
    YY: TEdit;
    Y: TComboBox;

    procedure AjouterTemoinClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MEditingDone(Sender: TObject);

    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);

//    procedure Supprimer1Click(Sender: TObject);

    procedure SupprimerTemoinClick(Sender: TObject);
    procedure TableauTemoinsDblClick(Sender: TObject);
    procedure TableauTemoinsDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; {%H-}aState: TGridDrawState);
    procedure YChange(Sender: TObject);
  private
    FEditType: enumEventEditType;
    function GetID: longint;
    function GetIdEventType: integer;
    procedure SetEditType(AValue: enumEventEditType);
    { private declarations }
  public
    property EditType: enumEventEditType read FEditType write SetEditType;
    Property idEvent:longint read GetID;
    property idEventType:integer read GetIdEventType;
    { public declarations }
  end; 

function PopulateTemoins(Event:string):string;

var
  frmEditEvents: TfrmEditEvents;

{ TODO : Ajouter la possibilité de mettre un témoin principal ou non, afficher le nombre de témoins }
implementation

uses
  frm_Events, frm_Main, dm_GenData, frm_Explorer, frm_EditWitness,
  frm_Names, cls_Translation;



{$R *.lfm}

{ TfrmEditEvents }

procedure TfrmEditEvents.TableauTemoinsDblClick(Sender: TObject);
begin
  if TableauTemoins.Row>0 then
     begin
     // Enregistrer le témoin par défaut si no.text='0'
     if no.text='0' then
        Button1Click(Sender);
     frmEditWitness.idWitness:=ptrint(TableauTemoins.Objects[0,frmEditEvents.TableauTemoins.Row]);
     If frmEditWitness.Showmodal=mrOK then
        PopulateTemoins(no.text);
  end;
end;

procedure TfrmEditEvents.TableauTemoinsDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin
  if aCol=0 then
     begin
     (Sender as TStringGrid).Canvas.Font.Color := (Sender as TStringGrid).Canvas.Brush.Color;
     (Sender as TStringGrid).Canvas.TextOut(aRect.Left+2,aRect.Top+2,(Sender as TStringGrid).Cells[aCol,aRow]);
  end;
  if (((Sender as TStringGrid).Cells[4,aRow]='*') and (aCol>0)) then
     begin
//     if (Sender as TStringGrid).Row=aRow then
//        (Sender as TStringGrid).Canvas.Brush.Color := clBlue
//     else
//        (Sender as TStringGrid).Canvas.Brush.Color := clYellow;
//     (Sender as TStringGrid).Canvas.FillRect(aRect);
     (Sender as TStringGrid).Canvas.Font.Bold := true;
     (Sender as TStringGrid).Canvas.TextOut(aRect.Left+2,aRect.Top+2,(Sender as TStringGrid).Cells[aCol,aRow]);
  end;
end;

procedure TfrmEditEvents.YChange(Sender: TObject);
var
  roledefaut, roles, phrase:string;
  j:integer;
begin
  dmGenData.Query1.SQL.Clear;
  dmGenData.Query1.SQL.Add('SELECT Y.P, Y.R FROM Y WHERE Y.no='+inttostr(ptrint(Y.Items.Objects[Y.ItemIndex])));
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  phrase:=dmGenData.Query1.Fields[0].AsString;
  roles:=dmGenData.Query1.Fields[1].AsString;
  if AnsiPos('|',Roles)>0 then
     RoleDefaut:=Copy(Roles,1,AnsiPos('|',Roles)-1)
  else
     RoleDefaut:=Roles;
  for j:=1 to TableauTemoins.Rowcount-1 do
     begin
     if AnsiPos(TableauTemoins.Cells[1,j],Roles)<1 then
        begin
        TableauTemoins.Cells[1,j]:=RoleDefaut;
        if TableauTemoins.Cells[2,j]=frmStemmaMainForm.sID then
           Role.Text:=RoleDefaut;
        dmGenData.Query1.SQL.Text:='UPDATE W SET P='''', R='''+RoleDefaut+''' WHERE W.no='+TableauTemoins.Cells[0,j];
        dmGenData.Query1.ExecSQL;
        dmGenData.SaveModificationTime(strtoint(TableauTemoins.Cells[2,j]));
     end;
  end;
  If fraPhrase1.isDefault Then
     fraPhrase1.Text:=DecodePhrase(frmStemmaMainForm.iID,Role.Text,phrase,'E',No.Value);
end;

function TfrmEditEvents.GetID: longint;
begin
  trystrtoint(No.Text,result);
end;

function TfrmEditEvents.GetIdEventType: integer;
begin
  result := PtrInt(y.Items.Objects[y.ItemIndex]);
end;

procedure TfrmEditEvents.SetEditType(AValue: enumEventEditType);
begin
  if FEditType=AValue then Exit;
  FEditType:=AValue;
end;


procedure TfrmEditEvents.FormShow(Sender: TObject);
var
  sPlace,phrase, sArticle, sCountry, sProvince, sDetail,
    sCity, sRegion, sEventType:string;
  lIdEvent: Integer;

  procedure FindTypeItem(FindTypeID:PtrInt);
  var   j:integer;
  begin
    for j:=0 to Y.Items.Count-1 do
             if PtrInt(Y.Items.Objects[j])=FindTypeID then
                Y.ItemIndex:=j;
  end;

begin
  ActiveControl:=fraDate1.edtDateForPresentation;
  frmStemmaMainForm.DataHist.Row:=0;
  Caption:=Translation.Items[165];
  Button1.Caption:=Translation.Items[152];
  Button2.Caption:=Translation.Items[164];
  Label1.Caption:=Translation.Items[166];
  Label3.Caption:=Translation.Items[171];
  //Label4.Caption:=Translation.Items[172];
  //Label5.Caption:=Translation.Items[144];
  //Label6.Caption:=Translation.Items[173];

  Label8.Caption:=Translation.Items[170];
  //Label9.Caption:=Translation.Items[168];
  //Label10.Caption:=Translation.Items[169];
  Label11.Caption:=Translation.Items[167];
  //Label12.Caption:=Translation.Items[298];
  TableauTemoins.Cells[1,0]:=Translation.Items[175];
  TableauTemoins.Cells[3,0]:=Translation.Items[176];


  fraDocuments1.tblDocuments.Cells[2,0]:=Translation.Items[154];
  fraDocuments1.tblDocuments.Cells[4,0]:=Translation.Items[201];
  fraEdtCitations1.Clear;
  fraEdtCitations1.CType:='E';
  //fraDocuments1.mniDocumentAdd.Caption:=Translation.Items[224];
  //fraDocuments1.mniDocumentEdit.Caption:=Translation.Items[225];
  //fraDocuments1.mniDocumentUnlink.Caption:=Translation.Items[226];
  AjouterTemoin.Caption:=Translation.Items[224];
  ModifierTemoin.Caption:=Translation.Items[225];
  SupprimerTemoin.Caption:=Translation.Items[226];
  MenuItem1.Caption:=Translation.Items[227];
  MenuItem2.Caption:=Translation.Items[228];
  MenuItem3.Caption:=Translation.Items[224];
  MenuItem4.Caption:=Translation.Items[225];
  MenuItem5.Caption:=Translation.Items[226];
  MenuItem6.Caption:=Translation.Items[224];
  MenuItem7.Caption:=Translation.Items[225];
  MenuItem8.Caption:=Translation.Items[226];
  //mniDocumentView.Caption:=Translation.Items[181];
  // Populate le ComboBox

  if FEditType <> eEET_EditExisting then
     begin
     if FEditType in [eEET_AddBirth,eEET_AddBaptism] then
        dmGenData.GetTypeList(Y.Items,'B')
     else if FEditType in [eEET_AddDeath,eEET_AddBurial] then
        dmGenData.GetTypeList(Y.Items,'D')
     else
        dmGenData.GetTypeList(Y.Items,['B','D','M','X','Z']);

  end
  else
     begin
     lIdEvent:=frmEvents.idEvent;
     sEventType:=dmGenData.GetEventType(lIdEvent);
     dmGenData.GetTypeList(Y.Items,sEventType);
  end;

  // Populate la form
  if FEditType <> eEET_EditExisting then
     begin
     frmEditEvents.Caption:=Translation.Items[30];
     TableauTemoins.RowCount:=2;
     TableauTemoins.Cells[0,1]:='0';
     case FEditType of
     eEET_New:
        begin
        Y.ItemIndex:=0;
        X.Text:='0';
     end;
     eEET_AddBirth:
        begin
        // Mettre le bon Y.ItemIndex
        // Trouver si ce doit être un primaire ou non
        FindTypeItem(100);
        dmGenData.Query1.Close;
        dmGenData.Query1.SQL.Text:='SELECT E.no FROM E JOIN W on W.E=E.no JOIN Y on E.Y=Y.no WHERE Y.Y=''B'' AND E.X=1 AND W.X=1 AND W.I='+
           frmStemmaMainForm.sID;
        dmGenData.Query1.Open;
        if dmGenData.Query1.Eof then
           X.Text:='1'
        else
           X.Text:='0';
     end;
     eEET_AddBaptism:
        begin
        // Mettre le bon Y.ItemIndex
        // Trouver si ce doit être un primaire ou non
        FindTypeItem(110);
        dmGenData.Query1.Close;
        dmGenData.Query1.SQL.Text:='SELECT E.no FROM E JOIN W on W.E=E.no JOIN Y on E.Y=Y.no WHERE Y.Y=''B'' AND E.X=1 AND W.X=1 AND W.I='+
           frmStemmaMainForm.sID;
        dmGenData.Query1.Open;
        if dmGenData.Query1.Eof then
           X.Text:='1'
        else
           X.Text:='0';
     end;
     eEET_AddDeath:

        begin
        // Mettre le bon Y.ItemIndex
        // Trouver si ce doit être un primaire ou non
        FindTypeItem(200);
        dmGenData.Query1.Close;
        dmGenData.Query1.SQL.Text:='SELECT E.no FROM E JOIN W on W.E=E.no JOIN Y on E.Y=Y.no WHERE Y.Y=''D'' AND E.X=1 AND W.X=1 AND W.I='+
           frmStemmaMainForm.sID;
        dmGenData.Query1.Open;
        if dmGenData.Query1.Eof then
           X.Text:='1'
        else
           X.Text:='0';
     end;
     eEET_AddBurial:
        begin
        // Mettre le bon Y.ItemIndex
        // Trouver si ce doit être un primaire ou non
        FindTypeItem(210);
        dmGenData.Query1.Close;
        dmGenData.Query1.SQL.Text:='SELECT E.no FROM E JOIN W on W.E=E.no JOIN Y on E.Y=Y.no WHERE Y.Y=''D'' AND E.X=1 AND W.X=1 AND W.I='+
           frmStemmaMainForm.sID;
        dmGenData.Query1.Open;
        if dmGenData.Query1.Eof then
           X.Text:='1'
        else
           X.Text:='0';
     end;
     end; {Case}
     // Trouver le type de témoin par défaut
     dmGenData.Query1.Close;
     dmGenData.Query1.SQL.text:='SELECT Y.R FROM Y WHERE Y.no=:idType';
     dmGenData.Query1.ParamByName('idType').AsInteger:=idEventType;
     dmGenData.Query1.Open;
     dmGenData.Query1.First;
     if AnsiPos('|',dmGenData.Query1.Fields[0].AsString)>0 then
        TableauTemoins.Cells[1,1]:=ANSIToUTF8(Copy(dmGenData.Query1.Fields[0].AsString,1,AnsiPos('|',dmGenData.Query1.Fields[0].AsString)-1))
     else
        TableauTemoins.Cells[1,1]:=dmGenData.Query1.Fields[0].AsString;
     TableauTemoins.Cells[2,1]:=frmStemmaMainForm.sID;
     TableauTemoins.Cells[3,1]:=dmGenData.GetIndividuumName(frmStemmaMainForm.iID);
     TableauTemoins.Cells[4,1]:='1';
     M.Text:='';
     fraPhrase1.clear;
     fraDate1.clear;
     No.Value:=0;
     Role.Text:=TableauTemoins.Cells[1,1];

     LA.Text:='';
     L0.Text:='';
     L1.Text:='';
     L2.Text:='';
     L3.Text:='';
     L4.Text:='';
     YY.Text:='';
     fraPhrase1.isDefault:=true;
  end
  else
     begin
     dmGenData.Query1.Close;
     dmGenData.Query1.SQL.text:='SELECT E.no, E.Y, E.L, E.M, E.X, E.PD, E.SD, L.L FROM E JOIN L ON L.no=E.L WHERE E.no=:idEvent';
     dmGenData.Query1.ParamByName('idEvent').AsInteger:=frmEvents.idEvent;
     dmGenData.Query1.Open;
     dmGenData.Query1.First;
     FindTypeItem(dmGenData.Query1.Fields[1].AsInteger);
     No.Text:=dmGenData.Query1.Fields[0].AsString;
     X.Text:=dmGenData.Query1.Fields[4].AsString;
     M.Text:=dmGenData.Query1.Fields[3].AsString;
     // Aller chercher L0-L4 de L
     sPlace:=dmGenData.Query1.Fields[7].AsString;
     DecodePlace(sPlace,sArticle ,sDetail,sCity,sRegion,sProvince,sCountry);
     LA.Text:=sArticle;
     L0.Text:=sDetail;
     L1.Text:=sCity;
     L2.Text:=sRegion;
     L3.text:=sProvince;
     L4.text:=sCountry;
     fraDate1.Date:=dmGenData.Query1.Fields[5].AsString;
     fraDate1.SortDate:=dmGenData.Query1.Fields[6].AsString;
     // Aller chercher P, Role et témoins de W
     phrase:=PopulateTemoins(no.Text);
  end;
  dmGenData.Query2.Close;
  dmGenData.Query2.SQL.text:='SELECT Y.no, Y.T, Y.P FROM Y WHERE Y.no=:idType';
  dmGenData.Query2.ParamByName('idType').AsInteger:=idEventType;
  dmGenData.Query2.Open;
  dmGenData.Query2.First;
  if length(phrase)=0 then
     begin
     fraPhrase1.isDefault:=true;
     phrase:=dmGenData.Query2.Fields[2].AsString;
  end;
  fraPhrase1.Text:=DecodePhrase(frmStemmaMainForm.iID,Role.Text,Phrase,'E',No.Value);
  // Populate le tableau de citations
  if no.Value=0 then
     fraEdtCitations1.clear
  else
     fraEdtCitations1.LinkID:=no.Value;
  // Populate le tableau de documents
  fraDocuments1.DocType:='E';
  fraDocuments1.idLink:=No.Value;
  if no.text='0' then
     fraDocuments1.clear
  else
     fraDocuments1.Populate;
end;

procedure TfrmEditEvents.MEditingDone(Sender: TObject);
begin
  frmStemmaMainForm.AppendHistoryData('M',M.Text);
end;


procedure TfrmEditEvents.MenuItem11Click(Sender: TObject);
begin
  Button1Click(Sender);
  ModalResult:=mrOk;
end;

procedure TfrmEditEvents.MenuItem12Click(Sender: TObject);
var
    j:integer;
    found:boolean;
    temp, sArticle, sDetail, sCity, sRegion, sProvince, sCountry:string;
begin
  // Traitement de F3 pour les lieus
  if frmEditEvents.ActiveControl.Name='LA' then
     begin
     found:=false;
     For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,j]='L' then
           begin
           dmGenData.Query1.SQL.Text:='SELECT L FROM L WHERE no='+frmStemmaMainForm.DataHist.Cells[1,j];
           dmGenData.Query1.Open;
           temp:=dmGenData.Query1.Fields[0].AsString;
           if ANSIPos('<'+CTagNameArticle+'>',temp)>0 then
              LA.text:=Copy(temp,ANSIPos('<'+CTagNameArticle+'>',temp)+length(CTagNameArticle)+2,AnsiPos('</'+CTagNameArticle+'>',temp)-ANSIPos('<'+CTagNameArticle+'>',temp)-length(CTagNameArticle)-2)
           else
              LA.text:='';
           found:=true;
           break;
        end;
     end;
     if not found then
        begin
        For j:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
           begin
           if frmStemmaMainForm.DataHist.Cells[0,j]='L' then
              begin
              dmGenData.Query1.SQL.Text:='SELECT L FROM L WHERE no='+frmStemmaMainForm.DataHist.Cells[1,j];
              dmGenData.Query1.Open;
              temp:=dmGenData.Query1.Fields[0].AsString;
              if ANSIPos('<'+CTagNameArticle+'>',temp)>0 then
                 LA.text:=Copy(temp,ANSIPos('<'+CTagNameArticle+'>',temp)+length(CTagNameArticle)+2,AnsiPos('</'+CTagNameArticle+'>',temp)-ANSIPos('<'+CTagNameArticle+'>',temp)-length(CTagNameArticle)-2)
              else
                 LA.text:='';
              found:=true;
              break;
           end;
        end;
     end;
  end;
  if frmEditEvents.ActiveControl.Name='L0' then
     begin
     found:=false;
     For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,j]='L' then
           begin
           dmGenData.Query1.SQL.Text:='SELECT L FROM L WHERE no='+frmStemmaMainForm.DataHist.Cells[1,j];
           dmGenData.Query1.Open;
           temp:=dmGenData.Query1.Fields[0].AsString;
           DecodePlace(temp,sArticle,sDetail,sCity,sRegion,sProvince,sCountry);
           L0.Text:=sDetail;
           L1.text:=sCity;
           L2.text:=sRegion;
           L3.text:=sProvince;
           L4.text:=sCountry;
           found:=true;
           break;
        end;
     end;
     if not found then
        begin
        For j:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
           begin
           if frmStemmaMainForm.DataHist.Cells[0,j]='L' then
              begin
              dmGenData.Query1.SQL.Text:='SELECT L FROM L WHERE no='+frmStemmaMainForm.DataHist.Cells[1,j];
              dmGenData.Query1.Open;
              temp:=dmGenData.Query1.Fields[0].AsString;
              DecodePlace(temp,sArticle,sDetail,sCity,sRegion,sProvince,sCountry);
              L0.Text:=sDetail;
              L1.text:=sCity;
              L2.text:=sRegion;
              L3.text:=sProvince;
              L4.text:=sCountry;
              found:=true;
              break;
           end;
        end;
     end;
  end;
  if frmEditEvents.ActiveControl.Name='L1' then
     begin
     found:=false;
     For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,j]='L' then
           begin
           dmGenData.Query1.SQL.Text:='SELECT L FROM L WHERE no='+frmStemmaMainForm.DataHist.Cells[1,j];
           dmGenData.Query1.Open;
           temp:=dmGenData.Query1.Fields[0].AsString;
           DecodePlace(temp,sArticle,sDetail,sCity,sRegion,sProvince,sCountry);
           L0.Text:=sDetail;
           L1.text:=sCity;
           L2.text:=sRegion;
           L3.text:=sProvince;
           L4.text:=sCountry;
           found:=true;
           break;
        end;
     end;
     if not found then
        begin
        For j:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
           begin
           if frmStemmaMainForm.DataHist.Cells[0,j]='L' then
              begin
              dmGenData.Query1.SQL.Text:='SELECT L FROM L WHERE no='+frmStemmaMainForm.DataHist.Cells[1,j];
              dmGenData.Query1.Open;
              temp:=dmGenData.Query1.Fields[0].AsString;
              DecodePlace(temp,sArticle,sDetail,sCity,sRegion,sProvince,sCountry);
              L0.Text:=sDetail;
              L1.text:=sCity;
              L2.text:=sRegion;
              L3.text:=sProvince;
              L4.text:=sCountry;
              found:=true;
              break;
           end;
        end;
     end;
  end;
  if frmEditEvents.ActiveControl.Name='L2' then
     begin
     found:=false;
     For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,j]='L' then
           begin
           dmGenData.Query1.SQL.Text:='SELECT L FROM L WHERE no='+frmStemmaMainForm.DataHist.Cells[1,j];
           dmGenData.Query1.Open;
           temp:=dmGenData.Query1.Fields[0].AsString;
           DecodePlace(temp,sArticle,sDetail,sCity,sRegion,sProvince,sCountry);
           L0.Text:=sDetail;
           L1.text:=sCity;
           L2.text:=sRegion;
           L3.text:=sProvince;
           L4.text:=sCountry;
           found:=true;
           break;
        end;
     end;
     if not found then
        begin
        For j:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
           begin
           if frmStemmaMainForm.DataHist.Cells[0,j]='L' then
              begin
              dmGenData.Query1.SQL.Text:='SELECT L FROM L WHERE no='+frmStemmaMainForm.DataHist.Cells[1,j];
              dmGenData.Query1.Open;
              temp:=dmGenData.Query1.Fields[0].AsString;
              DecodePlace(temp,sArticle,sDetail,sCity,sRegion,sProvince,sCountry);
              L0.Text:=sDetail;
              L1.text:=sCity;
              L2.text:=sRegion;
              L3.text:=sProvince;
              L4.text:=sCountry;
              found:=true;
              break;
           end;
        end;
     end;
  end;
  if frmEditEvents.ActiveControl.Name='L3' then
     begin
     found:=false;
     For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,j]='L' then
           begin
           dmGenData.Query1.SQL.Text:='SELECT L FROM L WHERE no='+frmStemmaMainForm.DataHist.Cells[1,j];
           dmGenData.Query1.Open;
           temp:=dmGenData.Query1.Fields[0].AsString;
           DecodePlace(temp,sArticle,sDetail,sCity,sRegion,sProvince,sCountry);
           L0.Text:=sDetail;
           L1.text:=sCity;
           L2.text:=sRegion;
           L3.text:=sProvince;
           L4.text:=sCountry;
           found:=true;
           break;
        end;
     end;
     if not found then
        begin
        For j:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
           begin
           if frmStemmaMainForm.DataHist.Cells[0,j]='L' then
              begin
              dmGenData.Query1.SQL.Text:='SELECT L FROM L WHERE no='+frmStemmaMainForm.DataHist.Cells[1,j];
              dmGenData.Query1.Open;
              temp:=dmGenData.Query1.Fields[0].AsString;
              DecodePlace(temp,sArticle,sDetail,sCity,sRegion,sProvince,sCountry);
              L0.Text:=sDetail;
              L1.text:=sCity;
              L2.text:=sRegion;
              L3.text:=sProvince;
              L4.text:=sCountry;
              found:=true;
              break;
           end;
        end;
     end;
  end;
  if frmEditEvents.ActiveControl.Name='L4' then
     begin
     found:=false;
     For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,j]='L' then
           begin
           dmGenData.Query1.SQL.Text:='SELECT L FROM L WHERE no='+frmStemmaMainForm.DataHist.Cells[1,j];
           dmGenData.Query1.Open;
           temp:=dmGenData.Query1.Fields[0].AsString;
           DecodePlace(temp,sArticle,sDetail,sCity,sRegion,sProvince,sCountry);
           L0.Text:=sDetail;
           L1.text:=sCity;
           L2.text:=sRegion;
           L3.text:=sProvince;
           L4.text:=sCountry;
           found:=true;
           break;
        end;
     end;
     if not found then
        begin
        For j:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
           begin
           if frmStemmaMainForm.DataHist.Cells[0,j]='L' then
              begin
              dmGenData.Query1.SQL.Text:='SELECT L FROM L WHERE no='+frmStemmaMainForm.DataHist.Cells[1,j];
              dmGenData.Query1.Open;
              temp:=dmGenData.Query1.Fields[0].AsString;
              DecodePlace(temp,sArticle,sDetail,sCity,sRegion,sProvince,sCountry);
              L0.Text:=sDetail;
              L1.text:=sCity;
              L2.text:=sRegion;
              L3.text:=sProvince;
              L4.text:=sCountry;
              found:=true;
              break;
           end;
        end;
     end;
  end;
    if frmEditEvents.ActiveControl.Name='SD' then
       begin
       found:=false;
       For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
          begin
          if frmStemmaMainForm.DataHist.Cells[0,j]='SD' then
             begin
             fraDate1.SortDate:=ConvertDate(frmStemmaMainForm.DataHist.Cells[1,j],1);
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
                fraDate1.SortDate:=ConvertDate(frmStemmaMainForm.DataHist.Cells[1,j],1);
                found:=true;
                break;
             end;
          end;
       end;
    end;
    if frmEditEvents.ActiveControl.Name='PD' then
       begin
       found:=false;
       For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
          begin
          if frmStemmaMainForm.DataHist.Cells[0,j]='PD' then
             begin
             fraDate1.Date:=ConvertDate(frmStemmaMainForm.DataHist.Cells[1,j],1);
             found:=true;
             break;
          end;
       end;
       if not found then
          begin
          For j:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
             begin
             if frmStemmaMainForm.DataHist.Cells[0,j]='PD' then
                begin
                fraDate1.Date:=ConvertDate(frmStemmaMainForm.DataHist.Cells[1,j],1);
                found:=true;
                break;
             end;
          end;
       end;
    end;
    if frmEditEvents.ActiveControl.Name='M' then
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


procedure TfrmEditEvents.Button1Click(Sender: TObject);
var
  Lieu1,Lieu2,dateev, lEvType, lDate, lSortDate,  lInfo:string;
  valide:boolean;
  lidInd,idPlace, lIdPlace, lidEvent,result:integer;
  lPrefered: boolean;
begin
  // Vérifie qu'il y a au moins 1 témoin
  valide:=TableauTemoins.RowCount>1;
  if not valide then
     begin
     Application.MessageBox(pchar(Translation.Items[301]),pchar(Translation.Items[124]),MB_OK)
  end
  else
     begin
     fraDate1.Finishediting(Sender,ActiveControl);
     // Trouve le lieu équivalent !!!
     LA.Text:=trim(LA.Text);
     L0.Text:=trim(L0.Text);
     L1.Text:=trim(L1.Text);
     L2.Text:=trim(L2.Text);
     L3.Text:=trim(L3.Text);
     L4.Text:=trim(L4.Text);
     Lieu1:='!TMG|'+trim(LA.Text+' '+L0.Text)+'|'+L1.Text+'|'+L2.Text+'|'+L3.Text+'|'+L4.Text+'||||';
     Lieu2:='';
     if Length(LA.TexT)>0 then
        Lieu2:='<'+CTagNameArticle+'>'+LA.Text+'</'+CTagNameArticle+'>';
     if Length(L0.TexT)>0 then
        Lieu2:=Lieu2+'<'+CTagNameDetail+'>'+L0.Text+'</'+CTagNameDetail+'>';
     L1.Text:=trim(L1.Text);
     if Length(L1.TexT)>0 then
        Lieu2:=Lieu2+'<Ville>'+L1.Text+'</Ville>';
     L2.Text:=trim(L2.Text);
     if Length(L2.TexT)>0 then
        Lieu2:=Lieu2+'<Région>'+L2.Text+'</Région>';
     L3.Text:=trim(L3.Text);
     if Length(L3.TexT)>0 then
        Lieu2:=Lieu2+'<Province>'+L3.Text+'</Province>';
     L4.Text:=trim(L4.Text);
     if Length(L4.TexT)>0 then
        Lieu2:=Lieu2+'<Pays>'+L4.Text+'</Pays>';
     Lieu1:=AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(Lieu1,'\','\\'),'"','\"'),'''','\''');
     Lieu2:=AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(Lieu2,'\','\\'),'"','\"'),'''','\''');
     dmGenData.Query1.SQL.Clear;
     dmGenData.Query1.SQL.Add('SELECT L.no FROM L WHERE L.L='''+UTF8toANSI(Lieu2)+'''');
     dmGenData.Query1.Open;
     if not dmGenData.Query1.EOF then
        idPlace:=dmGenData.Query1.Fields[0].AsInteger
     else
        begin
        dmGenData.Query1.SQL.Clear;
        dmGenData.Query1.SQL.Add('SELECT L.no FROM L WHERE L.L='''+UTF8toANSI(Lieu1)+'''');
        dmGenData.Query1.Open;
        if not dmGenData.Query1.EOF then
           idPlace:=dmGenData.Query1.Fields[0].AsInteger
        else // Ajoute le lieu dans la table
           begin
           dmGenData.Query1.SQL.Clear;
           dmGenData.Query1.SQL.Add('INSERT INTO L (L) VALUES ('''+UTF8toANSI(Lieu2)+''')');
           dmGenData.Query1.ExecSQL;
           dmGenData.Query1.SQL.Clear;
           dmGenData.Query1.SQL.Add('SELECT L.no FROM L WHERE L.L='''+UTF8toANSI(Lieu2)+'''');
           dmGenData.Query1.Open;
           idPlace:=dmGenData.Query1.Fields[0].AsInteger;
        end;
     end;
     if idPlace>1 then
        begin
        frmStemmaMainForm.DataHist.InsertColRow(false,0);
        frmStemmaMainForm.DataHist.Cells[0,0]:='L';
        frmStemmaMainForm.DataHist.Cells[1,0]:=inttostr(idPlace);
        frmStemmaMainForm.DataHist.Objects[1,0]:=TObject(ptrint(idPlace));
     end;  {SetVarInitHere}
     lIdPlace:=idPlace;
     lInfo:=trim(M.Text);
     lDate:=fraDate1.Date;
     lSortDate:=fraDate1.SortDate;
     lPrefered:=X.Text='1';
     lidEvent:=no.Value;;
     result:=dmGenData.SaveEventData(lPrefered, lidEvent, lIdPlace, lInfo, lDate,
       lSortDate,idEventType);

        if No.Value=0 then
           begin
            No.Value:=result;
        // Ajoute le témoin qui a été ajouté par défaut dans le tableau
        dmGenData.Query1.SQL.Clear;
        dmGenData.Query1.SQL.Add('INSERT INTO W (R, I, P, E, X) VALUES ('''+UTF8ToANSI(TableauTemoins.Cells[1,1])+
                ''', '+TableauTemoins.Cells[2,1]+', '''', '+no.Text+', 1)');
        dmGenData.Query1.ExecSQL;
        TableauTemoins.Cells[0,1]:=InttoStr(dmGenData.GetLastIDOfTable('W'));
     end;
     // Sauvegarder les modifications pour tous les témoins de l'événements
     dmGenData.Query3.SQL.Text:='SELECT W.I, W.X FROM W WHERE W.E='+no.Text;
     dmGenData.Query3.Open;
     dmGenData.Query3.First;
     lidInd:=0;
     While not dmGenData.Query3.EOF do
        begin
        if dmGenData.Query3.Fields[1].AsBoolean then
           lidInd:=dmGenData.Query3.Fields[0].AsInteger;
        dmGenData.SaveModificationTime(dmGenData.Query3.Fields[0].AsInteger);

        // UPDATE DÉCÈS si la date est il y a 100 ans !!!
        if (copy(fraDate1.Date,1,1)='1') and not (fraDate1.Date='100000000030000000000') then
           dateev:=Copy(fraDate1.Date,2,4)
        else
           if (copy(fraDate1.SortDate,1,1)='1') and not (fraDate1.SortDate='100000000030000000000') then
              dateev:=Copy(fraDate1.SortDate,2,4)
           else
              dateev:=FormatDateTime('YYYY',now);
        if ((StrtoInt(FormatDateTime('YYYY',now))-StrtoInt(dateev))>100) then
           begin
           dmGenData.Query2.SQL.Text:='UPDATE I SET V=''N'' WHERE no='+inttostr(lidInd);
           dmGenData.Query2.ExecSQL;
           If (frmStemmaMainForm.actWinNameAndAttr.Checked) and (lidInd=frmStemmaMainForm.iID) then
              frmNames.PopulateNom(Sender);
        end;

        dmGenData.Query3.Next;
     end;
     // Modifier la ligne de l'explorateur si naissance frmStemmaMainForm ou décès principal
     dmGenData.Query1.SQL.Text:='SELECT Y.Y, E.X, E.PD FROM Y JOIN E on E.Y=Y.no WHERE E.no='+no.Text;
     dmGenData.Query1.Open;
     lEvType:=dmGenData.Query1.Fields[0].AsString;
     lDate:= dmGenData.Query1.Fields[2].AsString;
     if (lEvType='B') then
        begin
    dmGenData.UpdateNameI3(lDate, lidInd);
                                             // fr: Update date de tri de relation
                 // en: Update sort-date of relationship
                 dmGenData.UpdateRelationSortdate(lidInd, lDate);
        end
  else  if (lEvType='D') then
     begin
    dmGenData.UpdateNameI4(lDate, lidInd);
    // UPDATE DÉCÈS!!!
     dmGenData.UpdateIndLiving(lidInd,'N',Sender);
     end;
     if  (lidInd>0) and
        ((lEvType='B') or ((lEvType='D'))) and
        (dmGenData.Query1.Fields[1].AsInteger=1) and (X.Text='1') then
        begin
        if frmStemmaMainForm.actWinExplorer.Checked then
          frmExplorer.UpdateIndexDates(lEvType,lDate,lidInd);
     end;
  end;
end;

procedure TfrmEditEvents.AjouterTemoinClick(Sender: TObject);
begin
  // Ajouter un témoin à l'événement
  If no.text='0' then
     Button1Click(Sender);
//  dmGenData.PutCode('A',no.text);
  frmEditWitness.idWitness:=0;
  frmEditWitness.idEvent:=no.value;
  If frmEditWitness.Showmodal=mrOK then
     PopulateTemoins(no.text);
end;

procedure TfrmEditEvents.SupprimerTemoinClick(Sender: TObject);
begin
  If (TableauTemoins.RowCount>1) and (TableauTemoins.Row>0) then  // Il faudra qu'il reste au moins un témoin
     if Application.MessageBox(Pchar(Translation.Items[32]+
        TableauTemoins.Cells[3,TableauTemoins.Row]+' ('+
        TableauTemoins.Cells[1,TableauTemoins.Row]+')'+Translation.Items[28]),pchar(SConfirmation),MB_YESNO)=IDYES then
        begin
        // Exécuter SAVEMODIFICATIONTIME pour le témoin supprimer
        dmGenData.SaveModificationTime(strtoint(TableauTemoins.Cells[2,TableauTemoins.Row]));
        dmGenData.Query1.SQL.Text:='DELETE FROM W WHERE no='+TableauTemoins.Cells[0,TableauTemoins.Row];
        dmGenData.Query1.ExecSQL;
        TableauTemoins.DeleteRow(TableauTemoins.Row);
        // Sauvegarder les modifications pour tous les témoins de l'événements
        dmGenData.Query3.SQL.Text:='SELECT W.I, W.X FROM W WHERE W.E='+no.Text;
        dmGenData.Query3.Open;
        dmGenData.Query3.First;
        While not dmGenData.Query3.EOF do
           begin
           dmGenData.SaveModificationTime(dmGenData.Query3.Fields[0].AsInteger);
           dmGenData.Query3.Next;
        end;
     end;
end;

function PopulateTemoins(Event:string):string;
var
  row:integer;
  phrase:string;
begin
  dmGenData.Query1.SQL.Text:='SELECT W.no, W.I, W.X, W.P, W.R, N.N FROM W JOIN N ON N.I=W.I WHERE W.E='+
                           Event+' AND N.X=1 ORDER BY W.X DESC';
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  frmEditEvents.TableauTemoins.RowCount:=dmGenData.Query1.RecordCount+1;
  row:=1;
  while not dmGenData.Query1.eof do
     begin
     frmEditEvents.TableauTemoins.Cells[0,row]:=dmGenData.Query1.Fields[0].AsString;
     frmEditEvents.TableauTemoins.Cells[1,row]:=dmGenData.Query1.Fields[4].AsString;
     frmEditEvents.TableauTemoins.Cells[2,row]:=dmGenData.Query1.Fields[1].AsString;
     frmEditEvents.TableauTemoins.Cells[3,row]:=DecodeName(dmGenData.Query1.Fields[5].AsString,1);
     if dmGenData.Query1.Fields[2].AsBoolean then
        frmEditEvents.TableauTemoins.Cells[4,row]:='*'
     else
        frmEditEvents.TableauTemoins.Cells[4,row]:='';
     if dmGenData.Query1.Fields[1].AsString=frmStemmaMainForm.sID then
        begin
        phrase:=dmGenData.Query1.Fields[3].AsString;
        frmEditEvents.Role.Text:=dmGenData.Query1.Fields[4].AsString;
     end;
     row:=row+1;
     dmGenData.Query1.Next;
  end;
  PopulateTemoins:=phrase;
end;

end.

