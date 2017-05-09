unit frm_History;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  FMUtils;

type

  { TfrmHistory }

  TfrmHistory = class(TForm)
    ListeHistorique: TListBox;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDblClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmHistory: TfrmHistory;

implementation

uses
  frm_Main,cls_Translation, dm_GenData;

{$R *.lfm}

{ TfrmHistory }

procedure TfrmHistory.FormResize(Sender: TObject);
begin
  ListeHistorique.Width:=frmHistory.Width;
  ListeHistorique.Height:=frmHistory.Height;
end;

procedure TfrmHistory.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  SaveFormPosition(Sender as TForm);
end;

procedure TfrmHistory.FormDblClick(Sender: TObject);
var
  no:string;
begin
  frmStemmaMainForm.iID:=PtrInt(ListeHistorique.Items.Objects[ListeHistorique.ItemIndex]);
  frmHistory.Close;
  frmHistory.ModalResult:=mrOk;
end;

procedure TfrmHistory.FormKeyPress(Sender: TObject; var Key: char);
begin
   If (Key=chr(27)) then
      begin
      frmHistory.Close;
      frmHistory.ModalResult:=mrAbort;
   end;
end;

procedure TfrmHistory.FormShow(Sender: TObject);
var
  i:integer;
begin
  Caption:=Translation.Items[206];
  GetFormPosition(Sender as TForm,0,0,70,1000);
  for i:=0 to frmStemmaMainForm.OldIndividu.Items.Count-1 do
    ListeHistorique.AddItem(dmGenData.GetIndividuumName(ptrint(frmStemmaMainForm.OldIndividu.Items.Objects[i])),frmStemmaMainForm.OldIndividu.Items.Objects[i]);
end;

end.

