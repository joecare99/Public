program fpcTestBitView;
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
  tst_BitView in '..\source\tests\tst_BitView.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Delphi-Bible: Test BitView-Example';
{$IFDEF FPC}
  Application.Scaled:=True;
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

