program Splashin;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_SplashinMAIN in '..\source\SPLASHIN\Frm_SplashinMAIN.pas' {MainForm}, 
  Frm_SPLASH in '..\source\SPLASHIN\Frm_SPLASH.pas' {SplashForm}; 
{$E EXE}
begin 
  Application.Initialize; 
  Application.Title := 'Splashin - Demo'; 
  SplashForm := TSplashForm.Create(Application); 
  SplashForm.Show; 
  SplashForm.Update; 
  Application.CreateForm(TMainForm, MainForm); 
  SplashForm.Close; 
  Application.Run; 
end. 
