program fpcTestGrueStew;

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
  tst_GrueStew in '..\source\GrueStew\tst_GrueStew.pas',
  unt_GrueStewBase in '..\source\GrueStew\unt_GrueStewBase.pas',
  cls_GrueStewEng in '..\source\GrueStew\cls_GrueStewEng.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Unit-Test: Grew Stew Engine';
{$IFDEF FPC}
  Application.CreateForm(TTestRunner, TestRunner);
{$EndIF}
// Evtl. user Forms to Test
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

