program MouseExcept;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  frm_MouseExceptMain in '..\source\MouseExcept\frm_MouseExceptMain.pas' {MainForm}; 
{$R *.res}
begin 
  Application.Initialize; 
  Application.Title := 'Custom Exceptions'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
