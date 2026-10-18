program VirtualDesktop;

{$mode objfpc}{$H+}

uses
  Interfaces,
  Forms,
  DesktopForm;

begin
  RequireDerivedFormResource := False;
  Application.Initialize;
  Application.CreateForm(TDesktopForm, MainDesktopForm);
  Application.Run;
end.
