program Nonclien;

uses
  Forms,
  frm_NonClientMAIN in '..\source\NONCLIEN\frm_NonClientMAIN.PAS' {MainForm};

{$E EXE}

{$R *.RES}

begin
  Application.Title := 'Nonclient Area Message Handling';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
