library DingButtonXControl;
uses
  ComServ,
  DingButtonXControl_TLB in '..\Source\DingX\DingButtonXControl_TLB.pas',
  DingButtonImpl1 in '..\Source\DingX\DingButtonImpl1.pas' {DingButtonX: CoClass},
  Frm_DingAbout in '..\Source\DingX\Frm_DingAbout.pas' {DingButtonXAbout},
  Ctrl_DingButton in '..\Source\Ding\Ctrl_DingButton.pas';

{$E ocx}
exports 
  DllGetClassObject, 
  DllCanUnloadNow, 
  DllRegisterServer, 
  DllUnregisterServer; 
{$R *.TLB}
{$R *.RES} 
{$LIBSUFFIX '140'}

begin
end. 
