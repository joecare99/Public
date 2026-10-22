program Memopad;

uses
  Forms,
  Frm_MemoPadMAIN in '..\source\MEMOPAD\Frm_MemoPadMAIN.pas' {MainForm};

{$E EXE}

{$R *.RES}

begin
  Application.Title := 'Memo Pad';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

