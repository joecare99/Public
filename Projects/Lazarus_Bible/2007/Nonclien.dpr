program Nonclien;

uses
  Forms,
  frm_NonClientMAIN in '..\NONCLIEN\frm_NonClientMAIN.pas' {MainForm};

{$E EXE}

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Nonclient Area Message Handling';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
