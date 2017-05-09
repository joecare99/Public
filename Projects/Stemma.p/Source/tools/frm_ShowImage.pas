unit frm_ShowImage;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Menus, Buttons;

type

  { TfrmShowImage }

  TfrmShowImage = class(TForm)
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    Image: TImage;
    MainMenu1: TMainMenu;
    Memo: TMemo;
    mniQuit: TMenuItem;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mniQuitClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmShowImage: TfrmShowImage;

implementation

uses
  cls_Translation;

{$R *.lfm}

{ TfrmShowImage }

procedure TfrmShowImage.FormResize(Sender: TObject);
begin
  Image.Width:=frmShowImage.Width;
  Image.Height:=frmShowImage.Height;
  Memo.Width:=frmShowImage.Width-16;
  Memo.Height:=frmShowImage.Height-76;
  btnOK.Top:=frmShowImage.Height-54;
  btnOK.Left:=frmShowImage.Width-160;
  btnCancel.Top:=frmShowImage.Height-54;
  btnCancel.Left:=frmShowImage.Width-83;
end;

procedure TfrmShowImage.FormShow(Sender: TObject);
begin
  mniQuit.Caption:=Translation.Items[256];
  Caption:=Translation.Items[217];
  btnOK.Caption:=Translation.Items[152];
  btnCancel.Caption:=Translation.Items[164];
end;

procedure TfrmShowImage.mniQuitClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;


end.

