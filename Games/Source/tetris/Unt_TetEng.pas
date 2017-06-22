Unit Unt_TetEng;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

Interface

Const
  PlayGroundX = 12;
  PlayGroundY = 21;

Type
  TCommandStruct = Record
    KeyLeft,
      KeyRight,
      KeyUp,
      KeyDown,
      KeyFire,
      KeyMiddle,
      KeyEsc: Procedure Of Object;
  End;

  { TTetrisEngine }

  TTetrisEngine = Class
  private
    UserQuit: Boolean;
    FNextBody: byte;
   { Aktuelle Position }
  PosX, PosY: byte;
  Body: byte;

    Procedure InitField;
    Procedure Scroll(l: byte);
    Procedure DelLine(y: byte);
    Procedure DieWork;
    Procedure PaintBody;
    Procedure PaintNextBody;
    Procedure UnPaintBody;
    Function BodyPossible(Posx, Posy: byte): boolean;
    Procedure NewBody;
    Procedure NewGame;
    Procedure CheckFullLines;

    Procedure BodyLeft;
    Procedure BodyRight;
    Procedure FallBody;
    Procedure RotateBody;
    Procedure QuitGame;

  protected
    PlayGround,
      PlayScreen: Array[0..PlayGroundX, 0..PlayGroundY] Of byte;
    NextpGround,
    NextpScreen: Array[0..6, 0..6] Of byte;

    Procedure ScoreLine(Level, Score, HighScore: Integer); virtual; abstract;
    Procedure Paint; virtual; abstract;
    Procedure Idle; virtual; abstract;
    Function HandleCmdEvent(Const CmdStruct: TCommandStruct): boolean; virtual;
      abstract;
    Procedure Sound(Freq, Duration: integer); virtual; abstract;

  public
    HighScore: longint;
    DoSound: boolean;

    Function PlayTetris:Boolean;
  End;

Implementation

{$IFnDEF FPC}
uses
  Windows; {GetTickCount}
{$ELSE}
uses
  Windows; {GetTickCount}
{$ENDIF}


