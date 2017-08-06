unit frm_Types;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Menus,
  StdCtrls,StrUtils, LCLType;

type

  { TfrmTypes }

  TfrmTypes = class(TForm)
    Button1: TButton;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem8: TMenuItem;
    PopupMenu1: TPopupMenu;
    TableauTypes: TStringGrid;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure TableauTypesEditingDone(Sender: TObject);
  private
    function GetIdAktType: integer;
    procedure SetIdAktType(AValue: integer);
    { private declarations }
  public
    { public declarations }
    property idAktType:integer read GetIdAktType write SetIdAktType;
  end; 

var
  frmTypes: TfrmTypes;

implementation

uses
  frm_Main, cls_Translation, dm_GenData, frm_Usage, frm_EditTypes;

procedure FillTableTypes(const ltblTypes: TStringGrid;OnUpdate:TNotifyEvent);
var
  i: integer;
begin
    with dmGenData.Query1 do begin
      Close;
      SQL.Text:='SELECT Y.no, Y.T, Y.Y, Y.P FROM Y ORDER BY Y.T';
      Open;
      First;
      ltblTypes.RowCount:=RecordCount+1;
      tag := -RecordCount-1;
      if assigned(OnUpdate) then
         OnUpdate(dmGenData.Query1);
      tag := 0;
      if assigned(OnUpdate) then
         OnUpdate(dmGenData.Query1);
      i:=0;
      While not Eof do
         begin
         i:=i+1;
         ltblTypes.Cells[0,i]:=Fields[0].AsString;
         ltblTypes.Cells[1,i]:=Fields[0].AsString;
         ltblTypes.Cells[2,i]:=Fields[1].AsString;
         ltblTypes.Cells[3,i]:=Fields[2].AsString;
         ltblTypes.Cells[4,i]:=Fields[3].AsString;
    // Aller chercher les utilisation
         dmGenData.Query2.SQL.Clear;
         if ltblTypes.Cells[3,i]='R' then
            dmGenData.Query2.SQL.add('SELECT COUNT(R.Y) FROM R WHERE R.Y='+Fields[0].AsString)
         else
           if ltblTypes.Cells[3,i]='N' then
              dmGenData.Query2.SQL.add('SELECT COUNT(N.Y) FROM N WHERE N.Y='+Fields[0].AsString)
           else
             dmGenData.Query2.SQL.add('SELECT COUNT(E.Y) FROM E WHERE E.Y='+Fields[0].AsString);
         dmGenData.Query2.Open;
         dmGenData.Query2.First;
         ltblTypes.Cells[5,i]:=dmGenData.Query2.Fields[0].AsString;
         tag := Tag+1;
         if assigned(OnUpdate) then
            OnUpdate(dmGenData.Query1);
         Next;
      end;
    end;
end;

procedure DeleteType(const lidType: PtrInt);
begin
  with dmGenData.Query1 do begin
close;
                 SQL.Text:='DELETE FROM Y WHERE no=:idtype';
                  ParamByName('idType').AsInteger:=lidType;
                 ExecSQL;
  end;
end;

procedure UpdateTableTypes(const ltblTypes: TStringGrid; const lidType: Integer
  );
var
  lTblAktRow: Integer;
begin
  with dmGenData.Query1 do begin
  lTblAktRow:=ltblTypes.Row;
Close;
            SQL.Text:='SELECT Y.no, Y.T, Y.Y, Y.P FROM Y WHERE Y.no=:idType';
            ParamByName('idType').AsInteger:=lidType;
               ltblTypes.Cells[0,lTblAktRow];
            Open;
            First;
            ltblTypes.Cells[2,lTblAktRow]:=Fields[1].AsString;
            ltblTypes.Cells[3,lTblAktRow]:=Fields[2].AsString;
            ltblTypes.Cells[4,lTblAktRow]:=Fields[3].AsString;
            Close;
            // Aller chercher les utilisation

            case ltblTypes.Cells[3,lTblAktRow][1] of
             'R':SQL.Text:='SELECT COUNT(R.Y) FROM R WHERE R.Y=:idType';
             'N':SQL.Text:='SELECT COUNT(N.Y) FROM N WHERE N.Y=:idType'
              else
                 SQL.Text:='SELECT COUNT(E.Y) FROM E WHERE E.Y=:idType';
             end;
            ParamByName('idType').AsInteger:=lidType;
            Open;
            First;
            ltblTypes.Cells[5,lTblAktRow]:=Fields[0].AsString;
            Close;
  end;
end;

{$R *.lfm}

{ TfrmTypes }

procedure TfrmTypes.FormResize(Sender: TObject);
begin
  TableauTypes.Width := (Sender as Tform).Width-16;
  TableauTypes.Height := (Sender as Tform).Height-51;
  Button1.Top:= (Sender as Tform).Height-35;
  Button1.Left:= (Sender as Tform).Width-80;
end;

procedure TfrmTypes.FormShow(Sender: TObject);
var
  MyCursor: TCursor;
  ltblTypes: TStringGrid;
