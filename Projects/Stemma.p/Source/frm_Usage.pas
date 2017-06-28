unit frm_Usage;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  Grids, Buttons, FMUtils;

type
  TEnumShowUsage = (
    eSU_Placees,
    eSU_Repositories,
    eSU_Sources,
    eSU_Types
    );
  { TfrmShowUsage }

  TfrmShowUsage = class(TForm)
    btnUsageOk: TBitBtn;
    tblUsage: TStringGrid;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tblUsageDblClick(Sender: TObject);
  private
    FidLink: integer;
    FUsageOf: TEnumShowUsage;
    function GetActIDInd: integer;
    function GetActIdSource: integer;
    procedure SetActIDInd(AValue: integer);
    procedure SetidLink(AValue: integer);
    procedure SetUsageOf(AValue: TEnumShowUsage);
    { private declarations }
  public
    { public declarations }
    property ActIDInd: integer read GetActIDInd write SetActIDInd;
    property ActIdSource: integer read GetActIdSource;
    property idLink: integer read FidLink write SetidLink;
    property UsageOf: TEnumShowUsage read FUsageOf write SetUsageOf;
  end;

var
  frmShowUsage: TfrmShowUsage;

implementation

uses cls_Translation,  frm_Sources, frm_Main, dm_GenData,
  frm_EditSource, frm_Types;

procedure FillRepositoriesUsageTable(var lTableauUtilisation: TStringGrid;
  const lFidLink: integer);
var
  i: integer;
var
  auteur: boolean;
  temp: string;
begin

  lTableauUtilisation.Columns[0].Title.Caption := Translation.Items[137];
  lTableauUtilisation.Columns[1].Title.Caption := Translation.Items[138];
  lTableauUtilisation.Columns[2].Title.Caption := Translation.Items[139];
  lTableauUtilisation.Columns[3].Title.Caption := Translation.Items[140];
  lTableauUtilisation.ColWidths[1] := 64;
  lTableauUtilisation.ColWidths[2] := 134;
  lTableauUtilisation.ColWidths[3] := 64;
  lTableauUtilisation.ColWidths[4] := 135;
  dmGenData.Query1.SQL.Text :=
    'SELECT A.S, S.T, S.M, S.A FROM A JOIN S on A.S=S.no WHERE A.D=:iDSource';
  dmGenData.Query1.ParamByName('idplace').AsInteger := lFidLink;
  dmGenData.Query1.Open;
  i := 1;
  lTableauUtilisation.RowCount := dmGenData.Query1.RecordCount + 1;
  while not dmGenData.Query1.EOF do
  begin
    lTableauUtilisation.Cells[0, i] := dmGenData.Query1.Fields[0].AsString;
    lTableauUtilisation.Cells[1, i] := dmGenData.Query1.Fields[0].AsString;
    lTableauUtilisation.Cells[2, i] := dmGenData.Query1.Fields[1].AsString;
    temp := dmGenData.Query1.Fields[3].AsString;
    auteur := False;
    if (length(temp) > 0) then
      if (temp[1] in ['0'..'9']) then
        auteur := (StrToInt(temp) > 0);
    if auteur then
    begin
      lTableauUtilisation.Cells[3, i] := temp;
      dmGenData.Query2.SQL.Text := 'SELECT N.N FROM N WHERE N.X=1 AND N.I=' + temp;
      dmGenData.Query2.Open;
      lTableauUtilisation.Cells[4, i] :=
        DecodeName(dmGenData.Query2.Fields[0].AsString, 1);
    end
    else
    begin
      lTableauUtilisation.Cells[3, i] := '';
      lTableauUtilisation.Cells[4, i] := temp;
    end;
    i := i + 1;
    dmGenData.Query1.Next;
  end;

end;

procedure FillTypesUsageTable(const lTableauUtilisation: TStringGrid; lidLink: integer);
var
  i: integer;
