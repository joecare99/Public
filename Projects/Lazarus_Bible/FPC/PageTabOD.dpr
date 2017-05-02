program PageTabOD;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_PagetabODMain in '..\Source\PageTabOD\Frm_PagetabODMain.pas' {MainForm}; 
{$E EXE} 
{$R *.res}
begin 
  Application.Initialize; 
  Application.Title := 'PageTab-OwnerDraw Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
