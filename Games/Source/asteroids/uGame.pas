Unit uGame;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

Interface
Uses {$IFDEF MSWINDOWS} windows,  {$ELSE}   {$ENDIF}
     {$IFDEF FPC} LCLIntf, LCLType,  {$ENDIF} Classes, Graphics; {Graphics MUST follow Windows}

{ $DEFINE ShowEdgeLines}{!!! ONLY for debugging !!!}
{ $DEFINE test}{!!! ONLY for debugging !!!}

Const RadCon = Pi / 180;
  r045: Single = RadCon * 045;
  r360: Single = RadCon * 360;
  RockAnomaly: Single = 0.25; {zero = spheres}

Type tPointSingle = Record
    x, y: Single;
  End;

  tVector = Record
    Direction, Distance: Single;
  End;

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
    Pos, Speed: tPointSingle;
    Turned, TurnSpeed: Single;
    Edge: Array Of tVector;
    PointSingle: Array Of tPointSingle;
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

  tShot = Class(tSpark) {spark + altered size, speed & counter}
    constructor Create(Sender: tPlayer; offset: tPointSingle);
    Procedure Update;
  End;

  tGame = Class
    Screen: tBitmap;
    Speed: Single; {should be 1}
    ScreenFactor: tPointSingle;
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
    Procedure SplitRock(i: Integer);
    Procedure Beep(Count: Integer);
    Procedure PrepareIntro;
    Procedure NewGame;
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

Function PointSingle(x,y:single):tPointSingle;inline;
begin
  result.x:=x;
  result.y:=y;
end;

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

Function PointInPoly(Pos: tPointSingle; Point: Array Of tPointSingle): Boolean;
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

Function Collision(Pos: tPointSingle; TestObj: tSpaceObj): Boolean;
Var x, y: Integer;
  tmpPos: tPointSingle;
Begin
  Result := False;
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
Var Movement: tPointSingle;
Begin
  If Settings.Box_FirstP.Checked Then
    Begin {add player's speed}
      If (Self <> Game.Player) Then
        With Game.Player.Speed Do
          Begin
            Movement.x := Speed.x - x;
            Movement.y := Speed.y - y;
          End;
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
  tmpPos: tPointSingle;
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

Constructor tShot.Create(Sender:tPlayer;offset:tPointSingle);
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
  pos.x := pos.x + c*offset.x - s*offset.y;
  pos.Y := pos.y + c*offset.y + s*offset.x;
  Speed.x := Sender.Speed.x + (s * div0125);
  Speed.y := Sender.Speed.y + (c * div0125);
  Counter := 120;
  Size := 1.5;
End;

Procedure tShot.Update;
Var i: Integer;
  tmpPos: tPointSingle;
Begin
  Inherited;
  tmpPos.x := Pos.x * Game.Screen.Width; {get pos. on screen and check the rocks}
  tmpPos.y := Pos.y * Game.Screen.Height;
  For i := 0 To High(Game.Rock) Do
    If Collision(tmpPos, Game.Rock[i]) Then
      Begin
        If (Length(Game.Rock) > 1) Or
          (Game.Rock[0].RockType <> 4) Then
          Game.AddSparks(Self);
        Game.SplitRock(i);
        Counter := 0;
        Break;
      End;
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
      {$ifdef FPC}
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

Procedure tGame.AddShot;
var
  i: Integer;
  ff: single;
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
  ff := 0.03/game.Player.Levels;
  for i := 0 to game.Player.Levels-1 do
    begin
  SetLength(Shot, Length(Shot) + 3); {generic insert procedure}
  Shot[High(Shot)-2] := tShot.Create(player,pointsingle(0,-0.01-I*ff));
  Shot[High(Shot)-1] := tShot.Create(player,pointsingle(0.02-I*ff*0.65,0.02-I*ff));
  Shot[High(Shot)] := tShot.Create(player,pointsingle(-0.02+I*ff*0.65,0.02-I*ff));
    end;
  Beep(1); {low beep}
End;

Procedure tGame.SplitRock(i: Integer);
Const div1000: Single = 1 / 1000;
  div0002: Single = 1 / 0002;
Var oldRock: tRock;
  Anomality: Single;
Begin
  Beep(2); {high beep}
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
  If (Count = 0) Then
    Exit;
  If Settings.Box_Beep.Checked Then
    begin
    {$IFDEF MSWINDOWS}
    MessageBeep($FFFFFFFF);
    {$ELSE}
    SysUtils.Beep;
    {$ENDIF}

    end;
  Beep(Count - 1); {Overkill? YEAH!}
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
