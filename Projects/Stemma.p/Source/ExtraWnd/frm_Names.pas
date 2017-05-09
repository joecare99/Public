unit frm_Names;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls, ExtCtrls, Spin, Menus, FMUtils, frm_EditName, LCLType;

type

  { TfrmNames }

  TfrmNames = class(TForm)
    lblLastModification: TLabel;
    mnuSetPrimary: TMenuItem;
    mnuSeparator: TMenuItem;
    mnuAdd: TMenuItem;
    mnuModify: TMenuItem;
    mnuDelete: TMenuItem;
    lblModificationDate: TLabel;
    PopupMenuEnfant: TPopupMenu;
    imgSex: TImage;
    edtInterest: TSpinEdit;
    imgLiving: TImage;
    grdNames: TStringGrid;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtInterestChange(Sender: TObject);
    procedure mnuSetPrimaryClick(Sender: TObject);
    procedure mnuAddClick(Sender: TObject);
    procedure mnuDeleteClick(Sender: TObject);
    procedure imgSexDblClick(Sender: TObject);
    procedure grdNamesDblClick(Sender: TObject);
    procedure grdNamesDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure imgLivingDblClick(Sender: TObject);
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
  frm_Main,cls_Translation, dm_GenData, frm_Explorer;

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
     SaveGridPosition(grdNames as TStringGrid,5);
end;

procedure TfrmNames.FormResize(Sender: TObject);
begin
  grdNames.Width := (Sender as Tform).Width-17;
  grdNames.Height := (Sender as Tform).Height-41;
  grdNames.Columns[3].Width := (Sender as Tform).Width-207;
  imgSex.Top := (Sender as Tform).Height-32;
  imgLiving.Top := (Sender as Tform).Height-32;
  edtInterest.Top := (Sender as Tform).Height-29;
  lblLastModification.Top := (Sender as Tform).Height-25;
  lblModificationDate.Top := (Sender as Tform).Height-25;
end;

procedure TfrmNames.PopulateNom(Sender: TObject);
var
  filename, sSex, sLiving, sDate, sTypeName:string;
  iInterest, lidInd: LongInt;
begin
  lidInd:= frmStemmaMainForm.iID;
  dmGenData.PopulateNameTable(lidInd,grdNames);

  if dmGenData.GetDataOfInd(frmStemmaMainForm.iID,sSex,sLiving,sDate,iInterest) then
  begin
  If sSex[1]='M' then
     filename:=resPath+'\masculin.ico'
  else
     If sSex[1]='F' then
        filename:=resPath+'\feminin.ico'
     else
        filename:=resPath+'\inconnu.ico';
   imgSex.hint:=sSex;
   imgSex.Picture.Icon.LoadFromFile(filename);

   imgLiving.Hint:=sLiving;
  If  imgLiving.Hint[1]='O' then
     filename:=resPath+'\vivant.ico'
  else If  imgLiving.Hint[1]='N' then
     filename:=resPath+'\mort.ico'
  else
     filename:=resPath+'\inconnu.ico';
   imgLiving.Picture.Icon.LoadFromFile(filename);
   edtInterest.Value := iInterest;
   lblModificationDate.Caption:=ConvertDate('1'+sDate+'030000000000',1);
   Caption:=Translation.Items[126]+' ('+IntToStr( grdNames.RowCount-1)+
     Translation.Items[127];

  end;
end;

procedure TfrmNames.FormShow(Sender: TObject);
begin
  Caption:=Translation.Items[214];
  grdNames.Cells[2,0]:=Translation.Items[185];
  grdNames.Cells[3,0]:=Translation.Items[136];
  grdNames.Cells[4,0]:=Translation.Items[176];
  grdNames.Cells[5,0]:=Translation.Items[177];
  lblLastModification.Caption:=Translation.Items[215];
  mnuSetPrimary.Caption:=Translation.Items[234];
  mnuAdd.Caption:=Translation.Items[224];
  mnuModify.Caption:=Translation.Items[225];
  mnuDelete.Caption:=Translation.Items[226];
  GetFormPosition(Sender as TForm,0,0,70,1000);
  GetGridPosition(grdNames as TStringGrid,5);
  dmGenData.OnModifyIndividual:=@ModifyIndividual;
  PopulateNom(Sender);
end;

procedure TfrmNames.edtInterestChange(Sender: TObject);
begin
  // Enregistrer la modification
  dmGenData.Query1.SQL.Clear;
  dmGenData.Query1.SQL.Add('UPDATE I SET I='+InttoStr(edtInterest.Value)+' WHERE no='+
                            frmStemmaMainForm.sID);
  dmGenData.Query1.ExecSQL;
  dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
end;

procedure TfrmNames.mnuSetPrimaryClick(Sender: TObject);
var
  temp:integer;
  lidName: Integer;
