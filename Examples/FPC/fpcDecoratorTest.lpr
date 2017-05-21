program fpcDecoratorTest;

{$mode objfpc}{$H+}

uses
//  consoletestrunner, fpcunit,
  Interfaces, Forms, GuiTestRunner, fpcunittestrunner,
  speedtests;

//var  lApp: TTestRunner;{$R *.res}

begin
    Application.Initialize;
    Application.CreateForm(TGuiTestRunner, TestRunner);
    Application.Run;
end.

