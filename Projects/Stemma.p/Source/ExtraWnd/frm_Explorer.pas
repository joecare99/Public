unit frm_Explorer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls, Menus, Spin, ActnList, ExtCtrls, ComCtrls, FMUtils;

type

  { TfrmExplorer }

  TfrmExplorer = class(TForm)
    actExplorerOrderByFirstname: TAction;
    actExplorerOrderByFamilyname: TAction;
    actExplorerOrderByBirth: TAction;
    actExplorerOrderByDeath: TAction;
    alsExplorer: TActionList;
    mniExplorerOrderByFirstname: TMenuItem;
    mniExplorerOrderByFamilyname: TMenuItem;
    mniExplorerOrderByBirth: TMenuItem;
    mniExplorerOrderByDeath: TMenuItem;
    O: TSpinEdit;
    mnuExplorer: TPopupMenu;
    edtSearch: TEdit;
    grdIndex: TStringGrid;
    pnlBottom: TPanel;
    tlbExplorerOrderBy: TToolBar;
    btnExplorerOrderByFirstname: TToolButton;
    btnExplorerOrderByBirth: TToolButton;
    btnExplorerOrderByFamilyname: TToolButton;
    btnExplorerOrderByDeath: TToolButton;
    procedure actExplorerOrderByActUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var {%H-}CloseAction: TCloseAction);
    procedure grdIndexResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grdIndexDblClick(Sender: TObject);
    procedure grdIndexDrawCell(Sender: TObject; aCol, aRow: integer;
      aRect: TRect; {%H-}aState: TGridDrawState);
    procedure grdIndexHeaderClick(Sender: TObject; IsColumn: Boolean;
      Index: Integer);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
    procedure PopulateIndex(Order: integer);
    procedure AddNameToExplorer(const id: integer; const FullName, i1, i2, i3,
      i4: string);
    procedure DeleteIndex(const idName: integer);
    procedure UpdatePreferedMark(const idNamePref, idNameUnPref: integer);
    procedure UpdateIndexDates(const lEvType: string; const lDate: string;
      const lidInd: integer);
    procedure FindIndividual;
    procedure AppendIndex(const i2, i1, nom: string; var lidName: longint;
      const lidInd: longint; Pref: boolean);
    procedure UpdateIndex(var i2: string; var i1: string; var nom: string;
      var lidName: longint; var lidInd: longint; j: integer);
  end;



var
  frmExplorer: TfrmExplorer;

implementation

uses
  frm_Main, dm_GenData, cls_Translation;


