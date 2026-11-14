program Enumfon;

uses
  Forms,
  Frm_EnumFonMAIN in '..\ENUMFON\Frm_EnumFonMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Enumfon';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
