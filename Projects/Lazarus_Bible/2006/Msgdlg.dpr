program Msgdlg;

uses
  Forms,
  Frm_MsgDlgMAIN in 'Frm_MsgDlgMAIN.PAS' {MainForm};

{$E EXE}

{$R *.RES}

begin
  Application.Title := 'Message-Display Dialogs';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
