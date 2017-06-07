Unit Unt_TITELM3;

interface

uses graph,win32crt;

var notitle:boolean;

procedure titel(x,y,font:integer;titels:string);

Implementation

uses graphics;
var arr:pointer;
    arrs:word;

procedure init;

var
  GraphDriver, GraphMode, Error : Integer;

procedure Abort(Msg : string);
begin
  Writeln(Msg, ': ', GraphErrorMsg(GraphResult));
  writeln (^G);
  Halt(1);
end;

var i,j,k:integer;

begin

  { "Registrierung" aller Grafik-Treiber (aus DRIVERS.TPU) }
  {if RegisterBGIdriver(@CGADriverProc) < 0 then  Abort('CGA');
  if RegisterBGIdriver(@EGAVGADriverProc) < 0 then  Abort('EGA/VGA');}
  { "Registrierung" aller Zeichenstze (aus FONTS.TPU) }
{  if RegisterBGIfont(@GothicFontProc) < 0 then      Abort('Gothic');
  if RegisterBGIfont(@SansSerifFontProc) < 0 then   Abort('SansSerif');
  if RegisterBGIfont(@SmallFontProc) < 0 then       Abort('Small');
  if RegisterBGIfont(@TriplexFontProc) < 0 then     Abort('Triplex');}

  graphdriver:=3;
  graphmode:=1;
  initgraph (graphdriver,graphmode,bgipath);
  if not notitle then
    begin
      for i:=10 to 15 do
       begin
        for j:=0 to 20 do
         for k:= 0 to getmaxx div 3 do
          putpixel (k*3+(i-10) mod 3,120+j*2+(i-10+k) mod 2,i);
       end;
       arrs:=imagesize (0,120,getmaxx,160);
       getmem (arr,arrs);
       getimage (0,120,getmaxx,160,arr^);
     end;
   RestoreCrtMode;
end;

procedure titel(x,y,font:integer;titels:string);

var ho,le,i:integer;


begin
  if not notitle then
    begin
//      setvisualpage(1);
//      cleaRDEViCE;
//      setpalette (0,1);
//      setpalette (1,0);
//      setactivepage (1);
//      settextstyle (Font,0,4);
//      ho:=textheight (titels);
//      le:=textwidth (titels);
//      setactivepage(0);
//      cleaRDEViCE;
//      setcolor (1);
//      outtextxy (x+2,y+2,titels);
//      setcolor (15);
//      outtextxy (x,y,titels);
//      setactivepage (1);
//      setcolor (7);
//      line (getmaxx div 2,getmaxy div 2,x,y);
//      line (getmaxx div 2,getmaxy div 2,x+le,y);
//      line (getmaxx div 2,getmaxy div 2,x,y+ho+2);
//      line (getmaxx div 2,getmaxy div 2,x+le,y+ho+2);
//      setcolor (1);
//      setfillstyle (1,1);
//      bar (x,y,x+le+2,y+ho+2);
//      setactivepage(0);
//      putimage (0,y,arr^,3);
//      for x:= 10 to 15 do setpalette (x,0);
     for I := 0 to 60 - 1 do
        begin
         setrgbcolor(rgb(i*4,i*4,i*4));
         outtextxy(x,y,titels);
         delay (20);
//         if stopmode  then
//           exit
        end;
      delay (1000);
      for I:=30 downto 1 do
        begin
         delay (30);
         setrgbcolor(rgb(i*8,i*8,i*8));
         outtextxy(x,y,titels);
//         if stopmode  then
//           exit
        end;
//      setvisualpage (1);
    end;
end;

var i:byte;

begin
 notitle:=false;
 for i := 1 to paramcount do
   if paramstr(i)='notitle' then
     notitle:=true;
 init;
end.
