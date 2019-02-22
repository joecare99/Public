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

{$R *.res}

begin
  Application.Scaled:=True;
Application.Initialize;
  Application.Title := 'Demo: Chargrid';
  Application.CreateForm(TfrmCharGridMain, frmCharGridMain);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
