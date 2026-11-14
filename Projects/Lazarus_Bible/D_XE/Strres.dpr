program Strres;

{$R 'ERRMSG.res' '..\ERRMSG.RC'}

uses
  Forms,
  Frm_StrresMAIN in '..\STRRES\Frm_StrresMAIN.pas' {MainForm};

{$E EXE}
{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Strres - Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
