program Bitview2;

uses
  Forms,
  Frm_BitView2MAIN in '..\Bitview2\Frm_BitView2MAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Bitview2';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

