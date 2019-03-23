program fpcTest3dPoint;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner,
  testcase3dPoint in '..\test\testcase3dPoint.pas',
  unt_Point3d in '..\source\unt_Point3d.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

