unit frm_TestTrPanelMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls,   BGRASpriteAnimation,
   BGRABitmap, cmp_transparentpanel,unit1;

type

  { TFrmTrPanelMain }

  TFrmTrPanelMain = class(TForm)
    BGRASpriteAnimation1: TBGRASpriteAnimation;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Image1: TImage;
    Memo1: TMemo;
    Panel1: TPanel;
    PaintBox1: TPanel;
    ScrollBar1: TScrollBar;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    TransparentPanel1: TTransparentPanel;
    procedure BGRASpriteAnimation1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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

uses BGRAAnimatedGif,BGRAGraphics,BGRABitmapTypes;
{$R *.lfm}

{ TFrmTrPanelMain }

procedure TFrmTrPanelMain.ScrollBar1Change(Sender: TObject);
begin
  TransparentPanel1.Left:=ScrollBar1.Position*2;
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

procedure TFrmTrPanelMain.FormCreate(Sender: TObject);
  var
  TempGif: TBGRAAnimatedGif;
  TempBitmap: TBGRABitmap;
  n: integer;

begin
  TempGif := TBGRAAnimatedGif.Create;
  if FileExists('..\..\glyphs\logo.gif') then
  try
//  TempGif.LoadFromResourceName(self.Handle,'LOGO');
  TempGif.LoadFromFile('..\..\glyphs\logo.gif');
  TempBitmap := TBGRABitmap.Create(TempGif.Width * TempGif.Count, TempGif.Height);

  for n := 0 to TempGif.Count do
  begin
    TempGif.CurrentImage := n;
    TempBitmap.CanvasBGRA.Draw(TempGif.Width * n, 0, TempGif.MemBitmap);
  end;

  BGRASpriteAnimation1.Sprite := TempBitmap.Bitmap;
  BGRASpriteAnimation1.SpriteCount := TempGif.Count;

  finally

    freeandnil(TempGif);
  end;
end;

procedure TFrmTrPanelMain.BGRASpriteAnimation1Click(Sender: TObject);
begin

end;

procedure TFrmTrPanelMain.BitBtn2Click(Sender: TObject);
var
  TempBitmap: TBGRABitmap;
begin
  TempBitmap := TBGRABitmap.Create(TransparentPanel1.getBuffer);
  try
  //TransparentPanel1.Visible:=false;
  //Application.ProcessMessages;
  //TempBitmap.takeScreenshot(RectWithSize(left+ClientRect.left,top+ClientRect.Top,width,height));
  //TransparentPanel1.Visible:=CheckBox1.Checked;
  TempBitmap.CanvasBGRA.Brush.Color:=clBlack;
  TempBitmap.CanvasBGRA.Brush.Opacity:=70;
  TempBitmap.CanvasBGRA.FillRect(BoundsRect);
  TransparentPanel1.getBuffer.Canvas.Draw(0,0, TempBitmap.FilterBlurRadial(5.0,rbFast).Bitmap) ;
  finally
    freeandnil(TempBitmap)
  end;
  TransparentPanel1.Invalidate;
end;

procedure TFrmTrPanelMain.BitBtn3Click(Sender: TObject);
begin
  PaintBox1.Canvas.CopyRect(PaintBox1.ReadBounds,self.Canvas,self.ReadBounds);
end;

procedure TFrmTrPanelMain.BitBtn4Click(Sender: TObject);
begin
  with PaintBox1.Canvas do
    begin
      brush.Color := clMaroon;
      FillRect(rect(0, 0, Width, Height));
    end;
end;

procedure TFrmTrPanelMain.Button1Click(Sender: TObject);
begin
  form1.Show;
end;

end.

