program BarTest;

uses
  Forms,
  Frm_BartestMain in '..\Barchart\Frm_BartestMain.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: BarTest';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
