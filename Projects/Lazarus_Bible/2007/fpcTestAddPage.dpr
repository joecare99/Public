program fpcTestAddPage;

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
  Forms,
  GuiTestRunner,
  TextTestRunner,
  tst_AddPage in '..\source\tests\tst_AddPage.pas',
  Frm_AddpageMAIN in '..\source\Addpage\Frm_AddpageMAIN.pas';

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
