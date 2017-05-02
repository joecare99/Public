program PicDialogs;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_PicDialogsMain in '..\Source\PicDialogs\Frm_PicDialogsMain.pas' {MainForm}; 
{$E EXE} 
{$R *.res}
begin 
  Application.Initialize; 
  Application.Title := 'PicDialogs - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
