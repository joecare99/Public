unit unt_starfield2;

interface

uses graph,unt_3dpoint,sysutils{,fgrtest};


type integer=longint;
     real=extended;

const genau=500;

      maxstar=10000;
      maxbahn=2500;

      rz2 =0;
      Auge:TPoint=(x:0;y:0;z:rz2);

      maxCol=255;

      ddx=0 ;
      ddy=0;
      ddz=-1;



type TMovinP=object(TPoint)
                procedure Move(auge:Tpoint);reintroduce;
              end;


var dx,dy,dz,cx,cy,cz,sx,sy,sz,dwx,dax,dwy,dwz,oc,lx,ly:real;
    co:word;

procedure execute;

implementation

  {
procedure TMovinP.move;

begin
  hide;
  if ((x+dx) >= raumx) or ((x+dx) < 0) then dx:=-(dx)*0.95;
  x:=x+dx;
  if ((y+dy) >= raumy) or ((y+dy) < 0) then dy:=-(dy)*0.95;
  y:=y+dy;
  if y<raumy-1 then dy:=dy+0.015;
  if ((z+dz) >= raumz) or ((z+dz) < 0) then dz:=-(dz)*0.95;
  z:=z+dz;
  xxx:=x;
  yyy:=y;
  zzz:=z;
  show
end;
{                }

procedure TMovinP.move(auge:Tpoint);

var xh,yh,zh,xx,yy,zz:real;

begin
  hide;
  {*a Berechne Translation}  {}
  xh:=(x-auge.x);
  yh:=(y-auge.y);
  zh:=(z-auge.z);
  if (xh >= raumx) then xh:=xh-raumx*2;
  if (xh >= raumx) then xh:=xh-raumx*2;
  if (xh < -raumx) then xh:=xh+raumx*2;
  if (xh < -raumx) then xh:=xh+raumx*2;
  if (yh >= raumy) then yh:=yh-raumy*2;
  if (yh < -raumy) then yh:=yh+raumy*2;
  if (zh >= raumz) then zh:=zh-raumz*2;
  if (zh >= raumz) then zh:=zh-raumz*2;
  if (zh < -raumz) then zh:=zh+raumz*2;

  xxx:=xh*cy*cz -xh*sy*sx*sz -zh*cy*sx*sz -zh*sy*cz +yh*cx*sz;
  yyy:=yh*cx*cz -zh*cy*sx*cz -xh*sy*sx*cz -xh*cy*sz +zh*sy*sz ;
  zzz:=zh*cy*cx +xh*sy*cx +yh*sx;
//  zz:=zh*cy+xh*sy;
//  xxx:=xh*cy-zh*sy;
//  yyy:=yh*cx-zz*sx;
//  zzz:=zz*cx+yh*sx;

  show
end;

procedure  CalcBahn(phi: real;var q:TMovinP);
var
  rad: real;
  offs: real;
  x,y,z:real;
begin
  rad := 0.05 + 0.95 * cos(8 * phi);
  offs := sin(8 * phi) * pi * 0.125;
  x:=(sin(phi * 5 + offs) * rad + 1 / (1 + sqr(rad * 2)) * 0.25 * cos(phi * 5 + offs)) * raumx - raumx;
  y:=(1 - sqr(sqr(sqr(sqr(cos(4 * phi)))))) * (2 - phi / pi) * raumy / 2 - raumy;
  z:=(cos(phi * 5 + offs) * rad - 1 / (1 + sqr(rad * 2)) * 0.25 * sin(phi * 5 + offs)) * raumz - raumz;
  q.Init(x,y,z);
end;
{ }

procedure execute;

var p:array[1..maxstar] of TMovinP;
    q:TMovinP;
    dd,bpo:TMovinP;
    i,j,ja,n,vs,vs1,oldn:integer;
    grk,grm:system.integer;
    ix,iy:real;
    phi,sp:real;
begin
  grk:=detect;
  initgraph(grk,grm,'');
  setgraphmode(grm);
  getmidx:=getmaxx div 2;
  getmidy:=getmaxy div 2;
//  j:=1;
  for i:=1 to maxbahn  do
    begin
      phi:=(i/maxbahn )*pi*2;
      CalcBahn(phi,p[i]);
      p[i].x:=(p[i].x+raumx) - int (p[i].x/(raumx*2))*(Raumx*2);
      p[i].z:=(p[i].z+raumz) - int (p[i].z/(raumz*2))*(Raumz*2);
    end;
  for i:=maxbahn+1 to maxbahn*2  do
    begin
      p[i].init(0,0,0);
      p[i].x:=p[i-maxbahn].x;
      p[i].y:=p[i-maxbahn].y-10;
      p[i].z:=p[i-maxbahn].z;
    end;
  for i:= maxbahn*2 +1 to maxstar do
    begin
      p[i].Init(-random(raumx*2),-raumy-50,-random(raumy*2));
      p[i].x:=(p[i].x+raumx) - int (p[i].x/(raumx*2))*(Raumx*2);
//      p[i].y:=(p[i].y+raumy) - int (p[i].y/(raumy*2))*(Raumy*2);
      p[i].z:=(p[i].z+raumz) - int (p[i].z/(raumz*2))*(Raumz*2);
    end;
  n:=1;
  cx:=1;
  cy:=1;
  cz:=1;
  sx:=0;
  sy:=0;
  sz:=0;
  dwx:=1;
  dwy:=1;
  dwz:=1;
  phi:=0;
  dd.Init(0,0,0);
  bpo.init(0,0,0);
  repeat
    getmidx:=getmaxx div 2;
  getmidy:=getmaxy div 2;

    phi:= (phi+(1/maxbahn)*0.5*pi);
    phi:= phi-int(phi/2/pi)*pi*2;
    ja:=trunc(phi*maxbahn/2/pi)+1;
    sp:=phi*maxbahn/2/pi-ja;
    j:=trunc(phi*maxbahn/2/pi+1) mod maxbahn +1;
    bpo:=dd;
    calcbahn(phi,dd);
    dd.x:=dd.x-raumx;
    dd.z:=dd.z-raumz;
    dd.y:=dd.y+50;

        dwx:=dd.x-bpo.x;
        dwy:=dd.y-bpo.y;
        dwz:=dd.z-bpo.z;

        ly:=sqrt(sqr(dwx)+sqr(dwz));
        if ly <> 0 then
          begin
        cy:=-dwz/ly;
        sy:=-dwx/ly;
          end;
        lx:=sqrt(sqr(ly)+sqr(dwy));
        if lx <> 0 then
          begin
        cx:=ly/lx;
        sx:=-dwy/lx
          end;
//        cz:=cos(j/maxstar *pi*20);
//        sz:=sin(j/maxstar *pi*20);
//        vs:=vsync;{
    sleep(20);
    for i:=1 to maxstar  do
      p[i].move(dd);
  until Keypressed;
  for i:=1 to maxstar do
      p[i].done;

  restorecrtmode;
end;

end.