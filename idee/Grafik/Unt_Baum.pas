unit Unt_Baum;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

procedure DoBaumDraw(grm,maxt:integer;faktor,rot:extended);

implementation

uses graph,unt_allgfunklib,sysutils;

Type
  real=double;
  vector = Object
    xk, yk, zk: real;
    Constructor init;
    Destructor done;
    Procedure add(v: vector);
    Procedure smal(sc: real);
    Function vmal(v: vector): real;
    Procedure xmal(v1, v2: vector);
    Function laenge: real;
    Procedure getwert(out x, y, z: real);
    Procedure setwert(x, y, z: real);
  End;

  ovec = Object(vector)
    ortsv: vector;
    Constructor init(vec, ort: vector);
  End;

  baumstZ = ^baumstT;
  baumstT = record
    ox, oy, oz,
      vx, vy, vz: real;
    b: integer;
    c: integer;
    nextl, nextr: baumstZ;
  End;

Constructor vector.init;

Begin
  xk := 0; yk := 0; zk := 0;
End;

Destructor vector.done;

Begin
End;

Procedure vector.add(v: vector);

Begin
  xk := xk + v.xk;
  yk := yk + v.yK;
  zk := zk + v.zk;
End;

Procedure vector.smal(sc: real);

Begin
  xk := xk * sc;
  yk := yk * sc;
  zk := zk * sc;
End;

Function vector.vmal(v: vector): real;

Begin
  vmal := xk * v.xk + yk * v.yk + zk * v.zk;
End;

Procedure vector.xmal(v1, v2: vector);

Begin
  xk := v1.yk * v2.zk - v1.zk * v2.yk;
  yk := v1.zk * v2.xk - v1.xk * v2.zk;
  zk := v1.xk * v2.yk - v1.yk * v2.xk;
End;

Function vector.laenge:real;

Begin
  laenge := sqrt(sqr(xk) + sqr(yk) + sqr(zk));
End;

Procedure vector.getwert(out x, y, z: real);

Begin
  x := xk; y := yk; z := zk;
End;

Procedure vector.setwert(x, y, z: real);

Begin
  xk := x; yk := y; zk := z;
End;

Constructor ovec.init(vec, ort: vector);

Begin
  vector.init;
  vector.add(vec);
  ortsv := ort;
End;

Function baumpush(bau: baumstZ; Var ort, vec: vector; breit, col: integer): baumstZ;

Var b1: baumstZ;

Begin
  If bau = Nil Then
    Begin
      new(b1);
      With b1^ Do
        Begin
          ort.getwert(ox, oy, oz);
          vec.getwert(vx, vy, vz);
          b := breit;
          c := col;
          nextl := Nil;
          nextr := Nil;
          bau := b1;
        End;
    End
  Else If bau^.oz + bau^.vz * 0.5 < ort.zk + vec.zk * 0.5 Then
    bau^.nextl := baumpush(bau^.nextl, ort, vec, breit, col)
  Else
    bau^.nextr := baumpush(bau^.nextr, ort, vec, breit, col);
  baumpush := bau;
End;

Function baumpop(bau: baumstZ; Var ort, vec: vector; Var breit, col: integer): baumstZ;

Begin
  If bau <> Nil Then
    With bau^ Do
      Begin
        baumpop := nextl;
        ort.init;
        ort.setwert(ox, oy, oz);
        vec.init;
        vec.setwert(vx, vy, vz);
        breit := b;
        col := c;
        dispose(bau);
      End
  Else
    baumpop := Nil
End;

procedure DisposeBaum(var bau:baumstZ);

var p:baumstZ;
begin
  if Assigned(bau)   then
    begin
      DisposeBaum(bau.nextl);
      DisposeBaum(bau.nextr);
    end;
  p:= bau;
  bau:=nil;
  Dispose(p);
end;

Var p: vector;
  Baum: baumstZ;
  xf, yf: word;
  grd,grm:integer;

Procedure drawbgr;

Var yk: integer;

Begin
  yk := trunc(getmaxy * (1 - 1 / (sqrt(5) + 1)));
//  setlinestyle(0,0,0);
  setfillstyle(Solidfill, blue);
  BAR(0, 0, getmaxx, yk);
  setfillstyle(Solidfill, green);
  BAR(0, yk, getmaxx, getmaxy);
End;

Procedure linebreit(ort, vec: vector; breit, col: integer);

Var n0,n1: vector;
  l: real;
  points: Array[1..4] Of pointtype;

Begin
  n0.init;
  n1.init;
  n0.setwert(vec.yk, -vec.xk, 0);
  n1.setwert(vec.xk, vec.yk, 0);
  l := n0.laenge;
  If l = 0 Then
    Begin
      n0.xk := breit Div 2;
      n0.yk := 0;
      vec.yk := breit Div 2;
    End
  Else
    begin
      n0.smal(breit / (2 * l));
      n1.smal(breit / (6 * l));
    end;
  points[1].x := trunc((ort.xk + n0.xk-n1.xk) / xf * yf);
  points[1].y := trunc(ort.yk + n0.yk-n1.yk);
  points[4].x := trunc((ort.xk + n0.xk + vec.xk+n1.xk) / xf * yf);
  points[4].y := trunc(ort.yk + n0.yk + vec.yk+n1.yk);
  points[2].x := trunc((ort.xk - n0.xk-n1.xk) / xf * yf);
  points[2].y := trunc(ort.yk - n0.yk-n1.yk);
  points[3].x := trunc((ort.xk - n0.xk + vec.xk+n1.xk) / xf * yf);
  points[3].y := trunc(ort.yk - n0.yk + vec.yk+n1.yk);
  setfillstyle(SolidFill, col);
  setcolor(col);
  fillpoly(4, points);
  n0.done;
  n1.done;
