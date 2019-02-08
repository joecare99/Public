Unit uGame;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

Interface
Uses {$IFDEF MSWINDOWS} windows,  {$ELSE}   {$ENDIF}
     {$IFDEF FPC} LCLIntf, LCLType,  {$ENDIF} Classes, Graphics, uTypes; {Graphics MUST follow Windows}

{ $DEFINE ShowEdgeLines}{!!! ONLY for debugging !!!}
{ $DEFINE test}{!!! ONLY for debugging !!!}

type
  tScreenObj = Class {ancestor of all objects on screen}
    Size: Single;
    Color:TColor;
    Point: Array Of tPoint;
    destructor Destroy; override;
  End;

  tScreenChar = Class(tScreenObj) {character on screen}
    PointTmp: Array Of tPoint;
    Constructor Create(Index: Byte);
    Procedure Draw(xPos, yPos: Single);
    Destructor Destroy; override;
  End;

  tSpaceObj = Class(tScreenObj) {ancestor of all moving space objects}
    ShowPos: Boolean;
    Pos, Speed: TFloatPoint;
    Turned, TurnSpeed: Single;
    Edge: Array Of TVector;
    PointSingle: Array Of TFloatPoint;
    Constructor Create;
    Procedure ProcessPoints;
    Procedure Draw;
    Procedure Update;
    destructor Destroy; override;
  End;

  tRock = Class(tSpaceObj) {ancestor of all moving objects}
    RockType: Integer;
    SpeedDir: Single; {direction in RAD}
    Constructor Create;
  End;

  tPlayer = Class(tSpaceObj) {Player = Spaceship}
    TurningLeft, alive,
      TurningRight,
      Accelerating: Boolean;
    Score, Levels: Integer; {can be negative}
    Temp, BlinkCounter: Single;
    Constructor Create;
    Procedure Update;
    Procedure CheckCollision;
    Procedure Reset;
    Procedure Draw;
  End;

  tSpark = Class(tSpaceObj)
    Counter: Single;
    Constructor Create(Sender: tSpaceObj);
    Procedure Update;
  End;

  { tShot }

  tShot = Class(tSpark) {spark + altered size, speed & counter}
    Multi:integer;
    constructor Create(Sender: tPlayer; offset: TFloatPoint);
    Procedure Update;
  End;

  { tGame }

  tGame = Class
    Screen: tBitmap;
    Speed: Single; {should be 1}
    ScreenFactor: TFloatPoint;
    focused, paused: Boolean;
    Player: tPlayer;
    Rock: Array Of tRock;
    Shot: Array Of tShot;
    Spark: Array Of tSpark;
    ScreenChar: Array[Byte] Of tScreenChar;
    Constructor Create;
    Destructor Destroy; override;
    Procedure Update;
    Procedure Check_DeadShots;
    Procedure Check_DeadSparks;
    Procedure Draw;
    Procedure DrawText(Text: String; xPos, yPos, TextSize: Single);
    Function TextWidth(Text: String; TextSize: Single): Single;
    Function TextHeight(TextSize: Single): Single;
    Procedure AddSparks(Sender: tSpaceObj);
    Procedure AddShot;
    procedure PecitionShot;
    Procedure SplitRock(i: Integer);
    Procedure Beep(Count: Integer);
    Procedure PrepareIntro;
    Procedure NewGame;
  private
  End;

  tMenuItem = Class
    Caption: String;
    Item: Array Of tMenuItem;
    Owner: tMenuItem;
    SelectedItem: Integer;
    active: Boolean;
    Procedure Draw;
    Procedure GetKey(Key: Word);
    Destructor Destroy; override;
  End;

  tMenu = Class(tMenuItem)
    visible: Boolean;
    BlinkCounter: Single;
    Constructor Create;
    Procedure GetKey(Key: Word);
  End;

Var Game: tGame = Nil;
  Menu: tMenu = Nil;

Implementation
Uses Forms, SysUtils, Dialogs, uMain, uSettings, uHighscores,
uDlg_EnterName, uInfo, math;

Const Edges: Array[Byte] Of String = ({$I CharEdges.txt});

{Tools}

Procedure Adjust(Var Value: Single); {get value into 0..1}

Begin
  try
  {$ifdef FPC}
  if dword(value)=$ffffffff then
    value :=0.5;
  {$endif}
  if frac(Value) < 0 then
    Value :=1.0+ frac(value)
    else
  Value := frac(value);
  except
    Value:=0.5;
  end;
End;

