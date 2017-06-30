unit unt_NSphaer;

interface

Uses graph;

procedure DrawNSphere(alpha: Integer; jj: Integer; nn: Integer);

implementation

Const
  ymin = -10; ymax = 10;
  xmin = -10; xmax = 10; (*Benutzerkoordinaten*)
  d = 4; (*Abstand vom Rand*)

Var
  vpx, vpy, vpz, angx, angy, angz,
    ax, ay, az, cx, cy, cz, sx, sy, sz,
    v1x, v1y, v1z, v2x, v2y, v2z,
    vnx, vny, vnz, rx, ry, rz, x, y, z,
    px, py, pz, u, v,
    sf, xl, yl, xsu, ysu, angp, ap: real;
  xs, ys, ysl, xsl, xs0, ys0, xs1, ys1, xs2, ys2, col, i, xkor, ykor: integer;

  ch: char;

Procedure moveto(x, y: integer);
Begin
  xkor := x;
  ykor := y;
End;

Procedure drawto(x, y: integer);
Begin
  line(x, y, xkor, ykor);
  xkor := x;
  ykor := y;
End;

Procedure init;
Var
  grd, grm, i: integer;
  xasp, yasp: word;

Begin
  grd := detect;
  initgraph(grd, grm, bgipath);
  setgraphmode(grm);
  getaspectratio(xasp, yasp);
  setfillstyle(solidfill, 15);
  bar(0, 0, getmaxx, getmaxy);
  setcolor(0);
  sf := yasp / xasp; (*Screen-Faktor fÅr x-Richtung*)
  yl := ymax - ymin; xl := xmax - xmin; (*LÑnge des Benutzerschirms*)
  ysl := getmaxy - 2 * d; (*LÑnge des Bildschirms in x-Richtung*)
  ysu := ysl / yl; xsu := sf * ysu; (*Pixels/LÑngeneinheit*)
  xsl := round(xl * xsu); (*LÑnge des Bildschirms in y-Richtung*)
  xs1 := (getmaxx - xsl) Div 2;
  ys1 := (getmaxy + ysl) Div 2; (*linke untere Schirmecke*)
  xs2 := (getmaxx + xsl) Div 2;
  ys2 := (getmaxy - ysl) Div 2; (*rechte obere Schirmecke*)
  xs0 := xs1 + round(xsu * (-xmin));
  ys0 := ys1 - round(ysu * (-ymin));
End;

Procedure param_projec;
Begin
  angp := 0;
  ap := angp * pi / 180;
  vpx := 0; vpy := sin(ap); vpz := cos(ap)
End;

Procedure param_rot;
Begin
  angx := 20; angy := 0; angz := 30;
  ax := angx * pi / 180; ay := angy * pi / 180; az := angz * pi / 180;
  cx := cos(ax); cy := cos(ay); cz := cos(az);
  sx := sin(ax); sy := sin(ay); sz := sin(az);
End;

Function transx(x: real): integer;
Begin
  transx := xs0 + round(xsu * x)
End;

Function transy(y: real): integer;
Begin
  transy := ys0 - round(ysu * y)
End;

Procedure cosys;
Var x, y: integer;
Begin
  line(xs1, ys0, xs2, ys0);
  line(xs2, ys0, xs2 - 5, ys0 - 5);
  line(xs2, ys0, xs2 - 5, ys0 + 5);
  line(xs0, ys1, xs0, ys2);
  line(xs0, ys2, xs0 - 5, ys2 + 5);
  line(xs0, ys2, xs0 + 5, ys2 + 5);
  For x := xmin To xmax Do
    For y := ymin To ymax Do
      putpixel(transx(x), transy(y), 1);
End;

Procedure vecprod;
Begin
  vnx := v1y * v2z - v1z * v2y;
  vny := -v1x * v2z + v1z * v2x;
  vnz := v1x * v2y - v1y * v2x
End;

Procedure rotation;
Var xr1, yr1, zr1, xr2, yr2, zr2: real;
Begin
  xr1 := x; yr1 := sx * z + cx * y; zr1 := cx * z - sx * y;
  xr2 := cy * xr1 - sy * zr1; yr2 := yr1; zr2 := sy * xr1 + cy * zr1;
  rx := cz * xr2 - sz * yr2; ry := sz * xr2 + cz * yr2; rz := zr2
End;

Procedure projection;
Begin
  px := rx; py := ry - rz * sin(ap) / cos(ap)
End;


Function kx(v,r: real): real;
Begin
  kx := r * cos(v)
End;

Function ky(v,r: real): real;
Begin
  ky := r * sin(v)
End;

Function xx(u, v,r: real): real;
Begin
  xx := kx(v,r) * cos(u)
