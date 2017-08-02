unit frm_Images;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TFormImage }

  TFormImage = class(TForm)
    Im: TImage;
    procedure FormClose(Sender: TObject; var {%H-}CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

procedure PopulateImage(no:integer);

var
  FormImage: TFormImage;

implementation

uses
  frm_Main, cls_Translation, dm_GenData, frm_Documents;

{$R *.lfm}

{ TFormImage }

procedure PopulateImage(no:integer);
var
  lFilename: String;
begin
  lFilename:=dmGenData.GetDocumentFilename(no,frmStemmaMainForm.iID);
  if lFilename <> '' then
     begin
     if (length(lFilename)>0) and
        not (AnsiPos('.PDF',lFilename)>0) and FileExists(lFilename) then
       begin
       FormImage.Im.Picture.LoadFromFile(lFilename);
       if no=0 then
         FormImage.Caption:=Translation.Items[117]
       else
         FormImage.Caption:=Translation.Items[118];
     end;
  end
  else
     FormImage.Im.Picture.Clear;
end;

procedure TFormImage.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  dmGenData.WriteCfgFormPosition(self);
end;

procedure TFormImage.FormResize(Sender: TObject);
begin
  Im.Width:=FormImage.Width;
  Im.Height:=FormImage.Height;
end;

procedure TFormImage.FormShow(Sender: TObject);
begin
  Caption:=Translation.Items[117];
  dmGenData.ReadCfgFormPosition(Sender as TForm,100,100,200,200);
  if frmStemmaMainForm.actWinDocuments.Checked then
    if frmDocuments.tblDocuments.Cells[1,frmDocuments.tblDocuments.Row]='*' then
       PopulateImage(0)
    else
       if frmDocuments.tblDocuments.RowCount>1 then
          PopulateImage(StrToInt(frmDocuments.tblDocuments.Cells[0,frmDocuments.tblDocuments.Row]))
       else
          PopulateImage(0)
  else
     PopulateImage(0);
end;

end.

