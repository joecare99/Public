program BarTest2;

uses
  Forms,
  Frm_BartestMain2 in '..\source\BARCHART\Frm_BartestMain2.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Demo: BarChart-Componente';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
