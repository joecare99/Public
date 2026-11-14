program Addpage;

uses
  Forms,
  Frm_AddpageMAIN in '..\Addpage\Frm_AddpageMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Addpage';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
