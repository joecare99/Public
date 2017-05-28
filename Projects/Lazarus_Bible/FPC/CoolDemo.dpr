program CoolDemo;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  DefaultTranslator,
  Forms,
  frm_CooldemoMain in '..\source\CoolDemo\frm_CooldemoMain.pas' {MainForm};

{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

begin
  Application.Initialize;
  Application.Title := 'Demo: CoolDemo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
