program Calc32; 
uses 
  Forms, 
  Frm_CALC in '..\Source\CALC32\Frm_CALC.PAS' {CalcForm}, 
  Frm_CalcABOUT in '..\Source\CALC32\Frm_CalcABOUT.PAS' {AboutForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Calc32'; 
  Application.CreateForm(TCalcForm, CalcForm); 
  Application.CreateForm(TAboutForm, AboutForm); 
  Application.Run; 
end. 
