program Filemenu;

uses
  Forms,
  Frm_FileMenuMAIN in '..\source\Filemenu\Frm_FileMenuMAIN.PAS' {MainForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Filemenu';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

