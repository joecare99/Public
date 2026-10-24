program Keyinfo;

uses
  Forms,
  Frm_KeyInfoMAIN in '..\KEYINFO\Frm_KeyInfoMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Keyinfo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

