program Contcomp;

uses
  Forms,
  frm_ContCompMAIN in '..\CONTCOMP\frm_ContCompMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Contcomp';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
