program Prj_TestCrt2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ELSE}
  {$E exe}
{$ENDIF}

 {$APPTYPE CONSOLE}

uses
  {$IFDEF FPC}
  interfaces,
{$ENDIF}
  unt_testcrt2;

begin
  execute;
end.