begin
     If grdNames.Cells[1,grdNames.row]='*' then
        ShowMessage(Translation.Items[128])
     else
        begin
        lidName:=ptrint(grdNames.Objects[0,grdNames.row]);

        // Get idName of prefered name
        dmGenData.Query1.SQL.Text:='SELECT no FROM N WHERE N.X=1 AND N.I='+
                                  frmStemmaMainForm.sID;
        dmGenData.Query1.Open;
        temp:=dmGenData.Query1.Fields[0].AsInteger;

        UpdateNamesPrefered( temp,lidName);
        // lblModificationDate la date de modification
        // lblModificationDate l'explorateur si affiché
        if frmStemmaMainForm.mniExplorateur.Checked then
           frmExplorer.UpdatePreferedMark(temp,lidName);

        //frmExplorer.Index.Repaint;
        dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
        frmExplorer.FindIndividual;
     end;
end;

procedure TfrmNames.mnuAddClick(Sender: TObject);  // Ajouter
begin
//     dmGenData.PutCode('A',0);
  frmEditName.EditType:=eNET_NewUnrelated;
     if frmEditName.Showmodal = mrOK then
        begin
         PopulateNom(Sender);
     end;
end;

procedure TfrmNames.mnuDeleteClick(Sender: TObject);  // Supprimer
var
  lidName: Integer;
begin
  if grdNames.Row>0 then
     if grdNames.Cells[1,grdNames.Row]='' then
        if Application.MessageBox(Pchar(Translation.Items[129]+
           grdNames.Cells[4,grdNames.Row]+Translation.Items[28]),pchar(Translation.Items[1]),MB_YESNO)=IDYES then
           begin
           lidName:=ptrint(grdNames.Objects[0,grdNames.Row]);
           dmGenData.Query1.SQL.Text:='DELETE FROM C WHERE Y=''N'' AND N='+inttostr(lidName);
           dmGenData.Query1.ExecSQL;
           dmGenData.Query1.SQL.Text:='DELETE FROM N WHERE no='+inttostr(lidName);
           dmGenData.Query1.ExecSQL;
           if frmStemmaMainForm.mniExplorateur.Checked then
              frmExplorer.DeleteIndex(lidName);
           grdNames.DeleteRow(grdNames.Row);
           dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
        end;
end;

procedure TfrmNames.imgSexDblClick(Sender: TObject);
var
  filename:string;
begin
  Case imgSex.Hint[1] of
     'M':begin
         imgSex.Hint:='F';
         filename:=resPath+'\feminin.ico';
         end;
     'F':begin
         imgSex.Hint:='?';
         filename:=resPath+'\inconnu.ico';
         end;
     '?':begin
         imgSex.Hint:='M';
         filename:=resPath+'\masculin.ico';
         end;
  end;
  imgSex.Picture.Icon.LoadFromFile(filename);
  // Enregistrer la modification
  dmGenData.Query1.SQL.Text:='UPDATE I SET S='''+imgSex.Hint+''' WHERE no='+
                            frmStemmaMainForm.sID;
  dmGenData.Query1.ExecSQL;
  dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
end;

procedure TfrmNames.grdNamesDblClick(Sender: TObject);
var
  lidName: Longint;
begin
  If (grdNames.Row>0) and trystrtoint(grdNames.Cells[0, grdNames.Row],lidName) then
     begin
     frmEditName.EditType:=eNET_EditExisting;
     frmEditName.idName:=lidName;
     If frmEditName.Showmodal=mrOK then
          PopulateNom(Sender);


     end;
end;

procedure TfrmNames.grdNamesDrawCell(Sender: TObject; aCol, aRow: Integer;
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

procedure TfrmNames.imgLivingDblClick(Sender: TObject);
var
  filename:string;
begin
  Case imgLiving.Hint[1] of
     'O':begin
         imgLiving.Hint:='N';
         filename:=resPath+'\mort.ico';
         end;
     'N':begin
         imgLiving.Hint:='?';
         filename:=resPath+'\inconnu.ico';
         end;
     '?':begin
         imgLiving.Hint:='O';
         filename:=resPath+'\vivant.ico';
         end;
  end;
  imgLiving.Picture.Icon.LoadFromFile(filename);
  // Enregistrer la modification
  dmGenData.Query1.SQL.text:='UPDATE I SET V=:living  WHERE no=:idInd';
  dmGenData.Query1.ParamByName('living').AsString:= imgLiving.Hint;
  dmGenData.Query1.ParamByName('idInd').AsInteger:=frmStemmaMainForm.iID;
  dmGenData.Query1.ExecSQL;
  dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
end;

function TfrmNames.GetIdName: integer;
begin
   result := ptrint(grdNames.Objects[0, grdNames.Row]);
end;

procedure TfrmNames.ModifyIndividual(Sender: TObject);
begin
    PopulateNom(Sender);
end;


end.

