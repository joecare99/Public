program Calc32;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms, SysUtils,
  Frm_CALC in '..\source\Calc32\view\Frm_CALC.pas' {CalcForm},
  Frm_CalcABOUT in '..\source\Calc32\Frm_CalcABOUT.pas' {AboutForm},
  Calc32ViewModel in '..\source\Calc32\viewmodel\Calc32ViewModel.pas',
  CalculatorModel in '..\source\Calc32\model\CalculatorModel.pas';
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

{$R *.res}
function AppVendorName: String;
begin
  Result := 'JC-Soft'
end;

function AppApplicationName: String;
begin
  Result := 'Calc32';
end;

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.Title := 'Demo: Calc32';
  OnGetVendorName:=AppVendorName;
  OnGetApplicationName:=AppApplicationName;
  Application.CreateForm(TfrmCalcMain, frmCalcMain);
  Application.CreateForm(TfrmCalcAbout, frmCalcAbout);
  Application.Run;
end.