Function PointInPoly(Pos: TFloatPoint; Point: Array Of TFloatPoint): Boolean;
Var i, j: Integer;
Begin
  Result := False;
  j := High(Point);
  For i := 0 To High(Point) Do
    Begin
      If ((Point[i].y <= Pos.y) And (Pos.y < Point[j].y)) Or
        ((Point[j].y <= Pos.y) And (Pos.y < Point[i].y)) Then
        Begin
          If (Pos.x < (Point[j].x - Point[i].x) * (Pos.y - Point[i].y) /
            (Point[j].y - Point[i].y) + Point[i].x) Then
            Result := Not Result;
        End;
      j := i;
    End;
End;

Function Collision(Pos: TFloatPoint; TestObj: tSpaceObj): Boolean;
Var x, y: Integer;
  tmpPos: TFloatPoint;
Begin
  Result := False;
  if sqr(Pos.x - TestObj.Pos.x*Game.Screen.Width)+sqr(pos.y-TestObj.pos.y*Game.Screen.Height)< sqr(TestObj.Size*1.1) then
  If Settings.Box_ShowParts.Checked Then
    Begin
      For y := -1 To 1 Do {check in all 9 screens}
        For x := -1 To 1 Do
          With Game.Screen Do
            Begin
              tmpPos.x := Pos.x + (x * Width);
              tmpPos.y := Pos.y + (y * Height);
              If PointInPoly(tmpPos, TestObj.PointSingle) Then
                Begin
                  Result := True;
                  Exit; {break loop}
                End;
            End;
    End
  Else
      Result := PointInPoly(Pos, TestObj.PointSingle);

End;

Function Collision2(TestObj1: tSpaceObj; TestObj: tSpaceObj): Boolean;
Var x, y: Integer;
  tmpPos: TFloatPoint;
  lf: Single;
Begin
  Result := False;
   If Settings.Box_ShowParts.Checked Then
    Begin
      For y := -1 To 1 Do {check in all 9 screens}
        For x := -1 To 1 Do
          if (abs(TestObj1.Pos.x-x*0.7-0.5) < 0.5) and
              (abs(TestObj1.Pos.y-y*0.7-0.5) < 0.5) then
          With Game.Screen Do
            Begin
              tmpPos.x := TestObj1.Pos.x* Width + (x * Width);
              tmpPos.y := TestObj1.Pos.y* Height + (y * Height);
              If PointInPoly(tmpPos, TestObj.PointSingle) Then
                Begin
                  Result := True;
                  Exit; {break loop}
                End;
            End;
    End
  Else
    if abs(TestObj1.Speed.x)+abs(TestObj1.Speed.y)* Game.Speed<2*testobj.Size/Game.Screen.height then
      begin
        if sqr(TestObj1.Pos.x - TestObj.Pos.x)+sqr(TestObj1.pos.y-TestObj.pos.y)< sqr(TestObj.Size/Game.Screen.Height) then
          Begin
            tmpPos.x := TestObj1.Pos.x* Game.Screen.Width ;
            tmpPos.y := TestObj1.Pos.y* Game.Screen.Height ;
            Result := PointInPoly(tmpPos, TestObj.PointSingle);
          end;
      end
    else
      begin
        lf := TestObj1.pos.Diff(TestObj.pos).vMult(TestObj1.Speed);

      end;

End;

{ScreenObj}

Destructor tScreenObj.Destroy;
Begin
  Point := Nil;
  Inherited;
End;

{ScreenChar}

Constructor tScreenChar.Create(Index: Byte);
Var i: Integer;
  tmpStr: String;
Begin
  Inherited Create;
  color := Main.Font.Color;
  tmpStr := Edges[Index];
  SetLength(Point, Length(tmpStr) Div 2);
  SetLength(PointTmp, Length(tmpStr) Div 2);
  For i := 0 To High(Point) Do
    Begin
      Point[i].x := StrToInt(tmpStr[1]) + 0;
      Delete(tmpStr, 1, 1);
      Point[i].y := StrToInt(tmpStr[1]) - 4;
      Delete(tmpStr, 1, 1);
    End;
End;

Procedure tScreenChar.Draw(xPos, yPos: Single);
Var i: Integer;
  oc: TColor;
Begin
  If (Length(Point) = 0) Then
    Exit;
  With Game.ScreenFactor Do
    Begin
      For i := 0 To High(Point) Do
        Begin
          PointTmp[i].x := Round(xPos + (Point[i].x * Size * x));
          PointTmp[i].y := Round(yPos - (Point[i].y * Size * y));
        End;
    End;
  With Game.Screen.Canvas Do
    With PointTmp[High(Point)] Do
      Begin
        oc := pen.Color;
        pen.color := clBlack;
        pen.width := 5;
        PolyLine(PointTmp);
        pen.color := Color;
        pen.width := 1;
        PolyLine(PointTmp);
        Pixels[x, y] := Pen.Color;
        Pen.Color := oc;
      End;
