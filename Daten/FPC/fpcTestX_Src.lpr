program fpcTestX_Src;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, TestPassRc, PasWrite, TestCShScanner;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

