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
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmTypes: TfrmTypes;

implementation

uses
  frm_Main, Traduction, dm_GenData, frm_Usage, frm_EditTypes;

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
  i:integer;
  MyCursor: TCursor;
begin
  Caption:=Traduction.Items[220];
  Button1.Caption:=Traduction.Items[152];
  TableauTypes.Cells[2,0]:=Traduction.Items[154];
  TableauTypes.Cells[3,0]:=Traduction.Items[185];
  TableauTypes.Cells[4,0]:=Traduction.Items[221];
  TableauTypes.Cells[5,0]:=Traduction.Items[158];
  MenuItem8.Caption:=Traduction.Items[223];
  MenuItem2.Caption:=Traduction.Items[224];
  MenuItem4.Caption:=Traduction.Items[225];
  MenuItem3.Caption:=Traduction.Items[226];
  MyCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  frmStemmaMainForm.ProgressBar.Position:=0;
  frmStemmaMainForm.ProgressBar.Visible:=True;
  Application.Processmessages;
  dmGenData.Query1.SQL.Text:='SELECT Y.no, Y.T, Y.Y, Y.P FROM Y ORDER BY Y.T';
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  TableauTypes.RowCount:=dmGenData.Query1.RecordCount+1;
  frmStemmaMainForm.ProgressBar.Max:=TableauTypes.RowCount;
  i:=0;
  While not dmGenData.Query1.Eof do
     begin
     i:=i+1;
     TableauTypes.Cells[0,i]:=dmGenData.Query1.Fields[0].AsString;
     TableauTypes.Cells[1,i]:=dmGenData.Query1.Fields[0].AsString;
     TableauTypes.Cells[2,i]:=dmGenData.Query1.Fields[1].AsString;
     TableauTypes.Cells[3,i]:=dmGenData.Query1.Fields[2].AsString;
     TableauTypes.Cells[4,i]:=dmGenData.Query1.Fields[3].AsString;
// Aller chercher les utilisation
     dmGenData.Query2.SQL.Clear;
     if TableauTypes.Cells[3,i]='R' then
        dmGenData.Query2.SQL.add('SELECT COUNT(R.Y) FROM R WHERE R.Y='+dmGenData.Query1.Fields[0].AsString)
     else
       if TableauTypes.Cells[3,i]='N' then
          dmGenData.Query2.SQL.add('SELECT COUNT(N.Y) FROM N WHERE N.Y='+dmGenData.Query1.Fields[0].AsString)
       else
         dmGenData.Query2.SQL.add('SELECT COUNT(E.Y) FROM E WHERE E.Y='+dmGenData.Query1.Fields[0].AsString);
     dmGenData.Query2.Open;
     dmGenData.Query2.First;
     TableauTypes.Cells[5,i]:=dmGenData.Query2.Fields[0].AsString;
     dmGenData.Query1.Next;
     frmStemmaMainForm.ProgressBar.Position:=frmStemmaMainForm.ProgressBar.Position+1;
     Application.ProcessMessages;
  end;
  frmStemmaMainForm.ProgressBar.Visible:=False;
  Screen.Cursor := MyCursor;
end;

procedure TfrmTypes.MenuItem2Click(Sender: TObject);    // Ajouter
begin
     dmGenData.PutCode('A',0);
     if EditType.Showmodal = mrOK then
        begin
        FormShow(Sender);
     end;
end;

procedure TfrmTypes.MenuItem3Click(Sender: TObject);    // Supprimer
begin
  if TableauTypes.Row>0 then
     if StrtoInt(TableauTypes.Cells[5,TableauTypes.Row])=0 then
        if Application.MessageBox(Pchar(Traduction.Items[133]+
           TableauTypes.Cells[2,TableauTypes.Row]+Traduction.Items[28]),pchar(Traduction.Items[1]),MB_YESNO)=IDYES then
           begin
              dmGenData.Query1.SQL.Text:='DELETE FROM Y WHERE no='+TableauTypes.Cells[1,TableauTypes.Row];
              dmGenData.Query1.ExecSQL;
              TableauTypes.DeleteRow(TableauTypes.Row);
        end;
end;

procedure TfrmTypes.MenuItem4Click(Sender: TObject);      // Modifier
begin
  if TableauTypes.Row>0 then
     if EditType.Showmodal = mrOK then
        begin
        dmGenData.Query1.SQL.Text:='SELECT Y.no, Y.T, Y.Y, Y.P FROM Y WHERE Y.no='+
           TableauTypes.Cells[0,TableauTypes.Row];
        dmGenData.Query1.Open;
        dmGenData.Query1.First;
        TableauTypes.Cells[2,TableauTypes.Row]:=dmGenData.Query1.Fields[1].AsString;
        TableauTypes.Cells[3,TableauTypes.Row]:=dmGenData.Query1.Fields[2].AsString;
        TableauTypes.Cells[4,TableauTypes.Row]:=dmGenData.Query1.Fields[3].AsString;
        // Aller chercher les utilisation
        dmGenData.Query2.SQL.Clear;
        if TableauTypes.Cells[3,TableauTypes.Row]='R' then
           dmGenData.Query2.SQL.add('SELECT COUNT(R.Y) FROM R WHERE R.Y='+dmGenData.Query1.Fields[0].AsString)
        else
          if TableauTypes.Cells[3,TableauTypes.Row]='N' then
             dmGenData.Query2.SQL.add('SELECT COUNT(N.Y) FROM N WHERE N.Y='+dmGenData.Query1.Fields[0].AsString)
          else
             dmGenData.Query2.SQL.add('SELECT COUNT(E.Y) FROM E WHERE E.Y='+dmGenData.Query1.Fields[0].AsString);
        dmGenData.Query2.Open;
        dmGenData.Query2.First;
        TableauTypes.Cells[5,TableauTypes.Row]:=dmGenData.Query2.Fields[0].AsString;
     end;
end;

procedure TfrmTypes.MenuItem8Click(Sender: TObject);
begin
  if TableauTypes.Row>0 then
     if StrtoInt(TableauTypes.Cells[5,TableauTypes.Row])>0 then
        begin
        dmGenData.PutCode('T',TableauTypes.Cells[1,TableauTypes.Row]);
        frmEventUsage.ShowModal;
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

end.

