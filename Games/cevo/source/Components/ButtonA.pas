unit ButtonA;

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
  TButtonA = class(TButtonBase)
    constructor Create(aOwner: TComponent); override;
  private
    FCaption: string;
    procedure SetCaption(x: string);
    procedure SetFont(const x: TFont);
  published
    property Visible;
    property Caption: string read FCaption write SetCaption;
    property OnClick;
  public
    property Font: TFont write SetFont;
  protected
    procedure Paint; override;
  end;

procedure Register;

implementation

procedure Register;
begin
RegisterComponents('Samples', [TButtonA]);
end;

constructor TButtonA.Create;
begin
inherited Create(aOwner);
FCaption:='';
SetBounds(0,0,100,25);
end;

procedure TButtonA.Paint;
begin
with Canvas do
  if FGraphic<>nil then
    begin
    BitBlt(Canvas.Handle,0,0,100,25,Graphic.Canvas.Handle,
      195,243+26*Byte(Down),SRCCOPY);
    Canvas.Brush.Style:=bsClear;
    Textout(50-(TextWidth(FCaption)+1) div 2,12-textheight(FCaption) div 2,
      FCaption);
    end
  else begin Brush.Color:=$0000FF; FrameRect(Rect(0,0,100,25)) end
end;

procedure TButtonA.SetCaption(x: string);
begin
if x<>FCaption then
  begin
  FCaption:=x;
  Invalidate
  end
end;

procedure TButtonA.SetFont(const x: TFont);
begin
Canvas.Font.Assign(x);
Canvas.Font.Color:=$000000;
end;

end.

