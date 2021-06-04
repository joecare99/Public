program fpcTestX_Src;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, tcscanner, GuiTestRunner, TestPassRc, tcstatements,
  tcPasWriteStatements, tctypeparser, TestCShScanner, CShScanner,
  tst_CShScanner, unt_CShTestData, CShTree, tst_CShBaseParser, CShParser,
  tst_CShStatements, tst_CShParseStatementsDirect, unt_TestCShStatements,
  tst_CShParseExpressions;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

