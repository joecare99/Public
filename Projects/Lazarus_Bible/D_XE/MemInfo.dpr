program MemInfo;

uses
  Forms,
  frm_MemInfoMain in '..\source\MemInfo\frm_MemInfoMain.pas' {MainForm};

{$E EXE}

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Program Memory Information';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
