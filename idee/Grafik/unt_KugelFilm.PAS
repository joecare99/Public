unit unt_KugelFilm;

interface

uses graph,farbgr{,bgiunt};

procedure Execute;

implementation

type real=extended;


const lx=1;
      ly=-1;
      lz=1;
      l=1.732051;
      tm=6;

var grm,grd:integer;
    xf,yf:word;
    vp,ap,t:WORD;



procedure makebild(x,y,r,f:integer);

var x1,y1,xl,yl,sp:integer;
    sq,sr,z:real;

begin

   for yl:=-r to r do
   if (yl+y>=0) and
      ((yl+y) <= getmaxy) then
   begin
     sq:=yf/xf*sqrt (sqr(1.00*r)-sqr(1.00*yl));
       for xl:= -trunc (sq) to trunc (sq) do
       if (xl+x>=0) and (xl+x<=getmaxx) then
       begin
         sr:=sqr(sq*xf/yf)-sqr(xl*xf/yf);
         if sr < 0 then else
           begin
             z:=sqrt(sr);
             if (x1 -x1 div 10 * 10 =0) or (y1 -y1 div 10 * 10 =1) {false} then
               putpixel (x+xl,y+yl,10)
             else
               begin
                 sp:=trunc( maxhell *(0.5+0.5 * ((xf/yf*xl*lx)+(yl*ly)+(z*lz))/(r*l)));
                 fputpixel (x+xl,y+yl,f,sp);
               end
           end
       end
  end
end;

var x,y,r,f:integer;
    exproc,org8:pointer;

//procedure expr;
//
//begin
//  setintvec (8,org8);
//  exitproc:=exproc;
//end;

var i: integer;

procedure Execute;

begin
   grd:=0;
   initgraph (grd,grm,bgipath);
   setgraphmode(grm);
   getaspectratio (xf,yf);

   for i:=1 to 20 do
     begin

     makebild (400,
	       20*i,
	       i*5,
	       100);
     // sleep (100);
     end;
   repeat
     makebild (
        random(graph.GetMaxX),
        random(graph.GetMaxY),
        random(graph.GetMaxY div 4)+5,
        random(255));

    // sleep (100);
   until keypressed;
   restorecrtmode;
end;
end.