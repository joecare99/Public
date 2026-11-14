program Msgdlg;

uses
  Forms,
  Frm_MsgDlgMAIN in '..\MSGDLG\Frm_MsgDlgMAIN.pas' {MainForm};

{$E EXE}

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Message-Display Dialogs';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
