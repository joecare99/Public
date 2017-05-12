unit frm_Documents;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Menus,
  frm_EditDocuments, frm_Images, LCLType, ActnList;

type

  { TfrmDocuments }

  TfrmDocuments = class(TForm)
    actDocumentsDelete: TAction;
    actDocumentsEdit: TAction;
    actDocumentsAdd: TAction;
    actDocumentsSetPrefered: TAction;
    ActionList1: TActionList;
    mniSetPrefered: TMenuItem;
    mniSeparator: TMenuItem;
    mniAdd: TMenuItem;
    mniEdit: TMenuItem;
    mniDelete: TMenuItem;
    mnuDocuments: TPopupMenu;
    tblDocuments: TStringGrid;
    procedure actDocumentsAddUpdate(Sender: TObject);
    procedure actDocumentsDeleteUpdate(Sender: TObject);
    procedure actDocumentsSetPreferedUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actDocumentsSetPreferedExecute(Sender: TObject);
    procedure actDocumentsAddExecute(Sender: TObject);
    procedure actDocumentsDeleteExecute(Sender: TObject);
    procedure mnuModifyClick(Sender: TObject);
    procedure tblDocumentsDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; {%H-}aState: TGridDrawState);
    procedure tblDocumentsSelection(Sender: TObject; {%H-}aCol, aRow: Integer);
  private
    { private declarations }
  public
    { public declarations }
  end; 

procedure PopulateDocuments(Tableau:TStringGrid;Code:string;no:integer);

var
  frmDocuments: TfrmDocuments;

implementation

uses
  frm_Main, cls_Translation, dm_GenData;

{$R *.lfm}

{ TfrmDocuments }

procedure TfrmDocuments.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  dmGenData.WriteCfgFormPosition(Self);
  dmGenData.WriteCfgGridPosition(tblDocuments as TStringGrid,4);
end;

procedure TfrmDocuments.actDocumentsSetPreferedUpdate(Sender: TObject);
begin
  actDocumentsSetPrefered.Enabled:=tblDocuments.Cells[1,tblDocuments.Row]<> '*';
end;

procedure TfrmDocuments.actDocumentsAddUpdate(Sender: TObject);
begin
  actDocumentsAdd.Enabled:=true;
end;

procedure TfrmDocuments.actDocumentsDeleteUpdate(Sender: TObject);
begin
  actDocumentsDelete.Enabled:=(tblDocuments.Cells[1,tblDocuments.row]<>'*') or
    (tblDocuments.RowCount<3);
end;

procedure TfrmDocuments.FormResize(Sender: TObject);
begin
  tblDocuments.Width := (Sender as Tform).Width;
  tblDocuments.Height := (Sender as Tform).Height;
  tblDocuments.Columns[1].Width := (Sender as Tform).Width-122;
end;

procedure TfrmDocuments.FormShow(Sender: TObject);
begin
  Caption:=Translation.Items[65];
  mniSetPrefered.Caption:=Translation.Items[234];
  mniAdd.Caption:=Translation.Items[224];
  mniEdit.Caption:=Translation.Items[225];
  mniDelete.Caption:=Translation.Items[226];
  tblDocuments.Cells[2,0]:=Translation.Items[154];
  tblDocuments.Cells[3,0]:=Translation.Items[185];
  tblDocuments.Cells[4,0]:=Translation.Items[201];
  dmGenData.ReadCfgFormPosition(Sender as TForm,0,0,200,200);
  dmGenData.ReadCfgGridPosition(frmDocuments.tblDocuments as TStringGrid,4);
  PopulateDocuments(tblDocuments,'I',frmStemmaMainForm.iID);
end;

procedure TfrmDocuments.actDocumentsSetPreferedExecute(Sender: TObject);
begin
  if tblDocuments.Cells[3,tblDocuments.row]='I' then
     begin
     dmGenData.Query1.SQL.Clear;
     If tblDocuments.Cells[1,tblDocuments.row]='*' then
        dmGenData.Query1.SQL.Add('UPDATE X SET X=0 WHERE X.no='+
                                  tblDocuments.Cells[0,tblDocuments.row])
     else
        begin
        dmGenData.Query1.SQL.Add('UPDATE X SET X=0 WHERE X.A=''I'' AND X.N='+
                                  frmStemmaMainForm.sID);
        dmGenData.Query1.ExecSQL;
        dmGenData.Query1.SQL.Text:='UPDATE X SET X=1 WHERE X.no='+
                                  tblDocuments.Cells[0,tblDocuments.row];
     end;
     dmGenData.Query1.ExecSQL;
     // Modifie la date de modification
     dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
     PopulateDocuments(tblDocuments,'I',frmStemmaMainForm.iID);
  end
  else
     ShowMessage(Translation.Items[61]);
end;

procedure TfrmDocuments.actDocumentsAddExecute(Sender: TObject);
begin
  // Ajouter un exhibit
  dmGenData.PutCode('I',frmStemmaMainForm.iID);
  dmGenData.PutCode('A',frmStemmaMainForm.iID);
  If frmEditDocuments.Showmodal=mrOK then
      PopulateDocuments(tblDocuments,'I',frmStemmaMainForm.iID);
end;

procedure TfrmDocuments.actDocumentsDeleteExecute(Sender: TObject);
begin
  // Supprimer un exhibit
  if tblDocuments.Row>0 then
     if Application.MessageBox(Pchar(Translation.Items[62]+
        tblDocuments.Cells[2,tblDocuments.Row]+Translation.Items[28]),pchar(Translation.Items[1]),MB_YESNO)=IDYES then
        begin
        dmGenData.Query1.SQL.Text:='DELETE FROM X WHERE no='+tblDocuments.Cells[0,tblDocuments.Row];
        dmGenData.Query1.ExecSQL;
        tblDocuments.DeleteRow(tblDocuments.Row);
        if frmStemmaMainForm.actWinImages.Checked then
           begin
           if tblDocuments.Row>0 then
              tblDocumentsSelection(Sender,0,tblDocuments.Row)
           else
              FormImage.Im.Picture.Clear;
        end;
        dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
     end;
