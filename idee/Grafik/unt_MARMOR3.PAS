unit unt_MARMOR3;

interface

uses Graph,farbgr;

procedure Execute;

implementation

var z:array[0..7,0..7] of byte;
    i,j:word;

function Interpol(w1,w2,w3,w4:longint;d1,d2:byte):word;

var z1,z2:longint;

begin
   z1:=(w3*d1+w1*(256-d1)) shr 8;
   z2:=(w4*d1+w2*(256-d1)) shr 8;
   result:=(z2*d2+z1*(256-d2)) shr 8;
end;

function Interpol_ex(w1,w2,w3,w4,d1,d2:extended):extended;

var z1,z2:extended;

begin
   z1:=w3*d1+w1*(1-d1);
   z2:=w4*d1+w2*(1-d1);
   result:=(z2*d2+z1*(1-d2)) /4;
end;


function marmor1(x,y:byte):byte;

var sy,sx,
    mx,my:word;
begin
   {Interpolate (X) }
   mx:=x shr 5;
   sx:=x and 31;
   my:=y shr 5;
   sy:=y and 31;
   result:=interpol(z[mx,my],z[mx,(my+1) and 7],
                    z[(mx+1) and 7,my],z[(mx+1) and 7,(my+1) and 7],
                    sx*8,sy*8);
end;

function marmor1_ex(x,y:extended):extended;

var sy,sx:extended;
    mx,my:integer;
begin
   {Interpolate (X) }
   mx:=trunc(x);
   sx:=x -mx;
   my:=trunc(y) ;
   sy:=y -my;
   result:=interpol_ex(z[mx,my],z[mx,(my+1) and 7],
                    z[(mx+1) and 7,my],z[(mx+1) and 7,(my+1) and 7],
                    sx,sy);
end;


var grm,grk,fa:Integer;
    Yh:array[0..640] of word;
    filla:array[0..256,0..1] of record
                                  he:byte;
                                  vis:boolean;
                                  xk,yk:word;
                                end;
    x,y,zz:word;
    jj,ii:byte;

procedure Execute;

var i,j:integer;

begin
  Randomize;
  fillchar (yh,sizeof(yh),255);
  for i := 0 to 7 do
    for j:= 0 to 7 do
      z[i,j]:=Random(255);
  grk:=0;
  initgraph(grk,grm,bgipath);
  setgraphmode(grm);
  setpalette(6,6);
  for j:= 0 to getmaxx div 4 do
    for i:= 0 to getmaxx div 4 do
     begin
      zz:=(marmor1(j,i)*3+marmor1(i*2+16,j*2+16)) div 4;
      x:=(i+j) +64;
      y:=(256+i-j) div 2+zz div 3;
      with filla[i,j mod 2] do
        begin
          he:=zz;
          xk:=x;
          yk:=y;
          vis:=Yh[x]>y;
          if vis then yh[x]:=y;
        end;
      if (i>0) and (j>0) then
        if  Filla[i,j mod 2].vis and
                 Filla[i-1,(j-1) mod 2].vis then
             begin
      fa:=(zz*7+marmor1(i,j)) div 8;
             for jj:= 0 to 7 do
              for ii:= 0 to 7 do
                fputpixel(trunc(
                Interpol(Filla[i,j and 1].xk,
                 Filla[i,(j-1) and 1].xk,
                 Filla[i-1,j and 1].xk,
                 Filla[i-1,(j-1) and 1].xk,ii*16,jj*16)/640*getmaxx),
                trunc(Interpol(Filla[i,j and 1].yk,
                 Filla[i,(j-1) and 1].yk,
                 Filla[i-1,j and 1].yk,
                 Filla[i-1,(j-1) and 1].yk,ii*16,jj*16)/480*getmaxy), fa  , 128{
                 trunc(112+sin(16*pi*fa/256)*112)+(9+Filla[i,j and 1].yk-
                 Filla[i,(j-1) and 1].yk) });
     fputpixel(i,j,((fa+128) div 128)*2+2 ,abs(abs(fa)-64) div 2);
             end;
     end;
   if keypressed then halt;
  repeat until stopmode;
  closegraph;
end;

end.


