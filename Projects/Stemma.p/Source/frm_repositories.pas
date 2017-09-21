unit frm_Repositories;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, Menus, FMUtils, LCLType;

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
    function GetidAktRepository: integer;
    procedure SetidAktRepository(AValue: integer);
    { private declarations }
  public
    { public declarations }
    property idAktRepository:integer read GetidAktRepository write SetidAktRepository;
  end; 

var
  frmRepository: TfrmRepository;

implementation

uses
  frm_Main, cls_Translation, dm_GenData, frm_Usage;

function SaveRepositoryData(Const lidRepository:integer; const lidInd: integer; const lMemo: string;
  const lDescription: string; const lTitle: string): integer;

begin
  with dmGenData.Query1 do begin
  if lidRepository=0 then
       SQL.Add('INSERT INTO D (T,D,M,I) VALUES ('''+
          lTitle+
          ''', '''+lDescription+
          ''', '''+lMemo+
          ''', '+inttostr(lidInd)+')')
    else
       SQL.Add('UPDATE D SET T='''+
         lTitle+
         ''', D='''+
         lDescription+
         ''', M='''+
         lMemo+
         ''', I='+inttostr(lidInd)+' WHERE no='+inttostr(lidRepository));
    ExecSQL;
    if lidRepository=0 then
       result:=dmGenData.GetLastIDOfTable('D')
    else
       Result:=lidRepository;
  end;
end;

procedure FillRepositoryTable(const lOnUpdate: TNotifyEvent;
  const lTblRepositories: TStringGrid);
var
  lidInd: Longint;
  i: integer;
begin
  with dmGenData.Query1 do begin
  Close;
      SQL.text:='SELECT D.no, D.T, D.D, D.M, D.I, COUNT(A.D) FROM D LEFT JOIN A on D.no=A.D GROUP by D.no ORDER BY D.D';
      Open;
      First;
      lTblRepositories.RowCount:=RecordCount+1;
      tag:= -RecordCount-1;
      if assigned(lOnUpdate) then
        lOnUpdate(dmGenData.Query1);
      tag:= 0;
      if assigned(lOnUpdate) then
        lOnUpdate(dmGenData.Query1);
      i:=0;
      While not Eof do
         begin
         i:=i+1;
         lidInd:=Fields[4].AsInteger;
         lTblRepositories.Cells[0,i]:=inttostr(lidind);
         lTblRepositories.Objects[0,i]:=TObject(ptrint(lidInd));
         lTblRepositories.Cells[1,i]:=Fields[0].AsString;
         lTblRepositories.Objects[1,i]:=TObject(ptrint(Fields[0].AsInteger));
         lTblRepositories.Cells[2,i]:=Fields[1].AsString;
         lTblRepositories.Cells[3,i]:=Fields[2].AsString;
      //   lTblRepositories.Objects[3,i]:=TObject(ptrint(dmGenData.Query1.Fields[2].AsInteger));
         lTblRepositories.Cells[4,i]:=Fields[3].AsString;
         lTblRepositories.Cells[5,i]:=DecodeName(dmGenData.GetIndividuumName(lidind),1);
         lTblRepositories.Objects[5,i]:=TObject(ptrint(lidInd));
         lTblRepositories.Cells[6,i]:=Fields[5].AsString;
         Next;
         tag:= tag+1;
         if assigned(lOnUpdate) then
           lOnUpdate(dmGenData.Query1);
      end;
  end;
end;

{ TfrmRepository }

procedure TfrmRepository.TableauDepotsDblClick(Sender: TObject);
begin
  if TableauDepots.Row>0 then
     if StrToInt(TableauDepots.Cells[0,TableauDepots.Row])>0 then
        frmStemmaMainForm.iID:=Ptrint(TableauDepots.Objects[0,TableauDepots.Row]);
end;

procedure TfrmRepository.TableauDepotsEditingDone(Sender: TObject);
var
  lTitle, lDescription, lMemo:string;
  temp, lidRepository, lidInd:integer;
  depot:boolean;
begin
  dmGenData.Query1.SQL.Clear;
  lidInd:=ptrint(TableauDepots.Objects[5,TableauDepots.Row]);
  depot:=(lidInd>0);
  if (not depot) and (ptrint(TableauDepots.Objects[0,TableauDepots.Row])>0) then
     begin
     temp:=ptrint(TableauDepots.Objects[0,TableauDepots.Row]);
     depot:=(DecodeName(dmGenData.GetIndividuumName(temp),1)+' ('+inttostr(temp)+')')=
            (TableauDepots.Cells[5,TableauDepots.Row]);
     lidInd:=temp;
     end;

  if depot then
     begin
     TableauDepots.Cells[5,TableauDepots.Row]:=DecodeName(dmGenData.GetIndividuumName(lidInd),1)+
                                                                   ' ('+inttostr(lidInd)+')';
     TableauDepots.Objects[5,TableauDepots.Row] :=TObject(ptrint(lidInd));
     TableauDepots.Cells[0,TableauDepots.Row]:=inttostr(lidInd);
     TableauDepots.Objects[0,TableauDepots.Row] :=TObject(ptrint(lidInd));
     lidRepository:=ptrint(TableauDepots.Objects[1,TableauDepots.Row]);
     lTitle:=TableauDepots.Cells[2,TableauDepots.Row];

     lMemo:=TableauDepots.Cells[4,TableauDepots.Row];
     lDescription:=TableauDepots.Cells[3,TableauDepots.Row];
     lidRepository:=SaveRepositoryData(lidRepository, lidInd, lMemo, lDescription, lTitle);
  end
  else
     begin
     TableauDepots.Cells[5,TableauDepots.Row]:='0';
     TableauDepots.Objects[5,TableauDepots.Row] :=TObject(ptrint(0));
     TableauDepots.Cells[0,TableauDepots.Row]:='0';
     TableauDepots.Objects[0,TableauDepots.Row] :=TObject(ptrint(0));

     lidRepository:=ptrint(TableauDepots.Objects[1,TableauDepots.Row]);
     lTitle:=TableauDepots.Cells[2,TableauDepots.Row];
     lDescription:=TableauDepots.Cells[3,TableauDepots.Row];
     lMemo:=TableauDepots.Cells[4,TableauDepots.Row];
     lidInd:=0;
     lidRepository:=SaveRepositoryData(lidRepository, 0, lMemo, lDescription, lTitle);
  end;
  if ptrint(TableauDepots.Objects[1,TableauDepots.Row])=0 then
     begin
  TableauDepots.Objects[1,TableauDepots.Row] :=TObject(ptrint( lidRepository));
  TableauDepots.Cells[1,TableauDepots.Row] :=inttostr( lidRepository);
     end;
  TableauDepots.SortColRow(true,3);
end;

function TfrmRepository.GetidAktRepository: integer;
begin
  result := Ptrint(TableauDepots.Objects[1,TableauDepots.Row]);
end;

procedure TfrmRepository.SetidAktRepository(AValue: integer);
var
  lIdx: Integer;
begin
  lIdx:= TableauDepots.Cols[1].IndexOfObject(TObject(ptrint(AValue)));
  if lIdx>=0 then
    TableauDepots.Row := lIdx;
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
  MyCursor: TCursor;
  lTblRepositories: TStringGrid;
  lOnUpdate: TNotifyEvent;
begin
  Caption:=Translation.Items[153];
  TableauDepots.Cells[2,0]:=Translation.Items[154];
  TableauDepots.Cells[3,0]:=Translation.Items[155];
  TableauDepots.Cells[4,0]:=Translation.Items[156];
  TableauDepots.Cells[5,0]:=Translation.Items[157];
  TableauDepots.Cells[6,0]:=Translation.Items[158];
  Button1.Caption:=Translation.Items[152];
  MenuItem8.Caption:=Translation.Items[223];
  MenuItem2.Caption:=Translation.Items[224];
  MenuItem3.Caption:=Translation.Items[226];
  MenuItem4.Caption:=Translation.Items[225];
  MyCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
  frmStemmaMainForm.ProgressBar.Position:=0;
  frmStemmaMainForm.ProgressBar.Visible:=True;
  Application.Processmessages;

  lTblRepositories:=TableauDepots;
  lOnUpdate:=@frmStemmaMainForm.UpdateProgressBar;
  FillRepositoryTable(lOnUpdate, lTblRepositories);
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
        if Application.MessageBox(Pchar(Translation.Items[27]+
           TableauDepots.Cells[2,TableauDepots.Row]+
           Translation.Items[28]),Pchar(SConfirmation),MB_YESNO)=IDYES then
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
//  dmGenData.PutCode('D',);
  frmShowUsage.UsageOf:=eSU_Repositories;
  frmShowUsage.idLink:=ptrint(TableauDepots.Objects[1,TableauDepots.Row]);
  frmShowUsage.ShowModal;
end;

{$R *.lfm}

end.

