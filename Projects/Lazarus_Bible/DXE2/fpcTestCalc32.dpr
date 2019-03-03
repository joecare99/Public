program fpcTestCalc32;
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
  tst_Calc32 in '..\source\tests\tst_Calc32.pas',
  Frm_CalcABOUT in '..\source\Calc32\Frm_CalcABOUT.PAS' {frmCalcAbout},
  Frm_CALC in '..\source\CALC32\Frm_CALC.PAS' {frmCalcMain},
  StrUtilsExt in '..\source\Strings\StrUtilsExt.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Delphi-Bible: Test Calc32-Example';
{$IFDEF FPC}
  Application.Scaled:=true;
  Application.CreateForm(TTestRunner, TestRunner);
{$EndIF}
{$IFDEF FPC}
  Application.Run;
{$ELSE}
  Application.CreateForm(TfrmCalcAbout, frmCalcAbout);
  Application.CreateForm(TfrmCalcMain, frmCalcMain);
  if IsConsole then
    with TextTestRunner.RunRegisteredTests do
      Free
  else
    GuiTestRunner.RunRegisteredTests;
{$EndIF}
end.

