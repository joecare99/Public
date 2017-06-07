unit Unt_SSHUT;


 interface
 {$o+}
 {$f+}

 const cmStartScrnShut=30000;
       maxstar=150;
       maxexpl=7;

 var ScreenShutactive:boolean;

 Procedure ScreenShut(mode:string);

 implementation

 {$R '..\Utils\scribe.res' '..\Utils\scribe.rc'}

 uses win32crt,
   unt_BIGFONT,
   classes,
  Windows;

 var shptz,destz:pointer;
     sm:boolean;
     ScreenWidth,
     ScreenHeight:byte;
     zae:word;
     scribevec:array[0..2000] of byte;

 Procedure ScreenShut(mode:string);

 type shpt=record
             x,y:byte;
             big:boolean;
           end;
      shpz=^shpa;
      shpa=array[0..maxStar] of shpt;
      destr=^desa;
      desa=array[0..maxexpl] of shpt;

 var s:shpz;
     d:destr;
     i:byte;

 const Z:array[0..maxexpl] of char=('ú','ù','','þ','*','','°',' ');
       C:array[0..maxexpl] of byte=( 3 , 3 , 7 , 15, 15, 15, 4 , 3 );

  begin
    case mode[1] of
      'A':
        begin
          shptz:=new (shpz);
          destz:=new (destr);
          sm:=true;
          zae:=0;
          ScreenWidth:=80;
          gotoxy (1,39);
          if wherey =39 then
            screenheight:=40
          else
            screenheight:=25;
          gotoxy (1,1);
          fillchar (shptz^,sizeof(shpa),0);
          fillchar (destz^,sizeof(desa),0);
          textcolor(c[0]);
          textbackground(0);
          Screenshutactive:=true;
          clrscr;
        end;
      'R' :
        begin
          s:=shptz;
          d:=destz;
          s^[0].y:=s^[0].x;
          s^[0].x:=(s^[0].x mod MaxStar) + 1;
          i:=s^[0].x;
          if s^[i].big then
            move(s^[i],d^[0],2)
          else
            begin
              if s^[i].x <> 0 then
                begin
                  gotoxy (s^[i].x,s^[i].y);
                  write(z[maxexpl]);
                end;
            end;
              case sm of
              true:begin
                s^[i].x:=random(ScreenWidth)+1;
                s^[i].y:=random(ScreenHeight-1)+1;
                s^[i].big:=random <0.3;
                inc(zae);
                if zae > 500 then
                 begin
                  sm:=false;
                  getbiginit(2,2);
                 end
              end;
              false:begin
                getbigpoint(s^[i].x,s^[i].y,@scribevec);
                s^[i].big:=true;
                if (s^[i].x=0) then
                  begin
                    s^[i].x:=random(ScreenWidth)+1;
                    s^[i].y:=random(ScreenHeight-1)+1;
                    s^[i].big:=random <0.3;
                    sm:=true;
                    zae:=0;
                  end;
                end
              end;
          gotoxy (s^[i].x,s^[i].y);
          textcolor (c[0]);
          write(z[0]{$ifdef debug},'(',s^[i].x,',',s^[i].y,')'{$endif});
          for i:= maxexpl downto 1 do
            begin
              if d^[i].x<>0 then
                begin
                  textcolor(c[i]);
                  gotoxy (d^[i].x,d^[i].y);
                  write(z[i]);
                end;
              move (d^[i-1],d^[i],2);
            end;
          d^[0].x:=0;
        end;
      'D'    :
        begin
          Screenshutactive:=false;
          freemem(shptz,sizeof(shpz));
          freemem(destz,sizeof(destr));
          clrscr;
        end
    end;
  end;

var
    Stream:TStream;

begin
  if FindResource(hInstance, 'SCRIBE', RT_RCDATA) <> 0 then
  begin // Ist die Ressource verfügbar
      Stream := TResourceStream.Create(hInstance, 'SCRIBE', RT_RCDATA); // Stream erstellen
    try
      Stream.ReadBuffer(scribevec,Stream.Size);
    finally
      Stream.free;
    end;
  end;
  Screenshutactive:=false;
end.