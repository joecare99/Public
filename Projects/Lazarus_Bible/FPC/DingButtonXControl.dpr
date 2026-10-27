program DingButtonXControl;

uses
  Forms,
  Ctrl_DingButton in '..\source\DING\Ctrl_DingButton.pas',
  Frm_DingAbout in '..\source\DingX\Frm_DingAbout.pas' {DingButtonXAbout},
  Frm_DingXMain in '..\source\DingX\Frm_DingXMain.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Demo: DingButtonXControl';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
