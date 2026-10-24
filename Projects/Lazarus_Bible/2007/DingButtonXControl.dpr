library DingButtonXControl;

uses
  ComServ,
  DingButtonXControl_TLB in '..\DingX\DingButtonXControl_TLB.pas',
  DingButtonImpl1 in '..\DingX\DingButtonImpl1.pas' {DingButtonX: CoClass},
  About1 in '..\About1.pas' {DingButtonXAbout},
  Ctrl_DingButton in '..\..\DING\Ctrl_DingButton.pas';

{$E ocx}

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
