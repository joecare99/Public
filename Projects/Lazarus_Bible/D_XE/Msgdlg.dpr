program Msgdlg;

uses
  Forms,
  Frm_MsgDlgMAIN in '..\source\MSGDLG\Frm_MsgDlgMAIN.pas' {MainForm};

{$E EXE}

{$R *.RES}

begin
  Application.Title := 'Message-Display Dialogs';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