End;

Function yy(u, v,r: real): real;
Begin
  yy := ky(v,r)
End;

Function zz(u, v,r: real): real;
Begin
  zz := kx(v,r) * sin(u)
End;

Function nx(u, v,r: real): real;
Begin
  nx := xx(u, v,r)
End;

Function ny(u, v,r: real): real;
Begin
  ny := yy(u, v,r)
End;

Function nz(u, v,r: real): real;
Begin
  nz := zz(u, v,r)
End;

Procedure surface(r:real);
Begin
  x := xx(u, v,r); y := yy(u, v,r); z := zz(u, v,r);
  rotation;
  projection;
  xs := transx(px); ys := transy(py)
End;

Function visibility(r:real): boolean;
Begin
  x := nx(u, v,r); y := ny(u, v,r); z := nz(u, v,r);
  rotation;
  If rx * vpx + ry * vpy + rz * vpz <= 0 Then
    visibility := true
  Else
    visibility := false
End;

Function hoch(x: real; n: integer): real;
Var z: real;
Begin
  z := 1;
  If n > 0 Then
    For n := n Downto 1 Do
      z := z * x;
  hoch := z
End;

procedure DrawNSphere(alpha: Integer; jj: Integer; nn: Integer);
var
  r: Real;
  fa: Real;
  rr: Real;
  j: Integer;
  n: Integer;
  t: Real;
  uc: array[0..20] of Real;
  vc: array[0..20] of Real;
  l: Integer;
  aau: array[0..10] of array[0..20] of Real;
  aav: array[0..10] of array[0..20] of Real;
  ku: Integer;
  au1: array[0..20] of Real;
  mu: array[0..20] of Real;
  kv: Integer;
  av1: array[0..20] of Real;
  mv: array[0..20] of Real;
  vis1: Boolean;
  vis2: Boolean;
  kku: Integer;
  kkv: Integer;
  ll: Integer;
  dp: Real;
  u1: Real;
  u2: Real;
  v1: Real;
  v2: Real;
  au: Real;
  av: Real;
  delta: Real;
  t0: Real;
  a: Real;
begin
  param_projec;
  param_rot;
  init;
  kku := 13;
  kkv := 6;
  ll := 8;
  dp := pi / 2 - pi * kkv / kku;
  u1 := -pi / 2;
  u2 := 3 / 2 * pi;
  v1 := -pi / 2 + dp;
  v2 := pi / 2 - dp;
  au := (u2 - u1) / kku;
  av := (v2 - v1) / kkv;
  delta := 2 * pi / nn;
  t0 := -delta / 2;
  a := alpha * pi / 180;
  r := 9;
  fa := 1 / (cos(a) + abs(sin(a)) * sin(delta / 2) / cos(delta / 2));
  rr := au / 2 / cos(delta / 2);
  init;
  col := 9;
  rx := 0;
  ry := 0;
  rz := 0;
  projection;
  SetLineStyle(SolidLn,Black,GraphForm.df);
  for j := 0 to jj do
  begin
    if j = 6 then
      ll := 4;
    for n := 0 to nn do
    begin
      t := n / nn * 2 * pi;
      uc[n] := rr * hoch(fa, j) * cos(t0 + t + j * a);
      vc[n] := rr * hoch(fa, j) * sin(t0 + t + j * a);
    end;
    for n := 0 to nn - 1 do
      for l := 0 to ll do
      begin
        aau[n, l] := uc[n] + l / ll * (uc[n + 1] - uc[n]);
        aav[n, l] := vc[n] + l / ll * (vc[n + 1] - vc[n]);
      end;
    for ku := 0 to kku - 1 do
    begin
      au1[ku] := u1 + ku * au;
      mu[ku] := au1[ku] + au / 2;
      for kv := 0 to kkv - 1 do
      begin
        if stopmode  then
          exit;
        av1[kv] := v1 + kv * av;
        mv[kv] := av1[kv] + av / 2;
        u := mu[ku] + aau[0, 0];
        v := mv[kv] + aav[0, 0];
        surface(r);
        vis1 := visibility(r);
        moveto(xs, ys);
        for n := 0 to nn - 1 do
        begin
          for l := 1 to ll do
          begin
            u := mu[ku] + aau[n, l];
            v := mv[kv] + aav[n, l];
            surface(r);
            vis2 := visibility(r);
            if vis1 and vis2 then
              drawto(xs, ys)
            else
              moveto(xs, ys);
            vis1 := vis2;
          end;
        end;
      end;
    end;
  end;
end;

procedure execute;

Var
  alpha, nn, nt, jj: integer;


Begin



  Repeat Until keypressed; ch := readkey;
  restorecrtmode
end;

End.

