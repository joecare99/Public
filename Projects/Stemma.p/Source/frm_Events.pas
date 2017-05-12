unit frm_Events;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Menus,
  FMUtils, LCLType;

type

  { TfrmEvents }

  TfrmEvents = class(TForm)
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    PopupMenuEvenements: TPopupMenu;
    TableauEvenements: TStringGrid;
    procedure FormClose(Sender: TObject; var {%H-}CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure TableauEvenementsDblClick(Sender: TObject);
    procedure TableauEvenementsDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; {%H-}aState: TGridDrawState);
  private
    function GetidEvent: Integer;
    { private declarations }
  public
    { public declarations }
    Procedure PopulateEvents(Sender:TObject);
    property idEvent:Integer read GetidEvent;
  end;


var
  frmEvents: TfrmEvents;

implementation

uses
  frm_Main,cls_Translation, dm_GenData,frm_EditEvents, frm_Explorer, frm_Documents;

{ TfrmEvents }

procedure TfrmEvents.PopulateEvents(Sender: TObject);
var
  age, row:integer;
  lieu, memo, temoin:string;
begin
  dmGenData.Query1.close;
  dmGenData.Query1.SQL.text:='SELECT E.no, E.X, E.Y, E.PD, E.L, E.SD, W.X, E.M FROM E JOIN W on W.E=E.no WHERE W.I=:idInd ORDER BY E.SD';
  dmGenData.Query1.ParamByName('idInd').AsInteger:=frmStemmaMainForm.iID;
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  row:=1;
  TableauEvenements.RowCount:=dmGenData.Query1.RecordCount+1;
  assert( dmGenData.Query1.Fields.Count=8,'Query should have 8 Fields');
  While not dmGenData.Query1.EOF do
  begin
     TableauEvenements.Cells[0,row]:=dmGenData.Query1.Fields[0].AsString;
     if dmGenData.Query1.Fields[1].AsBoolean and dmGenData.Query1.Fields[6].AsBoolean then
         TableauEvenements.Cells[1,row]:='*'
     else
         TableauEvenements.Cells[1,row]:='';
     dmGenData.Query2.SQL.Text:='SELECT T FROM Y WHERE no='+dmGenData.Query1.Fields[2].AsString;
     dmGenData.Query2.Open;
      TableauEvenements.Cells[2,row]:=dmGenData.Query2.Fields[0].AsString;
      TableauEvenements.Cells[3,row]:=ConvertDate(dmGenData.Query1.Fields[3].AsString,1);
     // Trouver # d'un autre principal témoin de l'événement
     dmGenData.Query2.close;
     dmGenData.Query2.SQL.Text:='SELECT I FROM W WHERE X=1 AND E='+dmGenData.Query1.Fields[0].AsString;
     dmGenData.Query2.Open;
      TableauEvenements.Cells[7,row]:='0';
     temoin:='';
     While not dmGenData.Query2.EOF do
         begin
         // Trouver les témoins principaux de l'événement
         If not (dmGenData.Query2.Fields[0].AsString=frmStemmaMainForm.sID) then
            begin
            if StrToInt( TableauEvenements.Cells[7,row])=0 then
                TableauEvenements.Cells[7,row]:=dmGenData.Query2.Fields[0].AsString;
            dmGenData.Query3.SQL.Text:='SELECT N FROM N WHERE X=1 AND I='+dmGenData.Query2.Fields[0].AsString;
            dmGenData.Query3.Open;
            if length(temoin)>0 then
               temoin:=temoin+' & '+DecodeName(dmGenData.Query3.Fields[0].AsString,1)+' ['+dmGenData.Query2.Fields[0].AsString+']'
            else
               temoin:=DecodeName(dmGenData.Query3.Fields[0].AsString,1)+' ['+dmGenData.Query2.Fields[0].AsString+']';
         end;
         dmGenData.Query2.Next;
     end;
     // Implanter la description
     dmGenData.Query2.SQL.Text:='SELECT L FROM L WHERE no='+dmGenData.Query1.Fields[4].AsString;
     dmGenData.Query2.Open;
     Lieu:=DecodeChanged(dmGenData.Query2.Fields[0].AsString);
     Memo:=dmGenData.Query1.Fields[7].AsString;
     If length(Lieu)>0 then
        if length(Memo)>0 then
           if length(temoin)>0 then
               TableauEvenements.Cells[4,row]:=Temoin+'; '+Lieu+'; '+Memo
           else
               TableauEvenements.Cells[4,row]:=Lieu+'; '+Memo
        else
           if length(temoin)>0 then
               TableauEvenements.Cells[4,row]:=Temoin+'; '+Lieu
           else
               TableauEvenements.Cells[4,row]:=Lieu
     else
           if length(Memo)>0 then
              if length(temoin)>0 then
                  TableauEvenements.Cells[4,row]:=Temoin+'; '+Memo
              else
                  TableauEvenements.Cells[4,row]:=Memo
           else
              if length(temoin)>0 then
                  TableauEvenements.Cells[4,row]:=Temoin
              else
                  TableauEvenements.Cells[4,row]:='';
     dmGenData.Query2.SQL.Text:='SELECT Q FROM C WHERE Y=''E'' AND N='+ TableauEvenements.Cells[0,row]+' ORDER BY Q DESC';
     dmGenData.Query2.Open;
      TableauEvenements.Cells[5,row]:=dmGenData.Query2.Fields[0].AsString;
     // Calculer l'âge
     dmGenData.Query2.SQL.Text:='SELECT I3 FROM N WHERE X=1 AND I='+frmStemmaMainForm.sID;
     dmGenData.Query2.Open;
     if ((Copy(dmGenData.Query2.Fields[0].AsString,1,1)='1') AND
         (Copy(dmGenData.Query1.Fields[5].AsString,1,1)='1')) then
         age:=StrToInt(Copy(dmGenData.Query1.Fields[5].AsString,2,4))
               -StrtoInt(Copy(dmGenData.Query2.Fields[0].AsString,2,4))
     else
        age:=-1;
     if (age>=0) AND (age<200) then
          TableauEvenements.Cells[6,row]:=InttoStr(age)
     else
         TableauEvenements.Cells[6,row]:='';
     if dmGenData.Query1.Fields[6].AsBoolean then
         TableauEvenements.Cells[8,row]:='*'
     else
         TableauEvenements.Cells[8,row]:='';
     dmGenData.Query1.Next;
     row:=row+1;
  end;
   Caption:=Translation.Items[59]+' ('+IntToStr( TableauEvenements.RowCount-1)+')';
