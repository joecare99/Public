program Memopad;

uses
  Forms,
  Frm_MemoPadMAIN in '..\MEMOPAD\Frm_MemoPadMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Memopad';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

