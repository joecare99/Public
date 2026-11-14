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
  Frm_ReadMeMain in '..\source\README\view\Frm_ReadMeMain.pas' {MainForm},
  ReadMeDocument in '..\source\README\model\ReadMeDocument.pas',
  ReadMeViewModel in '..\source\README\viewmodel\ReadMeViewModel.pas'; 
{$E EXE} 
{$R *.res}
begin 
  Application.Initialize; 
  Application.Title := 'Readme - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
