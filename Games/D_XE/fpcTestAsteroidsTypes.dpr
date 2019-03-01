program fpcTestAsteroidsTypes;
{

  Delphi DUnit-Testprojekt
  -------------------------
  Dieses Projekt enth�lt das DUnit-Test-Framework und die GUI/Konsolen-Test-Runner.
  F�gen Sie den Bedingungen in den Projektoptionen "CONSOLE_TESTRUNNER" hinzu,
  um den Konsolen-Test-Runner zu verwenden.  Ansonsten wird standardm��ig der
  GUI-Test-Runner verwendet.

}

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ELSE}
{$E EXE}
{$EndIF}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
{$IFDEF FPC}
  Interfaces,
{$EndIF}
  Forms,
  GuiTestRunner,
  TextTestRunner,
  TestAsteroTypes in '..\Source\asteroids\TestAsteroTypes.pas',
  uTypes in '..\Source\asteroids\uTypes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Unit-Test: Asteroids-Types';
 {$IFDEF FPC}
  Application.CreateForm(TTestRunner, TestRunner);
{$EndIF}

{$IFDEF FPC}
  Application.Run;
{$ELSE}
  if IsConsole then
    with TextTestRunner.RunRegisteredTests do
      Free
  else
    GuiTestRunner.RunRegisteredTests;
{$EndIF}
end.

