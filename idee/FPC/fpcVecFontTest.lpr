program fpcVecFontTest;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, testVectFont, cls_VecFont;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

