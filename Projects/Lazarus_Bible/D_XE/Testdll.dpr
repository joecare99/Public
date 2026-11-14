program Testdll;

uses
  Forms,
  Frm_TestDLLMAIN in '..\source\COLORDLL\Frm_TestDLLMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Testdll';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
