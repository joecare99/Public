unit Unt_Pig2;

interface

Procedure Execute;

implementation

{$I Jedi.inc}

uses
  windows;

Type scrnz = ^scrnt;
  scrnt = Record
    Offset: byte;
    {$ifdef DEFAULTS_WIDESTRING}
    Data: String;
    {$Else ~DEFAULTS_WIDESTRING}
    Data: String[11];
    {$EndIF ~DEFAULTS_WIDESTRING}
  End;

Const PigDef: Array[1..5, 1..5] Of scrnt =
  (((Offset: 4; data: '^ÄÄÄ\'),
    (Offset: 2; data: 'Ý>     ³ <'),
    (Offset: 1; data: '[[      \-/'),
    (Offset: 3; data: '\()_()/'),
    (Offset: 5; data: 'W W')),
    ((Offset: 4; data: '^Ä^ÄÄ\'),
    (Offset: 3; data: '/™™    ³>'),
    (Offset: 3; data: '[)     ³'),
    (Offset: 3; data: '\()__()/'),
    (Offset: 5; data: 'WWWW')),
    ((Offset: 4; data: '^ÄÄÄ^'),
    (Offset: 3; data: '/ ™ ™ \'),
    (Offset: 3; data: '³  0  ³'),
    (Offset: 3; data: '\()_()/'),
    (Offset: 5; data: 'W W')),
    ((Offset: 3; data: '/ÄÄ^Ä^'),
    (Offset: 1; data: '<³    ™™\'),
    (Offset: 2; data: '³     (]'),
    (Offset: 2; data: '\()__()/'),
    (Offset: 4; data: 'WWWW')),
    ((Offset: 4; data: '/ÄÄÄ^'),
    (Offset: 1; data: '> ³     <Ý '),
    (Offset: 1; data: '\-/      ]]'),
    (Offset: 3; data: '\()_()/'),
    (Offset: 5; data: 'W W')));
  go: Array[1..4] Of scrnt =
  ((Offset: 5; data: 'W W'),
    (Offset: 4; data: ' "  W'),
    (Offset: 4; data: '"   "'),
    (Offset: 4; data: 'W  "'));

Var x, i, k: integer;
  OutHandle: THandle;

Procedure sauinit;

Var j: integer;

Begin
  // Hole Hintergrund
End;

Procedure sau;

Var j, y, size: integer;
  lastXY, Coord: _Coord;
  consoleInfo: _console_Screen_buffer_info;
  Double: DWORD;

Begin
  size := 2;
  GetConsoleScreenBufferInfo(OutHandle, ConsoleInfo);
  LastXY := TCoord(ConsoleInfo.dwCursorPosition);
  If ((i > 1) And (x > 66)) Or ((i < 5) And (x < 1)) Then
    Begin
      If (x > 40) Then
        dec(i)
      Else
        inc(i);
      k := 1;
      For y := 1 To 5 Do
        Begin
          Coord.Y := Y - 1;
          For J := 0 To length(pigdef[i, y].Data) + 1 Do
            Begin
              Coord.x := x + j - 1 + pigdef[i, y].Offset;
              FillConsoleOutputCharacter(OutHandle, copy(' ' + pigdef[i, y].data
                + ' ', j + 1, 1)[1], Size,
                Coord, Double);
            End;
        End;
      k := 1;
    End
  Else
    Begin
      If i < 2 Then
        Begin
          x := x - 1;
          k := k Mod 4 + 1;
        End;
      If i > 4 Then
        Begin
          x := x + 1;
          k := (k + 2) Mod 4 + 1;
        End;
      For y := 1 To 4 Do
        Begin
          Coord.Y := Y - 1;
          For J := 0 To length(pigdef[i, y].Data) + 1 Do
            Begin
              Coord.x := x + j - 1 + pigdef[i, y].Offset;
              FillConsoleOutputCharacter(OutHandle, copy(' ' + pigdef[i, y].data
                + ' ', j + 1, 1)[1], Size,
                Coord, Double);
            End;
        End;
      Coord.Y := 5 - 1;
      For J := 0 To length(go[k].data) + 1 Do
        Begin
          Coord.x := x + j - 1 +go[k].Offset;
          FillConsoleOutputCharacter(OutHandle, copy(' ' + go[k].Data + ' ', j + 1,
            1)[1], Size, Coord,
            Double);
        End;
    End;
  SetConsoleCursorPosition(OutHandle, lastXY);
End;

Var t: byte;
  t2: longint;

Procedure timerTimer(sender: Tobject);

Begin
  t := t Mod 3 + 1;
  If t2 > 0 Then
    dec(t2);
  If (t2 = 1) Then
    sauinit;
  If (t = 1) And (t2 = 0) Then
    sau;
End;

Procedure Execute;

Var er: integer;
  Input: TInputRecord;
  dw: DWord;
  cmdl: String[255];
Begin

  OutHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  t := 1;
  i := 1;
  k := 1;
  x := 35;
  If paramcount <> 0 Then
    val(paramstr(1), t2, er)
  Else
    t2 := 0;
  If (paramcount <> 2) Or (paramstr(2) <> 'DoIt' + chr(253)) Then
    Begin
      cmdl := paramstr(0) + ' 0' + paramstr(1) + ' DoIt' + chr(253);
    {$ifdef DEFAULTS_WIDESTRING}
      winexec(pAnsichar(cmdl[1]), 0);
    {$Else ~DEFAULTS_WIDESTRING}
      winexec(pchar(cmdl), 0);
    {$Endif ~DEFAULTS_WIDESTRING}

      sleep(50);
    End
  Else
    Begin
      t2 := t2 * 18;
      While true Do
        Begin
          sleep(50);
          timertimer(Nil);
        End;
    End;
End;
end.
