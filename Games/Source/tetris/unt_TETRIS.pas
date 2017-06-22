unit unt_TETRIS;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  windows,
{$ELSE}
{$ENDIF}
  sysutils,
  win32crt, {From Compatible}
  Unt_TetEng;

Type
  TTetris = Class(TTetrisEngine)
  protected
    Procedure ScoreLine(Level, Score, HighScore: integer); override;
    Procedure Paint; override;
    Function HandleCmdEvent(Const CmdStruct: TCommandStruct): boolean; override;
    procedure Idle; override;
    procedure Sound(Freq, Duration: Integer); override;
  End;

Procedure Execute;
{$define Playset2}
implementation
  
Const
{$ifNdef Playset2}
  PlayChars: String[5] = ' ±'#218#219; { Body-Chars }
  PlayChars2: String[4] = ' '#216#220#219; { Half-Chars }
{$else}
  PlayChars: String{[5]} = ' ++[####'; { Body-Chars }
  PlayChars2: String{[4]} = ' m*#'; { Half-Chars }
{$endif}

  col_normal = 7;

  KNO = #0;
  KESC = #27;
  KSPACE = #32;
  KLEFT = #37;
  KRIGHT = #39;
  KDOWN = #41;
  KUP = #34;

Procedure WriteXY(x, y: integer; text: String);

Begin
  gotoxy(x, y);
  write(text);
End;

Procedure TTetris.ScoreLine(Level, Score, HighScore: integer);

Begin
  textcolor(col_normal);
  writexy(2, 23, ' ' + inttostr(Level) +
    ':' + inttostr(Score) +
    ' (' + inttostr(HighScore) + ') ');
End;

procedure TTetris.Sound(Freq, Duration: Integer);
begin
  if Duration<30 then
    Duration:=30;
  win32crt.sound(freq,Duration);
end;

procedure TTetris.Idle;
begin
  delay(3);
end;

Procedure TTetris.paint;
Var
  x, y: byte;
  m: byte;
Begin
  For y := 1 To PlayGroundY Do
      For x := 1 To PlayGroundX Do
        Begin
          If PlayGround[x, y] <> PlayScreen[x, y] Then
            Begin
              { Situation changed! }
              m := PlayGround[x, y];

              { Farbe! }
              textcolor(m Mod 16);

              { Zeichen! }
              writexy(x*2-1,y,PlayChars[succ(m Div 16)]);
              writexy(x * 2, y, PlayChars[succ(m Div 16)]);

              { Update! }
              PlayScreen[x, y] := PlayGround[x, y];
            End;
        End;

  For y := 0 To 6 Do
    For x := 0 To 6 Do
      Begin
        If NextpGround[x, y] <> NextpScreen[x, y] Then
          begin
             { Situation changed! }
              m := NextpGround[x, y];

              { Farbe! }
              textcolor(m Mod 16);

              { Zeichen! }
              writexy(40+x*2,y+1,PlayChars[succ(m Div 16)]);
              writexy(41+x * 2, y+1, PlayChars[succ(m Div 16)]);

              { Update! }
              NextpScreen[x, y] := NextpGround[x, y];
            End;
          end;
End;

function TTetris.HandleCmdEvent;
Var
  ExitKey, ch2: Char;

Begin
  result := false;
  If keypressed Then
    Begin
      result := true;
      ExitKey := readkey;
      If (ExitKey = KNO) And keypressed Then
        ch2 := readkey;

      Case ExitKey Of
        KNO: Case ch2 Of
            KLEFT: cmdStruct.KeyLeft;
            KRIGHT: cmdStruct.KeyRight;
            KUP: CmdStruct.KeyUp;
            KDOWN: CmdStruct.KeyDown
            Else
              result := false;
          End;
        '4': cmdStruct.KeyLeft;
        '6': cmdStruct.KeyRight;
        '8': cmdstruct.KeyUp;
        '5': CmdStruct.KeyMiddle;
        KSPACE: CmdStruct.KeyFire;
        '2': CmdStruct.KeyDown;
        KESC: CmdStruct.KeyEsc;
        's': DoSound := Not (DoSound)
        Else
          result := false;
      End;
    End;

End;

Procedure Execute;

Var
  CTetris: TTetris;
  Cont: Boolean;

Begin
  CTetris := TTetris.Create;
  Repeat
    cont := CTetris.PlayTetris;
    If Cont Then
      Begin
        textcolor(15);
        writexy(2, 2, ' G A M E   O V E R ');
        cont := readkey <> KESC;
      End
  Until Not Cont;
End;
End.

