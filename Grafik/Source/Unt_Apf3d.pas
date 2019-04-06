{$R-} {Range checking off}
{$B+} {Boolean complete evaluation on}
{$S+} {Stack checking on}
{$I+} {I/O checking on}

(****************************************************************)
(*                                                              *)
(*                 Grafik mit Turbo-Pascal                      *)
(*                     W. Kassera 1987                          *)
(*       Apfelmannbilder 2D oder 3D:    mit  setgraphmode (grm)-Modus        *)
(*                                                              *)
(****************************************************************)
(*                                                              *)
unit Unt_Apf3d;  {Apfelmann2D_3D}

interface

procedure Execute;

implementation

uses
  graph ,
  Win32Crt ,
  int_Graph ;

{Unit found in GRAPH3.TPU}

Type
  Name = String[20];
  werttype = Record
    x, y: real;
    wert: word;
  End;
Const
  schranke: Integer = 100;
Var
  grm, grk, rand, anzahl, anfang, count, n, i, j: Integer;
  DeltaP, DeltaQ, Pmax, Pmin, Qmax, Qmin: Real;
  DateiName: Name;
  ch: Char;
  graf: boolean;

Var Blockdatei: File Of werttype;

Procedure Grenzen(PTeiler, QTeiler: Integer);
Begin
  ClrScr;
  WriteLn('Apfelm„nnchen - beliebiger Ausschnitt'#10#10#13);
  Write('Grenze Pmin (Realteil horizontal)  : ');
  ReadLn(Pmin);
  Write('Grenze Pmax                        : ');
  ReadLn(Pmax);
  Write(#10#13, 'Grenze Qmin (ImagTeil vertikal)    : ');
  ReadLn(Qmin);
  Qmax := (Pmax - Pmin) + Qmin;
  Write('Grenze Qmax                        : ');
  WriteLn(Qmax: 1: 6);
  Write('Rechentiefe: ');
  ReadLn(count);
  Write('Randzahl:    ');
  ReadLn(rand);
  Write('Dateiname:   ');
  readln(dateiname);
  DeltaP := (Pmax - Pmin) / PTeiler;
  DeltaQ := (Qmax - Qmin) / Qteiler;
End;

Procedure Zeichnen;
Var X0, Y0, x, y: Real;
Var i, j: integer;
Begin
  ClrScr;
  setgraphmode(grm);
  graf := true;
  setgraphmode(grm);
  For i := 0 To 499 Do
    Begin
      If Not KeyPressed Then
        For j := 0 To getmaxy Do
          Begin
            X0 := pmin + i * Deltap;
            Y0 := qmin + j * Deltaq;
            n := 0;
            Repeat
              inc(n);
              x := SQR(x0) - sqr(y0) - {(pmin+i*Deltap+} 0.03;
              y := 2 * x0 * y0 + {qmin+j*Deltaq+} 1;
              x0 := x;
              y0 := y;
            Until (sqr(x) {)+SQR(y)} > schranke) Or (n >= count);
            If (n = count) Then
              Begin
                putpixel(i, j, 0);
              End
            Else
              putpixel(i, j, n Mod 8 + ((n Div 2) Mod 2) * 8);
          End;
    End;
End;

Procedure Zeichnen3D;

  Procedure farbline(x1, y1, x2, y2, dn, fp: integer);

  Var dx, dy, ddy: integer;

  Begin
    If y1 > y2 Then
      ddy := -1
    Else
      ddy := 1;
    dy := y1;
    While dy <> y2 Do
      Begin
        If dy * ddy > ((y1 + y2) * ddy) Div 2 Then
          dx := x2
        Else
          dx := x1;
        putpixel(dx, dy, (abs(dy - dn) Div 4 Mod 8 + fp));
        dy := dy + ddy;
      End;
  End;

Var X0, Y0, x, y, faktor, fak2: Real;
  base, i, j, n, kox, koy, altx, alty, dn: Integer;
  w: werttype;
Begin
  Write(#10#13, 'H”hen-Faktor:'); Read(faktor);
  Assign(Blockdatei, DateiName);
  Rewrite(Blockdatei);
  base := getmaxy - 90;
  If faktor >= 0 Then
    fak2 := 0
  Else
    fak2 := faktor;
  ClrScr;
  setgraphmode(grm);
  graf := true;
  GOTOxy(1, 23);
  WriteLn('Delta P:    DeltaQ:    I max:   Rand:   P aktuell:   auf Datei:');
  GOTOxy(1, 24); Write(Pmax: 1: 6);
  GOTOxy(13, 24); Write(Qmax: 1: 6);
  GOTOxy(1, 25); Write(Pmin: 1: 6);
  GOTOxy(13, 25); Write(Qmin: 1: 6);
  GOTOxy(26, 24); Write(count);
  GOTOxy(35, 24); Write(rand);
  GOTOxy(54, 24); write(Dateiname);
  setgraphmode(grm);
  GOTOxy(1, 1);
  For j := 0 To 79 Do
    Begin
      If Not KeyPressed Then
        Begin
          GOTOxy(41, 24); Write(Qmin + j * DeltaQ: 1: 7);
          For i := 0 To 399 Do
            Begin
              X0 := 0;
              Y0 := 0;
              n := 0;
              Repeat
                x := SQR(x0) - SQR(Y0) + Pmin + i * DeltaP;
                y := 2 * x0 * y0 + Qmin + j * DeltaQ;
                n := n + 1;
                x0 := x;
                y0 := y;
              Until (SQR(x) + SQR(y) > schranke) Or (n = count);
              If n = count Then
                w.wert := 0
              Else
                w.wert := n;
              w.x := pmin + i * deltaP;
              w.y := qmin + j * deltaq;
              write(blockdatei, w);
              If (i Mod 4 = 0) And (n <> 0) Then
                putpixel(i Div 4, j, trunc(ln(n - 1) * 16) Mod 15 + 1);
              dn := base + j + trunc(count * fak2);
              kox := i + 160 - 2 * j;
              koy := dn - trunc(ln(n - 1) * faktor);
              If (i = 0) Or (abs(alty - koy) < 2) Then
                putpixel(kox, koy, (abs(koy - dn) Div 4 Mod 8 + 8))
              Else
                farbline(altx, alty, kox, koy, dn, 8);
              setcolor(blue);
              farbline(kox, koy + 1, kox, dn, dn, 0);
              altx := kox;
              alty := koy;
            End;
        End;
    End;
  setcolor(white);
  line(kox, koy, kox, base + 80);
  line(0, base + 80, kox, base + 80);
  line(kox, base + 80, kox + 160, base);
  close(blockDatei);
End;

Procedure NeuBild(PTeiler, QTeiler: Integer);
Begin

  Grenzen(PTeiler, QTeiler);
  ClrScr;
  If ch = '1' Then
    Zeichnen
  Else
    Zeichnen3D;
  Repeat Until stopmode;
  restorecrtmode;
End;

Procedure altbild3D;

  Procedure farbline(x1, y1, x2, y2, dn, fp: integer);

  Var dx, dy, ddy: integer;

  Begin
    If y1 > y2 Then
      ddy := -1
    Else
      ddy := 1;
    dy := y1;
    While dy <> y2 Do
      Begin
        If dy * ddy > ((y1 + y2) * ddy) Div 2 Then
          dx := x2
        Else
          dx := x1;
        putpixel(dx, dy, (abs(dy - dn) Div 4 Mod 8 + fp));
        dy := dy + ddy;
      End;
  End;

Var Y0, x, y, faktor, fak2: Real;
  ch: char;
  base, i, io, j, n, kox, koy, altx, alty, dn: Integer;
  st: String;
  w: werttype;

Begin
  clrscr;
  writeln('                  Bild laden ');
  Repeat;
    write('Dateiname:');
    Repeat readln(dateiname)Until dateiname <> '';
    Assign(Blockdatei, DateiName);
{$I-}
    Reset(Blockdatei);
{$I+}
    io := ioresult;
    If io <> 0 Then
      writeln('  Datei nicht vorhanden !');
  Until io = 0;
  Write(#10#13, 'H”hen-Faktor:'); Read(faktor);
  base := getmaxy - 90;
  If faktor >= 0 Then
    fak2 := 0
  Else
    fak2 := faktor;
  ClrScr;
  setgraphmode(grm);
  For j := 0 To 79 Do
    Begin
      If (Not KeyPressed) And (io = 0) Then
        Begin
          For i := 0 To 399 Do
            Begin
{$I-}
              If io = 0 Then
                Begin
                  read(blockdatei, w);
                  io := ioresult;
                End;
{$I+}
              If io = 0 Then
                Begin
                  If i + j = 0 Then
                    Begin
                      setcolor(white);
                      str(w.x: 5: 3, st);
                      outtextxy(0, 82, 'X= ' + st);
                      str(w.y: 5: 3, st);
                      outtextxy(0, 90, 'Y= ' + st);
                    End;
                  n := w.wert;
                  If (i Mod 4 = 0) And (n > 1) Then
                    putpixel(i Div 4, j, trunc(ln(n - 1) * 16) Mod 15 + 1);
                  If n < 2 Then
                    n := 1000;
                  dn := base + j + trunc(ln(1000) * fak2);
                  kox := i + 160 - 2 * j;
                  koy := dn - trunc(ln(n - 1) * faktor);
                  farbline(kox, koy + 1, kox, base + j, dn, 0);
                  If (i = 0) Or (abs(alty - koy) < 2) Then
                    putpixel(kox, koy, (abs(koy - dn) Div 4 Mod 8 + 8))
                  Else
                    farbline(altx, alty, kox, koy, dn, 8);
                  setcolor(blue);
                  altx := kox;
                  alty := koy;
                End;
            End;
        End;
    End;
  While keypressed Do
    ch := readkey;
  setcolor(white);
  str(w.x: 5: 3, st);
  outtextxy(0, 102, 'X= ' + st);
  str(w.y: 5: 3, st);
  outtextxy(0, 110, 'Y= ' + st);
  line(kox, koy, kox, base + 80);
  line(0, base + 80, kox, base + 80);
  line(kox, base + 80, 559, base);
  close(blockDatei);
  Repeat Until readkey In [#27, #13, #0, #32, #48];
End;

Procedure altbild3Dn;

  Procedure farbline(x1, y1, x2, y2, dn, fp: integer);

  Var dx, dy, ddy: integer;

  Begin
    If y1 > y2 Then
      ddy := -1
    Else
      ddy := 1;
    dy := y1;
    While dy <> y2 Do
      Begin
        If dy * ddy > ((y1 + y2) * ddy) Div 2 Then
          dx := x2
        Else
          dx := x1;
        putpixel(dx, dy, (abs(dy - dn) Div 4 Mod 8 + fp));
        dy := dy + ddy;
      End;
  End;

Var X0, Y0, x, y, faktor, fak2: Real;
  base, i, j, n, kox, koy, altx, alty, dn: Integer;
  w: werttype;

Begin
  write('Dateiname:');
  readln(dateiname);
  Write(#10#13, 'H”hen-Faktor:'); Read(faktor);
  Assign(Blockdatei, DateiName);
  Reset(Blockdatei);
  base := getmaxy - 90;
  If faktor >= 0 Then
    fak2 := 0
  Else
    fak2 := faktor;
  ClrScr;
  setgraphmode(grm);
  For j := 0 To 79 Do
    Begin
      If Not KeyPressed Then
        Begin
          GOTOxy(41, 24); Write(Qmin + j * DeltaQ: 1: 7);
          For i := 0 To 399 Do
            Begin
              read(blockdatei, w);
              n := w.wert;
              If (i Mod 4 = 0) And (n <> 0) Then
                putpixel(i Div 4, j, trunc(ln(n - 1) * 16) Mod 15 + 1);
              If n = 0 Then
                n := 1000;
              dn := base + j + trunc(1000 * fak2);
              kox := i + 160 - 2 * j;
              koy := dn - trunc(n * faktor);
              farbline(kox, koy + 1, kox, base + j, dn, 0);
              If (i = 0) Or (abs(alty - koy) < 2) Then
                putpixel(kox, koy, (abs(koy - dn) Div 4 Mod 8 + 8))
              Else
                farbline(altx, alty, kox, koy, dn, 8);
              setcolor(blue);
              altx := kox;
              alty := koy;
            End;
        End;
    End;
  setcolor(white);
  line(kox, koy, kox, base + 80);
  line(0, base + 80, kox, base + 80);
  line(kox, base + 80, 559, base);
  close(blockDatei);
  Repeat Until readkey In [#27, #13, #0, #32, #48];
End;
Var
  GraphDriver, GraphMode, Error: Integer;

Procedure Menu;
Begin
  restorecrtmode;
  ClrScr;
  Write('Grafikprogramm Apfelm„nnchen', #10#10#10#10#13);
  Write('Neues Bild rechnen und zeichnen     <1>', #10#10#13);
  Write('3D-Bild rechnen, zeichnen,speichern <2>', #10#10#13);
  Write('Bild von Diskette holen             <3>', #10#10#13);
  Write('Programm beenden                    <0>', #10#10#10#13);
  Write('Menupunkt: ');
  readln(ch);
  Case ch Of
    '1': NeuBild(439, getmaxy);
    '2': NeuBild(400, 80);
    '3': Altbild3d;
    '4': Altbild3dn;
  End;
  restorecrtmode;
End;

Procedure Abort(Msg: String);
Begin
  Writeln(Msg, ': ', GraphErrorMsg(GraphResult));
  writeln(^G);
  Halt(1);
End;

procedure Execute;
Begin
  ch := '1';
  grk := 0;
  initgraph(grk, grm, bgipath);
  setgraphmode(grm);
  While ch <> '0' Do
    Menu;
  ClrScr;
  Write('Programm beendet');
  ch := 'X';
end;
end.
