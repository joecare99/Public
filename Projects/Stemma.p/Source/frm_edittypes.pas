unit frm_EditTypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus, StrUtils;

type
  TenumTypeEditMode =(eTEM_AddNew,eTEM_EditExisting);
  { TfrmEditType }

  TfrmEditType = class(TForm)
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
    FEditMode: TenumTypeEditMode;
    procedure SetEditMode(AValue: TenumTypeEditMode);
    { private declarations }
  public
    { public declarations }
    property EditMode:TenumTypeEditMode read FEditMode write SetEditMode;
  end; 

var
  frmEditType: TfrmEditType;

implementation

uses
  frm_Types, frm_Main, cls_Translation, dm_GenData;

procedure SaveTypeData(const lTitle: TCaption; const lPhrase: TCaption;
  const lidType: TCaption; const lTypeChar: string; const roles: string);
begin
  dmGenData.Query1.SQL.Clear;
    if lidType='0' then
       dmGenData.Query1.SQL.Add('INSERT INTO Y (T, Y, P, R) VALUES ('''+
          AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(lTitle),'\','\\'),'"','\"'),'''','\''')+
          ''', '''+lTypeChar+''', '''+
          AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(lPhrase),'\','\\'),'"','\"'),'''','\''')+
          ''', '''+
          AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Roles),'\','\\'),'"','\"'),'''','\''')+
          ''')')
    else
       dmGenData.Query1.SQL.Add('UPDATE Y SET T='''+
          AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(lTitle),'\','\\'),'"','\"'),'''','\''')+
          ''', Y='''+lTypeChar+
          ''', P='''+
          AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(lPhrase),'\','\\'),'"','\"'),'''','\''')+
          ''', R='''+
          AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Roles),'\','\\'),'"','\"'),'''','\''')+
          ''' WHERE no='+lidType);
    dmGenData.Query1.ExecSQL;
end;

{ TfrmEditType }

procedure TfrmEditType.FormShow(Sender: TObject);

begin
  frmStemmaMainForm.SetHistoryToActual(Sender);
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
  if FEditMode=eTEM_AddNew then
     begin
     Caption:=Translation.Items[56];
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

procedure TfrmEditType.MenuItem1Click(Sender: TObject);
begin
  Button1Click(Sender);
  ModalResult:=mrOk;
end;

procedure TfrmEditType.MenuItem2Click(Sender: TObject);
var
  lsResult: String;
begin
    if ActiveControl.Name = p.Name then
   begin
    lsResult := frmStemmaMainForm.RetreiveFromHistoy('P');
    if lsResult <> '' then
     begin
      P.Text := lsResult;
      PEditingDone(Sender);
     end;
   end
end;

procedure TfrmEditType.PEditingDone(Sender: TObject);
begin
  frmStemmaMainForm.AppendHistoryData('P',P.Text);
end;

procedure TfrmEditType.SetEditMode(AValue: TenumTypeEditMode);
begin
  if FEditMode=AValue then Exit;
  FEditMode:=AValue;
end;

procedure TfrmEditType.Button1Click(Sender: TObject);
var
  temp, role, roles, lTypeChar:string;
  pos1,pos2:integer;
  lidType, lPhrase, lTitle: TCaption;
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

  lidType:=no.text;
  lPhrase:=P.text;
  lTypeChar:=Copy(Y.Items[Y.ItemIndex],1,1);
  lTitle:=T.text;
  SaveTypeData(lTitle, lPhrase, lidType, lTypeChar, roles);
end;

{$R *.lfm}

end.

