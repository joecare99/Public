unit frm_Names;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls, ExtCtrls, Spin, Menus, FMUtils, frm_EditName, LCLType;

type

  { TfrmNames }

  TfrmNames = class(TForm)
    Label1: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    Modifie: TLabel;
    PopupMenuEnfant: TPopupMenu;
    Sexe: TImage;
    Interet: TSpinEdit;
    Vivant: TImage;
    TableauNoms: TStringGrid;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure InteretChange(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure SexeDblClick(Sender: TObject);
    procedure TableauNomsDblClick(Sender: TObject);
    procedure TableauNomsDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure VivantDblClick(Sender: TObject);
  private
    function GetIdName: integer;
    procedure ModifyIndividual(Sender: TObject);
    { private declarations }
  public
    { public declarations }
    procedure PopulateNom(Sender: TObject);
    property idName:integer read GetIdName;
  end;


var
  frmNames: TfrmNames;

implementation

uses
  frm_Main,Traduction, dm_GenData, frm_Explorer;

procedure UpdateNamesPrefered(const idNamePref, idNameUnPref: integer);
begin
  dmGenData.Query1.SQL.Text:='UPDATE N SET X=0 WHERE N.no='+inttostr(idNameUnPref);
  dmGenData.Query1.ExecSQL;
  dmGenData.Query1.SQL.Text:='UPDATE N SET X=1 WHERE N.no='+inttostr(idNamePref);
  dmGenData.Query1.ExecSQL;
end;


{$R *.lfm}

{ TfrmNames }

procedure TfrmNames.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
     dmGenData.OnModifyIndividual:=nil;
     SaveFormPosition(Sender as TForm);
     SaveGridPosition(TableauNoms as TStringGrid,5);
end;

procedure TfrmNames.FormResize(Sender: TObject);
begin
  TableauNoms.Width := (Sender as Tform).Width-17;
  TableauNoms.Height := (Sender as Tform).Height-41;
  TableauNoms.Columns[3].Width := (Sender as Tform).Width-207;
  Sexe.Top := (Sender as Tform).Height-32;
  Vivant.Top := (Sender as Tform).Height-32;
  Interet.Top := (Sender as Tform).Height-29;
  Label1.Top := (Sender as Tform).Height-25;
  Modifie.Top := (Sender as Tform).Height-25;
end;

procedure TfrmNames.PopulateNom(Sender: TObject);
var
  filename, sSex, sLiving, sDate, sTypeName:string;
  iInterest, lidInd: LongInt;
begin
  lidInd:= frmStemmaMainForm.iID;
  dmGenData.PopulateNameTable(lidInd,TableauNoms);

  if dmGenData.GetDataOfInd(frmStemmaMainForm.iID,sSex,sLiving,sDate,iInterest) then
  begin
  If sSex[1]='M' then
     filename:=resPath+'\masculin.ico'
  else
     If sSex[1]='F' then
        filename:=resPath+'\feminin.ico'
     else
        filename:=resPath+'\inconnu.ico';
   sexe.hint:=sSex;
   sexe.Picture.Icon.LoadFromFile(filename);

   Vivant.Hint:=sLiving;
  If  Vivant.Hint[1]='O' then
     filename:=resPath+'\vivant.ico'
  else If  Vivant.Hint[1]='N' then
     filename:=resPath+'\mort.ico'
  else
     filename:=resPath+'\inconnu.ico';
   Vivant.Picture.Icon.LoadFromFile(filename);
   Interet.Value := iInterest;
   Modifie.Caption:=ConvertDate('1'+sDate+'030000000000',1);
   Caption:=Traduction.Items[126]+' ('+IntToStr( TableauNoms.RowCount-1)+
     Traduction.Items[127];

  end;
end;

procedure TfrmNames.FormShow(Sender: TObject);
begin
  Caption:=Traduction.Items[214];
  TableauNoms.Cells[2,0]:=Traduction.Items[185];
  TableauNoms.Cells[3,0]:=Traduction.Items[136];
  TableauNoms.Cells[4,0]:=Traduction.Items[176];
  TableauNoms.Cells[5,0]:=Traduction.Items[177];
  Label1.Caption:=Traduction.Items[215];
  MenuItem1.Caption:=Traduction.Items[234];
  MenuItem3.Caption:=Traduction.Items[224];
  MenuItem4.Caption:=Traduction.Items[225];
  MenuItem5.Caption:=Traduction.Items[226];
  GetFormPosition(Sender as TForm,0,0,70,1000);
  GetGridPosition(TableauNoms as TStringGrid,5);
  dmGenData.OnModifyIndividual:=@ModifyIndividual;
  PopulateNom(Sender);
end;

procedure TfrmNames.InteretChange(Sender: TObject);
begin
  // Enregistrer la modification
  dmGenData.Query1.SQL.Clear;
  dmGenData.Query1.SQL.Add('UPDATE I SET I='+InttoStr(Interet.Value)+' WHERE no='+
                            frmStemmaMainForm.sID);
  dmGenData.Query1.ExecSQL;
  dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
end;

procedure TfrmNames.MenuItem1Click(Sender: TObject);
var
  temp:integer;
  lidName: Integer;
begin
     If TableauNoms.Cells[1,TableauNoms.row]='*' then
        ShowMessage(Traduction.Items[128])
     else
        begin
        lidName:=ptrint(TableauNoms.Objects[0,TableauNoms.row]);

        // Get idName of prefered name
        dmGenData.Query1.SQL.Text:='SELECT no FROM N WHERE N.X=1 AND N.I='+
                                  frmStemmaMainForm.sID;
        dmGenData.Query1.Open;
        temp:=dmGenData.Query1.Fields[0].AsInteger;

        UpdateNamesPrefered( temp,lidName);
        // Modifie la date de modification
        // Modifie l'explorateur si affiché
        if frmStemmaMainForm.mniExplorateur.Checked then
           frmExplorer.UpdatePreferedMark(temp,lidName);

        //frmExplorer.Index.Repaint;
        dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
        frmExplorer.FindIndividual;
     end;
end;

procedure TfrmNames.MenuItem3Click(Sender: TObject);  // Ajouter
begin
//     dmGenData.PutCode('A',0);
  frmEditName.EditType:=eNET_NewUnrelated;
     if frmEditName.Showmodal = mrOK then
        begin
         PopulateNom(Sender);
     end;
end;

procedure TfrmNames.MenuItem5Click(Sender: TObject);  // Supprimer
var
  lidName: Integer;
begin
  if TableauNoms.Row>0 then
     if TableauNoms.Cells[1,TableauNoms.Row]='' then
        if Application.MessageBox(Pchar(Traduction.Items[129]+
           TableauNoms.Cells[4,TableauNoms.Row]+Traduction.Items[28]),pchar(Traduction.Items[1]),MB_YESNO)=IDYES then
           begin
           lidName:=ptrint(TableauNoms.Objects[0,TableauNoms.Row]);
           dmGenData.Query1.SQL.Text:='DELETE FROM C WHERE Y=''N'' AND N='+inttostr(lidName);
           dmGenData.Query1.ExecSQL;
           dmGenData.Query1.SQL.Text:='DELETE FROM N WHERE no='+inttostr(lidName);
           dmGenData.Query1.ExecSQL;
           if frmStemmaMainForm.mniExplorateur.Checked then
              frmExplorer.DeleteIndex(lidName);
           TableauNoms.DeleteRow(TableauNoms.Row);
           dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
        end;
end;

procedure TfrmNames.SexeDblClick(Sender: TObject);
var
  filename:string;
begin
  Case Sexe.Hint[1] of
     'M':begin
         Sexe.Hint:='F';
         filename:=resPath+'\feminin.ico';
         end;
     'F':begin
         Sexe.Hint:='?';
         filename:=resPath+'\inconnu.ico';
         end;
     '?':begin
         Sexe.Hint:='M';
         filename:=resPath+'\masculin.ico';
         end;
  end;
  frmNames.sexe.Picture.Icon.LoadFromFile(filename);
  // Enregistrer la modification
  dmGenData.Query1.SQL.Text:='UPDATE I SET S='''+Sexe.Hint+''' WHERE no='+
                            frmStemmaMainForm.sID;
  dmGenData.Query1.ExecSQL;
  dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
end;

procedure TfrmNames.TableauNomsDblClick(Sender: TObject);
var
  lidName: Longint;
begin
  If (TableauNoms.Row>0) and trystrtoint(TableauNoms.Cells[0, TableauNoms.Row],lidName) then
     begin
     frmEditName.EditType:=eNET_EditExisting;
     frmEditName.idName:=lidName;
     If frmEditName.Showmodal=mrOK then
          PopulateNom(Sender);


     end;
end;

procedure TfrmNames.TableauNomsDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
  if aCol=0 then
     begin
     (Sender as TStringGrid).Canvas.Font.Color := (Sender as TStringGrid).Canvas.Brush.Color;
     (Sender as TStringGrid).Canvas.TextOut(aRect.Left,aRect.Top,(Sender as TStringGrid).Cells[aCol,aRow]);
  end;
  if (((Sender as TStringGrid).Cells[1,aRow]='*') and (aCol>0)) then
     begin
//     if (Sender as TStringGrid).Row=aRow then
//        (Sender as TStringGrid).Canvas.Brush.Color := clBlue
//     else
//        (Sender as TStringGrid).Canvas.Brush.Color := clYellow;
//     (Sender as TStringGrid).Canvas.FillRect(aRect);
     (Sender as TStringGrid).Canvas.Font.Bold := true;
     (Sender as TStringGrid).Canvas.TextOut(aRect.Left+2,aRect.Top+2,(Sender as TStringGrid).Cells[aCol,aRow]);
  end;
end;

procedure TfrmNames.VivantDblClick(Sender: TObject);
var
  filename:string;
begin
  Case Vivant.Hint[1] of
     'O':begin
         Vivant.Hint:='N';
         filename:=resPath+'\mort.ico';
         end;
     'N':begin
         Vivant.Hint:='?';
         filename:=resPath+'\inconnu.ico';
         end;
     '?':begin
         Vivant.Hint:='O';
         filename:=resPath+'\vivant.ico';
         end;
  end;
  frmNames.Vivant.Picture.Icon.LoadFromFile(filename);
  // Enregistrer la modification
  dmGenData.Query1.SQL.text:='UPDATE I SET V=:living  WHERE no=:idInd';
  dmGenData.Query1.ParamByName('living').AsString:= Vivant.Hint;
  dmGenData.Query1.ParamByName('idInd').AsInteger:=frmStemmaMainForm.iID;
  dmGenData.Query1.ExecSQL;
  dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
end;

function TfrmNames.GetIdName: integer;
begin
  TryStrToInt(TableauNoms.Cells[0,TableauNoms.Row],result);
end;

procedure TfrmNames.ModifyIndividual(Sender: TObject);
begin
    PopulateNom(Sender);
end;

end.

