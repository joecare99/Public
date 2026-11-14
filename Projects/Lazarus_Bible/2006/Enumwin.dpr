program Enumwin;

uses
  Forms,
  Frm_EnumWinMAIN in '..\ENUMWIN\Frm_EnumWinMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Enumwin';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
