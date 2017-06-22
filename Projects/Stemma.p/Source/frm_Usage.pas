unit frm_Usage;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  Grids, Buttons, FMUtils;

type

  { TfrmEventUsage }

  TfrmEventUsage = class(TForm)
    Button1: TBitBtn;
    TableauUtilisation: TStringGrid;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TableauUtilisationDblClick(Sender: TObject);
  private
    function GetActIDInd: integer;
    function GetActIdSource: integer;
    procedure SetActIDInd(AValue: integer);
    { private declarations }
  public
    { public declarations }
    Property ActIDInd:integer read GetActIDInd write SetActIDInd;
    Property ActIdSource:integer read GetActIdSource ;
  end; 

var
  frmEventUsage: TfrmEventUsage;

implementation

uses cls_Translation, frm_Places, frm_Sources, frm_Main, dm_GenData, frm_EditSource, frm_Types;

{ TfrmEventUsage }

procedure TfrmEventUsage.FormResize(Sender: TObject);
begin
  TableauUtilisation.Width := (Sender as Tform).Width-16;
  TableauUtilisation.Height := (Sender as Tform).Height-51;
  Button1.Top:= (Sender as Tform).Height-35;
  Button1.Left:= (Sender as Tform).Width-80;
end;

procedure TfrmEventUsage.FormShow(Sender: TObject);
var
  i:integer;
  temp, code, nocode:string;
  auteur:boolean;
