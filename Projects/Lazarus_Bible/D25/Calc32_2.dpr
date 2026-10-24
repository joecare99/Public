program Calc32_2;

uses
  Forms,
  Frm_CALC2 in '..\source\Calc32\Frm_CALC2.pas' {CalcForm},
  Frm_Calc2ABOUT in '..\source\Calc32\Frm_Calc2ABOUT.pas' {AboutForm};

{$E EXE}

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Taschenrechner';
  Application.CreateForm(TCalcForm, CalcForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.

