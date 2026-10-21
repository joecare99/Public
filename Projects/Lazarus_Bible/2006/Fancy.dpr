program Fancy;

uses
  Forms,
  Frm_FancyMAIN in '..\FANCY\Frm_FancyMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Fancy';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

