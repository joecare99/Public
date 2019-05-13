unit unt_RenderMath;

{$mode objfpc}{$H+}
{$ModeSwitch allowinline}

interface

{uses
    Classes, SysUtils;  }

function SolveQuadratic(a, b, c: Extended; out l1, l2: Extended): Boolean;
function SolveKubic(a, b, c: Extended; out l1, l2: Extended): Boolean;

implementation

uses Math;

function SolveQuadratic(a, b, c: Extended; out l1, l2: Extended): Boolean;
begin
    if (a = 0) And (b = 0) And (c = 0) then
      begin
        l1 := 1;
        l2 := -1;
        exit(True);
      end;
    if (a = 0) And (b = 0) And (c <> 0) then
      begin
        l1 := 0;
        l2 := 0;
        exit(False);
      end;
    if (a = 0) And (b <> 0) then
      begin
        l1 := -c / b;
        l2 := l1;
        exit(True);
      end;
    if (b = 0) And (-c / a < 0) then
      begin
        l1 := 0;
        l2 := 0;
        exit(False);
      end;
    if (b = 0) And (-c / a >= 0) then
      begin
        l1 := -sqrt(-c / a);
        l2 := sqrt(-c / a);
        exit(True);
      end;
    if (c = 0) then
      begin
        if b * a >0 then
        begin
        l2 := 0;
        l1 := -b / a;
        end
        else
        begin
        l1 := 0;
        l2 := -b / a;
        end;
        exit(True);
      end;
    Result := sqr(b) - 4 * a * c >= 0;
    if Result then
      begin
        l1 := (-b - sqrt(sqr(b) - 4 * a * c)) / (2 * a);
        l2 := (-b + sqrt(sqr(b) - 4 * a * c)) / (2 * a);
      end;
end;

function newton1(const a: array of Extended; const x: Extended): Extended; inline;
var
    y, y1: Extended;
begin
    Result := x;
    y      := a[2] + Result;
    y1     := 2 * y + Result;
    y1     := Result * y1 + a[1];
    y      := (Result * y + a[1]) * Result + a[0];
    if (y1 <> 0.0) then
        Result -= y / y1;
end;

function eqn_quadratic(const a: array of Extended; var x: array of Extended;
    i, j: Integer; pa: Integer = 0): Integer; inline;
var
    p: Extended;
    d: Extended;
begin
    p := -0.5 * a[pa + 1];
    d := sqr(p) - a[pa];
    if (d >= 0.0) then
      begin
        d    := sqrt(d);
        x[i] := p - d;
        x[j] := p + d;
        exit(2);
      end;
    exit(0);
end;

function eqn_quadratic(const a, o: array of Extended; var x: array of Extended;
    i, j: Integer): Integer; inline;
var
    p, d: Extended;
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


function SolveKubic(a, b, c: Extended; out l1, l2: Extended): Boolean;
begin

end;

function cbrt(e: Extended): Extended;

begin
    if e = 0.0 then
        Result := 0.0
    else if e > 0.0 then
        Result := exp(ln(e) / 3)
    else
        Result := -exp(ln(-e) / 3);
end;

function eqn_cubic(const a: array of Extended; var x: array of Extended): Integer;
    // Remark #2

var
    i_slope, i_loc: Integer;
    w, xh, y, y1, y2, dx, p, d: Extended;
    b:      array[0..2] of Extended;
    c:      array[0..1] of Extended;
    pb, pa: Integer;

const
    prec = 1.0e-6; // termination criterion, Remark #3

begin
    if (a[3] = 0.0) then
      begin // a less-than-cubic problem?
        if (a[2] = 0.0) then
          begin
            if (a[1] = 0.0) then // ill-defined problem
                exit(0)
            else
              begin // linear problem
                x[0] := -a[0] / a[1];
                exit(1);
              end;
          end
        else
          begin // quadratic problem
            w    := 1.0 / a[2];
            c[0] := a[0] * w;
            c[1] := a[1] * w;
            exit(eqn_quadratic(c, x, 0, 1));
          end;
      end;
    w  := 1.0 / a[3]; // normalize
    pa := 0;
    pb := 0;
    while (pb <= high(b)) do
      begin
        b[pb] := a[pa] * w;
        Inc(pb);
        Inc(pa);
      end;
    if (b[0] = 0.0) then
      begin // root at zero? Remark #4
        x[0] := 0.0;
        if (eqn_quadratic(b, x, 1, 2, 1) = 0) then
            exit(1)
        else
          begin // sort results
            if (x[2] < 0.0) then
              begin
                x[0] := x[1];
                x[1] := x[2];
                x[2] := 0.0;
              end
            else if (x[1] < 0.0) then
              begin
                x[0] := x[1];
                x[1] := 0.0;
              end;
            exit(3);
          end;
      end;
    xh := -1.0 / 3.0 * b[2]; // inflection point, Remark #5
    y  := b[0] + xh * (b[1] + xh * (b[2] + xh));
    if (y = 0.0) then
      begin // is inflection point a root?
        x[1] := xh;
        x[0] := x[1];
        c[1] := xh + b[2]; // deflation
        c[0] := c[1] * xh + b[1];
        exit(1 + eqn_quadratic(c, x, 0, 2));
      end;
    i_loc := ifthen(y >= 0.0, 1, 0);
    d     := sqr(b[2]) - 3 * b[1];
    i_slope := sign(d);
    if (i_slope = 1) then // Laguerre-Nair-Samuelson bounds
        xh += (ifthen(i_loc = 1, -2.0 / 3.0, 2.0 / 3.0) * sqrt(d))
    else if (i_slope = 0) then
      begin // saddle point?
        x[0] := xh - cbrt(y);
        exit(1);
      end;
    repeat  // iteration (Halley’s method)
        y  := b[2] + xh;
        y1 := 2 * y + xh;
        y2 := y1 + 3 * xh;
        y1 := xh * y1 + b[1];
        y  := (xh * y + b[1]) * xh + b[0];
        dx := y * y1 / (sqr(y1) - 0.5 * y * y2);
        xh -= dx;
    until Not (abs(dx) > prec * abs(xh)); // Remark #6
    x[2] := xh;
    x[0] := x[2];
    if (i_slope = 1) then
      begin
        c[1] := xh + b[2]; // deflation
        c[0] := c[1] * xh + b[1];
        exit(1 + eqn_quadratic(c, b, x, i_loc, i_loc + 1));
      end;
    exit(1);
end;


{
Remarks
#1 sq() (= square), signum() (= sign function), newton1() (= single Newton iteration
step), and eqn quadratic() should be implemented as inline functions (the former two
preferably as template functions) or preprocessor macros in order to avoid the usual over-
head of a subroutine call. We need two versions of eqn quadratic(), one without and
one with the capability of doing a postiteration.
#2 Users of C++ might prefer to deﬁne a and x as instances of an array or vector class.
#3 Halley’s method usually has a convergence order of 3, which practically means that the
number of correct places in the result triples with each iteration step. If two subsequent
iteration steps differ by less than 10 − 6 (relatively), the termination error of the last step is
less than 10 − 18 .
#4 This code block is not strictly necessary. But if it is omitted, the convergence criterion (see
Remark #6) may become inefﬁcient for a root happening to lie at x = 0.0 .
#5 Modern optimizing compilers evaluate constant numerical expressions, so that these ﬂoat-
ing-point divisions will not be performed at run time.
#6 Some CPU time can be saved by working with a ﬁxed threshold. But this may not be safe
under all circumstances. }

end.