End;

Destructor tScreenChar.Destroy;
Begin
  PointTmp := Nil;
  Inherited;
End;

{SpaceObj}

Constructor tSpaceObj.Create;
Var i: Integer;
  tmp: Single;
Begin
{!!! EDGE MUST HAVE A LENGTH <> ZERO AT THIS POINT !!!}
  Inherited;
  SetLength(PointSingle, Length(Edge));
  SetLength(Point, Length(Edge));
  tmp := 1 / Length(Edge);
  Color := clWhite;
  For i := 0 To High(Edge) Do
    With Edge[i] Do
      Begin
        If (i <> 0) Then
          Direction := Edge[i - 1].Direction + tmp
        Else
          Direction := 0;
        Distance := 1 - (Random * RockAnomaly); {should be 0.75 .. 1.00}
      End;
  Turned := Random;
End;

Procedure tSpaceObj.ProcessPoints; {get edge values into screen values}
Var tmp, tmpx, tmpy: Single;
  i: Integer;
Begin
  tmpx := Size * Game.ScreenFactor.x;
  tmpy := Size * Game.ScreenFactor.y;
  For i := 0 To High(Edge) Do
    With Edge[i] Do
      Begin
        tmp := (Direction + Turned) * r360;
        With PointSingle[i] Do
          With Game Do
            Begin
              x := (Pos.x * Screen.Width) + (Sin(tmp) * Distance * tmpx);
              y := (Pos.y * Screen.Height) - (Cos(tmp) * Distance * tmpy);
            End;
      End;
End;

Procedure tSpaceObj.Draw;
Var i, x, y: Integer;
Begin
  ProcessPoints;
  Game.Screen.canvas.pen.color:=Color;
  If Settings.Box_ShowParts.Checked Then
    Begin
      With Game.Screen Do
        For y := -1 To 1 Do
          Begin
            For i := 0 To High(Point) Do {get y values}
              Point[i].y := Round(PointSingle[i].y + (y * Height));
            For x := -1 To 1 Do
              Begin {get x values}
                For i := 0 To High(Point) Do
                  Point[i].x := Round(PointSingle[i].x + (x * Width));
                Canvas.Polygon(Point); {draw it}
              End;
          End;
    End
  Else
    With Game.Screen Do
      Begin
        For i := 0 To High(Point) Do
          Begin
            Point[i].x := Round(PointSingle[i].x); {get x values}
            Point[i].y := Round(PointSingle[i].y); {get y values}
          End;
        Canvas.Polygon(Point); {draw it}
      End;
  If ShowPos Then
    With Game.Screen Do
      With Canvas Do {modify pixel at pos.}
        Pixels[Round(Pos.x * Width), Round(Pos.y * Height)] := Pen.Color;
{$IFDEF ShowEdgeLines}
  With Game.Screen Do
    With Canvas Do {draw lines to the edges}
      For i := 0 To High(Edge) Do
        Begin
          MoveTo(Round(Pos.x * Width), Round(Pos.y * Height));
          LineTo(Round(PointSingle[i].x), Round(PointSingle[i].y));
        End;
{$ENDIF}
End;

