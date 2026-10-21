program Calc64;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms, Sysutils,
  Frm_CALC64 in '..\source\Calc32\Frm_CALC64.pas' {CalcForm},
  Frm_CalcABOUT in '..\source\Calc32\Frm_CalcABOUT.pas' {AboutForm};
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
  Result := 'Calc64';
end;

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.Title := 'Demo: Calc64';
  OnGetVendorName:=AppVendorName;
  OnGetApplicationName:=AppApplicationName;
  Application.CreateForm(TfrmCalcMain, frmCalcMain);
  Application.CreateForm(TfrmCalcAbout, frmCalcAbout);
  Application.Run;
end.

