program fpcTestAll;
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
    tst_AboutEx in '..\source\tests\tst_AboutEx.pas',
    tst_Actions in '..\source\tests\tst_Actions.pas',
    tst_AddPage in '..\source\tests\tst_AddPage.pas',
    tst_BarChart in '..\source\tests\tst_BarChart.pas',
    tst_BarTest2 in '..\source\tests\tst_BarTest2.pas',
    tst_BitView in '..\source\tests\tst_BitView.pas',
    tst_BitView2 in '..\source\tests\tst_BitView2.pas',
    tst_Calc32 in '..\source\tests\tst_Calc32.pas',
    tst_Calc64 in '..\source\tests\tst_Calc64.pas',
    tst_Something in '..\source\tests\tst_Something.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Delphi-Bible: Test All-Examples';
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
