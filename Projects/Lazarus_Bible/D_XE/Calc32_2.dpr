program Calc32_2;

uses
  Forms,
  Frm_CALC2 in '..\source\CALC32\Frm_CALC2.PAS' {CalcForm},
  Frm_Calc2ABOUT in '..\source\CALC32\Frm_Calc2ABOUT.PAS' {AboutForm};

{$E EXE}

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Taschenrechner';
  Application.CreateForm(TfrmCalcMain2, frmCalcMain2);
  Application.CreateForm(TfrmCalcAbout2, frmCalcAbout2);
  Application.Run;
end.

