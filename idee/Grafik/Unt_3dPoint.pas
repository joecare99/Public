unit Unt_3dPoint;

interface

uses graph;

const RaumX=8000;
      Raumy=8000;
      RaumZ=8000;

      maxcol=255;

type TPoint=object
                x,y,z:extended;
            protected
                xxx,yyy,zzz:real;
                skx,sky:integer;
                skxo,skyo:integer;
            public
                constructor Init(kx,ky,kz:real);
                destructor done;Virtual;
                procedure Show;virtual;
                procedure Hide;Virtual;
//                procedure Move;Virtual;abstract;
              end;

     TmPoint=object(tPoint)
            protected
            public
    function plus(summant: TPoint): TMPoint;
    function Minus(minuent: TPoint): TMPoint;
    function SMult(skalar: extended): TMPoint;
    function VMult(multiplikator: TPoint): extended;
    function XMult(multiplikator: TPoint): TMPoint;
    function aplus(summant: TPoint): TMPoint;
            end;

var getmidx,getmidy:word;
    zoom, ausl:extended;
implementation

constructor TPoint.Init;

begin
  x := kx  ;
  y := ky  ;
  z := kz  ;
  skx:=-2;

end;

destructor TPoint.done;

begin
end;

procedure TPoint.Show;

var c:integer;

begin
  c :=128;
//  putpixel (trunc((x+raumx*1.5)/raumx*60),trunc((z+raumz*1.5)/raumz*60),c*$10000+c*$100+c);
   if (zzz <-1 ) and (zzz > -raumz*ausl) then
     begin
       skx:=trunc((xxx/(zzz*zoom)*getmidy))+getmidx;
       sky:=trunc((yyy/(zzz*zoom)*getmidy))+getmidy;
//       skx:=trunc(xxx/(zzz*0.6));
//       sky:=trunc(yyy/(zzz*0.6));
       if (sky > 0) and (sky < getmaxy) and
          (skx > 0) and (skx < getmaxx)  then
         begin
       c:=maxcol-trunc(abs(zzz) / (raumz*ausl / (maxcol-1)));
       putpixel (skx,sky,c*$10000+c*$100+c);
       putpixel (trunc((x+raumx*1.5)/raumx*60),trunc((z+raumz*1.5)/raumz*60),c*$10000+c*$100+c);
       putpixel (getmaxx-trunc((x+raumx*1.5)/raumx*60),trunc((-Y+raumy*1)/raumy*60),c*$10000+c*$100+c);
//       if c > 100 then
          begin
           putpixel (skx+1,sky,c*$10000+c*$100+c);
           putpixel (skx,sky+1,c*$10000+c*$100+c);
           putpixel (skx+1,sky+1,c*$10000+c*$100+c);
       if c > 150 then
          begin
           putpixel (skx+2,sky,c*$10000+c*$100+c);
           putpixel (skx,sky+2,c*$10000+c*$100+c);
           putpixel (skx-1,sky,c*$10000+c*$100+c);
           putpixel (skx,sky-1,c*$10000+c*$100+c);
         end
         end
        end
   else
     begin
     skx:=-2;
   end
     end
   else
     begin
     skx:=-2;
   end;
end;

procedure TPoint.hide;

begin
  if skxo <> -2 then
    begin
      putpixel (trunc((x+raumx*1.5)/raumx*60),trunc((z+raumz*1.5)/raumz*60),0);
      putpixel (getmaxx-trunc((x+raumx*1.5)/raumx*60),trunc((-Y+raumy*1)/raumy*60),0);
      putpixel (skxo,skyo,0);
      putpixel (skxo+1,skyo,0);
      putpixel (skxo,skyo+1,0);
      putpixel (skxo+1,skyo+1,0);
           putpixel (skxo+2,skyo,0);
           putpixel (skxo,skyo+2,0);
           putpixel (skxo-1,skyo,0);
           putpixel (skxo,skyo-1,0);
    end;
  skxo:=skx;
  skyo:=sky;
end;

function TmPoint.aplus(summant: TPoint): TMPoint;
begin
  x:=abs(summant.x)+x;
  y:=abs(summant.y)+y;
  z:=abs(summant.z)+z;
  tmpoint(result):=self;
end;

function TmPoint.Minus(minuent: TPoint): TMPoint;
begin
  x:=x-minuent.x;
  y:=y-minuent.y;
  z:=z-minuent.z;
//  tmpoint(result):=self;
end;

function TmPoint.plus(summant: TPoint): TMPoint;
begin
  x:=summant.x+x;
  y:=summant.y+y;
  z:=summant.z+z;
//  result:=self
end;

function TmPoint.SMult(skalar: extended): TMPoint;
begin
  x:=skalar*x;
  y:=skalar*y;
  z:=skalar*z;
//  result:=self;
end;

function TmPoint.VMult(multiplikator: TPoint): extended;
begin
  result:=x*multiplikator.x+y*multiplikator.y+z*multiplikator.z   ;
end;

function TmPoint.XMult(multiplikator: TPoint): TMPoint;
var xn,yn:extended;
begin
  xn:=multiplikator.y*z-multiplikator.z*y;
  yn:=multiplikator.z*x-multiplikator.x*z;
  z:=multiplikator.x*y-multiplikator.y*x;
  x:=xn;
  y:=yn;
//  tmpoint(result):=self;
end;

initialization
    zoom:=0.4;
    ausl:=0.9;
end.
