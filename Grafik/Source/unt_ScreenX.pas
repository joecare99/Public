unit unt_ScreenX;

interface

uses

  classes,
  math,
  graphics,
  graph,
  Win32Crt;


Procedure Execute;

implementation

Type
  TExPoint = Record
    x, y: extended;
  End;

Function ExPoint(x, y: extended): Texpoint;
Inline;
Begin
  result.x := x;
  result.y := y;
End;

Var
  xmax, ymax: integer;

Function arcsin(p: TExpoint): extended;

//Var wi, s, c, d: extended;

Begin
  If p.x > 0 Then
    result := ArcTan(p.y / p.x)
  Else If p.x < 0 Then
    If p.y >= 0 Then
      result := ArcTan(p.y / p.x) + pi
    Else
      result := ArcTan(p.y / p.x) - pi
  Else If p.y > 0 Then
    result := 0.5 * pi
  Else If p.y < 0 Then
    result := -0.5 * pi
  Else
    result := 0;
End;

Function farbm(x, y: extended): integer;

Var
  m, n: extended;

Const
  farbtab: Array[0..4] Of integer = (graph.yellow, graph.red, cllime, graph.blue, graph.white);

Begin
  m := (x - int(x / 4) * 4);
  n := (y - int(y / 4) * 4);
  If m < 0 Then
    m := 1 - m;
  If n < 0 Then
    n := 1 - n;
  If m >= 3 Then
    m := 5 - m;
  If n >= 3 Then
    n := 5 - n;
  farbm := farbtab[trunc(int(n) + int(m))];
End;

Function farbm2(x, y: extended): integer;

Var
  m, n, k: extended;

Begin
  n := (y - int(y / 4) * 4);
  m := ((x + y * 0.5) - int((x + y * 0.5) / 4) * 4);
  K := ((x - y * 0.5) - int((x - y * 0.5) / 4) * 4);
  If m < 0 Then
    m := -m;
  If n < 0 Then
    n := -n;
  If k < 0 Then
    k := -k;
  If m >= 2 Then
    m := 4 - m;
  If n >= 2 Then
    n := 4 - n;
  If k >= 2 Then
    k := 4 - k;
  result := rgb(trunc(n * 127), trunc(m * 127), trunc(k * 127));
End;

Var
  bmp: Tbitmap;

Function farbm3(p: TExPoint): integer;

//Var m, n, k: extended;

// farbdreiecle
Const
  farbtab: Array[0..5] Of integer = (graph.yellow, graph.red, graph.green, graph.blue, graph.white,
    graph.black);

Begin
  If Not assigned(bmp) Then
    Begin
      bmp := Tbitmap.Create;
      bmp.LoadFromResourceName(hInstance, 'TestBMP');
    End;
  result := bmp.Canvas.Pixels[trunc((p.x / 4 - Floor(p.x / 4)) * bmp.Width),
    trunc((p.y / 4 -
    floor(p.y / 4)) * bmp.height)];
End;

Procedure strflucht(Var xe, ye, xa, ya: extended);

Var
  x, y: extended;

Begin
  x := xa;
  y := (ya);
  If y = 0 Then
    Begin
      xe := 0;
      ye := 0;
      exit
    End;
  xe := ((x)*4 / y);
  ye := -(32 / y) - 2;
End;

Procedure ballon(Var xe, ye, xa, ya: extended);

Begin
  If (xa = 0) And (ya = 0) Then
    Begin
      xe := 0;
      ye := 0;
      exit;
    End;
  xe := xa * (1 - 0.3 / ((sqr(ya) + sqr(xa)) / 100 + 0.3));
  ye := ya * (1 - 0.3 / ((sqr(xa) + sqr(ya)) / 100 + 0.3));
End;

Procedure sauger(Var xe, ye, xa, ya: extended);

Var
  force: Extended;
Begin
  If (xa = 0) And (ya = 0) Then
    Begin
      xe := 0;
      ye := 0;
      exit;
    End;
  force := (1 + 0.3 / ((sqr(ya) + sqr(xa)) / 100 + 0.1));
  xe := xa * force;
  ye := ya * force;
End;

Procedure schnecke(Var xe, ye, xa, ya: extended);

Var
  x, y: extended;

Begin
  y := sqrt(sqr(xa) + sqr(ya));
  If y = 0 Then
    Begin
      xe := 0;
      ye := 0;
      exit;
    End;
  x := arcsin(expoint(xa, ya))/pi;
  If  y > 0 Then
    ye := 32/y
  else
   ye:=0;
  xe := x * 16 ;
End;

Procedure schnecke2(Var xe, ye, xa, ya: extended);

Var
  x, y: extended;

Begin
  y := sqrt(sqr(xa) + sqr(ya));
  If y = 0 Then
    Begin
      xe := 0;
      ye := 0;
      exit;
    End;
  x := arcsin(expoint(xa, ya));
  ye := y + (x * 4 / pi);
  xe := x * 32 / pi
End;

Procedure strudel(Var xe, ye, xa, ya: extended);

Var
  x, y: extended;

Begin
  y := sqrt(sqr(xa) + sqr(ya));
  If y = 0 Then
    Begin
      xe := 0;
      ye := 0;
      exit;
    End;
  x := arcsin(expoint(xa, ya));
  ye := cos(x + pi - pi * sqr((y - 1) / y)) * y;
  xe := sin(x + pi - pi * sqr((y - 1) / y)) * y;
End;

Procedure strudel2(Var xe, ye, xa, ya: extended);

Var
  y, r: extended;

