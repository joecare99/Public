program TestCDlg;

uses
  Forms,
  COLORDLG in '..\source\COLORDLG\COLORDLG.PAS' {ColorDlgForm},
  Frm_TestCdlgMAIN in '..\source\COLORDLG\Frm_TestCdlgMAIN.PAS' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: TestCDlg';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TColorDlgForm, ColorDlgForm);
  Application.Run;
end.
