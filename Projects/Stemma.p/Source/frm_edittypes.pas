unit frm_EditTypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus, StrUtils;

type

  { TEditType }

  TEditType = class(TForm)
    Button1: TButton;
    Button2: TButton;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    No: TEdit;
    Y: TComboBox;
    Label10: TLabel;
    Label11: TLabel;
    Label3: TLabel;
    P: TMemo;
    T: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure PEditingDone(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  EditType: TEditType;

implementation

uses
  frm_Types, frm_Main, cls_Translation, dm_GenData;

{ TEditType }

procedure TEditType.FormShow(Sender: TObject);
var
  code,nocode:string;
begin
  frmStemmaMainForm.DataHist.Row:=0;
  Caption:=Translation.Items[199];
  Button1.Caption:=Translation.Items[152];
  Button2.Caption:=Translation.Items[164];
  Label11.Caption:=Translation.Items[166];
  Label3.Caption:=Translation.Items[172];
  // Populate le Combo-Box    ('B','D','M','N','R','X','Z')
  Y.Items.Clear;
  Y.Items.Add(Translation.Items[49]);
  Y.Items.Add(Translation.Items[50]);
  Y.Items.Add(Translation.Items[51]);
  Y.Items.Add(Translation.Items[52]);
  Y.Items.Add(Translation.Items[53]);
  Y.Items.Add(Translation.Items[54]);
  Y.Items.Add(Translation.Items[55]);
  // Populate la form
  dmGenData.getcode(code,nocode);
  if code='A' then
     begin
     EditType.Caption:=Translation.Items[56];
     No.Text:='0';
     T.Text:='';
     P.Text:='';
     Y.ItemIndex:=0;
  end
  else
     begin
     dmGenData.Query1.SQL.Text:='SELECT Y.no, Y.T, Y.Y, Y.P FROM Y WHERE Y.no='+
                                     FrmTypes.TableauTypes.Cells[1,FrmTypes.TableauTypes.Row];
     dmGenData.Query1.Open;
     dmGenData.Query1.First;
     No.Text:=dmGenData.Query1.Fields[0].AsString;
     T.Text:=dmGenData.Query1.Fields[1].AsString;
     P.Text:=dmGenData.Query1.Fields[3].AsString;
     Y.ItemIndex:=0;
     while not (Copy(Y.Items[Y.ItemIndex],1,1)=dmGenData.Query1.Fields[2].AsString) do
        Y.ItemIndex:=Y.ItemIndex+1;
  end;
end;

procedure TEditType.MenuItem1Click(Sender: TObject);
begin
  Button1Click(Sender);
  ModalResult:=mrOk;
end;

procedure TEditType.MenuItem2Click(Sender: TObject);
var
  i:integer;
  found:boolean;
begin
  if EditType.ActiveControl.Name='P' then
     begin
     found:=false;
     For i:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,i]='P' then
           begin
           P.text:=frmStemmaMainForm.DataHist.Cells[1,i];
           PEditingDone(Sender);
           found:=true;
           break;
        end;
     end;
     if not found then
        begin
        For i:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
           begin
           if frmStemmaMainForm.DataHist.Cells[0,i]='P' then
              begin
              P.text:=frmStemmaMainForm.DataHist.Cells[1,i];
              PEditingDone(Sender);
              found:=true;
              break;
           end;
        end;
     end;
  end;
  if found then frmStemmaMainForm.DataHist.Row:=i+1;
end;

procedure TEditType.PEditingDone(Sender: TObject);
begin
  frmStemmaMainForm.DataHist.InsertColRow(false,0);
  frmStemmaMainForm.DataHist.Cells[0,0]:='P';
  frmStemmaMainForm.DataHist.Cells[1,0]:=P.Text;
end;

procedure TEditType.Button1Click(Sender: TObject);
var
  temp, role, roles:string;
  pos1,pos2:integer;
begin
  roles:='';
  temp:=p.text;
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
  temp:=p.text;
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
  if no.text='0' then
     dmGenData.Query1.SQL.Add('INSERT INTO Y (T, Y, P, R) VALUES ('''+
        AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(T.text),'\','\\'),'"','\"'),'''','\''')+
        ''', '''+Copy(Y.Items[Y.ItemIndex],1,1)+''', '''+
        AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(P.text),'\','\\'),'"','\"'),'''','\''')+
        ''', '''+
        AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Roles),'\','\\'),'"','\"'),'''','\''')+
        ''')')
  else
     dmGenData.Query1.SQL.Add('UPDATE Y SET T='''+
        AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(T.text),'\','\\'),'"','\"'),'''','\''')+
        ''', Y='''+Copy(Y.Items[Y.ItemIndex],1,1)+
        ''', P='''+
        AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(P.text),'\','\\'),'"','\"'),'''','\''')+
        ''', R='''+
        AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Roles),'\','\\'),'"','\"'),'''','\''')+
        ''' WHERE no='+no.text);
  dmGenData.Query1.ExecSQL;
end;

{$R *.lfm}

end.