end;

procedure TfrmEvents.MenuItem1Click(Sender: TObject);
begin
  if TableauEvenements.Row>0 then
     If StrToInt(TableauEvenements.Cells[7,TableauEvenements.Row])>0 then
        frmStemmaMainForm.iID:=Ptrint(TableauEvenements.objects[7,TableauEvenements.Row]);
end;

procedure TfrmEvents.MenuItem3Click(Sender: TObject);
begin
  dmGenData.PutCode('A',0);
  frmEditEvents.EditType:=eEET_New;
  if frmEditEvents.Showmodal = mrOK then
     begin
     PopulateEvents(Sender);
     // Devrait modifier la fenêtre des exhibits aussi si elle est affichée (modifier et supprimer aussi)
     if frmStemmaMainForm.actWinDocuments.Checked then
        PopulateDocuments(frmDocuments.tblDocuments,'I',frmStemmaMainForm.iID);
  end;
end;

procedure TfrmEvents.MenuItem5Click(Sender: TObject);
begin
  // Supprimer un événement
  if TableauEvenements.Row>0 then
     if TableauEvenements.Cells[1,TableauEvenements.Row]='' then
        if Application.MessageBox(Pchar(Translation.Items[60]+
           TableauEvenements.Cells[2,TableauEvenements.Row]+'-'+TableauEvenements.Cells[4,TableauEvenements.Row]+
           Translation.Items[28]),pchar(Translation.Items[1]),MB_YESNO)=IDYES then
           begin
           // Modifie la date de dernière modification pour tous les témoins
           dmGenData.Query3.SQL.Text:='SELECT W.I, W.X FROM W WHERE W.E='+TableauEvenements.Cells[0,TableauEvenements.Row];
           dmGenData.Query3.Open;
           dmGenData.Query3.First;
           While not dmGenData.Query3.EOF do
              begin
              dmGenData.SaveModificationTime(dmGenData.Query3.Fields[0].AsInteger);
              dmGenData.Query3.Next;
           end;
           // Supprimer tous les exhibits de cet événement
           dmGenData.Query1.SQL.Text:='DELETE FROM X WHERE A=''E'' AND N='+TableauEvenements.Cells[0,TableauEvenements.Row];
           dmGenData.Query1.ExecSQL;
           dmGenData.Query1.SQL.Text:='DELETE FROM C WHERE Y=''E'' AND N='+TableauEvenements.Cells[0,TableauEvenements.Row];
           dmGenData.Query1.ExecSQL;
           dmGenData.Query1.SQL.Text:='DELETE FROM W WHERE E='+TableauEvenements.Cells[0,TableauEvenements.Row];
           dmGenData.Query1.ExecSQL;
           dmGenData.Query1.SQL.Text:='DELETE FROM E WHERE no='+TableauEvenements.Cells[0,TableauEvenements.Row];
           dmGenData.Query1.ExecSQL;
           TableauEvenements.DeleteRow(TableauEvenements.Row);
           // Devrait modifier la fenêtre des exhibits aussi si elle est affichée (modifier et supprimer aussi)
           if frmStemmaMainForm.actWinDocuments.Checked then
              PopulateDocuments(frmDocuments.tblDocuments,'I',frmStemmaMainForm.iID);
        end;
