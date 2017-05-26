library DingButtonXControl;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
  ComServ,
  DingButtonXControl_TLB in '..\source\DingX\DingButtonXControl_TLB.pas',
  DingButtonImpl1 in '..\source\DingX\DingButtonImpl1.pas' {DingButtonX: CoClass},
  Frm_DingAbout in '..\source\DingX\Frm_DingAbout.pas' {DingButtonXAbout};

{$E ocx}

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}
{$R *.res}

begin
end.
