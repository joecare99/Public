program DMTest;

uses
  Forms,
  Frm_DMTestMain in '..\source\DMtest\Frm_DMTestMain.pas' {MainForm},
  Frm_Module1 in '..\source\DMtest\Frm_Module1.pas' {DataModule1: TDataModule};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: DMTest';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