{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
 kleinstes Tetris der Welt
 ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Const
  AktBackGround = 16; { Blue BackGround  }
  TransparentColour = 1; { forbidden Colour }

  EasySpeed = 110;

  DieFreq = 4;

  BodyAnz = 10;

  Bodys: Array[1..10 * 4, 1..6] Of byte =

  { | }
    ((2, $34, $54, $64, 0, 0),
     (2, $43, $45, $46, 0, 0),
     (2, $34, $54, $64, 0, 0),
     (2, $43, $45, $46, 0, 0),
    { J }
    (3, $34, $54, $53, 0, 0),
    (3, $43, $45, $55, 0, 0),
    (3, $34, $35, $54, 0, 0),
    (3, $33, $43, $45, 0, 0),
    { L }
    (4, $34, 16 * 2 + 4, $45, 0, 0),
    (4, $43, $45, 16 * 3 + 5, 0, 0),
    (4, $54, $34, 16 * 3 + 3, 0, 0),
    (4, 16 * 5 + 3, $43, $45, 0, 0),
    { x }
    (5, $45, $35, $34, 0, 0),
    (5, $45, $35, $34, 0, 0),
    (5, $45, $35, $34, 0, 0),
    (5, $45, $35, $34, 0, 0),
    { 2 }
    (6, $34, $45, $55, 0, 0),
    (6, $43, $34, $35, 0, 0),
    (6, $34, $45, $55, 0, 0),
    (6, $43, $34, $35, 0, 0),
    { s }
    (7, $34, $43, 16 * 5 + 3, 0, 0),
    (7, $43, $54, 16 * 5 + 5, 0, 0),
    (7, $34, $43, 16 * 5 + 3, 0, 0),
    (7, $43, $54, 16 * 5 + 5, 0, 0),
    { T }
    (12, $43, $45, $34, 0, 0),
    (12, $43, $34, $54, 0, 0),
    (12, $43, $54, $45, 0, 0),
    (12, $34, $54, $45, 0, 0),
//3
    (13, $34, $43, 0, 0, 0),
    (13, $43 ,$54, 0, 0, 0),
    (13, $54, $45, 0, 0, 0),
    (13, $45 ,$34, 0, 0, 0),
    { * }
    (11, 16 * 3 + 3, 0, 0, 0, 0),
    (11, 16 * 5 + 3, 0, 0, 0, 0),
    (11, 16 * 5 + 5, 0, 0, 0, 0),
    (11, 16 * 3 + 5, 0, 0, 0, 0),
    { . }
    (09, 0, 0, 0, 0, 0),
    (09, 0, 0, 0, 0, 0),
    (09, 0, 0, 0, 0, 0),
    (09, 0, 0, 0, 0, 0)
    );

Var


  eog: boolean;
  Die: word;
  FallFreq: word;
  Fall: word;

  MyTick: longint;
  Score: longint;

procedure TTetrisEngine.InitField;
Var
  x, y: byte;
Begin
  For y := 1 To PlayGroundY Do
    For x := 1 To PlayGroundX Do
      Begin
        PlayGround[x, y] := 0;
        PlayScreen[x, y] := 255;
      End;
End;

procedure TTetrisEngine.Scroll(l: byte);
Var
  x, y: byte;
Begin
  For y := l Downto 2 Do
    For x := 1 To PlayGroundX Do
      PlayGround[x, y] := PlayGround[x, pred(y)];
  For x := 1 To PlayGroundX Do
    PlayGround[x, 1] := 0;
End;

procedure TTetrisEngine.DelLine(y: byte);
Var
  x: byte;
Begin
  For x := 1 To PlayGroundX Do
    PlayGround[x, y] := (PlayGround[x, y] Mod 16) + 3 * 16;
  inc(Score, y * 10 * succ(EasySpeed - FallFreq));
  If FallFreq > 10 Then
    Begin
      If random(7) = 0 Then
        dec(FallFreq, 10);
    End;

  ScoreLine((EasySpeed-FallFreq) div 10 +1,Score,HighScore);
End;

procedure TTetrisEngine.DieWork;
Var
  x, y, d: byte;
Begin
  For y := 1 To PlayGroundY Do
    If (PlayGround[1, y] Mod 16 > 0) And (PlayGround[1, y] Div 16 < 4) Then
      Begin
        d := PlayGround[1, y] Div 16;
        If d = 0 Then
          Begin
            scroll(y);
            //     nosound;
          End
        Else
          Begin
            If DoSound Then
              sound(40 + random(100) * d, 10);
            For x := 1 To PlayGroundX Do
              PlayGround[x, y] := (PlayGround[x, y] Mod 16) + pred(d) * 16;
          End;
      End;
End;

procedure TTetrisEngine.PaintBody;
Var
  c: byte;
  p: byte;
Begin
  c := Bodys[body, 1] + 16 * 4;
  PlayGround[PosX, PosY] := c;
  For p := 2 To 6 Do
    Begin
      If Bodys[body, p] = 0 Then
        break;
      PlayGround[integer(PosX) + integer(Bodys[body, p] Mod 16) - 4,
        integer(PosY) + integer(Bodys[body, p] Div 16) - 4] := c;
    End;
End;

procedure TTetrisEngine.PaintNextBody;
Var
  c: byte;
  p: byte;
begin
  fillchar(NextpGround,sizeof(NextpGround),0);
    c := Bodys[FNextBody, 1] + 16 * 4;
    NextpGround[3, 3] := c;
    For p := 2 To 6 Do
      Begin
        If Bodys[FNextBody, p] = 0 Then
          break;
        NextpGround[integer(3) + integer(Bodys[FNextBody, p] Mod 16) - 4,
          integer(3) + integer(Bodys[FNextBody, p] Div 16) - 4] := c;
      End;
End;

procedure TTetrisEngine.UnPaintBody;
Var
  p: byte;
Begin
  PlayGround[PosX, PosY] := 0;
  For p := 2 To 6 Do
    Begin
      If Bodys[body, p] = 0 Then
        break;
      PlayGround[integer(PosX) + integer(Bodys[body, p] Mod 16) - 4,
        integer(PosY) + integer(Bodys[body, p] Div 16) - 4] := 0;
    End;
End;

function TTetrisEngine.BodyPossible(Posx, Posy: byte): boolean;
Var
  p: byte;
  x, y: integer;
Begin
  BodyPossible := false;
  If (PosX < 1) Or (PosX > PlayGroundX) Then
    exit;
  If (PosY < 1) Or (PosY > PlayGroundY) Then
    exit;
  If PlayGround[PosX, PosY] Mod 16 > 0 Then
    exit;
  For p := 2 To 6 Do
    Begin
      If Bodys[body, p] = 0 Then
        break;

      x := integer(PosX) + integer(Bodys[body, p] Mod 16) - 4;
      If (x < 1) Or (x > PlayGroundX) Then
        exit;

      y := integer(PosY) + integer(Bodys[body, p] Div 16) - 4;
      If (y < 1) Or (y > PlayGroundY) Then
        exit;

      If PlayGround[x, y] Mod 16 > 0 Then
        exit;
    End;
  BodyPossible := true;
End;

procedure TTetrisEngine.FallBody;
Var
  y: byte;
Begin
  For y := PosY To succ(PlaygroundY) Do
    If Not (BodyPossible(PosX, y)) Then
      Begin
        PosY := pred(y);
        break;
      End;
End;

procedure TTetrisEngine.NewBody;

Begin
  body := FNextBody;
  FNextBody := succ(random(BodyAnz) * 4);
  PaintNextBody;
  If BodyPossible(PlayGroundX Div 2, 3) Then
    Begin
      PosX := PlayGroundX Div 2;
      PosY := 3;
    End
  Else
    Begin
      If Score > HighScore Then
        HighScore := Score;
      Eog := true;
    End;
End;

procedure TTetrisEngine.NewGame;
Begin
  InitField;
  FallFreq := EasySpeed;
  Die := DieFreq;
  Fall := FallFreq;
  Score := 0;
  FNextBody := succ(random(BodyAnz) * 4);
  NewBody;
  ScoreLine(1,0,HighScore);
End;

procedure TTetrisEngine.CheckFullLines;
Var
  x, y: byte;
  full: boolean;
  p: byte;
Begin
  For p := 2 To 6 Do
    Begin
      If Bodys[body, p] = 0 Then
        y := PosY
      Else
        y := integer(PosY) + integer(Bodys[body, p] Div 16) - 4;

      full := true;
      For x := 1 To PlayGroundX Do
        Begin
          If (PlayGround[x, y] Div 16 <> 4) Then
            full := false;
        End;
      If full Then
        DelLine(y);

      If Bodys[body, p] = 0 Then
        break;

    End;
End;

function TTetrisEngine.PlayTetris: Boolean;

Var
  CmdStruct: TCommandStruct;

Begin
  UserQuit:=False;
  //smart_window(pred(40-PlayGroundX),2,PlayGroundX*2,PlayGroundY,'Teddies');
  With cmdstruct Do
    Begin
      KeyLeft := BodyLeft;
      KeyRight := BodyRight;
      KeyUp := RotateBody;
      KeyMiddle:=RotateBody;
      KeyDown := FallBody;
      KeyFire := FallBody;
      KeyEsc := QuitGame;
    End;

  NewGame;
  eog := false;
  MyTick := GetTickCount;
  Repeat

    { wait for next tick }
    dec(Die);
    dec(Fall);

    MyTick := GetTickCount;

    UnPaintBody;

    HandleCmdEvent(CmdStruct);

    If fall = 0 Then
      Begin
        Fall := FallFreq;
        If BodyPossible(PosX, succ(PosY)) Then
          Begin
            inc(PosY);
          End
        Else
          Begin
            PaintBody;
            CheckFullLines;
            NewBody;
          End;
      End;

    If Die = 0 Then
      Begin
        Die := DieFreq;
        DieWork;
      End;

    PaintBody;
    paint;

    While GetTickCount - mytick <= 10 Do
      Begin
        Idle;
      End;

  Until eog;
  result:=NOT userquit;
End;

procedure TTetrisEngine.QuitGame;
Begin
  eog := true;
  UserQuit := true;
End;

procedure TTetrisEngine.BodyLeft;
Begin
  If BodyPossible(pred(PosX), PosY) Then
    dec(PosX);
End;

procedure TTetrisEngine.RotateBody;
var
  _body: Byte;
Begin
  _body := body;
  inc(body);
  If (body Mod 4) = 1 Then
    body := body - 4;
  If Not (BodyPossible(PosX, PosY)) Then
    body := _body;
End;

procedure TTetrisEngine.BodyRight;
Begin
  If BodyPossible(succ(PosX), PosY) Then
    inc(PosX);
End;

End.

