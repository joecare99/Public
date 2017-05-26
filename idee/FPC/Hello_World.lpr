program Hello_World;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ELSE}
{$E EXE}
{$ENDIF}
 {$APPTYPE CONSOLE}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, Unt_Hello_World in '..\source\unt_Hello_World.pas';

begin
  Execute;
end.

