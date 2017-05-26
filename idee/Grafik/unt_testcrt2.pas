unit unt_testcrt2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  windows,
{$ELSE}
{$ENDIF}
  SysUtils,
  forms,
  Win32Crt;

procedure Execute;

implementation

Uses
  windows,
  graphics,
  math,
  Unt_CharConst;


Const
  maxanim = 2000;

Type
  TColorKmpn = Record
    Case boolean Of
      false: (c: TColor);
      true: (r, g, b, a: byte);
  End;

  TColIndex = Record
    ci: _CHAR_INFO;
    cc: TColorKmpn;
  End;

Var
  i, j, k, l, found: integer;
  cc: TColorKmpn;
  chi: _char_info;
  ColIdx: Array Of TColIndex;

Function ColorComp(c1, c2: TColorKmpn): extended;
Inline;

Var
  r, b, g: integer;
Begin
  r := abs(c1.r - c2.r);
  g := abs(c1.g - c2.g);
  b := abs(c1.b - c2.b);
  result := 1024 - (r + b + g + max(r, max(b, g))) / 1024
End;

Function ColorHash(Const c: TColorKmpn): word;
Inline;

Begin
  result := (c.r And $F8) Shr 3 Or (c.g And $F8) Shl 2 Or (c.b And $F8) Shl 7;
End;

Function hashcolor(Const h: word): TColorKmpn;
Inline;
Begin
  result.r := (h And $1F) Shl 3;
  result.g := (h And $3E0) Shr 2;
  result.b := (h And $7C00) Shr 7;
End;

Function ColorSubtr(Const c1, c2: TColorKmpn): TColorKmpn;

  Function begr(r, mi, mx: integer): integer;
    Inline;

  Begin
    If r <= mi Then
      result := mi
    Else If r > mx Then
      result := mx
    Else
      result := r;
  End;

Var
  r, b, g: integer;

Begin
  r := c1.r;
  g := c1.g;
  b := c1.b;
  r := r - c2.r;
  g := g - c2.g;
  b := b - c2.b;
  r := c1.r + r Div 4;
  G := c1.G + G Div 4;
  b := c1.b + b Div 4;
  result.r := begr(r, 0, 255);
  result.g := begr(g, 0, 255);
  result.b := begr(b, 0, 255);
End;

Type
  TchinfArr = Array Of _CHAR_INFO;

Procedure FlushScreen(Const sb: TchinfArr);

Var
  srctReadRect: TSmallRect;
  coordBufSize, coordBufCoord: TCoord;
Begin
  srctReadRect.Top := 0; // top left: row 0, col 0
  srctReadRect.Left := 0;
  srctReadRect.Bottom := 49; // bot. right: row 1, col 79
  srctReadRect.Right := 79;

  coordBufSize.x := 80;
  coordBufSize.y := 50;

  coordBufCoord.x := 0;
  coordBufCoord.y := 0;

  WriteConsoleOutput(
    console.OutHandle, // screen buffer to read from
    @sb[0], // buffer to copy into
    coordbufSize, // col-row size of chiBuffer
    coordBufCoord, // top left dest. cell in chiBuffer
    srctReadRect); // screen buffer source rectangle
End;

procedure Execute;

Var
  mb, bew: extended;
//  rc: TColorKmpn;
  istcol: Array[0..79, 0..49] Of TColorKmpn;
  hashtab: Array[0..32768] Of word;
  sb: TchinfArr;

Begin
  Try
    TextMode(co80 + font8x8);
    // init
    For I := 0 To 15 Do
      For J := 0 To 15 Do
        For K := 1 To 3 Do
          Begin
            chi.AsciiChar := filler[K];
            chi.Attributes := i + J * 16;
            Case K Of
              1:
                Begin
                  cc.r := (i And $4) * 10 + (i And $8 Div 8) * 24 + (j And $4) *
                    30 + (J And $8
                    Div 8) * 71;
                  cc.g := (i And $2) * 20 + (i And $8 Div 8) * 24 + (j And $2) *
                    60 + (J And $8
                    Div 8) * 71;
                  cc.b := (i And $1) * 40 + (i And $8 Div 8) * 24 + (j And $1) *
                    120 + (J And $8
                    Div 8) * 71;
                End;
              2:
                Begin
                  cc.r := (i And $4) * 20 + (i And $8 Div 8) * 47 + (j And $4) *
                    20 + (J And $8
                    Div 8) * 47;
                  cc.g := (i And $2) * 40 + (i And $8 Div 8) * 47 + (j And $2) *
                    40 + (J And $8
                    Div 8) * 47;
                  cc.b := (i And $1) * 80 + (i And $8 Div 8) * 47 + (j And $1) *
                    80 + (J And $8
                    Div 8) * 47;
                End
              Else
                cc.c := 0;
            End;
            // append Coloridx
            found := -1;
            For L := 0 To high(ColIdx) Do
              If cc.c = colIdx[L].cc.c Then
                Begin
                  found := L;
                  break;
                End;
            If found = -1 Then
              Begin
                setlength(colIdx, high(colidx) + 2);
                colidx[high(colidx)].ci := chi;
                colidx[high(colidx)].cc := cc;
              End;

          End;

    For I := 0 To 32767 Do
      Begin
        cc := hashcolor(i);
        mb := ColorComp(cc, ColIdx[0].cc);
        found := 0;
        For l := 1 To high(ColIdx) Do
          Begin

            bew := ColorComp(cc, ColIdx[l].cc);
            If bew > mb Then
              Begin
                mb := bew;
                chi := ColIdx[l].ci;
                found := l;
              End;
          End;
        hashtab[I] := found;
      End;
    fillchar(istcol{%H-},sizeof(istcol),byte(0));
    writeln('Press Enter to Start');
    readln;
    setlength(sb, 80 * 50);
    For I := 0 To maxanim Do
      Begin
        For J := 0 To 79 Do
          For K := 0 To 49 Do
            Begin
              If k > (i - maxanim + 50) Then
                Begin
                  cc.r := trunc(J * (1.5 + sin(I / 50) * 1.5)) + random(15);
                  cc.g := trunc((79 - J) * (1.5 + cos(I / 50) * 1.5)) +
                    random(15);
                  cc.b := K * 5 + random(10);
                End
              Else
                cc.c := clblack;
              {}If (J > 0) And (k > 0) Then
                cc := ColorSubtr(cc, istcol[j - 1, k - 1]);
              {}If J > 0 Then
                cc := ColorSubtr(cc, istcol[j - 1, k]);
              {}If k > 0 Then
                cc := ColorSubtr(cc, istcol[j, k - 1]); {}
              cc := ColorSubtr(cc, istcol[j, k]);
              {
              mb := -1;
              found := -1;
              For f := 0 To 20 Do
                Begin
                  l := random(high(ColIdx) + 1);
                  bew := ColorComp(cc, ColIdx[l].cc);
                  If bew > mb Then
                    Begin
                      mb := bew;
                      chi := ColIdx[l].ci;
                      rc := ColIdx[l].cc;
                    End;
                End; }
              chi := colidx[hashtab[colorhash(cc)]].ci;
              sb[j + k * 80] := chi;
              istcol[j, k] := colidx[hashtab[colorhash(cc)]].cc;
            End;
        FlushScreen(sb);
        delay(10);
      End;
    writeln('Press Enter ...');
    readln;
  Except
    On E: Exception Do
      Writeln(E.Classname, ': ', E.Message);
  End;
End;

end.
