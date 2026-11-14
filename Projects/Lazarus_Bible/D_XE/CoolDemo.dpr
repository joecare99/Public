program CoolDemo;

uses
  Forms,
  frm_CooldemoMain in '..\source\Cooldemo\frm_CooldemoMain.pas' {frmCoolDemoMain};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: CoolDemo';
  Application.CreateForm(TfrmCoolDemoMain, frmCoolDemoMain);
  Application.Run;
end.
