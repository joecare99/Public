unit ButtonN;

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
  TButtonN = class(TGraphicControl)
    constructor Create(aOwner: TComponent); override;
  private
    FPossible, FLit: boolean;
    FGraphic, FMask, FBackGraphic: TBitmap;
    FIndex, BackIndex: integer;
    FSmartHint: string;
    ChangeProc: TNotifyEvent;
    procedure SetPossible(x: boolean);
    procedure SetLit(x: boolean);
    procedure SetIndex(x: integer);
    procedure SetSmartHint(x: string);
  published
    property Possible: boolean read FPossible write SetPossible;
    property Lit: boolean read FLit write SetLit;
    property SmartHint: string read FSmartHint write SetSmartHint;
    property Graphic: TBitmap read FGraphic write FGraphic;
    property Mask: TBitmap read FMask write FMask;
    property BackGraphic: TBitmap read FBackGraphic write FBackGraphic;
    property ButtonIndex: integer read FIndex write SetIndex;
    property OnClick: TNotifyEvent read ChangeProc write ChangeProc;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      x, y: integer); override;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TButtonN]);
end;

constructor TButtonN.Create;
begin
  inherited Create(aOwner);
  ShowHint := True;
  FGraphic := nil;
  FBackGraphic := nil;
  FPossible := True;
  FLit := False;
  FIndex := -1;
  ChangeProc := nil;
  SetBounds(0, 0, 42, 42);
end;

procedure TButtonN.Paint;
begin
  with Canvas do
  begin
    if FGraphic <> nil then
    begin
      BitBlt(Canvas.Handle, 1, 1, 40, 40, FBackGraphic.Canvas.Handle,
        1 + 80 * BackIndex + 40 * byte(FPossible and FLit), 176, SRCCOPY);
      if FPossible then
      begin
        BitBlt(Canvas.Handle, 3, 3, 36, 36, FMask.Canvas.Handle,
          195 + 37 * (FIndex mod 3), 21 + 37 * (FIndex div 3), SRCAND);
        BitBlt(Canvas.Handle, 3, 3, 36, 36, FGraphic.Canvas.Handle,
          195 + 37 * (FIndex mod 3), 21 + 37 * (FIndex div 3), SRCPAINT);
      end;
    end;
    MoveTo(0, 41);
    Pen.Color := $B0B0B0;
    LineTo(0, 0);
    LineTo(41, 0);
    Pen.Color := $FFFFFF;
    LineTo(41, 41);
    LineTo(0, 41);
  end;
end;

procedure TButtonN.MouseDown;
begin
  if FPossible and (Button = mbLeft) and (@ChangeProc <> nil) then
    ChangeProc(Self);
end;

procedure TButtonN.SetPossible(x: boolean);
begin
  if x <> FPossible then
  begin
    FPossible := x;
    if x then
      Hint := FSmartHint
    else
      Hint := '';
    Invalidate;
  end;
end;

procedure TButtonN.SetLit(x: boolean);
begin
  if x <> FLit then
  begin
    FLit := x;
    Invalidate;
  end;
end;

procedure TButtonN.SetIndex(x: integer);
begin
  if x <> FIndex then
  begin
    FIndex := x;
    if x < 6 then
      BackIndex := 1
    else
      BackIndex := 0;
    Invalidate;
  end;
end;

procedure TButtonN.SetSmartHint(x: string);
begin
  if x <> FSmartHint then
  begin
    FSmartHint := x;
    if FPossible then
      Hint := x;
  end;
end;

end.
