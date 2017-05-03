program Printgr;

uses
  Forms,
  Frm_PrintgrMAIN in '..\source\PRINTGR\Frm_PrintgrMAIN.PAS' {MainForm};

{$E EXE}
{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Printgr - Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
