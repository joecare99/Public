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
  Frm_CALC2 in '..\source\Calc32\Frm_CALC2.pas' {CalcForm},
  Frm_Calc2ABOUT in '..\source\Calc32\Frm_Calc2ABOUT.pas' {AboutForm};

begin
  Application.Initialize;
  Application.Title := 'Taschenrechner';
  Application.CreateForm(TfrmCalcMain2, frmCalcMain2);
  Application.CreateForm(TfrmCalcAbout2, frmCalcAbout2);
  Application.Run;
end.