begin
  begin
    dmGenData.Query1.SQL.Text :=
      'SELECT E.no, Y.T, N.N, W.I, E.PD ' +
      'FROM E JOIN W on W.E=E.no JOIN Y on E.Y=Y.no JOIN N on W.I=N.I JOIN C on C.N=E.no '
      +
      'WHERE C.Y=''E'' AND N.X=1 AND E.Y=:idEventType';
    dmGenData.Query1.ParamByName('idEventType').AsInteger := lidLink;
    dmGenData.Query1.Open;
    i := 1;
    lTableauUtilisation.RowCount := dmGenData.Query1.RecordCount + 1;
    while not dmGenData.Query1.EOF do
    begin
      lTableauUtilisation.Cells[0, i] := dmGenData.Query1.Fields[0].AsString;
      lTableauUtilisation.Cells[1, i] := dmGenData.Query1.Fields[1].AsString;
      lTableauUtilisation.Cells[2, i] :=
        DecodeName(dmGenData.Query1.Fields[2].AsString, 1);
      lTableauUtilisation.Cells[3, i] := dmGenData.Query1.Fields[3].AsString;
      lTableauUtilisation.Cells[4, i] :=
        ConvertDate(dmGenData.Query1.Fields[4].AsString, 1);
      i := i + 1;
      dmGenData.Query1.Next;
    end;
    dmGenData.Query1.SQL.Text :=
      'SELECT R.no, Y.T, N.N, R.A, R.SD FROM R JOIN Y on R.Y=Y.no JOIN N on R.A=N.I JOIN C on C.N=R.no WHERE C.Y=''R'' AND N.X=1 AND R.Y='
      + FrmTypes.TableauTypes.Cells[1, FrmTypes.TableauTypes.Row];
    dmGenData.Query1.Open;
    lTableauUtilisation.RowCount :=
      lTableauUtilisation.RowCount + dmGenData.Query1.RecordCount;
    while not dmGenData.Query1.EOF do
    begin
      lTableauUtilisation.Cells[0, i] := dmGenData.Query1.Fields[0].AsString;
      lTableauUtilisation.Cells[1, i] := dmGenData.Query1.Fields[1].AsString;
      lTableauUtilisation.Cells[2, i] :=
        DecodeName(dmGenData.Query1.Fields[2].AsString, 1);
      lTableauUtilisation.Cells[3, i] := dmGenData.Query1.Fields[3].AsString;
      lTableauUtilisation.Cells[4, i] :=
        ConvertDate(dmGenData.Query1.Fields[4].AsString, 1);
      i := i + 1;
      dmGenData.Query1.Next;
    end;
    dmGenData.Query1.SQL.Text :=
      'SELECT N.no, Y.T, N.N, N.I, N.PD FROM N JOIN Y on N.Y=Y.no JOIN C on C.N=N.no WHERE C.Y=''N'' AND N.X=1 AND N.Y='
      + FrmTypes.TableauTypes.Cells[1, FrmTypes.TableauTypes.Row];

    dmGenData.Query1.Open;
    lTableauUtilisation.RowCount :=
      lTableauUtilisation.RowCount + dmGenData.Query1.RecordCount;
    while not dmGenData.Query1.EOF do
    begin
      lTableauUtilisation.Cells[0, i] := dmGenData.Query1.Fields[0].AsString;
      lTableauUtilisation.Cells[1, i] := dmGenData.Query1.Fields[1].AsString;
      lTableauUtilisation.Cells[2, i] :=
        DecodeName(dmGenData.Query1.Fields[2].AsString, 1);
      lTableauUtilisation.Cells[3, i] := dmGenData.Query1.Fields[3].AsString;
      lTableauUtilisation.Cells[4, i] :=
        ConvertDate(dmGenData.Query1.Fields[4].AsString, 1);
      i := i + 1;
      dmGenData.Query1.Next;
    end;
  end;
end;

procedure FillSourceUsageTable(var lTableauUtilisation: TStringGrid;
  const lidLink: integer);
var
  i: integer;
