program CoolDemo;

uses
  Forms,
  frm_CooldemoMain in '..\source\CoolDemo\frm_CooldemoMain.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: CoolDemo';
  Application.CreateForm(TfrmCoolDemoMain, frmCoolDemoMain);
  Application.Run;
end.
