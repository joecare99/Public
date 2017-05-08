program Contcomp;

uses
  Forms,
  frm_ContCompMAIN in '..\source\ContComp\frm_ContCompMAIN.PAS' {MainForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Contcomp';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
