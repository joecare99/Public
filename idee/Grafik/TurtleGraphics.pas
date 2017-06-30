unit TurtleGraphics;

interface

uses graph;

Procedure Start;
Procedure turnleft(DDir:extended);
Procedure turnRight(DDir:extended);
procedure forwd(Amnt:extended);
procedure Back(Amnt:extended);
Procedure PenDown;
Procedure PenUp;
Procedure Setposition(x,y:extended);
Procedure SetHeading(DDir:extended);

const North = 0;


implementation


Var Direction,tx,ty:extended;
    PenIsDown:Boolean;

procedure Start;

var Grk,grm:integer;
begin
  InitGraph(grk,grm,bgipath);
  Direction :=0;
  tx:=0;
  ty:=0;
  PenIsDown :=true;
  setcolor(White);
end;

Procedure Setposition(x,y:extended);
begin
  moveto(trunc(x),trunc(y));
  ty:=y;
  tx:=x;
end;

procedure forwd(amnt:extended);
var X,y:extended;
begin
  X:=tx+sin(Direction*pi/180)*amnt;
  Y:=ty+cos(Direction*pi/180)*amnt;
  if PenisDown then
    lineto(trunc(x)+getmaxx div 2,-trunc(y)+getmaxy div 2)
  else
    moveto(trunc(x)+getmaxx div 2,-trunc(y)+getmaxy div 2);
  tx:=x;
  ty:=y;
end;

procedure back(amnt:extended);
var X,y:extended;
begin
  X:=tx-sin(Direction*pi/180)*amnt;
  Y:=ty-cos(Direction*pi/180)*amnt;
  if PenisDown then
    lineto(trunc(x)+getmaxx div 2,-trunc(y)+getmaxy div 2)
  else
    moveto(trunc(x)+getmaxx div 2,-trunc(y)+getmaxy div 2);
  tx:=x;
  ty:=y;
end;

Procedure Setheading(DDir:extended);
begin
  Direction := ddir ;
end;

Procedure turnleft(DDir:extended);
begin
  Direction := (direction-ddir) ;
  Direction := Direction-Int(Direction /360)*360
end;

Procedure turnRight(DDir:extended);
begin
  Direction := (direction+ddir) ;
  Direction := Direction-Int(Direction /360)*360
end;

Procedure PenDown;
begin
  PenIsDown :=true;
end;
Procedure PenUp;
begin
  PenIsDown :=false;
end;
end.
