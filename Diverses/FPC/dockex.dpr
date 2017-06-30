program DockEx;

uses
  Forms,
  Graphics,
  SysUtils,
  uMain in 'uMain.pas' {MainForm},
  uDockForm in 'uDockForm.pas' {DockableForm},
  uConjoinHost in 'uConjoinHost.pas' {ConjoinDockHost},
  uTabHost in 'uTabHost.pas' {TabDockHost};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
