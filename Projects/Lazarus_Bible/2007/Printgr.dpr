program Printgr;

uses
  Forms,
  Frm_PrintgrMAIN in '..\PRINTGR\Frm_PrintgrMAIN.pas' {MainForm};

{$E EXE}
{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Printgr - Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
