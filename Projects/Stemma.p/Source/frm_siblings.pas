unit frm_Siblings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Menus,
  FMUtils;

type

  { TfrmSiblings }

  TfrmSiblings = class(TForm)
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PopupMenuFratrie: TPopupMenu;
    TableauFratrie: TStringGrid;
    procedure FormClose(Sender: TObject; var {%H-}CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

procedure PopulateFratrie;

var
  frmSiblings: TfrmSiblings;

implementation

uses
  frm_Main,cls_Translation, dm_GenData;

{$R *.lfm}

{ TfrmSiblings }

procedure PopulateFratrie;
var
  row, nbmarriage:integer;
  naissance,deces,p1,p2,conjoint,temp:string;
begin
// Cherche les parents principaux P1 et P2
  p1:='0';
  p2:='0';
  dmGenData.Query1.SQL.Text:='SELECT R.B FROM R WHERE X=1 AND A='+frmStemmaMainForm.sID+' ORDER BY SD';
  dmGenData.Query1.Open;
  if not dmGenData.Query1.EOF then
     begin
     p1:=dmGenData.Query1.Fields[0].AsString;
     dmGenData.Query1.Next;
  end;
  if not dmGenData.Query1.EOF then
     p2:=dmGenData.Query1.Fields[0].AsString;
  dmGenData.Query1.SQL.Clear;
  if (strtoint(p1)>0) then
     if (strtoint(p2)>0) then
        dmGenData.Query1.SQL.add('SELECT R.no, R.A, N.N, N.I3, N.I4 FROM R JOIN N on N.I=R.A WHERE N.X=1 AND R.X=1 AND (R.B='+
                                  p1+' OR R.B='+p2+') ORDER BY R.SD, N.I')
     else
        dmGenData.Query1.SQL.add('SELECT R.no, R.A, N.N, N.I3, N.I4 FROM R JOIN N on N.I=R.A WHERE N.X=1 AND R.X=1 AND (R.B='+
                                  p1+') ORDER BY R.SD, N.I')
  else
     if (strtoint(p2)>0) then
        dmGenData.Query1.SQL.add('SELECT R.no, R.A, N.N, N.I3, N.I4 FROM R JOIN N on N.I=R.A WHERE N.X=1 AND R.X=1 AND (R.B='+
                                  p2+') ORDER BY R.SD, N.I')
     else
        dmGenData.Query1.SQL.add('SELECT no FROM I WHERE no=''A''');
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  row:=1;
  frmSiblings.TableauFratrie.RowCount:=dmGenData.Query1.RecordCount+1;
  While not dmGenData.Query1.EOF do
  begin
     // Enlève les doublons et le sujet
     if (not (dmGenData.Query1.Fields[1].AsString=frmStemmaMainForm.sID)) and
        (not (dmGenData.Query1.Fields[1].AsString=frmSiblings.TableauFratrie.Cells[2,row-1])) then
        begin
        frmSiblings.TableauFratrie.Cells[0,row]:=dmGenData.Query1.Fields[0].AsString;
        if Copy(dmGenData.Query1.Fields[3].AsString,1,1)='1' then
           naissance:=Copy(dmGenData.Query1.Fields[3].AsString,2,4)
        else
           naissance:='';
        if Copy(dmGenData.Query1.Fields[4].AsString,1,1)='1' then
           deces:=Copy(dmGenData.Query1.Fields[4].AsString,2,4)
        else
           deces:='';
        // Trouver conjoint + nombre de conjoints
        conjoint:='';
        dmGenData.Query2.SQL.Clear;
        dmGenData.Query2.SQL.add('SELECT E.no FROM (E JOIN Y on E.Y=Y.no) JOIN W on W.E=E.no WHERE W.X=1 AND E.X=1 AND Y.Y=''M'' AND W.I='+dmGenData.Query1.Fields[1].AsString);
        dmGenData.Query2.Open;
        nbmarriage:=dmGenData.Query2.RecordCount;
        if not dmGenData.Query2.EOF then
           begin
           temp:=dmGenData.Query2.Fields[0].AsString;
           dmGenData.Query2.SQL.Text:='SELECT W.I, N.N FROM W JOIN N on W.I=N.I WHERE W.X=1 AND N.X=1 AND W.E='+temp+
                                     ' AND NOT W.I='+dmGenData.Query1.Fields[1].AsString;
           dmGenData.Query2.Open;
           conjoint:=DecodeName(dmGenData.Query2.Fields[1].AsString,1);
        end;
        if length(conjoint)>0 then
           frmSiblings.TableauFratrie.Cells[1,row]:=DecodeName(dmGenData.Query1.Fields[2].AsString,1)+
                                                    ' ('+naissance+' - '+deces+
                                                    ') & '+conjoint+' (1 de '+
                                                    IntToStr(nbmarriage)+')'
        else
           frmSiblings.TableauFratrie.Cells[1,row]:=DecodeName(dmGenData.Query1.Fields[2].AsString,1)+' ('+
                                                    naissance+' - '+deces+')';
        dmGenData.Query2.SQL.Text:='SELECT Q FROM C WHERE Y=''R'' AND N='+frmSiblings.TableauFratrie.Cells[0,row]+' ORDER BY Q DESC';
        dmGenData.Query2.Open;
        frmSiblings.TableauFratrie.Cells[2,row]:=dmGenData.Query1.Fields[1].AsString;
        frmSiblings.TableauFratrie.Cells[3,row]:=dmGenData.Query2.Fields[0].AsString;
        dmGenData.Query2.SQL.Text:='SELECT no FROM R WHERE X=1 AND B='+dmGenData.Query1.Fields[1].AsString;
        dmGenData.Query2.Open;
        If (not dmGenData.Query2.EOF) then
           frmSiblings.TableauFratrie.Cells[4,row]:='+'
        else
           frmSiblings.TableauFratrie.Cells[4,row]:='';
        row:=row+1;
     end
     else
        frmSiblings.TableauFratrie.RowCount:=frmSiblings.TableauFratrie.RowCount-1;
     dmGenData.Query1.Next;
  end;
  frmSiblings.Caption:=Translation.Items[116]+' ('+IntToStr(frmSiblings.TableauFratrie.RowCount-1)+')';
end;

procedure TfrmSiblings.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  dmGenData.WriteCfgFormPosition(Self);
  dmGenData.WriteCfgGridPosition(TableauFratrie as TStringGrid,4);
end;

procedure TfrmSiblings.FormResize(Sender: TObject);
begin
  TableauFratrie.Width := (Sender as Tform).Width;
  TableauFratrie.Height := (Sender as Tform).Height;
  TableauFratrie.Columns[0].Width := (Sender as Tform).Width-62;
end;

procedure TfrmSiblings.FormShow(Sender: TObject);
begin
  Caption:=Translation.Items[116];
  TableauFratrie.Cells[1,0]:=Translation.Items[205];
  TableauFratrie.Cells[2,0]:='#';
  TableauFratrie.Cells[3,0]:=Translation.Items[177];
  MenuItem1.Caption:=Translation.Items[222];
  MenuItem3.Caption:=Translation.Items[224];
  dmGenData.ReadCfgFormPosition(Sender as TForm,0,0,70,1000);
  dmGenData.ReadCfgGridPosition(frmSiblings.TableauFratrie as TStringGrid,4);
  PopulateFratrie;
end;

procedure TfrmSiblings.MenuItem1Click(Sender: TObject);
begin
   if TableauFratrie.Row>0 then
      frmStemmaMainForm.iID:=Ptrint(TableauFratrie.objects[2,TableauFratrie.Row]);
end;

end.
