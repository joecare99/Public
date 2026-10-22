program Msgdlg;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_MsgDlgMAIN in '..\source\MSGDLG\Frm_MsgDlgMAIN.pas' {MainForm}; 
{$E EXE} 
{$R *.res}
begin
  Application.Initialize;
  Application.Title := 'Message-Display Dialogs'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