begin
  Caption:=Translation.Items[220];
  Button1.Caption:=Translation.Items[152];
  TableauTypes.Cells[2,0]:=Translation.Items[154];
  TableauTypes.Cells[3,0]:=Translation.Items[185];
  TableauTypes.Cells[4,0]:=Translation.Items[221];
  TableauTypes.Cells[5,0]:=Translation.Items[158];
  MenuItem8.Caption:=Translation.Items[223];
  MenuItem2.Caption:=Translation.Items[224];
  MenuItem4.Caption:=Translation.Items[225];
  MenuItem3.Caption:=Translation.Items[226];
  MyCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  frmStemmaMainForm.ProgressBar.Position:=0;
  frmStemmaMainForm.ProgressBar.Visible:=True;
  Application.Processmessages;

  ltblTypes:=TableauTypes;
  FillTableTypes(ltblTypes,@frmStemmaMainForm.UpdateProgressBar);
  frmStemmaMainForm.ProgressBar.Visible:=False;
  Screen.Cursor := MyCursor;
end;

procedure TfrmTypes.MenuItem2Click(Sender: TObject);    // Ajouter
begin
//     dmGenData.PutCode('A',0);
     frmEditType.EditMode:=eTEM_AddNew;
     if frmEditType.Showmodal = mrOK then
        begin
        FormShow(Sender);
     end;
end;

procedure TfrmTypes.MenuItem3Click(Sender: TObject);    // Supprimer

begin
  if TableauTypes.Row>0 then
     if StrtoInt(TableauTypes.Cells[5,TableauTypes.Row])=0 then
        if MessageDlg(SConfirmation,format(rsAreYouSureToDelete,[TableauTypes.Cells[2,TableauTypes.Row]]),mtConfirmation,mbYesNo,0)=mryes  then
           begin
              DeleteType(idAktType);
              TableauTypes.DeleteRow(TableauTypes.Row);
        end;
end;

procedure TfrmTypes.MenuItem4Click(Sender: TObject);      // Modifier

begin
  frmEditType.EditMode:=eTEM_EditExisting;
  frmEditType.idType:=idAktType;
  if TableauTypes.Row>0 then
     if frmEditType.Showmodal = mrOK then
        UpdateTableTypes(TableauTypes, idAktType);
end;

procedure TfrmTypes.MenuItem8Click(Sender: TObject);
begin
  if TableauTypes.Row>0 then
     if StrtoInt(TableauTypes.Cells[5,TableauTypes.Row])>0 then
        begin
        frmShowUsage.UsageOf:=eSU_Types;
        frmShowUsage.idLink:=ptrint(TableauTypes.Objects[1,TableauTypes.Row]);
        frmShowUsage.ShowModal;
     end;
end;

procedure TfrmTypes.TableauTypesEditingDone(Sender: TObject);
var
  temp, role, roles:string;
  pos1,pos2:integer;
begin
  roles:='';
  temp:=(Sender as TStringGrid).Cells[4,(Sender as TStringGrid).Row];
  while ANSIPos('<R=',temp)>0 do
     begin
     pos1:=ANSIPos('<R=',temp);
     temp:=Copy(temp,pos1+3,length(temp));
     pos2:=ANSIPos('>',temp);
     role:=uppercase(Copy(temp,1,pos2-1));
     if ANSIPos(role,roles)<=0 then
        if length(roles)>0 then
           roles:=roles+'|'+role
        else
           roles:=role;
     temp:=Copy(temp,pos2+1,length(temp));
  end;
  temp:=(Sender as TStringGrid).Cells[4,(Sender as TStringGrid).Row];
  while ANSIPos('[R=',temp)>0 do
     begin
     pos1:=ANSIPos('[R=',temp);
     temp:=Copy(temp,pos1+3,length(temp));
     pos2:=ANSIPos(']',temp);
     role:=uppercase(Copy(temp,1,pos2-1));
     if ANSIPos(role,roles)<=0 then
        if length(roles)>0 then
           roles:=roles+'|'+role
        else
           roles:=role;
     temp:=Copy(temp,pos2+1,length(temp));
  end;
  dmGenData.Query1.SQL.Clear;
  dmGenData.Query1.SQL.Add('UPDATE Y SET T='''+
     AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI((Sender as TStringGrid).Cells[2,(Sender as TStringGrid).Row]),'\','\\'),'"','\"'),'''','\''')+
     ''', Y='''+
     AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI((Sender as TStringGrid).Cells[3,(Sender as TStringGrid).Row]),'\','\\'),'"','\"'),'''','\''')+
     ''', P='''+
     AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI((Sender as TStringGrid).Cells[4,(Sender as TStringGrid).Row]),'\','\\'),'"','\"'),'''','\''')+
     ''', R='''+
     AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Roles),'\','\\'),'"','\"'),'''','\''')+
     ''' WHERE no='+(Sender as TStringGrid).Cells[1,(Sender as TStringGrid).Row]);
  dmGenData.Query1.ExecSQL;
end;

function TfrmTypes.GetIdAktType: integer;
begin
  result := ptrint(TableauTypes.Objects[0,TableauTypes.Row])
end;

procedure TfrmTypes.SetIdAktType(AValue: integer);
var
  lIdx: Integer;
begin
  if GetIdAktType = AValue then exit;
  lIdx := TableauTypes.Cols[0].IndexOfObject(TObject(ptrint(AValue)));
  if lidx>=0 then
     TableauTypes.Row:=lIdx;
end;

end.