Begin
  r := sqrt(sqr(xa) + sqr(ya));
  If abs(r) < (getmaxx / 40) Then
    Y := (1 + cos(r * pi / (getmaxx / 40))) * pi * 0.25
  Else
    Y := 0;
  If r = 0 Then
    Begin
      xe := 0;
      ye := 0;
      exit;
    End;
  //  x := arcsin(xa, ya, y);
  ye := cos(y) * ya - sin(y) * xa;
  xe := sin(y) * ya + cos(y) * xa;
End;

Procedure Wobble(Var xe, ye, xa, ya: extended);

//Var x, y: extended;

Begin
  ye := Ya + cos(XA * pi / 3) * 1.6;
  xe := Xa + sin(Ya * pi / 3) * 1.6;
End;

Procedure Wobble2(Var xe, ye, xa, ya: extended);

Var
  y: extended;

Begin
  y := sqrt(sqr(xa) + sqr(ya));
  ye := Ya + cos(XA * pi / 3) * 0.2 * y;
  xe := Xa + sin(Ya * pi / 3) * 0.2 * y;
End;

Function Wobble3(P: TExPoint): TExPoint;

Var
  x, r: extended;

Begin
  r := sqrt(sqr(p.x) + sqr(p.y));
  If abs(r) < (getmaxx / 40) Then
    x := (1 + cos(r * pi / (getmaxx / 40))) * 10
  Else
    x := 0;
  result := ExPoint(p.x + sin(p.y * pi / 3) * 0.2 * x, p.y + cos(p.x * pi / 3) *
    0.2 * x)
End;

Function Rotat(p: TExPoint; r: extended): TExPoint;
Inline;

Begin
  result := expoint(sin(r) * p.y + cos(r) * p.x, -sin(r) * p.x + cos(r) * p.y);
End;

Function Kugel(p: TExPoint): TExPoint;

Var
  r, rm, zm, z: extended;
  p2, p3: Texpoint;
Begin
  rm := (getmaxx / 50);
  r := sqrt(sqr(p.x) + sqr(p.y));
  If True Then
    If abs(r) > rm Then
      result := p
    Else
      Begin
        p := rotat(p, -pi / 6);
        zm := sqrt(sqr(rm) - sqr(p.y));
        If abs(zm) >= abs(p.x) Then
          z := sqrt(sqr(zm) - sqr(p.x))
        Else
          z := 0;
        p2 := rotat(expoint(p.y, z), -pi / 4);
        p3 := expoint(arcsin(expoint(p.x, p2.y)), arcsin(expoint(p2.x,
          sqrt(sqr(p2.y) + sqr(p.x)))));
        result := expoint(-4 * p3.x / pi * int(rm * 0.5), p3.x / pi * 4 - 4 *
          p3.y
          / pi * int(rm * 0.5));

      End;
End;

Procedure Execute;

Var
  grk, grm: integer;
  i, j: integer;
  p1, p2: TExPoint;
  ch, cch: char;

Const
  Menu: Array[0..21] Of String =
  ('S', 'Strudel',
    'B', 'Ballon',
    'N', 'schNecke',
    'M', 'Schnecke V2',
    'A', 'Sauger',
    'F', 'StassenFlucht',
    'W', 'Wobble',
    'K', 'Kugel',
    '1', 'FarbMuster 1',
    '2', 'FarbMuster 2',
    '3', 'Bitmap');


Begin
  //Menue
  cch := '2';
  Repeat
    clrscr;
    TextBackground(1);
    TextColor(14);
    write('+');
    For I := 0 To 77 - 1 Do
      write('-');
    writeln('+');
    For J := 0 To 22 - 1 Do
      Begin
        write('|');
        For I := 0 To 77 - 1 Do
          write(' ');
        writeln('|');
      End;
    write('+');
    For I := 0 To 77 - 1 Do
      write('-');
    writeln('+');
    textcolor(15);
    For I := 0 To high(menu) Div 2 Do
      If menu[i * 2] <> '' Then

        Begin
          gotoxy(10, I * 2 + 3);
          write('(', menu[i * 2], ')  ', menu[i * 2 + 1]);
        End;

    Repeat

    Until keypressed;
    ch := readkey;
    If ch In ['1'..'9'] Then
      cch := ch;
    If ch = #27 Then
      exit;
    grk := 0;
    initgraph(grk, grm, bgipath);
    xmax := getmaxx Div 2;
    ymax := getmaxy Div 2;
    For i := 0 To getmaxy Do
      Begin
        For j := 0 To getmaxx Do
          Try
            p1 := ExPoint((j - xmax) / 20, (i - ymax) / 20);
            //         strflucht(xh,yh,xh,yh);
            Case upcase(ch) Of
              'S': strudel2(p2.x, p2.y, p1.x, p1.y);
              'B': ballon(p2.x, p2.y, p1.x, p1.y);
              'N': schnecke(p2.x, p2.y, p1.x, p1.y);
              'M': schnecke2(p2.x, p2.y, p1.x, p1.y);
              'F': strflucht(p2.x, p2.y, p1.x, p1.y);
              'A': sauger(p2.x, p2.y, p1.x, p1.y);
              'W': p2 := Wobble3(p1);
              'K': p2 := kugel(p1)
              Else
                Begin
                  p2.x := p1.x;
                  p2.y := p1.y;
                End;
            End;
            //       sauger (p2.x,y,p2.x,y);
            If cch = '3' Then
              putpixel(j, i, farbm3(p2))
            Else If cch = '2' Then
              putpixel(j, i, farbm2(p2.x, p2.y))
            Else If cch = '1' Then
              putpixel(j, i, farbm(p2.x, p2.y))
            Else
              putpixel(j, i, farbm(p2.x, p2.y));

          Except
          End;

        //        if graph.keypressed then exit;
      End;
    Repeat
    Until graph.keypressed;
    ch := graph.readkey;
    restorecrtmode;
  Until ch = #27
end;

end.
