unit unt_TMAXY;

interface

uses win32crt;

var textmaxy:byte;

procedure inittextmaxy;

implementation

procedure inittextmaxy;

begin
  gotoxy (1,24);
  textmaxy:=24;
  while (textmaxy=wherey) and (textmaxy<51) do
    begin
      inc(textmaxy);
      gotoxy (1,textmaxy);
    end;
  dec (textmaxy);
end;

begin
  inittextmaxy;
end.
