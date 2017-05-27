unit ButtonB;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  WinProcs,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  ButtonBase,
  Classes, Graphics;

type
  TButtonB = class(TButtonBase)
    constructor Create(aOwner: TComponent); override;
  private
    FMask: TBitmap;
    FIndex: integer;
    procedure SetIndex(x: integer);
  public
    property Mask: TBitmap read FMask write FMask;
  published
    property Visible;
    property ButtonIndex: integer read FIndex write SetIndex;
    property OnClick;
  protected
    procedure Paint; override;
  end;

procedure Register;

implementation

procedure Register;
begin
RegisterComponents('Samples', [TButtonB]);
end;

constructor TButtonB.Create;
begin
inherited Create(aOwner);
ShowHint:=true;
SetBounds(0,0,25,25);
end;

procedure TButtonB.Paint;
begin
with Canvas do
  if FGraphic<>nil then
    begin
    BitBlt(Canvas.Handle,0,0,25,25,FGraphic.Canvas.Handle,
      169,243+26*Byte(FDown),SRCCOPY);
    if FIndex>=0 then
      begin
      BitBlt(Canvas.Handle,0,0,25,25,FMask.Canvas.Handle,
        1+FIndex mod 12 *26,337+FIndex div 12 *26,SRCAND);
      BitBlt(Canvas.Handle,0,0,25,25,FGraphic.Canvas.Handle,
        1+FIndex mod 12 *26,337+FIndex div 12 *26,SRCPAINT);
      end
    end
  else begin Brush.Color:=$0000FF; FrameRect(Rect(0,0,25,25)) end
end;

procedure TButtonB.SetIndex(x: integer);
begin
if x<>FIndex then
  begin
  FIndex:=x;
  Invalidate
  end
end;

end.

