unit frm_XMLDoc2po;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, fra_PoFile;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnProcessPas2Po: TBitBtn;
    btnProcessPo2Pas: TSpeedButton;
    btnSelectDir: TSpeedButton;
    edtSourceDir: TLabeledEdit;
    fraPoFile1: TfraPoFile;
    Panel1: TPanel;
    pnlProcessing: TPanel;
    pnlTop: TPanel;
    pnlTopRight: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  fraPoFile1.BaseDir := edtSourceDir.Text;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
    lWidth := (ClientWidth - 30) div 2;
    fraPoFile1.Width := lWidth;
    pnlleft.Width := lWidth;
end;

end.

