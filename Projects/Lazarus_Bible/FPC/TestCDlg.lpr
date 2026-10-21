program TestCDlg;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  COLORDLG,
  Frm_TestCdlgMAIN;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: TestCDlg';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TColorDlgForm, ColorDlgForm);
  Application.Run;
end.
