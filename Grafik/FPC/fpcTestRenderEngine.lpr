program fpcTestRenderEngine;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms,sysutils, GuiTestRunner, tst_RenderEngine, cls_RenderSimpleObjects,
  cls_RenderBase, cls_RenderCamera, cls_RenderEngine, cls_RenderColor,
  cls_RenderBoundary, cls_RenderLightSource, unt_RenderMath;

{$R *.res}

function GetApplName: String;
begin
  result:='RenderEngine';
end;

function GetVendName: String;
begin
  result:='JCSoft';
end;

begin
  Application.Initialize;
  OnGetApplicationName:=@GetApplName;
  OnGetVendorName:=@GetVendName;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

