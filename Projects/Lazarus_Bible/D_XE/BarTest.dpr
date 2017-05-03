program BarTest;

uses
  Forms,
  Frm_BartestMain in '..\source\BARCHART\Frm_BartestMain.pas' {frmBarChartMain};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: BarTest';
  Application.CreateForm(TfrmBarChartMain, frmBarChartMain);
  Application.Run;
end.
