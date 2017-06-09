unit frm_PicPas2Po;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons;

type

  { TfrmPicPas2PoMain }

  TfrmPicPas2PoMain = class(TForm)
    cbxSelectFile: TComboBox;
    edtSourceDir: TLabeledEdit;
    edtPasFile: TMemo;
    Memo2: TMemo;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    btnSelectDir: TSpeedButton;
    procedure btnSelectDirClick(Sender: TObject);
    procedure edtSourceDirChange(Sender: TObject);
    procedure UpdateCombobox(Sender: TObject);
  private
    FChanged :Boolean;

  public

  end;

var
  frmPicPas2PoMain: TfrmPicPas2PoMain;

implementation

{$R *.lfm}

{ TfrmPicPas2PoMain }

procedure TfrmPicPas2PoMain.btnSelectDirClick(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
    begin
      edtSourceDir.Text:= SelectDirectoryDialog1.FileName;
    end;
end;

procedure TfrmPicPas2PoMain.edtSourceDirChange(Sender: TObject);
begin
  if ActiveControl=edtSourceDir then
    FPChanged := true;
  else
    UpdateCombobox(Sender);
end;

end.

