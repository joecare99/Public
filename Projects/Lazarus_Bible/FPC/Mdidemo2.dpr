program Mdidemo2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_MDIDemo2MAIN in '..\Source\Mdidemo2\Frm_MDIDemo2MAIN.PAS' {MainForm}, 
  CHILD2 in '..\Source\Mdidemo2\CHILD2.PAS' {ChildForm}, 
  frm_MDIDemo2ABOUT in '..\Source\Mdidemo2\frm_MDIDemo2ABOUT.PAS' {AboutForm}, 
  Childbmp in '..\Source\Mdidemo2\Childbmp.pas' {ChildBmpForm}; 
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
{$R *.res}
begin
  Application.Initialize;
  Application.Title := 'MDI Demonstration 2'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TAboutForm, AboutForm); 
  Application.Run; 
end. 
