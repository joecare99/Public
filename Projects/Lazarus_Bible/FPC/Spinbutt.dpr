program Spinbutt;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_SpinButtonMAIN in '..\source\SPINBUTT\Frm_SpinButtonMAIN.pas' {MainForm}; 
{$E EXE} 
{$R *.res}
begin 
  Application.Initialize; 
  Application.Title := 'SpinButton - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