begin
  Caption:=Translation.Items[158];
  TableauUtilisation.Columns[0].Title.Caption:=Translation.Items[134];
  TableauUtilisation.Columns[1].Title.Caption:=Translation.Items[135];
  TableauUtilisation.Columns[2].Title.Caption:='#';
  TableauUtilisation.Columns[3].Title.Caption:=Translation.Items[136];
  TableauUtilisation.ColWidths[1]:=75;
  TableauUtilisation.ColWidths[2]:=183;
  TableauUtilisation.ColWidths[3]:=64;
  TableauUtilisation.ColWidths[4]:=75;
  dmGenData.GetCode(code,nocode);
  case code of 'L':
     begin
     dmGenData.Query1.SQL.Text:='SELECT E.no, Y.T, N.N, W.I, E.PD FROM E JOIN W on W.E=E.no JOIN Y on E.Y=Y.no JOIN N on W.I=N.I WHERE N.X=1 AND E.L='+
        FormLieux.TableauLieux.Cells[0,FormLieux.TableauLieux.Row];
     dmGenData.Query1.Open;
     i:=1;
     TableauUtilisation.RowCount:=dmGenData.Query1.RecordCount+1;
     while not dmGenData.Query1.EOF do
        begin
        TableauUtilisation.Cells[0,i]:=dmGenData.Query1.Fields[0].AsString;
        TableauUtilisation.Cells[1,i]:=dmGenData.Query1.Fields[1].AsString;
        TableauUtilisation.Cells[2,i]:=DecodeName(dmGenData.Query1.Fields[2].AsString,1);
        TableauUtilisation.Cells[3,i]:=dmGenData.Query1.Fields[3].AsString;
        TableauUtilisation.Cells[4,i]:=ConvertDate(dmGenData.Query1.Fields[4].AsString,1);
        i:=i+1;
        dmGenData.Query1.Next;
     end;
  end;
  'D':
     begin
     TableauUtilisation.Columns[0].Title.Caption:=Translation.Items[137];
     TableauUtilisation.Columns[1].Title.Caption:=Translation.Items[138];
     TableauUtilisation.Columns[2].Title.Caption:=Translation.Items[139];
     TableauUtilisation.Columns[3].Title.Caption:=Translation.Items[140];
     TableauUtilisation.ColWidths[1]:=64;
     TableauUtilisation.ColWidths[2]:=134;
     TableauUtilisation.ColWidths[3]:=64;
     TableauUtilisation.ColWidths[4]:=135;
     dmGenData.Query1.SQL.Text:='SELECT A.S, S.T, S.M, S.A FROM A JOIN S on A.S=S.no WHERE A.D='+nocode;
     dmGenData.Query1.Open;
     i:=1;
     TableauUtilisation.RowCount:=dmGenData.Query1.RecordCount+1;
     while not dmGenData.Query1.EOF do
        begin
        TableauUtilisation.Cells[0,i]:=dmGenData.Query1.Fields[0].AsString;
        TableauUtilisation.Cells[1,i]:=dmGenData.Query1.Fields[0].AsString;
        TableauUtilisation.Cells[2,i]:=dmGenData.Query1.Fields[1].AsString;
        temp:=dmGenData.Query1.Fields[3].AsString;
        auteur:=false;
        if (length(temp)>0) then
           if (temp[1] in ['0'..'9']) then
              auteur:=(StrtoInt(temp)>0);
        if auteur then
           begin
           TableauUtilisation.Cells[3,i]:=temp;
           dmGenData.Query2.SQL.Text:='SELECT N.N FROM N WHERE N.X=1 AND N.I='+temp;
           dmGenData.Query2.Open;
           TableauUtilisation.Cells[4,i]:=DecodeName(dmGenData.Query2.Fields[0].AsString,1);
        end
        else
           begin
           TableauUtilisation.Cells[3,i]:='';
           TableauUtilisation.Cells[4,i]:=temp;
        end;
        i:=i+1;
        dmGenData.Query1.Next;
     end;
  end;
  'S':
     begin
     dmGenData.Query1.SQL.Text:='SELECT E.no, Y.T, N.N, W.I, E.PD FROM E JOIN W on W.E=E.no JOIN Y on E.Y=Y.no JOIN N on W.I=N.I JOIN C on C.N=E.no WHERE C.Y=''E'' AND N.X=1 AND C.S='+
        FrmSources.TableauSources.Cells[1,frmSources.TableauSources.Row];
     dmGenData.Query1.Open;
     i:=1;
     TableauUtilisation.RowCount:=dmGenData.Query1.RecordCount+1;
     while not dmGenData.Query1.EOF do
        begin
        TableauUtilisation.Cells[0,i]:=dmGenData.Query1.Fields[0].AsString;
        TableauUtilisation.Cells[1,i]:=dmGenData.Query1.Fields[1].AsString;
        TableauUtilisation.Cells[2,i]:=DecodeName(dmGenData.Query1.Fields[2].AsString,1);
        TableauUtilisation.Cells[3,i]:=dmGenData.Query1.Fields[3].AsString;
        TableauUtilisation.Cells[4,i]:=ConvertDate(dmGenData.Query1.Fields[4].AsString,1);
        i:=i+1;
        dmGenData.Query1.Next;
     end;
     dmGenData.Query1.SQL.Text:='SELECT R.no, Y.T, N.N, R.A, R.SD FROM R JOIN Y on R.Y=Y.no JOIN N on R.A=N.I JOIN C on C.N=R.no WHERE C.Y=''R'' AND N.X=1 AND C.S='+
        FrmSources.TableauSources.Cells[1,FrmSources.TableauSources.Row];
     dmGenData.Query1.Open;
     TableauUtilisation.RowCount:=TableauUtilisation.RowCount+dmGenData.Query1.RecordCount;
     while not dmGenData.Query1.EOF do
        begin
        TableauUtilisation.Cells[0,i]:=dmGenData.Query1.Fields[0].AsString;
        TableauUtilisation.Cells[1,i]:=dmGenData.Query1.Fields[1].AsString;
        TableauUtilisation.Cells[2,i]:=DecodeName(dmGenData.Query1.Fields[2].AsString,1);
        TableauUtilisation.Cells[3,i]:=dmGenData.Query1.Fields[3].AsString;
        TableauUtilisation.Cells[4,i]:=ConvertDate(dmGenData.Query1.Fields[4].AsString,1);
        i:=i+1;
        dmGenData.Query1.Next;
     end;
     dmGenData.Query1.SQL.Text:='SELECT N.no, Y.T, N.N, N.I, N.PD FROM N JOIN Y on N.Y=Y.no JOIN C on C.N=N.no WHERE C.Y=''N'' AND N.X=1 AND C.S='+
        FrmSources.TableauSources.Cells[1,FrmSources.TableauSources.Row];
     dmGenData.Query1.Open;
     TableauUtilisation.RowCount:=TableauUtilisation.RowCount+dmGenData.Query1.RecordCount;
     while not dmGenData.Query1.EOF do
        begin
        TableauUtilisation.Cells[0,i]:=dmGenData.Query1.Fields[0].AsString;
        TableauUtilisation.Cells[1,i]:=dmGenData.Query1.Fields[1].AsString;
        TableauUtilisation.Cells[2,i]:=DecodeName(dmGenData.Query1.Fields[2].AsString,1);
        TableauUtilisation.Cells[3,i]:=dmGenData.Query1.Fields[3].AsString;
        TableauUtilisation.Cells[4,i]:=ConvertDate(dmGenData.Query1.Fields[4].AsString,1);
        i:=i+1;
        dmGenData.Query1.Next;
     end;
  end;
  'T':
     begin
     dmGenData.Query1.SQL.Text:='SELECT E.no, Y.T, N.N, W.I, E.PD FROM E JOIN W on W.E=E.no JOIN Y on E.Y=Y.no JOIN N on W.I=N.I JOIN C on C.N=E.no WHERE C.Y=''E'' AND N.X=1 AND E.Y='+
        FrmTypes.TableauTypes.Cells[1,FrmTypes.TableauTypes.Row];
     dmGenData.Query1.Open;
     i:=1;
     TableauUtilisation.RowCount:=dmGenData.Query1.RecordCount+1;
     while not dmGenData.Query1.EOF do
        begin
        TableauUtilisation.Cells[0,i]:=dmGenData.Query1.Fields[0].AsString;
        TableauUtilisation.Cells[1,i]:=dmGenData.Query1.Fields[1].AsString;
        TableauUtilisation.Cells[2,i]:=DecodeName(dmGenData.Query1.Fields[2].AsString,1);
        TableauUtilisation.Cells[3,i]:=dmGenData.Query1.Fields[3].AsString;
        TableauUtilisation.Cells[4,i]:=ConvertDate(dmGenData.Query1.Fields[4].AsString,1);
        i:=i+1;
        dmGenData.Query1.Next;
     end;
     dmGenData.Query1.SQL.Text:='SELECT R.no, Y.T, N.N, R.A, R.SD FROM R JOIN Y on R.Y=Y.no JOIN N on R.A=N.I JOIN C on C.N=R.no WHERE C.Y=''R'' AND N.X=1 AND R.Y='+
        FrmTypes.TableauTypes.Cells[1,FrmTypes.TableauTypes.Row];
     dmGenData.Query1.Open;
     TableauUtilisation.RowCount:=TableauUtilisation.RowCount+dmGenData.Query1.RecordCount;
     while not dmGenData.Query1.EOF do
        begin
        TableauUtilisation.Cells[0,i]:=dmGenData.Query1.Fields[0].AsString;
        TableauUtilisation.Cells[1,i]:=dmGenData.Query1.Fields[1].AsString;
        TableauUtilisation.Cells[2,i]:=DecodeName(dmGenData.Query1.Fields[2].AsString,1);
        TableauUtilisation.Cells[3,i]:=dmGenData.Query1.Fields[3].AsString;
        TableauUtilisation.Cells[4,i]:=ConvertDate(dmGenData.Query1.Fields[4].AsString,1);
        i:=i+1;
        dmGenData.Query1.Next;
     end;
     dmGenData.Query1.SQL.Text:='SELECT N.no, Y.T, N.N, N.I, N.PD FROM N JOIN Y on N.Y=Y.no JOIN C on C.N=N.no WHERE C.Y=''N'' AND N.X=1 AND N.Y='+
        FrmTypes.TableauTypes.Cells[1,FrmTypes.TableauTypes.Row];
     dmGenData.Query1.Open;
     TableauUtilisation.RowCount:=TableauUtilisation.RowCount+dmGenData.Query1.RecordCount;
     while not dmGenData.Query1.EOF do
        begin
        TableauUtilisation.Cells[0,i]:=dmGenData.Query1.Fields[0].AsString;
        TableauUtilisation.Cells[1,i]:=dmGenData.Query1.Fields[1].AsString;
        TableauUtilisation.Cells[2,i]:=DecodeName(dmGenData.Query1.Fields[2].AsString,1);
        TableauUtilisation.Cells[3,i]:=dmGenData.Query1.Fields[3].AsString;
        TableauUtilisation.Cells[4,i]:=ConvertDate(dmGenData.Query1.Fields[4].AsString,1);
        i:=i+1;
        dmGenData.Query1.Next;
     end;
  end
  else;

  end;
