unit Unt_TerraGen;

interface

type
  TTerraGenFkt = function(x, y: extended): extended;

Function TG1(x, y: extended): extended;
Function TG2(x, y: extended): extended;
Function TG3(x, y: extended): extended;
Function TG4(x, y: extended): extended;

Procedure SetUpGenData;

implementation

uses math;


const XExt = 8;
      YExt = 8;
var
  gendata: array [0 .. Xext*YExt-1] of extended;


Function TG1(x, y: extended): extended;

var x1,y1:integer;
    ex1,ex2,ex3,ex4,ex1f,ex12,ex34,ey1f:extended;


begin
  x1:= trunc(x*XExt-floor(x)*XExt);
  y1:= trunc(y*YExt-floor(y)*YExt);
  ex1 := gendata[((x1) mod XExt)+((y1) mod YExt)*XExt];
  ex2 := gendata[((x1+1) mod XExt) +((y1) mod YExt)*XExt];
  ex3 := gendata[((x1) mod XExt)+((y1+1) mod YExt)*XExt];
  ex4 := gendata[((x1+1) mod XExt) +((y1+1) mod YExt)*XExt];
  ex1f := x*XExt-floor(x*XExt);
  ex12 := ex2*ex1f+ex1*(1-ex1f);
  ex34 := ex4*ex1f+ex3*(1-ex1f);
  ey1f := y*YExt-floor(y*YExt);
  result := ex34*ey1f+ex12*(1-ey1f);
end;

Function TG2(x, y: extended): extended;

begin
  result :=
     TG1(x,y)*
     (0.3+TG1(x*3+y*2,y*3-x*3)*0.7);
  result := sin(result*pi*0.5);
end;

Function TG3(x, y: extended): extended;

begin
  result :=
     TG2(x,y)*0.75+
     TG2(x*7,y*7)*0.125+
     TG2(x*17,y*17)*0.06125+
     TG2(x*63,y*63)*0.06125;
  result := sqr(sin(result*pi*0.5));
  result := sqr(sin(result*pi*0.5));
end;

Function TG4(x, y: extended): extended;

begin
  result :=
     TG1(x,y)*
     (0.6+TG1(x*7+y,y*7-x+1)*0.4){+
     TG1(x*17,y*17)*0.05+
     TG1(x*63,y*63)*0.05};
  result :=result*0.7+sqr(result)*TG1(x*63-y*32,y*63+x*32)*TG1(x*17+y*3,y*17-x*3)*0.4;
  result := sqr(sin(result*pi*0.5));
  result := sqrt(sin(result*pi*0.5));
end;

Procedure SetUpGenData;
var
  i,mx,lx: integer;
begin
  mx:=0;
  lx:=0;
  for i := 0 to 63 do
    begin
      gendata[i] := random;
      if gendata[mx]<gendata[i] then
        mx :=i;
      if gendata[lx]>gendata[i] then
        Lx :=i;
    end;
  gendata[mx]:= 1.0;
  gendata[lx]:= 0.0;
end;

initialization

SetUpGenData;

end.
