program Filemenu;

uses
  Forms,
  Frm_FileMenuMAIN in '..\FILEMENU\Frm_FileMenuMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Filemenu';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

