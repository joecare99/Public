program Prj_TestCrt;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

 {$APPTYPE CONSOLE}
{$E exe}

uses
  {$IFDEF FPC}
  interfaces,
{$ENDIF}
  unt_TestCrt in '..\grafik\unt_TestCrt.pas';

begin
  execute;
end.
