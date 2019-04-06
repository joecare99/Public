unit Unt_Grafic;

interface

Procedure Execute;

implementation

uses
  graph ,
  int_Graph ;

const
  maxeck=4;
  maxpol=20;

 type
  picdatatype = array [1..maxpol,1..maxeck] of integer;
  farbdatatype= array [1..maxpol] of integer;

 const
       daX : picdatatype =((160, 60, 90,160),
                           (161,261,231,161),
                           (160,160,101, 91),
                           (161,161,220,230),
                           (160,160,140,140),
                           (161,161,180,180),
                           ( 60, 90,139,139),
                           (261,231,181,181),
                           ( 60, 60,160,160),
                           (261,261,161,161),
                           (140, 60, 90,160),
                           (181,261,231,161),
                           (160,160,101, 91),
                           (161,161,220,230),
                           (160,160,140,140),
                           (161,161,180,180),
                           ( 60, 90,139,139),
                           (261,231,181,181),
                           ( 60, 60,160,160),
                           (261,261,161,161));

       daY : picdatatype =((  0, 50, 50, 15),
                           (  0, 50, 50, 15),
                           ( 16, 30, 60, 50),
                           ( 16, 30, 60, 50),
                           ( 31,100, 90, 41),
                           ( 31,100, 90, 41),
                           ( 51, 51, 74, 89),
                           ( 51, 51, 74, 89),
                           ( 52, 67,116,100),
                           ( 52, 67,116,100),
                           (089,134,134,099),
                           (089,134,134,099),
                           (100,114,144,134),
                           (100,114,144,134),
                           (115,184,174,125),
                           (115,184,174,125),
                           (135,135,159,174),
                           (135,135,159,174),
                           (136,151,200,184),
                           (136,151,200,184));

       fa :     farbdatatype
                     = (3,3,2,1,1,2,3,3,1,2,3,3,2,1,1,2,3,3,1,2);
       fmap:array[0..3]of integer = (black,10,green,yellow);
procedure polynom (x1,y1,x2,y2,x3,y3,x4,y4,f:integer);

var
 punktfarbe,xm,ym:integer;

begin;
 xm:=round((x1+x2+x3+x4)*0.25);
 ym:=round((y1+y2+y3+y4)*0.25);
  begin;
   draw(x1,y1,x2,y2,3);
   draw(x2,y2,x3,y3,3);
   draw(x3,y3,x4,y4,3);
   draw(x4,y4,x1,y1,3);
  end;
 punktfarbe:=getdotcolor(xm,ym);
 if punktfarbe = 3 then exit;
 SetFillStyle(solidfill,f);
 floodfill (xm,ym,3);
  begin;
   draw(x1,y1,x2,y2,f);
   draw(x2,y2,x3,y3,f);
   draw(x3,y3,x4,y4,f);
   draw(x4,y4,x1,y1,f);
  end;
end;

procedure fuehreaus;

var
 poly,
 x1,x2,x3,x4,
 y1,y2,y3,y4,
 farbe:integer;
 dtaX,dtaY:picdatatype;
 fat :farbdatatype;

begin;
 dtaX:=daX;
 dtaY:=daY;
 fat :=fa;
 graphcolormode;
 palette (0);
  for poly := 1 to maxpol do
   begin;
    x1:= dtaX[poly,1]*2;
    x2:= dtaX[poly,2]*2;
    x3:= dtaX[poly,3]*2;
    x4:= dtaX[poly,4]*2;
    y1:= dtaY[poly,1]*2;
    y2:= dtaY[poly,2]*2;
    y3:= dtaY[poly,3]*2;
    y4:= dtaY[poly,4]*2;
    farbe:= fmap[fat[poly]];
    polynom (X1,Y1,X2,Y2,X3,Y3,X4,Y4,farbe);
  end;
end;

procedure save;
var
 picvar :array[0..16004] of byte;

begin;
 repeat;
 until keypressed;
end;

Procedure Execute;
begin;
 fuehreaus;
 save;
end;

end.
