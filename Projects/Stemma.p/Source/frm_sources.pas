unit frm_Sources;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls, Menus, FMUtils, StrUtils, LCLType, ActnList;

type

  { TfrmSources }

  TfrmSources = class(TForm)
    actSourceDelete: TAction;
    actSourceEdit: TAction;
    actSourceUsage: TAction;
    actSourceAdd: TAction;
    actSourceSortTitle: TAction;
    actSourceSortNumber: TAction;
    alsSource: TActionList;
    Button1: TButton;
    mniSourceSep2: TMenuItem;
    mniSourceAdd: TMenuItem;
    mniSourceEdit: TMenuItem;
    mniSourceDelete: TMenuItem;
    mniSourceSort: TMenuItem;
    mniSourceSep1: TMenuItem;
    mniSourceSortNumber: TMenuItem;
    mniSourceUsage: TMenuItem;
    mniSourceSortTitle: TMenuItem;
    mnuSource: TPopupMenu;
    TableauSources: TStringGrid;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mniSourceAddClick(Sender: TObject);
    procedure mniSourceDeleteClick(Sender: TObject);
    procedure mniSourceSortNumberClick(Sender: TObject);
    procedure mniSourceUsageClick(Sender: TObject);
    procedure mniSourceSortTitleClick(Sender: TObject);
    procedure TableauSourcesDblClick(Sender: TObject);
    procedure TableauSourcesEditingDone(Sender: TObject);
  private
    function GetIdAktSource: integer;
    { private declarations }
  public
    { public declarations }
    property idAktSource:integer read GetIdAktSource;
  end;

var
  frmSources: TfrmSources;

implementation

{ TODO 20 : F10 pour sortir de la fenêtre }
// Si j'ajoute un menu on le voit, faut trouver un moyen de mettre le
// shortcut pour sortir sans menu

uses
  frm_Main, cls_Translation, dm_GenData, frm_Usage, frm_EditSource;

procedure UpdateTableSourceRow(const ltblSources: TStringGrid);
var

  lAuthor: string;
  lidAuthor: longint;
begin
  with dmGenData.Query1 do
   begin
    Close;
    SQL.Text :=
      'SELECT S.no, S.T, S.D, S.M, S.A, S.Q, COUNT(C.S) FROM S JOIN C on C.S=S.no WHERE S.no=:idSource';
    ParamByName('idSource').AsInteger :=
      ptrint(ltblSources.Objects[1, ltblSources.Row]);
    Open;
    First;
    ltblSources.Cells[1, ltblSources.Row] := Fields[0].AsString;
    ltblSources.Objects[1, ltblSources.Row] := TObject(PtrInt( Fields[0].AsInteger));
    ltblSources.Cells[2, ltblSources.Row] := Fields[1].AsString;
    ltblSources.Cells[3, ltblSources.Row] := Fields[2].AsString;
    ltblSources.Cells[4, ltblSources.Row] := Fields[3].AsString;
    lAuthor := Fields[4].AsString;
    ltblSources.Cells[6, ltblSources.Row] := Fields[5].AsString;
    ltblSources.Objects[6, ltblSources.Row] := TObject(PtrInt( Fields[5].AsInteger));
    ltblSources.Cells[7, ltblSources.Row] := Fields[6].AsString;
    Close;
   end;
  if TryStrToInt(lAuthor, lidAuthor) then
   begin
    ltblSources.Cells[5, ltblSources.Row] :=
      DecodeName(dmGenData.GetIndividuumName(lidAuthor), 1) +
      ' (' + IntToStr(lidAuthor) + ')';
    ltblSources.Objects[5, ltblSources.Row] := TObject(ptrint(lidAuthor));
    ltblSources.Cells[0, ltblSources.Row] := IntToStr(lidAuthor);
    ltblSources.Objects[0, ltblSources.Row] := TObject(ptrint(lidAuthor));
   end
  else
   begin
    ltblSources.Cells[5, ltblSources.Row] := lAuthor;
    ltblSources.Objects[5, ltblSources.Row] := nil;
    ltblSources.Cells[0, ltblSources.Row] := '';
    ltblSources.Objects[0, ltblSources.Row] := nil;
   end;

end;


{$R *.lfm}

{ TfrmSources }

procedure TfrmSources.FormResize(Sender: TObject);
begin
  TableauSources.Width := (Sender as TForm).Width - 16;
  TableauSources.Height := (Sender as TForm).Height - 51;
  Button1.Top := (Sender as TForm).Height - 35;
  Button1.Left := (Sender as TForm).Width - 80;
end;

procedure TfrmSources.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if CloseAction <> caMinimize then
   begin
    dmGenData.WriteCfgFormPosition(self);
    dmGenData.WriteCfgGridPosition(TableauSources as TStringGrid, 6);
   end;
end;

procedure TfrmSources.FormShow(Sender: TObject);
var
  MyCursor: TCursor;
  lTable: TStringGrid;
  lNotification: TNotifyEvent;
begin
  dmGenData.ReadCfgFormPosition(frmSources, 0, 0, 70, 1000);
  dmGenData.ReadCfgGridPosition(frmSources.TableauSources as TStringGrid, 6);
  Caption := Translation.Items[218];
  Button1.Caption := Translation.Items[152];
  TableauSources.Cells[2, 0] := Translation.Items[154];
  TableauSources.Cells[3, 0] := Translation.Items[155];
  TableauSources.Cells[4, 0] := Translation.Items[156];
  TableauSources.Cells[5, 0] := Translation.Items[219];
  TableauSources.Cells[6, 0] := Translation.Items[177];
  TableauSources.Cells[7, 0] := Translation.Items[158];
  mniSourceAdd.Caption := Translation.Items[224];
  mniSourceEdit.Caption := Translation.Items[225];
  mniSourceDelete.Caption := Translation.Items[226];
  mniSourceSort.Caption := Translation.Items[239];
  mniSourceSortNumber.Caption := Translation.Items[246];
  mniSourceUsage.Caption := Translation.Items[223];
  mniSourceSortTitle.Caption := Translation.Items[247];
  MyCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  frmStemmaMainForm.ProgressBar.Position := 0;
  frmStemmaMainForm.ProgressBar.Visible := True;
  Application.ProcessMessages;
  lTable := TableauSources;
  lNotification := @frmStemmaMainForm.UpdateProgressBar;
  dmGenData.FillSourcesTable(lNotification, lTable);
  frmStemmaMainForm.ProgressBar.Visible := False;
  Screen.Cursor := MyCursor;
