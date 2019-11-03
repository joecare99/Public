program fpc_TestExpFileUnt;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner,
  testExpFile in '..\test\testExpFile.pas',
  Cmp_SEWFile in '..\source\cmp_SEWFile';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

