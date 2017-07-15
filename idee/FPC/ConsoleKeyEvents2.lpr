program ConsoleKeyEvents2;

{$mode delphi}{$H+}
 {$APPTYPE CONSOLE}
{$E EXE}
uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  {$IFDEF FPC}
  interfaces,
  {$ENDIF}
  Win32crt,
  unt_consoleevents2 in '..\source\unt_consoleevents2.pas', Compatible;

begin
  Execute;
end.