end;

procedure TfrmEventUsage.TableauUtilisationDblClick(Sender: TObject);
var
  code,nocode:string;
begin
  if tableauUtilisation.Row>0 then
     begin
//     dmGenData.GetCode(Code,nocode);
     if code='D' then
        begin
          frmEditSource.EditMode:=esem_EditExisting;
          frmEditSource.idSource:=ActIdSource;
          frmEditSource.showmodal;

        end
     else
        frmStemmaMainForm.iID:=ActIDInd;
  end;
end;

function TfrmEventUsage.GetActIDInd: integer;
begin
  result:=ptrint(TableauUtilisation.objects[3,TableauUtilisation.Row]);
end;

function TfrmEventUsage.GetActIdSource: integer;
begin
  result := ptrint(TableauUtilisation.objects[3,TableauUtilisation.Row]);
end;

procedure TfrmEventUsage.SetActIDInd(AValue: integer);
var
  NewRow: Integer;
begin
  if ptrint(TableauUtilisation.objects[3,TableauUtilisation.Row])=AValue then Exit;
  NewRow:=TableauUtilisation.Cols[3].IndexOfObject(TObject(ptrint(AValue)));
  if NewRow>-1 then
    TableauUtilisation.Row:=NewRow;
end;


{$R *.lfm}

end.

