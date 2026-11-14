program fpcTestAboutEx;

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
  tst_AboutEx in '..\source\tests\tst_AboutEx.pas',
  frm_About in '..\source\AboutEx\Frm_ABOUT.pas' {frmAbout},
  Frm_AboutExMAIN in '..\source\AboutEx\Frm_AboutExMAIN.pas' {frmAboutMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Delphi-Bible: Test About-Dialog Example';
{$IFDEF FPC}
  Application.CreateForm(TTestRunner, TestRunner);
{$EndIF}
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfrmAboutMain, frmAboutMain);
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

