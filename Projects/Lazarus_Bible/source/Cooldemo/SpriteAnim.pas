unit SpriteAnim;

{ Portables Sprite-Animations-Steuerelement (Ersatz fuer
  BGRASpriteAnimation aus BGRAControls).

  Zeigt die Frames eines horizontalen Bitmap-Streifens (SpriteCount Frames
  nebeneinander) und wechselt sie per TTimer. Wird zur Laufzeit erzeugt. }

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, Graphics, Controls, ExtCtrls;

type
  { TSpriteAnimation }
  TSpriteAnimation = class(TCustomControl)
  private
    FSprite: TBitmap;
    FSpriteCount: Integer;
    FAnimStatic: Boolean;
    FAnimSpeed: Integer;
    FFrame: Integer;
    FTimer: TTimer;
    procedure SetSprite(const AValue: TBitmap);
    procedure SetSpriteCount(const AValue: Integer);
    procedure SetAnimStatic(const AValue: Boolean);
    procedure SetAnimSpeed(const AValue: Integer);
    procedure TimerTick(Sender: TObject);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Frame: Integer read FFrame;
  published
    property Sprite: TBitmap read FSprite write SetSprite;
    property SpriteCount: Integer read FSpriteCount write SetSpriteCount
      default 1;
    property AnimStatic: Boolean read FAnimStatic write SetAnimStatic
      default False;
    property AnimSpeed: Integer read FAnimSpeed write SetAnimSpeed default 100;
    property Align;
    property Anchors;
    property Color;
    property ParentColor;
    property Visible;
    property OnClick;
  end;

implementation

constructor TSpriteAnimation.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSprite := TBitmap.Create;
  FSpriteCount := 1;
  FAnimSpeed := 100;
  Color := clBtnFace;
  Width := 68;
  Height := 40;
  FTimer := TTimer.Create(Self);
  FTimer.Interval := FAnimSpeed;
  FTimer.Enabled := True;
  FTimer.OnTimer := TimerTick;
end;

destructor TSpriteAnimation.Destroy;
begin
  FreeAndNil(FTimer);
  FreeAndNil(FSprite);
  inherited Destroy;
end;

procedure TSpriteAnimation.SetSprite(const AValue: TBitmap);
begin
  FSprite.Assign(AValue);
  FFrame := 0;
  Invalidate;
end;

procedure TSpriteAnimation.SetSpriteCount(const AValue: Integer);
begin
  if AValue < 1 then
    FSpriteCount := 1
  else
    FSpriteCount := AValue;
  FFrame := 0;
  Invalidate;
end;

procedure TSpriteAnimation.SetAnimStatic(const AValue: Boolean);
begin
  FAnimStatic := AValue;
  FTimer.Enabled := not AValue;
end;

procedure TSpriteAnimation.SetAnimSpeed(const AValue: Integer);
begin
  if AValue < 10 then
    FAnimSpeed := 10
  else
    FAnimSpeed := AValue;
  FTimer.Interval := FAnimSpeed;
end;

procedure TSpriteAnimation.TimerTick(Sender: TObject);
begin
  if FAnimStatic or (FSpriteCount <= 1) or FSprite.Empty then
    Exit;
  Inc(FFrame);
  if FFrame >= FSpriteCount then
    FFrame := 0;
  Invalidate;
end;

procedure TSpriteAnimation.Paint;
var
  FrameW: Integer;
  Src, Dst: TRect;
begin
  inherited Paint;
  Canvas.Brush.Color := Color;
  Canvas.Brush.Style := bsSolid;
  Canvas.FillRect(ClientRect);
  if FSprite.Empty or (FSpriteCount < 1) then
    Exit;
  FrameW := FSprite.Width div FSpriteCount;
  if FrameW <= 0 then
    Exit;
  Src := Rect(FFrame * FrameW, 0, (FFrame + 1) * FrameW, FSprite.Height);
  Dst := ClientRect;
  Canvas.CopyRect(Dst, FSprite.Canvas, Src);
end;

end.
