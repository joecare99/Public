unit frm_Images;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  FMUtils;

type

  { TFormImage }

  TFormImage = class(TForm)
    Im: TImage;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
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
  frm_Main, Traduction, dm_GenData, frm_Documents;

{$R *.lfm}

{ TFormImage }

procedure PopulateImage(no:integer);
begin
  dmGenData.Query2.SQL.Clear;
  if no=0 then
    dmGenData.Query2.SQL.add('SELECT X.F FROM X WHERE X.A=''I'' AND X.X=1 AND X.N='+
                               frmStemmaMainForm.sID)
  else
    dmGenData.Query2.SQL.add('SELECT X.F FROM X WHERE X.no='+inttostr(no));
  dmGenData.Query2.Open;
  dmGenData.Query2.First;
  if not dmGenData.Query2.EOF then
     begin
     if (length(dmGenData.Query2.Fields[0].AsString)>0) and
        not (AnsiPos('.PDF',dmGenData.Query2.Fields[0].AsString)>0) then
       begin
       FormImage.Im.Picture.LoadFromFile(dmGenData.Query2.Fields[0].AsString);
       if no=0 then
          FormImage.Caption:=Traduction.Items[117]
       else
         FormImage.Caption:=Traduction.Items[118];
     end;
  end
  else
     FormImage.Im.Picture.Clear;
end;

procedure TFormImage.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  SaveFormPosition(Sender as TForm);
end;

procedure TFormImage.FormResize(Sender: TObject);
begin
  Im.Width:=FormImage.Width;
  Im.Height:=FormImage.Height;
end;

procedure TFormImage.FormShow(Sender: TObject);
begin
  Caption:=Traduction.Items[117];
  GetFormPosition(Sender as TForm,100,100,200,200);
  if frmStemmaMainForm.mniExhibits.Checked then
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