Procedure tSpaceObj.Update;
Var Movement: TFloatPoint;
Begin
  If Settings.Box_FirstP.Checked Then
    Begin {add player's speed}
      If (Self <> Game.Player) Then
        Movement:=Speed.Diff(Game.Player.Speed)
      else
        Movement:=ZeroPnt;
    End
  Else
    Movement := Speed;
  Pos.x := Pos.x + (Movement.x * Game.Speed);
  Adjust(Pos.x);
  Pos.y := Pos.y - (Movement.y * Game.Speed);
  Adjust(Pos.y);
  Turned := Turned + (TurnSpeed * Game.Speed);
  Adjust(Turned);
End;

Destructor tSpaceObj.Destroy;
Begin
  Edge := Nil;
  PointSingle := Nil;
  Inherited;
End;

{Rock}

Constructor tRock.Create;
Const div1000: Single = 1 / 1000;
  div0200: Single = 1 / 0200;
Begin
  SetLength(Edge, 16); {prepare point structure}
  Inherited;
  color := clLtGray;
  Pos.x := Random; {random position}
  Pos.y := Random;
  SpeedDir := Random * r360; {random movement direction}
  Speed.x := Sin(SpeedDir) * div1000;
  Speed.y := Cos(SpeedDir) * div1000;
  TurnSpeed := (Random - 0.5) * div0200; {random turnspeed}
  Size := 48;
End;

{Player}

Constructor tPlayer.Create;
Begin
  SetLength(Edge, 4); {prepare edges}
  Inherited;
  Edge[0].Direction := 000 / 360;
  Edge[0].Distance := Sin(r045); {set edges}
  Edge[1].Direction := 225 / 360;
  Edge[1].Distance := 1;
  Edge[2].Direction := 180 / 360;
  Edge[2].Distance := Edge[0].Distance / 2;
  Edge[3].Direction := 135 / 360;
  Edge[3].Distance := 1;
  Size := 12;
  alive := False;
End;

Procedure tPlayer.Update;
Const TurnValue: Single = 12 / 1000;
  div7500: Single = 01 / 7500;
  div0100: Single = 01 / 0100;
Var i: Integer;
Begin
  If (Not alive) Then
    Exit;
  If (Length(Game.Rock) = 0) Then
    Begin
      Inc(Levels);
      i := Levels;
      If (Score > 0) Then
        Inc(i, trunc(ln(Score)*0.1 ));
      SetLength(Game.Rock, i);
      For i := 0 To High(Game.Rock) Do
        Begin
          Game.Rock[i] := tRock.Create;
          Game.Rock[i].RockType := 1;
        End;
      If (Length(Game.Shot) <> 0) Then
        For i := 0 To High(Game.Shot) Do
          Game.Shot[i].Counter := 0;
      Reset;
    End;
  CheckCollision;
  If TurningLeft Then
    TurnSpeed := -TurnValue
  Else If TurningRight Then
    TurnSpeed := +TurnValue
  Else
    TurnSpeed := 0;
  If Accelerating Then
    Begin
      Speed.x := Speed.x + (Sin(Turned * r360) * div7500 * Game.Speed);
      Speed.y := Speed.y + (Cos(Turned * r360) * div7500 * Game.Speed);
      if (abs(speed.x)+abs(speed.y)>0.001) and (Temp < 500.0) and (BlinkCounter<0.5) then
       //  game.AddShot;
         ;
    End;
  If (BlinkCounter > 0) Then
    BlinkCounter := BlinkCounter - Game.Speed
  Else
    BlinkCounter := 0;
  Temp := Temp - ((Temp * div0100) * Game.Speed);
  Inherited;
End;

Procedure tPlayer.CheckCollision;
Var i, j: Integer;
  broken: Boolean;
  tmpPos: TFloatPoint;
Begin
{Exit;                            {remove bracket for <unbesiegbarkeit>}
  broken := False;
  For j := 0 To High(PointSingle) Do
    If (Not broken) Then
      For i := 0 To High(Game.Rock) Do
        If Collision(PointSingle[j], Game.Rock[i]) Then
          Begin
            broken := True;
            Game.SplitRock(i);
            Break;
          End;
  If (Not broken) Then
    Begin
      tmpPos.x := Pos.x * Game.Screen.Width;
      tmpPos.y := Pos.y * Game.Screen.Height;
      For i := 0 To High(Game.Rock) Do
        If Collision(tmpPos, Game.Rock[i]) Then
          Begin
            broken := True;
            Game.SplitRock(i);
            Break;
          End;
    End;
  If (BlinkCounter > 0) Then
    Exit;
  If broken Then
    Begin
      Game.AddSparks(Self);
      Dec(Score, 512);
      Reset;
    End;
End;

Procedure tPlayer.Reset;
Begin
  Pos.x := 0.5;
  Pos.y := 0.5;
  BlinkCounter := 300;
  Speed.x := 0;
  Speed.y := 0;
  TurnSpeed := 0;
  Temp := 0;
End;

Procedure tPlayer.Draw;
Begin
  If (Not alive) Then
    Exit;
  If (BlinkCounter <> 0) And ((Round(BlinkCounter) Div
    Settings.TrackBar_Blink.Position And 1) = 0) Then
    Exit;
  Inherited;
End;

{Spark}

Constructor tSpark.Create(Sender: tSpaceObj);
Const div0003: Single = 1 / 0003;
  div0250: Single = 1 / 0250;
Begin
  SetLength(Edge, 3);
  Inherited Create;
  TurnSpeed := 0.5;
  Pos := Sender.Pos;
  Speed.x := (Sender.Speed.x * div0003) + (Sin(r360 * Turned) * div0250) *
    Random;
  Speed.y := (Sender.Speed.y * div0003) + (Cos(r360 * Turned) * div0250) *
    Random;
  Counter := Random(48);
  Size := 0.5; {should create dots in 640x480, creates flickering if lower}
End;

Procedure tSpark.Update;
Begin
  Inherited;
  Counter := Counter - Game.Speed;
End;

{Shot}

constructor tShot.Create(Sender: tPlayer; offset: TFloatPoint);
Const div0125: Single = 1 / 0125;
var
  s: Single;
  c: single;
  v: single;
Begin
  Inherited Create(Sender);
  v:= (random -0.5)*div0125*sender.Levels*sender.Temp*0.0003;
  s := Sin((Sender.Turned +v)* r360);
  c := Cos((Sender.Turned +v)* r360);
  Multi:=round(ln(sender.Levels+1))+1 ;
  pos.x := pos.x + c*offset.x - s*offset.y;
  pos.Y := pos.y + c*offset.y + s*offset.x;
  Speed.x := Sender.Speed.x + (s * div0125);
  Speed.y := Sender.Speed.y + (c * div0125);
  Counter := 120+sender.Levels*3;
  Size := 1.5;
End;

procedure tShot.Update;
Var i: Integer;

Begin
  Inherited;
  i := 0;
  while i <= High(Game.Rock) Do
    If Collision2(self, Game.Rock[i]) Then
      Begin
        If (Length(Game.Rock) > 1) Or
          (Game.Rock[0].RockType <> 4) Then
          Game.AddSparks(Self);
        Game.SplitRock(i);
        dec(Multi);
        if multi<=0 then
          begin
            Counter := 0;
            Break;
          end;
      End
    else
      inc(i)

End;

{Game}

Constructor tGame.Create;
Const div0640: Single = 1 / 0640;
Const div0480: Single = 1 / 0480;
Var i: Integer;
Begin
  Inherited;
  Screen := tBitmap.Create; {could cause resource leaks on IDE exceptions!}
  With Screen Do
    Begin
      Width := Main.ClientWidth;
      Height := Main.ClientHeight;
      {$ifndef FPC}
      PixelFormat := pf15bit; {!! must be specified AFTER Width & Height !!}
      {$ELSE}
      PixelFormat := pf4bit; {!! must be specified AFTER Width & Height !!}
      {$ENDIF}
      With Canvas Do
        Begin
          Pen.Color := Main.Font.Color;
          Font.Color := Main.Font.Color;
          Brush.Color := Main.Color;
        End;
      Settings.UpdateColors;
    End;
  Player := Nil;
  Player := tPlayer.Create;
  SetLength(Rock, 0);
  SetLength(Spark, 0);
  SetLength(Shot, 0);
  Speed := 1;
  ScreenFactor.x := Screen.Width * div0640;
    {!!! change to 480 for rectangular screens !!!}
  ScreenFactor.y := Screen.Height * div0480;
  For i := 0 To 255 Do
    ScreenChar[i] := tScreenChar.Create(i);
  focused := True;
  Menu := tMenu.Create;
  PrepareIntro;
End;

Procedure tGame.Update;
Var i: Integer;
Begin
  If (paused Or (Menu.visible And Player.alive)) Then
    Exit;
  If Settings.Box_Stop.Checked And (Not focused) And Player.alive Then
    Exit;
  For i := 0 To High(Rock) Do
    Rock[i].Update;
  For i := 0 To High(Spark) Do
    Spark[i].Update;
  Check_DeadSparks;
  For i := 0 To High(Shot) Do
    Shot[i].Update;
  Check_DeadShots;
  Player.Update;
End;

Procedure tGame.Check_DeadSparks;
Var i, next: Integer;
  finished: Boolean;
Begin
  next := 0;
  Repeat
    finished := True;
    For i := next To High(Spark) Do
      If (Spark[i].Counter <= 0) Then
        Begin
          finished := False; {one more loop}
          Spark[i].Free;
          Spark[i] := Spark[High(Spark)]; {!! insert LAST spark HERE}
          SetLength(Spark, High(Spark)); {!! ... and cut the array}
          next := i + 1; {don't start from the beginning}
          Break; {goto next repeat-until loop}
        End;
  Until finished;
End;

Procedure tGame.Check_DeadShots;
Var i, next: Integer;
  finished: Boolean;
Begin
  next := 0;
  Repeat
    finished := True;
    For i := next To High(Shot) Do
      If (Shot[i].Counter <= 0) Then
        Begin
          finished := False; {same as check_deadsparks}
          Shot[i].Free;
          Shot[i] := Shot[High(Shot)];
          SetLength(Shot, High(Shot));
          next := i + 1;
          Break;
        End;
  Until finished;
End;

Procedure tGame.Draw;
Var i: Integer;
Begin
  With Screen.Canvas Do
    With Brush Do
      Begin
        Style := bsSolid; {make it solid for filling}
        Color := Main.Color; {color seems to be cleared on style 'clearing'}
        FillRect(ClipRect);
          {does anyone know of a better solution?  MOST SPEED BRAKE HERE}
        Style := bsClear; {for transparent polygons - sounds great, hehe}
      End;
  For i := 0 To High(Rock) Do
    Rock[i].Draw;
  For i := 0 To High(Spark) Do
    Spark[i].Draw;
  For i := 0 To High(Shot) Do
    Shot[i].Draw;
  Player.Draw;
  If Menu.visible Then
    Menu.Draw;
End;

Procedure tGame.DrawText(Text: String; xPos, yPos, TextSize: Single);
Var i: Integer;
Begin
  For i := 1 To Length(Text) Do
    Begin
      Text[i] := UpCase(Text[i]);
      With ScreenChar[Byte(Text[i])] Do
        Begin
          Size := TextSize;
          Draw(xPos, yPos);
        End;
      xPos := xPos + (4 * TextSize * ScreenFactor.x);
    End;
End;

Function tGame.TextWidth(Text: String; TextSize: Single): Single;
Begin
  Result := Length(Text) * TextSize * 4;
  If (Length(Text) > 1) Then
    Result := Result - (TextSize * 2);
  Result := Result * ScreenFactor.x;
End;

Function tGame.TextHeight(TextSize: Single): Single;
Begin
  Result := TextSize * 4 * ScreenFactor.y;
End;

Procedure tGame.AddSparks(Sender: tSpaceObj);
Var i: Integer;
Begin
  For i := 1 To Settings.TrackBar_Sparks.Position Do
    Begin {anyone playing it with max. ??}
      SetLength(Spark, Length(Spark) + 1); {extend array}
      Spark[High(Spark)] := tSpark.Create(Sender); {use last index}
    End;
End;

var
    lLastRock:array[0..3] of integer=(-1,-1,-1,-1);

Procedure tGame.PecitionShot;

var
  lTestRockNr, lPickRock: Int64;
  lTestRockDist, lPickRockDist, lAngle,lPreAngle: Single;
  aShot: tShot;
  i: Integer;
  lpr: ValReal;
  vPos: TFloatPoint;

begin
  // pick a Rock (Monte Carlo Method)
  if length(Rock)>0 then
    begin
  lPickRock:= 0;
  lPickRockDist := rock[lPickRock].Pos.Summ(rock[lPickRock].speed.sMult(5)).Diff(Player.pos).pLength;
    for i := 1 to high(Rock) do
      begin
        lTestRockNr:= i;
        lTestRockDist := rock[lTestRockNr].Pos.Summ(rock[lTestRockNr].speed.sMult(5)).Diff(Player.pos).pLength ;
        if (lTestRockDist < lPickRockDist) and not ((lTestRockNr = lLastRock[0]) or (lTestRockNr = lLastRock[1]) or (lTestRockNr = lLastRock[2]) or (lTestRockNr = lLastRock[3])) then
           begin
             lPickRock := lTestRockNr;
             lPickRockDist := lTestRockDist;
           end;
      end;
  //Calc Angle
  for i := 1 to high(lLastRock) do
    lLastRock[i-1] := lLastRock[i];
  lLastRock[ high(lLastRock)] := lPickRock;
  lAngle:= Rock[lPickRock].Pos.diff(player.pos).Angle;
  // asing(sin(α) / a)
  lpr := sin(-lAngle+pi-Rock[lPickRock].speed.Diff(player.Speed).Angle)*Rock[lPickRock].speed.Diff(player.Speed).pLength*125;
  if abs(lpr)>1.0 then
    begin
      // 2. nd try
      vPos := vector(-player.speed.angle,1.4).ToPoint;
      vPos.x := round(vpos.x);
      vpos.y := round(vpos.y);
      lAngle:= Rock[lPickRock].Pos.Summ(vpos).diff(player.pos).Angle;
      lpr := sin(-lAngle+pi-Rock[lPickRock].speed.Diff(player.Speed).Angle)*Rock[lPickRock].speed.Diff(player.Speed).pLength*125;
      if abs(lpr)>1.0 then
      exit;
    end;
  With Player Do
    Begin
      Dec(Score , 10);
      Temp := Temp + 10;
    End;
  lPreAngle:=arcsin(lPr);
  // Shoot a single missle
  aShot := tShot.Create(player,pointsingle(0,0));
//  aShot.multi := 1;
  aShot.Speed := Vector(-langle+lPreAngle,1.0/125).ToPoint.Summ(player.speed);
  SetLength(Shot,Length(shot)+1);
  Shot[high(Shot)]:=aShot;
  Beep(4)
    end
end;

Procedure tGame.AddShot;
var
  i, lHighShot: Integer;
  ff: single;
  cnt: Int64;
Begin
  With Player Do
    Begin
    {forces you to aim carefully ;-)    }
      if (12*game.Player.Levels) < (trunc(temp)+10) then
        Dec(Score, 12*game.Player.Levels )
      else
        Dec(Score , (trunc(temp)+10));
      If (Temp > 2500) Then
        Exit;
      Temp := Temp + 100;
    End;
  cnt := trunc(sqrt(game.Player.Levels*2))-1;
  ff := 0.1/(cnt+1);
  SetLength(Shot, Length(Shot)+cnt+1 ); {generic insert procedure}
  lHighShot:=High(Shot);
  for i := 0 to cnt div 3 do
    begin
      if (cnt mod 3<>1) or (i<cnt div 3) then
        begin
          Shot[lHighShot] := tShot.Create(player,pointsingle(0,-0.01-I*ff));
          dec(lHighShot);
        end;
      if (cnt mod 3<>0) or (i<cnt div 3) then
        begin
         Shot[lHighShot] := tShot.Create(player,pointsingle(0.02-I*ff*0.65,0.02-I*ff));
         Shot[lHighShot-1] := tShot.Create(player,pointsingle(-0.02+I*ff*0.65,0.02-I*ff));
         dec(lHighShot,2);
      end
    end;
  Beep(5); {low beep}
End;

Procedure tGame.SplitRock(i: Integer);
Const div1000: Single = 1 / 1000;
  div0002: Single = 1 / 0002;
Var oldRock: tRock;
  Anomality: Single;
Begin
  Beep(30); {high beep}
  Inc(Player.Score, Rock[i].RockType * 12);
  oldRock := Rock[i];
  Rock[i] := Rock[High(Rock)];
  SetLength(Rock, High(Rock)); {splitted rock is removed from the list}
  If (oldRock.RockType <> 4) Then
    Begin {generations}
      Anomality := (Random - 0.5) * 2 * r360; {amount of parting drift}
      For i := 0 To 1 Do
        Begin
          SetLength(Rock, Length(Rock) + 1); {insert procedure again}
          Rock[High(Rock)] := tRock.Create;
          With Rock[High(Rock)] Do
            Begin {prepare added rock}
              Pos := oldRock.Pos;
              If (i = 0) Then
                SpeedDir := oldRock.SpeedDir + Anomality
              Else
                SpeedDir := oldRock.SpeedDir - Anomality;
              Speed.x := oldRock.Speed.x + (Sin(SpeedDir) * Cos(Anomality) *
                div1000);
              Speed.y := oldRock.Speed.y + (Cos(SpeedDir) * Cos(Anomality) *
                div1000);
              Size := oldRock.Size * div0002;
              RockType := oldRock.RockType + 1;
              If (i = 0) Then
                TurnSpeed := oldRock.TurnSpeed * (+2)
              Else
                TurnSpeed := oldRock.TurnSpeed * (-2);
            End;
        End;
    End;
  oldRock.Free;
End;

Procedure tGame.Beep(Count: Integer);
  {more count = higher beep, increase with care!}
Begin
  If (Count <= 0) Then
    Exit;
  If Settings.Box_Beep.Checked Then
    begin
    {$IFDEF MSWINDOWS}
    windows.Beep(count*20,30);
    {$ELSE}
    SysUtils.Beep;
    {$ENDIF}

    end;
//  Beep(Count - 2); {Overkill? YEAH!}
End;

Procedure tGame.PrepareIntro;
Var i: Integer;
  Distance: Single;
Begin
  SetLength(Rock, 128);
  For i := 0 To High(Rock) Do
    Begin
      Rock[i] := tRock.Create;
      Distance := Random;
      With Rock[i] Do
        Begin
          Speed.x := 0.0002 * (-1);
          Speed.y := 0;
          Size := 3 + (Distance * 4);
          ShowPos := (Random(16) <> 0);
          If ShowPos Then
            Size := 0;
        {TurnSpeed := TurnSpeed * 2;}
        End;
    End;
End;

Procedure tGame.NewGame;
Var i: Integer;
Begin
  Menu.Item[0].Caption := 'STOP GAME';
  For i := 0 To High(Rock) Do
    Rock[i].Free; {remove background}
  SetLength(Rock, 0);
  Menu.visible := False;
  Player.alive := True;
  Player.Turned := Random;
  Player.Score := 0;
  Player.Levels := -1;
End;

Destructor tGame.Destroy;
Var i: Integer;
Begin
  For i := 0 To 255 Do
    FreeAndNil(ScreenChar[i]);
  For i := 0 To High(Rock) Do
    FreeAndNil(Rock[i]);
  Rock := Nil;
  For i := 0 To High(Spark) Do
    FreeAndNil(spark[i]);
  Spark := Nil;
  For i := 0 To High(Shot) Do
    FreeAndNil(shot[i]);
  Shot := Nil;
  freeandnil(Player);
  freeandnil(Menu);
  freeandnil(Screen);
  Inherited;
End;

{MenuItem}

Procedure tMenuItem.Draw;
Var xPos, yPos, tmp: Single;
  i: Integer;
Begin
  If (Not active) Then
    Begin
      For i := 0 To High(Item) Do
        Item[i].Draw;
      Exit;
    End;
  With Game Do
    With ScreenFactor Do
      Begin
        xPos := (Screen.Width - TextWidth(Caption, 16)) * 0.5;
        tmp := TextHeight(16);
        DrawText(Caption, xPos, tmp, 16);
        yPos := tmp * 3;
        tmp := (Screen.Height - yPos - tmp) / (4 * y * ((Length(Item) * 2) -
          1));
        For i := 0 To High(Item) Do
          Begin
            xPos := (Screen.Width - TextWidth(Item[i].Caption, tmp)) * 0.5;
            If (i = SelectedItem) And Game.focused Then
              Begin
                If ((Round(Menu.BlinkCounter) Div
                  Settings.TrackBar_Blink.Position And 1)
                  <> 0) Then
                  DrawText(Item[i].Caption, xPos, yPos, tmp);
              End
            Else
              DrawText(Item[i].Caption, xPos, yPos, tmp);
            yPos := yPos + (TextHeight(tmp) * 2);
          End;
        If (Menu.BlinkCounter > -10000) Then
          Menu.BlinkCounter := Menu.BlinkCounter - Speed
        Else
          Menu.BlinkCounter := 0;
      End;
End;

Procedure tMenuItem.GetKey(Key: Word);
Var i: Integer;
Begin
  If active Then
    Begin
      Case Key Of
        VK_Up: Dec(SelectedItem);
        VK_Down: Inc(SelectedItem);
        VK_Return:
          Begin
            active := False;
            Item[SelectedItem].active := True;
          End;
        VK_Escape:
          Begin
            active := False;
            Owner.active := True;
          End;
      End;
      If (SelectedItem < 0) Then
        SelectedItem := 0;
      If (SelectedItem > High(Item)) Then
        SelectedItem := High(Item);
    End
  Else
    For i := 0 To High(Item) Do
      Item[i].GetKey(Key);
End;

Destructor tMenuItem.Destroy;
Var i: Integer;
Begin
  Caption := '';
  For i := 0 To High(Item) Do
    Item[i].Free;
  Inherited;
End;

{Menu}

Constructor tMenu.Create;
Var i: Integer;
Begin
  Inherited;
  Caption := 'ASTEROIDS';
  SetLength(Item, 5);
  For i := 0 To High(Item) Do
    Begin
      Item[i] := tMenuItem.Create;
      Item[i].Owner := Self;
    End;
  Item[0].Caption := 'NEW GAME';
  Item[1].Caption := 'OPTIONS';
  Item[2].Caption := 'HIGHSCORES';
  Item[3].Caption := 'INFO';
  Item[4].Caption := 'QUIT';
  active := True;
  visible := True;
  SelectedItem := 0;
End;

Procedure tMenu.GetKey(Key: Word);
Begin
  If active Then
    Case Key Of
      VK_Escape: visible := False;
      VK_Return:
        Begin
          Case SelectedItem Of
            0: If (Item[0].Caption[1] = 'S') Then
                Begin
                  Item[0].Caption := 'NEW GAME';
                  Game.Player.alive := False;
                  If (Game.Player.Score > 0) Then
                    Dlg_EnterName.Show;
                End
              Else
                Game.NewGame;
            1: Settings.Show;
            2: Highscores.Show;
            3: Info.Show;
            4: Main.Close;
          End;
          Exit;
        End;
    End;
  If visible Then
    Inherited;
End;

End.
