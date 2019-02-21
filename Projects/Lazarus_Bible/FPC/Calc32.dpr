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
  Frm_CALC in '..\source\CALC32\Frm_CALC.PAS' {CalcForm},
  Frm_CalcABOUT in '..\source\CALC32\Frm_CalcABOUT.PAS' {AboutForm};
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

