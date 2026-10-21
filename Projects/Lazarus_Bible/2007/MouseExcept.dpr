program MouseExcept;

uses
  Forms,
  frm_MouseExceptMain in '..\MouseExcept\frm_MouseExceptMain.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Custom Exceptions';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
