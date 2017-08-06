unit frm_EditTypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus, Spin;

type
  TenumTypeEditMode =(eTEM_AddNew,eTEM_EditExisting);
  { TfrmEditType }

  TfrmEditType = class(TForm)
    Button1: TButton;
    Button2: TButton;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    No: TSpinEdit;
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
    function GetIdType: integer;
    procedure SetEditMode(AValue: TenumTypeEditMode);
    procedure SetIdType(AValue: integer);
    { private declarations }
  public
    { public declarations }
    property EditMode:TenumTypeEditMode read FEditMode write SetEditMode;
    property idType:integer read GetIdType write SetIdType;
  end; 

var
  frmEditType: TfrmEditType;

implementation

uses
  frm_Main, cls_Translation, dm_GenData;

procedure GetSourceData(lidType: Integer; out lType: String; out lPhrase: String;
  out lTitle: String);
begin
  with dmGenData.Query1 do begin
  Close;
    SQL.Text:='SELECT Y.no, Y.T, Y.Y, Y.P FROM Y WHERE Y.no=:idType';
    ParamByName('idType').AsInteger:=lidType;
    Open;
    First;
    lTitle:=Fields[1].AsString;
    lPhrase:=Fields[3].AsString;
    lType:=Fields[2].AsString;
    Close;
  end;
end;

{ TfrmEditType }

procedure TfrmEditType.FormShow(Sender: TObject);

var
  lTitle, lPhrase, lType: String;
begin
  frmStemmaMainForm.SetHistoryToActual(Sender);
  Caption:=Translation.Items[199];
  Button1.Caption:=Translation.Items[152];
  Button2.Caption:=Translation.Items[164];
  Label11.Caption:=Translation.Items[166];
  Label3.Caption:=Translation.Items[172];
  // Populate le Combo-Box    ('B','D','M','N','R','X','Z')
  Y.Items.Clear;
  Y.Items.AddObject(Translation.Items[49],TObject(ptrint(ord('B'))));
  Y.Items.AddObject(Translation.Items[50],TObject(ptrint(ord('D'))));
  Y.Items.AddObject(Translation.Items[51],TObject(ptrint(ord('M'))));
  Y.Items.AddObject(Translation.Items[52],TObject(ptrint(ord('N'))));
  Y.Items.AddObject(Translation.Items[53],TObject(ptrint(ord('R'))));
  Y.Items.AddObject(Translation.Items[54],TObject(ptrint(ord('X'))));
  Y.Items.AddObject(Translation.Items[55],TObject(ptrint(ord('Z'))));
  // Populate la form
  if FEditMode=eTEM_AddNew then
     begin
     Caption:=Translation.Items[56];
     No.Value:=0;
     T.Text:='';
     P.Text:='';
     Y.ItemIndex:=0;
  end
  else
     begin
     GetSourceData(idType, lType, lPhrase, lTitle);
     T.Text:=lTitle;
     P.Text:=lPhrase;
     if Length(lType)>=1 then
       Y.ItemIndex:=y.Items.IndexOfObject(
         TObject(ptrint(ord(lType[1]))));
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

function TfrmEditType.GetIdType: integer;
begin
  result := no.Value;
end;

procedure TfrmEditType.SetIdType(AValue: integer);
begin
  if no.Value = AValue then exit;
  no.Value:=AValue;
end;

procedure TfrmEditType.Button1Click(Sender: TObject);
var
  temp, role, roles, lTypeChar:string;
  lidType, pos1,pos2:integer;
  lPhrase, lTitle: TCaption;
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

  lidType:=strtoint(no.text);
  lPhrase:=P.text;
  lTypeChar:=Copy(Y.Items[Y.ItemIndex],1,1);
  lTitle:=T.text;
  dmGenData.SaveTypeData(lidType, lTitle, lPhrase, lTypeChar, roles);
end;

{$R *.lfm}

end.

