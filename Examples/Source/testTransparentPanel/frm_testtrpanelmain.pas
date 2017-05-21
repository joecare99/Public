unit frm_TestTrPanelMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls, BGRAPanel, BCPanel, BGRASpriteAnimation, BGRAImageList,
  BGRAFlashProgressBar, cmp_transparentpanel,unit1;

type

  { TFrmTrPanelMain }

  TFrmTrPanelMain = class(TForm)
    BCPanel1: TBCPanel;
    BGRAFlashProgressBar1: TBGRAFlashProgressBar;
    BGRAPanel1: TBGRAPanel;
    BGRASpriteAnimation1: TBGRASpriteAnimation;
    BitBtn1: TBitBtn;
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Memo1: TMemo;
    Panel1: TPanel;
    ScrollBar1: TScrollBar;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    TransparentPanel1: TTransparentPanel;
    procedure BGRASpriteAnimation1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FrmTrPanelMain: TFrmTrPanelMain;

implementation

{$R *.lfm}

{ TFrmTrPanelMain }

procedure TFrmTrPanelMain.ScrollBar1Change(Sender: TObject);
begin
  TransparentPanel1.Left:=ScrollBar1.Position;
end;

procedure TFrmTrPanelMain.Panel1Click(Sender: TObject);
begin

end;

procedure TFrmTrPanelMain.CheckBox1Change(Sender: TObject);
begin
  TransparentPanel1.Visible:=CheckBox1.Checked;
end;

procedure TFrmTrPanelMain.CheckBox2Change(Sender: TObject);
begin
  TransparentPanel1.NoBGR:=CheckBox2.Checked;
end;

procedure TFrmTrPanelMain.BGRASpriteAnimation1Click(Sender: TObject);
begin

end;

procedure TFrmTrPanelMain.Button1Click(Sender: TObject);
begin
  form1.Show;
end;

end.