{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

{ TfrmExplorer }

procedure TfrmExplorer.PopulateIndex(Order: integer);
var
  MyCursor: TCursor;
  lGrid: TStringGrid;
  lOnProgress: TNotifyEvent;
begin
  MyCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    frmStemmaMainForm.ProgressBar.Position := 0;
    frmStemmaMainForm.ProgressBar.Visible := True;
    Application.ProcessMessages;

    lGrid := grdIndex;
    O.Value := Order;
    lOnProgress := @frmStemmaMainForm.UpdateProgressBar;

    dmGenData.FillExplorerIndex(lGrid, Order, lOnProgress);
  finally
    frmStemmaMainForm.ProgressBar.Visible := False;
    Screen.Cursor := MyCursor;
  end;
end;

procedure TfrmExplorer.AddNameToExplorer(const id:integer;const FullName, i1, i2, i3, i4: string);
var
  j: integer;
  temp: string;
begin
  case  O.value of
    1:  temp := RemoveUTF8(i2 + ' ' + i1);
    2:  temp := RemoveUTF8(i1 + ', ' + i2);
    3:  temp := i3;
    4:  temp := i4;
    else
    temp := RemoveUTF8(i1 + ', ' + i2);
  end;

  if length(temp) > 0 then
  begin
    j := grdIndex.Row;
    if AnsiCompareText((copy(grdIndex.Cells[6, j], 1, length(temp))), temp) > 0 then
    begin
      while (AnsiCompareText((copy(grdIndex.Cells[6, j], 1, length(temp))),
          temp) > 0) and (j > 1) do
      begin
        j := j - 1;
      end;
      j := j + 1;
    end
    else
    begin
      while (AnsiCompareText((copy(grdIndex.Cells[6, j], 1, length(temp))),
          temp) < 0) and (j < grdindex.rowcount - 1) do
      begin
        j := j + 1;
      end;
      j := j - 1;
    end;
  end;
  grdIndex.InsertColRow(False, j);
  grdIndex.Cells[0, j] :=
    IntToStr(id - 1);
  grdIndex.Objects[0, j] :=
    TObject(ptrint(id - 1));

  grdIndex.Cells[1, j] := frmStemmaMainForm.sID;
  grdIndex.Objects[1, j] := TObject(ptrint(frmStemmaMainForm.iID));

  if O.Text = '1' then
    grdIndex.Cells[2, j] :=
      DecodeName(FullName, 1)
  else
    grdIndex.Cells[2, j] :=
      DecodeName(Fullname, 2);
  grdIndex.Cells[3, j] := ConvertDate(i3, 1);
  grdIndex.Cells[4, j] := ConvertDate(i4, 1);
  grdIndex.Cells[5, j] := '';
  grdIndex.Cells[6, j] := temp;
  grdIndex.Row := j;

end;

procedure TfrmExplorer.UpdateIndexDates(const lEvType: string;
  const lDate: string; const lidInd: integer);
var
  j: integer;
  reorder: boolean;
begin

  reorder := False;
  for j := 1 to grdIndex.RowCount - 1 do
    if grdIndex.Cells[0, j] = IntToStr(lidInd) then
    begin
      if (lEvType = 'B') then
      begin
        grdIndex.Cells[3, j] := ConvertDate(lDate, 1);
        if (O.Text = '3') then
        begin
          grdIndex.Cells[6, j] := ConvertDate(lDate, 1);
          reorder := True;
        end;
      end;
      if (lEvType = 'D') then
      begin
        grdIndex.Cells[4, j] := ConvertDate(lDate, 1);
        if (O.Text = '4') then
        begin
          grdIndex.Cells[6, j] := ConvertDate(lDate, 1);
          reorder := True;
        end;
      end;
    end;
  if reorder then
  begin
    grdIndex.SortColRow(True, 6);
    FindIndividual;
  end;
end;

procedure TfrmExplorer.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  dmGenData.WriteCfgFormPosition(self);
  dmGenData.writecfgGridPosition(grdIndex as TStringGrid, 4);
end;

procedure TfrmExplorer.actExplorerOrderByActUpdate(Sender: TObject);
begin
  if sender.InheritsFrom(TAction) then
  with sender as TAction do begin
    checked := O.Value = tag;
    enabled := not   Checked;
  end;
end;

procedure TfrmExplorer.grdIndexResize(Sender: TObject);
var
  ww: Integer;
begin
  if grdIndex.ColCount >3 then
  begin
  ww:=grdIndex.Columns[0].Width + grdIndex.Columns[2].Width+grdIndex.Columns[3].Width + grdIndex.ColCount;
  grdIndex.Columns[1].Width := grdIndex.Width - ww;
  end;
end;

procedure TfrmExplorer.FormShow(Sender: TObject);
begin
  Caption := Translation.Items[202];
  grdIndex.Cells[1, 0] := '#';
  grdIndex.Cells[2, 0] := Translation.Items[176];
  grdIndex.Cells[3, 0] := Translation.Items[203];
  grdIndex.Cells[4, 0] := Translation.Items[204];
  mniExplorerOrderByFirstname.Caption := Translation.Items[235];
  mniExplorerOrderByFamilyname.Caption := Translation.Items[236];
  mniExplorerOrderByBirth.Caption := Translation.Items[237];
  mniExplorerOrderByDeath.Caption := Translation.Items[238];
  dmGenData.ReadCfgFormPosition(Sender as TForm, 0, 0, 70, 1000);
  dmGenData.ReadCfgGridPosition(grdIndex as TStringGrid, 4);
  PopulateIndex(2);
  FindIndividual;
end;

procedure TfrmExplorer.grdIndexDblClick(Sender: TObject);
begin
  if grdIndex.Row > 0 then
    frmStemmaMainForm.iID := ptrint(grdIndex.Objects[1, grdIndex.Row]);
end;

procedure TfrmExplorer.grdIndexDrawCell(Sender: TObject; aCol, aRow: integer;
  aRect: TRect; aState: TGridDrawState);
begin
  if ((Sender as TStringGrid).Cells[5, aRow] = '*') and (aCol = 2) then
  begin
    (Sender as TStringGrid).Canvas.Font.Bold := True;
    (Sender as TStringGrid).Canvas.TextOut(aRect.Left + 2, aRect.Top + 2,
      (Sender as TStringGrid).Cells[aCol, aRow]);
  end;
end;

procedure TfrmExplorer.grdIndexHeaderClick(Sender: TObject; IsColumn: Boolean;
  Index: Integer);
begin
  if IsColumn then
    if index in [3,4] then
      o.Value := index
    else
      if index = 2 then
        if o.Value in [3,4] then
          o.Value := 2;
  PopulateIndex(o.Value);
end;

procedure TfrmExplorer.MenuItem3Click(Sender: TObject);
begin
  PopulateIndex(1);
end;

procedure TfrmExplorer.MenuItem4Click(Sender: TObject);
begin
  PopulateIndex(2);
end;

procedure TfrmExplorer.MenuItem5Click(Sender: TObject);
begin
  PopulateIndex(3);
end;

procedure TfrmExplorer.MenuItem6Click(Sender: TObject);
begin
  PopulateIndex(4);
end;


procedure TfrmExplorer.edtSearchChange(Sender: TObject);
var
  i: integer;
  temp: string;
begin
  temp := RemoveUTF8(edtSearch.Text);
  if length(edtSearch.Text) > 0 then
  begin
    i := grdIndex.Row;
    if AnsiCompareText((copy(grdIndex.Cells[6, i], 1, length(temp))), temp) > 0 then
    begin
      while (AnsiCompareText((copy(grdIndex.Cells[6, i], 1, length(temp))), temp) >
          0) and (i > 1) do
      begin
        Application.ProcessMessages;
        i := i - 1;
      end;
    end
    else
    begin
      while (AnsiCompareText((copy(grdIndex.Cells[6, i], 1, length(temp))), temp) <
          0) and (i < grdIndex.rowcount - 1) do
      begin
        Application.ProcessMessages;
        i := i + 1;
      end;
    end;
    grdIndex.Row := i;
  end;
end;

procedure TfrmExplorer.FindIndividual;
var
  i: integer;
begin
  if (self.grdIndex.Cells[1, self.grdIndex.Row] <> frmStemmaMainForm.sID) then
    // or (self.grdIndex.Cells[5,self.grdIndex.Row]<>'*') then
  begin
    i := 0;
    // Rechercher le nom  principal
    while ((ptrint(grdIndex.Objects[1, i]) <> frmStemmaMainForm.iID) or
        (self.grdIndex.Cells[5, i] = '')) and (i < self.grdindex.rowcount - 1) do
      i := i + 1;
    if (ptrint(grdIndex.objects[1, i]) = frmStemmaMainForm.iID) then
      self.grdIndex.Row := i
    else
      self.grdIndex.Row := 1;
  end;
  if self.CanFocus then
    self.grdIndex.SetFocus;
end;

procedure TfrmExplorer.edtSearchKeyPress(Sender: TObject; var Key: char);
var
  MyCursor: TCursor;
  lOnProgress: TNotifyEvent;
  lSearchText: String;
  lGrid: TStringGrid;
begin
  if (Key = chr(13)) and (length(edtSearch.Text) > 3) then
    begin
      MyCursor := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      frmStemmaMainForm.ProgressBar.Visible := True;
      lOnProgress:=TNotifyEvent(@frmStemmaMainForm.UpdateProgressBar);
      lSearchText := edtSearch.Text;
      lGrid := grdIndex;

      dmGenData.FillIndexBySearchtext(lGrid, lSearchText, lOnProgress);
        frmStemmaMainForm.ProgressBar.Visible := False;
        edtSearchChange(Sender);
        Screen.Cursor := MyCursor;

      FindIndividual;
    end;

end;

procedure TfrmExplorer.UpdatePreferedMark(const idNamePref, idNameUnPref: integer);
var
  j: integer;
  n: integer;
begin

  with grdIndex do
  begin
    n := 0;
    for j := 1 to RowCount do
    begin
      if ptrint(Objects[0, j]) = idNamePref then
      begin
        Cells[5, j] := '*';
        n := n + 1;
      end;
      if ptrint(Objects[0, j]) = idNameUnPref then
      begin
        Cells[5, j] := '';
        n := n + 1;
      end;
      if n = 2 then
        break;
    end;
  end;
end;

procedure TfrmExplorer.DeleteIndex(const idName: integer);
var
  j: integer;
begin
  with grdIndex do
    for j := 1 to RowCount - 1 do
    begin
      if ptrint(objects[0, j]) = idName then
      begin
        DeleteRow(j);
        break;
      end;
      if j mod 1000 = 0 then
        Application.ProcessMessages;
    end;
end;

procedure TfrmExplorer.UpdateIndex(var i2: string; var i1: string;
  var nom: string; var lidName: longint; var lidInd: longint; j: integer);
begin
  for j := 1 to grdIndex.RowCount - 1 do
    if grdIndex.Cells[0, j] = IntToStr(lidName) then
    begin
      grdIndex.Cells[1, j] := IntToStr(lidInd);
      grdIndex.Objects[1, j] := TObject(ptrint(lidInd));
      case o.Value of
        1:begin
        grdIndex.Cells[2, j] := DecodeName(nom, 1);
        grdIndex.Cells[6, j] := RemoveUTF8(i2 + ' ' + i1);
        end;
        2:begin
        grdIndex.Cells[2, j] := DecodeName(nom, 2);
        grdIndex.Cells[6, j] := RemoveUTF8(i1 + ', ' + i2);
         end
        else
         grdIndex.Cells[2, j] := DecodeName(nom, 2);
      end;
      if (O.Value in [1,2]) then
      begin
        //   frmExplorer.grdIndex.SortColRow(true,6);
        FindIndividual;
      end;
      break;
    end;
end;

procedure TfrmExplorer.AppendIndex(const i2, i1, nom: string;
  var lidName: longint; const lidInd: longint; Pref: boolean);
var
  temp, i4, i3: string;
  j: integer;
begin
  i3 := dmGenData.geti3(lidInd);
  i4 := dmGenData.geti4(lidInd);
  case o.Value of

  1:
    temp := RemoveUTF8(i2 + ' ' + i1);
  2:
    temp := RemoveUTF8(i1 + ', ' + i2);
  3:
    temp := i3;
  4:
    temp := i4;
  else
    temp := RemoveUTF8(i1 + ', ' + i2);
   end;
  if length(temp) > 0 then
  begin
    j := grdIndex.Row;
    if AnsiCompareText((copy(grdIndex.Cells[6, j], 1, length(temp))),
      temp) > 0 then
    begin
      while (AnsiCompareText(
          (copy(grdIndex.Cells[6, j], 1, length(temp))), temp) > 0) and
        (j > 1) do
      begin
        Application.ProcessMessages;
        j := j - 1;
      end;
      j := j + 1;
    end
    else
    begin
      while (AnsiCompareText(
          (copy(grdIndex.Cells[6, j], 1, length(temp))), temp) < 0) and
        (j < grdindex.rowcount - 1) do
      begin
        Application.ProcessMessages;
        j := j + 1;
      end;
      j := j - 1;
    end;
  end
  else
    exit;
  grdIndex.InsertColRow(False, j);

  grdIndex.Cells[0, j] := IntToStr(lidName);
  grdIndex.Objects[0, j] := TObject(ptrint(lidName));
  grdIndex.Cells[1, j] := IntToStr(lidInd);
  grdIndex.Objects[1, j] := TObject(ptrint(lidInd));
  if O.Text = '1' then
    grdIndex.Cells[2, j] := DecodeName(nom, 1)
  else
    grdIndex.Cells[2, j] := DecodeName(nom, 2);
  grdIndex.Cells[3, j] := ConvertDate(i3, 1);
  grdIndex.Cells[4, j] := ConvertDate(i4, 1);
  if Pref then
    grdIndex.Cells[5, j] := '*'
  else
    grdIndex.Cells[5, j] := '';
  grdIndex.Cells[6, j] := temp;
  grdIndex.Row := j;
  //         Index.SortColRow(true,6);
  //        TrouveIndividu;
end;

end.
