unit frm_TSEMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  cls_FormBase;

type

  { TfrmTSEMain }

  TfrmTSEMain = class(TMyForm)
    btnOK: TBitBtn;
    procedure btnOKClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmTSEMain: TfrmTSEMain;

implementation

{$R *.lfm}

{ TfrmTSEMain }

procedure TfrmTSEMain.btnOKClick(Sender: TObject);
begin
  close;
end;

end.