end;

procedure TfrmEvents.MenuItem7Click(Sender: TObject);
var
  temoins1, temoins2, lEvType, lDate:string;
  redraw :boolean;
  lidInd: LongInt;
begin
   redraw:=false;
   if TableauEvenements.Row>0 then
      begin
      // si c'est un témoin primaire de l'événement sélectionné
      dmGenData.Query1.SQL.Text:='SELECT E.no, E.X, W.I, E.Y, Y.Y FROM E JOIN W on W.E=E.no JOIN Y on E.Y=Y.no WHERE W.X=1 AND W.I='+frmStemmaMainForm.sID+
                                ' AND E.no='+TableauEvenements.Cells[0,TableauEvenements.Row];
      dmGenData.Query1.Open;
      dmGenData.Query1.First;
      lEvType:=dmGenData.Query1.Fields[4].AsString;
      lidInd :=dmGenData.Query1.Fields[2].AsInteger;
      if not dmGenData.Query1.eof then
         begin
         // si primaire, enlève le primaire de la base de données et du tableau.
         if dmGenData.Query1.Fields[1].AsBoolean then
            begin
            dmGenData.Query2.SQL.Text:='UPDATE E SET X=0 WHERE no='+TableauEvenements.Cells[0,TableauEvenements.Row];
            dmGenData.Query2.ExecSQL;
            TableauEvenements.Cells[1,TableauEvenements.Row]:='';
            redraw:=true;
            if frmStemmaMainForm.actWinExplorer.Checked then
               frmExplorer.UpdateIndexDates(lEvType,'',lidInd);
         end
         // sinon
         else
            begin
            // trouve si autre événement du même types avec même témoins primaires qui est primaire
            dmGenData.Query2.SQL.Text:='SELECT W.I FROM W WHERE W.X=1 AND W.E='
                                      +TableauEvenements.Cells[0,TableauEvenements.Row]+' ORDER BY W.I';
            dmGenData.Query2.Open;
            dmGenData.Query2.First;
            temoins1:='';
            While not dmGenData.Query2.Eof do
               begin
               temoins1:=temoins1+'|'+dmGenData.Query2.Fields[0].AsString;
               dmGenData.Query2.Next;
            end;


            dmGenData.Query2.SQL.Clear;
            // Todo: Error: dmGenData.Query1.eof := true => No Data !!!
            if dmGenData.Query1.Fields[4].AsString='X' then
               dmGenData.Query2.SQL.add('SELECT E.no, W.I FROM E JOIN W on W.E=E.no WHERE W.X=1 AND E.X=1 AND E.Y='
                                         +dmGenData.Query1.Fields[3].AsString+' AND W.I='+frmStemmaMainForm.sID)
            else
               dmGenData.Query2.SQL.add('SELECT E.no, W.I FROM E JOIN W on W.E=E.no JOIN Y on E.Y=Y.no WHERE W.X=1 AND E.X=1 AND Y.Y='''
                                         +dmGenData.Query1.Fields[4].AsString+''' AND W.I='+frmStemmaMainForm.sID);
            dmGenData.Query2.Open;
            dmGenData.Query2.First;
            While not dmGenData.Query2.Eof do
               begin
               dmGenData.Query3.SQL.Text:='SELECT W.I FROM W WHERE W.X=1 AND W.E='
                                         +dmGenData.Query2.Fields[0].AsString+' ORDER BY W.I';
               dmGenData.Query3.Open;
               dmGenData.Query3.First;
               temoins2:='';
               While not dmGenData.Query3.Eof do
                  begin
                  temoins2:=temoins2+'|'+dmGenData.Query3.Fields[0].AsString;
                  dmGenData.Query3.Next;
               end;
               // Enlève son tag primaire
               if temoins1=temoins2 then
                  begin
                  dmGenData.Query3.SQL.Text:='UPDATE E SET X=0 WHERE no='+dmGenData.Query2.Fields[0].AsString;
                  dmGenData.Query3.ExecSQL;
                  redraw:=true;
               end;
               dmGenData.Query2.next;
            end;

            // fr: mets le tag primaire à l'événement sélectionné dans la base de données et dans le tableau
            // en: put the primary tag to the event selected in the database and the table
            dmGenData.Query2.SQL.Text:='UPDATE E SET X=1 WHERE no='+TableauEvenements.Cells[0,TableauEvenements.Row];
            dmGenData.Query2.ExecSQL;

            TableauEvenements.Cells[1,TableauEvenements.Row]:='*';
            If lEvType='B' then
               begin
                lDate := dmGenData.GetI3(lidInd);
                dmGenData.UpdateNameI3(lDate,lidInd);
               if frmStemmaMainForm.actWinExplorer.Checked then
                 frmExplorer.UpdateIndexDates(lEvType,lDate,lidInd);
            end else If lEvType='D' then
               begin
               lDate := dmGenData.GetI3(lidInd);
               dmGenData.UpdateNameI4(lDate,lidInd);
               if frmStemmaMainForm.actWinExplorer.Checked then
                 frmExplorer.UpdateIndexDates(lEvType,lDate,lidInd);
            end;
         end;
      end;
      // fr: Sauvegarder les modifications pour tout les témoins de l'événements
      // en: Save the changes for all the witnesses to the events
      dmGenData.Query3.SQL.Text:='SELECT W.I, W.X FROM W WHERE W.E='+TableauEvenements.Cells[0,TableauEvenements.Row];
      dmGenData.Query3.Open;
      dmGenData.Query3.First;
      While not dmGenData.Query3.EOF do
         begin
         dmGenData.SaveModificationTime(dmGenData.Query3.Fields[0].AsInteger);
         dmGenData.Query3.Next;
      end;
   end;
   if redraw then PopulateEvents(Sender);
end;

procedure TfrmEvents.TableauEvenementsDblClick(Sender: TObject);
begin
  frmEditEvents.EditType:=eEET_EditExisting;
  If TableauEvenements.Row>0 then
     If frmEditEvents.Showmodal=mrOK then
        begin
        PopulateEvents(Sender);
        // Devrait modifier la fenêtre des exhibits aussi si elle est affichée (modifier et supprimer aussi)
        if frmStemmaMainForm.actWinDocuments.Checked then
           PopulateDocuments(frmDocuments.tblDocuments,'I',frmStemmaMainForm.iID);
     end;
end;

procedure TfrmEvents.TableauEvenementsDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin
  if ((Sender as TStringGrid).Cells[1,aRow]='*') and (aCol=4) then
     begin
     (Sender as TStringGrid).Canvas.Font.Bold := true;
     (Sender as TStringGrid).Canvas.TextOut(aRect.Left+2,aRect.Top+2,(Sender as TStringGrid).Cells[aCol,aRow]);
  end;
  if (not ((Sender as TStringGrid).Cells[8,aRow]='*') and (aRow>0)) then
     begin
     (Sender as TStringGrid).Canvas.Font.Bold := false;
     if not (aRow = (Sender as TStringGrid).Row) then
        (Sender as TStringGrid).Canvas.Brush.Color := TColor($E0E0E0);
     (Sender as TStringGrid).Canvas.FillRect(aRect);
     (Sender as TStringGrid).Canvas.TextOut(aRect.Left+2,aRect.Top+2,(Sender as TStringGrid).Cells[aCol,aRow]);
  end;
end;

function TfrmEvents.GetidEvent: Integer;
begin
  trystrtoint(TableauEvenements.Cells[0,TableauEvenements.Row],result);
end;

procedure TfrmEvents.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  dmGenData.WriteCfgFormPosition(self);
  dmGenData.WriteCfgGridPosition(TableauEvenements as TStringGrid,7);
end;

procedure TfrmEvents.FormResize(Sender: TObject);
begin
  TableauEvenements.Width := (Sender as Tform).Width;
  TableauEvenements.Height := (Sender as Tform).Height;
  TableauEvenements.Columns[3].Width := (Sender as Tform).Width-233;
end;

procedure TfrmEvents.FormShow(Sender: TObject);
begin
  Caption:=Translation.Items[59];
  TableauEvenements.Cells[2,0]:=Translation.Items[185];
  TableauEvenements.Cells[3,0]:=Translation.Items[136];
  TableauEvenements.Cells[4,0]:=Translation.Items[155];
  TableauEvenements.Cells[5,0]:=Translation.Items[177];
  MenuItem1.Caption:=Translation.Items[222];
  MenuItem3.Caption:=Translation.Items[224];
  MenuItem4.Caption:=Translation.Items[225];
  MenuItem5.Caption:=Translation.Items[226];
  MenuItem7.Caption:=Translation.Items[234];
  dmGenData.ReadCfgFormPosition(Sender as TForm,0,0,70,1000);
  dmGenData.ReadCfgGridPosition(TableauEvenements as TStringGrid,7);
  dmGenData.OnModifyEvent:=@PopulateEvents;
  PopulateEvents(Sender);
end;

{$R *.lfm}

end.

