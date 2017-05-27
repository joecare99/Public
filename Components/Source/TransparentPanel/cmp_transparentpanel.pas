unit cmp_transparentpanel;

{$mode objfpc}{$H+}

interface

uses
  Classes,   SysUtils,{$IFDEF FPC}  LMessages,LCLType, {$ELSE}  Messages, {$ENDIF} Forms, Controls, Graphics  ;

type

  { TTransparentPanel }

  TTransparentPanel = class(TCustomControl)

  private
    fBuffer: TBitmap;
    fBufferChanged: boolean;
    FNoBGR: Boolean;
    procedure SetNoBGR(AValue: Boolean);
  protected
    {$IFDEF FPC}
    procedure WMWindowPosChanged(var Message: TLMWindowPosChanged);
      message LM_WINDOWPOSCHANGED;
//    procedure WMEraseBkgnd(var Message: TLMEraseBkgnd); message LM_ERASEBKGND;
    {$ELSE}
    procedure WMWindowPosChanged(var Message: TLMWindowPosChanged);
      message WM_WINDOWPOSCHANGED;
//    procedure WMEraseBkgnd(var Message: TLMEraseBkgnd); message WM_ERASEBKGND;
    {$ENDIF}
    procedure CreateParams(var Params: TCreateParams);override;
    procedure Paint; override;
    procedure Resize; override;
    procedure redrawBackgroundBuffer; virtual;
    function getBufferChanged: boolean; virtual;
    procedure setBufferChanged(val: boolean); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Invalidate; override;
    function getBuffer: Graphics.TBitmap; virtual;
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

uses windows,types;

procedure Register;

begin
  RegisterComponents('Standard', [TTransparentPanel]);
end;

{ TTransparentPanel }

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
//  Invalidate;
   if csDesigning in ComponentState then
    exit;
  Canvas.CopyRect(rect(0,0,Width,Height),fBuffer.Canvas,rect(left,top,Left+Width,top+Height));
//  inherited;
end;

procedure TTransparentPanel.CreateParams(var Params: TCreateParams);

begin
  inherited CreateParams(Params);
//  ControlStyle:=ControlStyle - [csOpaque];
end;

procedure TTransparentPanel.Paint;


begin
   if csDesigning in ComponentState then
    exit;
  Canvas.CopyRect(rect(0,0,Width,Height),fBuffer.Canvas,rect(left,top,Left+Width,top+Height));
  if assigned(OnPaint) then
    OnPaint(Self);
end;

procedure TTransparentPanel.Resize;

begin
  if csDesigning in ComponentState then
    exit;
  Invalidate;
  inherited Resize;
end;

procedure TTransparentPanel.redrawBackgroundBuffer;

var
  OldViz: Boolean;
begin
  if csDesigning in ComponentState then
    exit;
  with fBuffer do
  begin
    PixelFormat := pf24bit;
    Width := Parent.Width;
    Height := Parent.Height;
    Canvas.brush.Color := clMaroon;
    Canvas.FillRect(types.rect(0, 0, Width, Height));
    OldViz:=    self.Visible;
    self.Visible:=false;

    SendMessage(parent.handle, LM_PAINT, Canvas.handle, 0);
    Application.ProcessMessages;
    self.Visible:=OldViz;
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
  if assigned(parent) and parent.HandleAllocated and parent.Visible then
  begin
    if (fBuffer.Width <> Parent.Width) or
       (fBuffer.Height <> Parent.Height) then
       redrawBackgroundBuffer;
//    InvalidateRect(parent.Handle, BoundsRect, True);
  end;
  inherited;
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
  freeandnil(fBuffer);
  inherited Destroy;
end;

end.
