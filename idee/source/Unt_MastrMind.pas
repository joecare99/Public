unit Unt_MastrMind;

interface

procedure Execute;

implementation

uses win32crt;

Var
//  b: Array[0..10000] Of word;
//  banz: word;
  c: Array[0..35] Of integer;

Const am: Array[0..4] Of word = ($0007, $0038, $01C0, $0E00, $7000);
  sm: Array[0..4] Of word = ($0000, $0008, $0040, $0200, $1000);

Function compare(k1, k2: word): byte; inline;

Var test: word;
  i, j, pl, gl: byte;

Begin
  test := 0;
  gl := 0;
  Pl := 0;
  For i := 0 To 4 Do
    If (k1 And am[i]) = (k2 And am[i]) Then
      Begin
        inc(gl);
        test := test Or am[i];
      End;
  For i := 0 To 4 Do
    If (test And am[i]) = 0 Then
      For j := 0 To 4 Do
        If (j <> i) And
          ((test And am[j]) = 0) And
          (((k1 And am[i]) Shr (i * 3)) = ((k2 And am[j]) Shr (J * 3))) Then
          Begin
            inc(pl);
            test := test Or am[j];
          End;
  compare := (gl * 6) + pl
      // 0 ; 6 ; 11 ; 15 ; 18 ; 20 ;
End;

Function Oct(wert: integer): String;inline;
Const cc: Array[0..7] Of char = '01234567';
Var i, w: integer;
Begin
  result := '';
  I := 0;
  While i < 5 Do
    Begin
      w := (wert And am[i]) Shr (i * 3);
      result := result + cc[w];
      inc(i);
    End;
End;

procedure Execute;
Var CTest, Komb, i: integer;
  TWert, KWert, Mwert: real;

Const maxtest = 32768;

Begin
 // Komb := 0;
  Mwert := 0;
  Kwert := 1200000;
  randomize;
  For Ctest := 0 To maxtest - 1 Do
    Begin
    //CTest := Random(32768);
      fillchar(c, sizeof(c), 0);
      For i := 0 To maxtest - 1 Do
        inc(c[compare(CTest, i)]);
      TWert := 0;
      For i := 0 To 30 Do
        If (i Mod 6) + (i Div 6) < 6 Then
          TWert := TWert + abs((maxtest Div 20) - c[i])
        Else If c[i] <> 0 Then
          break;
      If TWert < Kwert Then
        Begin
          Kwert := TWert;
          Komb := CTest;
          writeln(Oct(Komb), '  ', Kwert: 6: 0);
        End
      Else If TWert > Mwert Then
        Begin
          Mwert := TWert;
          writeln(Oct(Ctest), '  ', Mwert: 6: 0,' Max');
        End
      Else
        if (ctest mod 60)=0 then

        write(Oct(Ctest), '  ', Twert: 6: 0,
          #8#8#8#8#8#8#8#8#8#8#8#8#8#8#8#8#8#8);
    End;
//  Until keypressed or (Kwert < trunc(maxtest));
  writeln('Ende ............');
  readln;
  end;
end.
