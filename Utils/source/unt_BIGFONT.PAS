unit unt_BIGFONT;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses win32crt;
{$undef debug}

resourcestring
  writestr = '  Copyright'+#10#13+'by Joker 1992';

procedure getbiginit  (x,y:byte);
procedure getbigpoint(out x,y:byte;Schrift:pointer);
procedure bigwrite (x,y:byte;ch,st:string;Schrift:pointer);

implementation

type pufz=^puft;
     puft=array[0..16000] of byte;

const dir:array[1..8,0..1] of shortint =
        ((1,0),(1,-1),(0,-1),(-1,-1),(-1,0),(-1,1),(0,1),(1,1));


var xk,yk,xk0,x0,yk0,as0{,mode}:byte;
    nr:word;
    b:pufz;

const offset1=33; // Header
      offset2=512; // Index

procedure getsvec(nr:word;out di:byte);
//
var art:byte;
    offs3,offs4,offs5{,offs6}:word;

begin
   offs3:=offset1+offset2+(nr div 12)*5;
   offs4:=(nr div 3) mod 4;
   art:=nr mod 3;
   offs5:=b^[offs3+offs4]*256+b^[offs3+offs4+1];
//   offs6:=offs5;
   offs5:=offs5 shr ((3-offs4)*2);
   offs5:=offs5 and 1023;
   case art of
    0:di:= (offs5 div 100) mod 10 ;
    1:di:= (offs5 div 10)  mod 10 ;
    2:di:=  offs5          mod 10 ;
   end;
end;

//Suche Charakter
procedure gethash(nr:byte;out st:word);

begin
  st:= b^[offset1+nr*2]*256+b^[offset1+nr*2+1];
end;

function getnextxy (var xk,yk:byte;ch:char):boolean;

var
    v:byte;

begin
  getnextxy:=true;
  if nr=0 then
    begin
      gethash(ord(ch),nr);
      {$ifdef debug}
      write(ch);
      {$endif}
    end;
  case ch of
    #10:
      begin
        nr:=0;
        yk0:=yk0+12;
        getnextxy:=false;
      end;
    #13:
      begin
        nr:=0;
        xk0:=x0;
        getnextxy:=false;
      end
    else
      begin
        getsvec (nr,v);
       {$ifdef debug } write(v); {$endif}
        case v of
          0:begin //EOC
              getnextxy:=false;
              while v=0 do
                begin
                  nr:=nr+1;
                  xk0:=xk+1;
                  xk:=xk0;
                  getsvec (nr,v);
                end;
              nr:=0;
            end;
          9:begin //Goto
              getsvec(nr+1,xk);
              xk:=xk+xk0;
              getsvec(nr+2,yk);
              yk:=yk+yk0;
              nr:=nr+3;
            end
          else
            begin
              xk:=xk+dir[v,0];
              yk:=yK+dir[v,1];
              nr:=nr+1;
            end
         end {case};
      end;
   end {case};
end;

procedure getbiginit;

begin
  xk0:=x;
  x0:=x;
  yk0:=y;
  xk:=x;
  yk:=y;
  as0:=1;
  nr:=0;
end;

procedure getbigpoint;

begin
  b:=schrift;
  while (as0 <> 0) and (not getnextxy(xk,yk,writestr[as0])) do
    if as0 < length (writestr) then inc(as0)
    else as0:=0;
  if as0=0 then
    begin
      x:=0;
      y:=0;
    end
  else
    begin
      x:=xk;
      y:=yk;
    end;
end;

procedure bigwrite;

begin
  xk0:=x;
  x0:=x;
  yk0:=y;
  xk:=x;
  yk:=y;
  nr:=0;
  b:=Schrift;
  for as0:=1 to length(st) do
    while getnextxy(xk,yk,st[as0]) do
      begin
        gotoxy (xk,yk);
        write(ch[1]);
      end;
end;

end.