begin
  begin
    dmGenData.Query1.SQL.Text :=
      'SELECT E.no, Y.T, N.N, W.I, E.PD ' +
      'FROM E '+
      'JOIN W on W.E=E.no '+
      'JOIN Y on E.Y=Y.no '+
      'JOIN N on W.I=N.I '+
      'JOIN C on C.N=E.no '+
      'WHERE C.Y=:Type AND N.X=1 AND C.S=:idSource';
    dmGenData.Query1.ParamByName('Type').AsString := 'E';
    dmGenData.Query1.ParamByName('idSource').AsInteger := lidLink;
    dmGenData.Query1.Open;
    i := 1;
    lTableauUtilisation.RowCount := dmGenData.Query1.RecordCount + 1;
    while not dmGenData.Query1.EOF do
    begin
      lTableauUtilisation.Cells[0, i] := dmGenData.Query1.Fields[0].AsString;
      lTableauUtilisation.Cells[1, i] := dmGenData.Query1.Fields[1].AsString;
      lTableauUtilisation.Cells[2, i] :=
        DecodeName(dmGenData.Query1.Fields[2].AsString, 1);
      lTableauUtilisation.Cells[3, i] := dmGenData.Query1.Fields[3].AsString;
      lTableauUtilisation.Cells[4, i] :=
        ConvertDate(dmGenData.Query1.Fields[4].AsString, 1);
      i := i + 1;
      dmGenData.Query1.Next;
    end;
    dmGenData.Query1.SQL.Text :=
      'SELECT R.no, Y.T, N.N, R.A, R.SD FROM R JOIN Y on R.Y=Y.no JOIN N on R.A=N.I JOIN C on C.N=R.no WHERE C.Y=''R'' AND N.X=1 AND C.S='
      + FrmSources.TableauSources.Cells[1, FrmSources.TableauSources.Row];
    dmGenData.Query1.Open;
    lTableauUtilisation.RowCount :=
      lTableauUtilisation.RowCount + dmGenData.Query1.RecordCount;
    while not dmGenData.Query1.EOF do
    begin
      lTableauUtilisation.Cells[0, i] := dmGenData.Query1.Fields[0].AsString;
      lTableauUtilisation.Cells[1, i] := dmGenData.Query1.Fields[1].AsString;
      lTableauUtilisation.Cells[2, i] :=
        DecodeName(dmGenData.Query1.Fields[2].AsString, 1);
      lTableauUtilisation.Cells[3, i] := dmGenData.Query1.Fields[3].AsString;
      lTableauUtilisation.Cells[4, i] :=
        ConvertDate(dmGenData.Query1.Fields[4].AsString, 1);
      i := i + 1;
      dmGenData.Query1.Next;
    end;
    dmGenData.Query1.SQL.Text :=
      'SELECT N.no, Y.T, N.N, N.I, N.PD FROM N JOIN Y on N.Y=Y.no JOIN C on C.N=N.no WHERE C.Y=''N'' AND N.X=1 AND C.S='
      + FrmSources.TableauSources.Cells[1, FrmSources.TableauSources.Row];
    dmGenData.Query1.Open;
    lTableauUtilisation.RowCount :=
      lTableauUtilisation.RowCount + dmGenData.Query1.RecordCount;
    while not dmGenData.Query1.EOF do
    begin
      lTableauUtilisation.Cells[0, i] := dmGenData.Query1.Fields[0].AsString;
      lTableauUtilisation.Cells[1, i] := dmGenData.Query1.Fields[1].AsString;
      lTableauUtilisation.Cells[2, i] :=
        DecodeName(dmGenData.Query1.Fields[2].AsString, 1);
      lTableauUtilisation.Cells[3, i] := dmGenData.Query1.Fields[3].AsString;
      lTableauUtilisation.Cells[4, i] :=
        ConvertDate(dmGenData.Query1.Fields[4].AsString, 1);
      i := i + 1;
      dmGenData.Query1.Next;
    end;
  end;
end;

procedure FillPlaceUsageTable(const lTableauUtilisation: TStringGrid;
  const lFidLink: integer);
var
  i: integer;
