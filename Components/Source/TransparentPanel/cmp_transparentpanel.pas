unit cmp_transparentpanel;

{$mode objfpc}{$H+}

interface

uses
  Classes,  types, SysUtils,{$IFDEF FPC}  LMessages,LCLType, {$ELSE}  Messages, {$ENDIF} Forms, Controls, Graphics{$IFDEF MSWINDOWS} , Windows {$ELSE}  {$ENDIF};

type

  { TTransparentPanel }

  TTransparentPanel = class(TCustomControl)

  private
    fBuffer: Graphics.TBitmap;
    fBufferChanged: boolean;
    FNoBGR: Boolean;
    procedure SetNoBGR(AValue: Boolean);
  protected
    function getBuffer: Graphics.TBitmap; virtual;
    procedure SetColor(Value: TColor); override;
    {$IFDEF FPC}
    procedure WMWindowPosChanged(var Message: TLMWindowPosChanged);
      message LM_WINDOWPOSCHANGED;
    procedure WMEraseBkgnd(var Message: TLMEraseBkgnd); message LM_ERASEBKGND;
    {$ELSE}
    procedure WMWindowPosChanged(var Message: TLMWindowPosChanged);
      message WM_WINDOWPOSCHANGED;
    procedure WMEraseBkgnd(var Message: TLMEraseBkgnd); message WM_ERASEBKGND;
    {$ENDIF}
    procedure CreateParams(var Params: TCreateParams);override;
    procedure Paint; override;
    procedure Resize; override;
    procedure redrawBackgroundBuffer(var buffer: Graphics.TBitmap); virtual;
    function getBufferChanged: boolean; virtual;
    procedure setBufferChanged(val: boolean); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Invalidate; override;
  published
    property NoBGR:Boolean read FNoBGR write SetNoBGR;
    property OnPaint;
    property Color;
    property Align;
    property Height;
    property Cursor;
    property HelpContext;
    property HelpType;
    property Hint;
    property Left;
    property Name;
    property Tag;
    property Top;
    property Width;
    property Anchors;
    property Constraints;
  end;

procedure Register;

implementation

procedure Register;

begin
  RegisterComponents('Standard', [TTransparentPanel]);
end;

{ TTransparentPanel }

procedure TTransparentPanel.SetColor(Value: TColor);

begin
  inherited SetColor(Value);
  RecreateWnd(Self);
end;

procedure TTransparentPanel.SetNoBGR(AValue: Boolean);
begin
  if FNoBGR=AValue then Exit;
  FNoBGR:=AValue;
end;

function TTransparentPanel.getBuffer: Graphics.TBitmap;

begin
  Result := fBuffer;
end;

procedure TTransparentPanel.WMWindowPosChanged(var Message: TLMWindowPosChanged);

begin
  setBufferChanged(True);
  Invalidate;
  inherited;
end;

procedure TTransparentPanel.WMEraseBkgnd(var Message: TLMEraseBkgnd);

begin
  Message.Result := 1;
end;

procedure TTransparentPanel.CreateParams(var Params: TCreateParams);

begin
  inherited CreateParams(Params);
  {$IFDEF MSWINDOWS}
  params.exstyle := params.exstyle or WS_EX_TRANSPARENT;
  {$ELSE}
  params.exstyle := params.exstyle or WS_EX_TRANSPARENT;
  {$ENDIF}
end;

procedure TTransparentPanel.Paint;

begin
  if csDesigning in ComponentState then
    exit;
  if not FNoBgr then
    begin
  if getBufferChanged then
  begin
    redrawBackgroundBuffer(fBuffer);
    setBufferChanged(False);
  end;
  Canvas.Draw(0, 0, fBuffer);
    end;
  if assigned(OnPaint) then
    OnPaint(Self);
end;

procedure TTransparentPanel.Resize;

begin
  if csDesigning in ComponentState then
    exit;
  setBufferChanged(True);
  Invalidate;
  inherited Resize;
end;

procedure TTransparentPanel.redrawBackgroundBuffer(var buffer: Graphics.TBitmap);

var
  rDest: TRect;
  bmp: Graphics.TBitmap;
begin
  bmp := Graphics.TBitmap.Create;
  try
    bmp.PixelFormat := pf24bit;
    bmp.Width := Parent.Width;
    bmp.Height := Parent.Height;
    bmp.TransparentColor := Self.Color;
    bmp.Canvas.brush.Color := TCustomForm(parent).Color;
    bmp.Canvas.FillRect(types.rect(0, 0, bmp.Width, bmp.Height));
    SendMessage(parent.Handle, WM_PAINT, bmp.Canvas.handle, 0);
    Application.ProcessMessages;
    buffer.Width := Self.Width;
    buffer.Height := Self.Height;
    rDest := types.Rect(0, 0, Width, Height);
    buffer.Canvas.CopyRect(rDest, bmp.Canvas, BoundsRect);
  finally
    FreeAndNil(bmp);
  end;//finally
end;

function TTransparentPanel.getBufferChanged: boolean;

begin
  Result := fBufferChanged;
end;

procedure TTransparentPanel.setBufferChanged(val: boolean);

begin
  fBufferChanged := val;
end;

procedure TTransparentPanel.Invalidate;

begin
  if assigned(parent) and parent.HandleAllocated then
  begin
    InvalidateRect(parent.Handle, BoundsRect, True);
    inherited Invalidate;
  end
  else
    inherited Invalidate;
end;

constructor TTransparentPanel.Create(AOwner: TComponent);

begin
  inherited Create(AOwner);
  fBuffer := Graphics.TBitmap.Create;
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
    csDoubleClicks, csReplicatable];
  Width := 200;
  Height := 150;
  ParentColor := False;
  fBufferChanged := False;
  inherited Color := clWindow;
end;

destructor TTransparentPanel.Destroy;

begin
  fBuffer.Free;
  inherited Destroy;
end;

end.
