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
  dmgendata.FillTableTypes(ltblTypes,@frmStemmaMainForm.UpdateProgressBar);
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
              dmgendata.DeleteType(idAktType);
              TableauTypes.DeleteRow(TableauTypes.Row);
        end;
end;

procedure TfrmTypes.MenuItem4Click(Sender: TObject);      // Modifier

begin
  frmEditType.EditMode:=eTEM_EditExisting;
  frmEditType.idType:=idAktType;
  if TableauTypes.Row>0 then
     if frmEditType.Showmodal = mrOK then
        dmgendata.UpdateTableTypes(TableauTypes, idAktType);
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
  with Sender as TStringGrid do
    dmGendata.SaveTypeData(ptrint(Objects[1,Row]),Cells[2,Row],Cells[4,Row],Cells[3,Row],Roles);
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

