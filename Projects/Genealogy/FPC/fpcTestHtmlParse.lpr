program fpcTestHtmlParse;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, FrameViewer09, GuiTestRunner, tst_HtmlParse1, tst_Filter,
  tst_h2gStep2, cls_h2gStep2, tst_GedComHelper2, unt_TestFBData,
  Unt_GNameHandler, unt_GenTestBase, cls_GedComHelper;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

