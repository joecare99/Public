program fpcTestAsteroidsTypes;
{

  Delphi DUnit-Testprojekt
  -------------------------
  Dieses Projekt enthält das DUnit-Test-Framework und die GUI/Konsolen-Test-Runner.
  Fügen Sie den Bedingungen in den Projektoptionen "CONSOLE_TESTRUNNER" hinzu,
  um den Konsolen-Test-Runner zu verwenden.  Ansonsten wird standardmäßig der
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

