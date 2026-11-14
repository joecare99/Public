program Except2;

uses
  Forms,
  frm_Except2MAIN in '..\EXCEPT2\frm_Except2MAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Except2';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