End;

Procedure knospen(p, v: vector);

Var i: byte;
  x, y: integer;

Begin
  For i := 1 To 40 Do
    Begin
      x := trunc((p.xk * ((30 - i) / 30) + (p.xk + v.xk) * (i / 30)) / xf * yf) + random(9) - 4;
      y := trunc(p.yk * ((30 - i) / 30) + (p.yk + v.yk) * (i / 30)) + random(9) - 4;
      putpixel(x, y, lightgreen);
    End;
End;

Procedure show(v: vector; tiefe, color: integer);

Var width: byte;

Begin
  width := trunc(sqrt(zweihoch[tiefe]) / 2 + 1);
  linebreit(p, v, width, color);
  p.add(v);
End;

Procedure push(v: vector; tiefe, color: integer);

Var
  width: integer;

Begin
  if v.laenge >0.01 then
  width := trunc(sqrt(sqrt(zweihoch[tiefe])) / 60 * v.laenge + 1)
  else
    width :=1 ;
  baum := baumpush(baum, p, v, width, color);
  p.add(v);
End;

Procedure moveback(v: vector);

Begin
  v.smal(-1);
  p.add(v);
End;

Var Count: word;
  count2: word;

Procedure aeste(vo, vs: vector; tiefe: shortint;faktor:extended);

Var v0, v1, v2, vo2, vs2: vector;
  l: real;

Begin
  inc(count);
  If count > 50 Then
    Begin
      count := 0;
      count2 := count2 + 1;
//      gotoxy (1,3);
//      write (count2:5,memavail:9);
    End;
  If tiefe > 0 Then
    Begin
      l := vo.laenge;
      push(vo, tiefe, brown);
      vo.smal(0.5);
      vs.smal(0.5);
      aeste(vo, vs, tiefe - 3,faktor);
      vo.smal(2);
      vs.smal(2);
      v0.init;
      v0.add(vo);
      v0.add(vs);
      v0.smal(l / v0.laenge);
      push(v0, tiefe, brown);
      v2.init;
      v2.xmal(v0, vs);
      v2.smal(l / (v2.laenge));
      v1.init;
      v1.xmal(v0, v2);
      v1.smal(l / (v1.laenge));
      vo2.init;
      vo2.add(v1);
      vo2.add(v2);
      vo2.add(v0);
      vo2.smal((l * faktor) / vo2.laenge);
      vs2.init;
      vs2.xmal(vo2, v0);
      vs2.smal(l / (2 * vs2.laenge));
      aeste(vo2, vs2, tiefe - 1,faktor);
      vs2.smal(-1);
      vo2.xmal(vo2, vs2);
      vo2.smal((l * faktor) / vo2.laenge);
      aeste(vo2, vs2, tiefe - 2,faktor);
      moveback(v0);
      moveback(vo);
      v0.done;
      v1.done;
      v2.done;
      vo2.done;
      vs2.done;
    End
  Else
    Begin
      push(vo, 0, green);
      moveback(vo);
    End
End;

Procedure Stamm(v0, vs: vector; tiefe: byte;faktor:extended);

Var v, v1: vector;

Begin
  v.init;
  v1.init;
  v.add(v0);
  v0.smal(1);
  push(v0, tiefe, brown);
  v.smal(0.7);
  vs.smal(0.7);
  v1.add(vs);
  v1.smal(-0.5);
  v.add(v1);
  aeste(v, vs, tiefe,faktor);
  moveback(v0);
End;

Procedure drawbaum(b1: baumstZ; Var o, v: vector);

Begin
  If b1 <> Nil Then
    With b1^ Do
      Begin
        drawbaum(nextl, o, v);
        o.setwert(ox, oy, oz);
        v.setwert(vx, vy, vz);
        If c = green Then
          knospen(o, v)
        Else
          linebreit(o, v, b, c);
        drawbaum(nextr, o, v);
      End;
End;

procedure DoBaumDraw(grm,maxt:integer;faktor,rot:extended);

var v0, vs, o, v: vector;
      w, mh, mhb: real;
      i:integer;

begin
  mh := 2.5;
  mhb := faktor;
  for i := 1 to maxt do
  begin
    mh := mh + mhb;
    mhb := mhb * faktor;
  end;
  mh := mh;
  InitGraph(grd,grm,bgipath);
  setgraphmode(grm);
  if  keypressed   then readkey;

  getaspectratio(xf, yf);
  p.init;
  p.xk := trunc((getmaxx div 2) / yf * xf);
  p.yk := getmaxy - 30;
  v0.init;
  vs.init;
  moveback(v0);
  v0.yk := -(getmaxy - 60) / mh;
  w := -0.1;

  w := w + 0.1;
  vs.init;
  moveback(vs);
  vs.zk := sin(w) * (getmaxy - 60) / (2 * mh);
  vs.xk := cos(w) * (getmaxy - 60) / (2 * mh);
  stamm(v0, vs, maxt,faktor);
//  setgraphmode(grm);

  //  setvisualpage(0);
  //  setactivepage(0);
  cleardevice;
  drawbgr;
  o.init;
  v.init;
  drawbaum(baum, o, v);
  DisposeBaum(baum);
  repeat
  until keypressed;
  restorecrtmode;
end;

initialization
  Count2 := 0;
  Count := 0;
  baum := Nil;
end.
