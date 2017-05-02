program Compstrm;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  frm_CompStrmMAIN in '..\source\Compstrm\frm_CompStrmMAIN.PAS' {MainForm};

{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

begin
  Application.Initialize;
  Application.Title := 'Demo: Compstrm';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
