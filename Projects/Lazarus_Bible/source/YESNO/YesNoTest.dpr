program YesNoTest;

uses
  Forms,
  Frm_YesNoMAIN in 'Frm_YesNoMAIN.PAS' {MainForm},
  YESNO in 'YESNO.PAS' {YesNoDlg};

{$R *.RES}

begin
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TYesNoDlg, YesNoDlg);
  Application.Run;
end.

