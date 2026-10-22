program OleWord2;

uses
  Forms,
  Frm_OLEWord2Main in '..\OleWord2\Frm_OLEWord2Main.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: OleWord2';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