begin
  dmGenData.Query1.SQL.Text :=
    'SELECT E.no, Y.T, N.N, W.I, E.PD FROM E JOIN W on W.E=E.no JOIN Y on E.Y=Y.no JOIN N on W.I=N.I WHERE N.X=1 AND E.L=:idPlace';
  dmGenData.Query1.ParamByName('idplace').AsInteger := lFidLink;
  dmGenData.Query1.Open;
  i := 1;
  lTableauUtilisation.RowCount := dmGenData.Query1.RecordCount + 1;
  while not dmGenData.Query1.EOF do
  begin
    lTableauUtilisation.Cells[0, i] := dmGenData.Query1.Fields[0].AsString;
    lTableauUtilisation.Cells[1, i] := dmGenData.Query1.Fields[1].AsString;
    lTableauUtilisation.Cells[2, i] :=
      DecodeName(dmGenData.Query1.Fields[2].AsString, 1);
    lTableauUtilisation.Cells[3, i] := dmGenData.Query1.Fields[3].AsString;
    lTableauUtilisation.Cells[4, i] :=
      ConvertDate(dmGenData.Query1.Fields[4].AsString, 1);
    i := i + 1;
    dmGenData.Query1.Next;
  end;
end;

{ TfrmShowUsage }

procedure TfrmShowUsage.FormResize(Sender: TObject);
begin
  tblUsage.Width := (Sender as TForm).Width - 16;
  tblUsage.Height := (Sender as TForm).Height - 51;
  btnUsageOk.Top := (Sender as TForm).Height - 35;
  btnUsageOk.Left := (Sender as TForm).Width - 80;
end;

procedure TfrmShowUsage.FormShow(Sender: TObject);
var
  lidLink: integer;
//  code, nocode: string;
  lTableauUtilisation: TStringGrid;
begin
  Caption := Translation.Items[158];
  tblUsage.Columns[0].Title.Caption := Translation.Items[134];
  tblUsage.Columns[1].Title.Caption := Translation.Items[135];
  tblUsage.Columns[2].Title.Caption := '#';
  tblUsage.Columns[3].Title.Caption := Translation.Items[136];
  tblUsage.ColWidths[1] := 75;
  tblUsage.ColWidths[2] := 183;
  tblUsage.ColWidths[3] := 64;
  tblUsage.ColWidths[4] := 75;
  lTableauUtilisation := tblUsage;
  lidLink := FidLink;
  case FUsageOf of
    eSU_Placees:   // Places
      FillPlaceUsageTable(lTableauUtilisation, lidLink);
    eSU_Repositories:  // Repositories & Citation
      FillRepositoriesUsageTable(lTableauUtilisation, lidLink);
    eSU_Sources:   // Sources & Witnesses
      FillSourceUsageTable(lTableauUtilisation, lidLink);
    eSU_Types:  // Types of Events
      FillTypesUsageTable(lTableauUtilisation, lidLink);
    else;
  end;
end;

procedure TfrmShowUsage.tblUsageDblClick(Sender: TObject);

begin
  if tblUsage.Row > 0 then
  begin
    if FUsageOf = eSU_Repositories then
    begin
      frmEditSource.EditMode := esem_EditExisting;
      frmEditSource.idSource := ActIdSource;
      frmEditSource.showmodal;
    end
    else
      frmStemmaMainForm.iID := ActIDInd;
  end;
end;

function TfrmShowUsage.GetActIDInd: integer;
begin
  Result := ptrint(tblUsage.objects[3, tblUsage.Row]);
end;

function TfrmShowUsage.GetActIdSource: integer;
begin
  Result := ptrint(tblUsage.objects[3, tblUsage.Row]);
end;

procedure TfrmShowUsage.SetActIDInd(AValue: integer);
var
  NewRow: integer;
begin
  if ptrint(tblUsage.objects[3, tblUsage.Row]) = AValue then
    Exit;
  NewRow := tblUsage.Cols[3].IndexOfObject(TObject(ptrint(AValue)));
  if NewRow > -1 then
    tblUsage.Row := NewRow;
end;

procedure TfrmShowUsage.SetidLink(AValue: integer);
begin
  if FidLink = AValue then
    Exit;
  FidLink := AValue;
end;

procedure TfrmShowUsage.SetUsageOf(AValue: TEnumShowUsage);
begin
  if FUsageOf = AValue then
    Exit;
  FUsageOf := AValue;
end;


{$R *.lfm}

end.
