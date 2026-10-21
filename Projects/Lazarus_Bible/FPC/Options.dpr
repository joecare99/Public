program Options;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_OptionsMain in '..\source\OPTIONS\Frm_OptionsMain.pas' {MainForm}, 
  Inidata in '..\Source\OPTIONS\..\Inidata\Inidata.pas'; 
{$E EXE} 
{$R *.res}
begin
  Application.Initialize;
  Application.Title := 'Options - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
