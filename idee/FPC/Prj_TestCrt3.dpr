program Prj_TestCrt3;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

 {$APPTYPE CONSOLE}
{$E exe}

uses
  {$IFDEF FPC}
  interfaces,
{$ENDIF}
  unt_testcrt3;

{$R *.res}

begin
  execute;
end.
