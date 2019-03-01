Unit uMain;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

Interface
Uses Classes, ExtCtrls, Forms, Messages,
    {$IFDEF FPC}  LCLIntf, LCLType {$ELSE} AppEvnts {$ENDIF};

Type

{ tMain }

 tMain = Class(tForm)
    {$IFDEF FPC}
    AppEvents: TApplicationProperties;
    IdleTimer1: TIdleTimer;
    {$ELSE}
    AppEvents: TApplicationEvents;
    {$ENDIF}
    Timer_Start: tTimer;
    Timer_FPS: tTimer;
    procedure AppEventsIdle(Sender: TObject; var Done: Boolean);
    Procedure App_Continue(Sender: tObject);
    Procedure App_Pause(Sender: tObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    Procedure Form_KeyDown(Sender: tObject; Var Key: Word; Shift: tShiftState);
    Procedure Form_KeyPress(Sender: tObject; Var Key: Char);
    Procedure Form_KeyUp(Sender: tObject; Var Key: Word; Shift: tShiftState);
    Procedure Form_Paint(Sender: tObject);
    Procedure Form_Show(Sender: tObject);
    Procedure Handle_Start(Sender: tObject);
    Procedure Handle_FPS(Sender: tObject);
  private
     Finitialized : Boolean;
  public
    FPS, Last_FPS: Integer;
    Speed: Single;
    Procedure DrawStatus;
    Procedure WMEraseBkgnd(Var Msg: tWMEraseBkgnd); message WM_EraseBkgnd;
  End;

Var Main: tMain;

Implementation
Uses {$IFNDEF FPC}windows, {$ENDIF} SysUtils, uGame, uSettings, uInfo;

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

{Tools}
resourcestring
  cScore = 'Score ';
  cTemp = 'Temp  ';
  cPXF = 'PXF ';
  cFPS = 'FPS ';

Function AddKomma(Text: String): String;
Var i, Index: Integer;
  negative: Boolean;
Begin
  Result := '';
  negative := (Text[1] = '-');
  If negative Then
    Delete(Text, 1, 1);
  For i := 1 To ((Length(Text) - 1) Div 3) Do
    Begin
      Index := Length(Text) - 2;
      Result := ',' + Copy(Text, Index, 3) + Result;
      Delete(Text, Index, 3);
    End;
  If negative Then
    Text := '-' + Text;
  Result := Text + Result;
End;

Function Min4(Value: Integer): String;
Begin
  If (Value < 0) Then
    Begin
      Result := IntToStr(Abs(Value));
      While (Length(Result) < 3) Do
        Result := '0' + Result;
      Result := '-' + Result;
    End
  Else
    Begin
      Result := IntToStr(Value);
      While (Length(Result) < 4) Do
        Result := '0' + Result;
    End;
End;

{Main}

Procedure tMain.App_Continue(Sender: tObject);
Begin
  If assigned(Game) Then
    Game.focused := True;
End;

procedure tMain.AppEventsIdle(Sender: TObject; var Done: Boolean);
{$IFDEF FPC}
Var Time: int64;
{$ELSE}
Var Time: Cardinal;
{$ENDIF}
begin

    if not FInitialized then
       begin
         Main.SetFocus;
         Game := tGame.Create;
         Timer_FPS.Enabled := True;
         FInitialized := true
       end;
    {$IFDEF FPC}
    Time := GetTickCount64 + 10;
    {$ELSE}
    Time := GetTickCount + 10;
    {$ENDIF}
    Done := false;
    Game.Update; {cancelled when paused}
    Game.Draw;
    DrawStatus;
    Invalidate;
    If Settings.Box_Limit.Checked Then
      {$IFDEF FPC}
      While (GetTickCount64 < Time) Do
      {$ELSE}
      While (GetTickCount < Time) Do
      {$ENDIF}
        sleep(0); {wait 10 ms => get 100 fps}
end;

Procedure tMain.App_Pause(Sender: tObject);
Begin
  If assigned(Game) Then
    Game.focused := False;
End;

procedure tMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if CloseAction <> caMinimize then
    begin
    Timer_FPS.Enabled:=false;
    freeandnil(Game);
    end;
end;

Procedure tMain.Form_KeyDown(Sender: tObject; Var Key: Word; Shift:
  tShiftState);
Begin
  If (Game = Nil) Then
    Exit;
  If (Not uGame.Menu.visible) Then
    Begin
      With Settings Do
        With Game Do
          Begin
            If assigned(Player) Then
              Begin
                If (Key = KeyLeft) Then
                  Player.TurningLeft := True;
                If (Key = KeyRight) Then
                  Player.TurningRight := True;
                If (Key = KeyAccel) Then
                  Player.Accelerating := True;
                If (Key = KeyFire) Then
                  AddShot;
                If (Key = {$IFDEF FPC}VK_P{$else}ORD('P'){$ENDIF}) Then
                  PecitionShot;
                If Player.Accelerating and
                  (player.Temp<300) and
                  ((abs(player.speed.x)+abs(player.speed.y)>0.01)) and
                  (player.BlinkCounter<50.0) then
                  AddShot;
              End;
            If (Key = VK_Pause) Then
              Game.paused := Not Game.paused;
            If (Key = VK_Escape) Then
              uGame.Menu.visible := True;
          End;
    End
  Else
    uGame.Menu.GetKey(Key);
  If (Key In [VK_F1..VK_F8]) Then
    Settings.Form_KeyDown(Sender, Key, Shift);
End;

Procedure tMain.Form_KeyPress(Sender: tObject; Var Key: Char);
Begin
if Key <> #27 then
  Key:=#0;
End;

Procedure tMain.Form_KeyUp(Sender: tObject; Var Key: Word; Shift: tShiftState);
Begin
  If (Game = Nil) Then
    Exit;
  With Settings Do
    If assigned(Game.Player) Then
      With Game.Player Do
        Begin
          If (Key = KeyLeft) Then
            TurningLeft := False;
          If (Key = KeyRight) Then
            TurningRight := False;
          If (Key = KeyAccel) Then
            Accelerating := False;
        End;
End;

Procedure tMain.Form_Paint(Sender: tObject);
Begin
  If assigned(Game) Then
    try
      Canvas.Draw(0, 0, Game.Screen);
    except
    end;
End;

Procedure tMain.Form_Show(Sender: tObject);
Begin
  Timer_Start.Enabled := True;
End;

Procedure tMain.Handle_Start(Sender: tObject);
Begin
  Timer_Start.Enabled := False; {would cause stack overflow}
End;

Procedure tMain.Handle_FPS(Sender: tObject);
Begin
  If Settings.Box_Stop.Checked And (Not focused) And (Not uGame.Menu.visible)
    Then
    Exit;
  Last_FPS := FPS * 1000 Div Integer(Timer_FPS.Interval);
  If (Last_FPS <> 0) Then
    Game.Speed := 100 / Last_FPS;
  If (Not Settings.Box_Accel.Checked) Then
    If (Game.Speed > 1) Then
      Game.Speed := 1;
  FPS := 0;
End;

Procedure tMain.DrawStatus;
Var xPos, yPos: Single;
Begin
  With Game Do
    With Screen Do
      With Player Do
        With Settings Do
          Begin
            xPos := TextWidth(' ', 4);
            yPos := TextHeight(4);
            If alive Then
              Begin
                If (Score <> 0) Then
                  DrawText(cScore + Min4((Score)), xPos, yPos * 1, 4);
                If (Round(Temp) <> 0) Then
                  DrawText(cTemp + Min4(Round(Temp)), xPos, yPos * 3, 4);
              End;
            If Settings.Box_ShowFPS.Checked Then
              Begin
                yPos := TextHeight(4) * 2;
                DrawText(cFPS + Min4(Last_FPS), xPos, Screen.Height - yPos, 4);
              End;
          End;
  If focused Or (Not Settings.Box_Stop.Checked) Or uGame.Menu.visible Then
    Inc(FPS);
End;

Procedure tMain.WMEraseBkgnd(Var Msg: tWMEraseBkgnd);
Begin
  Msg.Result := LResult(False); {prevent drawing of the window background}
End;

End.
