program Capslock;

uses
  Forms,
  Frm_CapslockMAIN in '..\source\Capslock\Frm_CapslockMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Capslock';
  Application.CreateForm(TfrmCapsLockMain, frmCapsLockMain);
  Application.Run;
end.

