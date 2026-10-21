program WinesChart;

uses
  Forms,
  frm_WinesChartMain in '..\WinesChart\Frm_WinesChartMain.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: WinesChart';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
