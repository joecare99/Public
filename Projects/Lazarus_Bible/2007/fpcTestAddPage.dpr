program fpcTestAddPage;

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
  Forms,
  GuiTestRunner,
  TextTestRunner,
  tst_AddPage in '..\source\tests\tst_AddPage.pas',
  Frm_AddpageMAIN in '..\source\Addpage\Frm_AddpageMAIN.PAS';

begin
  Application.Initialize;

{$IFDEF FPC}
  Application.CreateForm(TTestRunner, TestRunner);
{$EndIF}
  Application.CreateForm(TfrmActionsMain, frmActionsMain);
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
