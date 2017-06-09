unit Point2d;

interface

type TPoint=class
        x,y:longint;
        constructor init(nx,ny:longint);overload;
        constructor init(ZVect:TPoint);overload;
        destructor done;virtual;
        Function Copy(Vect:TPoint):PPoint;virtual;
        Function add(vect:TPoint):PPoint;virtual;
        Function Mult(vect:TPoint):PPoint;virtual;
        Function SMult(vect:TPoint):longint;virtual;

     end;

const dir4:array[0..4] of TPoint =
   ((x:0;Y:0),(x:1;Y:0),(x:0;Y:1),(x:-1;Y:0),(x:0;Y:-1));

const dir8:array[0..8] of TPoint =
   ((x: 0;Y: 0),
    (x: 1;Y: 0),
    (x: 1;Y: 1),
    (x: 0;Y: 1),
    (x:-1;Y: 1),
    (x:-1;Y: 0),
    (x:-1;Y:-1),
    (x: 0;Y:-1),
    (x: 1;Y:-1));

const dir12:array[0..12] of TPoint =
   ((x: 0;Y: 0),
    (x: 2;Y: 0),
    (x: 2;Y: 1),
    (x: 1;Y: 2),
    (x: 0;Y: 2),
    (x:-1;Y: 2),
    (x:-2;Y: 1),
    (x:-2;Y: 0),
    (x:-2;Y:-1),
    (x:-1;Y:-2),
    (x: 0;Y:-2),
    (x: 1;Y:-2),
    (x: 2;Y:-1));

    Way12:array[0..12,1..3] of TPoint =
      (((x: 0;y: 0),(x: 0;y: 0),(x: 0;y: 0)),
       ((x: 1;y: 0),(x: 2;y: 0),(x: 2;y: 0)),
       ((x: 1;y: 0),(x: 1;y: 1),(x: 2;y: 1)),
       ((x: 0;y: 1),(x: 1;y: 1),(x: 1;y: 2)),
       ((x: 0;y: 1),(x: 0;y: 2),(x: 0;y: 2)),
       ((x: 0;y: 1),(x:-1;y: 1),(x:-1;y: 2)),
       ((x:-1;y: 0),(x:-1;y: 1),(x:-2;y: 1)),
       ((x:-1;y: 0),(x:-2;y: 0),(x:-2;y: 0)),
       ((x:-1;y: 0),(x:-1;y:-1),(x:-2;y:-1)),
       ((x: 0;y:-1),(x:-1;y:-1),(x:-1;y:-2)),
       ((x: 0;y:-1),(x: 0;y:-2),(x: 0;y:-2)),
       ((x: 0;y:-1),(x: 1;y:-1),(x: 1;y:-2)),
       ((x: 1;y: 0),(x: 1;y:-1),(x: 2;y:-1)));

const dir16:array[0..16] of TPoint =
   ((x: 0;Y: 0),
    (x: 3;Y: 0),
    (x: 3;Y: 1),
    (x: 2;Y: 2),
    (x: 1;Y: 3),
    (x: 0;Y: 3),
    (x:-1;Y: 3),
    (x:-2;Y: 2),
    (x:-3;Y: 1),
    (x:-3;Y:-0),
    (x:-3;Y:-1),
    (x:-2;Y:-2),
    (x:-1;Y:-3),
    (x:-0;Y:-3),
    (x: 1;Y:-3),
    (x: 2;Y:-2),
    (x: 3;Y:-1));


function getdir(radius:integer;direction:integer):PPoint;

implementation

Constructor TPoint.init;

begin
  x:=nx;
  y:=ny;
end;

constructor TPoint.init2;

begin
  x:=ZVect^.x;
  y:=ZVect^.y;
end;

destructor TPoint.Done;

begin
end;

function TPoint.Copy ;

begin
  x:=ZVect^.x;
  y:=ZVect^.y;
  copy:=@self
end;

function TPoint.Add;

begin
  x:=x+ZVect^.x;
  y:=y+ZVect^.y;
  add:=@self
end;

function TPoint.Mult;

var nx,ny:integer;

begin
  nx:=x*ZVect^.x-y*ZVect^.y;
  ny:=x*ZVect^.y+y*ZVect^.x;
  x:=nx;
  y:=ny;
  Mult:=@self
end;

function TPoint.Smult;

begin
  smult:=x*ZVect^.x+y*ZVect^.y;
end;

var Sqrt2:extended;

function getdir;

var imax:longint;

var hp:TPoint;
    nr:integer;

begin
   imax:=radius*6;
   if (round(radius*sqrt2) mod 2) =0 then imax:=imax+4;
   nr:=direction mod (imax div 2);
   nr:=nr mod (imax div 4);
   if nr > imax div 8 then nr := (imax div 8)-nr;
   if direction = 0 then getdir:=@dir4[0]
   else
   case ((direction-1)*8 div imax) of
     0:begin
         hp.init(round(sqrt(radius*radius-nr*nr)),nr);
       end;
     1:begin
         hp.init(nr,round(sqrt(radius*radius-nr*nr)));
       end;
     2:begin
         hp.init(-nr,round(sqrt(radius*radius-nr*nr)));
       end;
     3:begin
         hp.init(-round(sqrt(radius*radius-nr*nr)),nr);
       end;
     4:begin
         hp.init(-round(sqrt(radius*radius-nr*nr)),-nr);
       end;
     5:begin
         hp.init(-nr,-round(sqrt(radius*radius-nr*nr)));
       end;
     6:begin
         hp.init(nr,-round(sqrt(radius*radius-nr*nr)));
       end;
     7:begin
         hp.init(round(sqrt(radius*radius-nr*nr)),-nr);
       end;
    end;
    getdir:=@hp;
end;

begin
  sqrt2:=sqrt(2.0);
end.

