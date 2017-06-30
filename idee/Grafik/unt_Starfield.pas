unit unt_Starfield;

interface

uses graph,unt_3dpoint,sysutils{,fgrtest};


const genau=10;

      maxstar=10000;

      rz2 =0;
      AugX=0;
      Augy=0;
      AugZ=rz2;

      maxCol=255;

      ddx=0 ;
      ddy=0;
      ddz=-1;

type TMovinP=object(Tpoint)
                procedure Move;Virtual;
              end;

var dx,dy,dz,cx,cy,cz,sx,sy,sz,dwx,dwy,dwz,Lng:extended;
    phi:real;
    co:word;

procedure Execute;


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
  show
end;
{}

procedure TMovinP.move;

var xh,yh,zh,xx,yy,zz:extended;

begin
  hide;

  {*a Berechne Translation }

  xh:=(x+dx);
  yh:=(y+dy);
  zh:=(z+dz);

  xh:=(x-dx-augx);
  yh:=(y-dy-augy);
  zh:=(z-dz-augz);
  if (xh >= raumx) then xh:=xh-raumx*2;
  if (xh < -raumx) then xh:=xh+raumx*2;
  if (yh >= raumy) then yh:=yh-raumy*2;
  if (yh < -raumy) then yh:=yh+raumy*2;
  if (zh >= raumz) then zh:=zh-raumz*2;
  if (zh < -raumz) then zh:=zh+raumz*2;
  zz:=zh*cy+xh*sy;
  xxx:=xh*cy-zh*sy;
  yyy:=yh*cx-zz*sx;
  zzz:=zz*cx+yh*sx;
  show
end;
{ }
procedure Execute;

var p:array[1..maxstar] of TMovinP;

    i,j,n,vs,vs1,oldn:integer;
    grk,grm:integer;

begin
  grk:=detect;
  initgraph(grk,grm,'');
  setgraphmode(grm);
  getmidx:=getmaxx div 2;
  getmidy:=getmaxy div 2;
  for i:=1 to maxstar do
    begin
      p[i].Init(random(raumx*2)-raumx,random(raumy*2)-raumy ,random(raumz*2)-raumz )
    end;
  cx:=1;
  cy:=1;
  cz:=1;
  sx:=0;
  sy:=0;
  sz:=0;
  dx:=0;
  dy:=0;
  dz:=0;
  repeat
      getmidx:=getmaxx div 2;
      getmidy:=getmaxy div 2;
        phi:=phi+0.0001*pi;
        dx:=dx+cos(phi*11)*genau;
        dx:=dx-int(dx/(raumx*2))*(raumx*2);
        dy:=dy+sin(phi*10)*genau;
        dy:=dy-int(dy/(raumy*2))*(raumy*2);
        Dz:=dz+sin(Phi*09)*genau;
        dz:=dz-int(dz/(raumz*2))*(raumz*2);//(dz+trunc(sin(Phi*09)*genau)+raumz) mod raumz*2-raumz;

        dwx:=cos(phi*18)*2;
        dwy:=sin(phi*18)*2;
        dwz:=0;//sin(Phi*15)*2;

        lng :=sqrt(sqr(dwx)+sqr(dwy)+sqr(dwz));

        cx:=cos(sin(phi*10)*5);
        sx:=sin(sin(phi*10)*5);
        cy:=cos(cos(phi*8)*7);
        sy:=sin(cos(phi*8)*7);
        cz:=cos(sin(phi*11)*9);
        sz:=sin(sin(phi*11)*9);

//     vs:=vsync;{
    sleep(1);
    for i:=1 to maxstar do
      p[i].move;
  until Keypressed;
    for i:=1 to maxstar do
      p[i].done;
  restorecrtmode;
end;

end.