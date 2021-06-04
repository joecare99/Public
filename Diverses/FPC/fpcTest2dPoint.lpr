program fpcTest2dPoint;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner,
  testcase2dPoint in '..\test\testcase2dPoint.pas',
  unt_Point2d in '..\source\Labyrinth\unt_Point2d.pas' ;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

