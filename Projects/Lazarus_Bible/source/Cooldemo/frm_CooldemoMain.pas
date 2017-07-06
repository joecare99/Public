unit frm_CooldemoMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  XPMan, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, StdCtrls, Buttons, ImgList, ExtCtrls, System.ImageList
      {$IFDEF FPC}, BGRASpriteAnimation{$endif};

type

  { TMainForm }

  TMainForm = class(TForm)
    {$IFDEF FPC}
    Animate1: TBGRASpriteAnimation;
    Image1: TImage;
    Panel1: TPanel;
    {$ELSE}
    Animate1: TAnimate;
    DateTimePicker1: TDateTimePicker;
    XPManifest1: TXPManifest;
    {$ENDIF}
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    NavigatorImages: TImageList;
    NavigatorHotImages: TImageList;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Button1: TButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  uses BGRAAnimatedGif,BGRABitmapTypes,BGRABitmap;
  {$R *.lfm}
{$ENDIF}

resourcestring
  SBacknForwardBtn_ED = '%s Back and Forward Buttons';
  SBeginAnimation = 'Begin Animation';
  SButtonSelectedS = 'Button selected: %s';
  SDisable = 'Disable';
  SEnable = 'Enable';
  SStopAnimation = 'Stop Animation';

procedure TMainForm.BitBtn1Click(Sender: TObject);
var
  TF: Boolean;  // True or False flag
  S: String;
begin
  TF := ToolButton1.Enabled;
  ToolButton1.Enabled := not TF;
  ToolButton2.Enabled := not TF;
  if TF
    then S := SEnable
    else S := SDisable;
  BitBtn1.Caption := format(SBacknForwardBtn_ED, [s]);
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  {$IFNDEF FPC}
  Animate1.Active := not Animate1.Active;
  if Animate1.Active
    {$ELSE}
    Animate1.AnimStatic := not Animate1.AnimStatic;
    if not Animate1.AnimStatic
    {$ENDIF}
    then Button1.Caption := SStopAnimation
    else Button1.Caption := SBeginAnimation;
end;

procedure TMainForm.FormCreate(Sender: TObject);
 {$IFDEF FPC}
  var
   TempGif: TBGRAAnimatedGif;
   TempBitmap: TBitmap;
   n: integer;
    {$ENDIF}

 begin
 {$IFDEF FPC}
   TempGif := TBGRAAnimatedGif.Create;
   try
   TempGif.LoadFromResourceName(HINSTANCE,'COOL');
   TempBitmap := TBitmap.Create;
   TempBitmap.Width:=TempGif.Width * TempGif.Count;
   TempBitmap.Height:=TempGif.Height;
   TempBitmap.PixelFormat:=pf32bit;

   for n := 0 to TempGif.Count do
   begin
     TempGif.CurrentImage := n;
     TempBitmap.Canvas.Draw(TempGif.Width * n, 0, TempGif.Bitmap);
   end;

   Animate1.Sprite.Assign(TempBitmap);
   Animate1.SpriteCount := TempGif.Count;

   finally

     freeandnil(TempGif);
     freeandnil(TempBitmap);
   end;
   Image1.Picture.Bitmap.Assign(CoolBar1.Bitmap);
   ToolBar1.ControlStyle:=ToolBar1.ControlStyle-[csOpaque]+[csParentBackground];
    {$ENDIF}
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  {$IFNDEF FPC}
  Animate1.Active :=true;
  {$ENDIF}
end;

procedure TMainForm.ToolButton1Click(Sender: TObject);
begin
  with Sender as TToolButton do
    ShowMessage(format(SButtonSelectedS, [Caption]));
end;

end.
