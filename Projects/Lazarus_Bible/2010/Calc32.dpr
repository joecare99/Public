program Calc32; 
uses 
  Forms, 
  Frm_CALC in '..\source\Calc32\Frm_CALC.pas' {CalcForm}, 
  Frm_CalcABOUT in '..\source\Calc32\Frm_CalcABOUT.pas' {AboutForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Calc32'; 
  Application.CreateForm(TCalcForm, CalcForm); 
  Application.CreateForm(TAboutForm, AboutForm); 
  Application.Run; 
end. 
