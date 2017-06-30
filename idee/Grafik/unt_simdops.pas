unit unt_simdops;

interface

uses graph,Unt_3dpoint{,fgrtest};

type real=extended;

const 
      maxstar=1500;

      rz2 =Raumz div 2;
      AugX=Raumx div 2;
      Augy=raumy div 2;
      AugZ=-120;

      maxCol=255;

      ddx=0 ;
      ddy=0;
      ddz=-1;

type TMovinP=object(tmPoint)
                dx,dy,dz:extended;
                procedure Move;Virtual;
                procedure Move2;Virtual;
                procedure Move3;Virtual;
                procedure Move4;Virtual;
              end;

var cc,ss,s,c,zz,dd,phi:real;

procedure Execute;

implementation

const gr=7e5;

var middlP,StdAbw,MidlV:TMovinP;

procedure TMovinP.move4;

var dg:extended;
begin
  if y>-raumy  then
  hide;
  if ((x+dx) >= raumx) or ((x+dx) < -raumx) then dx:=-(dx)*0.85;
  if ((y+dy) >= raumy) or ((y+dy) < -raumy) then
    begin
      y:=-raumy;
      x:=c*raumx;
      z:=s*raumz;
      dx:=cc*990+(0.5-random)*0.2;
      dz:=ss*990+(0.5-random)*0.2;
      dy:=50*dd+zz*20 +random*0.2;
      dd:=-1;
    end;
//allgemeine Gravitation
  if y<raumy-1 then dy:=dy-0.1 ;
  if ((z+dz) >= raumz) or ((z+dz) < -raumz) then dz:=-(dz)*0.85;
//
  dx:=dx*0.993;
  dy:=dy*0.999;
  dz:=dz*0.993;
  x:=x+dx;
  y:=y+dy;
  z:=z+dz;
  xxx:=x;
  yyy:=y;
  zzz:=-z-raumz;
  if y>-raumy  then
    show
end;

procedure TMovinP.move3;

var dg:extended;

begin
  hide;
  if ((x+dx) >= raumx) or ((x+dx) < -raumx) then dx:=-(dx)*0.85;
  if ((y+dy) >= raumy) or ((y+dy) < -raumy) then dy:=-(dy)*0.75;
//allgemeine Gravitation
  if y<raumy-1 then dy:=dy-0.3;
  if ((z+dz) >= raumz) or ((z+dz) < -raumz) then dz:=-(dz)*0.85;
//
  dg:=sqr(x)+sqr(y)+sqr(z);
  dg:=gr/(0.0001+dg*sqrt(dg));
  dx:=dx*0.999-x*dg ;
  dy:=dy*0.999-y*dg;
  dz:=dz*0.999-z*dg;
  x:=x+dx;
  y:=y+dy;
  z:=z+dz;
  xxx:=x;
  yyy:=y;
  zzz:=-z-raumz;
  show
end;

procedure TMovinP.move2;

begin
  hide;
  if ((x+dx) >= raumx) or ((x+dx) < -raumx) then dx:=-(dx)*0.95;
  x:=x+dx;
  if ((y+dy) >= raumy) or ((y+dy) < -raumy) then dy:=-(dy)*0.95;
  y:=y+dy;
  if y<raumy-1 then dy:=dy-0.3;
  if ((z+dz) >= raumz) or ((z+dz) < -raumz) then dz:=-(dz)*0.95;
  z:=z+dz;
  xxx:=x;
  yyy:=y;
  zzz:=-z-raumz;
  show
end;

procedure TMovinP.move;

begin
  hide;
  dx:=(+C+cc*(z-rz2)+(y-augy)*dd)*0.2;
  x:=x+dx;
  if (x >= raumx) then x:=x-raumx*2;
  if (x < -raumx)      then x:=x+raumx*2;
  dy:=(+S+ss*(z-rz2)+(augx-x)*dd)*0.2;
  y:=y+dy;
  if (y >= raumy) then y:=y-raumy*2;
  if (y < -raumy)      then y:=y+raumy*2;
  dz:=(+zz+cc*(augx-x)+ss*(augy-y))*0.2;
  z:=z+dz;
  if (z >= raumz) then z:=z-raumz*2;
  if (z < -raumz) then z:=z+raumz*2;
  xxx:=x;
  yyy:=y;
  zzz:=-z-raumz;
  show
end;

procedure Execute;

var p:array[1..maxstar] of TMovinP;

    i,j,n,vs,vs1,oldn:integer;
    grk,grm:integer;

begin
  grk:=detect;
  initgraph(grk,grm,'');
  getmidx:=getmaxx div 2;
  getmidy:=getmaxy div 2;
  j:=1;
{  for i:= 1 to 8 do
    begin
      rgb(i,i*7+3,i*7+3,i*7+3,false);
      rgb(i+7,63,63,63,false);
    end;   }
  middlP.Init(0,0,0);
  StdAbw.Init(0,0,0);
  MidlV.Init(0,0,0);
  for i:=1 to maxstar do
    begin
      p[i].Init(random(raumx)*2-raumx,random(raumy)*2-raumy ,random(raumz)*2-raumz );
      middlp.plus(p[i]);
      StdAbw.aplus(p[i]);
    end;
  middlp.SMult(1/maxstar);
  n:=maxstar;
  repeat
        phi:=phi-int(phi/(2*pi))*pi*2+0.0001*pi;
        c:=cos(phi*11)/3;
        s:=sin(phi*10)/3;
        cc:=cos(phi*3)/200;
        ss:=sin(phi*4)/200;
        zz:=sin(Phi*9)*raumz/100;
        dd:=sin(Phi*5)/60;
 //       vs:=vsync;
        oldn:=n;
    {  if vS>20 then
        begin
          if n+vs > 300 then n:=n div 3;
          if vs < 10 then n:=n-1;
          n:=n+(vs div 10) ;
        end;
    if n<oldn then
      for i:= n+1 to oldn do p[i].hide;
     vs:=vsync; }

    for i:=1 to n do
      p[i].move;
  until keypressed;
  readkey;
  repeat
    for i:=1 to n do
      p[i].move2;
  until keypressed;
  readkey;
  repeat
    for i:=1 to n do
      p[i].move3;
  until keypressed;
  readkey;
  repeat
        phi:=phi-int(phi/(2*pi))*pi*2+0.0001*pi;
        c:=cos(phi*5)/9;
        s:=sin(phi*6)/9;
        cc:=cos(phi*30)/18;
        ss:=sin(phi*35)/18;
        zz:=sin(Phi*800)/40;
        dd:=1;
 //       vs:=vsync;
        oldn:=n;
    {  if vS>20 then
        begin
          if n+vs > 300 then n:=n div 3;
          if vs < 10 then n:=n-1;
          n:=n+(vs div 10) ;
        end;
    if n<oldn then
      for i:= n+1 to oldn do p[i].hide;
     vs:=vsync; }

    for i:=1 to n do
      p[i].move4;
  until keypressed;

  restorecrtmode;
end;


end.
