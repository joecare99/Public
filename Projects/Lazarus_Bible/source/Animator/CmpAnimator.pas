unit cmpAnimator;

{ Portables Animations-Steuerelement fuer die LCL.

  Das Original (Windows) kapselte das Win32-ANIMATE-Steuerelement, das
  Common-AVI-Filme abspielt. Unter FPC/LCL gibt es das nicht; hier wird
  eine einfache, prozedural gezeichnete Animation (rotierender Zeiger)
  gezeigt, deren Farbe vom gewaehlten "CommonAVI" abhaengt. Die
  Schnittstelle (CommonAVI, Play, Stop, FrameCount) bleibt gleich. }

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, Graphics, Controls, ExtCtrls, Math;

type
  TCommonAVI = (aviNone, aviFindFolder, aviFindFile, aviFindComputer,
    aviCopyFiles, aviCopyFile, aviRecycleFile, aviEmptyRecycle, aviDeleteFile);

  { TAnimate }
  TAnimate = class(TCustomControl)
  private
    FActive: Boolean;
    FCommonAVI: TCommonAVI;
    FFrame: Integer;
    FFrameCount: Integer;
    FRepetitions: Integer;
    FStartFrame: Smallint;
    FStopFrame: Smallint;
    FTimer: TTimer;
    FOnStart: TNotifyEvent;
    FOnStop: TNotifyEvent;
    procedure SetActive(const AValue: Boolean);
    procedure SetCommonAVI(const AValue: TCommonAVI);
    procedure SetRepetitions(const AValue: Integer);
    procedure SetStartFrame(const AValue: Smallint);
    procedure SetStopFrame(const AValue: Smallint);
    procedure TimerTick(Sender: TObject);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Startet die Animation von FromFrame bis ToFrame (Count 0 = endlos). }
    procedure Play(FromFrame, ToFrame: Word; Count: Integer);
    procedure Stop;
    procedure Reset;
    procedure Seek(Frame: Smallint);
    property FrameCount: Integer read FFrameCount;
  published
    property Active: Boolean read FActive write SetActive default False;
    property CommonAVI: TCommonAVI read FCommonAVI write SetCommonAVI
      default aviNone;
    property Repetitions: Integer read FRepetitions write SetRepetitions
      default 0;
    property StartFrame: Smallint read FStartFrame write SetStartFrame
      default 1;
    property StopFrame: Smallint read FStopFrame write SetStopFrame
      default 0;
    property OnStart: TNotifyEvent read FOnStart write FOnStart;
    property OnStop: TNotifyEvent read FOnStop write FOnStop;
    property Align;
    property Anchors;
    property Color;
    property ParentColor;
    property Visible;
  end;

implementation

constructor TAnimate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFrameCount := 12;
  FStartFrame := 1;
  FRepetitions := 0;
  Color := clBtnFace;
  Width := 120;
  Height := 90;
  FTimer := TTimer.Create(Self);
  FTimer.Interval := 100;
  FTimer.Enabled := False;
  FTimer.OnTimer := TimerTick;
end;

destructor TAnimate.Destroy;
begin
  FreeAndNil(FTimer);
  inherited Destroy;
end;

procedure TAnimate.SetActive(const AValue: Boolean);
begin
  if FActive = AValue then
    Exit;
  if AValue then
    Play(1, FFrameCount, FRepetitions)
  else
    Stop;
end;

procedure TAnimate.SetCommonAVI(const AValue: TCommonAVI);
begin
  if FCommonAVI = AValue then
    Exit;
  FCommonAVI := AValue;
  Invalidate;
end;

procedure TAnimate.SetRepetitions(const AValue: Integer);
begin
  FRepetitions := AValue;
end;

procedure TAnimate.SetStartFrame(const AValue: Smallint);
begin
  FStartFrame := AValue;
end;

procedure TAnimate.SetStopFrame(const AValue: Smallint);
begin
  FStopFrame := AValue;
end;

procedure TAnimate.TimerTick(Sender: TObject);
begin
  Inc(FFrame);
  if FFrame >= FFrameCount then
    FFrame := 0;
  Invalidate;
end;

procedure TAnimate.Play(FromFrame, ToFrame: Word; Count: Integer);
begin
  FActive := True;
  FFrame := 0;
  FTimer.Enabled := True;
  if Assigned(FOnStart) then
    FOnStart(Self);
  Invalidate;
end;

procedure TAnimate.Stop;
begin
  if not FActive and not FTimer.Enabled then
    Exit;
  FActive := False;
  FTimer.Enabled := False;
  if Assigned(FOnStop) then
    FOnStop(Self);
  Invalidate;
end;

procedure TAnimate.Reset;
begin
  Stop;
  FFrame := 0;
  Invalidate;
end;

procedure TAnimate.Seek(Frame: Smallint);
begin
  FFrame := Frame;
  Invalidate;
end;

procedure TAnimate.Paint;
var
  Cx, Cy, Rad, Ang, X, Y: Integer;
  Col: TColor;
begin
  inherited Paint;
  Canvas.Brush.Color := Color;
  Canvas.Brush.Style := bsSolid;
  Canvas.FillRect(ClientRect);

  Cx := ClientWidth div 2;
  Cy := ClientHeight div 2;
  Rad := (ClientWidth div 2) - 6;
  if ClientHeight div 2 - 6 < Rad then
    Rad := ClientHeight div 2 - 6;
  if Rad < 4 then
    Rad := 4;

  case FCommonAVI of
    aviFindFolder, aviFindFile, aviFindComputer: Col := clNavy;
    aviCopyFiles, aviCopyFile: Col := clGreen;
    aviRecycleFile, aviEmptyRecycle, aviDeleteFile: Col := clMaroon;
  else
    Col := clGray;
  end;

  Canvas.Pen.Color := Col;
  Canvas.Pen.Width := 2;
  Canvas.Brush.Style := bsClear;
  Canvas.Ellipse(Cx - Rad, Cy - Rad, Cx + Rad, Cy + Rad);

  Ang := (FFrame * (360 div FFrameCount)) mod 360;
  X := Cx + Round(Rad * Cos(DegToRad(Ang)));
  Y := Cy + Round(Rad * Sin(DegToRad(Ang)));
  Canvas.Pen.Width := 4;
  Canvas.MoveTo(Cx, Cy);
  Canvas.LineTo(X, Y);

  Canvas.Brush.Style := bsSolid;
end;

end.
