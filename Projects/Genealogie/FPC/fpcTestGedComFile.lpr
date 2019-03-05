program fpcTestGedComFile;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, testGedComFile;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

