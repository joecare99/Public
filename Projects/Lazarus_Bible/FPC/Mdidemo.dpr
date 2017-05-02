program Mdidemo;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_MDIDemoMAIN in '..\Source\MDIDEMO\Frm_MDIDemoMAIN.PAS' {MainForm}, 
  CHILD1 in '..\Source\MDIDEMO\CHILD1.PAS' {ChildForm}, 
  Frm_MDIDemoABOUT in '..\Source\MDIDEMO\Frm_MDIDemoABOUT.PAS' {AboutForm}; 
{$E EXE} 
{$R *.res}
begin
  Application.Initialize;
  Application.Title := 'MDI Demonstration'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TAboutForm, AboutForm); 
  Application.Run; 
end. 
