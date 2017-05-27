unit ButtonBase;

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
  Classes, Graphics, Controls;

type
  TButtonBase = class(TGraphicControl)
    constructor Create(aOwner: TComponent); override;
  protected
    FDown,FPermanent,Active: boolean;
    FGraphic: TBitmap;
//    FDownSound, FUpSound: string;
    ChangeProc: TNotifyEvent;
    procedure SetDown(x: boolean);
//    procedure PlayDownSound;
//    procedure PlayUpSound;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      x, y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      x, y: integer); override;
    procedure MouseMove(Shift: TShiftState; x, y: integer); override;
  public
//    property DownSound: string read FDownSound write FDownSound;
//    property UpSound: string read FUpSound write FUpSound;
  published
    property Visible;
    property Graphic: TBitmap read FGraphic write FGraphic;
    property Down: boolean read FDown write SetDown;
    property Permanent: boolean read FPermanent write FPermanent;
    property OnClick: TNotifyEvent read ChangeProc write ChangeProc;
  end;

implementation

//uses
//  MMSystem;

constructor TButtonBase.Create;
begin
inherited Create(aOwner);
//FDownSound:='';
//FUpSound:='';
FGraphic:=nil; Active:=false; FDown:=false; FPermanent:=false;
ChangeProc:=nil;
end;

procedure TButtonBase.MouseDown;
begin
Active:=true;
MouseMove(Shift,x,y)
end;

procedure TButtonBase.MouseUp;
begin
if ssLeft in Shift then exit;
MouseMove(Shift,x,y);
if Active and FDown then
  begin
//  PlayUpSound;
  Active:=false;
  FDown:=FPermanent;
  Invalidate;
  if (Button=mbLeft) and (@ChangeProc<>nil) then ChangeProc(self)
  end
else
  begin
//  if FDown then PlayUpSound;
  Active:=false;
  FDown:=false;
  Invalidate;
  end
end;

procedure TButtonBase.MouseMove;
begin
if Active then
   if (x>=0) and (x<Width) and (y>=0) and (y<Height) then
     if (ssLeft in Shift) and not FDown then
       begin {PlayDownSound;} FDown:=true; Paint end
   else else if FDown and not FPermanent then
     begin {PlayUpSound;} FDown:=false; Paint end
end;

procedure TButtonBase.SetDown(x: boolean);
begin
FDown:=x;
Invalidate
end;

//procedure TButtonBase.PlayDownSound;
//begin
//if DownSound<>'' then SndPlaySound(pchar(DownSound),SND_ASYNC)
//end;

//procedure TButtonBase.PlayUpSound;
//begin
//if UpSound<>'' then SndPlaySound(pchar(UpSound),SND_ASYNC)
//end;

end.

