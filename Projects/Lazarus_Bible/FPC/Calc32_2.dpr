program Calc32_2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ELSE}
  {$E EXE}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_CALC2 in '..\source\CALC32\Frm_CALC2.PAS' {CalcForm},
  Frm_Calc2ABOUT in '..\source\CALC32\Frm_Calc2ABOUT.PAS' {AboutForm};

begin
  Application.Initialize;
  Application.Title := 'Taschenrechner';
  Application.CreateForm(TfrmCalcMain2, frmCalcMain2);
  Application.CreateForm(TfrmCalcAbout2, frmCalcAbout2);
  Application.Run;
end.

