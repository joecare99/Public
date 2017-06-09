Unit frm_laby4;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

Interface

Uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,  Buttons, StdCtrls;

Type
  TForm2 = Class(TForm)
    BitBtn1: TBitBtn;
    PaintBox1: TPaintBox;
    PaintBox2: TPaintBox;
    BitBtn2: TBitBtn;
    Procedure BitBtn1Click(Sender: TObject);
    Procedure BitBtn2Click(Sender: TObject);
  Private
    Clen: integer;
    FZValues: Array Of Array Of integer;
    { Private-Deklarationen }
  Public
    { Public-Deklarationen }
  End;

Var
  Form2: TForm2;

Implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

Procedure TForm2.BitBtn1Click(Sender: TObject);
  Var
    x, y, rr: integer;
  Begin
    Clen := 20;
    rr := random(3) + 2;
    Randomize;
    setlength(FZValues, Clen, Clen);
    // rohdaten
    For x := 0 To Clen - 1 Do
      For y := 0 To Clen - 1 Do
        Begin
          FZValues[x, y] := x + y + random(rr);
          If (x >= 1) And (FZValues[x, y] < FZValues[x - 1, y] - 1) Then
            FZValues[x, y] := FZValues[x - 1, y] - 1;
          If (y >= 1) And (FZValues[x, y] < FZValues[x, y - 1] - 1) Then
            FZValues[x, y] := FZValues[x, y - 1];
          If (y >= 1) And (x >= 1) And
            (FZValues[x, y] < FZValues[x - 1, y - 1] - 1) Then
            FZValues[x, y] := FZValues[x - 1, y - 1] - 1;
        End;
    // nicht verbundene zellen
    For x := 0 To Clen - 1 Do
      For y := 0 To Clen - 1 Do
        Begin
      //    c := 0;
          If (x >= 1) And (abs(FZValues[x, y] - FZValues[x - 1, y]) < 2) And
            (x < Clen - 1) And (abs(FZValues[x, y] - FZValues[x + 1, y]) < 2)
            And (y >= 1) And (abs(FZValues[x, y] - FZValues[x, y - 1]) < 2) And
            (y < Clen - 1) And (abs(FZValues[x, y] - FZValues[x, y]) < 2) Then
            Begin
              If abs(x - (Clen Div 2)) > abs(y - (Clen Div 2)) Then
                If x > Clen Div 2 Then
                  FZValues[x, y] := FZValues[x - 1, y] + 1
                Else
                  FZValues[x, y] := FZValues[x + 1, y] - 1
              Else If y > Clen Div 2 Then
                FZValues[x, y] := FZValues[x, y - 1] + 1
              Else
                FZValues[x, y] := FZValues[x, y + 1] - 1;

            End;

        End;
    For x := 0 To Clen - 1 Do
      For y := 0 To Clen - 1 Do
        Begin
          PaintBox2.Canvas.Brush.Color :=
            rgb(FZValues[x, y] * 4, FZValues[x, y] * 4, FZValues[x, y] * 5);
          PaintBox2.Canvas.FillRect(Rect(x * 10, y * 10, (x + 1) * 10,
            (y + 1) * 10));
          If (x >= 1) And (abs(FZValues[x, y] - FZValues[x - 1, y]) < 2) Then
            Begin
              PaintBox2.Canvas.pen.Color := clwhite;
              PaintBox2.Canvas.moveto(x * 10 + 5, y * 10 + 5);
              PaintBox2.Canvas.Lineto(x * 10 - 5, y * 10 + 5);

            End;
          If (y >= 1) And (abs(FZValues[x, y] - FZValues[x, y - 1]) < 2) Then
            Begin
              PaintBox2.Canvas.pen.Color := clwhite;
              PaintBox2.Canvas.moveto(x * 10 + 5, y * 10 + 5);
              PaintBox2.Canvas.Lineto(x * 10 + 5, y * 10 - 5);

            End;

        End;
  End;

Procedure TForm2.BitBtn2Click(Sender: TObject);

    Procedure Drawbox(x, y, z: integer);
      Var
        x2, y2, L: integer;
        pts: Array Of TPoint;
      Begin
        L := PaintBox1.Canvas.ClipRect.Right Div 80;
        x2 := (20 - x + y) * L * 2;
        y2 := PaintBox1.Canvas.ClipRect.bottom - (x + y + z + 2) * L;
        setlength(pts, 4);
        pts[0] := point(x2, y2);
        PaintBox1.Canvas.Brush.Color := clLtGray;
        PaintBox1.Canvas.pen.Color := clLtGray;
        pts[1] := point(x2 - L * 2, y2 - L);
        pts[2] := point(x2 - L * 2, y2);
        pts[3] := point(x2, y2 + L);
        PaintBox1.Canvas.Polygon(pts);
        // PaintBox1.Canvas.PolyLine(pts);
        PaintBox1.Canvas.Brush.Color := clDkGray;
        // PaintBox1.Canvas.pen.Color := PaintBox1.Canvas.Brush.Color;
        pts[1] := point(x2 + L * 2, y2 - L);
        pts[2] := point(x2 + L * 2, y2);
        pts[3] := point(x2, y2 + L);
        PaintBox1.Canvas.Polygon(pts);
        PaintBox1.Canvas.Brush.Color := clwhite;
        // PaintBox1.Canvas.pen.Color := PaintBox1.Canvas.Brush.Color;
        pts[1] := point(x2 + L * 2, y2 - L);
        pts[2] := point(x2, y2 - L * 2);
        pts[3] := point(x2 - L * 2, y2 - L);
        PaintBox1.Canvas.Polygon(pts);
        // PaintBox1.Canvas.PolyLine(pts);

      End;

  Var
    x, y, z: integer;

  Begin
    PaintBox1.Canvas.Brush.Color := Color;
    PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
    For z := 0 To 44 Do
      For x := Clen - 1 Downto 0 Do
        For y := Clen - 1 Downto 0 Do
          If (FZValues[x, y] >= z) And
            ((x = 0) Or (y = 0) Or (z > x + y - 2)) Then
            Drawbox(x, y, z);

  End;

End.
