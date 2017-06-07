unit Frm_TxtEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFrmTxtEdit = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    CheckBox1: TCheckBox;
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmTxtEdit: TFrmTxtEdit;

implementation

{$R *.dfm}

procedure TFrmTxtEdit.CheckBox1Click(Sender: TObject);
begin
  if TCheckBox(sender).Checked then
    memo1.ScrollBars := ssVertical
  else
    memo1.ScrollBars := ssBoth;
end;

end.
