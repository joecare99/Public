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
  Frm_MDIDemo2MAIN in '..\source\Mdidemo2\Frm_MDIDemo2MAIN.pas' {MainForm}, 
  CHILD2 in '..\source\Mdidemo2\CHILD2.pas' {ChildForm}, 
  frm_MDIDemo2ABOUT in '..\source\Mdidemo2\frm_MDIDemo2ABOUT.pas' {AboutForm}, 
  Childbmp in '..\source\Mdidemo2\Childbmp.pas' {ChildBmpForm}; 
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
