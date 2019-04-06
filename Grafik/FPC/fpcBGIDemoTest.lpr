program fpcBGIDemoTest;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, Compatible, GuiTestRunner, tc_BGIDemo;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

