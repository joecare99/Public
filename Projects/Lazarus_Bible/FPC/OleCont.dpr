program OleCont;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_OleContMain in '..\Source\OleCont\Frm_OleContMain.pas' {MainForm}; 
{$E EXE} 
{$R *.res}
begin 
  Application.Initialize; 
  Application.Title := 'OLE Container Demonstration'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
