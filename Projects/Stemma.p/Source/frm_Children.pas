unit frm_Children;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Menus,
  FMUtils, frm_EditParents, LCLType;

type

  { TfrmChildren }

  TfrmChildren = class(TForm)
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    PopupMenuEnfant: TPopupMenu;
    TableauEnfants: TStringGrid;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure TableauEnfantsDblClick(Sender: TObject);
    procedure TableauEnfantsDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
  private
    function GetIdChild: integer;
    function GetIdRelation: integer;
    { private declarations }
  public
    { public declarations }
    procedure PopulateEnfants(Sender:Tobject);
    property idRelation: integer read GetIdRelation;
    property idChild: integer read GetIdChild;
  end;


var
  frmChildren: TfrmChildren;

implementation

uses
  frm_Main, cls_Translation, dm_GenData;


{$R *.lfm}

{ TfrmChildren }

procedure TfrmChildren.PopulateEnfants(Sender: Tobject);
var
  row, principaux:integer;
  naissance,deces, lName:string;
  lidParent: LongInt;
  bRelExists: Boolean;
begin
  dmGenData.Query1.close;
  dmGenData.Query1.SQL.text:='SELECT R.no, R.X, R.Y, R.A FROM R WHERE R.B=:idInd ORDER BY R.X DESC, R.SD, R.Y';
  dmGenData.Query1.ParamByName('idInd').AsInteger:= frmStemmaMainForm.iID;
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  row:=1;
  principaux:=0;
  frmChildren.TableauEnfants.RowCount:=dmGenData.Query1.RecordCount+1;
  While not dmGenData.Query1.EOF do
  begin
     frmChildren.TableauEnfants.Cells[0,row]:=dmGenData.Query1.Fields[0].AsString;
     frmChildren.TableauEnfants.Objects[0,row]:=TObject(ptrint(dmGenData.Query1.Fields[0].AsInteger));

     if dmGenData.Query1.Fields[1].AsBoolean then
        begin
        frmChildren.TableauEnfants.Cells[1,row]:='*';
        principaux:=principaux+1;
     end
     else
        frmChildren.TableauEnfants.Cells[1,row]:='';

     frmChildren.TableauEnfants.Cells[2,row]:=dmGenData.GetTypeName(dmGenData.Query1.Fields[2].AsInteger);
     frmChildren.TableauEnfants.Objects[2,row]:=TObject(ptrint( dmGenData.Query1.Fields[2].AsInteger));

     lidParent := dmGenData.Query1.Fields[3].AsInteger;
     dmGenData.GetIndBaseData(lidParent,lName,naissance,deces);

     frmChildren.TableauEnfants.Cells[3,row]:=format('%s (%s - %s)',[DecodeName(lName,1),naissance,deces]);
     frmChildren.TableauEnfants.Objects[3,row]:=TObject(ptrint(lidParent));

     frmChildren.TableauEnfants.Cells[4,row]:=dmGenData.GetCitationBestQuality('R',ptrint(frmChildren.TableauEnfants.Objects[0,row]));
     frmChildren.TableauEnfants.Cells[5,row]:=dmGenData.Query1.Fields[3].AsString;

     If dmGenData.CheckIndChildExists(lidParent) then
        frmChildren.TableauEnfants.Cells[6,row]:='+'
     else
        frmChildren.TableauEnfants.Cells[6,row]:='';
     dmGenData.Query1.Next;
     row:=row+1;
  end;
  frmChildren.Caption:=Translation.Items[57]+' ('+IntToStr(principaux)+' & '+IntToStr(frmChildren.TableauEnfants.RowCount-1-principaux)+')'
end;

procedure TfrmChildren.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  SaveFormPosition(Sender as TForm);
  SaveGridPosition(TableauEnfants as TStringGrid,5);
end;

procedure TfrmChildren.FormResize(Sender: TObject);
begin
  TableauEnfants.Width := (Sender as Tform).Width;
  TableauEnfants.Height := (Sender as Tform).Height;
  TableauEnfants.Columns[2].Width := (Sender as Tform).Width-142;
end;

procedure TfrmChildren.FormShow(Sender: TObject);
begin
  Caption:=Translation.Items[57];
  TableauEnfants.Cells[2,0]:=Translation.Items[185];
  TableauEnfants.Cells[3,0]:=Translation.Items[200];
  TableauEnfants.Cells[4,0]:=Translation.Items[177];
  MenuItem1.Caption:=Translation.Items[222];
  MenuItem3.Caption:=Translation.Items[224];
  MenuItem4.Caption:=Translation.Items[225];
  MenuItem5.Caption:=Translation.Items[226];
  GetFormPosition(Sender as TForm,0,0,70,1000);
  GetGridPosition(TableauEnfants as TStringGrid,5);
  PopulateEnfants(sender);
end;

procedure TfrmChildren.MenuItem1Click(Sender: TObject);
begin
  If TableauEnfants.Row>0 then
     frmStemmaMainForm.iID:=ptrint(TableauEnfants.Objects[5,TableauEnfants.Row]);
end;

procedure TfrmChildren.MenuItem3Click(Sender: TObject);
begin
  // Ajouter un enfant
  dmGenData.PutCode('E',0);
  dmGenData.PutCode('A',0);
  if frmEditParents.Showmodal = mrOK then
     begin
     PopulateEnfants(sender);
  end;
end;

procedure TfrmChildren.MenuItem5Click(Sender: TObject);
begin
  // Supprimer un enfant
  if TableauEnfants.Row>0 then
     if Application.MessageBox(Pchar(Translation.Items[58]+
           TableauEnfants.Cells[3,TableauEnfants.Row]+
           Translation.Items[28]),pchar(Translation.Items[1]),MB_YESNO)=IDYES then
        begin
        dmGenData.SaveModificationTime(strtoint(TableauEnfants.Cells[5,TableauEnfants.Row]));
        dmGenData.Query1.SQL.Text:='DELETE FROM C WHERE Y=''R'' AND N='+TableauEnfants.Cells[0,TableauEnfants.Row];
        dmGenData.Query1.ExecSQL;
        dmGenData.Query1.SQL.Text:='DELETE FROM R WHERE no='+TableauEnfants.Cells[0,TableauEnfants.Row];
        dmGenData.Query1.ExecSQL;
        TableauEnfants.DeleteRow(TableauEnfants.Row);
        dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
     end;
end;

procedure TfrmChildren.TableauEnfantsDblClick(Sender: TObject);
begin
  If TableauEnfants.Row>0 then
     begin
     dmGenData.PutCode('E',0);
     If frmEditParents.Showmodal=mrOK then
        PopulateEnfants(sender);
  end;
end;

procedure TfrmChildren.TableauEnfantsDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin
  if ((Sender as TStringGrid).Cells[1,aRow]='*') and (aCol=3) then
     begin
     (Sender as TStringGrid).Canvas.Font.Bold := true;
     (Sender as TStringGrid).Canvas.TextOut(aRect.Left+2,aRect.Top+2,(Sender as TStringGrid).Cells[aCol,aRow]);
  end;
end;

function TfrmChildren.GetIdChild: integer;
begin
  Result := PtrInt(TableauEnfants.Objects[1, frmChildren.TableauEnfants.Row]);
end;

function TfrmChildren.GetIdRelation: integer;
begin
  Result := PtrInt(TableauEnfants.Objects[0, frmChildren.TableauEnfants.Row]);
end;


end.

