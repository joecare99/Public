unit frmSelectReadonlyEdit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TFrmSelectROEditMain }

  TFrmSelectROEditMain = class(TForm)
    Edit1: TEdit;
    LabeledEdit1: TLabeledEdit;
    Memo1: TMemo;
    procedure LabeledEdit1Change(Sender: TObject);
    procedure LabeledEdit1KeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FrmSelectROEditMain: TFrmSelectROEditMain;

implementation

{$R *.lfm}

{ TFrmSelectROEditMain }

procedure TFrmSelectROEditMain.LabeledEdit1Change(Sender: TObject);
begin
  LabeledEdit1.text := 'Fixed Text1';
end;

procedure TFrmSelectROEditMain.LabeledEdit1KeyPress(Sender: TObject; var Key: char);
begin
  if Key = #24 then
    Key := #3;
  if Key <> #3 then
   Key := #0;
end;

end.

