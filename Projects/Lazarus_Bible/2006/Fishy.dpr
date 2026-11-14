program Fishy;

uses
  Forms,
  Frm_FishyMAIN in '..\FISHY\Frm_FishyMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Fishy';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
