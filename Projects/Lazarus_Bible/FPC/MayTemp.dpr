program MayTemp;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_MayMain in '..\Source\MayTemp\Frm_MayMain.pas' {MainForm}; 

{$E EXE}
{$R *.res}
begin 
  Application.Initialize;
  Application.Title := 'Key West Temperatures May 1871 - 1996';
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