end;

procedure TfrmDocuments.mnuModifyClick(Sender: TObject);
begin
  If tblDocuments.Row>0 then
     begin
     dmGenData.PutCode('E',tblDocuments.Cells[0,tblDocuments.Row]);
     If frmEditDocuments.Showmodal=mrOK then
        PopulateDocuments(tblDocuments,'I',frmStemmaMainForm.iID);
     end;
end;

procedure TfrmDocuments.tblDocumentsDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin
  if ((Sender as TStringGrid).Cells[1,aRow]='*') and (aCol=2) then
     begin
     (Sender as TStringGrid).Canvas.Font.Bold := true;
     (Sender as TStringGrid).Canvas.TextOut(aRect.Left+2,aRect.Top+2,(Sender as TStringGrid).Cells[aCol,aRow]);
  end;
end;

procedure TfrmDocuments.tblDocumentsSelection(Sender: TObject; aCol,
  aRow: Integer);
begin
  if tblDocuments.Cells[1,aRow]='*' then
     PopulateImage(0)
  else
     PopulateImage(StrToInt(tblDocuments.Cells[0,aRow]));
end;

procedure PopulateDocuments(Tableau:TStringGrid;code:string;no:integer);
var
  row:integer;
  titre,desc:string;
begin
  if code='I' then
     begin
     dmGenData.Query1.SQL.Clear;
     // Ajouter les exhibits de l'individu
     dmGenData.Query1.SQL.add('SELECT X.no, X.X, X.T, X.D, X.F, X.A FROM X WHERE (X.A=''I'' AND X.N='+
                               inttostr(no)+')'+' ORDER BY X.T');
     dmGenData.Query1.Open;
     dmGenData.Query1.First;
     row:=1;
     Tableau.RowCount:=dmGenData.Query1.RecordCount+1;
     While not dmGenData.Query1.EOF do
     begin
        Tableau.Cells[0,row]:=dmGenData.Query1.Fields[0].AsString;
        if dmGenData.Query1.Fields[1].AsBoolean then
           Tableau.Cells[1,row]:='*'
        else
           Tableau.Cells[1,row]:='';
        titre:=dmGenData.Query1.Fields[2].AsString;
        desc:=dmGenData.Query1.Fields[3].AsString;
        if length(titre)=0 then
           if length(desc)=0 then
              Tableau.Cells[2,row]:=Translation.Items[63]
           else
              Tableau.Cells[2,row]:=desc
        else
           if length(desc)=0 then
              Tableau.Cells[2,row]:=titre
           else
              Tableau.Cells[2,row]:=titre+', '+desc;
        Tableau.Cells[3,row]:=dmGenData.Query1.Fields[5].AsString;
        if length(dmGenData.Query1.Fields[4].AsString)=0 then
           Tableau.Cells[4,row]:=Translation.Items[34]
        else
           Tableau.Cells[4,row]:=Translation.Items[64];
        dmGenData.Query1.Next;
        row:=row+1;
     end;
  end
  else
    Tableau.RowCount:=1;
  // Ajouter les exhibits des événements
  dmGenData.Query1.SQL.Clear;
  if code='I' then
     dmGenData.Query1.SQL.add('SELECT X.no, X.X, X.T, X.D, X.F, X.A FROM (X JOIN E on X.N=E.no) JOIN W on W.E=E.no WHERE (X.A=''E'' AND W.I='+
                               inttostr(no)+')'+' ORDER BY X.T');
  if code='E' then
     dmGenData.Query1.SQL.add('SELECT X.no, X.X, X.T, X.D, X.F, X.A FROM X WHERE X.A=''E'' AND X.N='+
                               inttostr(no)+' ORDER BY X.T');
  if code='S' then
     dmGenData.Query1.SQL.add('SELECT X.no, X.X, X.T, X.D, X.F, X.A FROM X WHERE X.A=''S'' AND X.N='+
                               inttostr(no)+' ORDER BY X.T');
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  Tableau.RowCount:=Tableau.RowCount+dmGenData.Query1.RecordCount;
  While not dmGenData.Query1.EOF do
  begin
     Tableau.Cells[0,row]:=dmGenData.Query1.Fields[0].AsString;
     Tableau.Cells[1,row]:='';
     titre:=dmGenData.Query1.Fields[2].AsString;
     desc:=dmGenData.Query1.Fields[3].AsString;
     if length(titre)=0 then
        if length(desc)=0 then
           Tableau.Cells[2,row]:=Translation.Items[63]
        else
           Tableau.Cells[2,row]:=desc
     else
        if length(desc)=0 then
           Tableau.Cells[2,row]:=titre
        else
           Tableau.Cells[2,row]:=titre+', '+desc;
     Tableau.Cells[3,row]:=dmGenData.Query1.Fields[5].AsString;
     if length(dmGenData.Query1.Fields[4].AsString)=0 then
        Tableau.Cells[4,row]:=Translation.Items[34]
     else
        Tableau.Cells[4,row]:=Translation.Items[64];
     dmGenData.Query1.Next;
     row:=row+1;
  end;
  if code='I' then
     frmDocuments.Caption:=Translation.Items[65]+' ('+IntToStr(Tableau.RowCount-1)+')';
end;
end.

