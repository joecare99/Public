program Readme;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_ReadMeMain in '..\Source\README\Frm_ReadMeMain.PAS' {MainForm}; 
{$E EXE} 
{$R *.res}
begin 
  Application.Initialize; 
  Application.Title := 'Readme - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
