program Chargrid;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_CharGridMAIN in '..\source\CHARGRID\Frm_CharGridMAIN.PAS' {MainForm},
  Frm_CharGridABOUT in '..\source\CHARGRID\Frm_CharGridABOUT.PAS' {AboutForm};
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

begin
Application.Initialize;
  Application.Title := 'Demo: Chargrid';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
