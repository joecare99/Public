unit Unt_TKASTEN;

interface

uses win32crt,
    tmaxy;

type RamenType=string[8];

     pufferbZT=^pufferbT;
     pufferbT =record
                 x1,y1,x2,y2:integer;
                 wx,wy:word;
                 puffer:pointer;
                 vorg:pufferbzt;
               end;
     arzt=^art;
     art=array[0..32000] of byte;

var pufferbz:pufferbzt;

const
  KeinRamen   : RamenType = '        ';
  RamenEinfach: RamenType = 'Ú¿ÀÙ³³ÄÄ';
  RamenDoppelt: RamenType = 'É»È¼ººÍÍ';

function timagesize  (x1,y1,x2,y2:integer):word;
procedure getTimage  (x1,y1,x2,y2:integer;var puffer);
procedure putTimage  (x,y:integer;var puffer);
procedure openkasten (x1,y1,x2,y2,color,bgr:integer;
                         Ramen:RamenType;
                         var abbruch:boolean);
procedure drawkasten (x1,y1,x2,y2,color,bgr:integer;
                         Ramen:RamenType);
procedure closekasten (var abbruch:boolean);

implementation

var exitpr:pointer;

function timagesize ;

begin
  timagesize:=(abs(x2-x1)+1)*(abs(y1-y2)+1)*2+2;
end;

procedure getTimage;

var x,y,z:integer;
    ar:arzt;

begin
  if x2<x1 then
    begin
      x:=x2;
      x2:=x1;
      x1:=x
    end;
  if y2<y1 then
    begin
      y:=y2;
      y2:=y1;
      y1:=y
    end;
  ar:=@puffer;
  ar^[0]:=x2-x1;
  ar^[1]:=y2-y1;
  z:=1;
  for y:=y1-1 to y2-1 do
    for x:=x1*2-2 to x2*2-1 do
      begin
        inc (z);
        ar^[z]:=getmemb800(x+y*160);
      end;
end;
                                        
procedure putTimage;

var xi,yi,z:integer;
    ar:arzt;

begin
  ar:=@puffer;
  z:=1;
  for yi:=y-1 to y+ar^[1]-1 do
    for xi:=x*2-2 to (x+ar^[0])*2-1 do
      begin
        inc (z);
        if (xi>=0) and (xi<=159) and
           (yi>=0) and (yi<=textmaxy-1) then
          setmemb800(xi+yi*160,ar^[z]);
      end;
end;

procedure openkasten;

var i,j:integer;
    p:pufferbzt;

begin
     begin
       if x2<x1 then
         begin
           i:=x2;
           x2:=x1;
           x1:=i
         end;
       if y2<y1 then
         begin
           i:=y2;
           y2:=y1;
           y1:=i
         end;
       new (p);
       p^.x1:=x1;
       p^.y1:=y1;
       p^.x2:=x2;
       p^.y2:=y2;
       with p^ do
         begin
           wx:=wherex;wy:=wherey;
           vorg:=pufferbz;
           pufferbz:=p;
           getmem(puffer,timagesize(x1,y1,x2,y2));
           gettimage(x1,y1,x2,y2,puffer^);
//           window(x1,y1,x2,y2);
           textbackground(bgr);
           textcolor (color);
//           clrscr;
           for i:=y1 +1 to y2-1 do begin
             setmemb800((x1-1)*2+(i-1)*160,ord(ramen[5]));
             setmemb800((x1-1)*2+(i-1)*160+1,textattr);
             setmemb800((x2-1)*2+(i-1)*160,ord(ramen[6]));
             setmemb800((x2-1)*2+(i-1)*160+1,textattr);
             for j:=x1 +1 to x2-1 do
               begin
                setmemb800((j-1)*2+(i-1)*160,32);
                setmemb800((j-1)*2+(i-1)*160+1,textattr);
               end;
            end;
           for i:=x1 +1 to x2-1 do begin
             setmemb800((i-1)*2+(y1-1)*160,ord(ramen[7]));
                setmemb800((i-1)*2+(y1-1)*160+1,textattr);
             setmemb800((i-1)*2+(y2-1)*160,ord(ramen[8]));
                setmemb800((i-1)*2+(y2-1)*160+1,textattr);
            end;
           for i:=1 to 4 do
             begin
              setmemb800((x1-1+(x2-x1)*((i-1) mod 2))*2+
                        (y1-1+ (y2-y1)*((i-1)  div 2))*160,ord(ramen[i]));
              setmemb800((x1-1+(x2-x1)*((i-1) mod 2))*2+
                        (y1-1+ (y2-y1)*((i-1)  div 2))*160+1,textattr);
             end;
//           window (1,1,80,textmaxy);

         end;
    end;
end;

procedure drawkasten;

var i:integer;
    p:pufferbzt;

begin
     begin
       if x2<x1 then
         begin
           i:=x2;
           x2:=x1;
           x1:=i
         end;
       if y2<y1 then
         begin
           i:=y2;
           y2:=y1;
           y1:=i
         end;
         begin
//          window(x1,y1,x2,y2);
           textbackground(bgr);
           textcolor (color);
           clrscr;
           for i:=y1 +1 to y2-1 do begin
             setmemb800((x1-1)*2+(i-1)*160,ord(ramen[5]));
             setmemb800((x2-1)*2+(i-1)*160,ord(ramen[6]));
            end;
           for i:=x1 +1 to x2-1 do begin
             setmemb800((i-1)*2+(y1-1)*160,ord(ramen[7]));
             setmemb800((i-1)*2+(y2-1)*160,ord(ramen[8]));
            end;
           for i:=1 to 4 do
              setmemb800((x1-1+(x2-x1)*((i-1) mod 2))*2+
                        (y1-1+ (y2-y1)*((i-1)  div 2))*160,ord(ramen[i]));
//           window (1,1,80,textmaxy);

         end;
    end;
end;

procedure closekasten;

var p:pufferbzt;

begin
   if pufferbz=nil then begin abbruch:=true;exit end;
   abbruch:=false;
   p:=pufferbz;
   with pufferbz^ do
     begin
//       window (1,1,80,textmaxy);
       gotoxy (wx,wy);
       putTimage (x1,y1,puffer^);
       freemem (puffer,timagesize(x1,y1,x2,y2));
       pufferbz:=vorg;
       dispose(p);
  
     end;
end;

{$F+}
procedure exitp;

var ab:boolean;

begin
  ab:=false;
  repeat
   delay(100);
   closekasten (ab);
  until ab;
  exitproc:=exitpr;
end;
{$F-}

begin
  pufferbz:=nil;
  exitpr:=exitproc;
  exitproc:=addr(exitp);
end.
