unit Unt_TestKasten;

interface

procedure Execute;

implementation

uses win32crt,
     Unt_TKASTEN,
     unt_tmaxy;

procedure Execute;
var abbruch:boolean;
    ch:char;
begin
// textmode (259);
//  fullscreen;
//  readkey;
  repeat
   openkasten (random(79)+1,random (textmaxy)+1,random(79)+1,random (textmaxy)+1,random(8)+8,random(8),RamenDoppelt,abbruch);
   delay(10);
   if keypressed then
     ch:=#27;

  until (ch=#27) or abbruch;
  repeat
    closekasten (abbruch);
    delay (40);
  until abbruch;
  readln
  end;
end.
