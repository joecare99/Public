{$APPTYPE CONSOLE} 
program PowerTest;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses unt_PowerTest in '..\source\POWER\unt_powertest.pas';

begin
  Execute;
end. 
