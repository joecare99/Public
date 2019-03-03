program Calc32;

uses
  Forms,
  Frm_CalcABOUT in '..\source\CALC32\Frm_CalcABOUT.PAS' {AboutForm},
  Frm_CALC64 in '..\source\Calc32\Frm_CALC64.PAS',
  StrUtilsExt in '..\source\Strings\StrUtilsExt.pas';

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Calc64';
  Application.CreateForm(TfrmCalc64Main, frmCalc64Main);
  Application.CreateForm(TfrmCalcAbout, frmCalcAbout);
  Application.Run;
end.

