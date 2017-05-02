program Calc32_2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_CALC2 in '..\source\CALC32\Frm_CALC2.PAS' {CalcForm},
  Frm_Calc2ABOUT in '..\source\CALC32\Frm_Calc2ABOUT.PAS' {AboutForm};
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Taschenrechner';
  Application.CreateForm(TCalcForm, CalcForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.

