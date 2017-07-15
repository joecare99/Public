program MCS;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

 {$APPTYPE CONSOLE}
{$E exe}

uses
  {$IFDEF FPC}
  interfaces,
{$ENDIF}

  Unt_MCS in '..\source\Unt_MCS.pas';

begin
  Execute;
end.
