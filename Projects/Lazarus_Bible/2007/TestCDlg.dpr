program TestCDlg;

uses
  Forms,
  COLORDLG in '..\COLORDLG\COLORDLG.pas' {ColorDlgForm},
  Frm_TestCdlgMAIN in '..\COLORDLG\Frm_TestCdlgMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: TestCDlg';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TColorDlgForm, ColorDlgForm);
  Application.Run;
end.
