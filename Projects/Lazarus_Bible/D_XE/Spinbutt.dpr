program Spinbutt;

uses
  Forms,
  Frm_SpinButtonMAIN in '..\SPINBUTT\Frm_SpinButtonMAIN.pas' {MainForm};

{$E EXE}
{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'SpinButton - Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

