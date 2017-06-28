program Prj_TestTCol01;

{$IFDEF FPC}
  {$MODE Delphi}
{$else}
  {$E exe}
{$ENDIF}

 {$APPTYPE CONSOLE}

uses
  {$IFDEF FPC}
  interfaces,
{$ENDIF}
  Forms,
  unt_TestTCol01,
  frm_TestDrawControl;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTestDrawControl,frmTestDrawControl);
  Application.Run;
end.
