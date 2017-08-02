unit frm_Events;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Menus,
  LCLType, ActnList, ComCtrls;

type

  { TfrmEvents }

  TfrmEvents = class(TForm)
    actEventsGoto: TAction;
    actEventsAdd: TAction;
    actEventsEdit: TAction;
    actEventsDelete: TAction;
    actEventsSetPrefered: TAction;
    alsEvents: TActionList;
    mniEventsGoto: TMenuItem;
    mniSeparator1: TMenuItem;
    mniEventsAdd: TMenuItem;
    mniEventsEdit: TMenuItem;
    mniEventsDelete: TMenuItem;
    mniSeparator2: TMenuItem;
    mniEventsSetPrefered: TMenuItem;
    mnuEvents: TPopupMenu;
    grdEvents: TStringGrid;
    tlbEvents: TToolBar;
    btnEventsGoto: TToolButton;
    btnSeparator1: TToolButton;
    btnEventsAdd: TToolButton;
    btnEventsEdit: TToolButton;
    btnEventsDelete: TToolButton;
    btnSeparator2: TToolButton;
    btnEventsSetPrefered: TToolButton;
    procedure actEventsDeleteUpdate(Sender: TObject);
    procedure actEventsSetPreferedUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var {%H-}CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure grdEventsResize(Sender: TObject);
    procedure actEventsGotoExecute(Sender: TObject);
    procedure actEventsAddExecute(Sender: TObject);
    procedure actEventsDeleteExecute(Sender: TObject);
    procedure actEventsSetPreferedExecute(Sender: TObject);
    procedure actEventsEditExecute(Sender: TObject);
    procedure grdEventsDrawCell(Sender: TObject; aCol, aRow: integer;
      aRect: TRect; {%H-}aState: TGridDrawState);
  private
    function GetidEvent: integer;
    { private declarations }
  public
    { public declarations }
    procedure PopulateEvents(Sender: TObject);
    property idEvent: integer read GetidEvent;
  end;


var
  frmEvents: TfrmEvents;

implementation

uses
  frm_Main, cls_Translation, dm_GenData, frm_EditEvents, frm_Explorer, frm_Documents;

{ TfrmEvents }

procedure TfrmEvents.PopulateEvents(Sender: TObject);
var
  lgrdEvents: TStringGrid;
begin
  lgrdEvents := grdEvents;
  dmGenData.FillTableEvents(frmStemmaMainForm.iID, lgrdEvents);
  Caption := Translation.Items[59] + ' (' + IntToStr(grdEvents.RowCount - 1) + ')';
end;

procedure TfrmEvents.actEventsGotoExecute(Sender: TObject);
begin
  if grdEvents.Row > 0 then
    if StrToInt(grdEvents.Cells[7, grdEvents.Row]) > 0 then
      frmStemmaMainForm.iID := Ptrint(grdEvents.objects[7, grdEvents.Row]);
end;

procedure TfrmEvents.actEventsAddExecute(Sender: TObject);
begin
  // dmGenData.PutCode('A',0);
  frmEditEvents.EditType := eEET_New;
  if frmEditEvents.Showmodal = mrOk then
  begin
    PopulateEvents(Sender);
    // Devrait modifier la fenêtre des exhibits aussi si elle est affichée (modifier et supprimer aussi)
    if frmStemmaMainForm.actWinDocuments.Checked then
      dmGenData.PopulateDocuments(frmDocuments.tblDocuments, 'I', frmStemmaMainForm.iID);
  end;
end;

procedure TfrmEvents.actEventsDeleteExecute(Sender: TObject);
var
  lidEvent: integer;
begin
  // Supprimer un événement
  if grdEvents.Row > 0 then
    if grdEvents.Cells[1, grdEvents.Row] = '' then
      if MessageDlg(SConfirmation, format(rsAreYouSureToDelete,
        [grdEvents.Cells[2, grdEvents.Row] + '-' + grdEvents.Cells[4, grdEvents.Row]]),
        mtConfirmation, mbYesNo, 0) = mrYes then
      begin
        lidEvent := ptrint(grdEvents.objects[0, grdEvents.Row]);
        dmGenData.DeleteEventComplete(lidEvent);
        grdEvents.DeleteRow(grdEvents.Row);
        // Devrait modifier la fenêtre des exhibits aussi si elle est affichée (modifier et supprimer aussi)
        if frmStemmaMainForm.actWinDocuments.Checked then
          dmGenData.PopulateDocuments(frmDocuments.tblDocuments, 'I', frmStemmaMainForm.iID);
      end;
end;

procedure TfrmEvents.actEventsSetPreferedExecute(Sender: TObject);
var
  lTypeType, lDate: string;
  redraw: boolean;
  lidInd: longint;
  lidEvent: PtrInt;
