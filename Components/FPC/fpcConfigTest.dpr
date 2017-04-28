program fpcConfigTest;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{

  Delphi DUnit-Testprojekt
  -------------------------
  Dieses Projekt enthält das DUnit-Test-Framework und die GUI/Konsolen-Test-Runner.
  Zum Verwenden des Konsolen-Test-Runners fügen Sie den konditinalen Definitionen  
  in den Projektoptionen "CONSOLE_TESTRUNNER" hinzu. Ansonsten wird standardmäßig 
  der GUI-Test-Runner verwendet.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
{$IFnDEF FPC}
  TestFramework, TextTestRunner,
{$ELSE}
  Interfaces,FPCUnitTestRunner,
{$ENDIF}
  Forms,
  GUITestRunner,
  TestUnt_Config in '..\TestUnt_Config.pas',
  Unt_Config in '..\source\Unt_Config.pas';

{$R *.res}

begin
  Application.Initialize;
  {$IFnDEF FPC}
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
  {$else}
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
  {$ENDIF}
end.

