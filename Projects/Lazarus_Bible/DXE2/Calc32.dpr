program Calc32;

uses
  Forms,
  Frm_CALC in '..\source\CALC32\Frm_CALC.PAS' {CalcForm},
  Frm_CalcABOUT in '..\source\CALC32\Frm_CalcABOUT.PAS' {AboutForm},
  StrUtilsExt in '..\source\Strings\StrUtilsExt.pas';

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Calc32';
  Application.CreateForm(TfrmCalcMain, frmCalcMain);
  Application.CreateForm(TfrmCalcAbout, frmCalcAbout);
  Application.Run;
end.

