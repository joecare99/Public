unit frm_Events;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Menus,
  FMUtils, LCLType, ActnList, ComCtrls;

type

  { TfrmEvents }

  TfrmEvents = class(TForm)
    actEventsGoto: TAction;
    actEventsAdd: TAction;
    actEventsEdit: TAction;
    actEventsDelete: TAction;
    actEventsSetPrefered: TAction;
    ActionList1: TActionList;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    PopupMenuEvenements: TPopupMenu;
    grdEvents: TStringGrid;
    ToolBar1: TToolBar;
    procedure FormClose(Sender: TObject; var {%H-}CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grdEventsResize(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure grdEventsDblClick(Sender: TObject);
    procedure grdEventsDrawCell(Sender: TObject; aCol, aRow: Integer;
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
  lgrdEvents: TStringGrid;
begin
  lgrdEvents:=grdEvents;
  dmGenData.FillTableEvents(frmStemmaMainForm.iID,lgrdEvents);
   Caption:=Translation.Items[59]+' ('+IntToStr( grdEvents.RowCount-1)+')';
end;

procedure TfrmEvents.MenuItem1Click(Sender: TObject);
begin
  if grdEvents.Row>0 then
     If StrToInt(grdEvents.Cells[7,grdEvents.Row])>0 then
        frmStemmaMainForm.iID:=Ptrint(grdEvents.objects[7,grdEvents.Row]);
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
  if grdEvents.Row>0 then
     if grdEvents.Cells[1,grdEvents.Row]='' then
        if Application.MessageBox(Pchar(Translation.Items[60]+
           grdEvents.Cells[2,grdEvents.Row]+'-'+grdEvents.Cells[4,grdEvents.Row]+
           Translation.Items[28]),pchar(Translation.Items[1]),MB_YESNO)=IDYES then
           begin
           // Modifie la date de dernière modification pour tous les témoins
           dmGenData.Query3.SQL.Text:='SELECT W.I, W.X FROM W WHERE W.E='+grdEvents.Cells[0,grdEvents.Row];
           dmGenData.Query3.Open;
           dmGenData.Query3.First;
           While not dmGenData.Query3.EOF do
              begin
              dmGenData.SaveModificationTime(dmGenData.Query3.Fields[0].AsInteger);
              dmGenData.Query3.Next;
           end;
           // Supprimer tous les exhibits de cet événement
           dmGenData.Query1.SQL.Text:='DELETE FROM X WHERE A=''E'' AND N='+grdEvents.Cells[0,grdEvents.Row];
           dmGenData.Query1.ExecSQL;
           dmGenData.Query1.SQL.Text:='DELETE FROM C WHERE Y=''E'' AND N='+grdEvents.Cells[0,grdEvents.Row];
           dmGenData.Query1.ExecSQL;
           dmGenData.Query1.SQL.Text:='DELETE FROM W WHERE E='+grdEvents.Cells[0,grdEvents.Row];
           dmGenData.Query1.ExecSQL;
           dmGenData.Query1.SQL.Text:='DELETE FROM E WHERE no='+grdEvents.Cells[0,grdEvents.Row];
           dmGenData.Query1.ExecSQL;
           grdEvents.DeleteRow(grdEvents.Row);
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
   if grdEvents.Row>0 then
      begin
      // si c'est un témoin primaire de l'événement sélectionné
      dmGenData.Query1.SQL.Text:='SELECT E.no, E.X, W.I, E.Y, Y.Y FROM E JOIN W on W.E=E.no JOIN Y on E.Y=Y.no WHERE W.X=1 AND W.I='+frmStemmaMainForm.sID+
                                ' AND E.no='+grdEvents.Cells[0,grdEvents.Row];
      dmGenData.Query1.Open;
      dmGenData.Query1.First;
      lEvType:=dmGenData.Query1.Fields[4].AsString;
      lidInd :=dmGenData.Query1.Fields[2].AsInteger;
      if not dmGenData.Query1.eof then
         begin
         // si primaire, enlève le primaire de la base de données et du tableau.
         if dmGenData.Query1.Fields[1].AsBoolean then
            begin
            dmGenData.Query2.SQL.Text:='UPDATE E SET X=0 WHERE no='+grdEvents.Cells[0,grdEvents.Row];
            dmGenData.Query2.ExecSQL;
            grdEvents.Cells[1,grdEvents.Row]:='';
            redraw:=true;
            if frmStemmaMainForm.actWinExplorer.Checked then
               frmExplorer.UpdateIndexDates(lEvType,'',lidInd);
         end
         // sinon
         else
            begin
            // trouve si autre événement du même types avec même témoins primaires qui est primaire
            dmGenData.Query2.SQL.Text:='SELECT W.I FROM W WHERE W.X=1 AND W.E='
                                      +grdEvents.Cells[0,grdEvents.Row]+' ORDER BY W.I';
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
            dmGenData.Query2.SQL.Text:='UPDATE E SET X=1 WHERE no='+grdEvents.Cells[0,grdEvents.Row];
            dmGenData.Query2.ExecSQL;

            grdEvents.Cells[1,grdEvents.Row]:='*';
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
      dmGenData.Query3.SQL.Text:='SELECT W.I, W.X FROM W WHERE W.E='+grdEvents.Cells[0,grdEvents.Row];
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

procedure TfrmEvents.grdEventsDblClick(Sender: TObject);
begin
  frmEditEvents.EditType:=eEET_EditExisting;
  If grdEvents.Row>0 then
     If frmEditEvents.Showmodal=mrOK then
        begin
        PopulateEvents(Sender);
        // Devrait modifier la fenêtre des exhibits aussi si elle est affichée (modifier et supprimer aussi)
        if frmStemmaMainForm.actWinDocuments.Checked then
           PopulateDocuments(frmDocuments.tblDocuments,'I',frmStemmaMainForm.iID);
     end;
end;

procedure TfrmEvents.grdEventsDrawCell(Sender: TObject; aCol,
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
  trystrtoint(grdEvents.Cells[0,grdEvents.Row],result);
end;

procedure TfrmEvents.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  dmGenData.WriteCfgFormPosition(self);
  dmGenData.WriteCfgGridPosition(grdEvents as TStringGrid,7);
end;

procedure TfrmEvents.FormResize(Sender: TObject);
begin

end;

procedure TfrmEvents.FormShow(Sender: TObject);
begin
  Caption:=Translation.Items[59];
  grdEvents.Cells[2,0]:=Translation.Items[185];
  grdEvents.Cells[3,0]:=Translation.Items[136];
  grdEvents.Cells[4,0]:=Translation.Items[155];
  grdEvents.Cells[5,0]:=Translation.Items[177];
  MenuItem1.Caption:=Translation.Items[222];
  MenuItem3.Caption:=Translation.Items[224];
  MenuItem4.Caption:=Translation.Items[225];
  MenuItem5.Caption:=Translation.Items[226];
  MenuItem7.Caption:=Translation.Items[234];
  dmGenData.ReadCfgFormPosition(Sender as TForm,0,0,70,1000);
  dmGenData.ReadCfgGridPosition(grdEvents as TStringGrid,7);
  dmGenData.OnModifyEvent:=@PopulateEvents;
  PopulateEvents(Sender);
end;

procedure TfrmEvents.grdEventsResize(Sender: TObject);
begin
  grdEvents.Columns[3].Width := grdEvents.Width-233;
end;

{$R *.lfm}

end.

