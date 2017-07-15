program ConsoleKeyEvents;

{$mode delphi}{$H+}
 {$APPTYPE CONSOLE}
{$E EXE}
uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  windows,
  SysUtils,
  Unt_ConsoleKeyEvents in '..\source\Unt_ConsoleKeyEvents.pas';

begin
  Execute;
end.
