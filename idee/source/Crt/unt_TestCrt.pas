unit unt_TestCrt;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  windows,
{$ELSE}
{$ENDIF}
  SysUtils,
  forms,
  Win32Crt;

procedure Execute;

implementation


procedure Execute;

var i:integer;
begin
  { TODO -oUser -cConsole Main : Hier Code einfügen }
  ClearConsole ;
  SetTitle('Dies ist ein Test (1)');
  TextColor(14);
  TextBackground(1);
  writeln('+-------------------------------------------------+');
  writeln('|                                                 |');
  writeln('|                                                 |');
  writeln('|                                                 |');
  writeln('|                                                 |');
  writeln('|                                                 |');
  writeln('|                                                 |');
  writeln('+-------------------------------------------------+');
  write('123'#8'456');
  Writeln;
  SetTitle('Dies ist ein Test (2)');
  for I := 0 to 300 - 1 do
     begin
       write(#13+inttostr(i)+'               ');
       sleep(10);
     end;
    SetTitle('Dies ist ein Test (3)');
  for I := 0 to 30 - 1 do
     begin
       write(#12);
       sleep(100);
     end;
  SetTitle('Dies ist ein Test (4)');

  for I := 0 to 30 - 1 do
     begin
       write(#14);
       sleep(100);
     end;
  SetTitle('Dies ist ein Test (Ende)');
  writeln;
  Writeln('Press <Enter>');
  readln
end;
end.
