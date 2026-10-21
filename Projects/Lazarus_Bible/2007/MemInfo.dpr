program MemInfo;

uses
  Forms,
  frm_MemInfoMain in '..\MemInfo\frm_MemInfoMain.pas' {MainForm};

{$E EXE}

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Program Memory Information';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
