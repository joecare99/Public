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
  ComCtrls, ToolWin, StdCtrls, Buttons, ImgList, ExtCtrls
      {$IFDEF FPC}, SpriteAnim{$ELSE} {$endif};

type

  { TMainForm }

  TfrmCoolDemoMain = class(TForm)
    {$IFDEF FPC}
    Animate1: TSpriteAnimation;
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
{$IFDEF FPC}
    function BuildSprite: TBitmap;
{$ENDIF}
  public
    { Public declarations }
  end;

var
  frmCoolDemoMain: TfrmCoolDemoMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{$IFDEF FPC}
{ Baut einen horizontalen Sprite-Streifen (8 Frames) prozedural. }
function TfrmCoolDemoMain.BuildSprite: TBitmap;
const
  Frames = 8;
  Cell = 16;
var
  I: Integer;
begin
  Result := TBitmap.Create;
  Result.Width := Frames * Cell;
  Result.Height := Cell;
  Result.Canvas.Brush.Color := clBlack;
  Result.Canvas.FillRect(0, 0, Result.Width, Result.Height);
  for I := 0 to Frames - 1 do
  begin
    case I mod 4 of
      0: Result.Canvas.Brush.Color := clRed;
      1: Result.Canvas.Brush.Color := clLime;
      2: Result.Canvas.Brush.Color := clBlue;
    else
      Result.Canvas.Brush.Color := clYellow;
    end;
    Result.Canvas.Ellipse(I * Cell + 3, 3, I * Cell + Cell - 3, Cell - 3);
  end;
end;
{$ENDIF}

resourcestring
  SBacknForwardBtn_ED = '%s Back and Forward Buttons';
  SBeginAnimation = 'Begin Animation';
  SButtonSelectedS = 'Button selected: %s';
  SDisable = 'Disable';
  SEnable = 'Enable';
  SStopAnimation = 'Stop Animation';

procedure TfrmCoolDemoMain.BitBtn1Click(Sender: TObject);
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

procedure TfrmCoolDemoMain.Button1Click(Sender: TObject);
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

procedure TfrmCoolDemoMain.FormCreate(Sender: TObject);
begin
 {$IFDEF FPC}
   { Animate1 zur Laufzeit erzeugen (BGRASpriteAnimation ist nicht
     verfuegbar); die Animation wird prozedural erzeugt. }
   Animate1 := TSpriteAnimation.Create(Self);
   Animate1.Parent := Panel1;
   Animate1.Align := alClient;
   Animate1.Sprite := BuildSprite;
   Animate1.SpriteCount := 8;
   Animate1.AnimSpeed := 120;
   Image1.Picture.Bitmap.Assign(CoolBar1.Bitmap);
   ToolBar1.ControlStyle:=ToolBar1.ControlStyle-[csOpaque]+[csParentBackground];
 {$ENDIF}
end;

procedure TfrmCoolDemoMain.FormShow(Sender: TObject);
begin
  {$IFNDEF FPC}
  Animate1.Active :=true;
  {$ENDIF}
end;

procedure TfrmCoolDemoMain.ToolButton1Click(Sender: TObject);
begin
  with Sender as TToolButton do
    ShowMessage(format(SButtonSelectedS, [Caption]));
end;

end.
