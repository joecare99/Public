unit unt_RenderMath;

{$mode objfpc}{$H+}
{$ModeSwitch allowinline}
{$ModeSwitch arrayoperators}


interface

uses
    Classes, SysUtils;

function SolveQuadratic(a, b, c: extended; out l1, l2: extended): boolean;
function SolveKubic(a, b, c: extended; out l1, l2: extended): boolean;

implementation

uses Math, matrix;

function SolveQuadratic(a, b, c: extended; out l1, l2: extended): boolean;
begin
    if (a = 0) and (b = 0) and (c = 0) then
      begin
        l1 := 1;
        l2 := -1;
        exit(True);
      end;
    if (a = 0) and (b = 0) and (c <> 0) then
      begin
        l1 := 0;
        l2 := 0;
        exit(False);
      end;
    if (a = 0) and (b <> 0) then
      begin
        l1 := -c / b;
        l2 := l1;
        exit(True);
      end;
    if (b = 0) and (-c / a < 0) then
      begin
        l1 := 0;
        l2 := 0;
        exit(False);
      end;
    if (b = 0) and (-c / a >= 0) then
      begin
        l1 := -sqrt(-c / a);
        l2 := sqrt(-c / a);
        exit(True);
      end;
    if (c = 0) then
      begin
        l1 := 0;
        l2 := -c / b;
        exit(True);
      end;
    Result := sqr(b) - 4 * a * c >= 0;
    if Result then
      begin
        l1 := (-b - sqrt(sqr(b) - 4 * a * c)) / (2 * a);
        l2 := (-b + sqrt(sqr(b) - 4 * a * c)) / (2 * a);
      end;
end;

function newton1(const a: array of extended; const x: extended): extended; inline;
var
    y, y1: extended;
begin
    Result := x;
    y := a[2] + Result;
    y1 := 2 * y + Result;
    y1 := Result * y1 + a[1];
    y := (Result * y + a[1]) * Result + a[0];
    if (y1 <> 0.0) then
        Result -= y / y1;
end;

function eqn_quadratic(const a: array of extended;
    var x: array of extended;i, j: integer;pa :integer=0): integer; inline;
var
    p: extended;
    d: extended;
begin
    p := -0.5 * a[pa+1];
    d := sqr(p) - a[pa];
    if (d >= 0.0) then
      begin
        d := sqrt(d);
        x[i] := p - d;
        x[j] := p + d;
        exit(2);
      end;
    exit(0);
end;

function eqn_quadratic(const a, o: array of extended;
    var x: array of extended; i, j: integer): integer; inline;
var
    p, d: extended;
begin
    p := -0.5 * a[1];
    d := sqr(p) - a[0];
    if (d >= 0.0) then
      begin
        d := sqrt(d);
        if (p < 0.0) then
          begin
            x[i] := newton1(o, p - d);
            x[j] := p + d;
          end
        else
          begin
            x[i] := p - d;
            x[j] := newton1(o, p + d);
          end;
        exit(2);
      end;
    exit(0);
end;


function SolveKubic(a, b, c: extended; out l1, l2: extended): boolean;
begin

end;

Function eqn_cubic(const a:array of extended; var x:array of extended):integer; // Remark #2

var i_slope, i_loc:integer;
 w, xh, y, y1, y2, dx,  p, d :extended;
 b:array[0..2] of extended;
 c:array[0..1] of extended;
 pb,
 pa:integer;

const prec = 1.0e-6; // termination criterion, Remark #3

begin
if (a[3] = 0.0) then begin // a less-than-cubic problem?
if (a[2] = 0.0) then begin
if (a[1] = 0.0) then // ill-defined problem
exit(0)
else begin // linear problem
x[0] := -a[0] / a[1];
exit(1);
end;
end
else begin // quadratic problem
w := 1.0 / a[2];
c[0] := a[0] * w;
c[1] := a[1] * w;
exit(eqn_quadratic(c, x, 0, 1));
end
end;
w := 1.0 / a[3]; // normalize
pa := 0; //
pb := 0;
while (pb <= high(b))  do begin b[pb] := a[pa] * w;
  inc(pb);inc(pa);end;
if (b[0] = 0.0) then BEGIN // root at zero? Remark #4
x[0] := 0.0;
if (eqn_quadratic(b , x, 1, 2, 1) = 0) then
exit (1)
else begin // sort results
if (x[2] < 0.0) then begin
x[0] := x[1];
x[1] := x[2];
x[2] := 0.0;
end
else if (x[1] < 0.0) then begin
x[0] := x[1];
x[1] := 0.0;
end;
exit( 3);
end
end;
xh := -1.0 / 3.0 * b[2]; // inflection point, Remark #5
y := b[0] + xh * (b[1] + xh * (b[2] + xh));
if (y = 0.0) then begin // is inflection point a root?
x[1] := xh;
x[0] := x[1];
c[1] := xh + b[2]; // deflation
c[0] := c[1] * xh + b[1];
exit( 1 + eqn_quadratic(c, x, 0, 2));
end;
i_loc := ifthen(y >= 0.0,1,0);
d := sqr(b[2]) - 3 * b[1];
i_slope := sign(d);
if (i_slope = 1) then // Laguerre-Nair-Samuelson bounds
xh += (ifthen(i_loc=1,  -2.0 / 3.0 , 2.0 / 3.0) * sqrt(d))
else if (i_slope = 0) then begin // saddle point?
x[0] := xh - cbrt(y);
exit( 1);
end;
repeat  // iteration (Halley’s method)
y := b[2] + xh;
y1 := 2 * y + xh;
y2 := y1 + 3 * xh;
y1 := xh * y1 + b[1];
y := (xh * y + b[1]) * xh + b[0];
dx := y * y1 / (sq(y1) - 0.5 * y * y2);
xh -= dx;
until not (fabs(dx) > prec * fabs(xh)); // Remark #6
x[0] := x[2] = xh;
if (i_slope = 1) then begin
c[1] := xh + b[2]; // deflation
c[0] := c[1] * xh + b[1];
exit ( 1 + eqn_quadratic(c, b, x, i_loc, i_loc + 1));
end
exit (1);
end;


end.
