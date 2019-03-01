unit uInfo;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface

uses Classes, Controls, ExtCtrls, Forms,
  {$IFDEF FPC} LCLIntf, LCLType,  {$ELSE} StdCtrls, {$ENDIF}Graphics, Messages;

type
  tInfo = class(TForm)
    Timer: tTimer;
    procedure Form_Create(Sender: TObject);
    procedure Form_Destroy(Sender: TObject);
    procedure Form_KeyDown(Sender: TObject; var Key: word; Shift: tShiftState);
    procedure Form_KeyUp(Sender: TObject; var Key: word; Shift: tShiftState);
    procedure Form_Paint(Sender: TObject);
    procedure Form_Show(Sender: TObject);
    procedure Handle_Timer(Sender: TObject);
  private
  public
    bmInfoText: tBitmap;
    Limit, LastPos: integer;
    Foldspeed, yPos, ySpeed: single;

    MovingUp, MovingDown, rendered, quit: boolean;
    procedure RenderText;
    procedure WMEraseBkgnd(var Msg: tWMEraseBkgnd); message WM_EraseBkgnd;
  end;

var
  Info: tInfo;

implementation

uses {$IFNDEF FPC}Windows, {$else}LConvEncoding,{$ENDIF}  SysUtils;

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

var
  Credit: array[0..228] of string = ({$I Credits.txt});

procedure tInfo.Form_Create(Sender: TObject);
begin
  bmInfoText := Graphics.tBitmap.Create; {resource leaks on exceptions!}
  rendered := False; {this will cause a rendering at the OnShow event}
  Lastpos := -1;
end;

procedure tInfo.Form_Destroy(Sender: TObject);
begin
  FreeAndNil(bmInfoText);
end;

procedure tInfo.Form_KeyDown(Sender: TObject; var Key: word; Shift: tShiftState);
begin
  case Key of
    VK_Up: MovingUp := True;
    VK_Down: MovingDown := True;
    VK_Home: yPos := 0;
    VK_End: yPos := Limit;
    VK_SPACE: if abs(ySpeed) < 0.01 then ySpeed:=FoldSpeed else begin Foldspeed := ySpeed;ySpeed:=0.0 end;
    VK_Prior: yPos := yPos - ClientHeight;
    VK_Next: yPos := yPos + ClientHeight;
  end;
end;

procedure tInfo.Form_KeyUp(Sender: TObject; var Key: word; Shift: tShiftState);
begin
  case Key of
    VK_Up: MovingUp := False;
    VK_Down: MovingDown := False;
    VK_Escape: quit := True;
  end;
end;

procedure tInfo.Form_Paint(Sender: TObject);
var
  tmpRect: tRect;
  Size: integer;

begin
  if (Round(yPos) = LastPos) then
    Exit;
  with tmpRect do
  begin {copy bmInfoText onto canvas}
    Left := 0;
    Right := bmInfoText.Width;
    Top := Round(yPos);
    Bottom := Top + ClientHeight;
    LastPos := Top;
  end;
  canvas.Pen.color := clblack;

  Canvas.CopyRect(Rect(0, 0, ClientWidth - 1, ClientHeight), bmInfoText.Canvas,
    tmpRect);

  Size := Round(ClientHeight / Limit * ClientHeight); {draw the 'scrollbar'}
  tmpRect.Top := Round(yPos / Limit * (ClientHeight - Size));
  tmpRect.Bottom := tmpRect.Top + Size;
  with Canvas do
  begin
    MoveTo(ClientWidth - 1, 0);
    Pen.Color := Color;
    LineTo(PenPos.x, tmpRect.Top);
    Pen.Color := clBlack;
    LineTo(PenPos.x, tmpRect.Bottom);
    Pen.Color := Color;
    LineTo(PenPos.x, ClientHeight);
  end;
end;

procedure tInfo.Form_Show(Sender: TObject);
begin
  RenderText;
  yPos := 0;
  ySpeed := 0.4;
  Timer.Enabled := True; {now enter the main loop}
  LastPos := -1;
end;

procedure tInfo.Handle_Timer(Sender: TObject);
var
{$IFDEF FPC}
  Time: int64;
{$ELSE}
{$if declared(GetTickCount64)}
    Time :int64;
  {$else}
  Time: cardinal;
{$IFEND}
{$ENDIF}
begin
  Timer.Enabled := False; {would cause a stack overflow because of App.ProcMsg}
  quit := False;
  repeat
    {$IFDEF FPC}
    Time := GetTickCount64;
    {$ELSE}
    {$if declared(GetTickCount64)}
    Time := GetTickCount64;
    {$else}
    Time := GetTickCount;
    {$IFEND}
    {$ENDIF}
    if MovingUp then
      ySpeed := ySpeed - 0.01
    else {update the position} if MovingDown then
      ySpeed := ySpeed + 0.01;
    yPos := yPos + ySpeed;
    if (yPos < 0) then
    begin
      yPos := 0;
      ySpeed := 0;
    end
    else if (yPos > Limit) then
    begin
      yPos := Limit;
      ySpeed := 0;
    end;
    RePaint; {draw it}
    Application.ProcessMessages;  // ToDo: - Change to AppIdle
    Inc(Time, 10);
    {$IFDEF FPC}
    while (GetTickCount64 < Time) do
    {$ELSE}{$if declared(GetTickCount64)}
    while (GetTickCount64 < Time) do
    {$ELSE}
      while (GetTickCount < Time) do
    {$IFEND}
    {$ENDIF}
    ; {keep the loop at 100 fps}
  until quit or not Info.Visible;
  Close;
end;

procedure tInfo.RenderText;
var
  i, x, y: integer;
begin
  if rendered then
    Exit;
  with bmInfoText.Canvas do
  begin
    Font.Name := Font.Name;
    Font.height := ClientHeight div 14;
    bmInfoText.Width := ClientWidth; {fill with bg color}
    bmInfoText.Height := (high(Credit)+1) * TextHeight(Credit[1]+'Mg');
    bmInfoText.PixelFormat := pf24bit;
    Limit :=  bmInfoText.Height - ClientHeight; {get max. ypos}

    Brush.Color := Color; {set background color}
    Brush.Style := bsSolid;
    FillRect(rect(0, 0,  bmInfoText.Width,  bmInfoText.Height));
//    Brush.Color := clWhite; {set background color}
    Font.Color := clWhite;
    y := 0;
    for i := 0 to High(Credit) do
    begin
      x := ( bmInfoText.Width - TextWidth(Credit[i])) {div 2} shr 1; {centering}
      {$IFDEF FPC}
      TextOut(x, y, Credit[i]); {draw text}
      {$ELSE}
      TextOut(x, y, Credit[i]); {draw text}
      {$ENDIF}
      Inc(y, TextHeight(Credit[i]+'Mg')); {update pos.}
    end;
  end;
  rendered := True;
end;

procedure tInfo.WMEraseBkgnd(var Msg: tWMEraseBkgnd);
begin
  Msg.Result := LResult(False); {prevent drawing of the window background}
end;

end.
