program fpcTestX_Src;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, tcscanner, GuiTestRunner, TestPassRc, TestCShScanner,
  CShScanner, tst_CShScanner, unt_CShTestData, CShTree, tst_CShBaseParser,
  CShParser;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

