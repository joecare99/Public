program Capslock2;

uses
  Forms,
  Frm_Capslock2MAIN in '..\source\Capslock\Frm_Capslock2MAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Capslock2';
  Application.CreateForm(TfrmCapsLock2Main, frmCapsLock2Main);
  Application.Run;
end.

