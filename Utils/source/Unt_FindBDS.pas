unit Unt_FindBDS;

interface

Procedure Execute;

implementation

uses
  windows,
  SysUtils;

Procedure Execute;

var wtitle:String;
begin
  readln(wtitle);
  writeln(inttostr(FindWindow(NIL,pchar(Wtitle))));
  readln;
end;
end.
