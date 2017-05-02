program TestCDlg;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  COLORDLG in '..\source\COLORDLG\COLORDLG.PAS' {ColorDlgForm},
  Frm_TestCdlgMAIN in '..\source\COLORDLG\Frm_TestCdlgMAIN.PAS' {MainForm};

{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

begin
  Application.Initialize;
  Application.Title := 'Demo: TestCDlg';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TColorDlgForm, ColorDlgForm);
  Application.Run;
end.
