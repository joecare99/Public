program Calc32;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_CALC in '..\source\CALC32\Frm_CALC.PAS' {CalcForm},
  Frm_CalcABOUT in '..\source\CALC32\Frm_CalcABOUT.PAS' {AboutForm};
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

begin
Application.Initialize;
  Application.Title := 'Demo: Calc32';
  Application.CreateForm(TCalcForm, CalcForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.

