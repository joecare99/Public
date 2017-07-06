program Mdidemo;

{$IFDEF FPC}
  {$MODE Delphi}
{$ELSE}
  {$E EXE}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_MDIDemoMAIN in '..\Source\MDIDEMO\Frm_MDIDemoMAIN.PAS' {MainForm}, 
  frm_MDIChild1 {ChildForm},
  Frm_MDIDemoABOUT in '..\Source\MDIDEMO\Frm_MDIDemoABOUT.PAS' {AboutForm}; 
{$R *.res}
begin
  Application.Initialize;
  Application.Title := 'MDI Demonstration'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TAboutForm, AboutForm); 
  Application.Run; 
end. 
