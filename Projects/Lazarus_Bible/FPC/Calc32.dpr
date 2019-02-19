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

{$R *.res}

begin
Application.Initialize;
  Application.Title := 'Demo: Calc32';
  Application.CreateForm(TfrmCalcMain, frmCalcMain);
  Application.CreateForm(TfrmCalcAbout, frmCalcAbout);
  Application.Run;
end.

