program PrjTest3dPoint;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, fpcunittestrunner,
  testcasef3dPoint in '..\test\testcasef3dPoint.pas',
  unt_Pointf3d in '..\source\unt_Pointf3d.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

