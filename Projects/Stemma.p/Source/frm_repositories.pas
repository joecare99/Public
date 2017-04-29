unit frm_Repositories;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, Menus, FMUtils, StrUtils, LCLType;

type

  { TfrmRepository }

  TfrmRepository = class(TForm)
    Button1: TButton;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem8: TMenuItem;
    PopupMenu1: TPopupMenu;
    TableauDepots: TStringGrid;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure TableauDepotsDblClick(Sender: TObject);
    procedure TableauDepotsEditingDone(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmRepository: TfrmRepository;

implementation

uses
  frm_Main, Traduction, dm_GenData, frm_Usage;

{ TfrmRepository }

procedure TfrmRepository.TableauDepotsDblClick(Sender: TObject);
begin
  if TableauDepots.Row>0 then
     if StrToInt(TableauDepots.Cells[0,TableauDepots.Row])>0 then
        frmStemmaMainForm.iID:=Ptrint(TableauDepots.Objects[0,TableauDepots.Row]);
end;

procedure TfrmRepository.TableauDepotsEditingDone(Sender: TObject);
var
  temp:string;
  depot:boolean;
begin
  dmGenData.Query1.SQL.Clear;
  temp:=TableauDepots.Cells[5,TableauDepots.Row];
  depot:=false;
  if (length(temp)>0) then
     if (temp[1] in ['0'..'9']) then
        depot:=StrtoInt(temp)>0;
  if (not depot) and (strtoint(TableauDepots.Cells[0,TableauDepots.Row])>0) then
     begin
     dmGenData.Query2.SQL.Text:='SELECT N.I, N.N FROM N WHERE N.X=1 AND N.I='+TableauDepots.Cells[0,TableauDepots.Row];
     dmGenData.Query2.Open;
     depot:=(DecodeName(dmGenData.Query2.Fields[1].AsString,1)+' ('+TableauDepots.Cells[0,TableauDepots.Row]+')')=
            (TableauDepots.Cells[5,TableauDepots.Row]);
     temp:=TableauDepots.Cells[0,TableauDepots.Row];
     end;
  if depot then
     begin
     dmGenData.Query2.SQL.Text:='SELECT N.I, N.N FROM N WHERE N.X=1 AND N.I='+temp;
     dmGenData.Query2.Open;
     TableauDepots.Cells[5,TableauDepots.Row]:=DecodeName(dmGenData.Query2.Fields[1].AsString,1)+
                                                                   ' ('+temp+')';
     TableauDepots.Cells[0,TableauDepots.Row]:=temp;
     if TableauDepots.Cells[1,TableauDepots.Row]='0' then
        dmGenData.Query1.SQL.Add('INSERT INTO D (T,D,M,I) VALUES ('''+
           AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(TableauDepots.Cells[2,TableauDepots.Row]),'\','\\'),'"','\"'),'''','\''')+
           ''', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(TableauDepots.Cells[3,TableauDepots.Row]),'\','\\'),'"','\"'),'''','\''')+
           ''', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(TableauDepots.Cells[4,TableauDepots.Row]),'\','\\'),'"','\"'),'''','\''')+
           ''', '+TableauDepots.Cells[0,TableauDepots.Row]+')')
     else
        dmGenData.Query1.SQL.Add('UPDATE D SET T='''+
           AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(TableauDepots.Cells[2,TableauDepots.Row]),'\','\\'),'"','\"'),'''','\''')+
           ''', D='''+
           AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(TableauDepots.Cells[3,TableauDepots.Row]),'\','\\'),'"','\"'),'''','\''')+
           ''', M='''+
           AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(TableauDepots.Cells[4,TableauDepots.Row]),'\','\\'),'"','\"'),'''','\''')+
           ''', I='+TableauDepots.Cells[0,TableauDepots.Row]+
           ' WHERE no='+TableauDepots.Cells[1,TableauDepots.Row]);
  end
  else
     begin
     TableauDepots.Cells[5,TableauDepots.Row]:='0';
     TableauDepots.Cells[0,TableauDepots.Row]:='0';
     if TableauDepots.Cells[1,TableauDepots.Row]='0' then
        dmGenData.Query1.SQL.Add('INSERT INTO D (T,D,M,I) VALUES ('''+
           AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(TableauDepots.Cells[2,TableauDepots.Row]),'\','\\'),'"','\"'),'''','\''')+
           ''', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(TableauDepots.Cells[3,TableauDepots.Row]),'\','\\'),'"','\"'),'''','\''')+
           ''', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(TableauDepots.Cells[4,TableauDepots.Row]),'\','\\'),'"','\"'),'''','\''')+
           ''', 0)')
     else
        dmGenData.Query1.SQL.Add('UPDATE D SET T='''+
          AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(TableauDepots.Cells[2,TableauDepots.Row]),'\','\\'),'"','\"'),'''','\''')+
          ''', D='''+
          AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(TableauDepots.Cells[3,TableauDepots.Row]),'\','\\'),'"','\"'),'''','\''')+
          ''', M='''+
          AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(TableauDepots.Cells[4,TableauDepots.Row]),'\','\\'),'"','\"'),'''','\''')+
          ''', I=0 WHERE no='+TableauDepots.Cells[1,TableauDepots.Row]);
  end;
  dmGenData.Query1.ExecSQL;
  if TableauDepots.Cells[1,TableauDepots.Row]='0' then
     begin
     TableauDepots.Cells[1,TableauDepots.Row]:=InttoStr(dmGenData.GetLastIDOfTable('D'));
  end;
  TableauDepots.SortColRow(true,3);
end;

procedure TfrmRepository.FormResize(Sender: TObject);
begin
  TableauDepots.Width := (Sender as Tform).Width-16;
  TableauDepots.Height := (Sender as Tform).Height-51;
  Button1.Top:= (Sender as Tform).Height-35;
  Button1.Left:= (Sender as Tform).Width-80;
end;

procedure TfrmRepository.FormShow(Sender: TObject);
var
  i:integer;
  MyCursor: TCursor;
  lidInd: Longint;
begin
  Caption:=Traduction.Items[153];
  TableauDepots.Cells[2,0]:=Traduction.Items[154];
  TableauDepots.Cells[3,0]:=Traduction.Items[155];
  TableauDepots.Cells[4,0]:=Traduction.Items[156];
  TableauDepots.Cells[5,0]:=Traduction.Items[157];
  TableauDepots.Cells[6,0]:=Traduction.Items[158];
  Button1.Caption:=Traduction.Items[152];
  MenuItem8.Caption:=Traduction.Items[223];
  MenuItem2.Caption:=Traduction.Items[224];
  MenuItem3.Caption:=Traduction.Items[226];
  MenuItem4.Caption:=Traduction.Items[225];
  MyCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
  frmStemmaMainForm.ProgressBar.Position:=0;
  frmStemmaMainForm.ProgressBar.Visible:=True;
  Application.Processmessages;
  dmGenData.Query1.SQL.Clear;
  dmGenData.Query1.SQL.add('SELECT D.no, D.T, D.D, D.M, D.I, COUNT(A.D) FROM D LEFT JOIN A on D.no=A.D GROUP by D.no ORDER BY D.D');
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  TableauDepots.RowCount:=dmGenData.Query1.RecordCount+1;
  frmStemmaMainForm.ProgressBar.Max:=TableauDepots.RowCount;
  i:=0;
  While not dmGenData.Query1.Eof do
     begin
     i:=i+1;
     lidInd:=dmGenData.Query1.Fields[4].AsInteger;
     TableauDepots.Cells[0,i]:=inttostr(lidind);
     TableauDepots.Objects[0,i]:=TObject(ptrint(lidInd));
     TableauDepots.Cells[1,i]:=dmGenData.Query1.Fields[0].AsString;
     TableauDepots.Objects[1,i]:=TObject(ptrint(dmGenData.Query1.Fields[0].AsInteger));
     TableauDepots.Cells[2,i]:=dmGenData.Query1.Fields[1].AsString;
     TableauDepots.Cells[3,i]:=dmGenData.Query1.Fields[2].AsString;
  //   TableauDepots.Objects[3,i]:=TObject(ptrint(dmGenData.Query1.Fields[2].AsInteger));
     TableauDepots.Cells[4,i]:=dmGenData.Query1.Fields[3].AsString;
     TableauDepots.Cells[5,i]:=DecodeName(dmGenData.GetIndividuumName(lidind),1);
     TableauDepots.Cells[6,i]:=dmGenData.Query1.Fields[5].AsString;
     dmGenData.Query1.Next;
     frmStemmaMainForm.ProgressBar.Position:=frmStemmaMainForm.ProgressBar.Position+1;
     Application.ProcessMessages;
  end;
  frmStemmaMainForm.ProgressBar.Visible:=False;

  finally
    Screen.Cursor := MyCursor;
  end;
end;

procedure TfrmRepository.MenuItem2Click(Sender: TObject);
begin
  // Ajouter un Dépot
  TableauDepots.RowCount:=TableauDepots.RowCount+1;
  TableauDepots.Row:=TableauDepots.RowCount-1;
  TableauDepots.Cells[0,TableauDepots.Row]:='0';
  TableauDepots.Cells[1,TableauDepots.Row]:='0';
  TableauDepots.Cells[6,TableauDepots.Row]:='0';
end;

procedure TfrmRepository.MenuItem3Click(Sender: TObject);
begin
  // Supprimer un Dépot
  if TableauDepots.Row>0 then
     if TableauDepots.Cells[6,TableauDepots.Row]='0' then
        if Application.MessageBox(Pchar(Traduction.Items[27]+
           TableauDepots.Cells[2,TableauDepots.Row]+
           Traduction.Items[28]),Pchar(Traduction.Items[1]),MB_YESNO)=IDYES then
           begin
           // Supprimer toutes les associations dépots de cette source
           dmGenData.Query1.SQL.Text:='DELETE FROM A WHERE D='+TableauDepots.Cells[1,TableauDepots.Row];
           dmGenData.Query1.ExecSQL;
           dmGenData.Query1.SQL.Text:='DELETE FROM D WHERE no='+TableauDepots.Cells[1,TableauDepots.Row];
           dmGenData.Query1.ExecSQL;
           TableauDepots.DeleteRow(TableauDepots.Row);
        end;
end;

procedure TfrmRepository.MenuItem8Click(Sender: TObject);
begin
  dmGenData.PutCode('D',TableauDepots.Cells[1,TableauDepots.Row]);
  frmEventUsage.ShowModal;
end;

{$R *.lfm}

end.

