program fpc_TstFileMove;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_FileMoveUnt;

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

