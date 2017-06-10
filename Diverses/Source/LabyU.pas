unit LabyU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,unt_Lists, ComCtrls,  StdCtrls;

type
  TLbyRoomItm=class

  end;

  TLbyActiveItm=class(TLbyRoomItm)

  end;

  TLbyPassiveItm=class(TLbyRoomItm)

  end;


  TLbyRoom=class
    private

    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

  TLbyCreature=class(TLbyActiveItm)
  end;

  TLbyPlayer=class(TLbyCreature)
  end;

  TLaby = class(TForm)
    btnClose: TButton;
    LabImage: TImage;
    ig: TImage;
    Timer1: TTimer;
    btnOK: TButton;
    Function NewPlayer:TLbyPlayer;
    Function GetRoom(ZLbyPlayer:TLbyPlayer):TLbyRoomItm;
    procedure btnCloseClick(Sender: TObject);
    procedure CreateLaby;
    procedure Timer1Timer(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure TermML(Sender: TObject);
  private

    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    HFont:TFont;
    HText:String;

  end;

var
  Laby: TLaby;

implementation

uses ProgressBarU,unt_Point2d;

type
  TMakeLaby = class(TThread)
  public
    test: integer;
  private
    { Private-Deklarationen }
    function getIpPixel(x,y:integer):Tcolor;
    function getLBPixel(x,y:integer):Tcolor;
    Procedure PutLBPixel(x,y:integer;value:Tcolor);

    property igpixel[x,y:integer]:Tcolor read getippixel;
    property LBpixel[x,y:integer]:Tcolor read getlbpixel write putlbpixel;
  protected
    procedure Execute; override;
  end;

  TStack=class(TList)
       Point:TPoint;
       Constructor Init(ZP:TPoint);
       destructor done;Virtual;
    end;


{$R *.DFM}

var makelaby:Tmakelaby;
    ZStack:TStack;

procedure TLaby.btnCloseClick(Sender: TObject);
begin
   hide;
   if assigned(makelaby) then
     makelaby.DoTerminate
end;

Function TLaby.NewPlayer;

begin
  NewPlayer:=nil;
end;

Function Tlaby.GetRoom;

begin
   GetRoom:=nil;
end;


Constructor TStack.init;

begin
  point:=Tpoint.init (zp);
  create;
end;

Destructor TStack.done ;

begin
  Point.free
end;

procedure myFloodfill(im:Timage;p:TPoint;c:Tcolor;o_r,u_l:TPoint;mode:byte);

var ZStack,zp:TStack;
    ocol,tc:TColor;
    i,j,k:integer;
    flag:boolean;

begin
  k:=0;
  ocol:=im.canvas.pixels[p.x,p.y];
  if ocol <> c then
  with im.canvas do
    begin
      zStack:=Tstack.init(p);
      while zstack <> nil do
        begin
          flag:=true;
          if pixels[zstack.point.x,zstack.point.y]=ocol then
            begin
              if mode>0 then
                begin
                  j:=1;
                  while (flag) and (j<=mode) do
                    begin
                    i:=1;
                  while (flag) and (i<= 12) do
                    begin
                      tc:=pixels[zstack.point.x+(dir12[i].x*j) div 2,zstack.point.y+(dir12[i].y*j)div 2];
                      flag:=flag and ((tc = c) or (tc = ocol));
                      inc(i);
                    end;
                      inc (j)
                    end;
                end;
              if flag then
              begin
              pixels[zstack.point.x,zstack.point.y]:=c;
              k:=k mod 50 +1;
      //        if k = 1 then im.update;
          for i := 1 to 4 do
            begin
              if (zstack.point.x+dir4[i].x>=O_R.x) and
                 (zstack.point.x+dir4[i].x<=u_l.x) and
                 (zstack.point.y+dir4[i].y>=O_R.y) and
                 (zstack.point.y+dir4[i].y<=u_l.y) and
                 (pixels[zstack.point.x+dir4[i].x,
                 zstack.point.y+dir4[i].y]=ocol)  then
                begin
                  zp:=tstack.init(zstack.point);
                  zp.point.add(dir4[i]);
                  ZStack.append(Zp);
                end;
            end;
            end;
          end;
          zp:=ZStack;
          zstack:=TStack(Zstack.getnext);
          zp.done ;
        end;
    end;
    im.update;
end;

{Wichtig: Objektmethoden und -eigenschaften in der VCL können in Methoden
verwendet werden, die mit Synchronize aufgerufen werden, z.B.:

      Synchronize(UpdateCaption);

  wobei UpdateCaption so aussehen könnte:

    procedure MakeLaby.UpdateCaption;
    begin
      Form1.Caption := 'Aktualisiert im Thread';
    end; }

{ MakeLaby }


const Farbtab:array[0..5] of Tcolor =
    (clwhite, {Freier Bereich }
     clyellow,{Waarerecht }
     clgreen, {senkrecht}
     clred,   {One Way }
     clblue,  {eingang zu schwarz}
     clblack); {Innen im weg}

      Uebergtab:array[0..5,0..5] of byte =
        ((1,1,1,4,4,9),
         (1,1,1,1,4,9),
         (1,1,1,1,4,9),
         (9,1,1,1,4,9),
         (9,9,9,9,1,1),
         (9,9,9,9,9,1));


Procedure TLaby.CreateLaby;


var ZP:TStack;
    i,j:integer;
 {   ocol:Tcolor;}

    dir:Shortint;
    Point,dp,tp,hp:TPoint;

    flag:boolean;



const HFont = {'Arial Rounded MT Bold'}'Brush Script MT kursiv';
      HFSize = 48;
      HFColor = clYellow;
      HFSColor= clBlack;

var Hiddentext:string;


procedure makeSpecialWay;

var i,j,k:integer;
    tc:tcolor;
    tp,dp,point:Tpoint;

begin
  tp:=Tpoint.init(0,0);
  dp:=Tpoint.init(0,0);
  point:=Tpoint.init(0,0);
  Hiddentext:='Joe Care';
  with ig.Canvas do
    begin
      for i:= 0 to ig.Width-1 do
        for j:= 0 to ig.height-1 do
          pixels[i,j]:=clwhite;
      ig.Visible :=true;
      font.size:=HFSize;
      font.Name:=HFont;
      font.Color :=HFColor;
      dp.x:=TextWidth (hiddentext)+20;
      dp.y:=TextHeight (hiddentext);
      point.x:=(ig.width-dp.x) div 2 ;
      point.y:=(((ig.height-dp.y) div 2)or 1)-1;
      copyMode:=cmMergeCopy;
      font.color:=HFColor;
       textout (point.x+10,point.y,Hiddentext);

       tp.init(point);
       tp.add(dp);
       myFloodFill (ig,point,clred,point,tp,0);
       {*Suche und beseitige 'Inseln'}
       {*Parameter: Bereich,Farbe,richtung }
       for j:=tp.x downto point.x do
         for i:=point.y to tp.y do
           if pixels[j,i] = clwhite then
             begin
               hp.x:=j;
               hp.y:=i;
               flag:=true;
               k:=1;
               while (k <= 4) do
                 begin
                   tc:=pixels[hp.x+dir8[k*2].x,hp.y+dir8[k*2].y];
                   if tc = clred then
                     begin
                       flag:=false;
                       pixels[hp.x+dir4[k].x,hp.y+dir4[k].y] := clwhite;
                       pixels[hp.x,hp.y] := clwhite;
                     end;
                   if tc = clwhite then
                       pixels[hp.x+dir4[k].x,hp.y+dir4[k].y] := clwhite;
                   inc (k);
                 end;
               if flag then begin
               while pixels[hp.x,hp.y] <> clred do
                 begin
                   pixels[hp.x,hp.y]:=clwhite;
                   hp.x:=hp.x+dir8[1].x;
                   hp.y:=hp.y+dir8[1].y;
                 end;
               hp.x:=hp.x-dir8[1].x;
               hp.y:=hp.y-dir8[1].y;
               myfloodfill(ig,hp,clred,point,tp,0);
               end
               else
                 myfloodfill(ig,hp,clred,point,tp,0);

             end;
       tp.y:=tp.y-1;
       myfloodfill(ig,point,clwhite,point,tp,0);
       tp.y:=tp.y+1;
       for i:=tp.y downto point.y do
         for j:=point.x to tp.x do
           if pixels[j,i] = hfcolor then
             begin
               hp.x:=j;
               hp.y:=i;
               flag:=true;
               k:=1;
               while flag and (k <= 4) do
                 begin
                   if pixels[hp.x+dir8[k*2].x,hp.y+dir8[k*2].y] = clred then
                     begin
                       flag:=false;
                       pixels[hp.x+dir4[k].x,hp.y+dir4[k].y] := clred;
                       pixels[hp.x,hp.y] := clred;
                     end;
                   inc (k);
                 end;
               if flag then
                 begin
               while pixels[hp.x,hp.y] <> clred do
                 begin
                   pixels[hp.x,hp.y]:=hfcolor;
                   hp.x:=hp.x+dir8[3].x;
                   hp.y:=hp.y+dir8[3].y;
                 end;
               hp.x:=hp.x+dir8[7].x;
               hp.y:=hp.y+dir8[7].y;
               myfloodfill(ig,hp,clred,point,tp,0);
               end;
             end;
       myfloodfill(ig,tp,hfscolor,point,tp,0);
       hp.copy(tp);
       tp.x:=ig.width;
       tp.y:=ig.height;
       myfloodfill(ig,point,clred,dir4[0],tp,6);
       for i:=1 to 6 do
         begin
           pixels[point.x-i,hp.y]:=farbtab[5];
           pixels[hp.x+i,hp.y]:=farbtab[5];
         end;
       pixels[point.x,hp.y+1]:=farbtab[4];
       tp.copy(dp);
       for j:= 0 to 5 do
         begin
       for i := 0 to ig.height do
         if pixels[j-2+ig.width div 2,i]=clred then
           pixels[j-2+ig.width div 2,i]:=clwhite;
       end;

 
       ig.visible:=false;
     end;
   dp.done;
   point.done;
end;

procedure RandomizeWalls(dp:TPoint;ddir:shortint);

var hp:Tpoint;
    k:integer;
    ocol,tc:TColor;

begin
  with labimage.canvas do
  begin
  hp:=Tpoint.init(dp);
  k:=0;
  point.copy(dp);
  while (pixels[dp.x,dp.y]<>clBlack)
    and (dp.x > 0)
    and (dp.y > 0)
    and (dp.x < LabImage.Width)
    and (dp.y < LabImage.Height)
    and (k<2) do
    begin
      ocol:=ig.canvas.pixels[dp.x,dp.y];
      j:=0;
      repeat
        if (ig.canvas.pixels[dp.x div 2,dp.y div 2]=HFColor) then
          dir := (dir or 1) and 3
        else
          dir :=((dir+2+random(3)) mod 4)+1;

        if dir = ddir then
          dir :=((dir+1) mod 4)+1;
        inc (j);
        tc:=ig.canvas.pixels[
        (dp.x div 2)+dir4[dir].x,
        (dp.y div 2)+dir4[dir].y];
      until (j>20) or ((tc<>HFsColor) and ((tc=clwhite) or (ocol=clred)));
    if j>20 then
      begin
        inc(k);
        dp.copy(hp);
        dir:=ddir;
        ddir:=((ddir+1) mod 4)+1;
        if ig.canvas.pixels[
          (dp.x div 2)+dir4[dir].x,
          (dp.y div 2)+dir4[dir].y]=HFsColor then inc(k);
      end
    else
      begin

      pixels[dp.x,dp.y]:=clblue;
      Zp:=tstack.init(dp);
      ZStack:=TStack(zp.add(ZStack));
      dp.add(dir4[dir]);
      pixels[dp.x,dp.y]:=clblue;
      dp.add(dir4[dir]);
      end;
  end;
  dp.x:=labimage.Width;
  dp.y:=labimage.height;
  if k=2 then
    myfloodfill(labimage,hp,clwhite,dir4[0],dp,0)
  else
    myfloodfill(labimage,hp,clblack,dir4[0],dp,0);
  end;
end;


begin
   labimage.width:=labimage.Width or 1;
   labimage.height:=labimage.height or 1;
   LabImage.canvas.rectangle(0,0,LabImage.width,LabImage.height);
   point:=Tpoint.init(dir4[0]);
   dp:=Tpoint.init(dir4[0]);
   hp:=TPoint.init(dir4[0]);
   randomize;
   ZStack:=nil;
   ig.height:=labimage.Height div 2+1;
   ig.width:=labimage.Width div 2 +1;
   with LabImage.canvas do
     begin
{*e Ausgang und Eingang }
       pixels[0,(LabImage.height div 2)or 1]:=clWhite;
       pixels[LabImage.width-1,(LabImage.height div 2)or 1]:=clWhite;
      {*e Special, Weg als Bild oder Schriftzug }
      labimage.visible:=false;
      MakeSpecialWay;
      labimage.visible:=true;
      {*e zeichne Labyrinth}
       for i := 1 to 9 do
         begin
           dp.x:=((LabImage.width *i) div 10) and -2;
           dp.y:=0;
           zp:=tstack.init(dp);
           zstack:=TStack(zp.append(Zstack));
           dp.x:=(LabImage.width-dp.x) and -2;
           dp.y:=labimage.height-1;
           zp:=TStack.init(dp);
           zstack:=TStack(zp.append(Zstack));
           dp.y:=((LabImage.height *i) div 10) and -2;
           dp.x:=labimage.width-1;
           zp:=tstack.init(dp);
           zstack:=tStack(zp.append(Zstack));
           dp.y:=(LabImage.height-dp.y) and -2;
           dp.x:=0;
           zp:=tstack.init(dp);
           zstack:=tStack(zp.append(Zstack));
         end;
       MakeLaby:= TMakeLaby.Create(false);

//       point.x:=(LabImage.width-tp.x) div 2 ;
//       point.y:=(((LabImage.height-tp.y) div 2)or 1)-1;

     end;
end;

function TMakelaby.getIpPixel;

begin
  getippixel:=laby.ig.canvas.pixels[x ,y]
end;

function TMakelaby.getLBPixel;

begin
  getlbpixel:=laby.labimage.canvas.pixels[x ,y]
end;

procedure TMakelaby.PutLBPixel;

begin
  laby.labimage.canvas.pixels[x ,y]:=value
end;

procedure TMakeLaby.Execute;

var flag,adds:boolean;
    Point,dp:TPoint;
    odir,dir,ddir:shortint;
    tc,tfc,nc,nfc,i:TColor;
    zp:tStack;

function getcolorFkt(c:TColor):byte;

var i:byte;

begin

  i:=5;
  while (i>0) and (farbtab[i]<>c) do dec(i);
  getColorFkt:=i;
end;


begin
  { Plazieren Sie den Thread-Quelltext hier }
 while ZStack <> nil do
 begin
   point:=tpoint.init(ZStack.point);
   dp:=tpoint.init(0,0);
   flag:=lbpixel[point.x,point.y] <>clblack;
   odir:=0;
   dir:=0;
   while not flag do
     begin
       tc:= igpixel[point.x div 2,point.y div 2];
       tfc:=getcolorfkt(tc);
       case tfc of
         1:begin
           dir := (random(2)*2)+1;
           ddir:=1
         end;
         2:begin
           dir := (random(2)*2)+2;
           ddir:=1
         end;
         0:begin
           ddir:= random(2)*2;
           if (odir=0) and (dir <> 0) then
             odir:=(dir+1) mod 4 +1;
           dir := random(4)+1;
           end
       else
         begin
           ddir:= random(2)*2;
           dir := random(4)+1;
          end
       end;

       dp.copy(point);
       flag:= true;
       i:=0;
       adds:=true;
         while flag and (i<8) do
           begin
             dp.copy(point);
             dir :=(dir +ddir) mod 4 +1;
             if dir = odir then
               dir :=(dir +ddir) mod 4 +1;
             nc:=igpixel[
           (dp.x div 2)+dir4[dir].x,
           (dp.y div 2)+dir4[dir].y];
             nfc:=getcolorfkt(nc);
             flag := uebergtab[tfc,nfc]>i;
             dp.add(dir4[dir]);
             flag := flag or (lbpixel[dp.x,dp.y]<>clwhite);
             dp.add(dir4[dir]);
             flag := flag or (lbpixel[dp.x,dp.y]<>clwhite);
             i:=i+1;
           end;
         if not flag then
           begin
             dp.copy(point);
             if (i <4) and adds then
               begin
                 Zp:=tstack.init(dp);
                 ZStack:=tStack(zp.add(ZStack));
                 adds:=false;
               end;
             dp.add(dir4[dir]);
             lbpixel[dp.x,dp.y]:=0;
             dp.add(dir4[dir]);
             lbpixel[dp.x,dp.y]:=0;
             Zp:=Tstack.init(dp);
             ZStack:=TStack(zp.add(ZStack));
             point.copy(dp);
             if adds then ;
           end;
     end;
   zp:=ZStack;
   ZStack:=tstack(ZStack.getnext);
   zp.done;
   point.done;
 end;
end;


procedure TLaby.Timer1Timer(Sender: TObject);
begin
   labimage.Update;
   ig.update;
end;

procedure TLaby.TermML(Sender: TObject);
begin
  btnok.Enabled := true;
end;

procedure TLaby.btnOKClick(Sender: TObject);
begin
  hide;
end;

end.

