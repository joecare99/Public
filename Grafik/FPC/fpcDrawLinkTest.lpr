program fpcDrawLinkTest;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tc_DrawLink;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