end;

procedure TfrmSources.mniSourceAddClick(Sender: TObject);
begin
  // Ajouter une source
  frmEditSource.EditMode := esem_AddNew;
  if frmEditSource.Showmodal = mrOk then
    // Reinitialize Form
    Formshow(Sender);
end;

procedure TfrmSources.mniSourceDeleteClick(Sender: TObject);
begin
  // Supprimer une source
  if TableauSources.Row > 0 then
    if TableauSources.Cells[7, TableauSources.Row] = '0' then
      if Application.MessageBox(PChar(Translation.Items[132] +
        TableauSources.Cells[2, TableauSources.Row] +
        Translation.Items[28]), PChar(SConfirmation), MB_YESNO) = idYes then
       begin
        dmGenData.DeleteSourceFull(ptrint(
          TableauSources.Objects[1, TableauSources.Row]));
        TableauSources.DeleteRow(TableauSources.Row);
       end;
end;

procedure TfrmSources.mniSourceSortNumberClick(Sender: TObject);
begin
  TableauSources.SortColRow(True, 1);
end;

procedure TfrmSources.mniSourceUsageClick(Sender: TObject);
var
  lSourceCitCount: longint;
  lidSource: PtrInt;
begin
  if TableauSources.Cells[7, TableauSources.Row] = '?' then
   begin
    lidSource := ptrint(TableauSources.Objects[1, TableauSources.Row]);
    lSourceCitCount := dmGenData.GetSourceCitCount(lidSource);
    TableauSources.Cells[7, TableauSources.Row] := IntToStr(lSourceCitCount);
   end
  else
   begin
    //     dmGenData.PutCode('S',TableauSources.Cells[2,TableauSources.Row]);
    frmShowUsage.UsageOf := eSU_Sources;
    frmShowUsage.idLink := ptrint(TableauSources.Objects[2, TableauSources.Row]);
    frmShowUsage.ShowModal;
   end;
end;

procedure TfrmSources.mniSourceSortTitleClick(Sender: TObject);
begin
  TableauSources.SortColRow(True, 2);
end;

procedure TfrmSources.TableauSourcesDblClick(Sender: TObject);
var
  ltblSources: TStringGrid;
begin
  if TableauSources.Row > 0 then
   begin
    frmEditSource.EditMode := esem_EditExisting;
    frmEditSource.idSource := ptrint(TableauSources.Objects[1, TableauSources.Row]);
    if frmEditSource.Showmodal = mrOk then
      // Ne pas repopuler toute la table, seulement la source modifiée.
      // FormShow(Sender);
     begin

      ltblSources := TableauSources;
      UpdateTableSourceRow(ltblSources);
     end;
   end;
  //  if StrToInt(ltblSources.Cells[0,ltblSources.Row])>0 then
  //     frmStemmaMainForm.sID:=ltblSources.Cells[0,ltblSources.Row];
end;

procedure TfrmSources.TableauSourcesEditingDone(Sender: TObject);
var
  temp: string;
  lidAuthor:integer;
  auteur: boolean;
  lTblSource: TStringGrid;
begin
  lTblSource:=(Sender as TStringGrid);
  temp := lTblSource.Cells[5, lTblSource.Row];
  auteur := False;
  if TryStrToInt(temp,lidAuthor) then
    auteur := lidAuthor > 0;
  if (not auteur) and (ptrint(lTblSource.Objects[0, lTblSource.Row]) > 0) then
   begin
    auteur := DecodeName(dmGenData.GetIndividuumName(PtrInt(lTblSource.Objects[0, lTblSource.Row])), 1) + ' (' +
      lTblSource.Cells[0, lTblSource.Row] + ')' =
      lTblSource.Cells[5, lTblSource.Row];
    lidAuthor := ptrint(lTblSource.Objects[0, lTblSource.Row]);
   end;
  if auteur then
   begin
    lTblSource.Cells[5, lTblSource.Row] :=
      DecodeName(dmGenData.GetIndividuumName(lidAuthor), 1) +
      ' (' + inttostr(lidAuthor) + ')';
    lTblSource.Cells[0, lTblSource.Row] := temp;
    dmGenData.SaveSourceData(idAktSource,ptrint(lTblSource.Objects[6, lTblSource.Row]),
      lTblSource.Cells[2, lTblSource.Row],lTblSource.Cells[3, lTblSource.Row],
      lTblSource.Cells[4, lTblSource.Row],lTblSource.Cells[0, lTblSource.Row]);
   end
  else
  dmGenData.SaveSourceData(idAktSource,ptrint(lTblSource.Objects[6, lTblSource.Row]),
    lTblSource.Cells[2, lTblSource.Row],lTblSource.Cells[3, lTblSource.Row],
    lTblSource.Cells[4, lTblSource.Row],lTblSource.Cells[5, lTblSource.Row]);
end;

function TfrmSources.GetIdAktSource: integer;
begin
  result := PtrInt(TableauSources.Objects[1, TableauSources.Row]);
end;

end.