begin
  redraw := False;
  lTypeType:='I';
  if grdEvents.Row > 0 then
  begin
    // si c'est un témoin primaire de l'événement sélectionné
    lidEvent := ptrint(grdEvents.objects[0, grdEvents.Row]);
    lidInd := frmStemmaMainForm.iID;
    if grdEvents.Cells[1, grdEvents.Row] = '*' then
    begin
      dmgendata.ResetEventPrefered(lidEvent);
      redraw := True;
      if frmStemmaMainForm.actWinExplorer.Checked then
        frmExplorer.UpdateIndexDates(lTypeType, '', lidInd);
      grdEvents.Cells[1, grdEvents.Row] := '';
    end
    else
    begin
      redraw := dmgendata.SetEventPrefered(lidEvent, lidInd);
      grdEvents.Cells[1, grdEvents.Row] := '*';
    end;
  end;
  if frmStemmaMainForm.actWinExplorer.Checked then
    frmExplorer.UpdateIndexDates(lTypeType, lDate, lidInd);
  if redraw then
    PopulateEvents(Sender);
end;

procedure TfrmEvents.actEventsEditExecute(Sender: TObject);
begin
  frmEditEvents.EditType := eEET_EditExisting;
  if grdEvents.Row > 0 then
    if frmEditEvents.Showmodal = mrOk then
    begin
      PopulateEvents(Sender);
      // Devrait modifier la fenêtre des exhibits aussi si elle est affichée (modifier et supprimer aussi)
      if frmStemmaMainForm.actWinDocuments.Checked then
        dmGenData.PopulateDocuments(frmDocuments.tblDocuments, 'I', frmStemmaMainForm.iID);
    end;
end;

procedure TfrmEvents.grdEventsDrawCell(Sender: TObject; aCol, aRow: integer;
  aRect: TRect; aState: TGridDrawState);
begin
  if ((Sender as TStringGrid).Cells[1, aRow] = '*') and (aCol = 4) then
  begin
    (Sender as TStringGrid).Canvas.Font.Bold := True;
    (Sender as TStringGrid).Canvas.TextOut(aRect.Left + 2, aRect.Top + 2,
      (Sender as TStringGrid).Cells[aCol, aRow]);
  end;
  if (not ((Sender as TStringGrid).Cells[8, aRow] = '*') and (aRow > 0)) then
  begin
    (Sender as TStringGrid).Canvas.Font.Bold := False;
    if not (aRow = (Sender as TStringGrid).Row) then
      (Sender as TStringGrid).Canvas.Brush.Color := TColor($E0E0E0);
    (Sender as TStringGrid).Canvas.FillRect(aRect);
    (Sender as TStringGrid).Canvas.TextOut(aRect.Left + 2, aRect.Top + 2,
      (Sender as TStringGrid).Cells[aCol, aRow]);
  end;
end;

function TfrmEvents.GetidEvent: integer;
begin
  Result := ptrint(grdEvents.Objects[0, grdEvents.Row]);
end;

procedure TfrmEvents.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  dmGenData.WriteCfgFormPosition(self);
  dmGenData.WriteCfgGridPosition(grdEvents as TStringGrid, 7);
end;

procedure TfrmEvents.actEventsDeleteUpdate(Sender: TObject);
begin
  actEventsDelete.Enabled := not actEventsSetPrefered.Checked or True;
end;

procedure TfrmEvents.actEventsSetPreferedUpdate(Sender: TObject);
begin
  actEventsSetPrefered.Checked := grdEvents.Cells[1, grdEvents.Row] = '*';
  actEventsSetPrefered.Enabled := not actEventsSetPrefered.Checked;
end;


procedure TfrmEvents.FormShow(Sender: TObject);
begin
  Caption := Translation.Items[59];
  grdEvents.Cells[2, 0] := Translation.Items[185];
  grdEvents.Cells[3, 0] := Translation.Items[136];
  grdEvents.Cells[4, 0] := Translation.Items[155];
  grdEvents.Cells[5, 0] := Translation.Items[177];
  mniEventsGoto.Caption := Translation.Items[222];
  mniEventsAdd.Caption := Translation.Items[224];
  mniEventsEdit.Caption := Translation.Items[225];
  mniEventsDelete.Caption := Translation.Items[226];
  mniEventsSetPrefered.Caption := Translation.Items[234];
  dmGenData.ReadCfgFormPosition(Sender as TForm, 0, 0, 70, 1000);
  dmGenData.ReadCfgGridPosition(grdEvents as TStringGrid, 7);
  dmGenData.OnModifyEvent := @PopulateEvents;
  PopulateEvents(Sender);
end;

procedure TfrmEvents.grdEventsResize(Sender: TObject);
var
  ww: integer;
begin
  if grdEvents.ColCount > 5 then
  begin
    ww := grdEvents.Columns[0].Width + grdEvents.Columns[1].Width +
      grdEvents.Columns[2].Width + grdEvents.Columns[4].Width + grdEvents.ColCount +
      grdEvents.Columns[5].Width + 1;
    if grdEvents.Width - ww > 120 then
      grdEvents.Columns[3].Width := grdEvents.Width - ww
    else
      grdEvents.Columns[3].Width := 120;
  end;
end;

{$R *.lfm}

end.
