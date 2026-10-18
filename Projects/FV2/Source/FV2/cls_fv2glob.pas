unit cls_fv2glob;

{$mode objfpc}{$H+}

interface

uses
  cls_fv2app, cls_fv2application, cls_fv2controls, cls_fv2forms;

var
  Application: TFvApplication;
  Desktop: TForm;
  CurrentControl: TControl;

implementation

initialization
  Application := cls_fv2app.Application;

finalization
  Application := nil;
  Desktop := nil;
  CurrentControl := nil;

end.
